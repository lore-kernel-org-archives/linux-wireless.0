Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47762 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1HTAam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 20:30:42 -0400
Received: by fxh19 with SMTP id 19so2243049fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2011 17:30:41 -0700 (PDT)
Subject: [PATCH] p54: improve site survey
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 20 Aug 2011 01:53:59 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201108200153.59664.chunkeey@googlemail.com> (sfid-20110820_023049_470149_180ADBAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware keeps track of channel usage. This data can
be used by the automatic channel selection to find the best
channel.

Survey data from wlan4
	frequency:				5200 MHz [in use]
	noise:					-91 dBm
	channel active time:			811909 ms
	channel busy time:			63395 ms
	channel transmit time:			59636 ms
Survey data from wlan4
	frequency:				5210 MHz
	noise:					-91 dBm
	channel active time:			121 ms
	channel busy time:			119 ms
	channel transmit time:			0 ms

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/eeprom.c |   26 ++++++++-
 drivers/net/wireless/p54/fwio.c   |    2 +
 drivers/net/wireless/p54/main.c   |  113 +++++++++++++++++++++++++++++++++----
 drivers/net/wireless/p54/p54.h    |   18 ++++++
 drivers/net/wireless/p54/txrx.c   |   66 +++++++++++++++++++++
 5 files changed, 211 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index 54cc0bb..8b6f363 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -145,6 +145,7 @@ static int p54_fill_band_bitrates(struct ieee80211_hw *dev,
 
 static int p54_generate_band(struct ieee80211_hw *dev,
 			     struct p54_channel_list *list,
+			     unsigned int *chan_num,
 			     enum ieee80211_band band)
 {
 	struct p54_common *priv = dev->priv;
@@ -190,7 +191,14 @@ static int p54_generate_band(struct ieee80211_hw *dev,
 
 		tmp->channels[j].band = chan->band;
 		tmp->channels[j].center_freq = chan->freq;
+		priv->survey[*chan_num].channel = &tmp->channels[j];
+		priv->survey[*chan_num].filled = SURVEY_INFO_NOISE_DBM |
+			SURVEY_INFO_CHANNEL_TIME |
+			SURVEY_INFO_CHANNEL_TIME_BUSY |
+			SURVEY_INFO_CHANNEL_TIME_TX;
+		tmp->channels[j].hw_value = (*chan_num);
 		j++;
+		(*chan_num)++;
 	}
 
 	if (j == 0) {
@@ -263,7 +271,7 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
 	struct p54_channel_list *list;
-	unsigned int i, j, max_channel_num;
+	unsigned int i, j, k, max_channel_num;
 	int ret = 0;
 	u16 freq;
 
@@ -283,6 +291,13 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
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
@@ -321,8 +336,9 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
 	sort(list->channels, list->entries, sizeof(struct p54_channel_entry),
 	     p54_compare_channels, NULL);
 
+	k = 0;
 	for (i = 0, j = 0; i < IEEE80211_NUM_BANDS; i++) {
-		if (p54_generate_band(dev, list, i) == 0)
+		if (p54_generate_band(dev, list, &k, i) == 0)
 			j++;
 	}
 	if (j == 0) {
@@ -335,6 +351,10 @@ free:
 		kfree(list->channels);
 		kfree(list);
 	}
+	if (ret) {
+		kfree(priv->survey);
+		priv->survey = NULL;
+	}
 
 	return ret;
 }
@@ -853,10 +873,12 @@ err:
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
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index b6a061c..53a3408 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -385,6 +385,7 @@ int p54_setup_mac(struct p54_common *priv)
 		setup->v2.osc_start_delay = cpu_to_le16(65535);
 	}
 	p54_tx(priv, skb);
+	priv->phy_idle = mode == P54_FILTER_TYPE_HIBERNATE;
 	return 0;
 }
 
@@ -626,6 +627,7 @@ int p54_set_ps(struct p54_common *priv)
 	psm->exclude[0] = WLAN_EID_TIM;
 
 	p54_tx(priv, skb);
+	priv->phy_ps = mode != P54_PSM_CAM;
 	return 0;
 }
 
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index a5a6d9e..726a934 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -204,13 +204,11 @@ static void p54_stop(struct ieee80211_hw *dev)
 	struct p54_common *priv = dev->priv;
 	int i;
 
-	mutex_lock(&priv->conf_mutex);
 	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
 	priv->softled_state = 0;
-	p54_set_leds(priv);
-
 	cancel_delayed_work_sync(&priv->work);
