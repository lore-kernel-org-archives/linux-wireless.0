Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:38459 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbaAHPbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 10:31:18 -0500
Received: by mail-ea0-f169.google.com with SMTP id l9so751497eaj.28
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jan 2014 07:31:16 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 3/4] cfg80211: implement multi-vif interface combination validation
Date: Wed,  8 Jan 2014 16:26:57 +0100
Message-Id: <1389194818-7864-4-git-send-email-michal.kazior@tieto.com> (sfid-20140108_163123_799648_3A27AD0F)
In-Reply-To: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
References: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This refactors cfg80211_can_use_iftype_chan() so
that it can process multi-interface combination
changes.

With this it will be possible to handle, e.g.
multi-BSS channel switching.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/core.h |  36 ++++++++++--
 net/wireless/util.c | 158 ++++++++++++++++++++++++++++++++--------------------
 2 files changed, 127 insertions(+), 67 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 38f74fe..ee19118 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -228,6 +228,14 @@ enum cfg80211_chan_mode {
 	CHAN_MODE_EXCLUSIVE,
 };
 
+struct cfg80211_iftype_chan_param {
+	struct wireless_dev *wdev;
+	enum nl80211_iftype iftype;
+	struct ieee80211_channel *chan;
+	enum cfg80211_chan_mode chanmode;
+	u8 radar_detect_width;
+};
+
 struct cfg80211_beacon_registration {
 	struct list_head list;
 	u32 nlportid;
@@ -374,12 +382,9 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
 void cfg80211_process_wdev_events(struct wireless_dev *wdev);
 
-int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
-				 struct wireless_dev *wdev,
-				 enum nl80211_iftype iftype,
-				 struct ieee80211_channel *chan,
-				 enum cfg80211_chan_mode chanmode,
-				 u8 radar_detect_width);
+int cfg80211_can_use_iftype_chan_params(struct cfg80211_registered_device *rdev,
+					const struct cfg80211_iftype_chan_param *params,
+					int num_params);
 
 /**
  * cfg80211_chandef_dfs_usable - checks if chandef is DFS usable
@@ -402,6 +407,25 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work);
 
 
 static inline int
+cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
+			     struct wireless_dev *wdev,
+			     enum nl80211_iftype iftype,
+			     struct ieee80211_channel *chan,
+			     enum cfg80211_chan_mode chanmode,
+			     u8 radar_detect_width)
+{
+	struct cfg80211_iftype_chan_param param = {
+		.wdev = wdev,
+		.iftype = iftype,
+		.chan = chan,
+		.chanmode = chanmode,
+		.radar_detect_width = radar_detect_width,
+	};
+
+	return cfg80211_can_use_iftype_chan_params(rdev, &param, 1);
+}
+
+static inline int
 cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev,
 			      enum nl80211_iftype iftype)
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 41013f1..099f1da 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1233,89 +1233,118 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 	return res;
 }
 
-int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
-				 struct wireless_dev *wdev,
-				 enum nl80211_iftype iftype,
-				 struct ieee80211_channel *chan,
-				 enum cfg80211_chan_mode chanmode,
-				 u8 radar_detect_width)
+int cfg80211_can_use_iftype_chan_params(struct cfg80211_registered_device *rdev,
+					const struct cfg80211_iftype_chan_param *params,
+					int num_params)
 {
 	struct wireless_dev *wdev_iter;
-	u32 used_iftypes = BIT(iftype);
+	u32 used_iftypes = 0;
 	int num[NUM_NL80211_IFTYPES];
 	struct ieee80211_channel
 			*used_channels[CFG80211_MAX_NUM_DIFFERENT_CHANNELS];
 	struct ieee80211_channel *ch;
 	enum cfg80211_chan_mode chmode;
 	int num_different_channels = 0;
-	int total = 1;
+	int total = num_params;
 	bool radar_required = false;
+	bool num_software_iftypes = 0;
 	int i, j;
 
 	ASSERT_RTNL();
 
-	if (WARN_ON(hweight32(radar_detect_width) > 1))
-		return -EINVAL;
+	memset(num, 0, sizeof(num));
+	memset(used_channels, 0, sizeof(used_channels));
 
-	switch (iftype) {
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_AP:
-	case NL80211_IFTYPE_AP_VLAN:
-	case NL80211_IFTYPE_MESH_POINT:
-	case NL80211_IFTYPE_P2P_GO:
-	case NL80211_IFTYPE_WDS:
-		/* if the interface could potentially choose a DFS channel,
-		 * then mark DFS as required.
-		 */
-		if (!chan) {
-			if (chanmode != CHAN_MODE_UNDEFINED && radar_detect_width)
-				radar_required = true;
+	for (i = 0; i < num_params; i++) {
+		if (WARN_ON(hweight32(params[i].radar_detect_width) > 1))
+			return -EINVAL;
+
+		/* sanity check - make sure all wdevs in params[] are unique */
+		for (j = 0; j < num_params; j++)
+			if (WARN_ON(i != j && params[i].wdev == params[j].wdev))
+				return -EINVAL;
+
+		radar_required = false;
+		used_iftypes |= BIT(params[i].iftype);
+
+		switch (params[i].iftype) {
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_AP_VLAN:
+		case NL80211_IFTYPE_MESH_POINT:
+		case NL80211_IFTYPE_P2P_GO:
+		case NL80211_IFTYPE_WDS:
+			/* if the interface could potentially choose a DFS channel,
+			 * then mark DFS as required.
+			 */
+			if (!params[i].chan) {
+				if (params[i].chanmode != CHAN_MODE_UNDEFINED &&
+				    params[i].radar_detect_width)
+					radar_required = true;
+				break;
+			}
+			radar_required = !!(params[i].chan->flags & IEEE80211_CHAN_RADAR);
+			break;
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_STATION:
+		case NL80211_IFTYPE_P2P_DEVICE:
+		case NL80211_IFTYPE_MONITOR:
 			break;
+		case NUM_NL80211_IFTYPES:
+		case NL80211_IFTYPE_UNSPECIFIED:
+		default:
+			return -EINVAL;
 		}
-		radar_required = !!(chan->flags & IEEE80211_CHAN_RADAR);
-		break;
-	case NL80211_IFTYPE_P2P_CLIENT:
-	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_P2P_DEVICE:
-	case NL80211_IFTYPE_MONITOR:
-		break;
-	case NUM_NL80211_IFTYPES:
-	case NL80211_IFTYPE_UNSPECIFIED:
-	default:
-		return -EINVAL;
-	}
-
-	if (radar_required && !radar_detect_width)
-		return -EINVAL;
 
-	/* Always allow software iftypes */
-	if (rdev->wiphy.software_iftypes & BIT(iftype)) {
-		if (radar_detect_width)
+		if (radar_required && !params[i].radar_detect_width)
 			return -EINVAL;
-		return 0;
-	}
 
-	memset(num, 0, sizeof(num));
-	memset(used_channels, 0, sizeof(used_channels));
+		if (rdev->wiphy.software_iftypes & BIT(params[i].iftype)) {
+			num_software_iftypes++;
+			if (params[i].radar_detect_width)
+				return -EINVAL;
+		}
 
-	num[iftype] = 1;
+		num[params[i].iftype]++;
 
-	switch (chanmode) {
-	case CHAN_MODE_UNDEFINED:
-		break;
-	case CHAN_MODE_SHARED:
-		WARN_ON(!chan);
-		used_channels[0] = chan;
-		num_different_channels++;
-		break;
-	case CHAN_MODE_EXCLUSIVE:
-		num_different_channels++;
-		break;
+		switch (params[i].chanmode) {
+		case CHAN_MODE_UNDEFINED:
+			break;
+		case CHAN_MODE_SHARED:
+			if (WARN_ON(!params[i].chan))
+				return -EINVAL;
+
+			for (j = 0; j < CFG80211_MAX_NUM_DIFFERENT_CHANNELS; j++)
+				if (!used_channels[j] ||
+				    used_channels[j] == params[i].chan)
+					break;
+
+			if (j == CFG80211_MAX_NUM_DIFFERENT_CHANNELS)
+				return -EBUSY;
+
+			if (used_channels[j] == NULL) {
+				used_channels[j] = params[i].chan;
+				num_different_channels++;
+			}
+			break;
+		case CHAN_MODE_EXCLUSIVE:
+			num_different_channels++;
+			break;
+		}
 	}
 
+	/* Always allow software iftypes */
+	if (num_params == num_software_iftypes)
+		return 0;
+
 	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
-		if (wdev_iter == wdev)
+		/* skip wdevs which are in params[] */
+		for (i = 0; i < num_params; i++)
+			if (wdev_iter == params[i].wdev)
+				break;
+		if (i < num_params)
 			continue;
+
 		if (wdev_iter->iftype == NL80211_IFTYPE_P2P_DEVICE) {
 			if (!wdev_iter->p2p_started)
 				continue;
@@ -1366,12 +1395,13 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		used_iftypes |= BIT(wdev_iter->iftype);
 	}
 
-	if (total == 1 && !radar_detect_width)
+	if (total == 1 && num_params == 1 && !params[0].radar_detect_width)
 		return 0;
 
 	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
 		const struct ieee80211_iface_combination *c;
 		struct ieee80211_iface_limit *limits;
+		enum nl80211_iftype iftype;
 		u32 all_iftypes = 0;
 
 		c = &rdev->wiphy.iface_combinations[i];
@@ -1399,8 +1429,14 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 			}
 		}
 
-		if (radar_detect_width && !(c->radar_detect_widths & radar_detect_width))
-			goto cont;
+		for (j = 0; j < num_params; j++) {
+			if (!params[j].radar_detect_width)
+				continue;
+
+			if (!(c->radar_detect_widths &
+			      params[j].radar_detect_width))
+				goto cont;
+		}
 
 		/*
 		 * Finally check that all iftypes that we're currently
-- 
1.8.4.rc3

