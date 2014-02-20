Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:35686 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaBTOgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 09:36:35 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Subject: [PATCH v3 5/7] cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()
Date: Thu, 20 Feb 2014 16:36:24 +0200
Message-Id: <1392906986-12275-6-git-send-email-luca@coelho.fi> (sfid-20140220_153644_007669_4268DA8C)
In-Reply-To: <1392906986-12275-1-git-send-email-luca@coelho.fi>
References: <1392906986-12275-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Some interface types don't require DFS (such as STATION, P2P_CLIENT
etc).  In order to centralize these decisions, make
cfg80211_chandef_dfs_required() take the iftype into consideration.

Additionally, the function now returns a bitmap with the channel width
that requires DFS.  This is done to simplify some of the calls.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h |  8 ++++--
 net/mac80211/ibss.c    | 31 ++++++++++----------
 net/mac80211/mesh.c    |  9 +++---
 net/wireless/chan.c    | 77 +++++++++++++++++++++++++++++++++++++-------------
 net/wireless/mesh.c    | 13 +++++----
 net/wireless/nl80211.c | 37 +++++++++++-------------
 6 files changed, 106 insertions(+), 69 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e44d62b..a1ce7cd 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -439,10 +439,14 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
  * cfg80211_chandef_dfs_required - checks if radar detection is required
  * @wiphy: the wiphy to validate against
  * @chandef: the channel definition to check
- * Return: 1 if radar detection is required, 0 if it is not, < 0 on error
+ * @iftype: the interface type as specified in &enum nl80211_iftype
+ * Returns:
+ *	the channel bandwidth bitmask if radar detection is required,
+ *	0 if it is not, < 0 on error
  */
 int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
-				  const struct cfg80211_chan_def *chandef);
+				  const struct cfg80211_chan_def *chandef,
+				  enum nl80211_iftype);
 
 /**
  * ieee80211_chandef_rate_flags - returns rate flags for a channel
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index b558468..56b0dce 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -228,7 +228,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct beacon_data *presp;
 	enum nl80211_bss_scan_width scan_width;
 	bool have_higher_than_11mbit;
-	bool radar_required = false;
+	bool radar_required;
 	int err;
 
 	sdata_assert_lock(sdata);
@@ -282,21 +282,20 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	}
 
 	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
-					    &chandef);
+					    &chandef, NL80211_IFTYPE_ADHOC);
 	if (err < 0) {
 		sdata_info(sdata,
 			   "Failed to join IBSS, invalid chandef\n");
 		return;
 	}
-	if (err > 0) {
-		if (!ifibss->userspace_handles_dfs) {
-			sdata_info(sdata,
-				   "Failed to join IBSS, DFS channel without control program\n");
-			return;
-		}
-		radar_required = true;
+	if (err > 0 && !ifibss->userspace_handles_dfs) {
+		sdata_info(sdata,
+			   "Failed to join IBSS, DFS channel without control program\n");
+		return;
 	}
 
+	radar_required = !!(err);
+
 	mutex_lock(&local->mtx);
 	if (ieee80211_vif_use_channel(sdata, &chandef,
 				      ifibss->fixed_channel ?
@@ -778,7 +777,8 @@ static void ieee80211_ibss_csa_mark_radar(struct ieee80211_sub_if_data *sdata)
 	 * unavailable.
 	 */
 	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
-					    &ifibss->chandef);
+					    &ifibss->chandef,
+					    NL80211_IFTYPE_ADHOC);
 	if (err > 0)
 		cfg80211_radar_event(sdata->local->hw.wiphy, &ifibss->chandef,
 				     GFP_ATOMIC);
@@ -876,16 +876,15 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 
 	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
-					    &params.chandef);
+					    &params.chandef,
+					    NL80211_IFTYPE_ADHOC);
 	if (err < 0)
 		goto disconnect;
-	if (err) {
+	if (err > 0 && !ifibss->userspace_handles_dfs)
 		/* IBSS-DFS only allowed with a control program */
-		if (!ifibss->userspace_handles_dfs)
-			goto disconnect;
+		goto disconnect;
 
-		params.radar_required = true;
-	}
+	params.radar_required = !!(err);
 
 	if (cfg80211_chandef_identical(&params.chandef,
 				       &sdata->vif.bss_conf.chandef)) {
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index f70e9cd..05eb540 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -903,14 +903,15 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	}
 
 	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
-					    &params.chandef);
+					    &params.chandef,
+					    NL80211_IFTYPE_MESH_POINT);
 	if (err < 0)
 		return false;
