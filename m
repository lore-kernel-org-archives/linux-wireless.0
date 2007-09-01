Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:34344 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbXIAQwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 12:52:32 -0400
From: Chr <chunkeey@web.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH 2/2 v2] p54: disable QoS on older firmwares
Date: Sat, 1 Sep 2007 18:54:27 +0200
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <46BFF10B.1090307@hhs.nl> <200708312327.28981.chunkeey@web.de> <200709010058.59928.flamingice@sourmilk.net>
In-Reply-To: <200709010058.59928.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_DlZ2GVMe1lpYEzZ"
Message-Id: <200709011854.27620.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_DlZ2GVMe1lpYEzZ
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

From: Christian Lamparter <chunkeey@web.de>

This patch fixes a regression with older (pre 2.5.2.0) firmwares, that don't
support the QoS queues yet...

Thanks to Hans de Goede <j.w.r.degoede@hhs.nl> for reporting and debugging it.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
>Why bother allocating a temporary buffer for firmware version string? Just 
>keep a pointer to where it's located. (unless it's not null terminated..)
Ok
 

--Boundary-00=_DlZ2GVMe1lpYEzZ
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="p54-support-older-firmwares4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-support-older-firmwares4.diff"

diff -Nurp a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
--- a/drivers/net/wireless/p54common.c	2007-08-31 21:57:29.000000000 +0200
+++ b/drivers/net/wireless/p54common.c	2007-09-01 18:27:10.000000000 +0200
@@ -30,9 +30,13 @@ MODULE_ALIAS("prism54common");
 void p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 {
 	struct p54_common *priv = dev->priv;
+	struct bootrec_exp_if *exp_if;
 	struct bootrec *bootrec;
 	u32 *data = (u32 *)fw->data;
 	u32 *end_data = (u32 *)fw->data + (fw->size >> 2);
+	u8 *fw_version = NULL;
+	size_t len;
+	int i;
 
 	if (priv->rx_start)
 		return;
@@ -46,7 +50,7 @@ void p54_parse_firmware(struct ieee80211
 	bootrec = (struct bootrec *) data;
 
 	while (bootrec->data <= end_data &&
-	       (bootrec->data + le32_to_cpu(bootrec->len)) <= end_data) {
+	       (bootrec->data + (len = le32_to_cpu(bootrec->len))) <= end_data) {
 		u32 code = le32_to_cpu(bootrec->code);
 		switch (code) {
 		case BR_CODE_COMPONENT_ID:
@@ -69,6 +73,9 @@ void p54_parse_firmware(struct ieee80211
 			}
 			break;
 		case BR_CODE_COMPONENT_VERSION:
+			/* 24 bytes should be enough for all firmwares */
+			if (strnlen((unsigned char*)bootrec->data, 24) < 24)
+				fw_version = (unsigned char*)bootrec->data;
 			break;
 		case BR_CODE_DESCR:
 			priv->rx_start = le32_to_cpu(bootrec->data[1]);
@@ -76,6 +83,10 @@ void p54_parse_firmware(struct ieee80211
 			priv->rx_end = le32_to_cpu(bootrec->data[2]) - 0x3500;
 			break;
 		case BR_CODE_EXPOSED_IF:
+			exp_if = (struct bootrec_exp_if *) bootrec->data;
+			for (i = 0; i < (len * sizeof(*exp_if) / 4); i++)
+				if (exp_if[i].if_id == 0x1a)
+					priv->fw_var = le16_to_cpu(exp_if[i].variant);
 			break;
 		case BR_CODE_DEPENDENT_IF:
 			break;
@@ -86,7 +97,20 @@ void p54_parse_firmware(struct ieee80211
 		default:
 			break;
 		}
-		bootrec = (struct bootrec *)&bootrec->data[le32_to_cpu(bootrec->len)];
+		bootrec = (struct bootrec *)&bootrec->data[len];
+	}
+
+	if (fw_version)
+		printk(KERN_INFO "p54: FW rev %s - Softmac protocol %x.%x\n",
+			fw_version, priv->fw_var >> 8, priv->fw_var & 0xff);
+
+	if (priv->fw_var >= 0x300) {
+		/* Firmware supports QoS, use it! */
+		priv->tx_stats.data[0].limit = 3;
+		priv->tx_stats.data[1].limit = 4;
+		priv->tx_stats.data[2].limit = 3;
+		priv->tx_stats.data[3].limit = 1;
+		dev->queues = 4;
 	}
 }
 EXPORT_SYMBOL_GPL(p54_parse_firmware);
@@ -909,13 +933,9 @@ struct ieee80211_hw *p54_init_common(siz
 	dev->channel_change_time = 1000;	/* TODO: find actual value */
 	dev->max_rssi = 127;
 
-	/* (hard) queue limits */
-	priv->tx_stats.data[0].limit = 3;
-	priv->tx_stats.data[1].limit = 4;
-	priv->tx_stats.data[2].limit = 3;
-	priv->tx_stats.data[3].limit = 1;
+	priv->tx_stats.data[0].limit = 5;
+	dev->queues = 1;
 
-	dev->queues = 4;
 	dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
 				 sizeof(struct p54_tx_control_allocdata);
 
diff -Nurp a/drivers/net/wireless/p54.h b/drivers/net/wireless/p54.h
--- a/drivers/net/wireless/p54.h	2007-08-28 12:00:54.000000000 +0200
+++ b/drivers/net/wireless/p54.h	2007-09-01 18:04:51.000000000 +0200
@@ -62,6 +62,7 @@ struct p54_common {
 	u8 version;
 	unsigned int tx_hdr_len;
 	void *cached_vdcf;
+	unsigned int fw_var;
 	/* FIXME: this channels/modes/rates stuff sucks */
 	struct ieee80211_channel channels[14];
 	struct ieee80211_rate rates[12];

--Boundary-00=_DlZ2GVMe1lpYEzZ--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
