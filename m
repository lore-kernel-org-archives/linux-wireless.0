Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:46244 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbZAABC1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 20:02:27 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] p54: longbow frontend support
Date: Thu, 1 Jan 2009 02:02:23 +0100
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901010202.23446.chunkeey@web.de> (sfid-20090101_020231_782877_98C3A30A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for longbow RF chip.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2009-01-01 00:57:09.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2009-01-01 00:59:07.000000000 +0100
@@ -261,13 +261,19 @@ static int p54_convert_rev0(struct ieee8
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
@@ -307,13 +313,19 @@ static int p54_convert_rev1(struct ieee8
 	unsigned int i, j;
 	void *source, *target;
 
-	priv->curve_data = kmalloc(cd_len, GFP_KERNEL);
+	priv->curve_data = kmalloc(cd_len + sizeof(*priv->curve_data),
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
@@ -395,6 +407,27 @@ static void p54_parse_default_country(st
 	}
 }
 
+static int p54_parse_output_power_limits(struct ieee80211_hw *dev,
+					 struct pda_entry *entry)
+{
+	struct p54_common *priv = dev->priv;
+	priv->output_limit = kmalloc(entry->data[1] *
+		sizeof(struct pda_channel_output_limit) +
+		sizeof(*priv->output_limit), GFP_KERNEL);
+
+	if (!priv->output_limit)
+		return -ENOMEM;
+
+	priv->output_limit->entries = entry->data[1];
+	priv->output_limit->entry_size =
+		sizeof(struct pda_channel_output_limit);
+
+	memcpy(priv->output_limit->data, &entry->data[2],
+	       entry->data[1] * sizeof(*priv->output_limit));
+
+	return 0;
+}
+
 static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 {
 	struct p54_common *priv = dev->priv;
@@ -421,9 +454,14 @@ static int p54_parse_eeprom(struct ieee8
 
 		switch (le16_to_cpu(entry->code)) {
 		case PDR_MAC_ADDRESS:
+			if (data_len != ETH_ALEN)
+				break;
 			SET_IEEE80211_PERM_ADDR(dev, entry->data);
 			break;
 		case PDR_PRISM_PA_CAL_OUTPUT_POWER_LIMITS:
+			if (priv->output_limit)
+				break;
+
 			if (data_len < 2) {
 				err = -EINVAL;
 				goto err;
@@ -434,17 +472,10 @@ static int p54_parse_eeprom(struct ieee8
 				goto err;
 			}
 
-			priv->output_limit = kmalloc(entry->data[1] *
-				sizeof(*priv->output_limit), GFP_KERNEL);
-
-			if (!priv->output_limit) {
-				err = -ENOMEM;
+			err = p54_parse_output_power_limits(dev, entry);
+			if (err)
 				goto err;
-			}
 
-			memcpy(priv->output_limit, &entry->data[2],
-			       entry->data[1]*sizeof(*priv->output_limit));
-			priv->output_limit_len = entry->data[1];
 			break;
 		case PDR_PRISM_PA_CAL_CURVE_DATA: {
 			struct pda_pa_curve_data *curve_data =
@@ -496,6 +527,8 @@ static int p54_parse_eeprom(struct ieee8
 			}
 			break;
 		case PDR_HARDWARE_PLATFORM_COMPONENT_ID:
+			if (data_len < 2)
+				break;
 			priv->version = *(u8 *)(entry->data + 1);
 			break;
 		case PDR_RSSI_LINEAR_APPROXIMATION:
@@ -504,6 +537,37 @@ static int p54_parse_eeprom(struct ieee8
 			p54_parse_rssical(dev, entry->data, data_len,
 					  le16_to_cpu(entry->code));
 			break;
+		case PDR_RSSI_LINEAR_APPROXIMATION_CUSTOM:
+			if (data_len != sizeof(priv->rssical_db)) {
+				err = -EINVAL;
+				goto err;
+			}
+			memcpy(&priv->rssical_db, entry->data, data_len);
+			break;
+		case PDR_PRISM_PA_CAL_OUTPUT_POWER_LIMITS_CUSTOM: {
+			struct pda_custom_wrapper *tm = (void *) entry->data;
+			if (priv->output_limit != NULL)
+				break;
+			if (data_len < sizeof(*tm))
+				break;
+			if ((tm->entries * tm->entry_size != tm->len) ||
+			    (tm->len + sizeof(*tm) != data_len))
+				break;
+			priv->output_limit = kmemdup(tm, data_len, GFP_KERNEL);
+			}
+			break;
+		case PDR_PRISM_PA_CAL_CURVE_DATA_CUSTOM: {
+			struct pda_custom_wrapper *pda = (void *) entry->data;
+			if (priv->curve_data != NULL)
+				break;
+			if (data_len < sizeof(*pda))
+				break;
+			if ((pda->entries * pda->entry_size != pda->len) ||
+			    (pda->len + sizeof(*pda) != data_len))
+				break;
+			priv->curve_data = kmemdup(pda, data_len, GFP_KERNEL);
+			}
+			break;
 		case PDR_END:
 			/* make it overrun */
 			entry_len = len;
@@ -547,7 +611,7 @@ static int p54_parse_eeprom(struct ieee8
 	}
 
 	priv->rxhw = synth & PDR_SYNTH_FRONTEND_MASK;
-	if (priv->rxhw == 4)
+	if (priv->rxhw == PDR_SYNTH_FRONTEND_XBOW)
 		p54_init_xbow_synth(dev);
 	if (!(synth & PDR_SYNTH_24_GHZ_DISABLED))
 		dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
@@ -600,7 +664,14 @@ static int p54_rssi_to_dbm(struct ieee80
 	struct p54_common *priv = dev->priv;
 	int band = dev->conf.channel->band;
 
-	return ((rssi * priv->rssical_db[band].mul) / 64 +
+	if (priv->rxhw != PDR_SYNTH_FRONTEND_LONGBOW)
+		return ((rssi * priv->rssical_db[band].mul) / 64 +
+			 priv->rssical_db[band].add) / 4;
+	else
+		/*
+		 * TODO: find the correct formula
+		 */
+		return ((rssi * priv->rssical_db[band].mul) / 64 +
 			 priv->rssical_db[band].add) / 4;
 }
 
@@ -1494,8 +1565,13 @@ static int p54_tx(struct ieee80211_hw *d
 	memset(txhdr->durations, 0, sizeof(txhdr->durations));
 	txhdr->tx_antenna = ((info->antenna_sel_tx == 0) ?
 		2 : info->antenna_sel_tx - 1) & priv->tx_diversity_mask;
-	txhdr->output_power = priv->output_power;
-	txhdr->cts_rate = cts_rate;
+	if (priv->rxhw == PDR_SYNTH_FRONTEND_LONGBOW) {
+		txhdr->longbow.cts_rate = cts_rate;
+		txhdr->longbow.output_power = cpu_to_le16(priv->output_power);
+	} else {
+		txhdr->normal.output_power = priv->output_power;
+		txhdr->normal.cts_rate = cts_rate;
+	}
 	if (padding)
 		txhdr->align[0] = padding;
 
@@ -1598,85 +1674,135 @@ static int p54_scan(struct ieee80211_hw 
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
-	struct p54_scan *chan;
+	struct p54_hdr *hdr;
+	struct p54_scan_head *head;
+	struct p54_iq_autocal_entry *iq_autocal;
+	union p54_scan_body_union *body;
+	struct p54_scan_tail_rate *rate;
+	struct pda_rssi_cal_entry *rssi;
+
 	unsigned int i;
 	void *entry;
 	__le16 freq = cpu_to_le16(dev->conf.channel->center_freq);
 	int band = dev->conf.channel->band;
 
-	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*chan) +
-			    sizeof(struct p54_hdr), P54_CONTROL_TYPE_SCAN,
-			    GFP_ATOMIC);
+	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*hdr) +
+			    sizeof(*head) + 2 + sizeof(*iq_autocal) +
+			    sizeof(*body) + sizeof(*rate) + 2 * sizeof(*rssi),
+			    P54_CONTROL_TYPE_SCAN, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
-	chan = (struct p54_scan *) skb_put(skb, sizeof(*chan));
-	memset(chan->padding1, 0, sizeof(chan->padding1));
-	chan->mode = cpu_to_le16(mode);
-	chan->dwell = cpu_to_le16(dwell);
+	head = (struct p54_scan_head *) skb_put(skb, sizeof(*head));
+	memset(head->scanning, 0, sizeof(head->scanning));
+	head->mode = cpu_to_le16(mode);
+	head->dwell = cpu_to_le16(dwell);
+	head->freq = freq;
+
+	if (priv->rxhw == PDR_SYNTH_FRONTEND_LONGBOW) {
+		__le16 *pa_power_points = (__le16 *) skb_put(skb, 2);
+		*pa_power_points = cpu_to_le16(0x0c);
+	}
 
+	iq_autocal = (void *) skb_put(skb, sizeof(*iq_autocal));
 	for (i = 0; i < priv->iq_autocal_len; i++) {
 		if (priv->iq_autocal[i].freq != freq)
 			continue;
 
-		memcpy(&chan->iq_autocal, &priv->iq_autocal[i],
-		       sizeof(*priv->iq_autocal));
+		memcpy(iq_autocal, &priv->iq_autocal[i].params,
+		       sizeof(struct p54_iq_autocal_entry));
 		break;
 	}
 	if (i == priv->iq_autocal_len)
 		goto err;
 
-	for (i = 0; i < priv->output_limit_len; i++) {
-		if (priv->output_limit[i].freq != freq)
+	if (priv->rxhw == PDR_SYNTH_FRONTEND_LONGBOW)
+		body = (void *) skb_put(skb, sizeof(body->longbow));
+	else
+		body = (void *) skb_put(skb, sizeof(body->normal));
+
+	for (i = 0; i < priv->output_limit->entries; i++) {
+		__le16 *entry_freq = (void *) (priv->output_limit->data +
+				     priv->output_limit->entry_size * i);
+
+		if (*entry_freq != freq)
 			continue;
 
-		chan->val_barker = 0x38;
-		chan->val_bpsk = chan->dup_bpsk =
-			priv->output_limit[i].val_bpsk;
-		chan->val_qpsk = chan->dup_qpsk =
-			priv->output_limit[i].val_qpsk;
-		chan->val_16qam = chan->dup_16qam =
-			priv->output_limit[i].val_16qam;
-		chan->val_64qam = chan->dup_64qam =
-			priv->output_limit[i].val_64qam;
+		if (priv->rxhw == PDR_SYNTH_FRONTEND_LONGBOW) {
+			memcpy(&body->longbow.power_limits,
+			       (void *) entry_freq + sizeof(__le16),
+			       priv->output_limit->entry_size);
+		} else {
+			struct pda_channel_output_limit *limits =
+			       (void *) entry_freq;
+
+			body->normal.val_barker = 0x38;
+			body->normal.val_bpsk = body->normal.dup_bpsk =
+				limits->val_bpsk;
+			body->normal.val_qpsk = body->normal.dup_qpsk =
+				limits->val_qpsk;
+			body->normal.val_16qam = body->normal.dup_16qam =
+				limits->val_16qam;
+			body->normal.val_64qam = body->normal.dup_64qam =
+				limits->val_64qam;
+		}
 		break;
 	}
-	if (i == priv->output_limit_len)
+	if (i == priv->output_limit->entries)
 		goto err;
 
-	entry = priv->curve_data->data;
-	for (i = 0; i < priv->curve_data->channels; i++) {
+	entry = (void *)(priv->curve_data->data + priv->curve_data->offset);
+	for (i = 0; i < priv->curve_data->entries; i++) {
 		if (*((__le16 *)entry) != freq) {
-			entry += sizeof(__le16);
-			entry += sizeof(struct p54_pa_curve_data_sample) *
-				 priv->curve_data->points_per_channel;
+			entry += priv->curve_data->entry_size;
 			continue;
 		}
 
-		entry += sizeof(__le16);
-		chan->pa_points_per_curve = 8;
-		memset(chan->curve_data, 0, sizeof(*chan->curve_data));
-		memcpy(chan->curve_data, entry,
-		       sizeof(struct p54_pa_curve_data_sample) *
-		       min((u8)8, priv->curve_data->points_per_channel));
+		if (priv->rxhw == PDR_SYNTH_FRONTEND_LONGBOW) {
+			memcpy(&body->longbow.curve_data,
+				(void *) entry + sizeof(__le16),
+				priv->curve_data->entry_size);
+		} else {
+			struct p54_scan_body *chan = &body->normal;
+			struct pda_pa_curve_data *curve_data =
+				(void *) priv->curve_data->data;
+
+			entry += sizeof(__le16);
+			chan->pa_points_per_curve = 8;
+			memset(chan->curve_data, 0, sizeof(*chan->curve_data));
+			memcpy(chan->curve_data, entry,
+			       sizeof(struct p54_pa_curve_data_sample) *
+			       min((u8)8, curve_data->points_per_channel));
+		}
 		break;
 	}
 
-	if (priv->fw_var < 0x500) {
-		chan->v1_rssi.mul = cpu_to_le16(priv->rssical_db[band].mul);
-		chan->v1_rssi.add = cpu_to_le16(priv->rssical_db[band].add);
-	} else {
-		chan->v2.rssi.mul = cpu_to_le16(priv->rssical_db[band].mul);
-		chan->v2.rssi.add = cpu_to_le16(priv->rssical_db[band].add);
-		chan->v2.basic_rate_mask = cpu_to_le32(priv->basic_rate_mask);
-		memset(chan->v2.rts_rates, 0, 8);
+	if (priv->fw_var >= 0x500) {
+		rate = (void *) skb_put(skb, sizeof(*rate));
+		rate->basic_rate_mask = cpu_to_le32(priv->basic_rate_mask);
+		/* TODO: initialize a RTS rate array */
+		memset(rate->rts_rates, 0, 8);
+	}
+
+	rssi = (struct pda_rssi_cal_entry *) skb_put(skb, sizeof(*rssi));
+	rssi->mul = cpu_to_le16(priv->rssical_db[band].mul);
+	rssi->add = cpu_to_le16(priv->rssical_db[band].add);
+	if (priv->rxhw == PDR_SYNTH_FRONTEND_LONGBOW) {
+		/* Longbow frontend needs ever more */
+		rssi = (void *) skb_put(skb, sizeof(*rssi));
+		rssi->mul = cpu_to_le16(priv->rssical_db[band].longbow_unkn);
+		rssi->add = cpu_to_le16(priv->rssical_db[band].longbow_unk2);
 	}
+
+	hdr = (struct p54_hdr *) skb->data;
+	hdr->len = skb->len - sizeof(*hdr);
+
 	priv->tx(dev, skb);
 	return 0;
 
  err:
 	printk(KERN_ERR "%s: frequency change failed\n", wiphy_name(dev->wiphy));
-	kfree_skb(skb);
+	p54_free_skb(dev, skb);
 	return -EINVAL;
 }
 
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2009-01-01 00:57:09.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2009-01-01 00:58:14.000000000 +0100
@@ -26,6 +26,11 @@ struct bootrec {
 } __attribute__((packed));
 
 #define PDR_SYNTH_FRONTEND_MASK		0x0007
+#define PDR_SYNTH_FRONTEND_DUETTE3	0x0001
+#define PDR_SYNTH_FRONTEND_DUETTE2	0x0002
+#define PDR_SYNTH_FRONTEND_FRISBEE	0x0003
+#define PDR_SYNTH_FRONTEND_XBOW		0x0004
+#define PDR_SYNTH_FRONTEND_LONGBOW	0x0005
 #define PDR_SYNTH_IQ_CAL_MASK		0x0018
 #define PDR_SYNTH_IQ_CAL_PA_DETECTOR	0x0000
 #define PDR_SYNTH_IQ_CAL_DISABLED	0x0008
@@ -125,9 +130,13 @@ struct eeprom_pda_wrap {
 	u8 data[0];
 } __attribute__ ((packed));
 
+struct p54_iq_autocal_entry {
+	__le16 iq_param[4];
+} __attribute__ ((packed));
+
 struct pda_iq_autocal_entry {
         __le16 freq;
-        __le16 iq_param[4];
+	struct p54_iq_autocal_entry params;
 } __attribute__ ((packed));
 
 struct pda_channel_output_limit {
@@ -187,6 +196,29 @@ struct pda_country {
 } __attribute__ ((packed));
 
 /*
+ * Warning: Longbow's structures are bogus.
+ */
+struct p54_channel_output_limit_longbow {
+	__le16 rf_power_points[12];
+} __attribute__ ((packed));
+
+struct p54_pa_curve_data_sample_longbow {
+	__le16 rf_power;
+	__le16 pa_detector;
+	struct {
+		__le16 data[4];
+	} points[3] __attribute__ ((packed));
+} __attribute__ ((packed));
+
+struct pda_custom_wrapper {
+	__le16 entries;
+	__le16 entry_size;
+	__le16 offset;
+	__le16 len;
+	u8 data[0];
+} __attribute__ ((packed));
+
+/*
  * this defines the PDR codes used to build PDAs as defined in document
  * number 553155. The current implementation mirrors version 1.1 of the
  * document and lists only PDRs supported by the ARM platform.
@@ -231,8 +263,13 @@ struct pda_country {
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
@@ -374,9 +411,18 @@ struct p54_tx_data {
 	u8 backlog;
 	__le16 durations[4];
 	u8 tx_antenna;
-	u8 output_power;
-	u8 cts_rate;
-	u8 unalloc2[3];
+	union {
+		struct {
+			u8 cts_rate;
+			__le16 output_power;
+		} __attribute__((packed)) longbow;
+		struct {
+			u8 output_power;
+			u8 cts_rate;
+			u8 unalloc;
+		} __attribute__ ((packed)) normal;
+	} __attribute__ ((packed));
+	u8 unalloc2[2];
 	u8 align[0];
 } __attribute__ ((packed));
 
@@ -437,11 +483,14 @@ struct p54_setup_mac {
 #define P54_SCAN_ACTIVE BIT(2)
 #define P54_SCAN_FILTER BIT(3)
 
-struct p54_scan {
+struct p54_scan_head {
 	__le16 mode;
 	__le16 dwell;
-	u8 padding1[20];
-	struct pda_iq_autocal_entry iq_autocal;
+	u8 scanning[20];
+	__le16 freq;
+} __attribute__ ((packed));
+
+struct p54_scan_body {
 	u8 pa_points_per_curve;
 	u8 val_barker;
 	u8 val_bpsk;
@@ -453,19 +502,23 @@ struct p54_scan {
 	u8 dup_qpsk;
 	u8 dup_16qam;
 	u8 dup_64qam;
-	union {
-		struct pda_rssi_cal_entry v1_rssi;
+} __attribute__ ((packed));
 
-		struct {
-			__le32 basic_rate_mask;
-			u8 rts_rates[8];
-			struct pda_rssi_cal_entry rssi;
-		} v2 __attribute__ ((packed));
-	} __attribute__ ((packed));
+struct p54_scan_body_longbow {
+	struct p54_channel_output_limit_longbow power_limits;
+	struct p54_pa_curve_data_sample_longbow curve_data[8];
+	__le16 unkn[6];		/* maybe more power_limits or rate_mask */
 } __attribute__ ((packed));
 
-#define P54_SCAN_V1_LEN 0x70
-#define P54_SCAN_V2_LEN 0x7c
+union p54_scan_body_union {
+	struct p54_scan_body normal;
+	struct p54_scan_body_longbow longbow;
+} __attribute__ ((packed));
+
+struct p54_scan_tail_rate {
+	__le32 basic_rate_mask;
+	u8 rts_rates[8];
+} __attribute__ ((packed));
 
 struct p54_led {
 	__le16 mode;
diff -Nurp a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
--- a/drivers/net/wireless/p54/p54.h	2009-01-01 00:57:09.000000000 +0100
+++ b/drivers/net/wireless/p54/p54.h	2009-01-01 00:58:14.000000000 +0100
@@ -103,9 +103,8 @@ struct p54_common {
 	u8 tx_diversity_mask;
 	struct pda_iq_autocal_entry *iq_autocal;
 	unsigned int iq_autocal_len;
-	struct pda_channel_output_limit *output_limit;
-	unsigned int output_limit_len;
-	struct pda_pa_curve_data *curve_data;
+	struct pda_custom_wrapper *output_limit;
+	struct pda_custom_wrapper *curve_data;
 	struct p54_rssi_linear_approximation rssical_db[IEEE80211_NUM_BANDS];
 	unsigned int filter_flags;
 	bool use_short_slot;
