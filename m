Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:64900 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3BPBYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 20:24:11 -0500
Received: by mail-ee0-f43.google.com with SMTP id c50so2065692eek.2
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2013 17:24:09 -0800 (PST)
Subject: [RFC/RFT] p54: do automatic device restart
Cc: linux-wireless@vger.kernel.org
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 16 Feb 2013 02:24:05 +0100
To: andrew@wasielewski.co.uk
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201302160224.05518.chunkeey@googlemail.com> (sfid-20130216_022416_750431_FA9E278E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, when the device stalled because the
firmware crashed [which in turn could be caused
by the driver] the user had to reload the driver
or replug the device manually.

With this patch, the driver will now try to re-
start the device on its own, when the outgoing
queue has reached its threshold of 32 queued
frames or firmware commands.
---

Andrew,

so far I was able to get a stable connection
with p54pci even if I let it crash at 20Hz.
I didn't had much luck with isl3887 though
[although that's not surprising given that
we can't/don't know how to stop it when it
crashed].

I'm hoping I can finish the crash-on-purpose
control knob tomorrow afternoon. Do you have
debugfs [CONFIG_MAC80211_DEBUGFS] enabled in
your kernel/compat-wireless config, or do
need some assistance with that?

Regards,
	Christian
---
 drivers/net/wireless/p54/main.c   |   67 +++++++++++++++++++++++++++++++------
 drivers/net/wireless/p54/p54.h    |    5 +++
 drivers/net/wireless/p54/p54pci.c |   23 ++++++++++++-
 drivers/net/wireless/p54/p54pci.h |    1 +
 drivers/net/wireless/p54/p54spi.c |    6 ++++
 drivers/net/wireless/p54/p54usb.c |   19 ++++++-----
 drivers/net/wireless/p54/txrx.c   |   20 ++++++-----
 7 files changed, 112 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index aadda99..fa6df63 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -201,17 +201,16 @@ out:
 	return err;
 }
 
