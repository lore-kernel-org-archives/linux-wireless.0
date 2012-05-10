Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:54317 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115Ab2EJGpJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 02:45:09 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/7] mac80211: split channel logic from hw_config
Date: Thu, 10 May 2012 08:44:37 +0200
Message-ID: <1336632282-2278-3-git-send-email-michal.kazior@tieto.com> (sfid-20120510_084530_679024_9144D9EC)
In-Reply-To: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extracts two functions from hw_config:

 * ieee80211_recalc_channel
 * ieee80211_recalc_power_level

Both are per-sdata. They either supplement or
substitute ieee80211_hw_config in the code.

Prepares channel switching logic for future
multi-channel operation.

Change-Id: Ibfe2965a6967c7f34c16b4111ea9ab2fceabaf22
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c         |   46 ++++++++++++++++++---------------
 net/mac80211/ibss.c        |    2 +-
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/iface.c       |    8 ++++-
 net/mac80211/main.c        |   61 ++++++++++++++++++++++++++-----------------
 net/mac80211/mlme.c        |    7 +++--
 net/mac80211/scan.c        |   18 ++++--------
 net/mac80211/util.c        |    6 ++++
 net/mac80211/work.c        |    6 +++-
 9 files changed, 91 insertions(+), 65 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 510a745..9fa5044 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1519,7 +1519,7 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 	/* Update driver if changes were actually made. */
 	if ((old_oper != local->oper_channel) ||
 	    (old_oper_type != local->_oper_channel_type))
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+		ieee80211_recalc_channel(sdata);
 
 	if (sdata && sdata->vif.type != NL80211_IFTYPE_MONITOR &&
 	    old_vif_oper_type != sdata->vif.bss_conf.channel_type)
@@ -1708,28 +1708,32 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_channel *chan = local->hw.conf.channel;
-	u32 changes = 0;
+	struct ieee80211_sub_if_data *sdata;
 
-	switch (type) {
-	case NL80211_TX_POWER_AUTOMATIC:
-		local->user_power_level = -1;
-		break;
-	case NL80211_TX_POWER_LIMITED:
-		if (mbm < 0 || (mbm % 100))
-			return -EOPNOTSUPP;
-		local->user_power_level = MBM_TO_DBM(mbm);
-		break;
-	case NL80211_TX_POWER_FIXED:
-		if (mbm < 0 || (mbm % 100))
-			return -EOPNOTSUPP;
-		/* TODO: move to cfg80211 when it knows the channel */
-		if (MBM_TO_DBM(mbm) > chan->max_power)
-			return -EINVAL;
-		local->user_power_level = MBM_TO_DBM(mbm);
-		break;
-	}
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		switch (type) {
+		case NL80211_TX_POWER_AUTOMATIC:
+			local->user_power_level = -1;
+			break;
+		case NL80211_TX_POWER_LIMITED:
+			if (mbm < 0 || (mbm % 100))
+				return -EOPNOTSUPP;
+			local->user_power_level = MBM_TO_DBM(mbm);
+			break;
+		case NL80211_TX_POWER_FIXED:
+			if (mbm < 0 || (mbm % 100))
+				return -EOPNOTSUPP;
+			/* TODO: move to cfg80211 when it knows the channel */
+			if (MBM_TO_DBM(mbm) > chan->max_power)
+				return -EINVAL;
+			local->user_power_level = MBM_TO_DBM(mbm);
+			break;
+		}
 
-	ieee80211_hw_config(local, changes);
+		ieee80211_recalc_power_level(sdata);
+	}
+	mutex_unlock(&local->iflist_mtx);
 
 	return 0;
 }
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 49a2079..718ee49 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -91,7 +91,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		WARN_ON(!ieee80211_set_channel_type(local, sdata,
 						    NL80211_CHAN_HT20));
 	}
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	ieee80211_recalc_channel(sdata);
 
 	sband = local->hw.wiphy->bands[chan->band];
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c109960..122717f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1201,6 +1201,8 @@ static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
 }
 
 
+void ieee80211_recalc_power_level(struct ieee80211_sub_if_data *sdata);
+void ieee80211_recalc_channel(struct ieee80211_sub_if_data *sdata);
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed);
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6e85fae..cefdf73 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -467,8 +467,10 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 	if (coming_up)
 		local->open_count++;
 
