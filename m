Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:7747 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306AbbGHMmF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 08:42:05 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/10] cfg80211: use RTNL locked reg_can_beacon for IR-relaxation
Date: Wed,  8 Jul 2015 15:41:44 +0300
Message-Id: <1436359312-26533-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144212_150926_532CADAA)
In-Reply-To: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The RTNL is required to check for IR-relaxation conditions that allow
more channels to beacon. Export an RTNL locked version of reg_can_beacon
and use it where possible in AP/STA interface type flows, where
IR-relaxation may be applicable.

Fixes: 06f207fc5418 ("cfg80211: change GO_CONCURRENT to IR_CONCURRENT for STA")
Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h | 17 +++++++++++++++++
 net/mac80211/tdls.c    |  6 +++---
 net/wireless/chan.c    | 45 ++++++++++++++++++++++++++++++++++-----------
 net/wireless/nl80211.c | 14 ++++++++------
 net/wireless/reg.c     |  2 +-
 net/wireless/trace.h   | 11 +++++++----
 6 files changed, 70 insertions(+), 25 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9a529c4..f0889a2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4867,6 +4867,23 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 			     struct cfg80211_chan_def *chandef,
 			     enum nl80211_iftype iftype);
 
+/**
+ * cfg80211_reg_can_beacon_relax - check if beaconing is allowed with relaxation
+ * @wiphy: the wiphy
+ * @chandef: the channel definition
+ * @iftype: interface type
+ *
+ * Return: %true if there is no secondary channel or the secondary channel(s)
+ * can be used for beaconing (i.e. is not a radar channel etc.). This version
+ * also checks if IR-relaxation conditions apply, to allow beaconing under
+ * more permissive conditions.
+ *
+ * Requires the RTNL to be held.
+ */
+bool cfg80211_reg_can_beacon_relax(struct wiphy *wiphy,
+				   struct cfg80211_chan_def *chandef,
+				   enum nl80211_iftype iftype);
+
 /*
  * cfg80211_ch_switch_notify - update wdev channel and notify userspace
  * @dev: the device which switched channels
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 8536789..20c9dbd 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -69,6 +69,7 @@ ieee80211_tdls_add_subband(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_channel *ch;
 	struct cfg80211_chan_def chandef;
 	int i, subband_start;
+	struct wiphy *wiphy = sdata->local->hw.wiphy;
 
 	for (i = start; i <= end; i += spacing) {
 		if (!ch_cnt)
@@ -79,9 +80,8 @@ ieee80211_tdls_add_subband(struct ieee80211_sub_if_data *sdata,
 			/* we will be active on the channel */
 			cfg80211_chandef_create(&chandef, ch,
 						NL80211_CHAN_NO_HT);
