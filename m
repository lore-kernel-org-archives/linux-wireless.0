Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:36594 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbZGJXYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 19:24:34 -0400
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: generate channel list dynamically
Date: Sat, 11 Jul 2009 01:22:26 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200907110122.26937.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enhances the eeprom parser to generate customized
channel list for every device.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index a2a044e..549ef2d 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
+#include <linux/sort.h>
 
 #include <net/mac80211.h>
 
@@ -41,30 +42,6 @@ static struct ieee80211_rate p54_bgrates[] = {
 	{ .bitrate = 540, .hw_value = 11, },
 };
 
-static struct ieee80211_channel p54_bgchannels[] = {
-	{ .center_freq = 2412, .hw_value = 1, },
-	{ .center_freq = 2417, .hw_value = 2, },
-	{ .center_freq = 2422, .hw_value = 3, },
-	{ .center_freq = 2427, .hw_value = 4, },
-	{ .center_freq = 2432, .hw_value = 5, },
-	{ .center_freq = 2437, .hw_value = 6, },
-	{ .center_freq = 2442, .hw_value = 7, },
-	{ .center_freq = 2447, .hw_value = 8, },
-	{ .center_freq = 2452, .hw_value = 9, },
-	{ .center_freq = 2457, .hw_value = 10, },
-	{ .center_freq = 2462, .hw_value = 11, },
-	{ .center_freq = 2467, .hw_value = 12, },
-	{ .center_freq = 2472, .hw_value = 13, },
-	{ .center_freq = 2484, .hw_value = 14, },
-};
-
-static struct ieee80211_supported_band band_2GHz = {
-	.channels = p54_bgchannels,
-	.n_channels = ARRAY_SIZE(p54_bgchannels),
-	.bitrates = p54_bgrates,
-	.n_bitrates = ARRAY_SIZE(p54_bgrates),
-};
-
 static struct ieee80211_rate p54_arates[] = {
 	{ .bitrate = 60, .hw_value = 4, },
 	{ .bitrate = 90, .hw_value = 5, },
@@ -76,51 +53,257 @@ static struct ieee80211_rate p54_arates[] = {
 	{ .bitrate = 540, .hw_value = 11, },
 };
 
-static struct ieee80211_channel p54_achannels[] = {
-	{ .center_freq = 4920 },
-	{ .center_freq = 4940 },
-	{ .center_freq = 4960 },
-	{ .center_freq = 4980 },
-	{ .center_freq = 5040 },
-	{ .center_freq = 5060 },
-	{ .center_freq = 5080 },
-	{ .center_freq = 5170 },
-	{ .center_freq = 5180 },
-	{ .center_freq = 5190 },
-	{ .center_freq = 5200 },
-	{ .center_freq = 5210 },
-	{ .center_freq = 5220 },
-	{ .center_freq = 5230 },
-	{ .center_freq = 5240 },
-	{ .center_freq = 5260 },
-	{ .center_freq = 5280 },
-	{ .center_freq = 5300 },
-	{ .center_freq = 5320 },
-	{ .center_freq = 5500 },
-	{ .center_freq = 5520 },
-	{ .center_freq = 5540 },
-	{ .center_freq = 5560 },
-	{ .center_freq = 5580 },
-	{ .center_freq = 5600 },
-	{ .center_freq = 5620 },
-	{ .center_freq = 5640 },
-	{ .center_freq = 5660 },
-	{ .center_freq = 5680 },
-	{ .center_freq = 5700 },
-	{ .center_freq = 5745 },
-	{ .center_freq = 5765 },
-	{ .center_freq = 5785 },
-	{ .center_freq = 5805 },
-	{ .center_freq = 5825 },
+#define CHAN_HAS_CAL		BIT(0)
+#define CHAN_HAS_LIMIT		BIT(1)
+#define CHAN_HAS_CURVE		BIT(2)
+#define CHAN_HAS_ALL		(CHAN_HAS_CAL | CHAN_HAS_LIMIT | CHAN_HAS_CURVE)
+
+struct p54_channel_entry {
+	u16 freq;
+	u16 data;
+	int index;
+	enum ieee80211_band band;
 };
 
-static struct ieee80211_supported_band band_5GHz = {
-	.channels = p54_achannels,
-	.n_channels = ARRAY_SIZE(p54_achannels),
-	.bitrates = p54_arates,
-	.n_bitrates = ARRAY_SIZE(p54_arates),
+struct p54_channel_list {
+	struct p54_channel_entry *channels;
+	size_t entries;
+	size_t max_entries;
+	size_t band_channel_num[IEEE80211_NUM_BANDS];
 };
 
+static int p54_get_band_from_freq(u16 freq)
+{
+	/* FIXME: sync these values with the 802.11 spec */
+
+	if ((freq >= 2412) && (freq <= 2484))
+		return IEEE80211_BAND_2GHZ;
+
+	if ((freq >= 4920) && (freq <= 5825))
+		return IEEE80211_BAND_5GHZ;
+
+	return -1;
+}
+
+static int p54_compare_channels(const void *_a,
+				const void *_b)
+{
+	const struct p54_channel_entry *a = _a;
+	const struct p54_channel_entry *b = _b;
+
+	return a->index - b->index;
+}
+
+static int p54_fill_band_bitrates(struct ieee80211_hw *dev,
+				  struct ieee80211_supported_band *band_entry,
+				  enum ieee80211_band band)
+{
+	/* TODO: generate rate array dynamically */
+
+	switch (band) {
+	case IEEE80211_BAND_2GHZ:
+		band_entry->bitrates = p54_bgrates;
+		band_entry->n_bitrates = ARRAY_SIZE(p54_bgrates);
+		break;
+	case IEEE80211_BAND_5GHZ:
+		band_entry->bitrates = p54_arates;
+		band_entry->n_bitrates = ARRAY_SIZE(p54_arates);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int p54_generate_band(struct ieee80211_hw *dev,
+			     struct p54_channel_list *list,
+			     enum ieee80211_band band)
+{
+	struct p54_common *priv = dev->priv;
+	struct ieee80211_supported_band *tmp, *old;
+	unsigned int i, j;
+	int ret = -ENOMEM;
+
+	if ((!list->entries) || (!list->band_channel_num[band]))
+		return 0;
+
+	tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+	if (!tmp)
+		goto err_out;
+
+	tmp->channels = kzalloc(sizeof(struct ieee80211_channel) *
+				list->band_channel_num[band], GFP_KERNEL);
+	if (!tmp->channels)
+		goto err_out;
+
+	ret = p54_fill_band_bitrates(dev, tmp, band);
+	if (ret)
+		goto err_out;
+
+	for (i = 0, j = 0; (j < list->band_channel_num[band]) &&
+			   (i < list->entries); i++) {
+
+		if (list->channels[i].band != band)
+			continue;
+
+		if (list->channels[i].data != CHAN_HAS_ALL) {
+			printk(KERN_ERR "%s:%s%s%s is/are missing for "
+					"channel:%d [%d MHz].\n",
+			       wiphy_name(dev->wiphy),
+			       (list->channels[i].data & CHAN_HAS_CAL ? "" :
+				" [iqauto calibration data]"),
+			       (list->channels[i].data & CHAN_HAS_LIMIT ? "" :
+				" [output power limits]"),
+			       (list->channels[i].data & CHAN_HAS_CURVE ? "" :
+				" [curve data]"),
+			       list->channels[i].index, list->channels[i].freq);
+		}
+
+		tmp->channels[j].band = list->channels[i].band;
+		tmp->channels[j].center_freq = list->channels[i].freq;
+		j++;
+	}
+
+	tmp->n_channels = list->band_channel_num[band];
+	old = priv->band_table[band];
+	priv->band_table[band] = tmp;
+	if (old) {
+		kfree(old->channels);
+		kfree(old);
+	}
+
+	return 0;
+
+err_out:
+	if (tmp) {
+		kfree(tmp->channels);
+		kfree(tmp);
+	}
+
+	return ret;
+}
+
+static void p54_update_channel_param(struct p54_channel_list *list,
+				     u16 freq, u16 data)
+{
+	int band, i;
+
+	/*
+	 * usually all lists in the eeprom are mostly sorted.
+	 * so it's very likely that the entry we are looking for
+	 * is right at the end of the list
+	 */
+	for (i = list->entries; i >= 0; i--) {
+		if (freq == list->channels[i].freq) {
+			list->channels[i].data |= data;
+			break;
+		}
+	}
+
+	if ((i < 0) && (list->entries < list->max_entries)) {
+		/* entry does not exist yet. Initialize a new one. */
+		band = p54_get_band_from_freq(freq);
+
+		/*
+		 * filter out frequencies which don't belong into
+		 * any supported band.
+		 */
+		if (band < 0)
+			return ;
+
+		i = list->entries++;
+		list->band_channel_num[band]++;
+
+		list->channels[i].freq = freq;
+		list->channels[i].data = data;
+		list->channels[i].band = band;
+		list->channels[i].index = ieee80211_frequency_to_channel(freq);
+		/* TODO: parse output_limit and fill max_power */
+	}
+}
+
+static int p54_generate_channel_lists(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	struct p54_channel_list *list;
+	unsigned int i, j, max_channel_num;
+	int ret = -ENOMEM;
+	u16 freq;
+
+	if ((priv->iq_autocal_len != priv->curve_data->entries) ||
+	    (priv->iq_autocal_len != priv->output_limit->entries))
+		printk(KERN_ERR "%s: EEPROM is damaged... you may not be able"
+				"to use all channels with this device.\n",
+				wiphy_name(dev->wiphy));
+
+	max_channel_num = max_t(unsigned int, priv->output_limit->entries,
+				priv->iq_autocal_len);
+	max_channel_num = max_t(unsigned int, max_channel_num,
+				priv->curve_data->entries);
+
+	list = kzalloc(sizeof(*list), GFP_KERNEL);
+	if (!list)
+		goto free;
+
+	list->max_entries = max_channel_num;
+	list->channels = kzalloc(sizeof(struct p54_channel_entry) *
+				 max_channel_num, GFP_KERNEL);
+	if (!list->channels)
+		goto free;
+
+	for (i = 0; i < max_channel_num; i++) {
+		if (i < priv->iq_autocal_len) {
+			freq = le16_to_cpu(priv->iq_autocal[i].freq);
+			p54_update_channel_param(list, freq, CHAN_HAS_CAL);
+		}
+
+		if (i < priv->output_limit->entries) {
+			freq = le16_to_cpup((__le16 *) (i *
+					    priv->output_limit->entry_size +
+					    priv->output_limit->offset +
+					    priv->output_limit->data));
+
+			p54_update_channel_param(list, freq, CHAN_HAS_LIMIT);
+		}
+
+		if (i < priv->curve_data->entries) {
+			freq = le16_to_cpup((__le16 *) (i *
+					    priv->curve_data->entry_size +
+					    priv->curve_data->offset +
+					    priv->curve_data->data));
+
+			p54_update_channel_param(list, freq, CHAN_HAS_CURVE);
+		}
+	}
+
+	/* sort the list by the channel index */
+	sort(list->channels, list->entries, sizeof(struct p54_channel_entry),
+	     p54_compare_channels, NULL);
+
+	for (i = 0, j = 0; i < IEEE80211_NUM_BANDS; i++) {
+		if (list->band_channel_num[i]) {
+			ret = p54_generate_band(dev, list, i);
+			if (ret)
+				goto free;
+
+			j++;
+		}
+	}
+	if (j == 0) {
+		/* no useable band available. */
+		ret = -EINVAL;
+	}
+
+free:
+	if (list) {
+		kfree(list->channels);
+		kfree(list);
+	}
+
+	return ret;
+}
+
 static int p54_convert_rev0(struct ieee80211_hw *dev,
 			    struct pda_pa_curve_data *curve_data)
 {
@@ -487,13 +670,19 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 		goto err;
 	}
 
+	err = p54_generate_channel_lists(dev);
+	if (err)
+		goto err;
+
 	priv->rxhw = synth & PDR_SYNTH_FRONTEND_MASK;
 	if (priv->rxhw == PDR_SYNTH_FRONTEND_XBOW)
 		p54_init_xbow_synth(priv);
 	if (!(synth & PDR_SYNTH_24_GHZ_DISABLED))
-		dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
+		dev->wiphy->bands[IEEE80211_BAND_2GHZ] =
+			priv->band_table[IEEE80211_BAND_2GHZ];
 	if (!(synth & PDR_SYNTH_5_GHZ_DISABLED))
-		dev->wiphy->bands[IEEE80211_BAND_5GHZ] = &band_5GHz;
+		dev->wiphy->bands[IEEE80211_BAND_5GHZ] =
+			priv->band_table[IEEE80211_BAND_5GHZ];
 	if ((synth & PDR_SYNTH_RX_DIV_MASK) == PDR_SYNTH_RX_DIV_SUPPORTED)
 		priv->rx_diversity_mask = 3;
 	if ((synth & PDR_SYNTH_TX_DIV_MASK) == PDR_SYNTH_TX_DIV_SUPPORTED)
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index c9a0545..f19add2 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -598,6 +598,10 @@ EXPORT_SYMBOL_GPL(p54_register_common);
 void p54_free_common(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
+	unsigned int i;
+
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+		kfree(priv->band_table[i]);
 
 	kfree(priv->iq_autocal);
 	kfree(priv->output_limit);
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 6772ed5..584b156 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -198,6 +198,7 @@ struct p54_common {
 	struct p54_cal_database *curve_data;
 	struct p54_cal_database *output_limit;
 	struct p54_rssi_linear_approximation rssical_db[IEEE80211_NUM_BANDS];
+	struct ieee80211_supported_band *band_table[IEEE80211_NUM_BANDS];
 
 	/* BBP/MAC state */
 	u8 mac_addr[ETH_ALEN];
