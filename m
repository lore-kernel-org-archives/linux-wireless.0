Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59283 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758835Ab2EKMjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 08:39:49 -0400
Message-ID: <1336739986.12801.1.camel@jlt3.sipsolutions.net> (sfid-20120511_143953_034622_9EC74798)
Subject: Re: [RFC/PATCH] multi-channel preparation work
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 11 May 2012 14:39:46 +0200
In-Reply-To: <1336738290.5819.23.camel@jlt3.sipsolutions.net> (sfid-20120511_141137_957037_16962830)
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>
	 <1336738290.5819.23.camel@jlt3.sipsolutions.net>
	 (sfid-20120511_141137_957037_16962830)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-11 at 14:11 +0200, Johannes Berg wrote:

> You saw my patches for managing the AP channel differently. I think we
> should do the same for mesh, Thomas might actually be working on it but

Here's what I came up with -- untested!

Thomas, if I understood your other patch correctly you wanted to be able
to set the channel before the interface was up, this should allow you to
do that since it only takes effect on join mesh.

johannes


cfg80211: provide channel to join_mesh function

From: Johannes Berg <johannes.berg@intel.com>

Just like the AP mode patch, instead of setting
the channel and then joining the mesh network,
provide the channel to join the network on to
the join_mesh() function.

Like in AP mode, you can also give the channel
to the join-mesh nl80211 command now.

Unlike AP mode, it picks a default channel if
none was given.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |    4 +++
 net/mac80211/cfg.c     |    6 +++++
 net/wireless/core.h    |    4 +--
 net/wireless/mesh.c    |   52 +++++++++++++++++++++++++++++++++++++++++++++++--
 net/wireless/nl80211.c |   19 +++++++++++++++++
 5 files changed, 81 insertions(+), 4 deletions(-)

--- a/include/net/cfg80211.h	2012-05-11 13:46:35.000000000 +0200
+++ b/include/net/cfg80211.h	2012-05-11 14:16:22.000000000 +0200
@@ -831,6 +831,8 @@ struct mesh_config {
 
 /**
  * struct mesh_setup - 802.11s mesh setup configuration
+ * @channel: the channel to start the mesh network on
+ * @channel_type: the channel type to use
  * @mesh_id: the mesh ID
  * @mesh_id_len: length of the mesh ID, at least 1 and at most 32 bytes
  * @sync_method: which synchronization method to use
@@ -845,6 +847,8 @@ struct mesh_config {
  * These parameters are fixed when the mesh is created.
  */
 struct mesh_setup {
+	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 	const u8 *mesh_id;
 	u8 mesh_id_len;
 	u8 sync_method;
--- a/net/wireless/nl80211.c	2012-05-11 13:46:35.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-05-11 14:31:52.000000000 +0200
@@ -1190,6 +1190,7 @@ static int __nl80211_set_channel(struct
 	if (wdev) switch (wdev->iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_MESH_POINT:
 		if (wdev->beacon_interval) {
 			result = -EBUSY;
 			break;
@@ -5996,6 +5997,24 @@ static int nl80211_join_mesh(struct sk_b
 			return err;
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
+		enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
+
+		if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
+		    !nl80211_valid_channel_type(info, &channel_type))
+			return -EINVAL;
+
+		setup.channel = rdev_freq_to_chan(rdev,
+			nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
+			channel_type);
+		if (!setup.channel)
+			return -EINVAL;
+		setup.channel_type = channel_type;
+	} else {
+		/* cfg80211_join_mesh() will sort it out */
+		setup.channel = NULL;
+	}
+
 	return cfg80211_join_mesh(rdev, dev, &setup, &cfg);
 }
 
--- a/net/wireless/core.h	2012-05-10 15:40:30.000000000 +0200
+++ b/net/wireless/core.h	2012-05-11 14:18:31.000000000 +0200
@@ -303,11 +303,11 @@ extern const struct mesh_config default_
 extern const struct mesh_setup default_mesh_setup;
 int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 			 struct net_device *dev,
-			 const struct mesh_setup *setup,
+			 struct mesh_setup *setup,
 			 const struct mesh_config *conf);
 int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
-		       const struct mesh_setup *setup,
+		       struct mesh_setup *setup,
 		       const struct mesh_config *conf);
 int cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 			struct net_device *dev);
