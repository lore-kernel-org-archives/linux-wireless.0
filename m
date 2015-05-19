Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:13215 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbbESLgz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 07:36:55 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: disconnect TDLS stations on STA CSA
Date: Tue, 19 May 2015 14:36:48 +0300
Message-Id: <1432035408-8460-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150519_133658_698990_C9D99D85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

When a station does a channel switch, it's not well defined what its TDLS
peers would do. Avoid a situation when the local side marks a potentially
disconnected peer as a TDLS peer.
Keeping peers connected through CSA is doubly problematic with the upcoming
TDLS WIDER-BW feature which allows peers to widen the BSS channel. The
new channel transitioned-to might not be compatible and would require
a re-negotiation anyway.

Make sure to disallow new TDLS link during CSA.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 26 ++++++++++++++++++++++++++
 net/mac80211/tdls.c |  6 ++++++
 2 files changed, 32 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3294666..387fe70 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1098,6 +1098,24 @@ static void ieee80211_chswitch_timer(unsigned long data)
 	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.chswitch_work);
 }
 
+static void ieee80211_teardown_tdls_peers(struct ieee80211_sub_if_data *sdata)
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
+
 static void
 ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 				 u64 timestamp, u32 device_timestamp,
@@ -1161,6 +1179,14 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
+	/*
+	 * Drop all TDLS peers - either we disconnect or move to a different
+	 * channel from this point on. There's no telling what our peer will do.
+	 * The TDLS WIDER_BW scenario is also problematic, as peers might now
+	 * have an incompatible wider chandef.
+	 */
+	ieee80211_teardown_tdls_peers(sdata);
+
 	mutex_lock(&local->mtx);
 	mutex_lock(&local->chanctx_mtx);
 	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 8a92a92..75e8e3b 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1183,6 +1183,12 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 
 	switch (oper) {
 	case NL80211_TDLS_ENABLE_LINK:
+		if (sdata->vif.csa_active) {
+			tdls_dbg(sdata, "TDLS: disallow link during CSA\n");
+			ret = -EBUSY;
+			break;
+		}
+
 		rcu_read_lock();
 		sta = sta_info_get(sdata, peer);
 		if (!sta) {
-- 
2.1.4

