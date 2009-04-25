Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:53362 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbZDYTML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 15:12:11 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] p54usb: rework driver for resume
Date: Sat, 25 Apr 2009 21:12:09 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200904252112.09381.chunkeey@web.de> (sfid-20090425_211214_754519_3756F344)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch redo the driver code so that p54usb no longer hangs
the kernel on resume.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,

for now this patch should be put in wireless-testing only.
I don't know if first generation devices will work after hibernation.

Regards,
	Chr
---
diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 44ab3cc..ec6c954 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -81,6 +81,29 @@ static struct usb_device_id p54u_table[] __devinitdata = {
 
 MODULE_DEVICE_TABLE(usb, p54u_table);
 
+static const struct {
+	u32 intf;
+	enum p54u_hw_type type;
+	char fw[FIRMWARE_NAME_MAX];
+	char fw_legacy[FIRMWARE_NAME_MAX];
+	char hw[20];
+} p54u_fwlist[__NUM_P54U_HWTYPES] = {
+	{
+		.type = P54U_NET2280,
+		.intf = FW_LM86,
+		.fw = "isl3886usb",
+		.fw_legacy = "isl3890usb",
+		.hw = "ISL3886 + net2280",
+	},
+	{
+		.type = P54U_3887,
+		.intf = FW_LM87,
+		.fw = "isl3887usb",
+		.fw_legacy = "isl3887usb_bare",
+		.hw = "ISL3887",
+	},
+};
+
 static void p54u_rx_cb(struct urb *urb)
 {
 	struct sk_buff *skb = (struct sk_buff *) urb->context;
@@ -125,11 +148,7 @@ static void p54u_rx_cb(struct urb *urb)
 		}
 		skb_reset_tail_pointer(skb);
 		skb_trim(skb, 0);
-		if (urb->transfer_buffer != skb_tail_pointer(skb)) {
-			/* this should not happen */
-			WARN_ON(1);
-			urb->transfer_buffer = skb_tail_pointer(skb);
-		}
+		urb->transfer_buffer = skb_tail_pointer(skb);
 	}
 	skb_queue_tail(&priv->rx_queue, skb);
 	usb_anchor_urb(urb, &priv->submitted);
@@ -378,20 +397,16 @@ static int p54u_bulk_msg(struct p54u_priv *priv, unsigned int ep,
 			    data, len, &alen, 2000);
 }
 
-static const char p54u_romboot_3887[] = "~~~~";
-static const char p54u_firmware_upload_3887[] = "<\r";
-
-static int p54u_device_reset_3887(struct ieee80211_hw *dev)
+static int p54u_device_reset(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
 	int ret, lock = (priv->intf->condition != USB_INTERFACE_BINDING);
-	u8 buf[4];
 
 	if (lock) {
 		ret = usb_lock_device_for_reset(priv->udev, priv->intf);
 		if (ret < 0) {
 			dev_err(&priv->udev->dev, "(p54usb) unable to lock "
-				" device for reset: %d\n", ret);
+				"device for reset (%d)!\n", ret);
 			return ret;
 		}
 	}
@@ -400,26 +415,34 @@ static int p54u_device_reset_3887(struct ieee80211_hw *dev)
 	if (lock)
 		usb_unlock_device(priv->udev);
 
-	if (ret) {
+	if (ret)
 		dev_err(&priv->udev->dev, "(p54usb) unable to reset "
-			"device: %d\n", ret);
-		return ret;
-	}
+			"device (%d)!\n", ret);
+
+	return ret;
+}
+
+static const char p54u_romboot_3887[] = "~~~~";
+static int p54u_firmware_reset_3887(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+	u8 buf[4];
+	int ret;
 
 	memcpy(&buf, p54u_romboot_3887, sizeof(buf));
 	ret = p54u_bulk_msg(priv, P54U_PIPE_DATA,
 			    buf, sizeof(buf));
 	if (ret)
 		dev_err(&priv->udev->dev, "(p54usb) unable to jump to "
-			"boot ROM: %d\n", ret);
+			"boot ROM (%d)!\n", ret);
 
 	return ret;
 }
 
