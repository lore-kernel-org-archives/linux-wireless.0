Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50547 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965601AbaKNQB4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 11:01:56 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/3] cfg80211: remove "channel" from survey names
Date: Fri, 14 Nov 2014 17:01:48 +0100
Message-Id: <1415980910-9105-1-git-send-email-johannes@sipsolutions.net> (sfid-20141114_170205_230521_441FD3B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

All of the survey data is (currently) per channel anyway,
so having the word "channel" in the name does nothing. In
the next patch I'll introduce global data to the survey,
where the word "channel" is actually confusing.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c         |  8 ++---
 drivers/net/wireless/ath/ath5k/mac80211-ops.c | 16 +++++-----
 drivers/net/wireless/ath/ath9k/link.c         | 16 +++++-----
 drivers/net/wireless/ath/carl9170/cmd.c       | 12 ++++----
 drivers/net/wireless/ath/carl9170/main.c      |  6 ++--
 drivers/net/wireless/mwl8k.c                  | 12 ++++----
 drivers/net/wireless/p54/eeprom.c             |  6 ++--
 drivers/net/wireless/p54/main.c               |  8 ++---
 drivers/net/wireless/p54/txrx.c               | 12 ++++----
 drivers/net/wireless/rt2x00/rt2800lib.c       | 12 ++++----
 include/net/cfg80211.h                        | 44 +++++++++++++--------------
 include/uapi/linux/nl80211.h                  | 27 ++++++++++------
 net/mac80211/ethtool.c                        | 20 ++++++------
 net/wireless/nl80211.c                        | 30 +++++++++---------
 net/wireless/trace.h                          | 26 ++++++++--------
 15 files changed, 131 insertions(+), 124 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 2c42bd504b79..903bea367cde 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1265,11 +1265,11 @@ static void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 		rx_clear_count -= ar->survey_last_rx_clear_count;
 
 		survey = &ar->survey[idx];
-		survey->channel_time = WMI_CHAN_INFO_MSEC(cycle_count);
-		survey->channel_time_rx = WMI_CHAN_INFO_MSEC(rx_clear_count);
+		survey->time = WMI_CHAN_INFO_MSEC(cycle_count);
+		survey->time_rx = WMI_CHAN_INFO_MSEC(rx_clear_count);
 		survey->noise = noise_floor;
-		survey->filled = SURVEY_INFO_CHANNEL_TIME |
-				 SURVEY_INFO_CHANNEL_TIME_RX |
+		survey->filled = SURVEY_INFO_TIME |
+				 SURVEY_INFO_TIME_RX |
 				 SURVEY_INFO_NOISE_DBM;
 	}
 
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index ab2709a43768..6e69d6c40415 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -670,10 +670,10 @@ ath5k_get_survey(struct ieee80211_hw *hw, int idx, struct survey_info *survey)
 	spin_lock_bh(&common->cc_lock);
 	ath_hw_cycle_counters_update(common);
 	if (cc->cycles > 0) {
-		ah->survey.channel_time += cc->cycles / div;
-		ah->survey.channel_time_busy += cc->rx_busy / div;
-		ah->survey.channel_time_rx += cc->rx_frame / div;
-		ah->survey.channel_time_tx += cc->tx_frame / div;
+		ah->survey.time += cc->cycles / div;
+		ah->survey.time_busy += cc->rx_busy / div;
+		ah->survey.time_rx += cc->rx_frame / div;
+		ah->survey.time_tx += cc->tx_frame / div;
 	}
 	memset(cc, 0, sizeof(*cc));
 	spin_unlock_bh(&common->cc_lock);
@@ -684,10 +684,10 @@ ath5k_get_survey(struct ieee80211_hw *hw, int idx, struct survey_info *survey)
 	survey->noise = ah->ah_noise_floor;
 	survey->filled = SURVEY_INFO_NOISE_DBM |
 			SURVEY_INFO_IN_USE |
