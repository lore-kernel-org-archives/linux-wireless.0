Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55564 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbYIFSJc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 14:09:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Remove QoS update workqueue
Date: Sat, 6 Sep 2008 20:07:31 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200809062007.32422.mb@bu3sch.de> (sfid-20080906_200936_007626_4E5118E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't need the workqueue anymore, as we can now sleep in the callback.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for the next merge window.
This patch depends on
[PATCH] mac80211: make conf_tx non-atomic

Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-09-06 15:24:52.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-09-06 19:49:14.000000000 +0200
@@ -582,14 +582,12 @@ enum {
 };
 
 /* QOS parameters for a queue. */
 struct b43_qos_params {
 	/* The QOS parameters */
 	struct ieee80211_tx_queue_params p;
-	/* Does this need to get uploaded to hardware? */
-	bool need_hw_update;
 };
 
 struct b43_wldev;
 
 /* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
 struct b43_wl {
@@ -645,17 +643,14 @@ struct b43_wl {
 	struct sk_buff *current_beacon;
 	bool beacon0_uploaded;
 	bool beacon1_uploaded;
 	bool beacon_templates_virgin; /* Never wrote the templates? */
 	struct work_struct beacon_update_trigger;
 
-	/* The current QOS parameters for the 4 queues.
-	 * This is protected by the irq_lock. */
+	/* The current QOS parameters for the 4 queues. */
 	struct b43_qos_params qos_params[4];
-	/* Workqueue for updating QOS parameters in hardware. */
-	struct work_struct qos_update_work;
 
 	/* Work for adjustment of the transmission power.
 	 * This is scheduled when we determine that the actual TX output
 	 * power doesn't match what we want. */
 	struct work_struct txpower_adjust_work;
 };
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-09-06 15:45:09.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-09-06 20:00:49.000000000 +0200
@@ -3065,36 +3065,28 @@ static const u16 b43_qos_shm_offsets[] =
 	[0] = B43_QOS_VOICE,
 	[1] = B43_QOS_VIDEO,
 	[2] = B43_QOS_BESTEFFORT,
 	[3] = B43_QOS_BACKGROUND,
 };
 
-/* Update the QOS parameters in hardware. */
-static void b43_qos_update(struct b43_wldev *dev)
+/* Update all QOS parameters in hardware. */
+static void b43_qos_upload_all(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
 	struct b43_qos_params *params;
-	unsigned long flags;
 	unsigned int i;
 
 	BUILD_BUG_ON(ARRAY_SIZE(b43_qos_shm_offsets) !=
 		     ARRAY_SIZE(wl->qos_params));
 
 	b43_mac_suspend(dev);
-	spin_lock_irqsave(&wl->irq_lock, flags);
-
 	for (i = 0; i < ARRAY_SIZE(wl->qos_params); i++) {
 		params = &(wl->qos_params[i]);
-		if (params->need_hw_update) {
-			b43_qos_params_upload(dev, &(params->p),
-					      b43_qos_shm_offsets[i]);
-			params->need_hw_update = 0;
-		}
+		b43_qos_params_upload(dev, &(params->p),
+				      b43_qos_shm_offsets[i]);
 	}
-
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
 	b43_mac_enable(dev);
 }
 
 static void b43_qos_clear(struct b43_wl *wl)
 {
 	struct b43_qos_params *params;
@@ -3133,70 +3125,61 @@ static void b43_qos_clear(struct b43_wl 
 			params->p.cw_min = 0x0001;
 			params->p.cw_max = 0x03FF;
 			break;
 		default:
 			B43_WARN_ON(1);
 		}
-		params->need_hw_update = 1;
 	}
 }
 
 /* Initialize the core's QOS capabilities */
 static void b43_qos_init(struct b43_wldev *dev)
 {
-	struct b43_wl *wl = dev->wl;
-	unsigned int i;
-
 	/* Upload the current QOS parameters. */
-	for (i = 0; i < ARRAY_SIZE(wl->qos_params); i++)
-		wl->qos_params[i].need_hw_update = 1;
-	b43_qos_update(dev);
+	b43_qos_upload_all(dev);
 
 	/* Enable QOS support. */
 	b43_hf_write(dev, b43_hf_read(dev) | B43_HF_EDCF);
 	b43_write16(dev, B43_MMIO_IFSCTL,
 		    b43_read16(dev, B43_MMIO_IFSCTL)
 		    | B43_MMIO_IFSCTL_USE_EDCF);
 }
 
