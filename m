Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52305 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab3HTLM1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 07:12:27 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 1/2] mac80211: allow APs to send SMPS frames
Date: Tue, 20 Aug 2013 14:12:18 +0300
Message-Id: <1376997139-6228-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130820_131231_376323_EDF32474)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SMPS code checks all over the place that the vif is
BSS. Remove that constraint and allow SMPS for AP too.

Provide dummy implementation that will be used for
further patches.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c            |   15 ++++++++++++---
 net/mac80211/debugfs_netdev.c |   24 +++++++++++++++---------
 net/mac80211/ht.c             |   38 ++++++++++++++++++++++++++++----------
 net/mac80211/ieee80211_i.h    |   13 ++++++++++---
 net/mac80211/iface.c          |    2 ++
 net/mac80211/mlme.c           |    2 +-
 6 files changed, 68 insertions(+), 26 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4cc81c3..bd6b38c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2337,8 +2337,14 @@ static int ieee80211_testmode_dump(struct wiphy *wiphy,
 }
 #endif
 
-int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
-			     enum ieee80211_smps_mode smps_mode)
+int __ieee80211_request_smps_ap(struct ieee80211_sub_if_data *sdata,
+				enum ieee80211_smps_mode smps_mode)
+{
+	return 0;
+}
+
+int __ieee80211_request_smps_mgd(struct ieee80211_sub_if_data *sdata,
+				 enum ieee80211_smps_mode smps_mode)
 {
 	const u8 *ap;
 	enum ieee80211_smps_mode old_req;
@@ -2346,6 +2352,9 @@ int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
 
 	lockdep_assert_held(&sdata->wdev.mtx);
 
+	if (WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
 	old_req = sdata->u.mgd.req_smps;
 	sdata->u.mgd.req_smps = smps_mode;
 
@@ -2402,7 +2411,7 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 
 	/* no change, but if automatic follow powersave */
 	sdata_lock(sdata);
-	__ieee80211_request_smps(sdata, sdata->u.mgd.req_smps);
+	__ieee80211_request_smps_mgd(sdata, sdata->u.mgd.req_smps);
 	sdata_unlock(sdata);
 
 	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index e601c9f..7609e47 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -224,12 +224,15 @@ static int ieee80211_set_smps(struct ieee80211_sub_if_data *sdata,
 	     smps_mode == IEEE80211_SMPS_AUTOMATIC))
 		return -EINVAL;
 
-	/* supported only on managed interfaces for now */
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+	    sdata->vif.type != NL80211_IFTYPE_AP)
 		return -EOPNOTSUPP;
 
 	sdata_lock(sdata);
-	err = __ieee80211_request_smps(sdata, smps_mode);
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		err = __ieee80211_request_smps_mgd(sdata, smps_mode);
+	else
+		err = __ieee80211_request_smps_ap(sdata, smps_mode);
 	sdata_unlock(sdata);
 
 	return err;
@@ -245,12 +248,15 @@ static const char *smps_modes[IEEE80211_SMPS_NUM_MODES] = {
 static ssize_t ieee80211_if_fmt_smps(const struct ieee80211_sub_if_data *sdata,
 				     char *buf, int buflen)
 {
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
-		return -EOPNOTSUPP;
-
-	return snprintf(buf, buflen, "request: %s\nused: %s\n",
-			smps_modes[sdata->u.mgd.req_smps],
-			smps_modes[sdata->smps_mode]);
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		return snprintf(buf, buflen, "request: %s\nused: %s\n",
+				smps_modes[sdata->u.mgd.req_smps],
+				smps_modes[sdata->smps_mode]);
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		return snprintf(buf, buflen, "request: %s\nused: %s\n",
+				smps_modes[sdata->u.ap.req_smps],
+				smps_modes[sdata->smps_mode]);
+	return -EINVAL;
 }
 
 static ssize_t ieee80211_if_parse_smps(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 529bf58..2c85b96 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -448,14 +448,25 @@ int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void ieee80211_request_smps_work(struct work_struct *work)
+void ieee80211_request_smps_mgd_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.request_smps_work);
 
 	sdata_lock(sdata);
-	__ieee80211_request_smps(sdata, sdata->u.mgd.driver_smps_mode);
+	__ieee80211_request_smps_mgd(sdata, sdata->u.mgd.driver_smps_mode);
+	sdata_unlock(sdata);
+}
+
+void ieee80211_request_smps_ap_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.ap.request_smps_work);
+
+	sdata_lock(sdata);
+	__ieee80211_request_smps_ap(sdata, sdata->u.ap.driver_smps_mode);
 	sdata_unlock(sdata);
 }
 
