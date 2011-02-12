Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63697 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1BLW2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 17:28:20 -0500
Received: by fxm20 with SMTP id 20so3925908fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 Feb 2011 14:28:18 -0800 (PST)
Message-Id: <50e288fa312fbeef461043181587959576545f8d.1297548925.git.chunkeey@googlemail.com>
In-Reply-To: <22063045349cb651b39a410a66fcdfedf7eb3a0c.1297548925.git.chunkeey@googlemail.com>
References: <a1716888d72252e775f666c0caf6aa15cd0de33b.1297548925.git.chunkeey@googlemail.com>
	<22063045349cb651b39a410a66fcdfedf7eb3a0c.1297548925.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 12 Feb 2011 22:32:49 +0100
Subject: [PATCH 3/4] p54: enhance rssi->dBm database import
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes several shortcomings of the
previous implementation. Features of the
rewrite include:

 * handles undocumented "0x0000" word at the
   start of the frequency table.
   (Affected some early? DELL 1450 USB devices
    and my Symbol 5GHz miniPCI card.)

 * supports more than just one reference point
   per band. (Also needed for the Symbol card.)

 * ships with default values in case the eeprom
   data is damaged, absent or unsupported.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/eeprom.c |  182 +++++++++++++++++++++++++++++++------
 drivers/net/wireless/p54/eeprom.h |    7 ++
 drivers/net/wireless/p54/fwio.c   |   12 ++-
 drivers/net/wireless/p54/lmac.h   |    1 +
 drivers/net/wireless/p54/main.c   |    2 +
 drivers/net/wireless/p54/p54.h    |    6 +-
 drivers/net/wireless/p54/txrx.c   |    6 +-
 7 files changed, 175 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index 360bc78..c04bcbe 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -55,6 +55,17 @@ static struct ieee80211_rate p54_arates[] = {
 	{ .bitrate = 540, .hw_value = 11, },
 };
 
+static struct p54_rssi_db_entry p54_rssi_default = {
+	/*
+	 * The defaults are taken from usb-logs of the
+	 * vendor driver. So, they should be safe to
+	 * use in case we can't get a match from the
+	 * rssi <-> dBm conversion database.
+	 */
+	.mul = 130,
+	.add = -398,
+};
+
 #define CHAN_HAS_CAL		BIT(0)
 #define CHAN_HAS_LIMIT		BIT(1)
 #define CHAN_HAS_CURVE		BIT(2)
@@ -87,6 +98,11 @@ static int p54_get_band_from_freq(u16 freq)
 	return -1;
 }
 
