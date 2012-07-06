Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23801 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab2GFUA3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 16:00:29 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 30/33] NFC: Add initial Sony RC-S360 support to pn533
Date: Fri,  6 Jul 2012 22:09:50 +0200
Message-Id: <1341605393-32056-31-git-send-email-sameo@linux.intel.com> (sfid-20120706_220534_505517_1248CCEB)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sony RC-S360 is also known as the Sony PaSoRi contactless reader.
Only type 2, 3 and 4 tag reading is supported at the moment.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/pn533.c |  219 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 181 insertions(+), 38 deletions(-)

diff --git a/drivers/nfc/pn533.c b/drivers/nfc/pn533.c
index 9ac829e..37786ff 100644
--- a/drivers/nfc/pn533.c
+++ b/drivers/nfc/pn533.c
@@ -38,9 +38,42 @@
 #define SCM_VENDOR_ID 0x4E6
 #define SCL3711_PRODUCT_ID 0x5591
 
+#define SONY_VENDOR_ID         0x054c
+#define PASORI_PRODUCT_ID      0x02e1
+
+#define PN533_QUIRKS_TYPE_A          BIT(0)
+#define PN533_QUIRKS_TYPE_F          BIT(1)
+#define PN533_QUIRKS_DEP             BIT(2)
+#define PN533_QUIRKS_RAW_EXCHANGE    BIT(3)
+
+#define PN533_DEVICE_STD    0x1
+#define PN533_DEVICE_PASORI 0x2
+
+#define PN533_ALL_PROTOCOLS (NFC_PROTO_JEWEL_MASK | NFC_PROTO_MIFARE_MASK \
+			     | NFC_PROTO_FELICA_MASK | NFC_PROTO_ISO14443_MASK \
+			     | NFC_PROTO_NFC_DEP_MASK)
+
+#define PN533_NO_TYPE_B_PROTOCOLS (NFC_PROTO_JEWEL_MASK | \
+				   NFC_PROTO_MIFARE_MASK | \
+				   NFC_PROTO_FELICA_MASK | \
+				   NFC_PROTO_NFC_DEP_MASK)
+
 static const struct usb_device_id pn533_table[] = {
-	{ USB_DEVICE(PN533_VENDOR_ID, PN533_PRODUCT_ID) },
-	{ USB_DEVICE(SCM_VENDOR_ID, SCL3711_PRODUCT_ID) },
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE,
+	  .idVendor		= PN533_VENDOR_ID,
+	  .idProduct		= PN533_PRODUCT_ID,
+	  .driver_info		= PN533_DEVICE_STD,
+	},
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE,
+	  .idVendor		= SCM_VENDOR_ID,
+	  .idProduct		= SCL3711_PRODUCT_ID,
+	  .driver_info		= PN533_DEVICE_STD,
+	},
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE,
+	  .idVendor		= SONY_VENDOR_ID,
+	  .idProduct		= PASORI_PRODUCT_ID,
+	  .driver_info		= PN533_DEVICE_PASORI,
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, pn533_table);
@@ -72,6 +105,7 @@ MODULE_DEVICE_TABLE(usb, pn533_table);
 #define PN533_CMD_GET_FIRMWARE_VERSION 0x02
 #define PN533_CMD_RF_CONFIGURATION 0x32
 #define PN533_CMD_IN_DATA_EXCHANGE 0x40
+#define PN533_CMD_IN_COMM_THRU     0x42
 #define PN533_CMD_IN_LIST_PASSIVE_TARGET 0x4A
 #define PN533_CMD_IN_ATR 0x50
 #define PN533_CMD_IN_RELEASE 0x52