-	if (err) {
-		params.radar_required = true;
+	if (err > 0)
 		/* TODO: DFS not (yet) supported */
 		return false;
-	}
+
+	params.radar_required = !!(err);
 
 	if (cfg80211_chandef_identical(&params.chandef,
 				       &sdata->vif.bss_conf.chandef)) {
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 5946450..f4b59a0 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -326,28 +326,58 @@ static int cfg80211_get_chans_dfs_required(struct wiphy *wiphy,
 
 
 int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
-				  const struct cfg80211_chan_def *chandef)
+				  const struct cfg80211_chan_def *chandef,
+				  enum nl80211_iftype iftype)
 {
 	int width;
-	int r;
+	int ret;
 
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
 		return -EINVAL;
 
-	width = cfg80211_chandef_get_width(chandef);
-	if (width < 0)
-		return -EINVAL;
+	switch (iftype) {
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_MESH_POINT:
+		width = cfg80211_chandef_get_width(chandef);
+		if (width < 0)
+			return -EINVAL;
 
-	r = cfg80211_get_chans_dfs_required(wiphy, chandef->center_freq1,
-					    width);
-	if (r)
-		return r;
+		ret = cfg80211_get_chans_dfs_required(wiphy,
+						      chandef->center_freq1,
+						      width);
+		if (ret < 0)
+			return ret;
+		else if (ret > 0)
+			return BIT(chandef->width);
 
-	if (!chandef->center_freq2)
-		return 0;
+		if (!chandef->center_freq2)
+			return 0;
+
+		ret = cfg80211_get_chans_dfs_required(wiphy,
+						      chandef->center_freq2,
+						      width);
+		if (ret < 0)
+			return ret;
+		else if (ret > 0)
+			return BIT(chandef->width);
 
-	return cfg80211_get_chans_dfs_required(wiphy, chandef->center_freq2,
-					       width);
+		break;
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_WDS:
+	case NL80211_IFTYPE_P2P_DEVICE:
+		break;
+	case NUM_NL80211_IFTYPES:
+	default:
+		WARN_ON(1);
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL(cfg80211_chandef_dfs_required);
 
@@ -615,7 +645,8 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 
 	trace_cfg80211_reg_can_beacon(wiphy, chandef);
 
-	if (cfg80211_chandef_dfs_required(wiphy, chandef) > 0 &&
+	if (cfg80211_chandef_dfs_required(wiphy, chandef,
+					  NL80211_IFTYPE_UNSPECIFIED) > 0 &&
 	    cfg80211_chandef_dfs_available(wiphy, chandef)) {
 		/* We can skip IEEE80211_CHAN_NO_IR if chandef dfs available */
 		prohibited_flags = IEEE80211_CHAN_DISABLED;
@@ -645,6 +676,8 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 		        enum cfg80211_chan_mode *chanmode,
 		        u8 *radar_detect)
 {
+	int ret;
+
 	*chan = NULL;
 	*chanmode = CHAN_MODE_UNDEFINED;
 
@@ -687,9 +720,11 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 			*chan = wdev->chandef.chan;
 			*chanmode = CHAN_MODE_SHARED;
 
-			if (cfg80211_chandef_dfs_required(wdev->wiphy,
-							  &wdev->chandef))
-				*radar_detect |= BIT(wdev->chandef.width);
+			ret = cfg80211_chandef_dfs_required(wdev->wiphy,
+							    &wdev->chandef,
+							    wdev->iftype);
+			WARN_ON(ret < 0);
+			*radar_detect |= ret;
 		}
 		return;
 	case NL80211_IFTYPE_MESH_POINT:
@@ -697,9 +732,11 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 			*chan = wdev->chandef.chan;
 			*chanmode = CHAN_MODE_SHARED;
 
-			if (cfg80211_chandef_dfs_required(wdev->wiphy,
-							  &wdev->chandef))
-				*radar_detect |= BIT(wdev->chandef.width);
+			ret = cfg80211_chandef_dfs_required(wdev->wiphy,
+							    &wdev->chandef,
+							    wdev->iftype);
+			WARN_ON(ret < 0);
+			*radar_detect |= ret;
 		}
 		return;
 	case NL80211_IFTYPE_MONITOR:
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 5af5cc6..c9458f2 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -99,7 +99,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 			 const struct mesh_config *conf)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	u8 radar_detect_width = 0;
+	u8 radar_detect_width;
 	int err;
 
 	BUILD_BUG_ON(IEEE80211_MAX_SSID_LEN != IEEE80211_MAX_MESH_ID_LEN);
@@ -178,11 +178,12 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
 		return -EINVAL;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy, &setup->chandef);
-	if (err < 0)
-		return err;
-	if (err)
-		radar_detect_width = BIT(setup->chandef.width);
+	radar_detect_width =
+		cfg80211_chandef_dfs_required(wdev->wiphy,
+					      &setup->chandef,
+					      NL80211_IFTYPE_MESH_POINT);
+	if (radar_detect_width < 0)
+		return radar_detect_width;
 
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   setup->chandef.chan,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b78d734..09ef2e1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3255,13 +3255,13 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy, &params.chandef);
-	if (err < 0)
-		return err;
-	if (err) {
-		radar_detect_width = BIT(params.chandef.width);
-		params.radar_required = true;
-	}
+	radar_detect_width = cfg80211_chandef_dfs_required(wdev->wiphy,
+							   &params.chandef,
+							   NL80211_IFTYPE_AP);
+	if (radar_detect_width < 0)
+		return radar_detect_width;
+
+	params.radar_required = !!(err);
 
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   params.chandef.chan,
@@ -5781,7 +5781,8 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (wdev->cac_started)
 		return -EBUSY;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef);
+	err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef,
+					    NL80211_IFTYPE_UNSPECIFIED);
 	if (err < 0)
 		return err;
 
@@ -5910,19 +5911,13 @@ skip_beacons:
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
 
-	if (dev->ieee80211_ptr->iftype == NL80211_IFTYPE_AP ||
-	    dev->ieee80211_ptr->iftype == NL80211_IFTYPE_P2P_GO ||
-	    dev->ieee80211_ptr->iftype == NL80211_IFTYPE_ADHOC ||
-	    dev->ieee80211_ptr->iftype == NL80211_IFTYPE_MESH_POINT) {
-		err = cfg80211_chandef_dfs_required(wdev->wiphy,
-						    &params.chandef);
-		if (err < 0) {
-			return err;
-		} else if (err) {
-			radar_detect_width = BIT(params.chandef.width);
-			params.radar_required = true;
-		}
-	}
+	radar_detect_width = cfg80211_chandef_dfs_required(wdev->wiphy,
+							   &params.chandef,
+							   wdev->iftype);
+	if (radar_detect_width < 0)
+		return radar_detect_width;
+
+	params.radar_required = !!(radar_detect_width);
 
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   params.chandef.chan,
-- 
1.8.5.3