+static const char p54u_firmware_upload_3887[] = "<\r";
 static int p54u_upload_firmware_3887(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
-	const struct firmware *fw_entry = NULL;
 	int err, alen;
 	u8 carry = 0;
 	u8 *buf, *tmp;
@@ -428,51 +451,29 @@ static int p54u_upload_firmware_3887(struct ieee80211_hw *dev)
 	struct x2_header *hdr;
 	unsigned long timeout;
 
+	err = p54u_firmware_reset_3887(dev);
+	if (err)
+		return err;
+
 	tmp = buf = kmalloc(P54U_FW_BLOCK, GFP_KERNEL);
 	if (!buf) {
 		dev_err(&priv->udev->dev, "(p54usb) cannot allocate firmware"
 					  "upload buffer!\n");
-		err = -ENOMEM;
-		goto err_bufalloc;
-	}
-
-	err = p54u_device_reset_3887(dev);
-	if (err)
-		goto err_reset;
-
-	err = request_firmware(&fw_entry, "isl3887usb", &priv->udev->dev);
-	if (err) {
-		dev_err(&priv->udev->dev, "p54usb: cannot find firmware "
-					  "(isl3887usb)\n");
-		err = request_firmware(&fw_entry, "isl3887usb_bare",
-			&priv->udev->dev);
-		if (err)
-			goto err_req_fw_failed;
-	}
-
-	err = p54_parse_firmware(dev, fw_entry);
-	if (err)
-		goto err_upload_failed;
-
-	if (priv->common.fw_interface != FW_LM87) {
-		dev_err(&priv->udev->dev, "wrong firmware, "
-			"please get a LM87 firmware and try again.\n");
-		err = -EINVAL;
-		goto err_upload_failed;
+		return -ENOMEM;
 	}
 
-	left = block_size = min((size_t)P54U_FW_BLOCK, fw_entry->size);
+	left = block_size = min((size_t)P54U_FW_BLOCK, priv->fw->size);
 	strcpy(buf, p54u_firmware_upload_3887);
 	left -= strlen(p54u_firmware_upload_3887);
 	tmp += strlen(p54u_firmware_upload_3887);
 
-	data = fw_entry->data;
-	remains = fw_entry->size;
+	data = priv->fw->data;
+	remains = priv->fw->size;
 
 	hdr = (struct x2_header *)(buf + strlen(p54u_firmware_upload_3887));
 	memcpy(hdr->signature, X2_SIGNATURE, X2_SIGNATURE_SIZE);
 	hdr->fw_load_addr = cpu_to_le32(ISL38XX_DEV_FIRMWARE_ADDR);
-	hdr->fw_length = cpu_to_le32(fw_entry->size);
+	hdr->fw_length = cpu_to_le32(priv->fw->size);
 	hdr->crc = cpu_to_le32(~crc32_le(~0, (void *)&hdr->fw_load_addr,
 					 sizeof(u32)*2));
 	left -= sizeof(*hdr);
@@ -514,7 +515,8 @@ static int p54u_upload_firmware_3887(struct ieee80211_hw *dev)
 		left = block_size = min((unsigned int)P54U_FW_BLOCK, remains);
 	}
 
-	*((__le32 *)buf) = cpu_to_le32(~crc32_le(~0, fw_entry->data, fw_entry->size));
+	*((__le32 *)buf) = cpu_to_le32(~crc32_le(~0, priv->fw->data,
+						 priv->fw->size));
 	err = p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, sizeof(u32));
 	if (err) {
 		dev_err(&priv->udev->dev, "(p54usb) firmware upload failed!\n");
@@ -565,19 +567,14 @@ static int p54u_upload_firmware_3887(struct ieee80211_hw *dev)
 	if (err)
 		goto err_upload_failed;
 
-  err_upload_failed:
-	release_firmware(fw_entry);
-  err_req_fw_failed:
-  err_reset:
+err_upload_failed:
 	kfree(buf);
-  err_bufalloc:
 	return err;
 }
 
 static int p54u_upload_firmware_net2280(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
-	const struct firmware *fw_entry = NULL;
 	const struct p54p_csr *devreg = (const struct p54p_csr *) P54U_DEV_BASE;
 	int err, alen;
 	void *buf;
@@ -592,33 +589,6 @@ static int p54u_upload_firmware_net2280(struct ieee80211_hw *dev)
 		return -ENOMEM;
 	}
 
