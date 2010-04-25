Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50634 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0DYNmv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Apr 2010 09:42:51 -0400
Received: by bwz19 with SMTP id 19so579133bwz.21
        for <linux-wireless@vger.kernel.org>; Sun, 25 Apr 2010 06:42:49 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [WIP] p54pci: fix resume p54 cardbus
Date: Sun, 25 Apr 2010 15:25:19 +0200
Cc: hdegoede@redhat.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201004251525.19796.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch tries to fix the resume freeze, which is described in
https://bugzilla.redhat.com/show_bug.cgi?id=583623

Unlike (normal) PCI cards, cardbus cards are easily removable.
Therefore, the user might replace/remove the card while
the system is suspended. The pcmcia subsystem takes special
precautions to deal with such cases and un- and rebinds
all devices on the pci-bridge during the resume process.

But here's the catch: p54pci uses request_firmware
which blocks until the filesystem is available.
This deadlocks, because the filesystem won't
be initialized until all pci devices are ready again.
---
highly experimental and possibly unstable
---
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 7bbd9d3..810197c 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -603,6 +603,8 @@ int p54_register_common(struct ieee80211_hw *dev, struct device *pdev)
 		return err;
 	}
 
+	priv->registered = true;
+
 #ifdef CONFIG_P54_LEDS
 	err = p54_init_leds(priv);
 	if (err)
