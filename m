Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965275Ab2COPxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 11:53:51 -0400
Message-Id: <20120315155228.138282599@sipsolutions.net> (sfid-20120315_165356_549239_A34CDA8B)
Date: Thu, 15 Mar 2012 16:41:34 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Paul Stewart <pstew@chromium.org>
Subject: [RFC 1/3] mac80211: set HT channel before association
References: <20120315154133.312616639@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Changing the channel type during operation is
confusing to some drivers and will be hard to
handle in multi-channel scenarios. Instead of
changing the channel, set it to the right HT
channel before authenticating/associating and
don't change it -- just update the 20/40 MHz
restrictions in rate control as needed when
changed by the AP.

This also fixes a problem that Paul missed in
his fix for the "regulatory makes us deaf"
issue -- when we couldn't use 40 MHz we still
associated saying we were using 40 MHz, which
could in similarly broken APs make us never
even connect successfully.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/networking/mac80211-auth-assoc-deauth.txt |   10 
 net/mac80211/ht.c                                       |    9 
 net/mac80211/ieee80211_i.h                              |   10 
 net/mac80211/mlme.c                                     |  225 +++++++---------
 4 files changed, 117 insertions(+), 137 deletions(-)

--- a/net/mac80211/ieee80211_i.h	2012-03-15 15:50:35.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2012-03-15 16:27:56.000000000 +0100
@@ -378,6 +378,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
 	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
 	IEEE80211_STA_RESET_SIGNAL_AVE	= BIT(9),
+	IEEE80211_STA_DISABLE_40MHZ	= BIT(10),
 };
 
 struct ieee80211_mgd_auth_data {
@@ -497,6 +498,8 @@ struct ieee80211_if_managed {
 	int rssi_min_thold, rssi_max_thold;
 	int last_ave_beacon_signal;
 
+	enum nl80211_channel_type tx_chantype;
+
 	struct ieee80211_ht_cap ht_capa; /* configured ht-cap over-rides */
 	struct ieee80211_ht_cap ht_capa_mask; /* Valid parts of ht_capa */
 };
@@ -653,12 +656,6 @@ struct ieee80211_sub_if_data {
 
 	char name[IFNAMSIZ];
 
-	/*
-	 * keep track of whether the HT opmode (stored in
-	 * vif.bss_info.ht_operation_mode) is valid.
-	 */
-	bool ht_opmode_valid;
-
 	/* to detect idle changes */
 	bool old_idle;
 
@@ -1300,7 +1297,6 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 				       struct net_device *dev);
 
 /* HT */
-bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata);
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_sta_ht_cap *ht_cap);
 void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
--- a/net/mac80211/mlme.c	2012-03-15 15:50:35.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-15 16:27:56.000000000 +0100
@@ -171,109 +171,57 @@ static int ecw2cw(int ecw)
 	return (1 << ecw) - 1;
 }
 
-/*
- * ieee80211_enable_ht should be called only after the operating band
- * has been determined as ht configuration depends on the hw's
- * HT abilities for a specific band.
- */
-static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
-			       struct ieee80211_ht_operation *ht_oper,
-			       const u8 *bssid, u16 ap_ht_cap_flags,
-			       bool beacon_htcap_ie)
+static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_ht_operation *ht_oper,
+				  const u8 *bssid, bool reconfig)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 	u32 changed = 0;
-	int ht_cfreq;
 	u16 ht_opmode;
-	bool enable_ht = true;
-	enum nl80211_channel_type prev_chantype;
-	enum nl80211_channel_type rx_channel_type = NL80211_CHAN_NO_HT;
-	enum nl80211_channel_type tx_channel_type;
+	enum nl80211_channel_type channel_type;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	prev_chantype = sdata->vif.bss_conf.channel_type;
-
-
-	ht_cfreq = ieee80211_channel_to_frequency(ht_oper->primary_chan,
-						  sband->band);
-	/* check that channel matches the right operating channel */
-	if (local->hw.conf.channel->center_freq != ht_cfreq) {
-		/* Some APs mess this up, evidently.
-		 * Netgear WNDR3700 sometimes reports 4 higher than
-		 * the actual channel, for instance.
-		 */
-		printk(KERN_DEBUG
-		       "%s: Wrong control channel in association"
-		       " response: configured center-freq: %d"
-		       " ht-cfreq: %d  ht->control_chan: %d"
-		       " band: %d.  Disabling HT.\n",
-		       sdata->name,
-		       local->hw.conf.channel->center_freq,
-		       ht_cfreq, ht_oper->primary_chan,
-		       sband->band);
-		enable_ht = false;
-	}
-
-	if (enable_ht) {
-		rx_channel_type = NL80211_CHAN_HT20;
-
-		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
-		    !ieee80111_cfg_override_disables_ht40(sdata) &&
-		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
-		    (ht_oper->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
-			switch(ht_oper->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
-			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-				rx_channel_type = NL80211_CHAN_HT40PLUS;
-				break;
-			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-				rx_channel_type = NL80211_CHAN_HT40MINUS;
-				break;
-			}
-		}
-	}
+	channel_type = local->hw.conf.channel_type;
 