-static void b43_qos_update_work(struct work_struct *work)
-{
-	struct b43_wl *wl = container_of(work, struct b43_wl, qos_update_work);
-	struct b43_wldev *dev;
-
-	mutex_lock(&wl->mutex);
-	dev = wl->current_dev;
-	if (likely(dev && (b43_status(dev) >= B43_STAT_INITIALIZED)))
-		b43_qos_update(dev);
-	mutex_unlock(&wl->mutex);
-}
-
 static int b43_op_conf_tx(struct ieee80211_hw *hw, u16 _queue,
 			  const struct ieee80211_tx_queue_params *params)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
-	unsigned long flags;
+	struct b43_wldev *dev;
 	unsigned int queue = (unsigned int)_queue;
-	struct b43_qos_params *p;
+	int err = -ENODEV;
 
 	if (queue >= ARRAY_SIZE(wl->qos_params)) {
 		/* Queue not available or don't support setting
 		 * params on this queue. Return success to not
 		 * confuse mac80211. */
 		return 0;
 	}
+	BUILD_BUG_ON(ARRAY_SIZE(b43_qos_shm_offsets) !=
+		     ARRAY_SIZE(wl->qos_params));
 
-	spin_lock_irqsave(&wl->irq_lock, flags);
-	p = &(wl->qos_params[queue]);
-	memcpy(&(p->p), params, sizeof(p->p));
-	p->need_hw_update = 1;
-	spin_unlock_irqrestore(&wl->irq_lock, flags);
+	mutex_lock(&wl->mutex);
+	dev = wl->current_dev;
+	if (unlikely(!dev || (b43_status(dev) < B43_STAT_INITIALIZED)))
+		goto out_unlock;
 
-	queue_work(hw->workqueue, &wl->qos_update_work);
+	memcpy(&(wl->qos_params[queue].p), params, sizeof(*params));
+	b43_mac_suspend(dev);
+	b43_qos_params_upload(dev, &(wl->qos_params[queue].p),
+			      b43_qos_shm_offsets[queue]);
+	b43_mac_enable(dev);
+	err = 0;
 
-	return 0;
+out_unlock:
+	mutex_unlock(&wl->mutex);
+
+	return err;
 }
 
 static int b43_op_get_tx_stats(struct ieee80211_hw *hw,
 			       struct ieee80211_tx_queue_stats *stats)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
@@ -4217,13 +4200,12 @@ static int b43_op_start(struct ieee80211
 static void b43_op_stop(struct ieee80211_hw *hw)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 
 	b43_rfkill_exit(dev);
-	cancel_work_sync(&(wl->qos_update_work));
 	cancel_work_sync(&(wl->beacon_update_trigger));
 
 	mutex_lock(&wl->mutex);
 	if (b43_status(dev) >= B43_STAT_STARTED)
 		b43_wireless_core_stop(dev);
 	b43_wireless_core_exit(dev);
@@ -4616,13 +4598,12 @@ static int b43_wireless_init(struct ssb_
 	spin_lock_init(&wl->irq_lock);
 	rwlock_init(&wl->tx_lock);
 	spin_lock_init(&wl->leds_lock);
 	spin_lock_init(&wl->shm_lock);
 	mutex_init(&wl->mutex);
 	INIT_LIST_HEAD(&wl->devlist);
-	INIT_WORK(&wl->qos_update_work, b43_qos_update_work);
 	INIT_WORK(&wl->beacon_update_trigger, b43_beacon_update_trigger_work);
 	INIT_WORK(&wl->txpower_adjust_work, b43_phy_txpower_adjust_work);
 
 	ssb_set_devtypedata(dev, wl);
 	b43info(wl, "Broadcom %04X WLAN found\n", dev->bus->chip_id);
 	err = 0;
