Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37309 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757652Ab2C1JGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:06:14 -0400
Message-Id: <20120328085901.175434140@sipsolutions.net> (sfid-20120328_110635_542452_336D0576)
Date: Wed, 28 Mar 2012 10:58:37 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mac80211: remove channel type argument from rate_update
References: <20120328085835.902687300@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The channel type argument to the rate_update()
callback isn't really the correct way to give
the rate control algorithm about the desired
RX bandwidth of the peer.

Remove this argument, and instead update the
STA capabilities with 20/40 appropriately. The
SMPS update done by this callback works in the
same way, so this makes the callback cleaner.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    5 +--
 drivers/net/wireless/rtlwifi/rc.c   |    3 --
 include/net/mac80211.h              |    5 +--
 net/mac80211/chan.c                 |   26 ------------------
 net/mac80211/ieee80211_i.h          |    5 ---
 net/mac80211/mlme.c                 |   51 ++++++++++++++++++++++++------------
 net/mac80211/rate.h                 |    5 +--
 net/mac80211/rc80211_minstrel_ht.c  |   15 ++--------
 net/mac80211/rx.c                   |    7 +---
 net/mac80211/sta_info.h             |    2 +
 10 files changed, 50 insertions(+), 74 deletions(-)

--- a/include/net/mac80211.h	2012-03-26 12:25:00.000000000 +0200
+++ b/include/net/mac80211.h	2012-03-26 12:25:15.000000000 +0200
@@ -3567,9 +3567,8 @@ struct rate_control_ops {
 	void (*rate_init)(void *priv, struct ieee80211_supported_band *sband,
 			  struct ieee80211_sta *sta, void *priv_sta);
 	void (*rate_update)(void *priv, struct ieee80211_supported_band *sband,
-			    struct ieee80211_sta *sta,
-			    void *priv_sta, u32 changed,
-			    enum nl80211_channel_type oper_chan_type);
+			    struct ieee80211_sta *sta, void *priv_sta,
+			    u32 changed);
 	void (*free_sta)(void *priv, struct ieee80211_sta *sta,
 			 void *priv_sta);
 
