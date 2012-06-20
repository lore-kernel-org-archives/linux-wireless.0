Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62631 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405Ab2FTGOb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 02:14:31 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFCv2 12/13] cfg80211: add channel checking for iface combinations
Date: Wed, 20 Jun 2012 08:14:18 +0200
Message-ID: <1340172859-18146-13-git-send-email-michal.kazior@tieto.com> (sfid-20120620_081436_410643_3CA3DDB4)
In-Reply-To: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>
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
 net/wireless/core.h |   27 ++++++++++++++++--
 net/wireless/util.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 92 insertions(+), 8 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 9d9441d..17da8f0 100644
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
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 9b92ec5..d40f324 100644
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
+	struct ieee80211_channel **used_channels;
+	struct ieee80211_channel *ch;
+	enum cfg80211_chan_mode chmode;
+	int num_different_channels = 0;
+	int num_max_channels = 0;
 	int total = 1;
 	int i, j;
 
@@ -954,6 +961,33 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 	if (rdev->wiphy.software_iftypes & BIT(iftype))
 		return 0;
 
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		if (!rdev->wiphy.bands[i])
+			continue;
+
+		num_max_channels += rdev->wiphy.bands[i]->n_channels;
+	}
+	if (!num_max_channels)
+		return -EINVAL;
+
+	used_channels = kzalloc(num_max_channels * sizeof(*used_channels),
+				GFP_KERNEL);
+	if (!used_channels)
+		return -ENOMEM;
+
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
 	memset(num, 0, sizeof(num));
 
 	num[iftype] = 1;
@@ -968,11 +1002,37 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 		if (rdev->wiphy.software_iftypes & BIT(wdev_iter->iftype))
 			continue;
 
+		cfg80211_get_chan_state(rdev, wdev_iter, &ch, &chmode);
+
+		switch (chmode) {
+		case CHAN_MODE_UNDEFINED:
+			break;
+		case CHAN_MODE_SHARED:
+			for (i = 0; i < num_max_channels; i++)
+				if (!used_channels[i] || used_channels[i] == ch)
+					break;
+
+			if (i == num_max_channels) {
+				kfree(used_channels);
+				return -ENOMEM;
+			}
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
 	}
 	mutex_unlock(&rdev->devlist_mtx);
+	kfree(used_channels);
 
 	if (total == 1)
 		return 0;
@@ -984,12 +1044,15 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 
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

