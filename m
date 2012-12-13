Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:47081 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab2LMN7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 08:59:05 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 2/8] cfg/mac80211: add dfs capability to cfg80211_reg_can_beacon()
Date: Thu, 13 Dec 2012 14:58:27 +0100
Message-Id: <1355407113-27006-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121213_145924_814787_8400F8C9)
In-Reply-To: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When checking if the channel can be used for beacons, the decision
should be made depending on whether DFS is supported.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 include/net/cfg80211.h |    4 +++-
 net/mac80211/ibss.c    |    2 +-
 net/wireless/chan.c    |   18 +++++++++++-------
 net/wireless/mesh.c    |    2 +-
 net/wireless/nl80211.c |    7 ++++---
 net/wireless/trace.h   |   11 +++++++----
 6 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8e6a6b7..1d22919 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3684,12 +3684,14 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
  * cfg80211_reg_can_beacon - check if beaconing is allowed
  * @wiphy: the wiphy
  * @chandef: the channel definition
+ * @dfs_capab: supported DFS bandwidth
  *
  * This function returns true if there is no secondary channel or the secondary
  * channel(s) can be used for beaconing (i.e. is not a radar channel etc.)
  */
 bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
-			     struct cfg80211_chan_def *chandef);
+			     struct cfg80211_chan_def *chandef,
+			     enum nl80211_chan_width dfs_capab);
 
 /*
  * cfg80211_ch_switch_notify - update wdev channel and notify userspace
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 8881fc7..8509386 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -80,7 +80,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
 	cfg80211_chandef_create(&chandef, chan, ifibss->channel_type);
-	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
+	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef, -1)) {
 		chandef.width = NL80211_CHAN_WIDTH_20;
 		chandef.center_freq1 = chan->center_freq;
 	}
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index a7990bb..18888f6 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -280,17 +280,21 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 EXPORT_SYMBOL(cfg80211_chandef_usable);
 
 bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
-			     struct cfg80211_chan_def *chandef)
+			     struct cfg80211_chan_def *chandef,
+			     enum nl80211_chan_width dfs_capab)
 {
 	bool res;
+	u32 prohibited_flags;
 
-	trace_cfg80211_reg_can_beacon(wiphy, chandef);
+	trace_cfg80211_reg_can_beacon(wiphy, chandef, dfs_capab);
 
-	res = cfg80211_chandef_usable(wiphy, chandef,
-				      IEEE80211_CHAN_DISABLED |
-				      IEEE80211_CHAN_PASSIVE_SCAN |
-				      IEEE80211_CHAN_NO_IBSS |
-				      IEEE80211_CHAN_RADAR);
+	prohibited_flags = IEEE80211_CHAN_DISABLED;
+	if (chandef->width > dfs_capab)
+		prohibited_flags |= IEEE80211_CHAN_PASSIVE_SCAN |
+				    IEEE80211_CHAN_NO_IBSS |
+				    IEEE80211_CHAN_RADAR;
+
+	res = cfg80211_chandef_usable(wiphy, chandef, prohibited_flags);
 
 	trace_cfg80211_return_bool(res);
 	return res;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index f9d6ce5..798477b 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -150,7 +150,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		setup->chandef.center_freq1 = setup->chandef.chan->center_freq;
 	}
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef, -1))
 		return -EINVAL;
 
 	err = cfg80211_can_use_chan(rdev, wdev, setup->chandef.chan,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f45706a..aeea068 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1453,7 +1453,7 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 			result = -EBUSY;
 			break;
 		}
-		if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef)) {
+		if (!cfg80211_reg_can_beacon(&rdev->wiphy, &chandef, -1)) {
 			result = -EINVAL;
 			break;
 		}
@@ -2713,7 +2713,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	} else if (!nl80211_get_ap_channel(rdev, &params))
 		return -EINVAL;
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef,
+				     -1))
 		return -EINVAL;
 
 	mutex_lock(&rdev->devlist_mtx);
@@ -5504,7 +5505,7 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef))
+	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef, -1))
 		return -EINVAL;
 
 	if (ibss.chandef.width > NL80211_CHAN_WIDTH_40)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 2134576..e311e49 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2019,18 +2019,21 @@ TRACE_EVENT(cfg80211_cqm_rssi_notify,
 );
 
 TRACE_EVENT(cfg80211_reg_can_beacon,
-	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef),
-	TP_ARGS(wiphy, chandef),
+	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef,
+		 enum nl80211_chan_width dfs_capab),
+	TP_ARGS(wiphy, chandef, dfs_capab),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		CHAN_DEF_ENTRY
+		__field(int, dfs_capab)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		CHAN_DEF_ASSIGN(chandef);
+		__entry->dfs_capab = dfs_capab;
 	),
-	TP_printk(WIPHY_PR_FMT ", " CHAN_DEF_PR_FMT,
-		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG)
+	TP_printk(WIPHY_PR_FMT ", " CHAN_DEF_PR_FMT " dfs_capability: %d",
+		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG, __entry->dfs_capab)
 );
 
 TRACE_EVENT(cfg80211_ch_switch_notify,
-- 
1.7.10.4

