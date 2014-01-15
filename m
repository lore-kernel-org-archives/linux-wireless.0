Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5806 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbaAOPu7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 10:50:59 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, wireless-regdb@lists.infradead.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v2 3/6] cfg80211: Enable GO operation on additional channels
Date: Wed, 15 Jan 2014 17:52:39 +0200
Message-Id: <1389801162-14488-4-git-send-email-ilan.peer@intel.com> (sfid-20140115_165105_551816_1FDF3C47)
In-Reply-To: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
References: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow GO operation on a channel marked with IEEE80211_CHAN_GO_CONCURRENT
iff there is an active station interface that is associated to
an AP operating on the same channel in 2.4 or the same UNII band in 5.2
(assuming that the AP is an authorized master)

Note that this is a permissive approach to the FCC definitions,
that require a clear assessment that the device operating the AP is
an authorized master, i.e., with radar detection and DFS capabilities.

It is assumed that such restrictions are enforced by user space.
Furthermore, it is assumed, that if the conditions that allowed for
the operation of the GO on such a channel change, i.e., the station
interface disconnected from the AP, it is the responsibility of user
space to evacuate the GO from the channel.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 include/net/cfg80211.h |    4 ++-
 net/mac80211/ibss.c    |    9 ++++---
 net/wireless/Kconfig   |    9 +++++++
 net/wireless/chan.c    |   68 +++++++++++++++++++++++++++++++++++++++++++++---
 net/wireless/mesh.c    |    3 ++-
 net/wireless/nl80211.c |   11 +++++---
 net/wireless/reg.c     |   22 ++++++++++++++++
 net/wireless/reg.h     |   12 +++++++++
 net/wireless/trace.h   |   11 +++++---
 9 files changed, 133 insertions(+), 16 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f4289db..504d656 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4297,12 +4297,14 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
  * cfg80211_reg_can_beacon - check if beaconing is allowed
  * @wiphy: the wiphy
  * @chandef: the channel definition
+ * @iftype: interface type
  *
  * Return: %true if there is no secondary channel or the secondary channel(s)
  * can be used for beaconing (i.e. is not a radar channel etc.)
  */
 bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
-			     struct cfg80211_chan_def *chandef);
+			     struct cfg80211_chan_def *chandef,
+			     enum nl80211_iftype iftype);
 
 /*
  * cfg80211_ch_switch_notify - update wdev channel and notify userspace
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 2eda7b1..9d5688d 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -263,7 +263,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	/* make a copy of the chandef, it could be modified below. */
 	chandef = *req_chandef;
 	chan = chandef.chan;
-	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
+	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef,
+				     NL80211_IFTYPE_ADHOC)) {
 		if (chandef.width == NL80211_CHAN_WIDTH_5 ||
 		    chandef.width == NL80211_CHAN_WIDTH_10 ||
 		    chandef.width == NL80211_CHAN_WIDTH_20_NOHT ||
@@ -275,7 +276,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		chandef.width = NL80211_CHAN_WIDTH_20;
 		chandef.center_freq1 = chan->center_freq;
 		/* check again for downgraded chandef */
-		if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
+		if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef,
+					     NL80211_IFTYPE_ADHOC)) {
 			sdata_info(sdata,
 				   "Failed to join IBSS, beacons forbidden\n");
 			return;
@@ -865,7 +867,8 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		goto disconnect;
 	}
 
-	if (!cfg80211_reg_can_beacon(sdata->local->hw.wiphy, &params.chandef)) {
+	if (!cfg80211_reg_can_beacon(sdata->local->hw.wiphy, &params.chandef,
+				     NL80211_IFTYPE_ADHOC)) {
 		sdata_info(sdata,
 			   "IBSS %pM switches to unsupported channel (%d MHz, width:%d, CF1/2: %d/%d MHz), disconnecting\n",
 			   ifibss->bssid,
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 81c05e4..f4012fc 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -102,6 +102,15 @@ config CFG80211_REG_CELLULAR_HINTS
 	  This option adds support for drivers that can receive regulatory
 	  hints from cellular base stations
 
+config CFG80211_REG_SOFT_CONFIGURATIONS
+	bool "cfg80211 support for GO operation on additional channels"
+	depends on CFG80211_CERTIFICATION_ONUS
+	---help---
+	  This option enables the operation of a P2P group owner on
+	  additional channels, if there is an additional BSS interface
+	  which is connected to an AP which is assumed to be an authorized
+	  master, i.e., with radar detection support and DFS capabilities
+
 config CFG80211_DEFAULT_PS
 	bool "enable powersave by default"
 	depends on CFG80211
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 78559b5..d47856b 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -605,15 +605,77 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(cfg80211_chandef_usable);
 
+#ifdef CONFIG_CFG80211_REG_SOFT_CONFIGURATIONS
+/* For GO only, check if the channel can be used under permissive conditions
+ * mandated by the some regulatory bodies, i.e., the channel is marked with
+ * IEEE80211_CHAN_GO_CONCURRENT and there is an additional station interface
+ * associated to an AP on the same channel or on the same UNII band
+ * (assuming that the AP is an authorized master).
+ */
+static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
+					struct ieee80211_channel *chan)
+{
+	struct wireless_dev *wdev_iter;
+
+	ASSERT_RTNL();
+
+	if (!(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
+		return false;
+
+	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
+		struct ieee80211_channel *other_chan = NULL;
+
+		if (wdev_iter->iftype != NL80211_IFTYPE_STATION ||
+		    !netif_running(wdev_iter->netdev))
+				continue;
+
+		wdev_lock(wdev_iter);
+		if (wdev_iter->current_bss)
+			other_chan = wdev_iter->current_bss->pub.channel;
+		wdev_unlock(wdev_iter);
+
+		if (!other_chan)
+			continue;
+
+		if (chan == other_chan) {
+			return true;
+		} else if (chan->band == IEEE80211_BAND_5GHZ) {
+			int r1 = cfg80211_get_unii(chan->center_freq);
+			int r2 = cfg80211_get_unii(other_chan->center_freq);
+
+			if (r1 != -EINVAL && r1 == r2)
+				return true;
+		}
+	}
+	return false;
+}
+#else
+static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
+					struct ieee80211_channel *chan)
+{
+	return false;
+}
+#endif /* CONFIG_CFG80211_REG_SOFT_CONFIGURATIONS */
+
 bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
-			     struct cfg80211_chan_def *chandef)
+			     struct cfg80211_chan_def *chandef,
+			     enum nl80211_iftype iftype)
 {
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	bool res;
 	u32 prohibited_flags = IEEE80211_CHAN_DISABLED |
-			       IEEE80211_CHAN_NO_IR |
 			       IEEE80211_CHAN_RADAR;
 
-	trace_cfg80211_reg_can_beacon(wiphy, chandef);
+	trace_cfg80211_reg_can_beacon(wiphy, chandef, iftype);
+
+	/* Under certain conditions suggested by the some regulatory bodies
+	 * a GO can operate on channels marked with IEEE80211_NO_IR
+	 * so set this flag only if such relaxations are not enabled and
+	 * the conditions are not met.
+	 */
+	if (iftype != NL80211_IFTYPE_P2P_GO ||
+	    !cfg80211_go_permissive_chan(rdev, chandef->chan))
+		prohibited_flags |= IEEE80211_CHAN_NO_IR;
 
 	if (cfg80211_chandef_dfs_required(wiphy, chandef) > 0 &&
 	    cfg80211_chandef_dfs_available(wiphy, chandef)) {
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index b0e1869..925c920 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -174,7 +174,8 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 							       scan_width);
 	}
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef,
+				     NL80211_IFTYPE_MESH_POINT))
 		return -EINVAL;
 
 	err = cfg80211_can_use_chan(rdev, wdev, setup->chandef.chan,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 31bc8c7..267d37e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1870,7 +1870,7 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 			result = -EBUSY;
 			break;
 		}
