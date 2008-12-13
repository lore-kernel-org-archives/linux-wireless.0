Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:53591 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYLMW0n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Dec 2008 17:26:43 -0500
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate03.web.de (Postfix) with ESMTP id 07EFDF5630D8
	for <linux-wireless@vger.kernel.org>; Sat, 13 Dec 2008 23:26:41 +0100 (CET)
Received: from [91.22.227.65] (helo=debian64.daheim)
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.109 #226)
	id 1LBcwa-0006QK-00
	for linux-wireless@vger.kernel.org; Sat, 13 Dec 2008 23:26:40 +0100
Received: from debian64.daheim
	([192.168.0.4] helo=debian64.localnet ident=chuck)
	by debian64.daheim with esmtpa (Exim 4.69)
	(envelope-from <chunkeey@web.de>)
	id 1LBcwa-0001lq-I3
	for linux-wireless@vger.kernel.org; Sat, 13 Dec 2008 23:26:40 +0100
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC][RFT][PATCH] p54: more accurate rssi_to_dBm conversion
Date: Sat, 13 Dec 2008 23:26:39 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812132326.40074.chunkeey@web.de> (sfid-20081213_232647_898499_800BDF98)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces the static rssi auto calibration data
with more precise values out of the device's eeprom.

---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-13 20:55:27.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-13 23:06:53.000000000 +0100
@@ -335,6 +335,36 @@ static const char *p54_rf_chips[] = { "N
                               "Frisbee", "Xbow", "Longbow", "NULL", "NULL" };
 static int p54_init_xbow_synth(struct ieee80211_hw *dev);
 
