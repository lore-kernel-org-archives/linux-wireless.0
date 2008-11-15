Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:57048 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYKOAma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 19:42:30 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/4] p54pci: cache firmware for suspend/resume
Date: Sat, 15 Nov 2008 01:42:28 +0100
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <200811141941.56752.chunkeey@web.de> <200811150054.30113.chunkeey@web.de> <1226707350.4120.34.camel@johannes.berg>
In-Reply-To: <1226707350.4120.34.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811150142.28447.chunkeey@web.de> (sfid-20081115_014235_915729_2151A097)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes pointed out that the driver has cache the firmware for
suspend/resume cycles. 

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
On Saturday 15 November 2008 01:02:30 Johannes Berg wrote:
> On Sat, 2008-11-15 at 00:54 +0100, Christian Lamparter wrote:
> > On Friday 14 November 2008 23:00:28 Johannes Berg wrote:
> > > that seems weird. Doesn't the driver pretty much have to cache the
> > > firmware anyway for suspend/resume?
> > 
> > well, that's odd. No one complained about this bug yet?!
> > Even better, this bug/quirk is even present in the initial p54pci version that made it
> > into the kernel. In fact it looks like its even present in the fullmac driver! Luis?
> > 
> > I guess, I have to leave it that way to provide "bug-to-bug" compatibility! ;-)
> 
> Maybe it doesn't upload the firmware at resume? But that'd be odd.
> 
Well, after a suspend/resume any wifi-link is "probably" gone and all userspace
tools are trying to reactive them. and of course "this" time, this will work!

But yeah, odd... so what about this patch instead? sure we "waste" now
about 20-32kb but that's nothing compared to firmware images from other vendors.
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-14 18:08:22.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-15 01:29:38.000000000 +0100
@@ -136,9 +136,6 @@ int p54_parse_firmware(struct ieee80211_
 	size_t len;
 	int i;
 
-	if (priv->rx_start)
-		return 0;
-
 	while (data < end_data && *data)
 		data++;
 
@@ -1525,16 +1522,24 @@ static int p54_start(struct ieee80211_hw
 
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
+++ b/drivers/net/wireless/p54/p54pci.c	2008-11-15 01:33:58.000000000 +0100
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
diff -Nurp a/drivers/net/wireless/p54/p54pci.h b/drivers/net/wireless/p54/p54pci.h
--- a/drivers/net/wireless/p54/p54pci.h	2008-11-14 00:14:59.000000000 +0100
+++ b/drivers/net/wireless/p54/p54pci.h	2008-11-15 01:04:29.000000000 +0100
@@ -104,6 +104,8 @@ struct p54p_priv {
 	void *tx_buf_data[32];
 	void *tx_buf_mgmt[4];
 	struct completion boot_comp;
+
+	const struct firmware *firmware;
 };
 
 #endif /* P54USB_H */
