Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:42146 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaATOOI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 09:14:08 -0500
Received: by mail-ee0-f49.google.com with SMTP id d17so3502499eek.36
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 06:14:07 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] cfg80211: implement multi-vif interface combination validation
Date: Mon, 20 Jan 2014 15:09:27 +0100
Message-Id: <1390226968-18928-3-git-send-email-michal.kazior@tieto.com> (sfid-20140120_151422_918032_3113B1BC)
In-Reply-To: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This refactors cfg80211_can_use_iftype_chan() so
that it can process multi-interface combination
changes.

With this it will be possible to handle, e.g.
multi-BSS channel switching.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/core.h |  36 ++++++++--
 net/wireless/util.c | 198 ++++++++++++++++++++++++++++++++--------------------
 2 files changed, 152 insertions(+), 82 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 37ec16d..faad3e9 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -226,6 +226,14 @@ enum cfg80211_chan_mode {
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
@@ -372,12 +380,9 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
 void cfg80211_process_wdev_events(struct wireless_dev *wdev);
 
-int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
-				 struct wireless_dev *wdev,
-				 enum nl80211_iftype iftype,
-				 struct ieee80211_channel *chan,
-				 enum cfg80211_chan_mode chanmode,
-				 u8 radar_detect);
+int cfg80211_can_use_iftype_chan_params(struct cfg80211_registered_device *rdev,
+				const struct cfg80211_iftype_chan_param *params,
+				int num_params);
 
 /**
  * cfg80211_chandef_dfs_usable - checks if chandef is DFS usable
@@ -400,6 +405,25 @@ void cfg80211_dfs_channels_update_work(struct work_struct *work);
 
 
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
index d39c371..c4cac9e 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1252,30 +1252,11 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 	return res;
 }
 
-int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
-				 struct wireless_dev *wdev,
-				 enum nl80211_iftype iftype,
-				 struct ieee80211_channel *chan,
-				 enum cfg80211_chan_mode chanmode,
-				 u8 radar_detect)
+static int cfg80211_is_radar_required(enum nl80211_iftype iftype,
+				      struct ieee80211_channel *chan,
+				      enum cfg80211_chan_mode chanmode,
+				      u8 radar_detect_width)
 {
-	struct wireless_dev *wdev_iter;
-	u32 used_iftypes = BIT(iftype);
-	int num[NUM_NL80211_IFTYPES];
-	struct ieee80211_channel
-			*used_channels[CFG80211_MAX_NUM_DIFFERENT_CHANNELS];
-	struct ieee80211_channel *ch;
-	enum cfg80211_chan_mode chmode;
-	int num_different_channels = 0;
-	int total = 1;
-	bool radar_required = false;
-	int i, j;
-
-	ASSERT_RTNL();
-
-	if (WARN_ON(hweight32(radar_detect) > 1))
-		return -EINVAL;
-
 	switch (iftype) {
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_AP:
@@ -1283,58 +1264,132 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_WDS:
-		/* if the interface could potentially choose a DFS channel,
-		 * then mark DFS as required.
-		 */
-		if (!chan) {
-			if (chanmode != CHAN_MODE_UNDEFINED && radar_detect)
-				radar_required = true;
-			break;
-		}
-		radar_required = !!(chan->flags & IEEE80211_CHAN_RADAR);
-		break;
+		/* if the interface could potentially choose a DFS
+		 * channel, then mark DFS as required. */
+		if (!chan)
+			return (chanmode != CHAN_MODE_UNDEFINED &&
+				radar_detect_width) ? 1 : 0;
+
+		return (chan->flags & IEEE80211_CHAN_RADAR) ? 1 : 0;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_DEVICE:
 	case NL80211_IFTYPE_MONITOR:
-		break;
+		return 0;
 	case NUM_NL80211_IFTYPES:
 	case NL80211_IFTYPE_UNSPECIFIED:
 	default:
 		return -EINVAL;
 	}
+}
 