-	err = request_firmware(&fw_entry, "isl3886usb", &priv->udev->dev);
-	if (err) {
-		dev_err(&priv->udev->dev, "(p54usb) cannot find firmware "
-					  "(isl3886usb)\n");
-		err = request_firmware(&fw_entry, "isl3890usb",
-			&priv->udev->dev);
-		if (err) {
-			kfree(buf);
-			return err;
-			}
-	}
-
-	err = p54_parse_firmware(dev, fw_entry);
-	if (err) {
-		kfree(buf);
-		release_firmware(fw_entry);
-		return err;
-	}
-
-	if (priv->common.fw_interface != FW_LM86) {
-		dev_err(&priv->udev->dev, "wrong firmware, "
-			"please get a LM86(USB) firmware and try again.\n");
-		kfree(buf);
-		release_firmware(fw_entry);
-		return -EINVAL;
-	}
-
 #define P54U_WRITE(type, addr, data) \
 	do {\
 		err = p54u_write(priv, buf, type,\
@@ -718,8 +688,8 @@ static int p54u_upload_firmware_net2280(struct ieee80211_hw *dev)
 	P54U_WRITE(NET2280_DEV_U32, &devreg->int_ack, reg);
 
 	/* finally, we can upload firmware now! */
-	remains = fw_entry->size;
-	data = fw_entry->data;
+	remains = priv->fw->size;
+	data = priv->fw->data;
 	offset = ISL38XX_DEV_FIRMWARE_ADDR;
 
 	while (remains) {
@@ -828,12 +798,54 @@ static int p54u_upload_firmware_net2280(struct ieee80211_hw *dev)
 #undef P54U_WRITE
 #undef P54U_READ
 
- fail:
-	release_firmware(fw_entry);
+fail:
 	kfree(buf);
 	return err;
 }
 
+static int p54u_load_firmware(struct ieee80211_hw *dev)
+{
+	struct p54u_priv *priv = dev->priv;
+	int err, i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(p54u_fwlist) != __NUM_P54U_HWTYPES);
+
+	for (i = 0; i < __NUM_P54U_HWTYPES; i++)
+		if (p54u_fwlist[i].type == priv->hw_type)
+			break;
+
+	if (i == __NUM_P54U_HWTYPES)
+		return -EOPNOTSUPP;
+
+	err = request_firmware(&priv->fw, p54u_fwlist[i].fw, &priv->udev->dev);
+	if (err) {
+		dev_err(&priv->udev->dev, "(p54usb) cannot load firmware %s "
+					  "(%d)!\n", p54u_fwlist[i].fw, err);
+
+		err = request_firmware(&priv->fw, p54u_fwlist[i].fw_legacy,
+				       &priv->udev->dev);
+		if (err)
+			return err;
+	}
+
+	err = p54_parse_firmware(dev, priv->fw);
+	if (err)
+		goto out;
+
+	if (priv->common.fw_interface != p54u_fwlist[i].intf) {
+		dev_err(&priv->udev->dev, "wrong firmware, please get "
+			"a firmware for \"%s\" and try again.\n",
+			p54u_fwlist[i].hw);
+		err = -EINVAL;
+	}
+
+out:
+	if (err)
+		release_firmware(priv->fw);
+
+	return err;
+}
+
 static int p54u_open(struct ieee80211_hw *dev)
 {
 	struct p54u_priv *priv = dev->priv;
@@ -875,6 +887,7 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 	}
 
 	priv = dev->priv;
+	priv->hw_type = P54U_INVALID_HW;
 
 	SET_IEEE80211_DEV(dev, &intf->dev);
 	usb_set_intfdata(intf, dev);
@@ -906,34 +919,46 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 	priv->common.open = p54u_open;
 	priv->common.stop = p54u_stop;
 	if (recognized_pipes < P54U_PIPE_NUMBER) {
+		/* ISL3887 needs a full reset on resume */
+		udev->reset_resume = 1;
+		err = p54u_device_reset(dev);
+
 		priv->hw_type = P54U_3887;
 		dev->extra_tx_headroom += sizeof(struct lm87_tx_hdr);
 		priv->common.tx_hdr_len = sizeof(struct lm87_tx_hdr);
 		priv->common.tx = p54u_tx_lm87;
-		err = p54u_upload_firmware_3887(dev);
+		priv->upload_fw = p54u_upload_firmware_3887;
 	} else {
 		priv->hw_type = P54U_NET2280;
 		dev->extra_tx_headroom += sizeof(struct net2280_tx_hdr);
 		priv->common.tx_hdr_len = sizeof(struct net2280_tx_hdr);
 		priv->common.tx = p54u_tx_net2280;
-		err = p54u_upload_firmware_net2280(dev);
+		priv->upload_fw = p54u_upload_firmware_net2280;
 	}
+	err = p54u_load_firmware(dev);
 	if (err)
 		goto err_free_dev;
 
+	err = priv->upload_fw(dev);
+	if (err)
+		goto err_free_fw;
+
 	p54u_open(dev);
 	err = p54_read_eeprom(dev);
 	p54u_stop(dev);
 	if (err)
-		goto err_free_dev;
+		goto err_free_fw;
 
 	err = p54_register_common(dev, &udev->dev);
 	if (err)
-		goto err_free_dev;
+		goto err_free_fw;
 
 	return 0;
 
- err_free_dev:
+err_free_fw:
+	release_firmware(priv->fw);
+
+err_free_dev:
 	ieee80211_free_hw(dev);
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(udev);
@@ -952,20 +977,64 @@ static void __devexit p54u_disconnect(struct usb_interface *intf)
 
 	priv = dev->priv;
 	usb_put_dev(interface_to_usbdev(intf));
+	release_firmware(priv->fw);
 	p54_free_common(dev);
 	ieee80211_free_hw(dev);
 }
 
 static int p54u_pre_reset(struct usb_interface *intf)
 {
+	struct ieee80211_hw *dev = usb_get_intfdata(intf);
+
+	if (!dev)
+		return -ENODEV;
+
+	p54u_stop(dev);
 	return 0;
 }
 
