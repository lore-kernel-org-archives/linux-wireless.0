Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759132Ab0EEN2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 09:28:30 -0400
Subject: [PATCH] mac80211: improve HT channel handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 15:28:27 +0200
Message-ID: <1273066107.3728.18.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, when one interface switches HT mode,
all others will follow along. This is clearly
undesirable, since the new one might switch to
no-HT while another one is operating in HT.

Address this issue by keeping track of the HT
mode per interface, and allowing only changes
that are compatible, i.e. switching into HT40+
is not possible when another interface is in
HT40-, in that case the second one needs to
fall back to HT20.

Also, to allow drivers to know what's going on,
store the per-interface HT mode (channel type)
in the virtual interface's bss_conf.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |   19 ++++-----
 include/net/mac80211.h                |    4 +
 net/mac80211/cfg.c                    |   23 ++++++++---
 net/mac80211/chan.c                   |   70 ++++++++++++++++++++++++++++++++++
 net/mac80211/ibss.c                   |    5 +-
 net/mac80211/ieee80211_i.h            |    5 +-
 net/mac80211/main.c                   |    2 
 net/mac80211/mlme.c                   |   44 +++++++++++----------
 8 files changed, 132 insertions(+), 40 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-05-05 15:21:53.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-05-05 15:23:27.000000000 +0200
