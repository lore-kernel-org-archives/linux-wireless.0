Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:36010 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933715Ab3CVPvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 11:51:46 -0400
Received: by mail-ea0-f169.google.com with SMTP id z7so1499378eaf.28
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2013 08:51:45 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [RFC V3 1/2] mac80211: Use a cfg80211_chan_def in ieee80211_hw_conf_chan
Date: Fri, 22 Mar 2013 16:48:23 +0100
Message-Id: <1363967304-4394-1-git-send-email-karl.beldan@gmail.com> (sfid-20130322_165152_512870_C297D0D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Drivers that don't use chanctxes cannot perform VHT association because
they still use a "backward compatibility" pair of {ieee80211_channel,
nl80211_channel_type} in ieee80211_conf and ieee80211_local.

FIXME:
- *this only changes mac80211_hwsim for the RFC
- *this improperly handles CSA (c.f mlme.c:ieee80211_chswitch_work())

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   44 +++++++++++++++---------
 include/net/mac80211.h                |   15 +++++----
 net/mac80211/cfg.c                    |    7 ++--
 net/mac80211/chan.c                   |   11 +++---
 net/mac80211/ieee80211_i.h            |    3 +-
 net/mac80211/main.c                   |   59 +++++++++++++++++++--------------
 net/mac80211/mlme.c                   |   25 +++++++++-----
 net/mac80211/scan.c                   |    6 ++--
 net/mac80211/trace.h                  |   17 ++++------
 net/mac80211/tx.c                     |    4 +--
 net/mac80211/util.c                   |    3 +-
 11 files changed, 110 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0064d38..33d23e5 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1062,11 +1062,13 @@ out:
 	return HRTIMER_NORESTART;
 }
 
-static const char *hwsim_chantypes[] = {
-	[NL80211_CHAN_NO_HT] = "noht",
-	[NL80211_CHAN_HT20] = "ht20",
-	[NL80211_CHAN_HT40MINUS] = "ht40-",
-	[NL80211_CHAN_HT40PLUS] = "ht40+",
+static const char *hwsim_chanwidths[] = {
+	[NL80211_CHAN_WIDTH_20_NOHT] = "noht",
+	[NL80211_CHAN_WIDTH_20] = "ht20",
+	[NL80211_CHAN_WIDTH_40] = "ht40",
+	[NL80211_CHAN_WIDTH_80] = "vht80",
+	[NL80211_CHAN_WIDTH_80P80] = "vht80p80",
+	[NL80211_CHAN_WIDTH_160] = "vht160",
 };
 
 static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
@@ -1080,18 +1082,30 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 		[IEEE80211_SMPS_DYNAMIC] = "dynamic",
 	};
 
-	wiphy_debug(hw->wiphy,
-		    "%s (freq=%d/%s idle=%d ps=%d smps=%s)\n",
-		    __func__,
-		    conf->channel ? conf->channel->center_freq : 0,
-		    hwsim_chantypes[conf->channel_type],
-		    !!(conf->flags & IEEE80211_CONF_IDLE),
-		    !!(conf->flags & IEEE80211_CONF_PS),
-		    smps_modes[conf->smps_mode]);
+	if (conf->chandef.chan)
+		wiphy_debug(hw->wiphy,
+			    "%s (freq=%d(%d - %d)/%s idle=%d ps=%d smps=%s)\n",
+			    __func__,
+			    conf->chandef.chan->center_freq,
+			    conf->chandef.width > NL80211_CHAN_WIDTH_20 ?
+			    conf->chandef.center_freq1 : 0,
+			    conf->chandef.width > NL80211_CHAN_WIDTH_40 ?
+			    conf->chandef.center_freq2 : 0,
+			    hwsim_chanwidths[conf->chandef.width],
+			    !!(conf->flags & IEEE80211_CONF_IDLE),
+			    !!(conf->flags & IEEE80211_CONF_PS),
+			    smps_modes[conf->smps_mode]);
+	else
+		wiphy_debug(hw->wiphy,
+			    "%s (freq=0 idle=%d ps=%d smps=%s)\n",
+			    __func__,
+			    !!(conf->flags & IEEE80211_CONF_IDLE),
+			    !!(conf->flags & IEEE80211_CONF_PS),
+			    smps_modes[conf->smps_mode]);
 
 	data->idle = !!(conf->flags & IEEE80211_CONF_IDLE);
 
-	data->channel = conf->channel;
+	data->channel = conf->chandef.chan;
 
 	WARN_ON(data->channel && channels > 1);
 
