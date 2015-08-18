Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18327 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbbHRNwM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 09:52:12 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avri Altman <avri.altman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: protect non-HT BSS when HT TDLS traffic exists
Date: Tue, 18 Aug 2015 16:52:07 +0300
Message-Id: <1439905927-24620-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_155220_695549_7A13D658)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

HT TDLS traffic should be protected in a non-HT BSS to avoid
collisions. Therefore, when TDLS peers join/leave, check if
protection is (now) needed and set the ht_operation_mode of
the virtual interface according to the HT capabilities of the
TDLS peer(s).

This works because a non-HT BSS connection never sets (or
otherwise uses) the ht_operation_mode; it just means that
drivers must be aware that this field applies to all HT
traffic for this virtual interface, not just the traffic
within the BSS. Document that.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |  4 ++-
 net/mac80211/tdls.c    | 70 +++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 70 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d37d6cd..a8f805b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -478,7 +478,9 @@ struct ieee80211_event {
  * @chandef: Channel definition for this BSS -- the hardware might be
  *	configured a higher bandwidth than this BSS uses, for example.
  * @ht_operation_mode: HT operation mode like in &struct ieee80211_ht_operation.
- *	This field is only valid when the channel type is one of the HT types.
+ *	This field is only valid when the channel is a wide HT/VHT channel.
+ *	Note that with TDLS this can be the case (channel is HT, protection must
+ *	be used from this field) even when the BSS association isn't using HT.
  * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero value
  *	implies disabled
  * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 8d656d3..c9eeb3f 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1258,6 +1258,58 @@ static void iee80211_tdls_recalc_chanctx(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&local->chanctx_mtx);
 }
 
+static int iee80211_tdls_have_ht_peers(struct ieee80211_sub_if_data *sdata)
+{
+	struct sta_info *sta;
+	bool result = false;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list) {
+		if (!sta->sta.tdls || sta->sdata != sdata || !sta->uploaded ||
+		    !test_sta_flag(sta, WLAN_STA_AUTHORIZED) ||
+		    !test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH) ||
+		    !sta->sta.ht_cap.ht_supported)
+			continue;
+		result = true;
+		break;
+	}
+	rcu_read_unlock();
+
+	return result;
+}
+
+static void
+iee80211_tdls_recalc_ht_protection(struct ieee80211_sub_if_data *sdata,
+				   struct sta_info *sta)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	bool tdls_ht;
+	u16 protection = IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED |
+			 IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT |
+			 IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT;
+	u16 opmode;
+
+	/* Nothing to do if the BSS connection uses HT */
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
+		return;
+
+	tdls_ht = (sta && sta->sta.ht_cap.ht_supported) ||
+		  iee80211_tdls_have_ht_peers(sdata);
+
+	opmode = sdata->vif.bss_conf.ht_operation_mode;
+
+	if (tdls_ht)
+		opmode |= protection;
+	else
+		opmode &= ~protection;
+
+	if (opmode == sdata->vif.bss_conf.ht_operation_mode)
+		return;
+
+	sdata->vif.bss_conf.ht_operation_mode = opmode;
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_HT);
+}
+
 int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, enum nl80211_tdls_operation oper)
 {
@@ -1283,6 +1335,10 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		return -ENOTSUPP;
 	}
 
+	/* protect possible bss_conf changes and avoid concurrency in
+	 * ieee80211_bss_info_change_notify()
+	 */
+	sdata_lock(sdata);
 	mutex_lock(&local->mtx);
 	tdls_dbg(sdata, "TDLS oper %d peer %pM\n", oper, peer);
 
@@ -1296,16 +1352,18 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 
 		iee80211_tdls_recalc_chanctx(sdata);
 
-		rcu_read_lock();
+		mutex_lock(&local->sta_mtx);
 		sta = sta_info_get(sdata, peer);
 		if (!sta) {
-			rcu_read_unlock();
+			mutex_unlock(&local->sta_mtx);
 			ret = -ENOLINK;
 			break;
 		}
 
+		iee80211_tdls_recalc_ht_protection(sdata, sta);
+
 		set_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH);
-		rcu_read_unlock();
+		mutex_unlock(&local->sta_mtx);
 
 		WARN_ON_ONCE(is_zero_ether_addr(sdata->u.mgd.tdls_peer) ||
 			     !ether_addr_equal(sdata->u.mgd.tdls_peer, peer));
@@ -1327,6 +1385,11 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		ieee80211_flush_queues(local, sdata, false);
 
 		ret = sta_info_destroy_addr(sdata, peer);
+
+		mutex_lock(&local->sta_mtx);
+		iee80211_tdls_recalc_ht_protection(sdata, NULL);
+		mutex_unlock(&local->sta_mtx);
+
 		iee80211_tdls_recalc_chanctx(sdata);
 		break;
 	default:
@@ -1344,6 +1407,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 				     &sdata->u.mgd.request_smps_work);
 
 	mutex_unlock(&local->mtx);
+	sdata_unlock(sdata);
 	return ret;
 }
 
-- 
2.1.4