@@ -191,6 +191,9 @@ enum ieee80211_bss_change {
  *	the current band.
  * @bssid: The BSSID for this BSS
  * @enable_beacon: whether beaconing should be enabled or not
+ * @channel_type: Channel type for this BSS -- the hardware might be
+ *	configured for HT40+ while this BSS only uses no-HT, for
+ *	example.
  * @ht_operation_mode: HT operation mode (like in &struct ieee80211_ht_info).
  *	This field is only valid when the channel type is one of the HT types.
  * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero value
@@ -215,6 +218,7 @@ struct ieee80211_bss_conf {
 	u16 ht_operation_mode;
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
+	enum nl80211_channel_type channel_type;
 };
 
 /**
--- wireless-testing.orig/net/mac80211/cfg.c	2010-05-05 15:21:53.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-05-05 15:23:27.000000000 +0200
@@ -1167,23 +1167,34 @@ static int ieee80211_set_channel(struct
 				 enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = NULL;
+
+	if (netdev)
+		sdata = IEEE80211_DEV_TO_SUB_IF(netdev);
 
 	switch (ieee80211_get_channel_mode(local, NULL)) {
 	case CHAN_MODE_HOPPING:
 		return -EBUSY;
 	case CHAN_MODE_FIXED:
-		if (local->oper_channel == chan &&
-		    local->oper_channel_type == channel_type)
+		if (local->oper_channel != chan)
+			return -EBUSY;
+		if (!sdata && local->_oper_channel_type == channel_type)
 			return 0;
-		return -EBUSY;
+		break;
 	case CHAN_MODE_UNDEFINED:
 		break;
 	}
 
 	local->oper_channel = chan;
-	local->oper_channel_type = channel_type;
 
-	return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	if (!ieee80211_set_channel_type(local, sdata, channel_type))
+		return -EBUSY;
+
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	if (sdata && sdata->vif.type != NL80211_IFTYPE_MONITOR)
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_HT);
+
+	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -1407,7 +1418,7 @@ int __ieee80211_request_smps(struct ieee
 	 * association, there's no need to send an action frame.
 	 */
 	if (!sdata->u.mgd.associated ||
-	    sdata->local->oper_channel_type == NL80211_CHAN_NO_HT) {
+	    sdata->vif.bss_conf.channel_type == NL80211_CHAN_NO_HT) {
 		mutex_lock(&sdata->local->iflist_mtx);
 		ieee80211_recalc_smps(sdata->local, sdata);
 		mutex_unlock(&sdata->local->iflist_mtx);
--- wireless-testing.orig/net/mac80211/chan.c	2010-05-05 15:21:53.000000000 +0200
+++ wireless-testing/net/mac80211/chan.c	2010-05-05 15:23:27.000000000 +0200
@@ -2,6 +2,7 @@
  * mac80211 - channel management
  */
 
+#include <linux/nl80211.h>
 #include "ieee80211_i.h"
 
 enum ieee80211_chan_mode
@@ -55,3 +56,72 @@ ieee80211_get_channel_mode(struct ieee80
 
 	return mode;
 }
+
+bool ieee80211_set_channel_type(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata,
+				enum nl80211_channel_type chantype)
+{
+	struct ieee80211_sub_if_data *tmp;
+	enum nl80211_channel_type superchan = NL80211_CHAN_NO_HT;
+	bool result;
+
+	mutex_lock(&local->iflist_mtx);
+
+	list_for_each_entry(tmp, &local->interfaces, list) {
+		if (tmp == sdata)
+			continue;
+
+		if (!ieee80211_sdata_running(tmp))
+			continue;
+
+		switch (tmp->vif.bss_conf.channel_type) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
+			superchan = tmp->vif.bss_conf.channel_type;
+			break;
+		case NL80211_CHAN_HT40PLUS:
+			WARN_ON(superchan == NL80211_CHAN_HT40MINUS);
+			superchan = NL80211_CHAN_HT40PLUS;
+			break;
+		case NL80211_CHAN_HT40MINUS:
+			WARN_ON(superchan == NL80211_CHAN_HT40PLUS);
+			superchan = NL80211_CHAN_HT40MINUS;
+			break;
+		}
+	}
+
+	switch (superchan) {
+	case NL80211_CHAN_NO_HT:
+	case NL80211_CHAN_HT20:
+		/*
+		 * allow any change that doesn't go to no-HT
+		 * (if it already is no-HT no change is needed)
+		 */
+		if (chantype == NL80211_CHAN_NO_HT)
+			break;
+		superchan = chantype;
+		break;
+	case NL80211_CHAN_HT40PLUS:
+	case NL80211_CHAN_HT40MINUS:
+		/* allow smaller bandwidth and same */
+		if (chantype == NL80211_CHAN_NO_HT)
+			break;
+		if (chantype == NL80211_CHAN_HT20)
+			break;
+		if (superchan == chantype)
+			break;
+		result = false;
+		goto out;
+	}
+
+	local->_oper_channel_type = superchan;
+
+	if (sdata)
+		sdata->vif.bss_conf.channel_type = chantype;
+
+	result = true;
+ out:
+	mutex_unlock(&local->iflist_mtx);
+
+	return result;
+}
--- wireless-testing.orig/net/mac80211/ibss.c	2010-05-05 15:21:54.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2010-05-05 15:23:27.000000000 +0200
@@ -103,7 +103,7 @@ static void __ieee80211_sta_join_ibss(st
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
 	local->oper_channel = chan;
-	local->oper_channel_type = NL80211_CHAN_NO_HT;
+	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	sband = local->hw.wiphy->bands[chan->band];
@@ -911,7 +911,8 @@ int ieee80211_ibss_join(struct ieee80211
 	/* fix ourselves to that channel now already */
 	if (params->channel_fixed) {
 		sdata->local->oper_channel = params->channel;
-		sdata->local->oper_channel_type = NL80211_CHAN_NO_HT;
+		WARN_ON(!ieee80211_set_channel_type(sdata->local, sdata,
+						    NL80211_CHAN_NO_HT));
 	}
 
 	if (params->ie) {
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-05-05 15:21:53.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-05-05 15:23:27.000000000 +0200
@@ -768,7 +768,7 @@ struct ieee80211_local {
 	enum mac80211_scan_state next_scan_state;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
-	enum nl80211_channel_type oper_channel_type;
+	enum nl80211_channel_type _oper_channel_type;
 	struct ieee80211_channel *oper_channel, *csa_channel;
 
 	/* Temporary remain-on-channel for off-channel operations */
@@ -1239,6 +1239,9 @@ enum ieee80211_chan_mode {
 enum ieee80211_chan_mode
 ieee80211_get_channel_mode(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *ignore);
+bool ieee80211_set_channel_type(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata,
+				enum nl80211_channel_type chantype);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
--- wireless-testing.orig/net/mac80211/main.c	2010-05-05 15:21:53.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-05-05 15:23:27.000000000 +0200
@@ -111,7 +111,7 @@ int ieee80211_hw_config(struct ieee80211
 		channel_type = local->tmp_channel_type;
 	} else {
 		chan = local->oper_channel;
-		channel_type = local->oper_channel_type;
+		channel_type = local->_oper_channel_type;
 	}
 
 	if (chan != local->hw.conf.channel ||
--- wireless-testing.orig/net/mac80211/mlme.c	2010-05-05 15:21:54.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-05-05 15:23:27.000000000 +0200
@@ -137,11 +137,14 @@ static u32 ieee80211_enable_ht(struct ie
 	struct sta_info *sta;
 	u32 changed = 0;
 	u16 ht_opmode;
-	bool enable_ht = true, ht_changed;
+	bool enable_ht = true;
+	enum nl80211_channel_type prev_chantype;
 	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
+	prev_chantype = sdata->vif.bss_conf.channel_type;
+
 	/* HT is not supported */
 	if (!sband->ht_cap.ht_supported)
 		enable_ht = false;
@@ -172,38 +175,37 @@ static u32 ieee80211_enable_ht(struct ie
 		}
 	}
 
-	ht_changed = conf_is_ht(&local->hw.conf) != enable_ht ||
-		     channel_type != local->hw.conf.channel_type;
-
 	if (local->tmp_channel)
 		local->tmp_channel_type = channel_type;
-	local->oper_channel_type = channel_type;
 
-	if (ht_changed) {
-                /* channel_type change automatically detected */
-		ieee80211_hw_config(local, 0);
+	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
+		/* can only fail due to HT40+/- mismatch */
+		channel_type = NL80211_CHAN_HT20;
+		WARN_ON(!ieee80211_set_channel_type(local, sdata, channel_type));
+	}
 
+	/* channel_type change automatically detected */
+	ieee80211_hw_config(local, 0);
+
+	if (prev_chantype != channel_type) {
 		rcu_read_lock();
 		sta = sta_info_get(sdata, bssid);
 		if (sta)
 			rate_control_rate_update(local, sband, sta,
 						 IEEE80211_RC_HT_CHANGED,
-						 local->oper_channel_type);
+						 channel_type);
 		rcu_read_unlock();
-        }
-
-	/* disable HT */
-	if (!enable_ht)
-		return 0;
+	}
 
 	ht_opmode = le16_to_cpu(hti->operation_mode);
 
 	/* if bss configuration changed store the new one */
-	if (!sdata->ht_opmode_valid ||
-	    sdata->vif.bss_conf.ht_operation_mode != ht_opmode) {
+	if (sdata->ht_opmode_valid != enable_ht ||
+	    sdata->vif.bss_conf.ht_operation_mode != ht_opmode ||
+	    prev_chantype != channel_type) {
 		changed |= BSS_CHANGED_HT;
 		sdata->vif.bss_conf.ht_operation_mode = ht_opmode;
-		sdata->ht_opmode_valid = true;
+		sdata->ht_opmode_valid = enable_ht;
 	}
 
 	return changed;
@@ -866,7 +868,7 @@ static void ieee80211_set_disassoc(struc
 	ieee80211_set_wmm_default(sdata);
 
 	/* channel(_type) changes are handled by ieee80211_hw_config */
-	local->oper_channel_type = NL80211_CHAN_NO_HT;
+	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
 
 	/* on the next assoc, re-program HT parameters */
 	sdata->ht_opmode_valid = false;
@@ -883,8 +885,8 @@ static void ieee80211_set_disassoc(struc
 
 	ieee80211_hw_config(local, config_changed);
 
-	/* And the BSSID changed -- not very interesting here */
-	changed |= BSS_CHANGED_BSSID;
+	/* The BSSID (not really interesting) and HT changed */
+	changed |= BSS_CHANGED_BSSID | BSS_CHANGED_HT;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	if (remove_sta)
@@ -2266,7 +2268,7 @@ int ieee80211_mgd_action(struct ieee8021
 	if ((chan != local->tmp_channel ||
 	     channel_type != local->tmp_channel_type) &&
 	    (chan != local->oper_channel ||
-	     channel_type != local->oper_channel_type))
+	     channel_type != local->_oper_channel_type))
 		return -EBUSY;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + len);
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2010-05-05 15:21:54.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2010-05-05 15:24:09.000000000 +0200
@@ -652,17 +652,17 @@ static void mac80211_hwsim_beacon(unsign
 	add_timer(&data->beacon_timer);
 }
 
+static const char *hwsim_chantypes[] = {
+	[NL80211_CHAN_NO_HT] = "noht",
+	[NL80211_CHAN_HT20] = "ht20",
+	[NL80211_CHAN_HT40MINUS] = "ht40-",
+	[NL80211_CHAN_HT40PLUS] = "ht40+",
+};
 
 static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
-	static const char *chantypes[4] = {
-		[NL80211_CHAN_NO_HT] = "noht",
-		[NL80211_CHAN_HT20] = "ht20",
-		[NL80211_CHAN_HT40MINUS] = "ht40-",
-		[NL80211_CHAN_HT40PLUS] = "ht40+",
-	};
 	static const char *smps_modes[IEEE80211_SMPS_NUM_MODES] = {
 		[IEEE80211_SMPS_AUTOMATIC] = "auto",
 		[IEEE80211_SMPS_OFF] = "off",
@@ -673,7 +673,7 @@ static int mac80211_hwsim_config(struct
 	printk(KERN_DEBUG "%s:%s (freq=%d/%s idle=%d ps=%d smps=%s)\n",
 	       wiphy_name(hw->wiphy), __func__,
 	       conf->channel->center_freq,
-	       chantypes[conf->channel_type],
+	       hwsim_chantypes[conf->channel_type],
 	       !!(conf->flags & IEEE80211_CONF_IDLE),
 	       !!(conf->flags & IEEE80211_CONF_PS),
 	       smps_modes[conf->smps_mode]);
@@ -761,9 +761,10 @@ static void mac80211_hwsim_bss_info_chan
 	}
 
 	if (changed & BSS_CHANGED_HT) {
-		printk(KERN_DEBUG "  %s: HT: op_mode=0x%x\n",
+		printk(KERN_DEBUG "  %s: HT: op_mode=0x%x, chantype=%s\n",
 		       wiphy_name(hw->wiphy),
-		       info->ht_operation_mode);
+		       info->ht_operation_mode,
+		       hwsim_chantypes[info->channel_type]);
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {


