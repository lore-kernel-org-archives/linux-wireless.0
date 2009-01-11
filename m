Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:47848 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZAKAKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 19:10:36 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/4] p54: prepare the eeprom parser routines for longbow
Date: Sun, 11 Jan 2009 01:10:33 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901110110.33501.chunkeey@web.de> (sfid-20090111_011040_190291_BA895E17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to upload pre-calculated calibration data to the firmware.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2009-01-10 22:58:55.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2009-01-11 00:09:38.000000000 +0100
@@ -272,13 +272,19 @@ static int p54_convert_rev0(struct ieee8
 	unsigned int i, j;
 	void *source, *target;
 
-	priv->curve_data = kmalloc(cd_len, GFP_KERNEL);
+	priv->curve_data = kmalloc(sizeof(*priv->curve_data) + cd_len,
+				   GFP_KERNEL);
 	if (!priv->curve_data)
 		return -ENOMEM;
 
-	memcpy(priv->curve_data, curve_data, sizeof(*curve_data));
+	priv->curve_data->entries = curve_data->channels;
+	priv->curve_data->entry_size = sizeof(__le16) +
+		sizeof(*dst) * curve_data->points_per_channel;
+	priv->curve_data->offset = offsetof(struct pda_pa_curve_data, data);
+	priv->curve_data->len = cd_len;
+	memcpy(priv->curve_data->data, curve_data, sizeof(*curve_data));
 	source = curve_data->data;
-	target = priv->curve_data->data;
+	target = ((struct pda_pa_curve_data *) priv->curve_data->data)->data;
 	for (i = 0; i < curve_data->channels; i++) {
 		__le16 *freq = source;
 		source += sizeof(__le16);
@@ -318,13 +324,19 @@ static int p54_convert_rev1(struct ieee8
 	unsigned int i, j;
 	void *source, *target;
 
-	priv->curve_data = kmalloc(cd_len, GFP_KERNEL);
+	priv->curve_data = kzalloc(cd_len + sizeof(*priv->curve_data),
+				   GFP_KERNEL);
 	if (!priv->curve_data)
 		return -ENOMEM;
 
-	memcpy(priv->curve_data, curve_data, sizeof(*curve_data));
+	priv->curve_data->entries = curve_data->channels;
+	priv->curve_data->entry_size = sizeof(__le16) +
+		sizeof(*dst) * curve_data->points_per_channel;
+	priv->curve_data->offset = offsetof(struct pda_pa_curve_data, data);
+	priv->curve_data->len = cd_len;
+	memcpy(priv->curve_data->data, curve_data, sizeof(*curve_data));
 	source = curve_data->data;
-	target = priv->curve_data->data;
+	target = ((struct pda_pa_curve_data *) priv->curve_data->data)->data;
 	for (i = 0; i < curve_data->channels; i++) {
 		__le16 *freq = source;
 		source += sizeof(__le16);
@@ -406,6 +418,71 @@ static void p54_parse_default_country(st
 	}
 }
 
+static int p54_convert_output_limits(struct ieee80211_hw *dev,
+				     u8 *data, size_t len)
+{
+	struct p54_common *priv = dev->priv;
+
+	if (len < 2)
+		return -EINVAL;
+
+	if (data[0] != 0) {
+		printk(KERN_ERR "%s: unknown output power db revision:%x\n",
+		       wiphy_name(dev->wiphy), data[0]);
+		return -EINVAL;
+	}
+
+	if (2 + data[1] * sizeof(struct pda_channel_output_limit) > len)
+		return -EINVAL;
+
+	priv->output_limit = kmalloc(data[1] *
+		sizeof(struct pda_channel_output_limit) +
+		sizeof(*priv->output_limit), GFP_KERNEL);
+
+	if (!priv->output_limit)
+		return -ENOMEM;
+
+	priv->output_limit->offset = 0;
+	priv->output_limit->entries = data[1];
+	priv->output_limit->entry_size =
+		sizeof(struct pda_channel_output_limit);
+	priv->output_limit->len = priv->output_limit->entry_size *
+				  priv->output_limit->entries +
+				  priv->output_limit->offset;
+
+	memcpy(priv->output_limit->data, &data[2],
+	       data[1] * sizeof(struct pda_channel_output_limit));
+
+	return 0;
+}
+
+static struct p54_cal_database *p54_convert_db(struct pda_custom_wrapper *src,
+					       size_t total_len)
+{
+	struct p54_cal_database *dst;
+	size_t payload_len, entries, entry_size, offset;
+
+	payload_len = le16_to_cpu(src->len);
+	entries = le16_to_cpu(src->entries);
+	entry_size = le16_to_cpu(src->entry_size);
+	offset = le16_to_cpu(src->offset);
+	if (((entries * entry_size + offset) != payload_len) ||
+	     (payload_len + sizeof(*src) != total_len))
+		return NULL;
+
+	dst = kmalloc(sizeof(*dst) + payload_len, GFP_KERNEL);
+	if (!dst)
+		return NULL;
+
+	dst->entries = entries;
+	dst->entry_size = entry_size;
+	dst->offset = offset;
+	dst->len = payload_len;
+
+	memcpy(dst->data, src->data, payload_len);
+	return dst;
+}
+
 static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 {
 	struct p54_common *priv = dev->priv;
@@ -432,30 +509,17 @@ static int p54_parse_eeprom(struct ieee8
 
 		switch (le16_to_cpu(entry->code)) {
 		case PDR_MAC_ADDRESS:
+			if (data_len != ETH_ALEN)
+				break;
 			SET_IEEE80211_PERM_ADDR(dev, entry->data);
 			break;
 		case PDR_PRISM_PA_CAL_OUTPUT_POWER_LIMITS:
-			if (data_len < 2) {
-				err = -EINVAL;
-				goto err;
-			}
-
-			if (2 + entry->data[1]*sizeof(*priv->output_limit) > data_len) {
-				err = -EINVAL;
-				goto err;
-			}
-
-			priv->output_limit = kmalloc(entry->data[1] *
-				sizeof(*priv->output_limit), GFP_KERNEL);
-
-			if (!priv->output_limit) {
-				err = -ENOMEM;
+			if (priv->output_limit)
+				break;
+			err = p54_convert_output_limits(dev, entry->data,
+							data_len);
+			if (err)
 				goto err;
-			}
-
-			memcpy(priv->output_limit, &entry->data[2],
-			       entry->data[1]*sizeof(*priv->output_limit));
-			priv->output_limit_len = entry->data[1];
 			break;
 		case PDR_PRISM_PA_CAL_CURVE_DATA: {
 			struct pda_pa_curve_data *curve_data =
@@ -507,6 +571,8 @@ static int p54_parse_eeprom(struct ieee8
 			}
 			break;
 		case PDR_HARDWARE_PLATFORM_COMPONENT_ID:
+			if (data_len < 2)
+				break;
 			priv->version = *(u8 *)(entry->data + 1);
 			break;
 		case PDR_RSSI_LINEAR_APPROXIMATION:
@@ -515,6 +581,34 @@ static int p54_parse_eeprom(struct ieee8
 			p54_parse_rssical(dev, entry->data, data_len,
 					  le16_to_cpu(entry->code));
 			break;
+		case PDR_RSSI_LINEAR_APPROXIMATION_CUSTOM: {
+			__le16 *src = (void *) entry->data;
+			s16 *dst = (void *) &priv->rssical_db;
+			int i;
+
+			if (data_len != sizeof(priv->rssical_db)) {
+				err = -EINVAL;
+				goto err;
+			}
+			for (i = 0; i < sizeof(priv->rssical_db) /
+					sizeof(*src); i++)
+				*(dst++) = (s16) le16_to_cpu(*(src++));
+			}
+			break;
+		case PDR_PRISM_PA_CAL_OUTPUT_POWER_LIMITS_CUSTOM: {
+			struct pda_custom_wrapper *pda = (void *) entry->data;
+			if (priv->output_limit || data_len < sizeof(*pda))
+				break;
+			priv->output_limit = p54_convert_db(pda, data_len);
+			}
+			break;
+		case PDR_PRISM_PA_CAL_CURVE_DATA_CUSTOM: {
+			struct pda_custom_wrapper *pda = (void *) entry->data;
+			if (priv->curve_data || data_len < sizeof(*pda))
+				break;
+			priv->curve_data = p54_convert_db(pda, data_len);
+			}
+			break;
 		case PDR_END:
 			/* make it overrun */
 			entry_len = len;
@@ -1611,8 +1705,8 @@ static int p54_scan(struct ieee80211_hw 
 	struct p54_scan *chan;
 	unsigned int i;
 	void *entry;
-	__le16 freq = cpu_to_le16(dev->conf.channel->center_freq);
 	int band = dev->conf.channel->band;
+	__le16 freq = cpu_to_le16(dev->conf.channel->center_freq);
 
 	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*chan),
 			    P54_CONTROL_TYPE_SCAN, GFP_ATOMIC);
@@ -1620,7 +1714,7 @@ static int p54_scan(struct ieee80211_hw 
 		return -ENOMEM;
 
 	chan = (struct p54_scan *) skb_put(skb, sizeof(*chan));
-	memset(chan->padding1, 0, sizeof(chan->padding1));
+	memset(chan->scan_params, 0, sizeof(chan->scan_params));
 	chan->mode = cpu_to_le16(mode);
 	chan->dwell = cpu_to_le16(dwell);
 
@@ -1635,41 +1729,45 @@ static int p54_scan(struct ieee80211_hw 
 	if (i == priv->iq_autocal_len)
 		goto err;
 
-	for (i = 0; i < priv->output_limit_len; i++) {
-		if (priv->output_limit[i].freq != freq)
+	for (i = 0; i < priv->output_limit->entries; i++) {
+		struct pda_channel_output_limit *limits;
+		__le16 *entry_freq = (void *) (priv->output_limit->data +
+			priv->output_limit->entry_size * i);
+
+		if (*entry_freq != freq)
 			continue;
 
+		limits = (void *) entry_freq;
 		chan->val_barker = 0x38;
-		chan->val_bpsk = chan->dup_bpsk =
-			priv->output_limit[i].val_bpsk;
-		chan->val_qpsk = chan->dup_qpsk =
-			priv->output_limit[i].val_qpsk;
-		chan->val_16qam = chan->dup_16qam =
-			priv->output_limit[i].val_16qam;
-		chan->val_64qam = chan->dup_64qam =
-			priv->output_limit[i].val_64qam;
+		chan->val_bpsk = chan->dup_bpsk = limits->val_bpsk;
+		chan->val_qpsk = chan->dup_qpsk = limits->val_qpsk;
+		chan->val_16qam = chan->dup_16qam = limits->val_16qam;
+		chan->val_64qam = chan->dup_64qam = limits->val_64qam;
 		break;
 	}
-	if (i == priv->output_limit_len)
+	if (i == priv->output_limit->entries)
 		goto err;
 
-	entry = priv->curve_data->data;
-	for (i = 0; i < priv->curve_data->channels; i++) {
+	entry = (void *)(priv->curve_data->data + priv->curve_data->offset);
+	for (i = 0; i < priv->curve_data->entries; i++) {
+		struct pda_pa_curve_data *curve_data;
 		if (*((__le16 *)entry) != freq) {
-			entry += sizeof(__le16);
-			entry += sizeof(struct p54_pa_curve_data_sample) *
-				 priv->curve_data->points_per_channel;
+			entry += priv->curve_data->entry_size;
 			continue;
 		}
 
 		entry += sizeof(__le16);
 		chan->pa_points_per_curve = 8;
 		memset(chan->curve_data, 0, sizeof(*chan->curve_data));
+		curve_data = (void *) priv->curve_data->data;
+
 		memcpy(chan->curve_data, entry,
 		       sizeof(struct p54_pa_curve_data_sample) *
-		       min((u8)8, priv->curve_data->points_per_channel));
+		       min_t(u8, 8, curve_data->points_per_channel));
 		break;
 	}
+	if (i == priv->curve_data->entries)
+		goto err;
 
 	if (priv->fw_var < 0x500) {
 		chan->v1_rssi.mul = cpu_to_le16(priv->rssical_db[band].mul);
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2009-01-10 16:39:15.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2009-01-10 23:28:18.000000000 +0100
@@ -186,6 +186,14 @@ struct pda_country {
 	u8 flags;
 } __attribute__ ((packed));
 
+struct pda_custom_wrapper {
+	__le16 entries;
+	__le16 entry_size;
+	__le16 offset;
+	__le16 len;
+	u8 data[0];
+} __attribute__ ((packed));
+
 /*
  * this defines the PDR codes used to build PDAs as defined in document
  * number 553155. The current implementation mirrors version 1.1 of the
@@ -231,8 +239,13 @@ struct pda_country {
 /* reserved range (0x2000 - 0x7fff) */
 
 /* customer range (0x8000 - 0xffff) */
-#define PDR_BASEBAND_REGISTERS			0x8000
-#define PDR_PER_CHANNEL_BASEBAND_REGISTERS	0x8001
+#define PDR_BASEBAND_REGISTERS				0x8000
+#define PDR_PER_CHANNEL_BASEBAND_REGISTERS		0x8001
+
+/* used by our modificated eeprom image */
+#define PDR_RSSI_LINEAR_APPROXIMATION_CUSTOM		0xDEAD
+#define PDR_PRISM_PA_CAL_OUTPUT_POWER_LIMITS_CUSTOM	0xBEEF
+#define PDR_PRISM_PA_CAL_CURVE_DATA_CUSTOM		0xB05D
 
 /* PDR definitions for default country & country list */
 #define PDR_COUNTRY_CERT_CODE		0x80
@@ -434,7 +447,7 @@ struct p54_setup_mac {
 struct p54_scan {
 	__le16 mode;
 	__le16 dwell;
-	u8 padding1[20];
+	u8 scan_params[20];
 	struct pda_iq_autocal_entry iq_autocal;
 	u8 pa_points_per_curve;
 	u8 val_barker;
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2009-01-10 16:39:15.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2009-01-10 23:06:56.000000000 +0100
@@ -87,6 +87,14 @@ struct p54_rssi_linear_approximation {
 	s16 longbow_unk2;
 };
 
+struct p54_cal_database {
+	size_t entries;
+	size_t entry_size;
+	size_t offset;
+	size_t len;
+	u8 data[0];
+};
+
 #define EEPROM_READBACK_LEN 0x3fc
 
 #define ISL38XX_DEV_FIRMWARE_ADDR 0x20000
@@ -115,9 +123,8 @@ struct p54_common {
 	u8 tx_diversity_mask;
 	struct pda_iq_autocal_entry *iq_autocal;
 	unsigned int iq_autocal_len;
-	struct pda_channel_output_limit *output_limit;
-	unsigned int output_limit_len;
-	struct pda_pa_curve_data *curve_data;
+	struct p54_cal_database *output_limit;
+	struct p54_cal_database *curve_data;
 	struct p54_rssi_linear_approximation rssical_db[IEEE80211_NUM_BANDS];
 	unsigned int filter_flags;
 	bool use_short_slot;
