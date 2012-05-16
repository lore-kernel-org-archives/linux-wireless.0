Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41669 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759327Ab2EPVzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 17:55:03 -0400
Message-Id: <20120516215038.904082557@sipsolutions.net> (sfid-20120516_235600_117266_D4BED472)
Date: Wed, 16 May 2012 23:50:20 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/7] cfg80211: provide channel to join_mesh function
References: <20120516215014.379333357@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Just like the AP mode patch, instead of setting
the channel and then joining the mesh network,
provide the channel to join the network on to
the join_mesh() function.

Like in AP mode, you can also give the channel
to the join-mesh nl80211 command now.

Unlike AP mode, it picks a default channel if
none was given.

As libertas uses mesh mode interfaces but has
no join_mesh callback and we can't simply break
it, keep some compatibility code for that case
and configure the channel directly for it.

In the non-libertas case, where we store the
channel until join, allow setting it while the
interface is down.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h     |    4 +
 net/mac80211/cfg.c         |    6 ++
 net/wireless/core.h        |    7 ++-
 net/wireless/mesh.c        |   91 ++++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.c     |   43 ++++++++++++++++-----
 net/wireless/wext-compat.c |   12 +++++
 6 files changed, 148 insertions(+), 15 deletions(-)

--- a/include/net/cfg80211.h	2012-05-16 10:24:04.000000000 +0200
+++ b/include/net/cfg80211.h	2012-05-16 10:24:50.000000000 +0200
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
--- a/net/wireless/nl80211.c	2012-05-16 10:24:45.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-05-16 10:24:50.000000000 +0200
@@ -921,7 +921,8 @@ static int nl80211_send_wiphy(struct sk_
 		if (nla_put_u32(msg, i, NL80211_CMD_SET_WIPHY_NETNS))
 			goto nla_put_failure;
 	}
