Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18453 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaCKOSB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 10:18:01 -0400
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, andrei.otcheretianski@intel.com,
	eliad@wizery.com
Subject: [PATCH v10 2/5] cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()
Date: Tue, 11 Mar 2014 16:16:31 +0200
Message-Id: <1394547394-3910-3-git-send-email-luciano.coelho@intel.com> (sfid-20140311_151806_188979_94510444)
In-Reply-To: <1394547394-3910-1-git-send-email-luciano.coelho@intel.com>
References: <1394547394-3910-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some interface types don't require DFS (such as STATION, P2P_CLIENT
etc).  In order to centralize these decisions, make
cfg80211_chandef_dfs_required() take the iftype into consideration.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
In v4:

   * rebased on top of slightly modified applied patches
   * removed the double negations when assigning err to a boolean;

In v7:

   * change cfg80211_chandef_dfs_required() back to returning 1 if
     radar detection is needed instead of a bitmap with the width
     required.

In v9:

   * fixed commit message;
   * added braces in a couple of if's that had comments and a
     statement;
   * move NL80211_IFTYPE_UNSPECIFIED to the WARN part of the switch in
     dfs_required) and remove default;

In v10:

   * move NL80211_IFTYPE_UNSPECIFIED up again, so we don't warn, just
     ignore it.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h |  7 +++--
 net/mac80211/ibss.c    | 32 +++++++++++-----------
 net/mac80211/mesh.c    |  9 +++---
 net/wireless/chan.c    | 74 ++++++++++++++++++++++++++++++++++++++------------
 net/wireless/mesh.c    |  7 +++--
 net/wireless/nl80211.c | 37 ++++++++++++-------------
 6 files changed, 104 insertions(+), 62 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 768fcc0..51f278a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -441,10 +441,13 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
  * cfg80211_chandef_dfs_required - checks if radar detection is required
  * @wiphy: the wiphy to validate against
  * @chandef: the channel definition to check
- * Return: 1 if radar detection is required, 0 if it is not, < 0 on error
+ * @iftype: the interface type as specified in &enum nl80211_iftype
+ * Returns:
+ *	1 if radar detection is required, 0 if it is not, < 0 on error
  */
 int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
-				  const struct cfg80211_chan_def *chandef);
+				  const struct cfg80211_chan_def *chandef,
+				  enum nl80211_iftype);
 
 /**
  * ieee80211_chandef_rate_flags - returns rate flags for a channel
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e458ca0..12057fd 100644
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
 
+	radar_required = err;
+
 	mutex_lock(&local->mtx);
 	if (ieee80211_vif_use_channel(sdata, &chandef,
 				      ifibss->fixed_channel ?
@@ -775,7 +774,8 @@ static void ieee80211_ibss_csa_mark_radar(struct ieee80211_sub_if_data *sdata)
 	 * unavailable.
 	 */
 	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
-					    &ifibss->chandef);
+					    &ifibss->chandef,
+					    NL80211_IFTYPE_ADHOC);
 	if (err > 0)
 		cfg80211_radar_event(sdata->local->hw.wiphy, &ifibss->chandef,
 				     GFP_ATOMIC);
@@ -873,17 +873,17 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 
 	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
-					    &params.chandef);
+					    &params.chandef,
+					    NL80211_IFTYPE_ADHOC);
 	if (err < 0)
 		goto disconnect;