-
+	mutex_lock(&priv->conf_mutex);
+	p54_set_leds(priv);
 	priv->stop(dev);
 	skb_queue_purge(&priv->tx_pending);
 	skb_queue_purge(&priv->tx_queue);
@@ -278,6 +276,42 @@ static void p54_remove_interface(struct ieee80211_hw *dev,
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
+	struct ieee80211_channel *chan = priv->curchan;
+
+	if (chan) {
+		struct survey_info *info = &priv->survey[chan->hw_value];
+
+		/* only reset channel statistics, don't touch .filled, etc. */
+		info->channel_time = 0;
+		info->channel_time_busy = 0;
+		info->channel_time_tx = 0;
+	}
+
+	priv->update_stats = true;
+	priv->survey_raw.active = 0;
+	priv->survey_raw.cca = 0;
+	priv->survey_raw.tx = 0;
+}
+
 static int p54_config(struct ieee80211_hw *dev, u32 changed)
 {
 	int ret = 0;
@@ -288,19 +322,36 @@ static int p54_config(struct ieee80211_hw *dev, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
 		priv->output_power = conf->power_level << 2;
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		struct ieee80211_channel *oldchan;
+		WARN_ON(p54_wait_for_stats(dev));
+		oldchan = priv->curchan;
+		priv->curchan = NULL;
 		ret = p54_scan(priv, P54_SCAN_EXIT, 0);
-		if (ret)
+		if (ret) {
+			priv->curchan = oldchan;
 			goto out;
+		}
+		/*
+		 * TODO: Use the LM_SCAN_TRAP to determine the current
+		 * operating channel.
+		 */
+		priv->curchan = priv->hw->conf.channel;
+		p54_reset_stats(priv);
+		WARN_ON(p54_fetch_statistics(priv));
 	}
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		WARN_ON(p54_wait_for_stats(dev));
 		ret = p54_set_ps(priv);
 		if (ret)
 			goto out;
+		WARN_ON(p54_wait_for_stats(dev));
 	}
 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
+		WARN_ON(p54_wait_for_stats(dev));
 		ret = p54_setup_mac(priv);
 		if (ret)
 			goto out;
+		WARN_ON(p54_wait_for_stats(dev));
 	}
 
 out:
@@ -384,7 +435,9 @@ static void p54_work(struct work_struct *work)
 	 *      2. cancel stuck frames / reset the device if necessary.
 	 */
 
-	p54_fetch_statistics(priv);
+	mutex_lock(&priv->conf_mutex);
+	WARN_ON_ONCE(p54_fetch_statistics(priv));
+	mutex_unlock(&priv->conf_mutex);
 }
 
 static int p54_get_stats(struct ieee80211_hw *dev,
@@ -541,16 +594,47 @@ static int p54_get_survey(struct ieee80211_hw *dev, int idx,
 				struct survey_info *survey)
 {
 	struct p54_common *priv = dev->priv;
-	struct ieee80211_conf *conf = &dev->conf;
+	struct ieee80211_channel *chan;
+	int err, tries;
+	bool in_use = false;
 
-	if (idx != 0)
+	if (idx >= priv->chan_num)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
-	survey->filled = SURVEY_INFO_NOISE_DBM;
-	survey->noise = clamp_t(s8, priv->noise, -128, 127);
+#define MAX_TRIES 1
+	for (tries = 0; tries < MAX_TRIES; tries++) {
+		chan = priv->curchan;
+		if (chan && chan->hw_value == idx) {
+			mutex_lock(&priv->conf_mutex);
+			err = p54_wait_for_stats(dev);
+			mutex_unlock(&priv->conf_mutex);
+			if (err)
+				return err;
+
+			in_use = true;
+		}
 
-	return 0;
+		memcpy(survey, &priv->survey[idx], sizeof(*survey));
+
+		if (in_use) {
+			/* test if the reported statistics are valid. */
+			if  (survey->channel_time != 0) {
+				survey->filled |= SURVEY_INFO_IN_USE;
+			} else {
+				/*
+				 * hw/fw has not accumulated enough sample sets.
+				 * Wait for 100ms, this ought to be enough to
+				 * to get at least one non-null set of channel
+				 * usage statistics.
+				 */
+				msleep(100);
+				continue;
+			}
+		}
+		return 0;
+	}
+	return -ETIMEDOUT;
+#undef MAX_TRIES
 }
 
 static unsigned int p54_flush_count(struct p54_common *priv)
@@ -686,11 +770,14 @@ struct ieee80211_hw *p54_init_common(size_t priv_data_len)
 
 	mutex_init(&priv->conf_mutex);
 	mutex_init(&priv->eeprom_mutex);
+	init_completion(&priv->stat_comp);
 	init_completion(&priv->eeprom_comp);
 	init_completion(&priv->beacon_comp);
 	INIT_DELAYED_WORK(&priv->work, p54_work);
 
 	memset(&priv->mc_maclist[0], ~0, ETH_ALEN);
+	priv->curchan = NULL;
+	p54_reset_stats(priv);
 	return dev;
 }
 EXPORT_SYMBOL_GPL(p54_init_common);