-	if (dev->ops->set_channel || dev->ops->start_ap) {
+	if (dev->ops->set_channel || dev->ops->start_ap ||
+	    dev->ops->join_mesh) {
 		i++;
 		if (nla_put_u32(msg, i, NL80211_CMD_SET_CHANNEL))
 			goto nla_put_failure;
@@ -1166,17 +1167,19 @@ static int parse_txq_params(struct nlatt
 static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
 {
 	/*
-	 * You can only set the channel explicitly for AP and
-	 * mesh type interfaces; all others have their channel
-	 * managed via their respective "establish a connection"
-	 * command (connect, join, ...)
+	 * You can only set the channel explicitly for WDS interfaces,
+	 * all others have their channel managed via their respective
+	 * "establish a connection" command (connect, join, ...)
+	 *
+	 * For AP/GO and mesh mode, the channel can be set with the
+	 * channel userspace API, but is only stored and passed to the
+	 * low-level driver when the AP starts or the mesh is joined.
+	 * This is for backward compatibility, userspace can also give
+	 * the channel in the start-ap or join-mesh commands instead.
 	 *
 	 * Monitors are special as they are normally slaved to
 	 * whatever else is going on, so they behave as though
 	 * you tried setting the wiphy channel itself.
-	 *
-	 * For AP/GO modes, it's only for compatibility, you can
-	 * also give the channel to the start-AP command.
 	 */
 	return !wdev ||
 		wdev->iftype == NL80211_IFTYPE_AP ||
@@ -1246,6 +1249,9 @@ static int __nl80211_set_channel(struct
 		wdev->preset_chantype = channel_type;
 		result = 0;
 		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		result = cfg80211_set_mesh_freq(rdev, wdev, freq, channel_type);
+		break;
 	default:
 		wdev_lock(wdev);
 		result = cfg80211_set_freq(rdev, wdev, freq, channel_type);
@@ -1335,8 +1341,7 @@ static int nl80211_set_wiphy(struct sk_b
 		result = 0;
 
 		mutex_lock(&rdev->mtx);
-	} else if (netif_running(netdev) &&
-		   nl80211_can_set_dev_channel(netdev->ieee80211_ptr))
+	} else if (nl80211_can_set_dev_channel(netdev->ieee80211_ptr))
 		wdev = netdev->ieee80211_ptr;
 	else
 		wdev = NULL;
@@ -6080,6 +6085,24 @@ static int nl80211_join_mesh(struct sk_b
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
 
--- a/net/wireless/core.h	2012-05-16 10:22:21.000000000 +0200
+++ b/net/wireless/core.h	2012-05-16 10:24:50.000000000 +0200
@@ -303,14 +303,17 @@ extern const struct mesh_config default_
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
+int cfg80211_set_mesh_freq(struct cfg80211_registered_device *rdev,
+			   struct wireless_dev *wdev, int freq,
+			   enum nl80211_channel_type channel_type);
 
 /* MLME */
 int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
--- a/net/wireless/mesh.c	2012-05-16 10:22:21.000000000 +0200
+++ b/net/wireless/mesh.c	2012-05-16 10:24:50.000000000 +0200
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
@@ -125,6 +173,45 @@ int cfg80211_join_mesh(struct cfg80211_r
 	return err;
 }
 
+int cfg80211_set_mesh_freq(struct cfg80211_registered_device *rdev,
+			   struct wireless_dev *wdev, int freq,
+			   enum nl80211_channel_type channel_type)
+{
+	struct ieee80211_channel *channel;
+
+	/*
+	 * Workaround for libertas (only!), it puts the interface
+	 * into mesh mode but doesn't implement join_mesh. Instead,
+	 * it is configured via sysfs and then joins the mesh when
+	 * you set the channel. Note that the libertas mesh isn't
+	 * compatible with 802.11 mesh.
+	 */
+	if (!rdev->ops->join_mesh) {
+		int err;
+
+		if (!netif_running(wdev->netdev))
+			return -ENETDOWN;
+		wdev_lock(wdev);
+		err = cfg80211_set_freq(rdev, wdev, freq, channel_type);
+		wdev_unlock(wdev);
+
+		return err;
+	}
+
+	if (wdev->mesh_id_len)
+		return -EBUSY;
+
+	channel = rdev_freq_to_chan(rdev, freq, channel_type);
+	if (!channel || !cfg80211_can_beacon_sec_chan(&rdev->wiphy,
+						      channel,
+						      channel_type)) {
+		return -EINVAL;
+	}
+	wdev->preset_chan = channel;
+	wdev->preset_chantype = channel_type;
+	return 0;
+}
+
 void cfg80211_notify_new_peer_candidate(struct net_device *dev,
 		const u8 *macaddr, const u8* ie, u8 ie_len, gfp_t gfp)
 {
--- a/net/mac80211/cfg.c	2012-05-16 10:24:04.000000000 +0200
+++ b/net/mac80211/cfg.c	2012-05-16 10:24:50.000000000 +0200
@@ -1598,6 +1598,12 @@ static int ieee80211_join_mesh(struct wi
 	err = copy_mesh_setup(ifmsh, setup);
 	if (err)
 		return err;
+
+	err = ieee80211_set_channel(wiphy, dev, setup->channel,
+				    setup->channel_type);
+	if (err)
+		return err;
+
 	ieee80211_start_mesh(sdata);
 
 	return 0;
--- a/net/wireless/wext-compat.c	2012-05-16 10:24:45.000000000 +0200
+++ b/net/wireless/wext-compat.c	2012-05-16 10:24:50.000000000 +0200
@@ -796,7 +796,6 @@ static int cfg80211_wext_siwfreq(struct
 	case NL80211_IFTYPE_ADHOC:
 		return cfg80211_ibss_wext_siwfreq(dev, info, wextfreq, extra);
 	case NL80211_IFTYPE_MONITOR:
-	case NL80211_IFTYPE_MESH_POINT:
 		freq = cfg80211_wext_freq(wdev->wiphy, wextfreq);
 		if (freq < 0)
 			return freq;
@@ -808,6 +807,17 @@ static int cfg80211_wext_siwfreq(struct
 		wdev_unlock(wdev);
 		mutex_unlock(&rdev->devlist_mtx);
 		return err;
+	case NL80211_IFTYPE_MESH_POINT:
+		freq = cfg80211_wext_freq(wdev->wiphy, wextfreq);
+		if (freq < 0)
+			return freq;
+		if (freq == 0)
+			return -EINVAL;
+		mutex_lock(&rdev->devlist_mtx);
+		err = cfg80211_set_mesh_freq(rdev, wdev, freq,
+					     NL80211_CHAN_NO_HT);
+		mutex_unlock(&rdev->devlist_mtx);
+		return err;
 	default:
 		return -EOPNOTSUPP;
 	}