@@ -1277,7 +1291,7 @@ static int mac80211_hwsim_get_survey(
 		return -ENOENT;
 
 	/* Current channel */
-	survey->channel = conf->channel;
+	survey->channel = conf->chandef.chan;
 
 	/*
 	 * Magically conjured noise level --- this is only ok for simulated hardware.
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dd73b8c..0584dd3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1003,8 +1003,7 @@ struct ieee80211_conf {
 
 	u8 long_frame_max_tx_count, short_frame_max_tx_count;
 
-	struct ieee80211_channel *channel;
-	enum nl80211_channel_type channel_type;
+	struct cfg80211_chan_def chandef;
 	bool radar_enabled;
 	enum ieee80211_smps_mode smps_mode;
 };
@@ -4205,31 +4204,33 @@ void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
 static inline bool
 conf_is_ht20(struct ieee80211_conf *conf)
 {
-	return conf->channel_type == NL80211_CHAN_HT20;
+	return conf->chandef.width == NL80211_CHAN_WIDTH_20;
 }
 
 static inline bool
 conf_is_ht40_minus(struct ieee80211_conf *conf)
 {
-	return conf->channel_type == NL80211_CHAN_HT40MINUS;
+	return conf->chandef.width == NL80211_CHAN_WIDTH_40 &&
+	       conf->chandef.center_freq1 < conf->chandef.chan->center_freq;
 }
 
 static inline bool
 conf_is_ht40_plus(struct ieee80211_conf *conf)
 {
-	return conf->channel_type == NL80211_CHAN_HT40PLUS;
+	return conf->chandef.width == NL80211_CHAN_WIDTH_40 &&
+	       conf->chandef.center_freq1 > conf->chandef.chan->center_freq;
 }
 
 static inline bool
 conf_is_ht40(struct ieee80211_conf *conf)
 {
-	return conf_is_ht40_minus(conf) || conf_is_ht40_plus(conf);
+	return conf->chandef.width == NL80211_CHAN_WIDTH_40;
 }
 
 static inline bool
 conf_is_ht(struct ieee80211_conf *conf)
 {
-	return conf->channel_type != NL80211_CHAN_NO_HT;
+	return conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT;
 }
 
 static inline enum nl80211_iftype
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e5c1441..8a59294 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -805,8 +805,7 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 					IEEE80211_CHANCTX_EXCLUSIVE);
 		}
 	} else if (local->open_count == local->monitors) {
-		local->_oper_channel = chandef->chan;
-		local->_oper_channel_type = cfg80211_get_chandef_type(chandef);
+		local->_oper_chandef = *chandef;
 		ieee80211_hw_config(local, 0);
 	}
 
@@ -3360,9 +3359,7 @@ static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
 		if (local->use_chanctx)
 			*chandef = local->monitor_chandef;
 		else
-			cfg80211_chandef_create(chandef,
-						local->_oper_channel,
-						local->_oper_channel_type);
+			*chandef = local->_oper_chandef;
 		ret = 0;
 	}
 	rcu_read_unlock();
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 78c0d90..8024874 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -22,7 +22,7 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
 	drv_change_chanctx(local, ctx, IEEE80211_CHANCTX_CHANGE_WIDTH);
 
 	if (!local->use_chanctx) {
-		local->_oper_channel_type = cfg80211_get_chandef_type(chandef);
+		local->_oper_chandef = *chandef;
 		ieee80211_hw_config(local, 0);
 	}
 }
@@ -77,9 +77,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	ctx->mode = mode;
 
 	if (!local->use_chanctx) {
-		local->_oper_channel_type =
-			cfg80211_get_chandef_type(chandef);
-		local->_oper_channel = chandef->chan;
+		local->_oper_chandef = *chandef;
 		ieee80211_hw_config(local, 0);
 	} else {
 		err = drv_add_chanctx(local, ctx);
@@ -106,7 +104,10 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 	WARN_ON_ONCE(ctx->refcount != 0);
 
 	if (!local->use_chanctx) {
-		local->_oper_channel_type = NL80211_CHAN_NO_HT;
+		struct cfg80211_chan_def *chandef = &local->_oper_chandef;
+		chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
+		chandef->center_freq1 = chandef->chan->center_freq;
+		chandef->center_freq2 = 0;
 		ieee80211_hw_config(local, 0);
 	} else {
 		drv_remove_chanctx(local, ctx);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ae2d175..9dc2bf4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1022,8 +1022,7 @@ struct ieee80211_local {
 	struct ieee80211_sub_if_data __rcu *scan_sdata;
 	struct ieee80211_channel *csa_channel;
 	/* For backward compatibility only -- do not use */
-	struct ieee80211_channel *_oper_channel;
-	enum nl80211_channel_type _oper_channel_type;
+	struct cfg80211_chan_def _oper_chandef;
 
 	/* Temporary remain-on-channel for off-channel operations */
 	struct ieee80211_channel *tmp_channel;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c6f81ec..c71efbe 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -95,42 +95,47 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
 static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_channel *chan;
+	struct cfg80211_chan_def chandef = {};
 	u32 changed = 0;
 	int power;
-	enum nl80211_channel_type channel_type;
 	u32 offchannel_flag;
 
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
+
 	if (local->scan_channel) {
-		chan = local->scan_channel;
+		chandef.chan = local->scan_channel;
 		/* If scanning on oper channel, use whatever channel-type
 		 * is currently in use.
 		 */
-		if (chan == local->_oper_channel)
-			channel_type = local->_oper_channel_type;
-		else
-			channel_type = NL80211_CHAN_NO_HT;
+		if (chandef.chan == local->_oper_chandef.chan)
+			chandef = local->_oper_chandef;
+		else {
+			chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
+			chandef.center_freq1 = chandef.chan->center_freq;
+		}
 	} else if (local->tmp_channel) {
-		chan = local->tmp_channel;
-		channel_type = NL80211_CHAN_NO_HT;
-	} else {
-		chan = local->_oper_channel;
-		channel_type = local->_oper_channel_type;
-	}
-
-	if (chan != local->_oper_channel ||
-	    channel_type != local->_oper_channel_type)
+		chandef.chan = local->tmp_channel;
+		chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
+		chandef.center_freq1 = chandef.chan->center_freq;
+	} else
+		chandef = local->_oper_chandef;
+
+	WARN(!cfg80211_chandef_valid(&chandef),
+	     "control:%d MHz width:%d center: %d/%d MHz",
+	     chandef.chan->center_freq, chandef.width,
+	     chandef.center_freq1, chandef.center_freq2);
+
+	if (!cfg80211_chandef_identical(&chandef, &local->_oper_chandef))
 		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
 	else
 		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
 
 	offchannel_flag ^= local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 
