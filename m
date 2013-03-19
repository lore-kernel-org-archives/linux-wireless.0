Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65106 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab3CSAXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 20:23:35 -0400
Received: by mail-wi0-f172.google.com with SMTP id ez12so3342306wid.5
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2013 17:23:34 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [RFC V2 1/2] mac80211: Use a cfg80211_chan_def in ieee80211_hw_conf_chan
Date: Tue, 19 Mar 2013 01:23:19 +0100
Message-Id: <1363652600-23223-2-git-send-email-karl.beldan@gmail.com> (sfid-20130319_012339_074252_0660FEDA)
In-Reply-To: <1363652600-23223-1-git-send-email-karl.beldan@gmail.com>
References: <1363652600-23223-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Drivers that don't use chanctxes cannot perform VHT association because
they still use a "backward compatibility" pair of {ieee80211_channel,
nl80211_channel_type} in ieee80211_conf and ieee80211_local.

FIXME: this only changes mac80211_hwsim for the RFC

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   44 +++++++++++++++++---------
 include/net/mac80211.h                |   15 +++++----
 net/mac80211/cfg.c                    |    7 +---
 net/mac80211/chan.c                   |    8 ++---
 net/mac80211/ieee80211_i.h            |    3 +-
 net/mac80211/main.c                   |   55 +++++++++++++++++++--------------
 net/mac80211/mlme.c                   |   20 ++++++++----
 net/mac80211/scan.c                   |    6 ++--
 net/mac80211/trace.h                  |   21 ++++++++-----
 net/mac80211/tx.c                     |    4 +-
 net/mac80211/util.c                   |    3 +-
 11 files changed, 107 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7490c4f..96e75e2 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1056,11 +1056,13 @@ out:
 	return HRTIMER_NORESTART;
 }
 
-static const char *hwsim_chantypes[] = {
-	[NL80211_CHAN_NO_HT] = "noht",
-	[NL80211_CHAN_HT20] = "ht20",
-	[NL80211_CHAN_HT40MINUS] = "ht40-",
-	[NL80211_CHAN_HT40PLUS] = "ht40+",
+static const char *hwsim_chanwidth[] = {
+	[NL80211_CHAN_WIDTH_20_NOHT] = "noht",
+	[NL80211_CHAN_WIDTH_20] = "ht20",
+	[NL80211_CHAN_WIDTH_40] = "ht40",
+	[NL80211_CHAN_WIDTH_80] = "ht80",
+	[NL80211_CHAN_WIDTH_80P80] = "ht80p80",
+	[NL80211_CHAN_WIDTH_160] = "ht160",
 };
 
 static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
@@ -1074,18 +1076,30 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
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
+			    hwsim_chanwidth[conf->chandef.width],
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
 
@@ -1271,7 +1285,7 @@ static int mac80211_hwsim_get_survey(
 		return -ENOENT;
 
 	/* Current channel */
-	survey->channel = conf->channel;
+	survey->channel = conf->chandef.chan;
 
 	/*
 	 * Magically conjured noise level --- this is only ok for simulated hardware.
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8c0ca11..2eb3de9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1001,8 +1001,7 @@ struct ieee80211_conf {
 
 	u8 long_frame_max_tx_count, short_frame_max_tx_count;
 
-	struct ieee80211_channel *channel;
-	enum nl80211_channel_type channel_type;
+	struct cfg80211_chan_def chandef;
 	bool radar_enabled;
 	enum ieee80211_smps_mode smps_mode;
 };
@@ -4204,31 +4203,33 @@ void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
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
index 78c0d90..c3b9dc7 100644
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
@@ -106,7 +104,7 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 	WARN_ON_ONCE(ctx->refcount != 0);
 
 	if (!local->use_chanctx) {
-		local->_oper_channel_type = NL80211_CHAN_NO_HT;
+		local->_oper_chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
 		ieee80211_hw_config(local, 0);
 	} else {
 		drv_remove_chanctx(local, ctx);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 95beb18..eb84b37 100644
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
index eee1768..1da8ce0 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -92,45 +92,54 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
 	ieee80211_configure_filter(local);
 }
 
+static int ieee80211_chandef_cmp(const struct cfg80211_chan_def *def1,
+				 const struct cfg80211_chan_def *def2)
+{
+	if (def1->chan != def2->chan || def1->width != def2->width)
+		return 1;
+	if (def1->width < NL80211_CHAN_WIDTH_40)
+		return 0;
+	if (def1->width != NL80211_CHAN_WIDTH_80P80)
+		return def1->center_freq1 != def2->center_freq1 ||
+		       def1->center_freq2 != def2->center_freq2;
+	return def1->center_freq1 != def2->center_freq1;
+}
+
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
+		if (chandef.chan == local->_oper_chandef.chan)
+			chandef = local->_oper_chandef;
 		else
-			channel_type = NL80211_CHAN_NO_HT;
+			chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
 	} else if (local->tmp_channel) {
-		chan = local->tmp_channel;
-		channel_type = NL80211_CHAN_NO_HT;
-	} else {
-		chan = local->_oper_channel;
-		channel_type = local->_oper_channel_type;
-	}
+		chandef.chan = local->tmp_channel;
+		chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
+	} else
+		chandef = local->_oper_chandef;
 
-	if (chan != local->_oper_channel ||
-	    channel_type != local->_oper_channel_type)
+	if (ieee80211_chandef_cmp(&chandef, &local->_oper_chandef))
 		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
 	else
 		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
 
 	offchannel_flag ^= local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 
-	if (offchannel_flag || chan != local->hw.conf.channel ||
-	    channel_type != local->hw.conf.channel_type) {
-		local->hw.conf.channel = chan;
-		local->hw.conf.channel_type = channel_type;
+	if (offchannel_flag || ieee80211_chandef_cmp(&local->hw.conf.chandef,
+						     &local->_oper_chandef)) {
+		local->hw.conf.chandef = chandef;
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
 	}
 
@@ -146,7 +155,7 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 		changed |= IEEE80211_CONF_CHANGE_SMPS;
 	}
 
-	power = chan->max_power;
+	power = chandef.chan->max_power;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
@@ -738,11 +747,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		sband = local->hw.wiphy->bands[band];
 		if (!sband)
 			continue;
-		if (!local->use_chanctx && !local->_oper_channel) {
+		if (!local->use_chanctx && !local->_oper_chandef.chan) {
 			/* init channel we're on */
-			local->hw.conf.channel =
-			local->_oper_channel = &sband->channels[0];
-			local->hw.conf.channel_type = NL80211_CHAN_NO_HT;
+			local->hw.conf.chandef.chan =
+			local->_oper_chandef.chan = &sband->channels[0];
+			local->hw.conf.chandef.width = NL80211_CHAN_NO_HT;
 		}
 		cfg80211_chandef_create(&local->monitor_chandef,
 					&sband->channels[0],
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fdc06e3..17b9c15 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -985,7 +985,9 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	int cfreq_off;
 
 	if (!ieee80211_sdata_running(sdata))
 		return;
@@ -994,21 +996,25 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ifmgd->associated)
 		goto out;
 
-	sdata->local->_oper_channel = sdata->local->csa_channel;
-	if (!sdata->local->ops->channel_switch) {
+	cfreq_off = local->csa_channel->center_freq -
+		local->_oper_chandef.chan->center_freq;
+
+	local->_oper_chandef.center_freq1 += cfreq_off;
+	local->_oper_chandef.center_freq2 += cfreq_off;
+	local->_oper_chandef.chan = local->csa_channel;
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
 					IEEE80211_QUEUE_STOP_REASON_CSA);
  out:
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 5dc17c6..11cab5c 100644
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
index e7db2b8..be358cd 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -269,7 +269,6 @@ DEFINE_EVENT(local_sdata_addr_evt, drv_remove_interface,
 		 struct ieee80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata)
 );