-	if (radar_required && !radar_detect)
-		return -EINVAL;
-
-	/* Always allow software iftypes */
-	if (rdev->wiphy.software_iftypes & BIT(iftype)) {
-		if (radar_detect)
-			return -EINVAL;
-		return 0;
-	}
-
-	memset(num, 0, sizeof(num));
-	memset(used_channels, 0, sizeof(used_channels));
-
-	num[iftype] = 1;
+static int cfg80211_add_used_chan(struct ieee80211_channel **used_chans,
+				  int *num_diff_chans,
+				  int max_num_diff_chans,
+				  struct ieee80211_channel *chan,
+				  enum cfg80211_chan_mode chanmode)
+{
+	int i;
 
 	switch (chanmode) {
 	case CHAN_MODE_UNDEFINED:
 		break;
 	case CHAN_MODE_SHARED:
-		WARN_ON(!chan);
-		used_channels[0] = chan;
-		num_different_channels++;
+		if (WARN_ON(!chan))
+			return -EINVAL;
+
+		for (i = 0; i < max_num_diff_chans; i++)
+			if (!used_chans[i] || used_chans[i] == chan)
+				break;
+
+		if (i == max_num_diff_chans)
+			return -EBUSY;
+
+		if (used_chans[i] == NULL) {
+			used_chans[i] = chan;
+			(*num_diff_chans)++;
+		}
 		break;
 	case CHAN_MODE_EXCLUSIVE:
-		num_different_channels++;
+		(*num_diff_chans)++;
 		break;
 	}
 
+	return 0;
+}
+
+int cfg80211_can_use_iftype_chan_params(struct cfg80211_registered_device *rdev,
+				const struct cfg80211_iftype_chan_param *params,
+				int num_params)
+{
+	struct wireless_dev *wdev_iter;
+	u32 used_iftypes = 0;
+	int num[NUM_NL80211_IFTYPES];
+	struct ieee80211_channel
+			*used_channels[CFG80211_MAX_NUM_DIFFERENT_CHANNELS];
+	struct ieee80211_channel *ch;
+	enum cfg80211_chan_mode chmode;
+	int num_different_channels = 0;
+	int total = num_params;
+	bool num_software_iftypes = 0;
+	int err, i, j;
+
+	ASSERT_RTNL();
+
+	memset(num, 0, sizeof(num));
+	memset(used_channels, 0, sizeof(used_channels));
+
+	for (i = 0; i < num_params; i++) {
+		if (WARN_ON(hweight32(params[i].radar_detect_width) > 1))
+			return -EINVAL;
+
+		/* sanity check - make sure all wdevs in params[] are unique */
+		for (j = 0; j < num_params; j++)
+			if (WARN_ON(i != j && params[i].wdev == params[j].wdev))
+				return -EINVAL;
+
+		if (params[i].wdev && params[i].wdev->wiphy != &rdev->wiphy)
+			return -EINVAL;
+
+		used_iftypes |= BIT(params[i].iftype);
+		num[params[i].iftype]++;
+
+		err = cfg80211_is_radar_required(params[i].iftype,
+						 params[i].chan,
+						 params[i].chanmode,
+						 params[i].radar_detect_width);
+		if (err < 0)
+			return err;
+		else if (err && !params[i].radar_detect_width)
+			return -EINVAL;
+
+		if (rdev->wiphy.software_iftypes & BIT(params[i].iftype)) {
+			num_software_iftypes++;
+			if (params[i].radar_detect_width)
+				return -EINVAL;
+		}
+
+		err = cfg80211_add_used_chan(used_channels,
+					     &num_different_channels,
+					     ARRAY_SIZE(used_channels),
+					     params[i].chan,
+					     params[i].chanmode);
+		if (err)
+			return err;
+	}
+
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
@@ -1359,38 +1414,25 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		cfg80211_get_chan_state(wdev_iter, &ch, &chmode);
 		wdev_unlock(wdev_iter);
 
-		switch (chmode) {
-		case CHAN_MODE_UNDEFINED:
-			break;
-		case CHAN_MODE_SHARED:
-			for (i = 0; i < CFG80211_MAX_NUM_DIFFERENT_CHANNELS; i++)
-				if (!used_channels[i] || used_channels[i] == ch)
-					break;
-
-			if (i == CFG80211_MAX_NUM_DIFFERENT_CHANNELS)
-				return -EBUSY;
-
-			if (used_channels[i] == NULL) {
-				used_channels[i] = ch;
-				num_different_channels++;
-			}
-			break;
-		case CHAN_MODE_EXCLUSIVE:
-			num_different_channels++;
-			break;
-		}
+		err = cfg80211_add_used_chan(used_channels,
+					     &num_different_channels,
+					     ARRAY_SIZE(used_channels),
+					     ch, chmode);
+		if (err)
+			return err;
 
 		num[wdev_iter->iftype]++;
 		total++;
 		used_iftypes |= BIT(wdev_iter->iftype);
 	}
 
-	if (total == 1 && !radar_detect)
+	if (total == 1 && num_params == 1 && !params[0].radar_detect_width)
 		return 0;
 
 	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
 		const struct ieee80211_iface_combination *c;
 		struct ieee80211_iface_limit *limits;
+		enum nl80211_iftype iftype;
 		u32 all_iftypes = 0;
 
 		c = &rdev->wiphy.iface_combinations[i];
@@ -1418,8 +1460,12 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 			}
 		}
 
-		if (radar_detect && !(c->radar_detect_widths & radar_detect))
-			goto cont;
+		for (j = 0; j < num_params; j++) {
+			if (params[j].radar_detect_width &&
+			    !(c->radar_detect_widths &
+			      params[j].radar_detect_width))
+				goto cont;
+		}
 
 		/*
 		 * Finally check that all iftypes that we're currently
-- 
1.8.4.rc3

