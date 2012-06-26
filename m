Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:64975 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554Ab2FZMam (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:30:42 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC v3 12/13] cfg80211: add channel checking for iface combinations
Date: Tue, 26 Jun 2012 14:30:17 +0200
Message-ID: <1340713818-28549-13-git-send-email-michal.kazior@tieto.com> (sfid-20120626_143051_734400_A1501BC5)
In-Reply-To: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com>
References: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

.connect cannot be handled since the driver scans
and connects on its own. It is up to the driver
then to refuse a connection (with -EBUSY for
example).

Non-fixed channel IBSSes always take a single
channel resource. For example two non-fixed
channel IBSSes always take up 2
num_different_channels, even if they operate on
the same channel at a given point of time.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/core.c |    8 +++++++
 net/wireless/core.h |   29 +++++++++++++++++++++++--
 net/wireless/util.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 85 insertions(+), 8 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5b3f74e..2fed61b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -436,6 +436,14 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 		if (WARN_ON(!c->num_different_channels))
 			return -EINVAL;
 
+		/*
+		 * Put a sane limit on maximum number of different
+		 * channels to simplify channel accounting code.
+		 */
+		if (WARN_ON(c->num_different_channels >
+				CFG80211_MAX_NUM_DIFFERENT_CHANNELS))
+			return -EINVAL;
+
 		if (WARN_ON(!c->n_limits))
 			return -EINVAL;
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 9d9441d..63e04f6 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -454,9 +454,20 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			  u32 *flags, struct vif_params *params);
 void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
 
-int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
-				  struct wireless_dev *wdev,
-				  enum nl80211_iftype iftype);
+int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
+				 struct wireless_dev *wdev,
+				 enum nl80211_iftype iftype,
+				 struct ieee80211_channel *chan,
+				 enum cfg80211_chan_mode chanmode);
+
+static inline int
+cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
+			      struct wireless_dev *wdev,
+			      enum nl80211_iftype iftype)
+{
+	return cfg80211_can_use_iftype_chan(rdev, wdev, iftype, NULL,
+					    CHAN_MODE_UNDEFINED);
+}
 
 static inline int
 cfg80211_can_add_interface(struct cfg80211_registered_device *rdev,
@@ -465,6 +476,16 @@ cfg80211_can_add_interface(struct cfg80211_registered_device *rdev,
 	return cfg80211_can_change_interface(rdev, NULL, iftype);
 }
 
+static inline int
+cfg80211_can_use_chan(struct cfg80211_registered_device *rdev,
+		      struct wireless_dev *wdev,
+		      struct ieee80211_channel *chan,
+		      enum cfg80211_chan_mode chanmode)
+{
+	return cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+					    chan, chanmode);
+}
+
 void
 cfg80211_get_chan_state(struct cfg80211_registered_device *rdev,
 		        struct wireless_dev *wdev,
@@ -487,6 +508,8 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype, int num);
 
+#define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
+
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
 #define CFG80211_DEV_WARN_ON(cond)	WARN_ON(cond)
 #else
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 9b92ec5..b8e3f70 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -938,13 +938,20 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 	return res;
 }
 
-int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
-				  struct wireless_dev *wdev,
-				  enum nl80211_iftype iftype)
+int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
+				 struct wireless_dev *wdev,
+				 enum nl80211_iftype iftype,
+				 struct ieee80211_channel *chan,
+				 enum cfg80211_chan_mode chanmode)
 {
 	struct wireless_dev *wdev_iter;
 	u32 used_iftypes = BIT(iftype);
 	int num[NUM_NL80211_IFTYPES];
+	struct ieee80211_channel
+			*used_channels[CFG80211_MAX_NUM_DIFFERENT_CHANNELS];
+	struct ieee80211_channel *ch;
+	enum cfg80211_chan_mode chmode;
+	int num_different_channels = 0;
 	int total = 1;
 	int i, j;
 
@@ -955,9 +962,23 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 		return 0;
 
 	memset(num, 0, sizeof(num));
+	memset(used_channels, 0, sizeof(used_channels));
 
 	num[iftype] = 1;
 
+	switch (chanmode) {
+	case CHAN_MODE_UNDEFINED:
+		break;
+	case CHAN_MODE_SHARED:
+		WARN_ON(!chan);
+		used_channels[0] = chan;
+		num_different_channels++;
+		break;
+	case CHAN_MODE_EXCLUSIVE:
+		num_different_channels++;
+		break;
+	}
+
 	mutex_lock(&rdev->devlist_mtx);
 	list_for_each_entry(wdev_iter, &rdev->netdev_list, list) {
 		if (wdev_iter == wdev)
@@ -968,6 +989,28 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 		if (rdev->wiphy.software_iftypes & BIT(wdev_iter->iftype))
 			continue;
 
+		cfg80211_get_chan_state(rdev, wdev_iter, &ch, &chmode);
+
+		switch (chmode) {
+		case CHAN_MODE_UNDEFINED:
+			break;
+		case CHAN_MODE_SHARED:
+			for (i = 0; i < CFG80211_MAX_NUM_DIFFERENT_CHANNELS; i++)
+				if (!used_channels[i] || used_channels[i] == ch)
+					break;
+
+			BUG_ON(i == CFG80211_MAX_NUM_DIFFERENT_CHANNELS);
+
+			if (used_channels[i] == NULL) {
+				used_channels[i] = ch;
+				num_different_channels++;
+			}
+			break;
+		case CHAN_MODE_EXCLUSIVE:
+			num_different_channels++;
+			break;
+		}
+
 		num[wdev_iter->iftype]++;
 		total++;
 		used_iftypes |= BIT(wdev_iter->iftype);
@@ -984,12 +1027,15 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 
 		c = &rdev->wiphy.iface_combinations[i];
 
+		if (total > c->max_interfaces)
+			continue;
+		if (num_different_channels > c->num_different_channels)
+			continue;
+
 		limits = kmemdup(c->limits, sizeof(limits[0]) * c->n_limits,
 				 GFP_KERNEL);
 		if (!limits)
 			return -ENOMEM;
-		if (total > c->max_interfaces)
-			goto cont;
 
 		for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
 			if (rdev->wiphy.software_iftypes & BIT(iftype))
-- 
1.7.0.4