-static void p54_stop(struct ieee80211_hw *dev)
+static void __p54_stop(struct p54_common *priv)
 {
-	struct p54_common *priv = dev->priv;
 	int i;
 
-	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
+	ieee80211_stop_queues(priv->hw);
 	priv->softled_state = 0;
 	cancel_delayed_work_sync(&priv->work);
 	mutex_lock(&priv->conf_mutex);
 	p54_set_leds(priv);
-	priv->stop(dev);
+	priv->stop(priv->hw);
 	skb_queue_purge(&priv->tx_pending);
 	skb_queue_purge(&priv->tx_queue);
 	for (i = 0; i < P54_QUEUE_NUM; i++) {
@@ -224,6 +223,14 @@ static void p54_stop(struct ieee80211_hw *dev)
 	mutex_unlock(&priv->conf_mutex);
 }
 
+static void p54_stop(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+
+	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
+	__p54_stop(priv);
+}
+
 static int p54_add_interface(struct ieee80211_hw *dev,
 			     struct ieee80211_vif *vif)
 {
@@ -435,10 +442,9 @@ static void p54_work(struct work_struct *work)
 	if (unlikely(priv->mode == NL80211_IFTYPE_UNSPECIFIED))
 		return ;
 
-	/*
-	 * TODO: walk through tx_queue and do the following tasks
+	/* TODO: walk through tx_queue and do the following tasks
 	 * 	1. initiate bursts.
-	 *      2. cancel stuck frames / reset the device if necessary.
+	 *	2. cancel stuck frames
 	 */
 
 	mutex_lock(&priv->conf_mutex);
@@ -675,11 +681,10 @@ static void p54_flush(struct ieee80211_hw *dev, bool drop)
 	struct p54_common *priv = dev->priv;
 	unsigned int total, i;
 
-	/*
-	 * Currently, it wouldn't really matter if we wait for one second
+	/* Currently, it wouldn't really matter if we wait for one second
 	 * or 15 minutes. But once someone gets around and completes the
-	 * TODOs [ancel stuck frames / reset device] in p54_work, it will
-	 * suddenly make sense to wait that long.
+	 * TODOs [cancel stuck frames] in p54_work, it will suddenly make
+	 * sense to wait that long.
 	 */
 	i = P54_STATISTICS_UPDATE * 2 / 20;
 
@@ -729,6 +734,45 @@ static const struct ieee80211_ops p54_ops = {
 	.set_coverage_class	= p54_set_coverage_class,
 };
 
+void p54_do_reset(struct ieee80211_hw *hw)
+{
+	struct p54_common *priv = hw->priv;
+
+	if (atomic_inc_return(&priv->reset_pending) > 1) {
+		wiphy_debug(priv->hw->wiphy, "device reset is already scheduled.");
+		return;
+	}
+
+	wiphy_warn(priv->hw->wiphy, "restarting device.");
+	schedule_work(&priv->reset_work);
+}
+
+void p54_reset_done_callback(struct ieee80211_hw *hw)
+{
+	struct p54_common *priv = hw->priv;
+
+	atomic_set(&priv->reset_pending, 0);
+
+	if (priv->mode != NL80211_IFTYPE_UNSPECIFIED)
+		ieee80211_restart_hw(hw);
+}
+EXPORT_SYMBOL_GPL(p54_reset_done_callback);
+
+static void p54_reset_work(struct work_struct *work)
+{
+	struct p54_common *priv = container_of(work, struct p54_common,
+					       reset_work);
+	int err;
+
+	__p54_stop(priv);
+	err = priv->reset(priv->hw);
+	if (err) {
+		priv->mode = NL80211_IFTYPE_UNSPECIFIED;
+		wiphy_err(priv->hw->wiphy,
+			  "failed to restart device (%d)", err);
+	}
+}
+
 struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 {
 	struct ieee80211_hw *dev;
@@ -791,6 +835,7 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 	init_completion(&priv->eeprom_comp);
 	init_completion(&priv->beacon_comp);
 	INIT_DELAYED_WORK(&priv->work, p54_work);
+	INIT_WORK(&priv->reset_work, p54_reset_work);
 
 	memset(&priv->mc_maclist[0], ~0, ETH_ALEN);
 	priv->curchan = NULL;
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 40b401e..e3e23f1 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -170,9 +170,12 @@ struct p54_common {
 	void (*tx)(struct ieee80211_hw *dev, struct sk_buff *skb);
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
+	int (*reset)(struct ieee80211_hw *dev);
 	struct sk_buff_head tx_pending;
 	struct sk_buff_head tx_queue;
 	struct mutex conf_mutex;
+	struct work_struct reset_work;
+	atomic_t reset_pending;
 	bool registered;
 
 	/* memory management (as seen by the firmware) */
@@ -275,6 +278,8 @@ int p54_read_eeprom(struct ieee80211_hw *dev);
 struct ieee80211_hw *p54_init_common(size_t priv_data_len);
 int p54_register_common(struct ieee80211_hw *dev, struct device *pdev);
 void p54_free_common(struct ieee80211_hw *dev);
+void p54_do_reset(struct ieee80211_hw *hw);
+void p54_reset_done_callback(struct ieee80211_hw *hw);
 
 void p54_unregister_common(struct ieee80211_hw *dev);
 
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index 57e3af8..0fc027f 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -373,7 +373,10 @@ static void p54p_stop(struct ieee80211_hw *dev)
 	P54P_READ(int_enable);
 	udelay(10);
 
-	free_irq(priv->pdev->irq, dev);
+	if (priv->registered) {
+		free_irq(priv->pdev->irq, dev);
+		priv->registered = false;
+	}
 
 	tasklet_kill(&priv->tasklet);
 
@@ -440,6 +443,7 @@ static int p54p_open(struct ieee80211_hw *dev)
 		dev_err(&priv->pdev->dev, "failed to register IRQ handler\n");
 		return err;
 	}
+	priv->registered = true;
 
 	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
 	err = p54p_upload_firmware(dev);
@@ -540,6 +544,22 @@ out:
 	pci_dev_put(pdev);
 }
 
+static int p54p_reset(struct ieee80211_hw *dev)
+{
+	int err;
+
+	p54p_stop(dev);
+	err = p54p_open(dev);
+	if (err)
+		goto err_out;
+
+	p54_reset_done_callback(dev);
+
+err_out:
+	p54p_stop(dev);
+	return err;
+}
+
 static int p54p_probe(struct pci_dev *pdev,
 				const struct pci_device_id *id)
 {
@@ -614,6 +634,7 @@ static int p54p_probe(struct pci_dev *pdev,
 	priv->common.open = p54p_open;
 	priv->common.stop = p54p_stop;
 	priv->common.tx = p54p_tx;
+	priv->common.reset = p54p_reset;
 
 	spin_lock_init(&priv->lock);
 	tasklet_init(&priv->tasklet, p54p_tasklet, (unsigned long)dev);
diff --git a/drivers/net/wireless/p54/p54pci.h b/drivers/net/wireless/p54/p54pci.h
index 68405c1..5ba6b3d 100644
--- a/drivers/net/wireless/p54/p54pci.h
+++ b/drivers/net/wireless/p54/p54pci.h
@@ -96,6 +96,7 @@ struct p54p_priv {
 	struct tasklet_struct tasklet;
 	const struct firmware *firmware;
 	spinlock_t lock;
+	bool registered;
 	struct p54p_ring_control *ring_control;
 	dma_addr_t ring_control_dma;
 	u32 rx_idx_data, tx_idx_data;
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 4fd49a0..1b2d447 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -595,6 +595,11 @@ static void p54spi_op_stop(struct ieee80211_hw *dev)
 	cancel_work_sync(&priv->work);
 }
 
+static int p54spi_op_reset(struct ieee80211_hw *dev)
+{
+	return -EOPNOTSUPP;
+}
+
 static int p54spi_probe(struct spi_device *spi)
 {
 	struct p54s_priv *priv = NULL;
@@ -657,6 +662,7 @@ static int p54spi_probe(struct spi_device *spi)
 	priv->common.open = p54spi_op_start;
 	priv->common.stop = p54spi_op_stop;
 	priv->common.tx = p54spi_op_tx;
+	priv->common.reset = p54spi_op_reset;
 
 	ret = p54spi_request_firmware(hw);
 	if (ret < 0)
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 1f78585..c623a09 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -483,13 +483,11 @@ static int p54u_firmware_reset_3887(struct ieee80211_hw *dev)
 	buf = kmemdup(p54u_romboot_3887, 4, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-	ret = p54u_bulk_msg(priv, P54U_PIPE_DATA,
-			    buf, 4);
+	ret = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, 4);
 	kfree(buf);
 	if (ret)
 		dev_err(&priv->udev->dev, "(p54usb) unable to jump to "
 			"boot ROM (%d)!\n", ret);
-
 	return ret;
 }
 
@@ -990,6 +988,13 @@ static int p54u_load_firmware(struct ieee80211_hw *dev,
 	return err;
 }
 
+static int p54u_reset(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+	usb_queue_reset_device(priv->intf);
+	return 0;
+}
+
 static int p54u_probe(struct usb_interface *intf,
 				const struct usb_device_id *id)
 {
@@ -1038,6 +1043,7 @@ static int p54u_probe(struct usb_interface *intf,
 	}
 	priv->common.open = p54u_open;
 	priv->common.stop = p54u_stop;
+	priv->common.reset = p54u_reset;
 	if (recognized_pipes < P54U_PIPE_NUMBER) {
 #ifdef CONFIG_PM
 		/* ISL3887 needs a full reset on resume */
@@ -1081,7 +1087,6 @@ static void p54u_disconnect(struct usb_interface *intf)
 static int p54u_pre_reset(struct usb_interface *intf)
 {
 	struct ieee80211_hw *dev = usb_get_intfdata(intf);
-
 	if (!dev)
 		return -ENODEV;
 
@@ -1107,7 +1112,6 @@ static int p54u_resume(struct usb_interface *intf)
 static int p54u_post_reset(struct usb_interface *intf)
 {
 	struct ieee80211_hw *dev = usb_get_intfdata(intf);
-	struct p54u_priv *priv;
 	int err;
 
 	err = p54u_resume(intf);
@@ -1115,10 +1119,7 @@ static int p54u_post_reset(struct usb_interface *intf)
 		return err;
 
 	/* reinitialize old device state */
-	priv = dev->priv;
-	if (priv->common.mode != NL80211_IFTYPE_UNSPECIFIED)
-		ieee80211_restart_hw(dev);
-
+	p54_reset_done_callback(dev);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 12f0a34..7bfbf1f 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -97,12 +97,11 @@ static int p54_assign_address(struct p54_common *priv, struct sk_buff *skb)
 
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
 	if (unlikely(skb_queue_len(&priv->tx_queue) == 32)) {
-		/*
-		 * The tx_queue is now really full.
-		 *
-		 * TODO: check if the device has crashed and reset it.
+		/* The tx_queue is full and the device doesn't
+		 * seem to care... So reset it!
 		 */
 		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
+		p54_do_reset(priv->hw);
 		return -EBUSY;
 	}
 
@@ -791,13 +790,14 @@ void p54_tx_80211(struct ieee80211_hw *dev,
 	u8 nrates = 0, nremaining = 8;
 	bool burst_allowed = false;
 
+	if (atomic_read(&priv->reset_pending))
+		goto drop;
+
 	p54_tx_80211_header(priv, skb, info, control->sta, &queue, &extra_len,
 			    &hdr_flags, &aid, &burst_allowed);
 
-	if (p54_tx_qos_accounting_alloc(priv, skb, queue)) {
-		ieee80211_free_txskb(dev, skb);
-		return;
-	}
+	if (p54_tx_qos_accounting_alloc(priv, skb, queue))
+		goto drop;
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
@@ -938,4 +938,8 @@ void p54_tx_80211(struct ieee80211_hw *dev,
 	p54info->extra_len = extra_len;
 
 	p54_tx(priv, skb);
+	return;
+
+drop:
+	ieee80211_free_txskb(dev, skb);
 }
-- 
1.7.10.4