-			SURVEY_INFO_CHANNEL_TIME |
-			SURVEY_INFO_CHANNEL_TIME_BUSY |
-			SURVEY_INFO_CHANNEL_TIME_RX |
-			SURVEY_INFO_CHANNEL_TIME_TX;
+			SURVEY_INFO_TIME |
+			SURVEY_INFO_TIME_BUSY |
+			SURVEY_INFO_TIME_RX |
+			SURVEY_INFO_TIME_TX;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 2343f56e6498..973eed2142f2 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -510,14 +510,14 @@ int ath_update_survey_stats(struct ath_softc *sc)
 		ath_hw_cycle_counters_update(common);
 
 	if (cc->cycles > 0) {
-		survey->filled |= SURVEY_INFO_CHANNEL_TIME |
-			SURVEY_INFO_CHANNEL_TIME_BUSY |
-			SURVEY_INFO_CHANNEL_TIME_RX |
-			SURVEY_INFO_CHANNEL_TIME_TX;
-		survey->channel_time += cc->cycles / div;
-		survey->channel_time_busy += cc->rx_busy / div;
-		survey->channel_time_rx += cc->rx_frame / div;
-		survey->channel_time_tx += cc->tx_frame / div;
+		survey->filled |= SURVEY_INFO_TIME |
+			SURVEY_INFO_TIME_BUSY |
+			SURVEY_INFO_TIME_RX |
+			SURVEY_INFO_TIME_TX;
+		survey->time += cc->cycles / div;
+		survey->time_busy += cc->rx_busy / div;
+		survey->time_rx += cc->rx_frame / div;
+		survey->time_tx += cc->tx_frame / div;
 	}
 
 	if (cc->cycles < div)