--- a/drivers/net/wireless/ath/ath9k/rc.c	2012-03-23 17:58:42.000000000 +0100
+++ b/drivers/net/wireless/ath/ath9k/rc.c	2012-03-26 12:25:15.000000000 +0200
@@ -1436,7 +1436,7 @@ static void ath_rate_init(void *priv, st
 
 static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 			    struct ieee80211_sta *sta, void *priv_sta,
-			    u32 changed, enum nl80211_channel_type oper_chan_type)
+			    u32 changed)
 {
 	struct ath_softc *sc = priv;
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
@@ -1451,8 +1451,7 @@ static void ath_rate_update(void *priv,
 		if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
 			return;
 
-		if (oper_chan_type == NL80211_CHAN_HT40MINUS ||
-		    oper_chan_type == NL80211_CHAN_HT40PLUS)
+		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
 			oper_cw40 = true;
 
 		if (oper_cw40)
--- a/net/mac80211/rx.c	2012-03-23 17:58:42.000000000 +0100
+++ b/net/mac80211/rx.c	2012-03-26 12:25:15.000000000 +0200
@@ -2269,11 +2269,8 @@ ieee80211_rx_h_action(struct ieee80211_r
 
 			sband = rx->local->hw.wiphy->bands[status->band];
 
-			rate_control_rate_update(
-				local, sband, rx->sta,
-				IEEE80211_RC_SMPS_CHANGED,
-				ieee80211_get_tx_channel_type(
-					local, local->_oper_channel_type));
+			rate_control_rate_update(local, sband, rx->sta,
+						 IEEE80211_RC_SMPS_CHANGED);
 			goto handled;
 		}
 		default:
--- a/net/mac80211/mlme.c	2012-03-26 12:25:14.000000000 +0200
+++ b/net/mac80211/mlme.c	2012-03-26 12:25:15.000000000 +0200
@@ -180,21 +180,38 @@ static u32 ieee80211_config_ht_tx(struct
 	struct sta_info *sta;
 	u32 changed = 0;
 	u16 ht_opmode;
-	enum nl80211_channel_type channel_type;
+	bool disable_40 = false;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	channel_type = local->hw.conf.channel_type;
 
-	if (WARN_ON_ONCE(channel_type == NL80211_CHAN_NO_HT))
-		return 0;
-
-	channel_type = ieee80211_get_tx_channel_type(local, channel_type);
+	switch (sdata->vif.bss_conf.channel_type) {
+	case NL80211_CHAN_HT40PLUS:
+		if (local->hw.conf.channel->flags & IEEE80211_CHAN_NO_HT40PLUS)
+			disable_40 = true;
+		break;
+	case NL80211_CHAN_HT40MINUS:
+		if (local->hw.conf.channel->flags & IEEE80211_CHAN_NO_HT40MINUS)
+			disable_40 = true;
+		break;
+	default:
+		break;
+	}
 
 	/* This can change during the lifetime of the BSS */
 	if (!(ht_oper->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
-		channel_type = NL80211_CHAN_HT20;
+		disable_40 = true;
+
+	mutex_lock(&local->sta_mtx);
+	sta = sta_info_get(sdata, bssid);
 
-	if (!reconfig || (sdata->u.mgd.tx_chantype != channel_type)) {
+	WARN_ON_ONCE(!sta);
+
+	if (sta && !sta->supports_40mhz)
+		disable_40 = true;
+
+	if (sta && (!reconfig ||
+		    (disable_40 != !!(sta->sta.ht_cap.cap &
+					IEEE80211_HT_CAP_SUP_WIDTH_20_40)))) {
 		if (reconfig) {
 			/*
 			 * Whenever the AP announces the HT mode changed
@@ -211,20 +228,19 @@ static u32 ieee80211_config_ht_tx(struct
 			drv_flush(local, false);
 		}
 
-		rcu_read_lock();
-		sta = sta_info_get(sdata, bssid);
-		if (sta)
-			rate_control_rate_update(local, sband, sta,
-						 IEEE80211_RC_HT_CHANGED,
-						 channel_type);
-		rcu_read_unlock();
+		if (disable_40)
+			sta->sta.ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+		else
+			sta->sta.ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 
-		sdata->u.mgd.tx_chantype = channel_type;
+		rate_control_rate_update(local, sband, sta,
+					 IEEE80211_RC_HT_CHANGED);
 
 		if (reconfig)
 			ieee80211_wake_queues_by_reason(&sdata->local->hw,
 				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
 	}
+	mutex_unlock(&local->sta_mtx);
 
 	ht_opmode = le16_to_cpu(ht_oper->operation_mode);
 
@@ -1995,6 +2011,9 @@ static bool ieee80211_assoc_success(stru
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
+	sta->supports_40mhz =
+		sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+
 	rate_control_rate_init(sta);
 
 	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
--- a/net/mac80211/rate.h	2012-03-23 17:58:42.000000000 +0100
+++ b/net/mac80211/rate.h	2012-03-26 12:25:15.000000000 +0200
@@ -63,8 +63,7 @@ static inline void rate_control_rate_ini
 
 static inline void rate_control_rate_update(struct ieee80211_local *local,
 				    struct ieee80211_supported_band *sband,
-				    struct sta_info *sta, u32 changed,
-				    enum nl80211_channel_type oper_chan_type)
+				    struct sta_info *sta, u32 changed)
 {
 	struct rate_control_ref *ref = local->rate_ctrl;
 	struct ieee80211_sta *ista = &sta->sta;
@@ -72,7 +71,7 @@ static inline void rate_control_rate_upd
 
 	if (ref && ref->ops->rate_update)
 		ref->ops->rate_update(ref->priv, sband, ista,
-				      priv_sta, changed, oper_chan_type);
+				      priv_sta, changed);
 }
 
 static inline void *rate_control_alloc_sta(struct rate_control_ref *ref,
--- a/net/mac80211/rc80211_minstrel_ht.c	2012-03-23 17:58:42.000000000 +0100
+++ b/net/mac80211/rc80211_minstrel_ht.c	2012-03-26 12:25:15.000000000 +0200
@@ -686,8 +686,7 @@ minstrel_ht_get_rate(void *priv, struct
 
 static void
 minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
-                        struct ieee80211_sta *sta, void *priv_sta,
-			enum nl80211_channel_type oper_chan_type)
+                        struct ieee80211_sta *sta, void *priv_sta)
 {
 	struct minstrel_priv *mp = priv;
 	struct minstrel_ht_sta_priv *msp = priv_sta;
@@ -735,10 +734,6 @@ minstrel_ht_update_caps(void *priv, stru
 	if (sta_cap & IEEE80211_HT_CAP_LDPC_CODING)
 		mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
 
-	if (oper_chan_type != NL80211_CHAN_HT40MINUS &&
-	    oper_chan_type != NL80211_CHAN_HT40PLUS)
-		sta_cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-
 	smps = (sta_cap & IEEE80211_HT_CAP_SM_PS) >>
 		IEEE80211_HT_CAP_SM_PS_SHIFT;
 
@@ -788,17 +783,15 @@ static void
 minstrel_ht_rate_init(void *priv, struct ieee80211_supported_band *sband,
                       struct ieee80211_sta *sta, void *priv_sta)
 {
-	struct minstrel_priv *mp = priv;
-
-	minstrel_ht_update_caps(priv, sband, sta, priv_sta, mp->hw->conf.channel_type);
+	minstrel_ht_update_caps(priv, sband, sta, priv_sta);
 }
 
 static void
 minstrel_ht_rate_update(void *priv, struct ieee80211_supported_band *sband,
                         struct ieee80211_sta *sta, void *priv_sta,
-                        u32 changed, enum nl80211_channel_type oper_chan_type)
+                        u32 changed)
 {
-	minstrel_ht_update_caps(priv, sband, sta, priv_sta, oper_chan_type);
+	minstrel_ht_update_caps(priv, sband, sta, priv_sta);
 }
 
 static void *
--- a/drivers/net/wireless/rtlwifi/rc.c	2012-03-23 17:58:42.000000000 +0100
+++ b/drivers/net/wireless/rtlwifi/rc.c	2012-03-26 12:25:15.000000000 +0200
@@ -225,8 +225,7 @@ static void rtl_rate_init(void *ppriv,
 static void rtl_rate_update(void *ppriv,
 			    struct ieee80211_supported_band *sband,
 			    struct ieee80211_sta *sta, void *priv_sta,
-			    u32 changed,
-			    enum nl80211_channel_type oper_chan_type)
+			    u32 changed)
 {
 }
 
--- a/net/mac80211/chan.c	2012-03-23 17:58:42.000000000 +0100
+++ b/net/mac80211/chan.c	2012-03-26 12:25:15.000000000 +0200
@@ -135,29 +135,3 @@ bool ieee80211_set_channel_type(struct i
 
 	return result;
 }
-
-/*
- * ieee80211_get_tx_channel_type returns the channel type we should
- * use for packet transmission, given the channel capability and
- * whatever regulatory flags we have been given.
- */
-enum nl80211_channel_type ieee80211_get_tx_channel_type(
-				struct ieee80211_local *local,
-				enum nl80211_channel_type channel_type)
-{
-	switch (channel_type) {
-	case NL80211_CHAN_HT40PLUS:
-		if (local->hw.conf.channel->flags &
-				IEEE80211_CHAN_NO_HT40PLUS)
-			return NL80211_CHAN_HT20;
-		break;
-	case NL80211_CHAN_HT40MINUS:
-		if (local->hw.conf.channel->flags &
-				IEEE80211_CHAN_NO_HT40MINUS)
-			return NL80211_CHAN_HT20;
-		break;
-	default:
-		break;
-	}
-	return channel_type;
-}
--- a/net/mac80211/ieee80211_i.h	2012-03-26 12:25:14.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2012-03-26 12:25:15.000000000 +0200
@@ -512,8 +512,6 @@ struct ieee80211_if_managed {
 	int rssi_min_thold, rssi_max_thold;
 	int last_ave_beacon_signal;
 
-	enum nl80211_channel_type tx_chantype;
-
 	struct ieee80211_ht_cap ht_capa; /* configured ht-cap over-rides */
 	struct ieee80211_ht_cap ht_capa_mask; /* Valid parts of ht_capa */
 };
@@ -1501,9 +1499,6 @@ bool ieee80211_set_channel_type(struct i
 				enum nl80211_channel_type chantype);
 enum nl80211_channel_type
 ieee80211_ht_oper_to_channel_type(struct ieee80211_ht_operation *ht_oper);
-enum nl80211_channel_type ieee80211_get_tx_channel_type(
-					struct ieee80211_local *local,
-					enum nl80211_channel_type channel_type);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
--- a/net/mac80211/sta_info.h	2012-03-23 17:58:42.000000000 +0100
+++ b/net/mac80211/sta_info.h	2012-03-26 12:25:15.000000000 +0200
@@ -365,6 +365,8 @@ struct sta_info {
 	unsigned int lost_packets;
 	unsigned int beacon_loss_count;
 
+	bool supports_40mhz;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };


