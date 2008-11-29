Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:50022 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbYK2VjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 16:39:11 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] p54: per-device names
Date: Sat, 29 Nov 2008 22:39:08 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811292239.09296.chunkeey@web.de> (sfid-20081129_223916_056485_631E682A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces the static "p54:" strings in front of most printk's
with their corresponding per-device names.

It was always a bit of a hassle to check which device was
generating all the messages. 

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-29 21:34:26.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-29 21:34:31.000000000 +0100
@@ -158,21 +158,21 @@ int p54_parse_firmware(struct ieee80211_
 			priv->fw_interface = be32_to_cpup((__be32 *)
 					     bootrec->data);
 			switch (priv->fw_interface) {
-			case FW_FMAC:
-				printk(KERN_INFO "p54: FreeMAC firmware\n");
-				break;
-			case FW_LM20:
-				printk(KERN_INFO "p54: LM20 firmware\n");
-				break;
 			case FW_LM86:
-				printk(KERN_INFO "p54: LM86 firmware\n");
-				break;
-			case FW_LM87:
-				printk(KERN_INFO "p54: LM87 firmware\n");
+			case FW_LM20:
+			case FW_LM87: {
+				char *iftype = (char *)bootrec->data;
+				printk(KERN_INFO "%s: p54 detected a LM%c%c "
+						 "firmware\n",
+					wiphy_name(dev->wiphy),
+					iftype[2], iftype[3]);
 				break;
+				}
+			case FW_FMAC:
 			default:
-				printk(KERN_INFO "p54: unknown firmware\n");
-				break;
+				printk(KERN_ERR "%s: unsupported firmware\n",
+					wiphy_name(dev->wiphy));
+				return -ENODEV;
 			}
 			break;
 		case BR_CODE_COMPONENT_VERSION:
@@ -216,13 +216,15 @@ int p54_parse_firmware(struct ieee80211_
 	}
 
 	if (fw_version)
-		printk(KERN_INFO "p54: FW rev %s - Softmac protocol %x.%x\n",
-			fw_version, priv->fw_var >> 8, priv->fw_var & 0xff);
+		printk(KERN_INFO "%s: FW rev %s - Softmac protocol %x.%x\n",
+			wiphy_name(dev->wiphy), fw_version,
+			priv->fw_var >> 8, priv->fw_var & 0xff);
 
 	if (priv->fw_var < 0x500)
-		printk(KERN_INFO "p54: you are using an obsolete firmware. "
+		printk(KERN_INFO "%s: you are using an obsolete firmware. "
 		       "visit http://wireless.kernel.org/en/users/Drivers/p54 "
-		       "and grab one for \"kernel >= 2.6.28\"!\n");
+		       "and grab one for \"kernel >= 2.6.28\"!\n",
+			wiphy_name(dev->wiphy));
 
 	if (priv->fw_var >= 0x300) {
 		/* Firmware supports QoS, use it! */
@@ -400,8 +402,9 @@ static int p54_parse_eeprom(struct ieee8
 				err = p54_convert_rev1(dev, curve_data);
 				break;
 			default:
-				printk(KERN_ERR "p54: unknown curve data "
+				printk(KERN_ERR "%s: unknown curve data "
 						"revision %d\n",
+						wiphy_name(dev->wiphy),
 						curve_data->cal_method_rev);
 				err = -ENODEV;
 				break;
@@ -461,7 +464,8 @@ static int p54_parse_eeprom(struct ieee8
 		case PDR_PER_CHANNEL_BASEBAND_REGISTERS:
 			break;
 		default:
-			printk(KERN_INFO "p54: unknown eeprom code : 0x%x\n",
+			printk(KERN_INFO "%s: unknown eeprom code : 0x%x\n",
+				wiphy_name(dev->wiphy),
 				le16_to_cpu(entry->code));
 			break;
 		}
@@ -471,7 +475,8 @@ static int p54_parse_eeprom(struct ieee8
 
 	if (!synth || !priv->iq_autocal || !priv->output_limit ||
 	    !priv->curve_data) {
-		printk(KERN_ERR "p54: not all required entries found in eeprom!\n");
+		printk(KERN_ERR "%s: not all required entries found in eeprom!\n",
+			wiphy_name(dev->wiphy));
 		err = -EINVAL;
 		goto err;
 	}
@@ -516,7 +521,8 @@ static int p54_parse_eeprom(struct ieee8
 		priv->curve_data = NULL;
 	}
 
-	printk(KERN_ERR "p54: eeprom parse failed!\n");
+	printk(KERN_ERR "%s: eeprom parse failed!\n",
+		wiphy_name(dev->wiphy));
 	return err;
 }
 
@@ -1574,28 +1580,23 @@ static int p54_beacon_tim(struct sk_buff
 	struct ieee80211_mgmt *mgmt = (void *)skb->data;
 	u8 *pos, *end;
 
-	if (skb->len <= sizeof(mgmt)) {
-		printk(KERN_ERR "p54: beacon is too short!\n");
+	if (skb->len <= sizeof(mgmt))
 		return -EINVAL;
-	}
 
 	pos = (u8 *)mgmt->u.beacon.variable;
 	end = skb->data + skb->len;
 	while (pos < end) {
-		if (pos + 2 + pos[1] > end) {
-			printk(KERN_ERR "p54: parsing beacon failed\n");
+		if (pos + 2 + pos[1] > end)
 			return -EINVAL;
-		}
 
 		if (pos[0] == WLAN_EID_TIM) {
 			u8 dtim_len = pos[1];
 			u8 dtim_period = pos[3];
 			u8 *next = pos + 2 + dtim_len;
 
-			if (dtim_len < 3) {
-				printk(KERN_ERR "p54: invalid dtim len!\n");
+			if (dtim_len < 3)
 				return -EINVAL;
-			}
+
 			memmove(pos, next, end - next);
 
 			if (dtim_len > 3)
diff -Nurp a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-11-26 21:32:21.000000000 +0100
+++ b/drivers/net/wireless/p54/p54usb.c	2008-11-28 22:25:45.000000000 +0100
@@ -405,7 +405,8 @@ static int p54u_upload_firmware_3887(str
 
 	tmp = buf = kmalloc(P54U_FW_BLOCK, GFP_KERNEL);
 	if (!buf) {
-		printk(KERN_ERR "p54usb: cannot allocate firmware upload buffer!\n");
+		dev_err(&priv->udev->dev, "(p54usb) cannot allocate firmware"
+					  "upload buffer!\n");
 		err = -ENOMEM;
 		goto err_bufalloc;
 	}
@@ -413,13 +414,14 @@ static int p54u_upload_firmware_3887(str
 	memcpy(buf, start_string, 4);
 	err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, 4);
 	if (err) {
-		printk(KERN_ERR "p54usb: reset failed! (%d)\n", err);
+		dev_err(&priv->udev->dev, "(p54usb) reset failed! (%d)\n", err);
 		goto err_reset;
 	}
 
 	err = request_firmware(&fw_entry, "isl3887usb", &priv->udev->dev);
 	if (err) {
-		printk(KERN_ERR "p54usb: cannot find firmware (isl3887usb)\n");
+		dev_err(&priv->udev->dev, "p54usb: cannot find firmware "
+					  "(isl3887usb)\n");
 		err = request_firmware(&fw_entry, "isl3887usb_bare",
 			&priv->udev->dev);
 		if (err)
@@ -474,7 +476,8 @@ static int p54u_upload_firmware_3887(str
 
 		err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, block_size);
 		if (err) {
-			printk(KERN_ERR "p54usb: firmware upload failed!\n");
+			dev_err(&priv->udev->dev, "(p54usb) firmware "
+						  "upload failed!\n");
 			goto err_upload_failed;
 		}
 
@@ -485,10 +488,9 @@ static int p54u_upload_firmware_3887(str
 	*((__le32 *)buf) = cpu_to_le32(~crc32_le(~0, fw_entry->data, fw_entry->size));
 	err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, sizeof(u32));
 	if (err) {
-		printk(KERN_ERR "p54usb: firmware upload failed!\n");
+		dev_err(&priv->udev->dev, "(p54usb) firmware upload failed!\n");
 		goto err_upload_failed;
 	}
-
 	timeout = jiffies + msecs_to_jiffies(1000);
 	while (!(err = usb_bulk_msg(priv->udev,
 		usb_rcvbulkpipe(priv->udev, P54U_PIPE_DATA), buf, 128, &alen, 1000))) {
@@ -496,25 +498,27 @@ static int p54u_upload_firmware_3887(str
 			break;
 
 		if (alen > 5 && !memcmp(buf, "ERROR", 5)) {
-			printk(KERN_INFO "p54usb: firmware upload failed!\n");
 			err = -EINVAL;
 			break;
 		}
 
 		if (time_after(jiffies, timeout)) {
-			printk(KERN_ERR "p54usb: firmware boot timed out!\n");
+			dev_err(&priv->udev->dev, "(p54usb) firmware boot "
+						  "timed out!\n");
 			err = -ETIMEDOUT;
 			break;
 		}
 	}
-	if (err)
+	if (err) {
+		dev_err(&priv->udev->dev, "(p54usb) firmware upload failed!\n");
 		goto err_upload_failed;
+	}
 
 	buf[0] = 'g';
 	buf[1] = '\r';
 	err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, 2);
 	if (err) {
-		printk(KERN_ERR "p54usb: firmware boot failed!\n");
+		dev_err(&priv->udev->dev, "(p54usb) firmware boot failed!\n");
 		goto err_upload_failed;
 	}
 
@@ -554,13 +558,15 @@ static int p54u_upload_firmware_net2280(
 
 	buf = kmalloc(512, GFP_KERNEL);
 	if (!buf) {
-		printk(KERN_ERR "p54usb: firmware buffer alloc failed!\n");
+		dev_err(&priv->udev->dev, "(p54usb) firmware buffer "
+					  "alloc failed!\n");
 		return -ENOMEM;
 	}
 
 	err = request_firmware(&fw_entry, "isl3886usb", &priv->udev->dev);
 	if (err) {
-		printk(KERN_ERR "p54usb: cannot find firmware (isl3886usb)\n");
+		dev_err(&priv->udev->dev, "(p54usb) cannot find firmware "
+					  "(isl3886usb)\n");
 		err = request_firmware(&fw_entry, "isl3890usb",
 			&priv->udev->dev);
 		if (err) {
@@ -685,8 +691,8 @@ static int p54u_upload_firmware_net2280(
 
 		err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, block_len);
 		if (err) {
-			printk(KERN_ERR "p54usb: firmware block upload "
-			       "failed\n");
+			dev_err(&priv->udev->dev, "(p54usb) firmware block "
+						  "upload failed\n");
 			goto fail;
 		}
 
@@ -719,8 +725,8 @@ static int p54u_upload_firmware_net2280(
 			  0x002C | (unsigned long)&devreg->direct_mem_win);
 		if (!(reg & cpu_to_le32(ISL38XX_DMA_STATUS_DONE)) ||
 		    !(reg & cpu_to_le32(ISL38XX_DMA_STATUS_READY))) {
-			printk(KERN_ERR "p54usb: firmware DMA transfer "
-			       "failed\n");
+			dev_err(&priv->udev->dev, "(p54usb) firmware DMA "
+						  "transfer failed\n");
 			goto fail;
 		}
 
@@ -826,8 +832,9 @@ static int __devinit p54u_probe(struct u
 	DECLARE_MAC_BUF(mac);
 
 	dev = p54_init_common(sizeof(*priv));
+
 	if (!dev) {
-		printk(KERN_ERR "p54usb: ieee80211 alloc failed\n");
+		dev_err(&udev->dev, "(p54usb) ieee80211 alloc failed\n");
 		return -ENOMEM;
 	}
 
@@ -888,7 +895,7 @@ static int __devinit p54u_probe(struct u
 
 	err = ieee80211_register_hw(dev);
 	if (err) {
-		printk(KERN_ERR "p54usb: Cannot register netdevice\n");
+		dev_err(&udev->dev, "(p54usb) Cannot register netdevice\n");
 		goto err_free_dev;
 	}
 