-		if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef)) {
+		if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef, iftype)) {
 			result = -EINVAL;
 			break;
 		}
@@ -3219,7 +3219,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	} else if (!nl80211_get_ap_channel(rdev, &params))
 		return -EINVAL;
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef,
+				     wdev->iftype))
 		return -EINVAL;
 
 	err = cfg80211_chandef_dfs_required(wdev->wiphy, &params.chandef);
@@ -5806,7 +5807,8 @@ skip_beacons:
 	if (err)
 		return err;
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef,
+				     wdev->iftype))
 		return -EINVAL;
 
 	if (dev->ieee80211_ptr->iftype == NL80211_IFTYPE_AP ||
@@ -6577,7 +6579,8 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef,
+				     NL80211_IFTYPE_ADHOC))
 		return -EINVAL;
 
 	switch (ibss.chandef.width) {
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2449dce..212b5c2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2460,6 +2460,28 @@ static void reg_timeout_work(struct work_struct *work)
 	rtnl_unlock();
 }
 
+int cfg80211_get_unii(int freq)
+{
+	/* UNII-1 */
+	if (freq >= 5150 && freq <= 5250)
+		return 0;
+
+	/* UNII-2 */
+	if (freq > 5250 && freq <= 5350)
+		return 1;
+
+	/* UNII-2E */
+	if (freq >= 5470 && freq <= 5725)
+		return 2;
+
+	/* UNII-3 */
+	if (freq > 5725 && freq <= 5825)
+		return 3;
+
+	WARN_ON(1);
+	return -EINVAL;
+}
+
 int __init regulatory_init(void)
 {
 	int err = 0;
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index cc4c2c0..1ef2daa 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -102,4 +102,16 @@ void regulatory_hint_country_ie(struct wiphy *wiphy,
  */
 void regulatory_hint_disconnect(void);
 
+/**
+ * cfg80211_get_unii - get a value specifying the U-NII band the frequency
+ * belongs too.
+ * @freq: the frequency for which we want to get the UNII band.
+
+ * U-NII bands are defined by the FCC in C.F.R 47 part 15.
+ *
+ * Returns -EINVAL if freq is invalid, 1 for UNII-1, 2 for UNII-2,
+ * 3 for UNII-2e, 4 for UNII-3.
+ */
+int cfg80211_get_unii(int freq);
+
 #endif  /* __NET_WIRELESS_REG_H */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index f7aa7a7..6687712 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2149,18 +2149,21 @@ TRACE_EVENT(cfg80211_cqm_rssi_notify,
 );
 
 TRACE_EVENT(cfg80211_reg_can_beacon,
-	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef),
-	TP_ARGS(wiphy, chandef),
+	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef,
+		 enum nl80211_iftype iftype),
+	TP_ARGS(wiphy, chandef, iftype),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		CHAN_DEF_ENTRY
+		__field(enum nl80211_iftype, iftype)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		CHAN_DEF_ASSIGN(chandef);
+		__entry->iftype = iftype;
 	),
-	TP_printk(WIPHY_PR_FMT ", " CHAN_DEF_PR_FMT,
-		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG)
+	TP_printk(WIPHY_PR_FMT ", " CHAN_DEF_PR_FMT ", iftype=%d",
+		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG, __entry->iftype)
 );
 
 TRACE_EVENT(cfg80211_chandef_dfs_required,
-- 
1.7.10.4