@@ -464,19 +475,26 @@ void ieee80211_request_smps(struct ieee80211_vif *vif,
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 
-	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION))
+	if (WARN_ON_ONCE(vif->type != NL80211_IFTYPE_STATION &&
+			 vif->type != NL80211_IFTYPE_AP))
 		return;
 
 	if (WARN_ON(smps_mode == IEEE80211_SMPS_OFF))
 		smps_mode = IEEE80211_SMPS_AUTOMATIC;
 
-	if (sdata->u.mgd.driver_smps_mode == smps_mode)
-		return;
-
-	sdata->u.mgd.driver_smps_mode = smps_mode;
-
-	ieee80211_queue_work(&sdata->local->hw,
-			     &sdata->u.mgd.request_smps_work);
+	if (vif->type == NL80211_IFTYPE_STATION) {
+		if (sdata->u.mgd.driver_smps_mode == smps_mode)
+			return;
+		sdata->u.mgd.driver_smps_mode = smps_mode;
+		ieee80211_queue_work(&sdata->local->hw,
+				     &sdata->u.mgd.request_smps_work);
+	} else {
+		if (sdata->u.ap.driver_smps_mode == smps_mode)
+			return;
+		sdata->u.ap.driver_smps_mode = smps_mode;
+		ieee80211_queue_work(&sdata->local->hw,
+				     &sdata->u.ap.request_smps_work);
+	}
 }
 /* this might change ... don't want non-open drivers using it */
 EXPORT_SYMBOL_GPL(ieee80211_request_smps);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 47cf62e..7c68eac 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -265,6 +265,10 @@ struct ieee80211_if_ap {
 
 	struct ps_data ps;
 	atomic_t num_mcast_sta; /* number of stations receiving multicast */
+	enum ieee80211_smps_mode req_smps, /* requested smps mode */
+			 driver_smps_mode; /* smps mode request */
+
+	struct work_struct request_smps_work;
 };
 
 struct ieee80211_if_wds {
@@ -1439,7 +1443,8 @@ void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
 			       enum ieee80211_smps_mode smps, const u8 *da,
 			       const u8 *bssid);
-void ieee80211_request_smps_work(struct work_struct *work);
+void ieee80211_request_smps_ap_work(struct work_struct *work);
+void ieee80211_request_smps_mgd_work(struct work_struct *work);
 
 void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				     u16 initiator, u16 reason, bool stop);
@@ -1634,8 +1639,10 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 u32 ieee80211_sta_get_rates(struct ieee80211_sub_if_data *sdata,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band, u32 *basic_rates);
-int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
-			     enum ieee80211_smps_mode smps_mode);
+int __ieee80211_request_smps_mgd(struct ieee80211_sub_if_data *sdata,
+				 enum ieee80211_smps_mode smps_mode);
+int __ieee80211_request_smps_ap(struct ieee80211_sub_if_data *sdata,
+				enum ieee80211_smps_mode smps_mode);
 void ieee80211_recalc_smps(struct ieee80211_sub_if_data *sdata);
 
 size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index cc0c4be..913ef15 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1301,6 +1301,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 		skb_queue_head_init(&sdata->u.ap.ps.bc_buf);
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
+		INIT_WORK(&sdata->u.ap.request_smps_work,
+			  ieee80211_request_smps_ap_work);
 		sdata->vif.bss_conf.bssid = sdata->vif.addr;
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 21bccd8..89e6f28 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3693,7 +3693,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 		  ieee80211_beacon_connection_loss_work);
 	INIT_WORK(&ifmgd->csa_connection_drop_work,
 		  ieee80211_csa_connection_drop_work);
-	INIT_WORK(&ifmgd->request_smps_work, ieee80211_request_smps_work);
+	INIT_WORK(&ifmgd->request_smps_work, ieee80211_request_smps_mgd_work);
 	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
 	setup_timer(&ifmgd->bcn_mon_timer, ieee80211_sta_bcn_mon_timer,
-- 
1.7.10.4

