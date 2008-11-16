Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:58810 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbYKPLUg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 06:20:36 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] p54pci: cache firmware for suspend/resume v2.1
Date: Sun, 16 Nov 2008 12:20:32 +0100
Cc: John W Linville <linville@tuxdriver.com>
References: <200811141941.56752.chunkeey@web.de> <200811150142.28447.chunkeey@web.de> <200811151930.19854.chunkeey@web.de>
In-Reply-To: <200811151930.19854.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811161220.32828.chunkeey@web.de> (sfid-20081116_122041_451004_02D53C75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes pointed out that the driver has cache the firmware for
suspend/resume cycles. 
 
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
v1 removed a bit too much. it was very chatty about the firmware capabilities...
v2 forget release_firmware. d'oh!
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-14 18:08:22.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-15 18:57:30.000000000 +0100
@@ -1525,16 +1525,24 @@ static int p54_start(struct ieee80211_hw
 
 	mutex_lock(&priv->conf_mutex);
 	err = priv->open(dev);
-	if (!err)
-		priv->mode = NL80211_IFTYPE_MONITOR;
+	if (err)
+		goto out;
 	P54_SET_QUEUE(priv->qos_params[0], 0x0002, 0x0003, 0x0007, 47);
 	P54_SET_QUEUE(priv->qos_params[1], 0x0002, 0x0007, 0x000f, 94);
 	P54_SET_QUEUE(priv->qos_params[2], 0x0003, 0x000f, 0x03ff, 0);
 	P54_SET_QUEUE(priv->qos_params[3], 0x0007, 0x000f, 0x03ff, 0);
 	err = p54_set_edcf(dev);
-	if (!err)
-		err = p54_init_stats(dev);
+	if (err)
+		goto out;
+	err = p54_init_stats(dev);
+	if (err)
+		goto out;
+	err = p54_setup_mac(dev, P54_FILTER_TYPE_NONE, NULL);
+	if (err)
+		goto out;
+	priv->mode = NL80211_IFTYPE_MONITOR;
 
+out:
 	mutex_unlock(&priv->conf_mutex);
 	return err;
 }
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2008-11-14 00:14:59.000000000 +0100
+++ b/drivers/net/wireless/p54/p54pci.c	2008-11-16 12:09:44.000000000 +0100
@@ -47,7 +47,6 @@ MODULE_DEVICE_TABLE(pci, p54p_table);
 static int p54p_upload_firmware(struct ieee80211_hw *dev)
 {
 	struct p54p_priv *priv = dev->priv;
-	const struct firmware *fw_entry = NULL;
 	__le32 reg;
 	int err;
 	__le32 *data;
@@ -73,23 +72,15 @@ static int p54p_upload_firmware(struct i
 	P54P_WRITE(ctrl_stat, reg);
 	wmb();
 
-	err = request_firmware(&fw_entry, "isl3886pci", &priv->pdev->dev);
-	if (err) {
-		printk(KERN_ERR "%s (p54pci): cannot find firmware "
-		       "(isl3886pci)\n", pci_name(priv->pdev));
-		err = request_firmware(&fw_entry, "isl3886", &priv->pdev->dev);
-		if (err)
-			return err;
-	}
+	/* wait for the firmware to reset properly */
+	mdelay(10);
 
-	err = p54_parse_firmware(dev, fw_entry);
-	if (err) {
-		release_firmware(fw_entry);
+	err = p54_parse_firmware(dev, priv->firmware);
+	if (err)
 		return err;
-	}
 
-	data = (__le32 *) fw_entry->data;
-	remains = fw_entry->size;
+	data = (__le32 *) priv->firmware->data;
+	remains = priv->firmware->size;
 	device_addr = ISL38XX_DEV_FIRMWARE_ADDR;
 	while (remains) {
 		u32 i = 0;
@@ -107,8 +98,6 @@ static int p54p_upload_firmware(struct i
 		P54P_READ(int_enable);
 	}
 
-	release_firmware(fw_entry);
-
 	reg = P54P_READ(ctrl_stat);
 	reg &= cpu_to_le32(~ISL38XX_CTRL_STAT_CLKRUN);
 	reg &= cpu_to_le32(~ISL38XX_CTRL_STAT_RESET);
@@ -501,15 +490,14 @@ static int __devinit p54p_probe(struct p
 	if (mem_len < sizeof(struct p54p_csr)) {
 		printk(KERN_ERR "%s (p54pci): Too short PCI resources\n",
 		       pci_name(pdev));
-		pci_disable_device(pdev);
-		return err;
+		goto err_disable_dev;
 	}
 
 	err = pci_request_regions(pdev, "p54pci");
 	if (err) {
 		printk(KERN_ERR "%s (p54pci): Cannot obtain PCI resources\n",
 		       pci_name(pdev));
-		return err;
+		goto err_disable_dev;
 	}
 
 	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) ||
@@ -562,6 +550,17 @@ static int __devinit p54p_probe(struct p
 	spin_lock_init(&priv->lock);
 	tasklet_init(&priv->rx_tasklet, p54p_rx_tasklet, (unsigned long)dev);
 
+	err = request_firmware(&priv->firmware, "isl3886pci",
+			       &priv->pdev->dev);
+	if (err) {
+		printk(KERN_ERR "%s (p54pci): cannot find firmware "
+			"(isl3886pci)\n", pci_name(priv->pdev));
+		err = request_firmware(&priv->firmware, "isl3886",
+				       &priv->pdev->dev);
+		if (err)
+			goto err_free_common;
+	}
+
 	err = p54p_open(dev);
 	if (err)
 		goto err_free_common;
@@ -580,6 +579,7 @@ static int __devinit p54p_probe(struct p
 	return 0;
 
  err_free_common:
+	release_firmware(priv->firmware);
 	p54_free_common(dev);
 	pci_free_consistent(pdev, sizeof(*priv->ring_control),
 			    priv->ring_control, priv->ring_control_dma);
@@ -593,6 +593,7 @@ static int __devinit p54p_probe(struct p
 
  err_free_reg:
 	pci_release_regions(pdev);
+ err_disable_dev:
 	pci_disable_device(pdev);
 	return err;
 }
@@ -607,6 +608,7 @@ static void __devexit p54p_remove(struct
 
 	ieee80211_unregister_hw(dev);
 	priv = dev->priv;
+	release_firmware(priv->firmware);
 	pci_free_consistent(pdev, sizeof(*priv->ring_control),
 			    priv->ring_control, priv->ring_control_dma);
 	p54_free_common(dev);
diff -Nurp a/drivers/net/wireless/p54/p54pci.h b/drivers/net/wireless/p54/p54pci.h
--- a/drivers/net/wireless/p54/p54pci.h	2008-11-14 00:14:59.000000000 +0100
+++ b/drivers/net/wireless/p54/p54pci.h	2008-11-15 18:58:41.000000000 +0100
@@ -93,7 +93,7 @@ struct p54p_priv {
 	struct pci_dev *pdev;
 	struct p54p_csr __iomem *map;
 	struct tasklet_struct rx_tasklet;
-
+	const struct firmware *firmware;
 	spinlock_t lock;
 	struct p54p_ring_control *ring_control;
 	dma_addr_t ring_control_dma;