+static void p54_parse_rssical(struct ieee80211_hw *dev, void *data, int len,
+			     u16 type)
+{
+	struct p54_common *priv = dev->priv;
+	int offset = (type == PDR_RSSI_LINEAR_APPROXIMATION_EXTENDED) ? 2 : 0;
+	int entry_size = sizeof(struct pda_rssi_cal_entry) + offset;
+	int num_entries = (type == PDR_RSSI_LINEAR_APPROXIMATION) ? 1 : 2;
+	int i;
+
+	if (len != (entry_size * num_entries)) {
+		printk(KERN_ERR "%s: unknown rssi calibration data packing "
+				 " type:(%x) len:%d.\n",
+		       wiphy_name(dev->wiphy), type, len);
+
+		print_hex_dump_bytes("rssical:", DUMP_PREFIX_NONE,
+				     data, len);
+
+		printk(KERN_ERR "%s: please report this issue.\n",
+			wiphy_name(dev->wiphy));
+		return;
+	}
+
+	for (i = 0; i < num_entries; i++) {
+		struct pda_rssi_cal_entry *cal = data +
+						 (offset + i * entry_size);
+		priv->rssical_db[i].mul = (s16) le16_to_cpu(cal->mul);
+		priv->rssical_db[i].add = (s16) le16_to_cpu(cal->add);
+	}
+}
+
 static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 {
 	struct p54_common *priv = dev->priv;
@@ -435,6 +465,12 @@ static int p54_parse_eeprom(struct ieee8
 		case PDR_HARDWARE_PLATFORM_COMPONENT_ID:
 			priv->version = *(u8 *)(entry->data + 1);
 			break;
+		case PDR_RSSI_LINEAR_APPROXIMATION:
+		case PDR_RSSI_LINEAR_APPROXIMATION_DUAL_BAND:
+		case PDR_RSSI_LINEAR_APPROXIMATION_EXTENDED:
+			p54_parse_rssical(dev, entry->data, data_len,
+					  le16_to_cpu(entry->code));
+			break;
 		case PDR_END:
 			/* make it overrun */
 			entry_len = len;
@@ -454,10 +490,7 @@ static int p54_parse_eeprom(struct ieee8
 		case PDR_DEFAULT_COUNTRY:
 		case PDR_ANTENNA_GAIN:
 		case PDR_PRISM_INDIGO_PA_CALIBRATION_DATA:
-		case PDR_RSSI_LINEAR_APPROXIMATION:
-		case PDR_RSSI_LINEAR_APPROXIMATION_DUAL_BAND:
 		case PDR_REGULATORY_POWER_LIMITS:
-		case PDR_RSSI_LINEAR_APPROXIMATION_EXTENDED:
 		case PDR_RADIATED_TRANSMISSION_CORRECTION:
 		case PDR_PRISM_TX_IQ_CALIBRATION:
 		case PDR_BASEBAND_REGISTERS:
@@ -528,8 +561,11 @@ static int p54_parse_eeprom(struct ieee8
 
 static int p54_rssi_to_dbm(struct ieee80211_hw *dev, int rssi)
 {
-	/* TODO: get the rssi_add & rssi_mul data from the eeprom */
-	return ((rssi * 0x83) / 64 - 400) / 4;
+	struct p54_common *priv = dev->priv;
+	int band = dev->conf.channel->band;
+
+	return ((rssi * priv->rssical_db[band].mul) / 64 +
+			 priv->rssical_db[band].add) / 4;
 }
 
 static int p54_rx_data(struct ieee80211_hw *dev, struct sk_buff *skb)
@@ -1467,15 +1503,15 @@ static int p54_setup_mac(struct ieee8021
 	return 0;
 }
 
-static int p54_scan(struct ieee80211_hw *dev, u16 mode, u16 dwell,
-		    u16 frequency)
+static int p54_scan(struct ieee80211_hw *dev, u16 mode, u16 dwell)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
 	struct p54_scan *chan;
 	unsigned int i;
 	void *entry;
-	__le16 freq = cpu_to_le16(frequency);
+	__le16 freq = cpu_to_le16(dev->conf.channel->center_freq);
+	int band = dev->conf.channel->band;
 
 	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*chan) +
 			    sizeof(struct p54_hdr), P54_CONTROL_TYPE_SCAN,
@@ -1536,11 +1572,11 @@ static int p54_scan(struct ieee80211_hw 
 	}
 
 	if (priv->fw_var < 0x500) {
-		chan->v1.rssical_mul = cpu_to_le16(130);
-		chan->v1.rssical_add = cpu_to_le16(0xfe70);
+		chan->v1_rssi.mul = cpu_to_le16(priv->rssical_db[band].mul);
+		chan->v1_rssi.add = cpu_to_le16(priv->rssical_db[band].add);
 	} else {
-		chan->v2.rssical_mul = cpu_to_le16(130);
-		chan->v2.rssical_add = cpu_to_le16(0xfe70);
+		chan->v2.rssi.mul = cpu_to_le16(priv->rssical_db[band].mul);
+		chan->v2.rssi.add = cpu_to_le16(priv->rssical_db[band].add);
 		chan->v2.basic_rate_mask = cpu_to_le32(priv->basic_rate_mask);
 		memset(chan->v2.rts_rates, 0, 8);
 	}
@@ -1802,8 +1838,7 @@ static int p54_config(struct ieee80211_h
 			goto out;
 	}
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		ret = p54_scan(dev, P54_SCAN_EXIT, 0,
-			       conf->channel->center_freq);
+		ret = p54_scan(dev, P54_SCAN_EXIT, 0);
 		if (ret)
 			goto out;
 	}
@@ -1829,8 +1864,7 @@ static int p54_config_interface(struct i
 	}
 
 	if (conf->changed & IEEE80211_IFCC_BEACON) {
-		ret = p54_scan(dev, P54_SCAN_EXIT, 0,
-			       dev->conf.channel->center_freq);
+		ret = p54_scan(dev, P54_SCAN_EXIT, 0);
 		if (ret)
 			goto out;
 		ret = p54_setup_mac(dev);
@@ -1969,8 +2003,7 @@ static void p54_bss_info_changed(struct 
 			priv->basic_rate_mask = info->basic_rates;
 		p54_setup_mac(dev);
 		if (priv->fw_var >= 0x500)
-			p54_scan(dev, P54_SCAN_EXIT, 0,
-				 dev->conf.channel->center_freq);
+			p54_scan(dev, P54_SCAN_EXIT, 0);
 	}
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (info->assoc) {
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-12-13 21:10:30.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2008-12-13 23:00:30.000000000 +0100
@@ -178,6 +178,11 @@ struct pda_pa_curve_data {
 	u8 data[0];
 } __attribute__ ((packed));
 
+struct pda_rssi_cal_entry {
+	__le16 mul;
+	__le16 add;
+} __attribute__ ((packed));
+
 /*
  * this defines the PDR codes used to build PDAs as defined in document
  * number 553155. The current implementation mirrors version 1.1 of the
@@ -429,22 +434,18 @@ struct p54_scan {
 	u8 dup_16qam;
 	u8 dup_64qam;
 	union {
-		struct {
-			__le16 rssical_mul;
-			__le16 rssical_add;
-		} v1 __attribute__ ((packed));
+		struct pda_rssi_cal_entry v1_rssi;
 
 		struct {
 			__le32 basic_rate_mask;
 			u8 rts_rates[8];
-			__le16 rssical_mul;
-			__le16 rssical_add;
+			struct pda_rssi_cal_entry rssi;
 		} v2 __attribute__ ((packed));
 	} __attribute__ ((packed));
 } __attribute__ ((packed));
 
-#define P54_SCAN_V1_LEN (sizeof(struct p54_scan)-12)
-#define P54_SCAN_V2_LEN (sizeof(struct p54_scan))
+#define P54_SCAN_V1_LEN 0x70
+#define P54_SCAN_V2_LEN 0x7c
 
 struct p54_led {
 	__le16 mode;
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2008-12-13 16:16:26.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2008-12-13 23:01:29.000000000 +0100
@@ -61,6 +61,13 @@ struct p54_edcf_queue_param {
 	__le16 txop;
 } __attribute__ ((packed));
 
+struct p54_rssi_linear_approximation {
+	s16 mul;
+	s16 add;
+	s16 longbow_unkn;
+	s16 longbow_unk2;
+};
+
 #define EEPROM_READBACK_LEN 0x3fc
 
 #define ISL38XX_DEV_FIRMWARE_ADDR 0x20000
@@ -91,6 +98,7 @@ struct p54_common {
 	struct pda_channel_output_limit *output_limit;
 	unsigned int output_limit_len;
 	struct pda_pa_curve_data *curve_data;
+	struct p54_rssi_linear_approximation rssical_db[IEEE80211_NUM_BANDS];
 	unsigned int filter_flags;
 	bool use_short_slot;
 	u16 rxhw;
