Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:47765 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1GASMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 14:12:00 -0400
Received: by fxd18 with SMTP id 18so3502416fxd.11
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2011 11:11:59 -0700 (PDT)
Received: from localhost
	([127.0.0.1] helo=debian64.localnet ident=chuck)
	by debian64.daheim with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <chunkeey@googlemail.com>)
	id 1QciDb-00084K-I5
	for linux-wireless@vger.kernel.org; Fri, 01 Jul 2011 20:13:31 +0200
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFT] p54: improve site survey
Date: Fri, 1 Jul 2011 20:13:26 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201107012013.26485.chunkeey@googlemail.com> (sfid-20110701_201204_668517_D085B2C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware keeps track of channel usage. This data can
be used by the automatic channel selection to find the best
channel.

Survey data from wlan4
        frequency:                      5200 MHz [in use]
        noise:                          -91 dBm
        channel active time:            811909 ms
        channel busy time:              63395 ms
        channel transmit time:          59636 ms
Survey data from wlan4
        frequency:                      5210 MHz
        noise:                          -91 dBm
        channel active time:            121 ms
        channel busy time:              119 ms
        channel transmit time:          0 ms
---
diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index bdb571f..331f4da 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -145,6 +145,7 @@ static int p54_fill_band_bitrates(struct ieee80211_hw *dev,
 
 static int p54_generate_band(struct ieee80211_hw *dev,
 			     struct p54_channel_list *list,
+			     unsigned int *chan_num,
 			     enum ieee80211_band band)
 {
 	struct p54_common *priv = dev->priv;
@@ -190,7 +191,10 @@ static int p54_generate_band(struct ieee80211_hw *dev,
 
 		tmp->channels[j].band = chan->band;
 		tmp->channels[j].center_freq = chan->freq;
+		priv->survey[*chan_num].channel = &tmp->channels[j];
+		tmp->channels[j].hw_value = (*chan_num);
 		j++;
+		(*chan_num)++;
 	}
 
 	if (j == 0) {
@@ -263,7 +267,7 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_channel_list *list;
-	unsigned int i, j, max_channel_num;
+	unsigned int i, j, k, max_channel_num;
 	int ret = 0;
 	u16 freq;
 
@@ -283,6 +287,13 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
 		ret = -ENOMEM;
 		goto free;
 	}
+	priv->chan_num = max_channel_num;
+	priv->survey = kzalloc(sizeof(struct survey_info) * max_channel_num,
+			       GFP_KERNEL);
+	if (!priv->survey) {
+		ret = -ENOMEM;
+		goto free;
+	}
 
 	list->max_entries = max_channel_num;
 	list->channels = kzalloc(sizeof(struct p54_channel_entry) *
@@ -321,8 +332,9 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
 	sort(list->channels, list->entries, sizeof(struct p54_channel_entry),
 	     p54_compare_channels, NULL);
 
+	k = 0;
 	for (i = 0, j = 0; i < IEEE80211_NUM_BANDS; i++) {
-		if (p54_generate_band(dev, list, i) == 0)
+		if (p54_generate_band(dev, list, &k, i) == 0)
 			j++;
 	}
 	if (j == 0) {
@@ -335,6 +347,10 @@ free:
 		kfree(list->channels);
 		kfree(list);
 	}
+	if (ret) {
+		kfree(priv->survey);
+		priv->survey = NULL;
+	}
 
 	return ret;
 }
@@ -853,10 +869,12 @@ err:
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
 	kfree(priv->rssi_db);
+	kfree(priv->survey);
 	priv->iq_autocal = NULL;
 	priv->output_limit = NULL;
 	priv->curve_data = NULL;
 	priv->rssi_db = NULL;
+	priv->survey = NULL;
 
 	wiphy_err(dev->wiphy, "eeprom parse failed!\n");
 	return err;
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 03198ed..a68be32 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -278,6 +278,30 @@ static void p54_remove_interface(struct ieee80211_hw *dev,
 	mutex_unlock(&priv->conf_mutex);
 }
 
+static int p54_wait_for_stats(struct ieee80211_hw *dev)
+{
+	struct p54_common *priv = dev->priv;
+	int ret;
+
+	priv->update_stats = true;
+	ret = p54_fetch_statistics(priv);
+	if (ret)
+		return ret;
+
+	ret = wait_for_completion_interruptible_timeout(&priv->stat_comp, HZ);
+	if (ret == 0)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static void p54_reset_stats(struct p54_common *priv)
+{
+	priv->survey_raw.active = 0;
+	priv->survey_raw.cca = 0;
+	priv->survey_raw.tx = 0;
+}
+
 static int p54_config(struct ieee80211_hw *dev, u32 changed)
 {
 	int ret = 0;
@@ -288,9 +312,16 @@ static int p54_config(struct ieee80211_hw *dev, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
 		priv->output_power = conf->power_level << 2;
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		ret = p54_wait_for_stats(dev);
+		if (ret)
+			goto out;
 		ret = p54_scan(priv, P54_SCAN_EXIT, 0);
 		if (ret)
 			goto out;
+		p54_reset_stats(priv);
+		ret = p54_fetch_statistics(priv);
+		if (ret)
+			return ret;
 	}
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		ret = p54_set_ps(priv);
@@ -541,14 +572,27 @@ static int p54_get_survey(struct ieee80211_hw *dev, int idx,
 				struct survey_info *survey)
 {
 	struct p54_common *priv = dev->priv;
-	struct ieee80211_conf *conf = &dev->conf;
+	struct ieee80211_channel *chan;
+	int err;
 
-	if (idx != 0)
+	if (idx == 0) {
+		err = p54_wait_for_stats(dev);
+		if (err)
+			return err;
+	}
+
+	if (idx >= priv->chan_num)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
-	survey->filled = SURVEY_INFO_NOISE_DBM;
-	survey->noise = clamp_t(s8, priv->noise, -128, 127);
+	memcpy(survey, &priv->survey[idx], sizeof(*survey));
+	survey->filled = SURVEY_INFO_NOISE_DBM |
+			 SURVEY_INFO_CHANNEL_TIME |
+			 SURVEY_INFO_CHANNEL_TIME_BUSY |
+			 SURVEY_INFO_CHANNEL_TIME_TX;
+
+	chan = dev->conf.channel;
+	if (chan && chan->hw_value == idx)
+		survey->filled |= SURVEY_INFO_IN_USE;
 
 	return 0;
 }
@@ -686,6 +730,7 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 
 	mutex_init(&priv->conf_mutex);
 	mutex_init(&priv->eeprom_mutex);
+	init_completion(&priv->stat_comp);
 	init_completion(&priv->eeprom_comp);
 	init_completion(&priv->beacon_comp);
 	INIT_DELAYED_WORK(&priv->work, p54_work);
@@ -730,11 +775,13 @@ void p54_free_common(struct ieee80211_hw *dev)
 	kfree(priv->curve_data);
 	kfree(priv->rssi_db);
 	kfree(priv->used_rxkeys);
+	kfree(priv->survey);
 	priv->iq_autocal = NULL;
 	priv->output_limit = NULL;
 	priv->curve_data = NULL;
 	priv->rssi_db = NULL;
 	priv->used_rxkeys = NULL;
+	priv->survey = NULL;
 	ieee80211_free_hw(dev);
 }
 EXPORT_SYMBOL_GPL(p54_free_common);
diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index 799d05e..6d2c39b 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -199,6 +199,23 @@ struct p54_common {
 	u8 tx_diversity_mask;
 	unsigned int output_power;
 	struct p54_rssi_db_entry *cur_rssi;
+	struct survey_info *survey;
+	unsigned int chan_num;
+	struct completion stat_comp;
+	bool update_stats;
+	struct {
+		unsigned int timestamp;
+
+		unsigned int cached_cca;
+		unsigned int cached_tx;
+		unsigned int cached_rssi;
+
+		u64 active;
+		u64 cca;
+		u64 tx;
+		u64 rssi;
+	} survey_raw;
+
 	int noise;
 	/* calibration, output power limit and rssi<->dBm conversation data */
 	struct pda_iq_autocal_entry *iq_autocal;
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 4d28b52..992dac1 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -507,6 +507,8 @@ static void p54_rx_stats(struct p54_common *priv, struct sk_buff *skb)
 	struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
 	struct p54_statistics *stats = (struct p54_statistics *) hdr->data;
 	struct sk_buff *tmp;
+	struct ieee80211_channel *chan;
+	unsigned int i, rssi, tx, cca, dtime, dtotal, dcca, dtx, drssi, unit;
 	u32 tsf32;
 
 	if (unlikely(priv->mode == NL80211_IFTYPE_UNSPECIFIED))
@@ -520,11 +522,72 @@ static void p54_rx_stats(struct p54_common *priv, struct sk_buff *skb)
 	priv->stats.dot11RTSFailureCount = le32_to_cpu(stats->rts_fail);
 	priv->stats.dot11RTSSuccessCount = le32_to_cpu(stats->rts_success);
 	priv->stats.dot11FCSErrorCount = le32_to_cpu(stats->rx_bad_fcs);
-
 	priv->noise = p54_rssi_to_dbm(priv, le32_to_cpu(stats->noise));
+	cca = le32_to_cpu(stats->sample_cca);
+	tx = le32_to_cpu(stats->sample_tx);
+	rssi = 0;
+	for (i = 0; i < ARRAY_SIZE(stats->sample_noise); i++)
+		rssi += le32_to_cpu(stats->sample_noise[i]);
+
+	dcca = cca - priv->survey_raw.cached_cca;
+	drssi = rssi - priv->survey_raw.cached_rssi;
+	dtx = tx - priv->survey_raw.cached_tx;
+	dtotal = dcca + drssi + dtx;
+	dtime = tsf32 - priv->survey_raw.timestamp;
+
+	/* only once one needed, or every 900 ms */
+	if (priv->update_stats || dtime >= 900000) {
+		/*
+		 * STSW450X LMAC API page 26 - 3.8 Statistics
+		 * "The exact measurement period can be derived from the
+		 * timestamp memeber"
+		 */
+		priv->survey_raw.timestamp = tsf32;
+		priv->update_stats = false;
+
+		/*
+		 * STSW450X LMAC API page 26 - 3.8.1 Noise histogram
+		 * The LMAC samples RSSI, CCA and transmit state at regular
+		 * periods (typically 8 times per 1k [as in 1024] usec.
+		 */
+
+		if (dtotal) {
+			/* 1024 usec / 8 times = 128 usec / time */
+			unit = dtime / dtotal;
+
+			priv->survey_raw.active += dtotal * unit;
+
+			if (dcca) {
+				priv->survey_raw.cca += dcca * unit;
+				priv->survey_raw.cached_cca = cca;
+			}
+
+			if (dtx) {
+				priv->survey_raw.tx += dtx * unit;
+				priv->survey_raw.cached_tx = tx;
+			}
+
+			if (drssi) {
+				priv->survey_raw.rssi += drssi * unit;
+				priv->survey_raw.cached_rssi = rssi;
+			}
+		}
+	}
+
+	chan = priv->hw->conf.channel;
+	if (chan) {
+		struct survey_info *survey = &priv->survey[chan->hw_value];
+
+		survey->noise = clamp_t(s8, priv->noise, -128, 127);
+		survey->channel_time = priv->survey_raw.active / 1024;
+		survey->channel_time_tx = priv->survey_raw.tx / 1024;
+		survey->channel_time_busy = priv->survey_raw.cca / 1024 +
+			survey->channel_time_tx;
+	}
 
 	tmp = p54_find_and_unlink_skb(priv, hdr->req_id);
 	dev_kfree_skb_any(tmp);
+	complete(&priv->stat_comp);
 }
 
 static void p54_rx_trap(struct p54_common *priv, struct sk_buff *skb)

