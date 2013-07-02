Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30270 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab3GBNbc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 09:31:32 -0400
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, David Spinadel <david.spinadel@intel.com>,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 3/3] [RFC] cfg80211: Enable GO operation on additional channels
Date: Tue,  2 Jul 2013 15:28:15 +0300
Message-Id: <1372768095-26053-4-git-send-email-ilan.peer@intel.com> (sfid-20130702_153135_354953_B88A7BA0)
In-Reply-To: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
References: <1372768095-26053-1-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Allow GO operation on a channel marked with
IEEE80211_CHAN_INDOOR_ONLY or IEEE80211_CHAN_GO_CONCURRENT
iff there is an active station interface that is associated to
an AP operating on this channel.

Note that this is a permissive approach to the FCC definitions,
that require a clear assessment that either the platform device
is an indoor device, or the device operating the AP is an indoor
device, i.e., AC powered.
It is assumed that these restrictions are enforced by user space.
Furthermore, it is assumed, that if the conditions that allowed for
the operation of the GO on such a channel change, it is the
responsibility of user space to evacuate the GO from the channel.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 include/net/cfg80211.h |    4 +-
 net/mac80211/ibss.c    |    2 +-
 net/wireless/Kconfig   |   10 +++++
 net/wireless/chan.c    |   98 ++++++++++++++++++++++++++++++++++++++++++++----
 net/wireless/mesh.c    |    2 +-
 net/wireless/nl80211.c |    8 ++--
 net/wireless/trace.h   |   11 ++++--
 7 files changed, 118 insertions(+), 17 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f0badeb..17d693d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4070,12 +4070,14 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
  * cfg80211_reg_can_beacon - check if beaconing is allowed
  * @wiphy: the wiphy
  * @chandef: the channel definition
+ * @p2p_go: if the interface type is a P2P GO
  *
  * Return: %true if there is no secondary channel or the secondary channel(s)
  * can be used for beaconing (i.e. is not a radar channel etc.)
  */
 bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
-			     struct cfg80211_chan_def *chandef);
+			     struct cfg80211_chan_def *chandef,
+			     bool p2p_go);
 
 /*
  * cfg80211_ch_switch_notify - update wdev channel and notify userspace
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ea7b9c2..1e0fac1 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -82,7 +82,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
 	chandef = ifibss->chandef;
-	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
+	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef, false)) {
 		chandef.width = NL80211_CHAN_WIDTH_20;
 		chandef.center_freq1 = chan->center_freq;
 	}
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index de76078..d9e2be7 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -102,6 +102,16 @@ config CFG80211_REG_CELLULAR_HINTS
 	  This option adds support for drivers that can receive regulatory
 	  hints from cellular base stations
 
+config CFG80211_REG_SOFT_CONFIGURATIONS
+	bool "cfg80211 support for GO operation on additional channels"
+	depends on CFG80211 && CFG80211_CERTIFICATION_ONUS
+	---help---
+	  This option enables the operation of a P2P Group Owner on
+	  additional channels, if there is a clear assessment that
+	  the platform device operates in an indoor environment or
+	  in case that there is an additional BSS interface which is
+	  connected to an AP which is an indoor device.
+
 config CFG80211_DEFAULT_PS
 	bool "enable powersave by default"
 	depends on CFG80211
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 50f6195..92d9e3c 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -457,18 +457,102 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(cfg80211_chandef_usable);
 
+#ifdef CPTCFG_CFG80211_REG_SOFT_CONFIGURATIONS
+static int cfg80211_get_unii_band(int freq)
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
+#endif
+
+/* For GO only, check if the channel can be used under permissive conditions
+ * mandated by the FCC, i.e., the channel is marked as:
+ * 1. Indoor only: a GO can be operational on such a channel, iff there is
+ *    clear assessment that the platform device is indoor.
+ * 2. Concurrent GO: a GO can be operational on such a channel, iff there is an
+ *    additional station interface connected to an AP on this channel.
+ *
+ * TODO: The function is too permissive, as it does not verify the platform
+ * device type is indeed indoor, or that the AP is indoor/AC powered.
+ */
+static bool cfg80211_can_go_use_chan(struct cfg80211_registered_device *rdev,
+				     struct ieee80211_channel *chan)
+{
+#ifdef CPTCFG_CFG80211_REG_SOFT_CONFIGURATIONS
+	struct wireless_dev *wdev_iter;
+
+	ASSERT_RTNL();
+
+	if (!(chan->flags & (IEEE80211_CHAN_INDOOR_ONLY |
+			     IEEE80211_CHAN_GO_CONCURRENT)))
+		return false;
+
+	if (chan->band == IEEE80211_BAND_60GHZ)
+		return false;
+
+	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
+		struct ieee80211_channel *other_chan = NULL;
+
+		if (wdev_iter->iftype != NL80211_IFTYPE_STATION ||
+		    (!netif_running(wdev_iter->netdev)))
+				continue;
+
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
+		else if ((chan->band == IEEE80211_BAND_5GHZ) &&
+			 (cfg80211_get_unii_band(chan->center_freq) ==
+			  cfg80211_get_unii_band(other_chan->center_freq)))
+			return true;
+	}
+#endif
+	return false;
+}
+
 bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