-
 TRACE_EVENT(drv_config,
 	TP_PROTO(struct ieee80211_local *local,
 		 u32 changed),
@@ -286,8 +285,10 @@ TRACE_EVENT(drv_config,
 		__field(u16, listen_interval)
 		__field(u8, long_frame_max_tx_count)
 		__field(u8, short_frame_max_tx_count)
-		__field(int, center_freq)
-		__field(int, channel_type)
+		__field(int, control_freq)
+		__field(int, center_freq1)
+		__field(int, center_freq2)
+		__field(int, chan_width)
 		__field(int, smps)
 	),
 
@@ -303,15 +304,19 @@ TRACE_EVENT(drv_config,
 			local->hw.conf.long_frame_max_tx_count;
 		__entry->short_frame_max_tx_count =
 			local->hw.conf.short_frame_max_tx_count;
-		__entry->center_freq = local->hw.conf.channel ?
-					local->hw.conf.channel->center_freq : 0;
-		__entry->channel_type = local->hw.conf.channel_type;
+		__entry->control_freq = local->hw.conf.chandef.chan ?
+			local->hw.conf.chandef.chan->center_freq : 0;
+		__entry->center_freq1 = local->hw.conf.chandef.chan ?
+			local->hw.conf.chandef.center_freq1 : 0;
+		__entry->center_freq2 = local->hw.conf.chandef.chan ?
+			local->hw.conf.chandef.center_freq2 : 0;
+		__entry->chan_width = local->hw.conf.chandef.width;
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
index 3fcdf21..90988c0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1708,7 +1708,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	if (chanctx_conf)
 		chan = chanctx_conf->def.chan;
 	else if (!local->use_chanctx)
-		chan = local->_oper_channel;
+		chan = local->_oper_chandef.chan;
 	else
 		goto fail_rcu;
 
@@ -1842,7 +1842,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		 * This is the exception! WDS style interfaces are prohibited
 		 * when channel contexts are in used so this must be valid
 		 */
-		band = local->hw.conf.channel->band;
+		band = local->hw.conf.chandef.chan->band;
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index b7a856e..5d1fbb2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2137,8 +2137,7 @@ void ieee80211_dfs_radar_detected_work(struct work_struct *work)
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
1.7.9.dirty