-	tx_channel_type = ieee80211_get_tx_channel_type(local, rx_channel_type);
+	if (WARN_ON_ONCE(channel_type == NL80211_CHAN_NO_HT))
+		return 0;
 
-	if (local->tmp_channel)
-		local->tmp_channel_type = rx_channel_type;
+	channel_type = ieee80211_get_tx_channel_type(local, channel_type);
 
-	if (!ieee80211_set_channel_type(local, sdata, rx_channel_type)) {
-		/* can only fail due to HT40+/- mismatch */
-		rx_channel_type = NL80211_CHAN_HT20;
-		WARN_ON(!ieee80211_set_channel_type(local, sdata,
-						    rx_channel_type));
-	}
+	/* This can change during the lifetime of the BSS */
+	if (!(ht_oper->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
+		channel_type = NL80211_CHAN_HT20;
 
-	if (beacon_htcap_ie && (prev_chantype != rx_channel_type)) {
-		/*
-		 * Whenever the AP announces the HT mode change that can be
-		 * 40MHz intolerant or etc., it would be safer to stop tx
-		 * queues before doing hw config to avoid buffer overflow.
-		 */
-		ieee80211_stop_queues_by_reason(&sdata->local->hw,
+	if (!reconfig || (sdata->u.mgd.tx_chantype != channel_type)) {
+		if (reconfig) {
+			/*
+			 * Whenever the AP announces the HT mode changed
+			 * (e.g. 40 MHz intolerant) stop queues to avoid
+			 * sending out frames while the rate control is
+			 * reconfiguring.
+			 */
+			ieee80211_stop_queues_by_reason(&sdata->local->hw,
 				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
 
-		/* flush out all packets */
-		synchronize_net();
+			/* flush out all packets */
+			synchronize_net();
 
-		drv_flush(local, false);
-	}
-
-	/* channel_type change automatically detected */
-	ieee80211_hw_config(local, 0);
+			drv_flush(local, false);
+		}
 
-	if (prev_chantype != tx_channel_type) {
 		rcu_read_lock();
 		sta = sta_info_get(sdata, bssid);
 		if (sta)
 			rate_control_rate_update(local, sband, sta,
 						 IEEE80211_RC_HT_CHANGED,
-						 tx_channel_type);
+						 channel_type);
 		rcu_read_unlock();
 
-		if (beacon_htcap_ie)
+		sdata->u.mgd.tx_chantype = channel_type;
+
+		if (reconfig)
 			ieee80211_wake_queues_by_reason(&sdata->local->hw,
 				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
 	}
@@ -281,12 +229,9 @@ static u32 ieee80211_enable_ht(struct ie
 	ht_opmode = le16_to_cpu(ht_oper->operation_mode);
 
 	/* if bss configuration changed store the new one */
-	if (sdata->ht_opmode_valid != enable_ht ||
-	    sdata->vif.bss_conf.ht_operation_mode != ht_opmode ||
-	    prev_chantype != rx_channel_type) {
+	if (!reconfig || (sdata->vif.bss_conf.ht_operation_mode != ht_opmode)) {
 		changed |= BSS_CHANGED_HT;
 		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
-		sdata->ht_opmode_valid = enable_ht;
 	}
 
 	return changed;
@@ -349,6 +294,16 @@ static void ieee80211_add_ht_ie(struct i
 		break;
 	}
 
+	/*
+	 * If 40 MHz was disabled associate as though we weren't
+	 * capable of 40 MHz -- some broken APs will never fall
+	 * back to trying to transmit in 20 MHz.
+	 */
+	if (sdata->u.mgd.flags & IEEE80211_STA_DISABLE_40MHZ) {
+		cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+		cap &= ~IEEE80211_HT_CAP_SGI_40;
+	}
+
 	/* set SM PS mode properly */
 	cap &= ~IEEE80211_HT_CAP_SM_PS;
 	switch (smps) {
@@ -1426,7 +1381,6 @@ static void ieee80211_set_disassoc(struc
 	sdata->vif.bss_conf.assoc = false;
 
 	/* on the next assoc, re-program HT parameters */
-	sdata->ht_opmode_valid = false;
 	memset(&ifmgd->ht_capa, 0, sizeof(ifmgd->ht_capa));
 	memset(&ifmgd->ht_capa_mask, 0, sizeof(ifmgd->ht_capa_mask));
 
@@ -1991,7 +1945,6 @@ static bool ieee80211_assoc_success(stru
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 	u32 changed = 0;
 	int err;
-	u16 ap_ht_cap_flags;
 
 	/* AssocResp and ReassocResp have identical structure */
 
@@ -2042,8 +1995,6 @@ static bool ieee80211_assoc_success(stru
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
-	ap_ht_cap_flags = sta->sta.ht_cap.cap;
-
 	rate_control_rate_init(sta);
 
 	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
@@ -2085,9 +2036,8 @@ static bool ieee80211_assoc_success(stru
 
 	if (elems.ht_operation && elems.wmm_param &&
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
-		changed |= ieee80211_enable_ht(sdata, elems.ht_operation,
-					       cbss->bssid, ap_ht_cap_flags,
-					       false);
+		changed |= ieee80211_config_ht_tx(sdata, elems.ht_operation,
+						  cbss->bssid, false);
 
 	/* set AID and assoc capability,
 	 * ieee80211_set_associated() will tell the driver */
@@ -2497,29 +2447,12 @@ static void ieee80211_rx_mgmt_beacon(str
 
 	if (elems.ht_cap_elem && elems.ht_operation && elems.wmm_param &&
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N)) {
-		struct sta_info *sta;
 		struct ieee80211_supported_band *sband;
-		u16 ap_ht_cap_flags;
-
-		rcu_read_lock();
-
-		sta = sta_info_get(sdata, bssid);
-		if (WARN_ON(!sta)) {
-			rcu_read_unlock();
-			return;
-		}
 
 		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
-				elems.ht_cap_elem, &sta->sta.ht_cap);
-
-		ap_ht_cap_flags = sta->sta.ht_cap.cap;
-
-		rcu_read_unlock();
-
-		changed |= ieee80211_enable_ht(sdata, elems.ht_operation,
-					       bssid, ap_ht_cap_flags, true);
+		changed |= ieee80211_config_ht_tx(sdata, elems.ht_operation,
+						  bssid, true);
 	}
 
 	/* Note: country IE parsing is done for us by cfg80211 */
@@ -3049,6 +2982,11 @@ static int ieee80211_prep_connection(str
 	struct sta_info *sta;
 	bool have_sta = false;
 	int err;
+	int ht_cfreq;
+	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
+	const u8 *ht_oper_ie;
+	const struct ieee80211_ht_operation *ht_oper = NULL;
+	struct ieee80211_supported_band *sband;
 
 	if (WARN_ON(!ifmgd->auth_data && !ifmgd->assoc_data))
 		return -EINVAL;
@@ -3070,17 +3008,76 @@ static int ieee80211_prep_connection(str
 	mutex_unlock(&local->mtx);
 
 	/* switch to the right channel */
+	sband = local->hw.wiphy->bands[cbss->channel->band];
+
+	ifmgd->flags &= ~IEEE80211_STA_DISABLE_40MHZ;
+
+	if (sband->ht_cap.ht_supported) {
+		ht_oper_ie = cfg80211_find_ie(WLAN_EID_HT_OPERATION,
+					      cbss->information_elements,
+					      cbss->len_information_elements);
+		if (ht_oper_ie && ht_oper_ie[1] >= sizeof(*ht_oper))
+			ht_oper = (void *)(ht_oper_ie + 2);
+	}
+
+	if (ht_oper) {
+		ht_cfreq = ieee80211_channel_to_frequency(ht_oper->primary_chan,
+							  cbss->channel->band);
+		/* check that channel matches the right operating channel */
+		if (cbss->channel->center_freq != ht_cfreq) {
+			/*
+			 * It's possible that some APs are confused here;
+			 * Netgear WNDR3700 sometimes reports 4 higher than
+			 * the actual channel in association responses, but
+			 * since we look at probe response/beacon data here
+			 * it should be OK.
+			 */
+			printk(KERN_DEBUG
+			       "%s: Wrong control channel: center-freq: %d"
+			       " ht-cfreq: %d ht->primary_chan: %d"
+			       " band: %d. Disabling HT.\n",
+			       sdata->name, cbss->channel->center_freq,
+			       ht_cfreq, ht_oper->primary_chan,
+			       cbss->channel->band);
+			ht_oper = NULL;
+		}
+	}
+
+	if (ht_oper) {
+		channel_type = NL80211_CHAN_HT20;
+
+		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
+			switch (ht_oper->ht_param &
+					IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+				channel_type = NL80211_CHAN_HT40PLUS;
+				break;
+			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+				channel_type = NL80211_CHAN_HT40MINUS;
+				break;
+			}
+		}
+	}
+
+	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
+		/* can only fail due to HT40+/- mismatch */
+		channel_type = NL80211_CHAN_HT20;
+		printk(KERN_DEBUG
+		       "%s: disabling 40 MHz due to multi-vif mismatch\n",
+		       sdata->name);
+		ifmgd->flags |= IEEE80211_STA_DISABLE_40MHZ;
+		WARN_ON(!ieee80211_set_channel_type(local, sdata,
+						    channel_type));
+	}
+
 	local->oper_channel = cbss->channel;
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	ieee80211_hw_config(local, 0);
 
 	if (!have_sta) {
-		struct ieee80211_supported_band *sband;
 		u32 rates = 0, basic_rates = 0;
 		bool have_higher_than_11mbit;
 		int min_rate = INT_MAX, min_rate_index = -1;
 
-		sband = sdata->local->hw.wiphy->bands[cbss->channel->band];
-
 		ieee80211_get_rates(sband, bss->supp_rates,
 				    bss->supp_rates_len,
 				    &rates, &basic_rates,
--- a/net/mac80211/ht.c	2012-03-15 15:32:26.000000000 +0100
+++ b/net/mac80211/ht.c	2012-03-15 15:50:36.000000000 +0100
@@ -19,15 +19,6 @@
 #include "ieee80211_i.h"
 #include "rate.h"
 
-bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata)
-{
-	const __le16 flg = cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40);
-	if ((sdata->u.mgd.ht_capa_mask.cap_info & flg) &&
-	    !(sdata->u.mgd.ht_capa.cap_info & flg))
-		return true;
-	return false;
-}
-
 static void __check_htcap_disable(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_sta_ht_cap *ht_cap,
 				  u16 flag)
--- a/Documentation/networking/mac80211-auth-assoc-deauth.txt	2012-03-15 15:33:29.000000000 +0100
+++ b/Documentation/networking/mac80211-auth-assoc-deauth.txt	2012-03-15 16:29:02.000000000 +0100
@@ -23,7 +23,7 @@ BA session stop & deauth/disassoc frames
 end note
 end
 
-mac80211->driver: config(channel, non-HT)
+mac80211->driver: config(channel, channel type)
 mac80211->driver: bss_info_changed(set BSSID, basic rate bitmap)
 mac80211->driver: sta_state(AP, exists)
 
@@ -51,7 +51,7 @@ note over mac80211,driver: cleanup like
 end
 
 alt not previously authenticated (FT)
-mac80211->driver: config(channel, non-HT)
+mac80211->driver: config(channel, channel type)
 mac80211->driver: bss_info_changed(set BSSID, basic rate bitmap)
 mac80211->driver: sta_state(AP, exists)
 mac80211->driver: sta_state(AP, authenticated)
@@ -67,10 +67,6 @@ end
 
 mac80211->driver: set up QoS parameters
 
-alt is HT channel
-mac80211->driver: config(channel, HT params)
-end
-
 mac80211->driver: bss_info_changed(QoS, HT, associated with AID)
 mac80211->userspace: associated
 
@@ -95,5 +91,5 @@ mac80211->driver: sta_state(AP,exists)
 mac80211->driver: sta_state(AP,not-exists)
 mac80211->driver: turn off powersave
 mac80211->driver: bss_info_changed(clear BSSID, not associated, no QoS, ...)
-mac80211->driver: config(non-HT channel type)
+mac80211->driver: config(channel type to non-HT)
 mac80211->userspace: disconnected