@@ -638,6 +640,9 @@ void p54_unregister_common(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
 
+	if (!priv->registered)
+		return;
+
 #ifdef CONFIG_P54_LEDS
 	p54_unregister_leds(priv);
 #endif /* CONFIG_P54_LEDS */
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 43a3b2e..850e6bb 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -172,6 +172,7 @@ struct p54_common {
 	struct sk_buff_head tx_pending;
 	struct sk_buff_head tx_queue;
 	struct mutex conf_mutex;
+	bool registered;
 
 	/* memory management (as seen by the firmware) */
 	u32 rx_start;
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index c916e46..353085d 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -50,7 +50,6 @@ static int p54p_upload_firmware(struct ieee80211_hw *dev)
 {
 	struct p54p_priv *priv = dev->priv;
 	__le32 reg;
-	int err;
 	__le32 *data;
 	u32 remains, left, device_addr;
 
@@ -75,11 +74,7 @@ static int p54p_upload_firmware(struct ieee80211_hw *dev)
 	wmb();
 
 	/* wait for the firmware to reset properly */
-	mdelay(10);
-
-	err = p54_parse_firmware(dev, priv->firmware);
-	if (err)
-		return err;
+	mdelay(50);
 
 	if (priv->common.fw_interface != FW_LM86) {
 		dev_err(&priv->pdev->dev, "wrong firmware, "
@@ -360,8 +355,12 @@ static void p54p_stop(struct ieee80211_hw *dev)
 {
 	struct p54p_priv *priv = dev->priv;
 	struct p54p_ring_control *ring_control = priv->ring_control;
-	unsigned int i;
 	struct p54p_desc *desc;
+	unsigned int i;
+
+	mutex_lock(&priv->mutex);
+	if (!priv->started)
+		goto out_unlock;
 
 	P54P_WRITE(int_enable, cpu_to_le32(0));
 	P54P_READ(int_enable);
@@ -420,6 +419,10 @@ static void p54p_stop(struct ieee80211_hw *dev)
 	}
 
 	memset(ring_control, 0, sizeof(*ring_control));
+	priv->started = false;
+
+out_unlock:
+	mutex_unlock(&priv->mutex);
 }
 
 static int p54p_open(struct ieee80211_hw *dev)
@@ -427,19 +430,25 @@ static int p54p_open(struct ieee80211_hw *dev)
 	struct p54p_priv *priv = dev->priv;
 	int err;
 
+	mutex_lock(&priv->mutex);
+	if (WARN_ON(priv->started)) {
+		err = -EBUSY;
+		goto out_unlock;
+	}
+
 	init_completion(&priv->boot_comp);
 	err = request_irq(priv->pdev->irq, p54p_interrupt,
 			  IRQF_SHARED, "p54pci", dev);
 	if (err) {
 		dev_err(&priv->pdev->dev, "failed to register IRQ handler\n");
-		return err;
+		goto out_unlock;
 	}
 
 	memset(priv->ring_control, 0, sizeof(*priv->ring_control));
 	err = p54p_upload_firmware(dev);
 	if (err) {
 		free_irq(priv->pdev->irq, dev);
-		return err;
+		goto out_unlock;
 	}
 	priv->rx_idx_data = priv->tx_idx_data = 0;
 	priv->rx_idx_mgmt = priv->tx_idx_mgmt = 0;
@@ -464,10 +473,10 @@ static int p54p_open(struct ieee80211_hw *dev)
 	P54P_READ(dev_int);
 
 	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ)) {
-		printk(KERN_ERR "%s: Cannot boot firmware!\n",
-		       wiphy_name(dev->wiphy));
+		dev_err(&priv->pdev->dev, "Cannot boot firmware!");
 		p54p_stop(dev);
-		return -ETIMEDOUT;
+		err = -ETIMEDOUT;
+		goto out_unlock;
 	}
 
 	P54P_WRITE(int_enable, cpu_to_le32(ISL38XX_INT_IDENT_UPDATE));
@@ -480,7 +489,78 @@ static int p54p_open(struct ieee80211_hw *dev)
 	wmb();
 	udelay(10);
 
-	return 0;
+	priv->started = true;
+
+out_unlock:
+	mutex_unlock(&priv->mutex);
+	return err;
+}
+
+const static char *p54p_fws[] = { "isl3886pci", "isl3886" };
+
+static void p54p_fw_callback(const struct firmware *fw, void *context);
+static int p54p_request_fw(struct p54p_priv *priv)
+{
+
+	if (ARRAY_SIZE(p54p_fws) <= priv->fw_idx)
+		return -ENOENT;
+
+	return request_firmware_nowait(THIS_MODULE, 1, p54p_fws[priv->fw_idx],
+				       &priv->pdev->dev, GFP_KERNEL, priv,
+				       p54p_fw_callback);
+}
+
+static void p54p_fw_callback(const struct firmware *fw, void *context)
+{
+	struct p54p_priv *priv = context;
+	struct ieee80211_hw *dev = pci_get_drvdata(priv->pdev);
+	int err;
+
+	if (!fw) {
+		dev_err(&priv->pdev->dev, "Cannot find firmware (\"%s\")",
+			p54p_fws[priv->fw_idx]);
+		priv->fw_idx++;
+
+		err = p54p_request_fw(priv);
+		if (err)
+			goto err_out;
+
+		return;
+	}
+
+	priv->firmware = fw;
+
+	err = p54_parse_firmware(dev, priv->firmware);
+	if (err) {
+		dev_err(&priv->pdev->dev, "Failed to parse firmware");
+		goto err_out;
+	}
+
+	err = p54p_open(dev);
+	if (err)
+		goto err_out;
+	err = p54_read_eeprom(dev);
+	p54p_stop(dev);
+	if (err)
+		goto err_out;
+
+	err = p54_register_common(dev, &priv->pdev->dev);
+	if (err)
+		goto err_out;
+
+	return;
+
+err_out:
+	device_release_driver(&priv->pdev->dev);
+}
+
+static void p54p_init_dev(struct pci_dev *pdev)
+{
+	pci_set_master(pdev);
+	pci_try_set_mwi(pdev);
+
+	pci_write_config_byte(pdev, 0x40, 0);
+	pci_write_config_byte(pdev, 0x41, 0);
 }
 
 static int __devinit p54p_probe(struct pci_dev *pdev,
@@ -518,11 +598,7 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 		goto err_free_reg;
 	}
 
-	pci_set_master(pdev);
-	pci_try_set_mwi(pdev);
-
-	pci_write_config_byte(pdev, 0x40, 0);
-	pci_write_config_byte(pdev, 0x41, 0);
+	p54p_init_dev(pdev);
 
 	dev = p54_init_common(sizeof(*priv));
 	if (!dev) {
@@ -556,34 +632,16 @@ static int __devinit p54p_probe(struct pci_dev *pdev,
 	priv->common.tx = p54p_tx;
 
 	spin_lock_init(&priv->lock);
+	mutex_init(&priv->mutex);
 	tasklet_init(&priv->tasklet, p54p_tasklet, (unsigned long)dev);
 
-	err = request_firmware(&priv->firmware, "isl3886pci",
-			       &priv->pdev->dev);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot find firmware (isl3886pci)\n");
-		err = request_firmware(&priv->firmware, "isl3886",
-				       &priv->pdev->dev);
-		if (err)
-			goto err_free_common;
-	}
-
-	err = p54p_open(dev);
-	if (err)
-		goto err_free_common;
-	err = p54_read_eeprom(dev);
-	p54p_stop(dev);
-	if (err)
-		goto err_free_common;
-
-	err = p54_register_common(dev, &pdev->dev);
+	err = p54p_request_fw(priv);
 	if (err)
 		goto err_free_common;
 
 	return 0;
 
  err_free_common:
-	release_firmware(priv->firmware);
 	pci_free_consistent(pdev, sizeof(*priv->ring_control),
 			    priv->ring_control, priv->ring_control_dma);
 
@@ -611,6 +669,8 @@ static void __devexit p54p_remove(struct pci_dev *pdev)
 
 	p54_unregister_common(dev);
 	priv = dev->priv;
+	p54p_stop(dev);
+	mutex_destroy(&priv->mutex);
 	release_firmware(priv->firmware);
 	pci_free_consistent(pdev, sizeof(*priv->ring_control),
 			    priv->ring_control, priv->ring_control_dma);
@@ -624,32 +684,48 @@ static void __devexit p54p_remove(struct pci_dev *pdev)
 static int p54p_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
-	struct p54p_priv *priv = dev->priv;
-
-	if (priv->common.mode != NL80211_IFTYPE_UNSPECIFIED) {
-		ieee80211_stop_queues(dev);
-		p54p_stop(dev);
-	}
 
+	p54p_stop(dev);
 	pci_save_state(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-	return 0;
+	pci_disable_device(pdev);
+	return pci_set_power_state(pdev, pci_choose_state(pdev, state));
 }
 
 static int p54p_resume(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
 	struct p54p_priv *priv = dev->priv;
+	int err;
+
+	err = pci_set_power_state(pdev, PCI_D0);
+	if (err) {
+		dev_err(&pdev->dev, "failed to power-up device");
+		return err;
+	}
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "failed to reenable device");
+		return err;
+	}
+
+	err = pci_restore_state(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "failed to restore device state");
+		return err;
+	}
+
+	p54p_init_dev(pdev);
 
 	if (priv->common.mode != NL80211_IFTYPE_UNSPECIFIED) {
-		p54p_open(dev);
-		ieee80211_wake_queues(dev);
+		err = p54p_open(dev);
+		if (err) {
+			dev_err(&pdev->dev, "failed to bring up link");
+			return err;
+		}
 	}
 
-	return 0;
+	return err;
 }
 #endif /* CONFIG_PM */
 
diff --git a/drivers/net/wireless/p54/p54pci.h b/drivers/net/wireless/p54/p54pci.h
index 9fd822f..d4a9bdc 100644
--- a/drivers/net/wireless/p54/p54pci.h
+++ b/drivers/net/wireless/p54/p54pci.h
@@ -95,7 +95,10 @@ struct p54p_priv {
 	struct pci_dev *pdev;
 	struct p54p_csr __iomem *map;
 	struct tasklet_struct tasklet;
+	unsigned int fw_idx;
 	const struct firmware *firmware;
+	bool started;
+	struct mutex mutex;
 	spinlock_t lock;
 	struct p54p_ring_control *ring_control;
 	dma_addr_t ring_control_dma;