-			     struct cfg80211_chan_def *chandef)
+			     struct cfg80211_chan_def *chandef,
+			     bool p2p_go)
 {
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	bool res;
+	u32 flags;
 
-	trace_cfg80211_reg_can_beacon(wiphy, chandef);
+	trace_cfg80211_reg_can_beacon(wiphy, chandef, p2p_go);
+
+	flags = IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_RADAR;
+
+	/* Under certain conditions a GO can operate on channels marked
+	 * with IEEE80211_CHAN_PASSIVE_SCAN and IEEE80211_CHAN_NO_IBSS, so set
+	 * these flags only if the conditions are not met.
+	 */
+	if (!p2p_go || !cfg80211_can_go_use_chan(rdev, chandef->chan))
+		flags |= IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_IBSS;
 
-	res = cfg80211_chandef_usable(wiphy, chandef,
-				      IEEE80211_CHAN_DISABLED |
-				      IEEE80211_CHAN_PASSIVE_SCAN |
-				      IEEE80211_CHAN_NO_IBSS |
-				      IEEE80211_CHAN_RADAR);
+	res = cfg80211_chandef_usable(wiphy, chandef, flags);
 
 	trace_cfg80211_return_bool(res);
 	return res;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 30c4920..746c8b4 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -172,7 +172,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		setup->basic_rates = ieee80211_mandatory_rates(sband);
 	}
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef, false))
 		return -EINVAL;
 
 	err = cfg80211_can_use_chan(rdev, wdev, setup->chandef.chan,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cf22b22..204c160 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1801,7 +1801,8 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 			result = -EBUSY;
 			break;
 		}
-		if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef)) {
+		if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef,
+					     iftype == NL80211_IFTYPE_P2P_GO)) {
 			result = -EINVAL;
 			break;
 		}
@@ -3150,7 +3151,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	} else if (!nl80211_get_ap_channel(rdev, &params))
 		return -EINVAL;
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef,
+				     wdev->iftype == NL80211_IFTYPE_P2P_GO))
 		return -EINVAL;
 
 	err = cfg80211_chandef_dfs_required(wdev->wiphy, &params.chandef);
@@ -6319,7 +6321,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef, false))
 		return -EINVAL;
 
 	switch (ibss.chandef.width) {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index e1534baf..7be32c3 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2115,18 +2115,21 @@ TRACE_EVENT(cfg80211_cqm_rssi_notify,
 );
 
 TRACE_EVENT(cfg80211_reg_can_beacon,
-	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef),
-	TP_ARGS(wiphy, chandef),
+	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef,
+		 bool p2p_go),
+	TP_ARGS(wiphy, chandef, p2p_go),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		CHAN_DEF_ENTRY
+		__field(bool, p2p_go)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		CHAN_DEF_ASSIGN(chandef);
+		__entry->p2p_go = p2p_go;
 	),
-	TP_printk(WIPHY_PR_FMT ", " CHAN_DEF_PR_FMT,
-		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG)
+	TP_printk(WIPHY_PR_FMT ", " CHAN_DEF_PR_FMT ", p2p_go=%d",
+		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG, __entry->p2p_go)
 );
 
 TRACE_EVENT(cfg80211_chandef_dfs_required,
-- 
1.7.10.4