+static int same_band(u16 freq, u16 freq2)
+{
+	return p54_get_band_from_freq(freq) == p54_get_band_from_freq(freq2);
+}
+
 static int p54_compare_channels(const void *_a,
 				const void *_b)
 {
@@ -96,6 +112,15 @@ static int p54_compare_channels(const void *_a,
 	return a->freq - b->freq;
 }
 
+static int p54_compare_rssichan(const void *_a,
+				const void *_b)
+{
+	const struct p54_rssi_db_entry *a = _a;
+	const struct p54_rssi_db_entry *b = _b;
+
+	return a->freq - b->freq;
+}
+
 static int p54_fill_band_bitrates(struct ieee80211_hw *dev,
 				  struct ieee80211_supported_band *band_entry,
 				  enum ieee80211_band band)
@@ -411,33 +436,118 @@ static int p54_convert_rev1(struct ieee80211_hw *dev,
 static const char *p54_rf_chips[] = { "INVALID-0", "Duette3", "Duette2",
 	"Frisbee", "Xbow", "Longbow", "INVALID-6", "INVALID-7" };
 
-static void p54_parse_rssical(struct ieee80211_hw *dev, void *data, int len,
-			     u16 type)
+static int p54_parse_rssical(struct ieee80211_hw *dev,
+			     u8 *data, int len, u16 type)
 {
 	struct p54_common *priv = dev->priv;
-	int offset = (type == PDR_RSSI_LINEAR_APPROXIMATION_EXTENDED) ? 2 : 0;
-	int entry_size = sizeof(struct pda_rssi_cal_entry) + offset;
-	int num_entries = (type == PDR_RSSI_LINEAR_APPROXIMATION) ? 1 : 2;
-	int i;
+	struct p54_rssi_db_entry *entry;
+	size_t db_len, entries;
+	int offset = 0, i;
+
+	if (type != PDR_RSSI_LINEAR_APPROXIMATION_EXTENDED) {
+		entries = (type == PDR_RSSI_LINEAR_APPROXIMATION) ? 1 : 2;
+		if (len != sizeof(struct pda_rssi_cal_entry) * entries) {
+			wiphy_err(dev->wiphy, "rssical size mismatch.\n");
+			goto err_data;
+		}
+	} else {
+		/*
+		 * Some devices (Dell 1450 USB, Xbow 5GHz card, etc...)
+		 * have an empty two byte header.
+		 */
+		if (*((__le16 *)&data[offset]) == cpu_to_le16(0))
+			offset += 2;
 
-	if (len != (entry_size * num_entries)) {
-		wiphy_err(dev->wiphy,
-			  "unknown rssi calibration data packing type:(%x) len:%d.\n",
-			  type, len);
+		entries = (len - offset) /
+			sizeof(struct pda_rssi_cal_ext_entry);
 
-		print_hex_dump_bytes("rssical:", DUMP_PREFIX_NONE,
-				     data, len);
+		if ((len - offset) % sizeof(struct pda_rssi_cal_ext_entry) ||
+		    entries <= 0) {
+			wiphy_err(dev->wiphy, "invalid rssi database.\n");
+			goto err_data;
+		}
+	}
 
-		wiphy_err(dev->wiphy, "please report this issue.\n");
-		return;
+	db_len = sizeof(*entry) * entries;
+	priv->rssi_db = kzalloc(db_len + sizeof(*priv->rssi_db), GFP_KERNEL);
+	if (!priv->rssi_db)
+		return -ENOMEM;
+
+	priv->rssi_db->offset = 0;
+	priv->rssi_db->entries = entries;
+	priv->rssi_db->entry_size = sizeof(*entry);
+	priv->rssi_db->len = db_len;
+
+	entry = (void *)((unsigned long)priv->rssi_db->data + priv->rssi_db->offset);
+	if (type == PDR_RSSI_LINEAR_APPROXIMATION_EXTENDED) {
+		struct pda_rssi_cal_ext_entry *cal = (void *) &data[offset];
+
+		for (i = 0; i < entries; i++) {
+			entry[i].freq = le16_to_cpu(cal[i].freq);
+			entry[i].mul = (s16) le16_to_cpu(cal[i].mul);
+			entry[i].add = (s16) le16_to_cpu(cal[i].add);
+		}
+	} else {
+		struct pda_rssi_cal_entry *cal = (void *) &data[offset];
+
+		for (i = 0; i < entries; i++) {
+			u16 freq;
+			switch (i) {
+			case IEEE80211_BAND_2GHZ:
+				freq = 2437;
+				break;
+			case IEEE80211_BAND_5GHZ:
+				freq = 5240;
+				break;
+			}
+
+			entry[i].freq = freq;
+			entry[i].mul = (s16) le16_to_cpu(cal[i].mul);
+			entry[i].add = (s16) le16_to_cpu(cal[i].add);
+		}
 	}
 
-	for (i = 0; i < num_entries; i++) {
-		struct pda_rssi_cal_entry *cal = data +
-						 (offset + i * entry_size);
-		priv->rssical_db[i].mul = (s16) le16_to_cpu(cal->mul);
-		priv->rssical_db[i].add = (s16) le16_to_cpu(cal->add);
+	/* sort the list by channel frequency */
+	sort(entry, entries, sizeof(*entry), p54_compare_rssichan, NULL);
+	return 0;
+
+err_data:
+	wiphy_err(dev->wiphy,
+		  "rssi calibration data packing type:(%x) len:%d.\n",
+		  type, len);
+
+	print_hex_dump_bytes("rssical:", DUMP_PREFIX_NONE, data, len);
+
+	wiphy_err(dev->wiphy, "please report this issue.\n");
+	return -EINVAL;
+}
+
+struct p54_rssi_db_entry *p54_rssi_find(struct p54_common *priv, const u16 freq)
+{
+	struct p54_rssi_db_entry *entry = (void *)(priv->rssi_db->data +
+						   priv->rssi_db->offset);
+	int i, found = -1;
+
+	for (i = 0; i < priv->rssi_db->entries; i++) {
+		if (!same_band(freq, entry[i].freq))
+			continue;
+
+		if (found == -1) {
+			found = i;
+			continue;
+		}
+
+		/* nearest match */
+		if (abs(freq - entry[i].freq) <
+		    abs(freq - entry[found].freq)) {
+			found = i;
+			continue;
+		} else {
+			break;
+		}
 	}
+
+	return found < 0 ? &p54_rssi_default : &entry[found];
 }
 
 static void p54_parse_default_country(struct ieee80211_hw *dev,
@@ -628,21 +738,30 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 		case PDR_RSSI_LINEAR_APPROXIMATION:
 		case PDR_RSSI_LINEAR_APPROXIMATION_DUAL_BAND:
 		case PDR_RSSI_LINEAR_APPROXIMATION_EXTENDED:
-			p54_parse_rssical(dev, entry->data, data_len,
-					  le16_to_cpu(entry->code));
+			err = p54_parse_rssical(dev, entry->data, data_len,
+						le16_to_cpu(entry->code));
+			if (err)
+				goto err;
 			break;
-		case PDR_RSSI_LINEAR_APPROXIMATION_CUSTOM: {
-			__le16 *src = (void *) entry->data;
-			s16 *dst = (void *) &priv->rssical_db;
+		case PDR_RSSI_LINEAR_APPROXIMATION_CUSTOMV2: {
+			struct pda_custom_wrapper *pda = (void *) entry->data;
+			__le16 *src;
+			u16 *dst;
 			int i;
 
-			if (data_len != sizeof(priv->rssical_db)) {
-				err = -EINVAL;
-				goto err;
-			}
-			for (i = 0; i < sizeof(priv->rssical_db) /
-					sizeof(*src); i++)
+			if (priv->rssi_db || data_len < sizeof(*pda))
+				break;
+
+			priv->rssi_db = p54_convert_db(pda, data_len);
+			if (!priv->rssi_db)
+				break;
+
+			src = (void *) priv->rssi_db->data;
+			dst = (void *) priv->rssi_db->data;
+
+			for (i = 0; i < priv->rssi_db->entries; i++)
 				*(dst++) = (s16) le16_to_cpu(*(src++));
+
 			}
 			break;
 		case PDR_PRISM_PA_CAL_OUTPUT_POWER_LIMITS_CUSTOM: {
@@ -718,6 +837,8 @@ good_eeprom:
 		SET_IEEE80211_PERM_ADDR(dev, perm_addr);
 	}
 
+	priv->cur_rssi = &p54_rssi_default;
+
 	wiphy_info(dev->wiphy, "hwaddr %pM, MAC:isl38%02x RF:%s\n",
 		   dev->wiphy->perm_addr, priv->version,
 		   p54_rf_chips[priv->rxhw]);
@@ -728,9 +849,11 @@ err:
 	kfree(priv->iq_autocal);
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
+	kfree(priv->rssi_db);
 	priv->iq_autocal = NULL;
 	priv->output_limit = NULL;
 	priv->curve_data = NULL;
+	priv->rssi_db = NULL;
 
 	wiphy_err(dev->wiphy, "eeprom parse failed!\n");
 	return err;
diff --git a/drivers/net/wireless/p54/eeprom.h b/drivers/net/wireless/p54/eeprom.h
index 9051aef..afde72b 100644
--- a/drivers/net/wireless/p54/eeprom.h
+++ b/drivers/net/wireless/p54/eeprom.h
@@ -81,6 +81,12 @@ struct pda_pa_curve_data {
 	u8 data[0];
 } __packed;
 
+struct pda_rssi_cal_ext_entry {
+	__le16 freq;
+	__le16 mul;
+	__le16 add;
+} __packed;
+
 struct pda_rssi_cal_entry {
 	__le16 mul;
 	__le16 add;
@@ -179,6 +185,7 @@ struct pda_custom_wrapper {
 
 /* used by our modificated eeprom image */
 #define PDR_RSSI_LINEAR_APPROXIMATION_CUSTOM		0xDEAD
+#define PDR_RSSI_LINEAR_APPROXIMATION_CUSTOMV2		0xCAFF
 #define PDR_PRISM_PA_CAL_OUTPUT_POWER_LIMITS_CUSTOM	0xBEEF
 #define PDR_PRISM_PA_CAL_CURVE_DATA_CUSTOM		0xB05D
 
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 92b9b1f..0d3d108 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -397,9 +397,9 @@ int p54_scan(struct p54_common *priv, u16 mode, u16 dwell)
 	union p54_scan_body_union *body;
 	struct p54_scan_tail_rate *rate;
 	struct pda_rssi_cal_entry *rssi;
+	struct p54_rssi_db_entry *rssi_data;
 	unsigned int i;
 	void *entry;
-	int band = priv->hw->conf.channel->band;
 	__le16 freq = cpu_to_le16(priv->hw->conf.channel->center_freq);
 
 	skb = p54_alloc_skb(priv, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*head) +
@@ -503,13 +503,14 @@ int p54_scan(struct p54_common *priv, u16 mode, u16 dwell)
 	}
 
 	rssi = (struct pda_rssi_cal_entry *) skb_put(skb, sizeof(*rssi));
-	rssi->mul = cpu_to_le16(priv->rssical_db[band].mul);
-	rssi->add = cpu_to_le16(priv->rssical_db[band].add);
+	rssi_data = p54_rssi_find(priv, le16_to_cpu(freq));
+	rssi->mul = cpu_to_le16(rssi_data->mul);
+	rssi->add = cpu_to_le16(rssi_data->add);
 	if (priv->rxhw == PDR_SYNTH_FRONTEND_LONGBOW) {
 		/* Longbow frontend needs ever more */
 		rssi = (void *) skb_put(skb, sizeof(*rssi));
-		rssi->mul = cpu_to_le16(priv->rssical_db[band].longbow_unkn);
-		rssi->add = cpu_to_le16(priv->rssical_db[band].longbow_unk2);
+		rssi->mul = cpu_to_le16(rssi_data->longbow_unkn);
+		rssi->add = cpu_to_le16(rssi_data->longbow_unk2);
 	}
 
 	if (priv->fw_var >= 0x509) {
@@ -523,6 +524,7 @@ int p54_scan(struct p54_common *priv, u16 mode, u16 dwell)
 	hdr->len = cpu_to_le16(skb->len - sizeof(*hdr));
 
 	p54_tx(priv, skb);
+	priv->cur_rssi = rssi_data;
 	return 0;
 
 err:
diff --git a/drivers/net/wireless/p54/lmac.h b/drivers/net/wireless/p54/lmac.h
index b59374d..09e8e8c 100644
--- a/drivers/net/wireless/p54/lmac.h
+++ b/drivers/net/wireless/p54/lmac.h
@@ -551,6 +551,7 @@ int p54_upload_key(struct p54_common *priv, u8 algo, int slot,
 /* eeprom */
 int p54_download_eeprom(struct p54_common *priv, void *buf,
 			u16 offset, u16 len);
+struct p54_rssi_db_entry *p54_rssi_find(struct p54_common *p, const u16 freq);
 
 /* utility */
 u8 *p54_find_ie(u8 *data, const size_t len, const u8 ie);
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 761a03b..d176afa 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -642,10 +642,12 @@ void p54_free_common(struct ieee80211_hw *dev)
 	kfree(priv->iq_autocal);
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
+	kfree(priv->rssi_db);
 	kfree(priv->used_rxkeys);
 	priv->iq_autocal = NULL;
 	priv->output_limit = NULL;
 	priv->curve_data = NULL;
+	priv->rssi_db = NULL;
 	priv->used_rxkeys = NULL;
 	ieee80211_free_hw(dev);
 }
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 43a3b2e..f951c8f 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -116,7 +116,8 @@ struct p54_edcf_queue_param {
 	__le16 txop;
 } __packed;
 
-struct p54_rssi_linear_approximation {
+struct p54_rssi_db_entry {
+	u16 freq;
 	s16 mul;
 	s16 add;
 	s16 longbow_unkn;
@@ -197,13 +198,14 @@ struct p54_common {
 	u8 rx_diversity_mask;
 	u8 tx_diversity_mask;
 	unsigned int output_power;
+	struct p54_rssi_db_entry *cur_rssi;
 	int noise;
 	/* calibration, output power limit and rssi<->dBm conversation data */
 	struct pda_iq_autocal_entry *iq_autocal;
 	unsigned int iq_autocal_len;
 	struct p54_cal_database *curve_data;
 	struct p54_cal_database *output_limit;
-	struct p54_rssi_linear_approximation rssical_db[IEEE80211_NUM_BANDS];
+	struct p54_cal_database *rssi_db;
 	struct ieee80211_supported_band *band_table[IEEE80211_NUM_BANDS];
 
 	/* BBP/MAC state */
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 344ccd5..c4b440b 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -273,11 +273,9 @@ void p54_tx(struct p54_common *priv, struct sk_buff *skb)
 
 static int p54_rssi_to_dbm(struct p54_common *priv, int rssi)
 {
-	int band = priv->hw->conf.channel->band;
-
 	if (priv->rxhw != 5) {
-		return ((rssi * priv->rssical_db[band].mul) / 64 +
-			 priv->rssical_db[band].add) / 4;
+		return ((rssi * priv->cur_rssi->mul) / 64 +
+			 priv->cur_rssi->add) / 4;
 	} else {
 		/*
 		 * TODO: find the correct formula
-- 
1.7.2.3