-			if (cfg80211_reg_can_beacon(sdata->local->hw.wiphy,
-						    &chandef,
-						    sdata->wdev.iftype)) {
+			if (cfg80211_reg_can_beacon_relax(wiphy, &chandef,
+							  sdata->wdev.iftype)) {
 				ch_cnt++;
 				/*
 				 * check if the next channel is also part of
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 915b328..59cabc9 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -797,23 +797,18 @@ static bool cfg80211_ir_permissive_chan(struct wiphy *wiphy,
 	return false;
 }
 
-bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
-			     struct cfg80211_chan_def *chandef,
-			     enum nl80211_iftype iftype)
+static bool _cfg80211_reg_can_beacon(struct wiphy *wiphy,
+				     struct cfg80211_chan_def *chandef,
+				     enum nl80211_iftype iftype,
+				     bool check_no_ir)
 {
 	bool res;
 	u32 prohibited_flags = IEEE80211_CHAN_DISABLED |
 			       IEEE80211_CHAN_RADAR;
 
-	trace_cfg80211_reg_can_beacon(wiphy, chandef, iftype);
+	trace_cfg80211_reg_can_beacon(wiphy, chandef, iftype, check_no_ir);
 
-	/*
-	 * Under certain conditions suggested by some regulatory bodies a
-	 * GO/STA can IR on channels marked with IEEE80211_NO_IR. Set this flag
-	 * only if such relaxations are not enabled and the conditions are not
-	 * met.
-	 */
-	if (!cfg80211_ir_permissive_chan(wiphy, iftype, chandef->chan))
+	if (check_no_ir)
 		prohibited_flags |= IEEE80211_CHAN_NO_IR;
 
 	if (cfg80211_chandef_dfs_required(wiphy, chandef, iftype) > 0 &&
@@ -827,8 +822,36 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 	trace_cfg80211_return_bool(res);
 	return res;
 }
+
+bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
+			     struct cfg80211_chan_def *chandef,
+			     enum nl80211_iftype iftype)
+{
+	return _cfg80211_reg_can_beacon(wiphy, chandef, iftype, true);
+}
 EXPORT_SYMBOL(cfg80211_reg_can_beacon);
 
+bool cfg80211_reg_can_beacon_relax(struct wiphy *wiphy,
+				   struct cfg80211_chan_def *chandef,
+				   enum nl80211_iftype iftype)
+{
+	bool check_no_ir;
+
+	ASSERT_RTNL();
+
+	/*
+	 * Under certain conditions suggested by some regulatory bodies a
+	 * GO/STA can IR on channels marked with IEEE80211_NO_IR. Set this flag
+	 * only if such relaxations are not enabled and the conditions are not
+	 * met.
+	 */
+	check_no_ir = !cfg80211_ir_permissive_chan(wiphy, iftype,
+						   chandef->chan);
+
+	return _cfg80211_reg_can_beacon(wiphy, chandef, iftype, check_no_ir);
+}
+EXPORT_SYMBOL(cfg80211_reg_can_beacon_relax);
+
 int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 				 struct cfg80211_chan_def *chandef)
 {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c264eff..76b4157 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2003,7 +2003,8 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
-		if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef, iftype)) {
+		if (!cfg80211_reg_can_beacon_relax(&rdev->wiphy, &chandef,
+						   iftype)) {
 			result = -EINVAL;
 			break;
 		}
@@ -3403,8 +3404,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	} else if (!nl80211_get_ap_channel(rdev, &params))
 		return -EINVAL;
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef,
-				     wdev->iftype))
+	if (!cfg80211_reg_can_beacon_relax(&rdev->wiphy, &params.chandef,
+					   wdev->iftype))
 		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_ACL_POLICY]) {
@@ -6492,8 +6493,8 @@ skip_beacons:
 	if (err)
 		return err;
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef,
-				     wdev->iftype))
+	if (!cfg80211_reg_can_beacon_relax(&rdev->wiphy, &params.chandef,
+					   wdev->iftype))
 		return -EINVAL;
 
 	err = cfg80211_chandef_dfs_required(wdev->wiphy,
@@ -10170,7 +10171,8 @@ static int nl80211_tdls_channel_switch(struct sk_buff *skb,
 		return -EINVAL;
 
 	/* we will be active on the TDLS link */
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef, wdev->iftype))
+	if (!cfg80211_reg_can_beacon_relax(&rdev->wiphy, &chandef,
+					   wdev->iftype))
 		return -EINVAL;
 
 	/* don't allow switching to DFS channels */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 62d8ea4..847da65 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1589,7 +1589,7 @@ static bool reg_wdev_chan_valid(struct wiphy *wiphy, struct wireless_dev *wdev)
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_ADHOC:
-		return cfg80211_reg_can_beacon(wiphy, &chandef, iftype);
+		return cfg80211_reg_can_beacon_relax(wiphy, &chandef, iftype);
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
 		return cfg80211_chandef_usable(wiphy, &chandef,
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index af3617c..a808279 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2358,20 +2358,23 @@ TRACE_EVENT(cfg80211_cqm_rssi_notify,
 
 TRACE_EVENT(cfg80211_reg_can_beacon,
 	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef,
-		 enum nl80211_iftype iftype),
-	TP_ARGS(wiphy, chandef, iftype),
+		 enum nl80211_iftype iftype, bool check_no_ir),
+	TP_ARGS(wiphy, chandef, iftype, check_no_ir),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		CHAN_DEF_ENTRY
 		__field(enum nl80211_iftype, iftype)
+		__field(bool, check_no_ir)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		CHAN_DEF_ASSIGN(chandef);
 		__entry->iftype = iftype;
+		__entry->check_no_ir = check_no_ir;
 	),
-	TP_printk(WIPHY_PR_FMT ", " CHAN_DEF_PR_FMT ", iftype=%d",
-		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG, __entry->iftype)
+	TP_printk(WIPHY_PR_FMT ", " CHAN_DEF_PR_FMT ", iftype=%d check_no_ir=%s",
+		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG, __entry->iftype,
+		  BOOL_TO_STR(__entry->check_no_ir))
 );
 
 TRACE_EVENT(cfg80211_chandef_dfs_required,
-- 
2.1.4