@@ -109,6 +143,7 @@ struct pn533_fw_version {
 /* PN533_CMD_RF_CONFIGURATION */
 #define PN533_CFGITEM_TIMING 0x02
 #define PN533_CFGITEM_MAX_RETRIES 0x05
+#define PN533_CFGITEM_PASORI 0x82
 
 #define PN533_CONFIG_TIMING_102 0xb
 #define PN533_CONFIG_TIMING_204 0xc
@@ -344,6 +379,8 @@ struct pn533 {
 	u8 tgt_available_prots;
 	u8 tgt_active_prot;
 	u8 tgt_mode;
+
+	u32 device_type;
 };
 
 struct pn533_frame {
@@ -1768,13 +1805,31 @@ static int pn533_build_tx_frame(struct pn533 *dev, struct sk_buff *skb,
 	}
 
 	if (target == true) {
-		skb_push(skb, PN533_CMD_DATAEXCH_HEAD_LEN);
-		out_frame = (struct pn533_frame *) skb->data;
+		switch (dev->device_type) {
+		case PN533_DEVICE_STD:
+			skb_push(skb, PN533_CMD_DATAEXCH_HEAD_LEN);
+			out_frame = (struct pn533_frame *) skb->data;
+			pn533_tx_frame_init(out_frame,
+					    PN533_CMD_IN_DATA_EXCHANGE);
+			tg = 1;
+			memcpy(PN533_FRAME_CMD_PARAMS_PTR(out_frame),
+			       &tg, sizeof(u8));
+			out_frame->datalen += sizeof(u8);
+			break;
+
+		case PN533_DEVICE_PASORI:
+			skb_push(skb, PN533_CMD_DATAEXCH_HEAD_LEN - 1);
+			out_frame = (struct pn533_frame *) skb->data;
+			pn533_tx_frame_init(out_frame, PN533_CMD_IN_COMM_THRU);
+
+			break;
+
+		default:
+			nfc_dev_err(&dev->interface->dev,
+				    "Unknown device type %d", dev->device_type);
+			return -EINVAL;
+		}
 
-		pn533_tx_frame_init(out_frame, PN533_CMD_IN_DATA_EXCHANGE);
-		tg = 1;
-		memcpy(PN533_FRAME_CMD_PARAMS_PTR(out_frame), &tg, sizeof(u8));
-		out_frame->datalen += sizeof(u8);
 	} else {
 		skb_push(skb, PN533_CMD_DATAEXCH_HEAD_LEN - 1);
 		out_frame = (struct pn533_frame *) skb->data;
@@ -2101,7 +2156,28 @@ static int pn533_set_configuration(struct pn533 *dev, u8 cfgitem, u8 *cfgdata,
 	return rc;
 }
 
-struct nfc_ops pn533_nfc_ops = {
+static int pn533_fw_reset(struct pn533 *dev)
+{
+	int rc;
+	u8 *params;
+
+	nfc_dev_dbg(&dev->interface->dev, "%s", __func__);
+
+	pn533_tx_frame_init(dev->out_frame, 0x18);
+
+	params = PN533_FRAME_CMD_PARAMS_PTR(dev->out_frame);
+	params[0] = 0x1;
+	dev->out_frame->datalen += 1;
+
+	pn533_tx_frame_finish(dev->out_frame);
+
+	rc = pn533_send_cmd_frame_sync(dev, dev->out_frame, dev->in_frame,
+				       dev->in_maxlen);
+
+	return rc;
+}
+
+static struct nfc_ops pn533_nfc_ops = {
 	.dev_up = NULL,
 	.dev_down = NULL,
 	.dep_link_up = pn533_dep_link_up,
@@ -2114,6 +2190,84 @@ struct nfc_ops pn533_nfc_ops = {
 	.tm_send = pn533_tm_send,
 };
 
+static int pn533_setup(struct pn533 *dev)
+{
+	struct pn533_config_max_retries max_retries;
+	struct pn533_config_timing timing;
+	u8 pasori_cfg[3] = {0x08, 0x01, 0x08};
+	int rc;
+
+	switch (dev->device_type) {
+	case PN533_DEVICE_STD:
+		max_retries.mx_rty_atr = PN533_CONFIG_MAX_RETRIES_ENDLESS;
+		max_retries.mx_rty_psl = 2;
+		max_retries.mx_rty_passive_act =
+			PN533_CONFIG_MAX_RETRIES_NO_RETRY;
+
+		timing.rfu = PN533_CONFIG_TIMING_102;
+		timing.atr_res_timeout = PN533_CONFIG_TIMING_204;
+		timing.dep_timeout = PN533_CONFIG_TIMING_409;
+
+		break;
+
+	case PN533_DEVICE_PASORI:
+		max_retries.mx_rty_atr = 0x2;
+		max_retries.mx_rty_psl = 0x1;
+		max_retries.mx_rty_passive_act =
+			PN533_CONFIG_MAX_RETRIES_NO_RETRY;
+
+		timing.rfu = PN533_CONFIG_TIMING_102;
+		timing.atr_res_timeout = PN533_CONFIG_TIMING_102;
+		timing.dep_timeout = PN533_CONFIG_TIMING_204;
+
+		break;
+
+	default:
+		nfc_dev_err(&dev->interface->dev, "Unknown device type %d\n",
+			    dev->device_type);
+		return -EINVAL;
+	}
+
+	rc = pn533_set_configuration(dev, PN533_CFGITEM_MAX_RETRIES,
+				     (u8 *)&max_retries, sizeof(max_retries));
+	if (rc) {
+		nfc_dev_err(&dev->interface->dev,
+			    "Error on setting MAX_RETRIES config");
+		return rc;
+	}
+
+
+	rc = pn533_set_configuration(dev, PN533_CFGITEM_TIMING,
+				     (u8 *)&timing, sizeof(timing));
+	if (rc) {
+		nfc_dev_err(&dev->interface->dev,
+			    "Error on setting RF timings");
+		return rc;
+	}
+
+	switch (dev->device_type) {
+	case PN533_DEVICE_STD:
+		break;
+
+	case PN533_DEVICE_PASORI:
+		pn533_fw_reset(dev);
+
+		rc = pn533_set_configuration(dev, PN533_CFGITEM_PASORI,
+					     pasori_cfg, 3);
+		if (rc) {
+			nfc_dev_err(&dev->interface->dev,
+				    "Error while settings PASORI config");
+			return rc;
+		}
+
+		pn533_fw_reset(dev);
+
+		break;
+	}
+
+	return 0;
+}
+
 static int pn533_probe(struct usb_interface *interface,
 			const struct usb_device_id *id)
 {
@@ -2121,8 +2275,6 @@ static int pn533_probe(struct usb_interface *interface,
 	struct pn533 *dev;
 	struct usb_host_interface *iface_desc;
 	struct usb_endpoint_descriptor *endpoint;
-	struct pn533_config_max_retries max_retries;
-	struct pn533_config_timing timing;
 	int in_endpoint = 0;
 	int out_endpoint = 0;
 	int rc = -ENOMEM;
@@ -2208,10 +2360,22 @@ static int pn533_probe(struct usb_interface *interface,
 	nfc_dev_info(&dev->interface->dev, "NXP PN533 firmware ver %d.%d now"
 					" attached", fw_ver->ver, fw_ver->rev);
 
-	protocols = NFC_PROTO_JEWEL_MASK
-			| NFC_PROTO_MIFARE_MASK | NFC_PROTO_FELICA_MASK
-			| NFC_PROTO_ISO14443_MASK
-			| NFC_PROTO_NFC_DEP_MASK;
+	dev->device_type = id->driver_info;
+	switch (dev->device_type) {
+	case PN533_DEVICE_STD:
+		protocols = PN533_ALL_PROTOCOLS;
+		break;
+
+	case PN533_DEVICE_PASORI:
+		protocols = PN533_NO_TYPE_B_PROTOCOLS;
+		break;
+
+	default:
+		nfc_dev_err(&dev->interface->dev, "Unknown device type %d\n",
+			    dev->device_type);
+		rc = -EINVAL;
+		goto destroy_wq;
+	}
 
 	dev->nfc_dev = nfc_allocate_device(&pn533_nfc_ops, protocols,
 					   PN533_CMD_DATAEXCH_HEAD_LEN,
@@ -2226,30 +2390,9 @@ static int pn533_probe(struct usb_interface *interface,
 	if (rc)
 		goto free_nfc_dev;
 
-	max_retries.mx_rty_atr = PN533_CONFIG_MAX_RETRIES_ENDLESS;
-	max_retries.mx_rty_psl = 2;
-	max_retries.mx_rty_passive_act = PN533_CONFIG_MAX_RETRIES_NO_RETRY;
-
-	rc = pn533_set_configuration(dev, PN533_CFGITEM_MAX_RETRIES,
-				(u8 *) &max_retries, sizeof(max_retries));
-
-	if (rc) {
-		nfc_dev_err(&dev->interface->dev, "Error on setting MAX_RETRIES"
-								" config");
-		goto unregister_nfc_dev;
-	}
-
-	timing.rfu = PN533_CONFIG_TIMING_102;
-	timing.atr_res_timeout = PN533_CONFIG_TIMING_204;
-	timing.dep_timeout = PN533_CONFIG_TIMING_409;
-
-	rc = pn533_set_configuration(dev, PN533_CFGITEM_TIMING,
-				(u8 *) &timing, sizeof(timing));
-	if (rc) {
-		nfc_dev_err(&dev->interface->dev,
-			    "Error on setting RF timings");
+	rc = pn533_setup(dev);
+	if (rc)
 		goto unregister_nfc_dev;
-	}
 
 	return 0;
 
-- 
1.7.10

