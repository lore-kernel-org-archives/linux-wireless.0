Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11402 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaBWHLe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 02:11:34 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v6 3/5] cfg80211: Enable GO operation on additional channels
Date: Sun, 23 Feb 2014 09:13:01 +0200
Message-Id: <1393139583-7249-4-git-send-email-ilan.peer@intel.com> (sfid-20140223_081140_132775_99FD0953)
In-Reply-To: <1393139583-7249-1-git-send-email-ilan.peer@intel.com>
References: <1393139583-7249-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow GO operation on a channel marked with IEEE80211_CHAN_GO_CONCURRENT
iff there is an active station interface that is associated to
an AP operating on the same channel in the 2 GHz band or the same UNII band
(in the 5 GHz band). This relaxation is not allowed if the channel is
marked with IEEE80211_CHAN_RADAR.

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
 include/net/cfg80211.h   |    4 ++-
 include/net/regulatory.h |    6 ++++
 net/mac80211/ibss.c      |    9 ++++--
 net/wireless/Kconfig     |   24 +++++++++++++++
 net/wireless/chan.c      |   76 ++++++++++++++++++++++++++++++++++++++++++++--
 net/wireless/mesh.c      |    3 +-
 net/wireless/nl80211.c   |   11 ++++---
 net/wireless/reg.c       |   29 ++++++++++++++++++
 net/wireless/reg.h       |   12 ++++++++
 net/wireless/trace.h     |   11 ++++---
 10 files changed, 169 insertions(+), 16 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2ba017c..e872c9c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4521,12 +4521,14 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
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
diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index b07cdc9..0d96cd0 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -131,6 +131,11 @@ struct regulatory_request {
  * 	all country IE information processed by the regulatory core. This will
  * 	override %REGULATORY_COUNTRY_IE_FOLLOW_POWER as all country IEs will
  * 	be ignored.
+ * @REGULATORY_ENABLE_RELAX_NO_IR: for devices that wish to allow the
+ *      NO_IR relaxation, which enables transmissions on channels on which
+ *      otherwise initiating radiation is not allowed. This will enable the
+ *      relaxations enabled under the CFG80211_REG_RELAX_NO_IR configuration
+ *      option
  */
 enum ieee80211_regulatory_flags {
 	REGULATORY_CUSTOM_REG			= BIT(0),
@@ -138,6 +143,7 @@ enum ieee80211_regulatory_flags {
 	REGULATORY_DISABLE_BEACON_HINTS		= BIT(2),
 	REGULATORY_COUNTRY_IE_FOLLOW_POWER	= BIT(3),
 	REGULATORY_COUNTRY_IE_IGNORE		= BIT(4),
+	REGULATORY_ENABLE_RELAX_NO_IR           = BIT(5),
 };
 
 struct ieee80211_freq_range {
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 4453e27..a3b9561 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -262,7 +262,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	/* make a copy of the chandef, it could be modified below. */
 	chandef = *req_chandef;
 	chan = chandef.chan;
-	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
+	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef,
+				     NL80211_IFTYPE_ADHOC)) {
 		if (chandef.width == NL80211_CHAN_WIDTH_5 ||
 		    chandef.width == NL80211_CHAN_WIDTH_10 ||
 		    chandef.width == NL80211_CHAN_WIDTH_20_NOHT ||
@@ -274,7 +275,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		chandef.width = NL80211_CHAN_WIDTH_20;
 		chandef.center_freq1 = chan->center_freq;
 		/* check again for downgraded chandef */
-		if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
+		if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef,
+					     NL80211_IFTYPE_ADHOC)) {
 			sdata_info(sdata,
 				   "Failed to join IBSS, beacons forbidden\n");
 			return;
@@ -856,7 +858,8 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		goto disconnect;
 	}
 
-	if (!cfg80211_reg_can_beacon(sdata->local->hw.wiphy, &params.chandef)) {
+	if (!cfg80211_reg_can_beacon(sdata->local->hw.wiphy, &params.chandef,
+				     NL80211_IFTYPE_ADHOC)) {
 		sdata_info(sdata,
 			   "IBSS %pM switches to unsupported channel (%d MHz, width:%d, CF1/2: %d/%d MHz), disconnecting\n",
 			   ifibss->bssid,
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 2a891bc..405f3c4 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -108,6 +108,30 @@ config CFG80211_REG_CELLULAR_HINTS
 	  feature if you have tested and validated this feature on your
 	  systems.
 
+config CFG80211_REG_RELAX_NO_IR
+	bool "cfg80211 support for NO_IR relaxation"
+	depends on CFG80211_CERTIFICATION_ONUS
+	---help---
+	 This option enables support for relaxation of the NO_IR flag for
+	 situations that certain regulatory bodies have provided clarifications
+	 on how relaxation can occur. This feature has an inherent dependency on
+	 userspace features which must have been properly tested and as such is
+	 not enabled by default.
+
+	 A relaxation feature example is allowing the operation of a P2P group
+	 owner (GO) on channels marked with NO_IR if there is an additional BSS
+	 interface which associated to an AP which userspace assumes or confirms
+	 to be an authorized master, i.e., with radar detection support and DFS
+	 capabilities. However, note that in order to not create daisy chain
+	 scenarios, this relaxation is not allowed in cases that the BSS client
+	 is associated to P2P GO and in addition the P2P GO instantiated on
+	 a channel due to this relaxation should not allow connection from
+	 non P2P clients.
+
+	 The regulatory core will apply these relaxations only for drivers that
+	 support this feature by declaring the appropriate channel flags and
+	 capabilities in their registration flow.
+
 config CFG80211_DEFAULT_PS
 	bool "enable powersave by default"
 	depends on CFG80211
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index f8ab7df..cc255eb 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -605,15 +605,85 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(cfg80211_chandef_usable);
 
+/*
+ * For GO only, check if the channel can be used under permissive conditions
+ * mandated by the some regulatory bodies, i.e., the channel is marked with
+ * IEEE80211_CHAN_GO_CONCURRENT and there is an additional station interface
+ * associated to an AP on the same channel or on the same UNII band
+ * (assuming that the AP is an authorized master).
+ */
+static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
+					struct ieee80211_channel *chan)
+{
+	struct wireless_dev *wdev_iter;
+	struct wiphy *wiphy = wiphy_idx_to_wiphy(rdev->wiphy_idx);
+
+	ASSERT_RTNL();
+
+	if (!config_enabled(CONFIG_CFG80211_REG_RELAX_NO_IR) ||
+	    !(wiphy->regulatory_flags & REGULATORY_ENABLE_RELAX_NO_IR) ||
+	    !(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
+		return false;
+
+	/*
+	 * Generally, it is possible to rely on another device/driver to allow
+	 * the GO concurrent relaxation, however, since the device can further
+	 * enforce the relaxation (by doing a similar verifications as this),
+	 * and thus fail the GO instantiation, consider only the interfaces of
+	 * the current registered device.
+	 */
+	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
+		struct ieee80211_channel *other_chan = NULL;
+		int r1, r2;
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
+		if (chan == other_chan)
+			return true;
+
+		if (chan->band != IEEE80211_BAND_5GHZ)
+			continue;
+
+		r1 = cfg80211_get_unii(chan->center_freq);
+		r2 = cfg80211_get_unii(other_chan->center_freq);
+
+		if (r1 != -EINVAL && r1 == r2)
+			return true;
+	}
+
+	return false;
+}
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
+	/*
+	 * Under certain conditions suggested by the some regulatory bodies
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
index d42a3fc..45c2c85 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -175,7 +175,8 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 							       scan_width);
 	}
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef,
+				     NL80211_IFTYPE_MESH_POINT))
 		return -EINVAL;
 
 	err = cfg80211_chandef_dfs_required(wdev->wiphy, &setup->chandef);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 95a8c72..2270d9b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1933,7 +1933,7 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 			result = -EBUSY;
 			break;
 		}
-		if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef)) {
+		if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef, iftype)) {
 			result = -EINVAL;
 			break;
 		}
@@ -3259,7 +3259,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	} else if (!nl80211_get_ap_channel(rdev, &params))
 		return -EINVAL;
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef,
+				     wdev->iftype))
 		return -EINVAL;
 
 	err = cfg80211_chandef_dfs_required(wdev->wiphy, &params.chandef);
@@ -5914,7 +5915,8 @@ skip_beacons:
 	if (err)
 		return err;
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef,
+				     wdev->iftype))
 		return -EINVAL;
 
 	if (dev->ieee80211_ptr->iftype == NL80211_IFTYPE_AP ||
@@ -6685,7 +6687,8 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef,
+				     NL80211_IFTYPE_ADHOC))
 		return -EINVAL;
 
 	switch (ibss.chandef.width) {
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 97af820..85aa847 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2597,6 +2597,35 @@ static void reg_timeout_work(struct work_struct *work)
 	rtnl_unlock();
 }
 
+/*
+ * See http://www.fcc.gov/document/5-ghz-unlicensed-spectrum-unii, for
+ * UNII band definitions
+ */
+int cfg80211_get_unii(int freq)
+{
+	/* UNII-1 */
+	if (freq >= 5150 && freq <= 5250)
+		return 0;
+
+	/* UNII-2A */
+	if (freq > 5250 && freq <= 5350)
+		return 1;
+
+	/* UNII-2B */
+	if (freq > 5350 && freq <= 5470)
+		return 2;
+
+	/* UNII-2C */
+	if (freq > 5470 && freq <= 5725)
+		return 3;
+
+	/* UNII-3 */
+	if (freq > 5725 && freq <= 5825)
+		return 4;
+
+	return -EINVAL;
+}
+
 int __init regulatory_init(void)
 {
 	int err = 0;
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 1852461..9c11e72 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -105,4 +105,16 @@ void regulatory_hint_country_ie(struct wiphy *wiphy,
  */
 void regulatory_hint_disconnect(void);
 
+/**
+ * cfg80211_get_unii - get the U-NII band for the frequency
+ * @freq: the frequency for which we want to get the UNII band.
+
+ * Get a value specifying the U-NII band frequency belongs to.
+ * U-NII bands are defined by the FCC in C.F.R 47 part 15.
+ *
+ * Returns -EINVAL if freq is invalid, 0 for UNII-1, 1 for UNII-2A,
+ * 2 for UNII-2B, 3 for UNII-2C and 4 for UNII-3.
+ */
+int cfg80211_get_unii(int freq);
+
 #endif  /* __NET_WIRELESS_REG_H */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 5eaeed5..6293e8d 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2189,18 +2189,21 @@ TRACE_EVENT(cfg80211_cqm_rssi_notify,
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