-	if (err) {
+	if (err > 0 && !ifibss->userspace_handles_dfs) {
 		/* IBSS-DFS only allowed with a control program */
-		if (!ifibss->userspace_handles_dfs)
-			goto disconnect;
-
-		params.radar_required = true;
+		goto disconnect;
 	}
 
+	params.radar_required = err;
+
 	if (cfg80211_chandef_identical(&params.chandef,
 				       &sdata->vif.bss_conf.chandef)) {
 		ibss_dbg(sdata,
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index f70e9cd..ea0b628 100644
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
+	params.radar_required = err;
 
 	if (cfg80211_chandef_identical(&params.chandef,
 				       &sdata->vif.bss_conf.chandef)) {
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 8659d5c..07bb239 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -326,28 +326,57 @@ static int cfg80211_get_chans_dfs_required(struct wiphy *wiphy,
 
 
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
+	case NL80211_IFTYPE_UNSPECIFIED:
+		break;
+	case NUM_NL80211_IFTYPES:
+		WARN_ON(1);
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL(cfg80211_chandef_dfs_required);
 
@@ -671,7 +700,8 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 
 	trace_cfg80211_reg_can_beacon(wiphy, chandef);
 
-	if (cfg80211_chandef_dfs_required(wiphy, chandef) > 0 &&
+	if (cfg80211_chandef_dfs_required(wiphy, chandef,
+					  NL80211_IFTYPE_UNSPECIFIED) > 0 &&
 	    cfg80211_chandef_dfs_available(wiphy, chandef)) {
 		/* We can skip IEEE80211_CHAN_NO_IR if chandef dfs available */
 		prohibited_flags = IEEE80211_CHAN_DISABLED;
@@ -701,6 +731,8 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 		        enum cfg80211_chan_mode *chanmode,
 		        u8 *radar_detect)
 {
+	int ret;
+
 	*chan = NULL;
 	*chanmode = CHAN_MODE_UNDEFINED;
 
@@ -743,8 +775,11 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 			*chan = wdev->chandef.chan;
 			*chanmode = CHAN_MODE_SHARED;
 
-			if (cfg80211_chandef_dfs_required(wdev->wiphy,
-							  &wdev->chandef))
+			ret = cfg80211_chandef_dfs_required(wdev->wiphy,
+							    &wdev->chandef,
+							    wdev->iftype);
+			WARN_ON(ret < 0);
+			if (ret > 0)
 				*radar_detect |= BIT(wdev->chandef.width);
 		}
 		return;
@@ -753,8 +788,11 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 			*chan = wdev->chandef.chan;
 			*chanmode = CHAN_MODE_SHARED;
 
-			if (cfg80211_chandef_dfs_required(wdev->wiphy,
-							  &wdev->chandef))
+			ret = cfg80211_chandef_dfs_required(wdev->wiphy,
+							    &wdev->chandef,
+							    wdev->iftype);
+			WARN_ON(ret < 0);
+			if (ret > 0)
 				*radar_detect |= BIT(wdev->chandef.width);
 		}
 		return;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 5af5cc6..a95212b 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -178,10 +178,13 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
 		return -EINVAL;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy, &setup->chandef);
+	err = cfg80211_chandef_dfs_required(wdev->wiphy,
+					    &setup->chandef,
+					    NL80211_IFTYPE_MESH_POINT);
 	if (err < 0)
 		return err;
-	if (err)
+
+	if (err > 0)
 		radar_detect_width = BIT(setup->chandef.width);
 
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 052c1bf..9fe7746 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3261,12 +3261,15 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy, &params.chandef);
+	err = cfg80211_chandef_dfs_required(wdev->wiphy,
+					    &params.chandef,
+					    NL80211_IFTYPE_AP);
 	if (err < 0)
 		return err;
-	if (err) {
-		radar_detect_width = BIT(params.chandef.width);
+
+	if (err > 0) {
 		params.radar_required = true;
+		radar_detect_width = BIT(params.chandef.width);
 	}
 
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
@@ -5796,7 +5799,8 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (wdev->cac_started)
 		return -EBUSY;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef);
+	err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef,
+					    NL80211_IFTYPE_UNSPECIFIED);
 	if (err < 0)
 		return err;
 
@@ -5931,22 +5935,15 @@ skip_beacons:
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
 
-	switch (dev->ieee80211_ptr->iftype) {
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_P2P_GO:
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_MESH_POINT:
-		err = cfg80211_chandef_dfs_required(wdev->wiphy,
-						    &params.chandef);
-		if (err < 0)
-			return err;
-		if (err) {
-			radar_detect_width = BIT(params.chandef.width);
-			params.radar_required = true;
-		}
-		break;
-	default:
-		break;
+	err = cfg80211_chandef_dfs_required(wdev->wiphy,
+					    &params.chandef,
+					    wdev->iftype);
+	if (err < 0)
+		return err;
+
+	if (err > 0) {
+		radar_detect_width = BIT(params.chandef.width);
+		params.radar_required = true;
 	}
 
 	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
-- 
1.9.0

