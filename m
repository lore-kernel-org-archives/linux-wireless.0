Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60158 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab2CHODW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 09:03:22 -0500
Message-Id: <20120308140227.427040320@sipsolutions.net> (sfid-20120308_150327_513084_04A3AAE0)
Date: Thu, 08 Mar 2012 15:02:08 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] mac80211: set basic rates earlier
References: <20120308140202.751490800@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The authentication and association handshake
already happens in the context of the new BSS,
and the basic rates are needed at least for
the ACK response frame to the authentication
or association response frames. Therefore the
basic rates should already be configured into
the driver when those frames are sent.

Change the logic to set up the basic rates in
the connection preparation that happens for
authentication and association (if needed).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   97 ++++++++++++++++++++++++++--------------------------
 1 file changed, 49 insertions(+), 48 deletions(-)

--- a/net/mac80211/mlme.c	2012-03-08 14:26:34.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-08 14:34:31.000000000 +0100
@@ -1344,12 +1344,6 @@ static void ieee80211_set_associated(str
 		bss_conf->dtim_period = 0;
 
 	bss_conf->assoc = 1;
-	/*
-	 * For now just always ask the driver to update the basic rateset
-	 * when we have associated, we aren't checking whether it actually
-	 * changed or not.
-	 */
-	bss_info_changed |= BSS_CHANGED_BASIC_RATES;
 
 	/* Tell the driver to monitor connection quality (if supported) */
 	if (sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI &&
@@ -2016,15 +2010,12 @@ static bool ieee80211_assoc_success(stru
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 	u8 *pos;
-	u32 rates, basic_rates;
 	u16 capab_info, aid;
 	struct ieee802_11_elems elems;
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 	u32 changed = 0;
 	int err;
-	bool have_higher_than_11mbit = false;
 	u16 ap_ht_cap_flags;
-	int min_rate = INT_MAX, min_rate_index = -1;
 
 	/* AssocResp and ReassocResp have identical structure */
 
@@ -2069,39 +2060,8 @@ static bool ieee80211_assoc_success(stru
 		return false;
 	}
 
-	rates = 0;
-	basic_rates = 0;
 	sband = local->hw.wiphy->bands[local->oper_channel->band];
 
-	ieee80211_get_rates(sband, elems.supp_rates, elems.supp_rates_len,
-			    &rates, &basic_rates, &have_higher_than_11mbit,
-			    &min_rate, &min_rate_index);
-
-	ieee80211_get_rates(sband, elems.ext_supp_rates,
-			    elems.ext_supp_rates_len, &rates, &basic_rates,
-			    &have_higher_than_11mbit,
-			    &min_rate, &min_rate_index);
-
-	/*
-	 * some buggy APs don't advertise basic_rates. use the lowest
-	 * supported rate instead.
-	 */
-	if (unlikely(!basic_rates) && min_rate_index >= 0) {
-		printk(KERN_DEBUG "%s: No basic rates in AssocResp. "
-		       "Using min supported rate instead.\n", sdata->name);
-		basic_rates = BIT(min_rate_index);
-	}
-
-	sta->sta.supp_rates[local->oper_channel->band] = rates;
-	sdata->vif.bss_conf.basic_rates = basic_rates;
-
-	/* cf. IEEE 802.11 9.2.12 */
-	if (local->oper_channel->band == IEEE80211_BAND_2GHZ &&
-	    have_higher_than_11mbit)
-		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
-	else
-		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
-
 	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
@@ -3129,10 +3089,11 @@ int ieee80211_max_network_latency(struct
 }
 
 static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
-				     struct cfg80211_bss *bss, bool assoc)
+				     struct cfg80211_bss *cbss, bool assoc)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_bss *bss = (void *)cbss->priv;
 	struct sta_info *sta;
 	bool have_sta = false;
 	int err;
@@ -3142,12 +3103,12 @@ static int ieee80211_prep_connection(str
 
 	if (assoc) {
 		rcu_read_lock();
-		have_sta = sta_info_get(sdata, bss->bssid);
+		have_sta = sta_info_get(sdata, cbss->bssid);
 		rcu_read_unlock();
 	}
 
 	if (!have_sta) {
-		sta = sta_info_alloc(sdata, bss->bssid, GFP_KERNEL);
+		sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
 		if (!sta)
 			return -ENOMEM;
 	}
@@ -3157,13 +3118,53 @@ static int ieee80211_prep_connection(str
 	mutex_unlock(&local->mtx);
 
 	/* switch to the right channel */
-	local->oper_channel = bss->channel;
+	local->oper_channel = cbss->channel;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	if (!have_sta) {
-		/* set BSSID - if STA already there this will be set too */
-		memcpy(ifmgd->bssid, bss->bssid, ETH_ALEN);
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+		struct ieee80211_supported_band *sband;
+		u32 rates = 0, basic_rates = 0;
+		bool have_higher_than_11mbit;
+		int min_rate = INT_MAX, min_rate_index = -1;
+
+		sband = sdata->local->hw.wiphy->bands[cbss->channel->band];
+
+		ieee80211_get_rates(sband, bss->supp_rates,
+				    bss->supp_rates_len,
+				    &rates, &basic_rates,
+				    &have_higher_than_11mbit,
+				    &min_rate, &min_rate_index);
+
+		/*
+		 * This used to be a workaround for basic rates missing
+		 * in the association response frame. Now that we no
+		 * longer use the basic rates from there, it probably
+		 * doesn't happen any more, but keep the workaround so
+		 * in case some *other* APs are buggy in different ways
+		 * we can connect -- with a warning.
+		 */
+		if (!basic_rates && min_rate_index >= 0) {
+			printk(KERN_DEBUG
+			       "%s: No basic rates, using min rate instead.\n",
+			       sdata->name);
+			basic_rates = BIT(min_rate_index);
+		}
+
+		sta->sta.supp_rates[cbss->channel->band] = rates;
+		sdata->vif.bss_conf.basic_rates = basic_rates;
+
+		/* cf. IEEE 802.11 9.2.12 */
+		if (local->oper_channel->band == IEEE80211_BAND_2GHZ &&
+		    have_higher_than_11mbit)
+			sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
+		else
+			sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
+
+		memcpy(ifmgd->bssid, cbss->bssid, ETH_ALEN);
+
+		/* tell driver about BSSID and basic rates */
+		ieee80211_bss_info_change_notify(sdata,
+			BSS_CHANGED_BSSID | BSS_CHANGED_BASIC_RATES);
 
 		if (assoc)
 			sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
@@ -3177,7 +3178,7 @@ static int ieee80211_prep_connection(str
 			return err;
 		}
 	} else
-		WARN_ON_ONCE(compare_ether_addr(ifmgd->bssid, bss->bssid));
+		WARN_ON_ONCE(compare_ether_addr(ifmgd->bssid, cbss->bssid));
 
 	return 0;
 }