diff --git a/drivers/net/wireless/ath/carl9170/cmd.c b/drivers/net/wireless/ath/carl9170/cmd.c
index 39a63874b275..f2b4f537e4c1 100644
--- a/drivers/net/wireless/ath/carl9170/cmd.c
+++ b/drivers/net/wireless/ath/carl9170/cmd.c
@@ -188,12 +188,12 @@ int carl9170_collect_tally(struct ar9170 *ar)
 
 		if (ar->channel) {
 			info = &ar->survey[ar->channel->hw_value];
-			info->channel_time = ar->tally.active;
-			info->channel_time_busy = ar->tally.cca;
-			info->channel_time_tx = ar->tally.tx_time;
-			do_div(info->channel_time, 1000);
-			do_div(info->channel_time_busy, 1000);
-			do_div(info->channel_time_tx, 1000);
+			info->time = ar->tally.active;
+			info->time_busy = ar->tally.cca;
+			info->time_tx = ar->tally.tx_time;
+			do_div(info->time, 1000);
+			do_div(info->time_busy, 1000);
+			do_div(info->time_tx, 1000);
 		}
 	}
 	return 0;
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index ef5b6dc7b7f1..f1455a04cb62 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1690,9 +1690,9 @@ found:
 		survey->filled |= SURVEY_INFO_IN_USE;
 
 	if (ar->fw.hw_counters) {
-		survey->filled |= SURVEY_INFO_CHANNEL_TIME |
-				  SURVEY_INFO_CHANNEL_TIME_BUSY |
-				  SURVEY_INFO_CHANNEL_TIME_TX;
+		survey->filled |= SURVEY_INFO_TIME |
+				  SURVEY_INFO_TIME_BUSY |
+				  SURVEY_INFO_TIME_TX;
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ef1104476bd8..ab2151752d66 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3098,14 +3098,14 @@ static void mwl8k_update_survey(struct mwl8k_priv *priv,
 
 	cca_cnt = ioread32(priv->regs + NOK_CCA_CNT_REG);
 	cca_cnt /= 1000; /* uSecs to mSecs */
-	survey->channel_time_busy = (u64) cca_cnt;
+	survey->time_busy = (u64) cca_cnt;
 
 	rx_rdy = ioread32(priv->regs + BBU_RXRDY_CNT_REG);
 	rx_rdy /= 1000; /* uSecs to mSecs */
-	survey->channel_time_rx = (u64) rx_rdy;
+	survey->time_rx = (u64) rx_rdy;
 
 	priv->channel_time = jiffies - priv->channel_time;
-	survey->channel_time = jiffies_to_msecs(priv->channel_time);
+	survey->time = jiffies_to_msecs(priv->channel_time);
 
 	survey->channel = channel;
 
@@ -3115,9 +3115,9 @@ static void mwl8k_update_survey(struct mwl8k_priv *priv,
 	survey->noise = nf * -1;
 
 	survey->filled = SURVEY_INFO_NOISE_DBM |
-			 SURVEY_INFO_CHANNEL_TIME |
-			 SURVEY_INFO_CHANNEL_TIME_BUSY |
-			 SURVEY_INFO_CHANNEL_TIME_RX;
+			 SURVEY_INFO_TIME |
+			 SURVEY_INFO_TIME_BUSY |
+			 SURVEY_INFO_TIME_RX;
 }
 
 /*
diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
index 0fe67d2da208..2fe713eda7ad 100644
--- a/drivers/net/wireless/p54/eeprom.c
+++ b/drivers/net/wireless/p54/eeprom.c
@@ -196,9 +196,9 @@ static int p54_generate_band(struct ieee80211_hw *dev,
 		dest->max_power = chan->max_power;
 		priv->survey[*chan_num].channel = &tmp->channels[j];
 		priv->survey[*chan_num].filled = SURVEY_INFO_NOISE_DBM |
-			SURVEY_INFO_CHANNEL_TIME |
-			SURVEY_INFO_CHANNEL_TIME_BUSY |
-			SURVEY_INFO_CHANNEL_TIME_TX;
+			SURVEY_INFO_TIME |
+			SURVEY_INFO_TIME_BUSY |
+			SURVEY_INFO_TIME_TX;
 		dest->hw_value = (*chan_num);
 		j++;
 		(*chan_num)++;
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 97aeff0edb84..09a03820efa9 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -305,9 +305,9 @@ static void p54_reset_stats(struct p54_common *priv)
 		struct survey_info *info = &priv->survey[chan->hw_value];
 
 		/* only reset channel statistics, don't touch .filled, etc. */
-		info->channel_time = 0;
-		info->channel_time_busy = 0;
-		info->channel_time_tx = 0;
+		info->time = 0;
+		info->time_busy = 0;
+		info->time_tx = 0;
 	}
 
 	priv->update_stats = true;
@@ -634,7 +634,7 @@ static int p54_get_survey(struct ieee80211_hw *dev, int idx,
 
 		if (in_use) {
 			/* test if the reported statistics are valid. */
-			if  (survey->channel_time != 0) {
+			if  (survey->time != 0) {
 				survey->filled |= SURVEY_INFO_IN_USE;
 			} else {
 				/*
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 153c61539ec8..24e5ff9a9272 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -587,13 +587,13 @@ static void p54_rx_stats(struct p54_common *priv, struct sk_buff *skb)
 	if (chan) {
 		struct survey_info *survey = &priv->survey[chan->hw_value];
 		survey->noise = clamp(priv->noise, -128, 127);
-		survey->channel_time = priv->survey_raw.active;
-		survey->channel_time_tx = priv->survey_raw.tx;
-		survey->channel_time_busy = priv->survey_raw.tx +
+		survey->time = priv->survey_raw.active;
+		survey->time_tx = priv->survey_raw.tx;
+		survey->time_busy = priv->survey_raw.tx +
 			priv->survey_raw.cca;
-		do_div(survey->channel_time, 1024);
-		do_div(survey->channel_time_tx, 1024);
-		do_div(survey->channel_time_busy, 1024);
+		do_div(survey->time, 1024);
+		do_div(survey->time_tx, 1024);
+		do_div(survey->time_busy, 1024);
 	}
 
 	tmp = p54_find_and_unlink_skb(priv, hdr->req_id);
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9f57a2db791c..8c807ef2ba1d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -8013,13 +8013,13 @@ int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
 	rt2800_register_read(rt2x00dev, CH_BUSY_STA_SEC, &busy_ext);
 
 	if (idle || busy) {
-		survey->filled = SURVEY_INFO_CHANNEL_TIME |
-				 SURVEY_INFO_CHANNEL_TIME_BUSY |
-				 SURVEY_INFO_CHANNEL_TIME_EXT_BUSY;
+		survey->filled = SURVEY_INFO_TIME |
+				 SURVEY_INFO_TIME_BUSY |
+				 SURVEY_INFO_TIME_EXT_BUSY;
 
-		survey->channel_time = (idle + busy) / 1000;
-		survey->channel_time_busy = busy / 1000;
-		survey->channel_time_ext_busy = busy_ext / 1000;
+		survey->time = (idle + busy) / 1000;
+		survey->time_busy = busy / 1000;
+		survey->time_ext_busy = busy_ext / 1000;
 	}
 
 	if (!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 220d5f5f1aca..15c720c2962c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -520,23 +520,23 @@ ieee80211_chandef_max_power(struct cfg80211_chan_def *chandef)
  *
  * @SURVEY_INFO_NOISE_DBM: noise (in dBm) was filled in
  * @SURVEY_INFO_IN_USE: channel is currently being used
- * @SURVEY_INFO_CHANNEL_TIME: channel active time (in ms) was filled in
- * @SURVEY_INFO_CHANNEL_TIME_BUSY: channel busy time was filled in
- * @SURVEY_INFO_CHANNEL_TIME_EXT_BUSY: extension channel busy time was filled in
- * @SURVEY_INFO_CHANNEL_TIME_RX: channel receive time was filled in
- * @SURVEY_INFO_CHANNEL_TIME_TX: channel transmit time was filled in
+ * @SURVEY_INFO_TIME: active time (in ms) was filled in
+ * @SURVEY_INFO_TIME_BUSY: busy time was filled in
+ * @SURVEY_INFO_TIME_EXT_BUSY: extension channel busy time was filled in
+ * @SURVEY_INFO_TIME_RX: receive time was filled in
+ * @SURVEY_INFO_TIME_TX: transmit time was filled in
  *
  * Used by the driver to indicate which info in &struct survey_info
  * it has filled in during the get_survey().
  */
 enum survey_info_flags {
-	SURVEY_INFO_NOISE_DBM = 1<<0,
-	SURVEY_INFO_IN_USE = 1<<1,
-	SURVEY_INFO_CHANNEL_TIME = 1<<2,
-	SURVEY_INFO_CHANNEL_TIME_BUSY = 1<<3,
-	SURVEY_INFO_CHANNEL_TIME_EXT_BUSY = 1<<4,
-	SURVEY_INFO_CHANNEL_TIME_RX = 1<<5,
-	SURVEY_INFO_CHANNEL_TIME_TX = 1<<6,
+	SURVEY_INFO_NOISE_DBM		= BIT(0),
+	SURVEY_INFO_IN_USE		= BIT(1),
+	SURVEY_INFO_TIME		= BIT(2),
+	SURVEY_INFO_TIME_BUSY		= BIT(3),
+	SURVEY_INFO_TIME_EXT_BUSY	= BIT(4),
+	SURVEY_INFO_TIME_RX		= BIT(5),
+	SURVEY_INFO_TIME_TX		= BIT(6),
 };
 
 /**
@@ -546,11 +546,11 @@ enum survey_info_flags {
  * @filled: bitflag of flags from &enum survey_info_flags
  * @noise: channel noise in dBm. This and all following fields are
  *	optional
- * @channel_time: amount of time in ms the radio spent on the channel
- * @channel_time_busy: amount of time the primary channel was sensed busy
- * @channel_time_ext_busy: amount of time the extension channel was sensed busy
- * @channel_time_rx: amount of time the radio spent receiving data
- * @channel_time_tx: amount of time the radio spent transmitting data
+ * @time: amount of time in ms the radio was turn on (on the channel)
+ * @time_busy: amount of time the primary channel was sensed busy
+ * @time_ext_busy: amount of time the extension channel was sensed busy
+ * @time_rx: amount of time the radio spent receiving data
+ * @time_tx: amount of time the radio spent transmitting data
  *
  * Used by dump_survey() to report back per-channel survey information.
  *
@@ -559,11 +559,11 @@ enum survey_info_flags {
  */
 struct survey_info {
 	struct ieee80211_channel *channel;
-	u64 channel_time;
-	u64 channel_time_busy;
-	u64 channel_time_ext_busy;
-	u64 channel_time_rx;
-	u64 channel_time_tx;
+	u64 time;
+	u64 time_busy;
+	u64 time_ext_busy;
+	u64 time_rx;
+	u64 time_tx;
 	u32 filled;
 	s8 noise;
 };
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 442369f69b4f..2e484938e36f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2746,15 +2746,15 @@ enum nl80211_user_reg_hint_type {
  * @NL80211_SURVEY_INFO_FREQUENCY: center frequency of channel
  * @NL80211_SURVEY_INFO_NOISE: noise level of channel (u8, dBm)
  * @NL80211_SURVEY_INFO_IN_USE: channel is currently being used
- * @NL80211_SURVEY_INFO_CHANNEL_TIME: amount of time (in ms) that the radio
+ * @NL80211_SURVEY_INFO_TIME: amount of time (in ms) that the radio
  *	spent on this channel
- * @NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY: amount of the time the primary
+ * @NL80211_SURVEY_INFO_TIME_BUSY: amount of the time the primary
  *	channel was sensed busy (either due to activity or energy detect)
- * @NL80211_SURVEY_INFO_CHANNEL_TIME_EXT_BUSY: amount of time the extension
+ * @NL80211_SURVEY_INFO_TIME_EXT_BUSY: amount of time the extension
  *	channel was sensed busy
- * @NL80211_SURVEY_INFO_CHANNEL_TIME_RX: amount of time the radio spent
+ * @NL80211_SURVEY_INFO_TIME_RX: amount of time the radio spent
  *	receiving data
- * @NL80211_SURVEY_INFO_CHANNEL_TIME_TX: amount of time the radio spent
+ * @NL80211_SURVEY_INFO_TIME_TX: amount of time the radio spent
  *	transmitting data
  * @NL80211_SURVEY_INFO_MAX: highest survey info attribute number
  *	currently defined
@@ -2765,17 +2765,24 @@ enum nl80211_survey_info {
 	NL80211_SURVEY_INFO_FREQUENCY,
 	NL80211_SURVEY_INFO_NOISE,
 	NL80211_SURVEY_INFO_IN_USE,
-	NL80211_SURVEY_INFO_CHANNEL_TIME,
-	NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY,
-	NL80211_SURVEY_INFO_CHANNEL_TIME_EXT_BUSY,
-	NL80211_SURVEY_INFO_CHANNEL_TIME_RX,
-	NL80211_SURVEY_INFO_CHANNEL_TIME_TX,
+	NL80211_SURVEY_INFO_TIME,
+	NL80211_SURVEY_INFO_TIME_BUSY,
+	NL80211_SURVEY_INFO_TIME_EXT_BUSY,
+	NL80211_SURVEY_INFO_TIME_RX,
+	NL80211_SURVEY_INFO_TIME_TX,
 
 	/* keep last */
 	__NL80211_SURVEY_INFO_AFTER_LAST,
 	NL80211_SURVEY_INFO_MAX = __NL80211_SURVEY_INFO_AFTER_LAST - 1
 };
 
+/* keep old names for compatibility */
+#define NL80211_SURVEY_INFO_CHANNEL_TIME		NL80211_SURVEY_INFO_TIME
+#define NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY		NL80211_SURVEY_INFO_TIME_BUSY
+#define NL80211_SURVEY_INFO_CHANNEL_TIME_EXT_BUSY	NL80211_SURVEY_INFO_TIME_EXT_BUSY
+#define NL80211_SURVEY_INFO_CHANNEL_TIME_RX		NL80211_SURVEY_INFO_TIME_RX
+#define NL80211_SURVEY_INFO_CHANNEL_TIME_TX		NL80211_SURVEY_INFO_TIME_TX
+
 /**
  * enum nl80211_mntr_flags - monitor configuration flags
  *
diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
index ebfc8091557b..eea742710c0a 100644
--- a/net/mac80211/ethtool.c
+++ b/net/mac80211/ethtool.c
@@ -175,24 +175,24 @@ do_survey:
 		data[i++] = (u8)survey.noise;
 	else
 		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME)
-		data[i++] = survey.channel_time;
+	if (survey.filled & SURVEY_INFO_TIME)
+		data[i++] = survey.time;
 	else
 		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_BUSY)
-		data[i++] = survey.channel_time_busy;
+	if (survey.filled & SURVEY_INFO_TIME_BUSY)
+		data[i++] = survey.time_busy;
 	else
 		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_EXT_BUSY)
-		data[i++] = survey.channel_time_ext_busy;
+	if (survey.filled & SURVEY_INFO_TIME_EXT_BUSY)
+		data[i++] = survey.time_ext_busy;
 	else
 		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_RX)
-		data[i++] = survey.channel_time_rx;
+	if (survey.filled & SURVEY_INFO_TIME_RX)
+		data[i++] = survey.time_rx;
 	else
 		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_TX)
-		data[i++] = survey.channel_time_tx;
+	if (survey.filled & SURVEY_INFO_TIME_TX)
+		data[i++] = survey.time_tx;
 	else
 		data[i++] = -1LL;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d0a8361b3395..48e695cba4b0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6374,25 +6374,25 @@ static int nl80211_send_survey(struct sk_buff *msg, u32 portid, u32 seq,
 	if ((survey->filled & SURVEY_INFO_IN_USE) &&
 	    nla_put_flag(msg, NL80211_SURVEY_INFO_IN_USE))
 		goto nla_put_failure;
-	if ((survey->filled & SURVEY_INFO_CHANNEL_TIME) &&
-	    nla_put_u64(msg, NL80211_SURVEY_INFO_CHANNEL_TIME,
-			survey->channel_time))
+	if ((survey->filled & SURVEY_INFO_TIME) &&
+	    nla_put_u64(msg, NL80211_SURVEY_INFO_TIME,
+			survey->time))
 		goto nla_put_failure;
-	if ((survey->filled & SURVEY_INFO_CHANNEL_TIME_BUSY) &&
-	    nla_put_u64(msg, NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY,
-			survey->channel_time_busy))
+	if ((survey->filled & SURVEY_INFO_TIME_BUSY) &&
+	    nla_put_u64(msg, NL80211_SURVEY_INFO_TIME_BUSY,
+			survey->time_busy))
 		goto nla_put_failure;
-	if ((survey->filled & SURVEY_INFO_CHANNEL_TIME_EXT_BUSY) &&
-	    nla_put_u64(msg, NL80211_SURVEY_INFO_CHANNEL_TIME_EXT_BUSY,
-			survey->channel_time_ext_busy))
+	if ((survey->filled & SURVEY_INFO_TIME_EXT_BUSY) &&
+	    nla_put_u64(msg, NL80211_SURVEY_INFO_TIME_EXT_BUSY,
+			survey->time_ext_busy))
 		goto nla_put_failure;
-	if ((survey->filled & SURVEY_INFO_CHANNEL_TIME_RX) &&
-	    nla_put_u64(msg, NL80211_SURVEY_INFO_CHANNEL_TIME_RX,
-			survey->channel_time_rx))
+	if ((survey->filled & SURVEY_INFO_TIME_RX) &&
+	    nla_put_u64(msg, NL80211_SURVEY_INFO_TIME_RX,
+			survey->time_rx))
 		goto nla_put_failure;
-	if ((survey->filled & SURVEY_INFO_CHANNEL_TIME_TX) &&
-	    nla_put_u64(msg, NL80211_SURVEY_INFO_CHANNEL_TIME_TX,
-			survey->channel_time_tx))
+	if ((survey->filled & SURVEY_INFO_TIME_TX) &&
+	    nla_put_u64(msg, NL80211_SURVEY_INFO_TIME_TX,
+			survey->time_tx))
 		goto nla_put_failure;
 
 	nla_nest_end(msg, infoattr);
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 6e25370d3ce7..2e2885ec2912 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1604,11 +1604,11 @@ TRACE_EVENT(rdev_return_int_survey_info,
 		WIPHY_ENTRY
 		CHAN_ENTRY
 		__field(int, ret)
-		__field(u64, channel_time)
-		__field(u64, channel_time_busy)
-		__field(u64, channel_time_ext_busy)
-		__field(u64, channel_time_rx)
-		__field(u64, channel_time_tx)
+		__field(u64, time)
+		__field(u64, time_busy)
+		__field(u64, time_ext_busy)
+		__field(u64, time_rx)
+		__field(u64, time_tx)
 		__field(u32, filled)
 		__field(s8, noise)
 	),
@@ -1616,11 +1616,11 @@ TRACE_EVENT(rdev_return_int_survey_info,
 		WIPHY_ASSIGN;
 		CHAN_ASSIGN(info->channel);
 		__entry->ret = ret;
-		__entry->channel_time = info->channel_time;
-		__entry->channel_time_busy = info->channel_time_busy;
-		__entry->channel_time_ext_busy = info->channel_time_ext_busy;
-		__entry->channel_time_rx = info->channel_time_rx;
-		__entry->channel_time_tx = info->channel_time_tx;
+		__entry->time = info->time;
+		__entry->time_busy = info->time_busy;
+		__entry->time_ext_busy = info->time_ext_busy;
+		__entry->time_rx = info->time_rx;
+		__entry->time_tx = info->time_tx;
 		__entry->filled = info->filled;
 		__entry->noise = info->noise;
 	),
@@ -1629,9 +1629,9 @@ TRACE_EVENT(rdev_return_int_survey_info,
 		  "channel time extension busy: %llu, channel time rx: %llu, "
 		  "channel time tx: %llu, filled: %u, noise: %d",
 		  WIPHY_PR_ARG, __entry->ret, CHAN_PR_ARG,
-		  __entry->channel_time, __entry->channel_time_busy,
-		  __entry->channel_time_ext_busy, __entry->channel_time_rx,
-		  __entry->channel_time_tx, __entry->filled, __entry->noise)
+		  __entry->time, __entry->time_busy,
+		  __entry->time_ext_busy, __entry->time_rx,
+		  __entry->time_tx, __entry->filled, __entry->noise)
 );
 
 TRACE_EVENT(rdev_tdls_oper,
-- 
2.1.1