+static int p54u_resume(struct usb_interface *intf)
+{
+	struct ieee80211_hw *dev = usb_get_intfdata(intf);
+	struct p54u_priv *priv;
+
+	if (!dev)
+		return -ENODEV;
+
+	priv = dev->priv;
+	if (unlikely(!(priv->upload_fw && priv->fw)))
+		return 0;
+
+	return priv->upload_fw(dev);
+}
+
 static int p54u_post_reset(struct usb_interface *intf)
 {
+	struct ieee80211_hw *dev = usb_get_intfdata(intf);
+	struct p54u_priv *priv;
+	int err;
+
+	err = p54u_resume(intf);
+	if (err)
+		return err;
+
+	/* reinitialize old device state */
+	priv = dev->priv;
+	if (priv->common.mode != NL80211_IFTYPE_UNSPECIFIED)
+		ieee80211_restart_hw(dev);
+
 	return 0;
 }
 
+#ifdef CONFIG_PM
+
+static int p54u_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	return p54u_pre_reset(intf);
+}
+
+#endif /* CONFIG_PM */
+
 static struct usb_driver p54u_driver = {
 	.name	= "p54usb",
 	.id_table = p54u_table,
@@ -973,6 +1042,11 @@ static struct usb_driver p54u_driver = {
 	.disconnect = p54u_disconnect,
 	.pre_reset = p54u_pre_reset,
 	.post_reset = p54u_post_reset,
+#ifdef CONFIG_PM
+	.suspend = p54u_suspend,
+	.resume = p54u_resume,
+	.reset_resume = p54u_resume,
+#endif /* CONFIG_PM */
 	.soft_unbind = 1,
 };
 
diff --git a/drivers/net/wireless/p54/p54usb.h b/drivers/net/wireless/p54/p54usb.h
index 8bc5898..e935b79 100644
--- a/drivers/net/wireless/p54/p54usb.h
+++ b/drivers/net/wireless/p54/p54usb.h
@@ -123,18 +123,26 @@ struct p54u_rx_info {
 	struct ieee80211_hw *dev;
 };
 
+enum p54u_hw_type {
+	P54U_INVALID_HW,
+	P54U_NET2280,
+	P54U_3887,
+
+	/* keep last */
+	__NUM_P54U_HWTYPES,
+};
+
 struct p54u_priv {
 	struct p54_common common;
 	struct usb_device *udev;
 	struct usb_interface *intf;
-	enum {
-		P54U_NET2280 = 0,
-		P54U_3887
-	} hw_type;
+	int (*upload_fw)(struct ieee80211_hw *dev);
 
+	enum p54u_hw_type hw_type;
 	spinlock_t lock;
 	struct sk_buff_head rx_queue;
 	struct usb_anchor submitted;
+	const struct firmware *fw;
 };
 
 #endif /* P54USB_H */