--- a/net/wireless/mesh.c	2012-05-08 13:02:00.000000000 +0200
+++ b/net/wireless/mesh.c	2012-05-11 14:35:21.000000000 +0200
@@ -65,6 +65,9 @@ const struct mesh_config default_mesh_co
 };
 
 const struct mesh_setup default_mesh_setup = {
+	/* cfg80211_join_mesh() will pick a channel if needed */
+	.channel = NULL,
+	.channel_type = NL80211_CHAN_NO_HT,
 	.sync_method = IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET,
 	.path_sel_proto = IEEE80211_PATH_PROTOCOL_HWMP,
 	.path_metric = IEEE80211_PATH_METRIC_AIRTIME,
@@ -75,7 +78,7 @@ const struct mesh_setup default_mesh_set
 
 int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 			 struct net_device *dev,
-			 const struct mesh_setup *setup,
+			 struct mesh_setup *setup,
 			 const struct mesh_config *conf)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
@@ -101,6 +104,51 @@ int __cfg80211_join_mesh(struct cfg80211
 	if (!rdev->ops->join_mesh)
 		return -EOPNOTSUPP;
 
+	if (!setup->channel) {
+		/* if no channel explicitly given, use preset channel */
+		setup->channel = wdev->preset_chan;
+		setup->channel_type = wdev->preset_chantype;
+	}
+
+	if (!setup->channel) {
+		/* if we don't have that either, use the first usable channel */
+		enum ieee80211_band band;
+
+		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+			struct ieee80211_supported_band *sband;
+			struct ieee80211_channel *chan;
+			int i;
+
+			sband = rdev->wiphy.bands[band];
+			if (!sband)
+				continue;
+
+			for (i = 0; i < sband->n_channels; i++) {
+				chan = &sband->channels[i];
+				if (chan->flags & (IEEE80211_CHAN_NO_IBSS |
+						   IEEE80211_CHAN_PASSIVE_SCAN |
+						   IEEE80211_CHAN_DISABLED |
+						   IEEE80211_CHAN_RADAR))
+					continue;
+				setup->channel = chan;
+				break;
+			}
+
+			if (setup->channel)
+				break;
+		}
+
+		/* no usable channel ... */
+		if (!setup->channel)
+			return -EINVAL;
+
+		setup->channel_type = NL80211_CHAN_NO_HT;
+	}
+
+	if (!cfg80211_can_beacon_sec_chan(&rdev->wiphy, setup->channel,
+					  setup->channel_type))
+		return -EINVAL;
+
 	err = rdev->ops->join_mesh(&rdev->wiphy, dev, conf, setup);
 	if (!err) {
 		memcpy(wdev->ssid, setup->mesh_id, setup->mesh_id_len);
@@ -112,7 +160,7 @@ int __cfg80211_join_mesh(struct cfg80211
 
 int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
-		       const struct mesh_setup *setup,
+		       struct mesh_setup *setup,
 		       const struct mesh_config *conf)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
--- a/net/mac80211/cfg.c	2012-05-11 13:46:35.000000000 +0200
+++ b/net/mac80211/cfg.c	2012-05-11 14:31:34.000000000 +0200
@@ -1598,6 +1598,12 @@ static int ieee80211_join_mesh(struct wi
 	err = copy_mesh_setup(ifmsh, setup);
 	if (err)
 		return err;
+
+	err = ieee80211_set_channel(wiphy, dev, params->channel,
+				    params->channel_type);
+	if (err)
+		return err;
+
 	ieee80211_start_mesh(sdata);
 
 	return 0;


