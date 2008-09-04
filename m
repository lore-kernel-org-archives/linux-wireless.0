Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:56587 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbYIDK03 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2008 06:26:29 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2] p54usb: support LM87 firmwares
Date: Thu, 4 Sep 2008 12:29:38 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Tomas Winkler <tomasw@gmail.com>
References: <200809022139.12969.chunkeey@web.de> <200809030200.50745.chunkeey@web.de> <1220492662.7700.21.camel@dv>
In-Reply-To: <1220492662.7700.21.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809041229.38538.chunkeey@web.de> (sfid-20080904_122640_618844_A0948F6A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch adds the necessary changes to support LM87 firmwares.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
as you can see, the *(__be32 *) cast is now gone ;-)
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c 
b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-09-01 22:25:35.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-09-04 12:02:51.000000000 +0200
@@ -93,7 +93,8 @@ int p54_parse_firmware(struct ieee80211_
 		u32 code = le32_to_cpu(bootrec->code);
 		switch (code) {
 		case BR_CODE_COMPONENT_ID:
-			switch (be32_to_cpu(*(__be32 *)bootrec->data)) {
+			priv->fw_interface = be32_to_cpup(bootrec->data);
+			switch (priv->fw_interface) {
 			case FW_FMAC:
 				printk(KERN_INFO "p54: FreeMAC firmware\n");
 				break;
@@ -104,7 +105,7 @@ int p54_parse_firmware(struct ieee80211_
 				printk(KERN_INFO "p54: LM86 firmware\n");
 				break;
 			case FW_LM87:
-				printk(KERN_INFO "p54: LM87 firmware - not supported yet!\n");
+				printk(KERN_INFO "p54: LM87 firmware\n");
 				break;
 			default:
 				printk(KERN_INFO "p54: unknown firmware\n");
diff -Nurp a/drivers/net/wireless/p54/p54common.h 
b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-09-01 01:56:53.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.h	2008-09-02 19:39:10.000000000 +0200
@@ -50,11 +50,6 @@ struct bootrec_desc {
 #define BR_CODE_END_OF_BRA		0xFF0000FF
 #define LEGACY_BR_CODE_END_OF_BRA	0xFFFFFFFF
 
-#define FW_FMAC 0x464d4143
-#define FW_LM86 0x4c4d3836
-#define FW_LM87 0x4c4d3837
-#define FW_LM20 0x4c4d3230
-
 /* PDA defines are Copyright (C) 2005 Nokia Corporation (taken from 
islsm_pda.h) */
 
 struct pda_entry {
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-09-01 02:20:25.000000000 +0200
+++ b/drivers/net/wireless/p54/p54.h	2008-09-02 19:39:26.000000000 +0200
@@ -42,6 +42,11 @@ struct p54_control_hdr {
 
 #define ISL38XX_DEV_FIRMWARE_ADDR 0x20000
 
+#define FW_FMAC 0x464d4143
+#define FW_LM86 0x4c4d3836
+#define FW_LM87 0x4c4d3837
+#define FW_LM20 0x4c4d3230
+
 struct p54_common {
 	u32 rx_start;
 	u32 rx_end;
@@ -68,6 +73,7 @@ struct p54_common {
 	unsigned int tx_hdr_len;
 	void *cached_vdcf;
 	unsigned int fw_var;
+	unsigned int fw_interface;
 	struct ieee80211_tx_queue_stats tx_stats[8];
 	void *eeprom;
 	struct completion eeprom_comp;
diff -Nurp a/drivers/net/wireless/p54/p54usb.c 
b/drivers/net/wireless/p54/p54usb.c
--- a/drivers/net/wireless/p54/p54usb.c	2008-09-01 22:23:46.000000000 +0200
+++ b/drivers/net/wireless/p54/p54usb.c	2008-09-02 21:28:36.000000000 +0200
@@ -91,8 +91,13 @@ static void p54u_rx_cb(struct urb *urb)
 
 	skb_unlink(skb, &priv->rx_queue);
 	skb_put(skb, urb->actual_length);
-	if (!priv->hw_type)
-		skb_pull(skb, sizeof(struct net2280_tx_hdr));
+
+	if (priv->hw_type == P54U_NET2280)
+		skb_pull(skb, priv->common.tx_hdr_len);
+	if (priv->common.fw_interface == FW_LM87) {
+		skb_pull(skb, 4);
+		skb_put(skb, 4);
+	}
 
 	if (p54_rx(dev, skb)) {
 		skb = dev_alloc_skb(priv->common.rx_mtu + 32);
@@ -109,9 +114,12 @@ static void p54u_rx_cb(struct urb *urb)
 		urb->context = skb;
 		skb_queue_tail(&priv->rx_queue, skb);
 	} else {
-		if (!priv->hw_type)
-			skb_push(skb, sizeof(struct net2280_tx_hdr));
-
+		if (priv->hw_type == P54U_NET2280)
+			skb_push(skb, priv->common.tx_hdr_len);
+		if (priv->common.fw_interface == FW_LM87) {
+			skb_push(skb, 4);
+			skb_put(skb, 4);
+		}
 		skb_reset_tail_pointer(skb);
 		skb_trim(skb, 0);
 		if (urb->transfer_buffer != skb_tail_pointer(skb)) {
@@ -210,6 +218,42 @@ static void p54u_tx_3887(struct ieee8021
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
 
+__le32 p54u_lm87_chksum(const u32 *data, size_t length)
+{
+	__le32 chk = 0;
+
+	length >>= 2;
+	while (length--) {
+		chk ^= cpu_to_le32(*data++);
+		chk = (chk >> 5) ^ (chk << 3);
+	}
+
+	return chk;
+}
+
+static void p54u_tx_lm87(struct ieee80211_hw *dev,
+			 struct p54_control_hdr *data,
+			 size_t len, int free_on_tx)
+{
+	struct p54u_priv *priv = dev->priv;
+	struct urb *data_urb;
+	struct lm87_tx_hdr *hdr = (void *)data - sizeof(*hdr);
+
+	data_urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!data_urb)
+		return;
+
+	hdr->chksum = p54u_lm87_chksum((u32 *)data, len);
+	hdr->device_addr = data->req_id;
+
+	usb_fill_bulk_urb(data_urb, priv->udev,
+		usb_sndbulkpipe(priv->udev, P54U_PIPE_DATA), hdr,
+		len + sizeof(*hdr), free_on_tx ? p54u_tx_free_cb : p54u_tx_cb,
+		dev);
+
+	usb_submit_urb(data_urb, GFP_ATOMIC);
+}
+
 static void p54u_tx_net2280(struct ieee80211_hw *dev, struct p54_control_hdr 
*data,
 			    size_t len, int free_on_tx)
 {
@@ -776,21 +820,23 @@ static int __devinit p54u_probe(struct u
 		}
 	}
 	priv->common.open = p54u_open;
-
+	priv->common.stop = p54u_stop;
 	if (recognized_pipes < P54U_PIPE_NUMBER) {
 		priv->hw_type = P54U_3887;
-		priv->common.tx = p54u_tx_3887;
+		err = p54u_upload_firmware_3887(dev);
+		if (priv->common.fw_interface == FW_LM87) {
+			dev->extra_tx_headroom += sizeof(struct lm87_tx_hdr);
+			priv->common.tx_hdr_len = sizeof(struct lm87_tx_hdr);
+			priv->common.tx = p54u_tx_lm87;
+		} else
+			priv->common.tx = p54u_tx_3887;
 	} else {
+		priv->hw_type = P54U_NET2280;
 		dev->extra_tx_headroom += sizeof(struct net2280_tx_hdr);
 		priv->common.tx_hdr_len = sizeof(struct net2280_tx_hdr);
 		priv->common.tx = p54u_tx_net2280;
-	}
-	priv->common.stop = p54u_stop;
-
-	if (priv->hw_type)
-		err = p54u_upload_firmware_3887(dev);
-	else
 		err = p54u_upload_firmware_net2280(dev);
+	}
 	if (err)
 		goto err_free_dev;
 
diff -Nurp a/drivers/net/wireless/p54/p54usb.h 
b/drivers/net/wireless/p54/p54usb.h
--- a/drivers/net/wireless/p54/p54usb.h	2008-09-01 01:56:53.000000000 +0200
+++ b/drivers/net/wireless/p54/p54usb.h	2008-09-02 19:23:52.000000000 +0200
@@ -72,6 +72,11 @@ struct net2280_tx_hdr {
 	u8 padding[8];
 } __attribute__((packed));
 
+struct lm87_tx_hdr {
+	__le32 device_addr;
+	__le32 chksum;
+} __attribute__((packed));
+
 /* Some flags for the isl hardware registers controlling DMA inside the
  * chip */
 #define ISL38XX_DMA_STATUS_DONE			0x00000001