-	if (offchannel_flag || chan != local->hw.conf.channel ||
-	    channel_type != local->hw.conf.channel_type) {
-		local->hw.conf.channel = chan;
-		local->hw.conf.channel_type = channel_type;
+	if (offchannel_flag ||
+	    !cfg80211_chandef_identical(&local->hw.conf.chandef,
+					&local->_oper_chandef)) {
+		local->hw.conf.chandef = chandef;
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
 	}
 
@@ -146,7 +151,7 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 		changed |= IEEE80211_CONF_CHANGE_SMPS;
 	}
 
-	power = chan->max_power;
+	power = chandef.chan->max_power;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
@@ -738,11 +743,15 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		sband = local->hw.wiphy->bands[band];
 		if (!sband)
 			continue;
-		if (!local->use_chanctx && !local->_oper_channel) {
+		if (!local->use_chanctx && !local->_oper_chandef.chan) {
 			/* init channel we're on */
-			local->hw.conf.channel =
-			local->_oper_channel = &sband->channels[0];
-			local->hw.conf.channel_type = NL80211_CHAN_NO_HT;
+			struct cfg80211_chan_def init_chandef = {
+				.chan = &sband->channels[0],
+				.width = NL80211_CHAN_NO_HT,
+				.center_freq1 = sband->channels[0].center_freq,
+				.center_freq2 = 0
+			};
+			local->hw.conf.chandef = local->_oper_chandef = init_chandef;
 		}
 		cfg80211_chandef_create(&local->monitor_chandef,
 					&sband->channels[0],
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4d383a9..e031c77 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -985,6 +985,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (!ieee80211_sdata_running(sdata))
@@ -994,24 +995,32 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ifmgd->associated)
 		goto out;
 
-	sdata->local->_oper_channel = sdata->local->csa_channel;
-	if (!sdata->local->ops->channel_switch) {
+	/*
+	 * FIXME: Here we are downgrading to NL80211_CHAN_WIDTH_20_NOHT
+	 * and don't adjust our ht/vht settings
+	 * This is wrong - we should behave according to the CSA params
+	 */
+	local->_oper_chandef.chan = local->csa_channel;
+	local->_oper_chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
+	local->_oper_chandef.center_freq1 = local->_oper_chandef.chan->center_freq;
+	local->_oper_chandef.center_freq2 = 0;
+
+	if (!local->ops->channel_switch) {
 		/* call "hw_config" only if doing sw channel switch */
-		ieee80211_hw_config(sdata->local,
-			IEEE80211_CONF_CHANGE_CHANNEL);
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 	} else {
 		/* update the device channel directly */
-		sdata->local->hw.conf.channel = sdata->local->_oper_channel;
+		local->hw.conf.chandef = local->_oper_chandef;
 	}
 
 	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->channel = sdata->local->_oper_channel;
+	ifmgd->associated->channel = local->_oper_chandef.chan;
 
 	/* XXX: wait for a beacon first? */
-	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+	ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
- out:
+out:
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
 	mutex_unlock(&ifmgd->mtx);
 }
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index cb34cbb..581764f 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -384,7 +384,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 {
 	int i;
 	struct ieee80211_sub_if_data *sdata;
-	enum ieee80211_band band = local->hw.conf.channel->band;
+	enum ieee80211_band band = local->hw.conf.chandef.chan->band;
 	u32 tx_flags;
 
 	tx_flags = IEEE80211_TX_INTFL_OFFCHAN_TX_OK;
@@ -401,7 +401,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 			local->scan_req->ssids[i].ssid_len,
 			local->scan_req->ie, local->scan_req->ie_len,
 			local->scan_req->rates[band], false,
-			tx_flags, local->hw.conf.channel, true);
+			tx_flags, local->hw.conf.chandef.chan, true);
 
 	/*
 	 * After sending probe requests, wait for probe responses
@@ -467,7 +467,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	if (local->ops->hw_scan) {
 		__set_bit(SCAN_HW_SCANNING, &local->scanning);
 	} else if ((req->n_channels == 1) &&
-		   (req->channels[0] == local->_oper_channel)) {
+		   (req->channels[0] == local->_oper_chandef.chan)) {
 		/*
 		 * If we are scanning only on the operating channel
 		 * then we do not need to stop normal activities
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index c589979..dcf8444 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -33,9 +33,9 @@
 			__field(u32, center_freq1)				\
 			__field(u32, center_freq2)
 #define CHANDEF_ASSIGN(c)							\
-			__entry->control_freq = (c)->chan->center_freq;		\
-			__entry->chan_width = (c)->width;			\
-			__entry->center_freq1 = (c)->center_freq1;		\
+			__entry->control_freq = (c)->chan ? (c)->chan->center_freq : 0;	\
+			__entry->chan_width = (c)->width;				\
+			__entry->center_freq1 = (c)->center_freq1;			\
 			__entry->center_freq2 = (c)->center_freq2;
 #define CHANDEF_PR_FMT	" control:%d MHz width:%d center: %d/%d MHz"
 #define CHANDEF_PR_ARG	__entry->control_freq, __entry->chan_width,		\
@@ -286,8 +286,7 @@ TRACE_EVENT(drv_config,
 		__field(u16, listen_interval)
 		__field(u8, long_frame_max_tx_count)
 		__field(u8, short_frame_max_tx_count)
-		__field(int, center_freq)
-		__field(int, channel_type)
+		CHANDEF_ENTRY
 		__field(int, smps)
 	),
 
@@ -303,15 +302,13 @@ TRACE_EVENT(drv_config,
 			local->hw.conf.long_frame_max_tx_count;
 		__entry->short_frame_max_tx_count =
 			local->hw.conf.short_frame_max_tx_count;
-		__entry->center_freq = local->hw.conf.channel ?
-					local->hw.conf.channel->center_freq : 0;
-		__entry->channel_type = local->hw.conf.channel_type;
+		CHANDEF_ASSIGN(&local->hw.conf.chandef)
 		__entry->smps = local->hw.conf.smps_mode;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " ch:%#x freq:%d",
-		LOCAL_PR_ARG, __entry->changed, __entry->center_freq
+		LOCAL_PR_FMT " ch:%#x" CHANDEF_PR_FMT,
+		LOCAL_PR_ARG, __entry->changed, CHANDEF_PR_ARG
 	)
 );
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2a6ae80..38ffa1c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1709,7 +1709,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	if (chanctx_conf)
 		chan = chanctx_conf->def.chan;
 	else if (!local->use_chanctx)
-		chan = local->_oper_channel;
+		chan = local->_oper_chandef.chan;
 	else
 		goto fail_rcu;
 
@@ -1843,7 +1843,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		 * This is the exception! WDS style interfaces are prohibited
 		 * when channel contexts are in used so this must be valid
 		 */
-		band = local->hw.conf.channel->band;
+		band = local->hw.conf.chandef.chan->band;
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 90cc2b8..1734cd2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2171,8 +2171,7 @@ void ieee80211_dfs_radar_detected_work(struct work_struct *work)
 		/* currently not handled */
 		WARN_ON(1);
 	else {
-		cfg80211_chandef_create(&chandef, local->hw.conf.channel,
-					local->hw.conf.channel_type);
+		chandef = local->hw.conf.chandef;
 		cfg80211_radar_event(local->hw.wiphy, &chandef, GFP_KERNEL);
 	}
 }
-- 
1.7.10.GIT