-	if (hw_reconf_flags)
+	if (hw_reconf_flags) {
 		ieee80211_hw_config(local, hw_reconf_flags);
+		ieee80211_recalc_channel(sdata);
+	}
 
 	ieee80211_recalc_ps(local, -1);
 
@@ -685,8 +687,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	ieee80211_set_channel_type(local, NULL, NL80211_CHAN_NO_HT);
 
 	/* do after stop to avoid reconfiguring when we stop anyway */
-	if (hw_reconf_flags || (orig_ct != local->_oper_channel_type))
+	if (hw_reconf_flags || (orig_ct != local->_oper_channel_type)) {
 		ieee80211_hw_config(local, hw_reconf_flags);
+		ieee80211_recalc_channel(sdata);
+	}
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b70f7f0..01c0e8b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -93,16 +93,38 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
 	ieee80211_configure_filter(local);
 }
 
-int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
+void ieee80211_recalc_power_level(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_channel *chan;
-	int ret = 0;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel *chan = local->hw.conf.channel;
 	int power;
+
+	if (test_bit(SCAN_SW_SCANNING, &local->scanning) ||
+	    test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning) ||
+	    test_bit(SCAN_HW_SCANNING, &local->scanning))
+		power = chan->max_power;
+	else
+		power = local->power_constr_level ?
+			min(chan->max_power,
+				(chan->max_reg_power  - local->power_constr_level)) :
+			chan->max_power;
+
+	if (local->user_power_level >= 0)
+		power = min(power, local->user_power_level);
+
+	if (local->hw.conf.power_level != power) {
+		local->hw.conf.power_level = power;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_POWER);
+	}
+}
+
+void ieee80211_recalc_channel(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel *chan;
 	enum nl80211_channel_type channel_type;
 	u32 offchannel_flag;
 
-	might_sleep();
-
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 	if (local->scan_channel) {
 		chan = local->scan_channel;
@@ -133,8 +155,17 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 	    channel_type != local->hw.conf.channel_type) {
 		local->hw.conf.channel = chan;
 		local->hw.conf.channel_type = channel_type;
-		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
+
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+		ieee80211_recalc_power_level(sdata);
 	}
+}
+
+int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
+{
+	int ret = 0;
+
+	might_sleep();
 
 	if (!conf_is_ht(&local->hw.conf)) {
 		/*
@@ -148,24 +179,6 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 		changed |= IEEE80211_CONF_CHANGE_SMPS;
 	}
 
-	if (test_bit(SCAN_SW_SCANNING, &local->scanning) ||
-	    test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning) ||
-	    test_bit(SCAN_HW_SCANNING, &local->scanning))
-		power = chan->max_power;
-	else
-		power = local->power_constr_level ?
-			min(chan->max_power,
-				(chan->max_reg_power  - local->power_constr_level)) :
-			chan->max_power;
-
-	if (local->user_power_level >= 0)
-		power = min(power, local->user_power_level);
-
-	if (local->hw.conf.power_level != power) {
-		changed |= IEEE80211_CONF_CHANGE_POWER;
-		local->hw.conf.power_level = power;
-	}
-
 	if (changed && local->open_count) {
 		ret = drv_config(local, changed);
 		/*
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c8836fa..f75947b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -681,8 +681,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	sdata->local->oper_channel = sdata->local->csa_channel;
 	if (!sdata->local->ops->channel_switch) {
 		/* call "hw_config" only if doing sw channel switch */
-		ieee80211_hw_config(sdata->local,
-			IEEE80211_CONF_CHANGE_CHANNEL);
+		ieee80211_recalc_channel(sdata);
 	} else {
 		/* update the device channel directly */
 		sdata->local->hw.conf.channel = sdata->local->oper_channel;
@@ -815,7 +814,7 @@ static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 	if ((*pwr_constr_elem <= conf->channel->max_reg_power) &&
 	    (*pwr_constr_elem != sdata->local->power_constr_level)) {
 		sdata->local->power_constr_level = *pwr_constr_elem;
-		ieee80211_hw_config(sdata->local, 0);
+		ieee80211_recalc_power_level(sdata);
 	}
 }
 
@@ -1417,6 +1416,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	/* channel(_type) changes are handled by ieee80211_hw_config */
 	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
 	ieee80211_hw_config(local, 0);
+	ieee80211_recalc_channel(sdata);
 
 	/* disassociated - set to defaults now */
 	ieee80211_set_wmm_default(sdata, false);
@@ -3111,6 +3111,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 
 	local->oper_channel = cbss->channel;
 	ieee80211_hw_config(local, 0);
+	ieee80211_recalc_channel(sdata);
 
 	if (!have_sta) {
 		u32 rates = 0, basic_rates = 0;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index d8c0a34..71d642e 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -291,6 +291,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 				       bool was_hw_scan)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 
 	lockdep_assert_held(&local->mtx);
 
@@ -324,7 +325,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	local->scan_channel = NULL;
 
 	/* Set power back to normal operating levels. */
-	ieee80211_hw_config(local, 0);
+	ieee80211_recalc_power_level(sdata);
 
 	if (!was_hw_scan) {
 		ieee80211_configure_filter(local);
@@ -379,7 +380,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	ieee80211_configure_filter(local);
 
 	/* We need to set power level at maximum rate for scanning. */
-	ieee80211_hw_config(local, 0);
+	ieee80211_recalc_power_level(local->scan_sdata);
 
 	ieee80211_queue_delayed_work(&local->hw,
 				     &local->scan_work, 0);
@@ -511,7 +512,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		ieee80211_configure_filter(local); /* accept probe-responses */
 
 		/* We need to ensure power level is at max for scanning. */
-		ieee80211_hw_config(local, 0);
+		ieee80211_recalc_power_level(sdata);
 
 		if ((req->channels[0]->flags &
 		     IEEE80211_CHAN_PASSIVE_SCAN) ||
@@ -652,18 +653,11 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 
 	local->scan_channel = chan;
 
-	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
-		skip = 1;
+	ieee80211_recalc_channel(local->scan_sdata);
 
 	/* advance state machine to next channel/band */
 	local->scan_channel_idx++;
 
-	if (skip) {
-		/* if we skip this channel return to the decision state */
-		local->next_scan_state = SCAN_DECISION;
-		return;
-	}
-
 	/*
 	 * Probe delay is used to update the NAV, cf. 11.1.3.2.2
 	 * (which unfortunately doesn't say _why_ step a) is done,
@@ -691,7 +685,7 @@ static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
 {
 	/* switch back to the operating channel */
 	local->scan_channel = NULL;
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	ieee80211_recalc_channel(local->scan_sdata);
 
 	/*
 	 * Re-enable vifs and beaconing.  Leave PS
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9d255a2..c0a1c0d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1295,6 +1295,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	/* reconfigure hardware */
 	ieee80211_hw_config(local, ~0);
 
+	list_for_each_entry(sdata, &local->interfaces, list)
+		ieee80211_recalc_channel(sdata);
+
 	ieee80211_configure_filter(local);
 
 	/* Finally also reconfigure all the BSS information */
@@ -1528,6 +1531,9 @@ void ieee80211_recalc_smps(struct ieee80211_local *local)
 	local->smps_mode = smps_mode;
 	/* changed flag is auto-detected for this */
 	ieee80211_hw_config(local, 0);
+
+	list_for_each_entry(sdata, &local->interfaces, list)
+		ieee80211_recalc_channel(sdata);
 }
 
 static bool ieee80211_id_in_list(const u8 *ids, int n_ids, u8 id)
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 2a0b252..59f01ff 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -156,7 +156,7 @@ static void ieee80211_work_work(struct work_struct *work)
 			local->tmp_channel = wk->chan;
 			local->tmp_channel_type = wk->chan_type;
 
-			ieee80211_hw_config(local, 0);
+			ieee80211_recalc_channel(wk->sdata);
 
 			started = true;
 			wk->timeout = jiffies;
@@ -220,9 +220,11 @@ static void ieee80211_work_work(struct work_struct *work)
 	}
 
 	if (!remain_off_channel && local->tmp_channel) {
+		struct ieee80211_sub_if_data *sdata = local->tmp_sdata;
+
 		local->tmp_sdata = NULL;
 		local->tmp_channel = NULL;
-		ieee80211_hw_config(local, 0);
+		ieee80211_recalc_channel(sdata);
 
 		ieee80211_offchannel_return(local, true);
 
-- 
1.7.0.4