@@ -730,11 +817,13 @@ void p54_free_common(struct ieee80211_hw *dev)
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
index 799d05e..452fa3a 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -199,6 +199,22 @@ struct p54_common {
 	u8 tx_diversity_mask;
 	unsigned int output_power;
 	struct p54_rssi_db_entry *cur_rssi;
+	struct ieee80211_channel *curchan;
+	struct survey_info *survey;
+	unsigned int chan_num;
+	struct completion stat_comp;
+	bool update_stats;
+	struct {
+		unsigned int timestamp;
+		unsigned int cached_cca;
+		unsigned int cached_tx;
+		unsigned int cached_rssi;
+		u64 active;
+		u64 cca;
+		u64 tx;
+		u64 rssi;
+	} survey_raw;
+
 	int noise;
 	/* calibration, output power limit and rssi<->dBm conversation data */
 	struct pda_iq_autocal_entry *iq_autocal;
@@ -220,6 +236,8 @@ struct p54_common {
 	u32 basic_rate_mask;
 	u16 aid;
 	u8 coverage_class;
+	bool phy_idle;
+	bool phy_ps;
 	bool powersave_override;
 	__le32 beacon_req_id;
 	struct completion beacon_comp;
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 042842e..d3e88cc 100644
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
@@ -523,8 +525,72 @@ static void p54_rx_stats(struct p54_common *priv, struct sk_buff *skb)
 
 	priv->noise = p54_rssi_to_dbm(priv, le32_to_cpu(stats->noise));
 
+	/*
+	 * STSW450X LMAC API page 26 - 3.8 Statistics
+	 * "The exact measurement period can be derived from the
+	 * timestamp member".
+	 */
+	dtime = tsf32 - priv->survey_raw.timestamp;
+
+	/*
+	 * STSW450X LMAC API page 26 - 3.8.1 Noise histogram
+	 * The LMAC samples RSSI, CCA and transmit state at regular
+	 * periods (typically 8 times per 1k [as in 1024] usec).
+	 */
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
+
+	/*
+	 * update statistics when more than a second is over since the
+	 * last call, or when a update is badly needed.
+	 */
+	if (dtotal && (priv->update_stats || dtime >= USEC_PER_SEC) &&
+	    dtime >= dtotal) {
+		priv->survey_raw.timestamp = tsf32;
+		priv->update_stats = false;
+		unit = dtime / dtotal;
+
+		if (dcca) {
+			priv->survey_raw.cca += dcca * unit;
+			priv->survey_raw.cached_cca = cca;
+		}
+		if (dtx) {
+			priv->survey_raw.tx += dtx * unit;
+			priv->survey_raw.cached_tx = tx;
+		}
+		if (drssi) {
+			priv->survey_raw.rssi += drssi * unit;
+			priv->survey_raw.cached_rssi = rssi;
+		}
+
+		/* 1024 usec / 8 times = 128 usec / time */
+		if (!(priv->phy_ps || priv->phy_idle))
+			priv->survey_raw.active += dtotal * unit;
+		else
+			priv->survey_raw.active += (dcca + dtx) * unit;
+	}
+
+	chan = priv->curchan;
+	if (chan) {
+		struct survey_info *survey = &priv->survey[chan->hw_value];
+		survey->noise = clamp_t(s8, priv->noise, -128, 127);
+		survey->channel_time = priv->survey_raw.active / 1024;
+		survey->channel_time_tx = priv->survey_raw.tx / 1024;
+		survey->channel_time_busy = priv->survey_raw.cca / 1024 +
+			survey->channel_time_tx;
+	}
+
 	tmp = p54_find_and_unlink_skb(priv, hdr->req_id);
 	dev_kfree_skb_any(tmp);
+	complete(&priv->stat_comp);
 }
 
 static void p54_rx_trap(struct p54_common *priv, struct sk_buff *skb)
-- 
1.7.5.4

