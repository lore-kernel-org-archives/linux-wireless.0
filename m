Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:54755 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbYHHTOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 15:14:51 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] p54: rename prism54xyz -> p54xyz
Date: Fri, 8 Aug 2008 21:17:37 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808082117.38254.chunkeey@web.de> (sfid-20080808_211456_134630_0F3BF2B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's been a long time, but fullmac prism54 driver is still around...
I think we should rename every prism54* in order to avoid some
confusion about "what is actually what" in the future ;-).

Thanks-to: Maxi <maxi@daemonizer.de>

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-08-08 20:56:52.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-08-07 17:29:39.000000000 +0200
@@ -1,5 +1,5 @@
-#ifndef PRISM54COMMON_H
-#define PRISM54COMMON_H
+#ifndef P54COMMON_H
+#define P54COMMON_H
 
 /*
  * Common code specific definitions for mac80211 Prism54 drivers
@@ -252,4 +252,4 @@ struct p54_tx_control_vdcf {
 	__le16 frameburst;
 } __attribute__ ((packed));
 
-#endif /* PRISM54COMMON_H */
+#endif /* P54COMMON_H */
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-08-07 09:01:17.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-08-07 17:29:39.000000000 +0200
@@ -1,5 +1,5 @@
-#ifndef PRISM54_H
-#define PRISM54_H
+#ifndef P54_H
+#define P54_H
 
 /*
  * Shared defines for all mac80211 Prism54 code
@@ -75,4 +75,4 @@ void p54_fill_eeprom_readback(struct p54
 struct ieee80211_hw *p54_init_common(size_t priv_data_len);
 void p54_free_common(struct ieee80211_hw *dev);
 
-#endif /* PRISM54_H */
+#endif /* P54_H */
diff -Nurp a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
--- a/drivers/net/wireless/p54/p54pci.c	2008-08-07 09:01:17.000000000 +0200
+++ b/drivers/net/wireless/p54/p54pci.c	2008-08-08 20:58:39.000000000 +0200
@@ -75,7 +75,7 @@ static int p54p_upload_firmware(struct i
 
 	err = request_firmware(&fw_entry, "isl3886", &priv->pdev->dev);
 	if (err) {
-		printk(KERN_ERR "%s (prism54pci): cannot find firmware "
+		printk(KERN_ERR "%s (p54pci): cannot find firmware "
 		       "(isl3886)\n", pci_name(priv->pdev));
 		return err;
 	}
@@ -150,16 +150,16 @@ static int p54p_read_eeprom(struct ieee8
 
 	init_completion(&priv->boot_comp);
 	err = request_irq(priv->pdev->irq, &p54p_simple_interrupt,
-			  IRQF_SHARED, "prism54pci", priv);
+			  IRQF_SHARED, "p54pci", priv);
 	if (err) {
-		printk(KERN_ERR "%s (prism54pci): failed to register IRQ handler\n",
+		printk(KERN_ERR "%s (p54pci): failed to register IRQ handler\n",
 		       pci_name(priv->pdev));
 		return err;
 	}
 
 	eeprom = kmalloc(0x2010 + EEPROM_READBACK_LEN, GFP_KERNEL);
 	if (!eeprom) {
-		printk(KERN_ERR "%s (prism54pci): no memory for eeprom!\n",
+		printk(KERN_ERR "%s (p54pci): no memory for eeprom!\n",
 		       pci_name(priv->pdev));
 		err = -ENOMEM;
 		goto out;
@@ -177,7 +177,7 @@ static int p54p_read_eeprom(struct ieee8
 	P54P_WRITE(dev_int, cpu_to_le32(ISL38XX_DEV_INT_RESET));
 
 	if (!wait_for_completion_interruptible_timeout(&priv->boot_comp, HZ)) {
-		printk(KERN_ERR "%s (prism54pci): Cannot boot firmware!\n",
+		printk(KERN_ERR "%s (p54pci): Cannot boot firmware!\n",
 		       pci_name(priv->pdev));
 		err = -EINVAL;
 		goto out;
@@ -219,7 +219,7 @@ static int p54p_read_eeprom(struct ieee8
 	alen = le16_to_cpu(ring_control->rx_mgmt[0].len);
 	if (le32_to_cpu(ring_control->device_idx[2]) != 1 ||
 	    alen < 0x10) {
-		printk(KERN_ERR "%s (prism54pci): Cannot read eeprom!\n",
+		printk(KERN_ERR "%s (p54pci): Cannot read eeprom!\n",
 		       pci_name(priv->pdev));
 		err = -EINVAL;
 		goto out;
@@ -412,7 +412,7 @@ static int p54p_open(struct ieee80211_hw
 
 	init_completion(&priv->boot_comp);
 	err = request_irq(priv->pdev->irq, &p54p_interrupt,
-			  IRQF_SHARED, "prism54pci", dev);
+			  IRQF_SHARED, "p54pci", dev);
 	if (err) {
 		printk(KERN_ERR "%s: failed to register IRQ handler\n",
 		       wiphy_name(dev->wiphy));
@@ -506,7 +506,7 @@ static int __devinit p54p_probe(struct p
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		printk(KERN_ERR "%s (prism54pci): Cannot enable new PCI device\n",
+		printk(KERN_ERR "%s (p54pci): Cannot enable new PCI device\n",
 		       pci_name(pdev));
 		return err;
 	}
@@ -514,22 +514,22 @@ static int __devinit p54p_probe(struct p
 	mem_addr = pci_resource_start(pdev, 0);
 	mem_len = pci_resource_len(pdev, 0);
 	if (mem_len < sizeof(struct p54p_csr)) {
-		printk(KERN_ERR "%s (prism54pci): Too short PCI resources\n",
+		printk(KERN_ERR "%s (p54pci): Too short PCI resources\n",
 		       pci_name(pdev));
 		pci_disable_device(pdev);
 		return err;
 	}
 
-	err = pci_request_regions(pdev, "prism54pci");
+	err = pci_request_regions(pdev, "p54pci");
 	if (err) {
-		printk(KERN_ERR "%s (prism54pci): Cannot obtain PCI resources\n",
+		printk(KERN_ERR "%s (p54pci): Cannot obtain PCI resources\n",
 		       pci_name(pdev));
 		return err;
 	}
 
 	if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) ||
 	    pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
-		printk(KERN_ERR "%s (prism54pci): No suitable DMA available\n",
+		printk(KERN_ERR "%s (p54pci): No suitable DMA available\n",
 		       pci_name(pdev));
 		goto err_free_reg;
 	}
@@ -542,7 +542,7 @@ static int __devinit p54p_probe(struct p
 
 	dev = p54_init_common(sizeof(*priv));
 	if (!dev) {
-		printk(KERN_ERR "%s (prism54pci): ieee80211 alloc failed\n",
+		printk(KERN_ERR "%s (p54pci): ieee80211 alloc failed\n",
 		       pci_name(pdev));
 		err = -ENOMEM;
 		goto err_free_reg;
@@ -556,7 +556,7 @@ static int __devinit p54p_probe(struct p
 
 	priv->map = ioremap(mem_addr, mem_len);
 	if (!priv->map) {
-		printk(KERN_ERR "%s (prism54pci): Cannot map device memory\n",
+		printk(KERN_ERR "%s (p54pci): Cannot map device memory\n",
 		       pci_name(pdev));
 		err = -EINVAL;	// TODO: use a better error code?
 		goto err_free_dev;
@@ -565,7 +565,7 @@ static int __devinit p54p_probe(struct p
 	priv->ring_control = pci_alloc_consistent(pdev, sizeof(*priv->ring_control),
 						  &priv->ring_control_dma);
 	if (!priv->ring_control) {
-		printk(KERN_ERR "%s (prism54pci): Cannot allocate rings\n",
+		printk(KERN_ERR "%s (p54pci): Cannot allocate rings\n",
 		       pci_name(pdev));
 		err = -ENOMEM;
 		goto err_iounmap;
@@ -588,7 +588,7 @@ static int __devinit p54p_probe(struct p
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
-		printk(KERN_ERR "%s (prism54pci): Cannot register netdevice\n",
+		printk(KERN_ERR "%s (p54pci): Cannot register netdevice\n",
 		       pci_name(pdev));
 		goto err_free_common;
 	}
@@ -673,7 +673,7 @@ static int p54p_resume(struct pci_dev *p
 #endif /* CONFIG_PM */
 
 static struct pci_driver p54p_driver = {
-	.name		= "prism54pci",
+	.name		= "p54pci",
 	.id_table	= p54p_table,
 	.probe		= p54p_probe,
 	.remove		= __devexit_p(p54p_remove),
diff -Nurp a/drivers/net/wireless/p54/p54pci.h b/drivers/net/wireless/p54/p54pci.h
--- a/drivers/net/wireless/p54/p54pci.h	2008-08-07 09:01:17.000000000 +0200
+++ b/drivers/net/wireless/p54/p54pci.h	2008-08-07 17:29:39.000000000 +0200
@@ -1,5 +1,5 @@
-#ifndef PRISM54PCI_H
-#define PRISM54PCI_H
+#ifndef P54PCI_H
+#define P54PCI_H
 
 /*
  * Defines for PCI based mac80211 Prism54 driver
@@ -68,7 +68,7 @@ struct p54p_csr {
 } __attribute__ ((packed));
 
 /* usb backend only needs the register defines above */
-#ifndef PRISM54USB_H
+#ifndef P54USB_H
 struct p54p_desc {
 	__le32 host_addr;
 	__le32 device_addr;
@@ -102,5 +102,5 @@ struct p54p_priv {
 	struct completion boot_comp;
 };
 
-#endif /* PRISM54USB_H */
-#endif /* PRISM54PCI_H */
+#endif /* P54USB_H */
+#endif /* P54PCI_H */
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-08-07 09:01:17.000000000 +0200
+++ b/drivers/net/wireless/p54/p54usb.c	2008-08-08 20:52:38.000000000 +0200
@@ -312,7 +312,7 @@ static int p54u_read_eeprom(struct ieee8
 
 	buf = kmalloc(0x2020, GFP_KERNEL);
 	if (!buf) {
-		printk(KERN_ERR "prism54usb: cannot allocate memory for "
+		printk(KERN_ERR "p54usb: cannot allocate memory for "
 		       "eeprom readback!\n");
 		return -ENOMEM;
 	}
@@ -321,7 +321,7 @@ static int p54u_read_eeprom(struct ieee8
 		*((u32 *) buf) = priv->common.rx_start;
 		err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, sizeof(u32));
 		if (err) {
-			printk(KERN_ERR "prism54usb: addr send failed\n");
+			printk(KERN_ERR "p54usb: addr send failed\n");
 			goto fail;
 		}
 	} else {
@@ -331,7 +331,7 @@ static int p54u_read_eeprom(struct ieee8
 		reg->val = cpu_to_le32(ISL38XX_DEV_INT_DATA);
 		err = p54u_bulk_msg(priv, P54U_PIPE_DEV, buf, sizeof(*reg));
 		if (err) {
-			printk(KERN_ERR "prism54usb: dev_int send failed\n");
+			printk(KERN_ERR "p54usb: dev_int send failed\n");
 			goto fail;
 		}
 	}
@@ -349,7 +349,7 @@ static int p54u_read_eeprom(struct ieee8
 	err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf,
 			    EEPROM_READBACK_LEN + priv->common.tx_hdr_len);
 	if (err) {
-		printk(KERN_ERR "prism54usb: eeprom req send failed\n");
+		printk(KERN_ERR "p54usb: eeprom req send failed\n");
 		goto fail;
 	}
 
@@ -359,7 +359,7 @@ static int p54u_read_eeprom(struct ieee8
 	if (!err && alen > offset) {
 		p54_parse_eeprom(dev, (u8 *)buf + offset, alen - offset);
 	} else {
-		printk(KERN_ERR "prism54usb: eeprom read failed!\n");
+		printk(KERN_ERR "p54usb: eeprom read failed!\n");
 		err = -EINVAL;
 		goto fail;
 	}
@@ -448,7 +448,7 @@ static int p54u_upload_firmware_3887(str
 
 		err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, block_size);
 		if (err) {
-			printk(KERN_ERR "prism54usb: firmware upload failed!\n");
+			printk(KERN_ERR "p54usb: firmware upload failed!\n");
 			goto err_upload_failed;
 		}
 
@@ -459,7 +459,7 @@ static int p54u_upload_firmware_3887(str
 	*((__le32 *)buf) = cpu_to_le32(~crc32_le(~0, fw_entry->data, fw_entry->size));
 	err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, sizeof(u32));
 	if (err) {
-		printk(KERN_ERR "prism54usb: firmware upload failed!\n");
+		printk(KERN_ERR "p54usb: firmware upload failed!\n");
 		goto err_upload_failed;
 	}
 
@@ -470,13 +470,13 @@ static int p54u_upload_firmware_3887(str
 			break;
 
 		if (alen > 5 && !memcmp(buf, "ERROR", 5)) {
-			printk(KERN_INFO "prism54usb: firmware upload failed!\n");
+			printk(KERN_INFO "p54usb: firmware upload failed!\n");
 			err = -EINVAL;
 			break;
 		}
 
 		if (time_after(jiffies, timeout)) {
-			printk(KERN_ERR "prism54usb: firmware boot timed out!\n");
+			printk(KERN_ERR "p54usb: firmware boot timed out!\n");
 			err = -ETIMEDOUT;
 			break;
 		}
@@ -488,7 +488,7 @@ static int p54u_upload_firmware_3887(str
 	buf[1] = '\r';
 	err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, 2);
 	if (err) {
-		printk(KERN_ERR "prism54usb: firmware boot failed!\n");
+		printk(KERN_ERR "p54usb: firmware boot failed!\n");
 		goto err_upload_failed;
 	}
 
@@ -650,7 +650,7 @@ static int p54u_upload_firmware_net2280(
 
 		err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, block_len);
 		if (err) {
-			printk(KERN_ERR "prism54usb: firmware block upload "
+			printk(KERN_ERR "p54usb: firmware block upload "
 			       "failed\n");
 			goto fail;
 		}
@@ -684,7 +684,7 @@ static int p54u_upload_firmware_net2280(
 			  0x002C | (unsigned long)&devreg->direct_mem_win);
 		if (!(reg & cpu_to_le32(ISL38XX_DMA_STATUS_DONE)) ||
 		    !(reg & cpu_to_le32(ISL38XX_DMA_STATUS_READY))) {
-			printk(KERN_ERR "prism54usb: firmware DMA transfer "
+			printk(KERN_ERR "p54usb: firmware DMA transfer "
 			       "failed\n");
 			goto fail;
 		}
@@ -792,7 +792,7 @@ static int __devinit p54u_probe(struct u
 
 	dev = p54_init_common(sizeof(*priv));
 	if (!dev) {
-		printk(KERN_ERR "prism54usb: ieee80211 alloc failed\n");
+		printk(KERN_ERR "p54usb: ieee80211 alloc failed\n");
 		return -ENOMEM;
 	}
 
@@ -848,7 +848,7 @@ static int __devinit p54u_probe(struct u
 	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
 		u8 perm_addr[ETH_ALEN];
 
-		printk(KERN_WARNING "prism54usb: Invalid hwaddr! Using randomly generated MAC addr\n");
+		printk(KERN_WARNING "p54usb: Invalid hwaddr! Using randomly generated MAC addr\n");
 		random_ether_addr(perm_addr);
 		SET_IEEE80211_PERM_ADDR(dev, perm_addr);
 	}
@@ -857,7 +857,7 @@ static int __devinit p54u_probe(struct u
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
-		printk(KERN_ERR "prism54usb: Cannot register netdevice\n");
+		printk(KERN_ERR "p54usb: Cannot register netdevice\n");
 		goto err_free_dev;
 	}
 
@@ -892,7 +892,7 @@ static void __devexit p54u_disconnect(st
 }
 
 static struct usb_driver p54u_driver = {
-	.name	= "prism54usb",
+	.name	= "p54usb",
 	.id_table = p54u_table,
 	.probe = p54u_probe,
 	.disconnect = p54u_disconnect,
diff -Nurp a/drivers/net/wireless/p54/p54usb.h b/drivers/net/wireless/p54/p54usb.h
--- a/drivers/net/wireless/p54/p54usb.h	2008-08-07 09:01:17.000000000 +0200
+++ b/drivers/net/wireless/p54/p54usb.h	2008-08-07 17:29:39.000000000 +0200
@@ -1,5 +1,5 @@
-#ifndef PRISM54USB_H
-#define PRISM54USB_H
+#ifndef P54USB_H
+#define P54USB_H
 
 /*
  * Defines for USB based mac80211 Prism54 driver
@@ -130,4 +130,4 @@ struct p54u_priv {
 	struct sk_buff_head rx_queue;
 };
 
-#endif /* PRISM54USB_H */
+#endif /* P54USB_H */

