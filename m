Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35430 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbbFNNxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2015 09:53:52 -0400
Received: by wiga1 with SMTP id a1so53555175wig.0
        for <linux-wireless@vger.kernel.org>; Sun, 14 Jun 2015 06:53:50 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: TDLS: correctly configure SMPS state
Date: Sun, 14 Jun 2015 16:53:46 +0300
Message-Id: <1434290026-10158-1-git-send-email-arik@wizery.com> (sfid-20150614_155356_136092_E4A488AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IEEE802.11-2012 specification is vague regarding SMPS operation during
TDLS. It does not define a clear way to transition between SMPS states.

To avoid interop issues, set SMPS to off when TDLS peers are connected.
Accomplish this by extending the definition of the AUTOMATIC state. If the
driver forces a state other than OFF, disconnect all TDLS peers.

While at it, avoid changing the SMPS state of the peer STA. We have no
way to control it, so try and behave correctly towards it.

Move the TDLS peer-teardown function to where the rest of the TDLS code
resides.

Also update Intel copyright to 2015.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         | 21 ++++++++++++++++++---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/mlme.c        | 18 ------------------
 net/mac80211/tdls.c        | 36 ++++++++++++++++++++++++++++++++----
 4 files changed, 51 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bf7023f..c17f91f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2358,6 +2358,8 @@ int __ieee80211_request_smps_mgd(struct ieee80211_sub_if_data *sdata,
 	const u8 *ap;
 	enum ieee80211_smps_mode old_req;
 	int err;
+	struct sta_info *sta;
+	bool tdls_peer_found = false;
 
 	lockdep_assert_held(&sdata->wdev.mtx);
 
@@ -2382,11 +2384,22 @@ int __ieee80211_request_smps_mgd(struct ieee80211_sub_if_data *sdata,
 
 	ap = sdata->u.mgd.associated->bssid;
 
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list) {
+		if (!sta->sta.tdls || sta->sdata != sdata || !sta->uploaded ||
+		    !test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+			continue;
+
+		tdls_peer_found = true;
+		break;
+	}
+	rcu_read_unlock();
+
 	if (smps_mode == IEEE80211_SMPS_AUTOMATIC) {
-		if (sdata->u.mgd.powersave)
-			smps_mode = IEEE80211_SMPS_DYNAMIC;
-		else
+		if (tdls_peer_found || !sdata->u.mgd.powersave)
 			smps_mode = IEEE80211_SMPS_OFF;
+		else
+			smps_mode = IEEE80211_SMPS_DYNAMIC;
 	}
 
 	/* send SM PS frame to AP */
@@ -2394,6 +2407,8 @@ int __ieee80211_request_smps_mgd(struct ieee80211_sub_if_data *sdata,
 					 ap, ap);
 	if (err)
 		sdata->u.mgd.req_smps = old_req;
+	else if (smps_mode != IEEE80211_SMPS_OFF && tdls_peer_found)
+		ieee80211_teardown_tdls_peers(sdata);
 
 	return err;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b12f615..a5081e6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2060,6 +2060,7 @@ void ieee80211_tdls_cancel_channel_switch(struct wiphy *wiphy,
 					  const u8 *addr);
 void ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 					   struct sk_buff *skb);
+void ieee80211_teardown_tdls_peers(struct ieee80211_sub_if_data *sdata);
 
 extern const struct ethtool_ops ieee80211_ethtool_ops;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9b2cc27..60dd6151 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1096,24 +1096,6 @@ static void ieee80211_chswitch_timer(unsigned long data)
 	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.chswitch_work);
 }
 
-static void ieee80211_teardown_tdls_peers(struct ieee80211_sub_if_data *sdata)
-{
-	struct sta_info *sta;
-	u16 reason = WLAN_REASON_TDLS_TEARDOWN_UNSPECIFIED;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list) {
-		if (!sta->sta.tdls || sta->sdata != sdata || !sta->uploaded ||
-		    !test_sta_flag(sta, WLAN_STA_AUTHORIZED))
-			continue;
-
-		ieee80211_tdls_oper_request(&sdata->vif, sta->sta.addr,
-					    NL80211_TDLS_TEARDOWN, reason,
-					    GFP_ATOMIC);
-	}
-	rcu_read_unlock();
-}
-
 static void
 ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				 u64 timestamp, u32 device_timestamp,
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index ad31b2d..b074c85 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -4,6 +4,7 @@
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2014, Intel Corporation
  * Copyright 2014  Intel Mobile Communications GmbH
+ * Copyright 2015  Intel Deutschland GmbH
  *
  * This file is GPLv2 as found in COPYING.
  */
@@ -384,10 +385,6 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 		ieee80211_ie_build_ht_cap(pos, &ht_cap, ht_cap.cap);
 	} else if (action_code == WLAN_TDLS_SETUP_RESPONSE &&
 		   ht_cap.ht_supported && sta->sta.ht_cap.ht_supported) {
-		/* disable SMPS in TDLS responder */
-		sta->sta.ht_cap.cap |= WLAN_HT_CAP_SM_PS_DISABLED
-					<< IEEE80211_HT_CAP_SM_PS_SHIFT;
-
 		/* the peer caps are already intersected with our own */
 		memcpy(&ht_cap, &sta->sta.ht_cap, sizeof(ht_cap));
 
@@ -983,8 +980,17 @@ ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
+	enum ieee80211_smps_mode smps_mode = sdata->u.mgd.driver_smps_mode;
 	int ret;
 
+	/* don't support setup with forced SMPS mode that's not off */
+	if (smps_mode != IEEE80211_SMPS_AUTOMATIC &&
+	    smps_mode != IEEE80211_SMPS_OFF) {
+		tdls_dbg(sdata, "Aborting TDLS setup due to SMPS mode %d\n",
+			 smps_mode);
+		return -ENOTSUPP;
+	}
+
 	mutex_lock(&local->mtx);
 
 	/* we don't support concurrent TDLS peer setups */
@@ -1224,6 +1230,10 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		eth_zero_addr(sdata->u.mgd.tdls_peer);
 	}
 
+	if (ret == 0)
+		ieee80211_queue_work(&sdata->local->hw,
+				     &sdata->u.mgd.request_smps_work);
+
 	mutex_unlock(&local->mtx);
 	return ret;
 }
@@ -1720,3 +1730,21 @@ void ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 }
+
+void ieee80211_teardown_tdls_peers(struct ieee80211_sub_if_data *sdata)
+{
+	struct sta_info *sta;
+	u16 reason = WLAN_REASON_TDLS_TEARDOWN_UNSPECIFIED;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list) {
+		if (!sta->sta.tdls || sta->sdata != sdata || !sta->uploaded ||
+		    !test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+			continue;
+
+		ieee80211_tdls_oper_request(&sdata->vif, sta->sta.addr,
+					    NL80211_TDLS_TEARDOWN, reason,
+					    GFP_ATOMIC);
+	}
+	rcu_read_unlock();
+}
-- 
2.1.4

