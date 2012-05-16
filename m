Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41672 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab2EPVzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 17:55:04 -0400
Message-Id: <20120516215039.044163237@sipsolutions.net> (sfid-20120516_235521_710599_0233D0EE)
Date: Wed, 16 May 2012 23:50:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/7] cfg80211: clarify set_channel APIs
References: <20120516215014.379333357@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Now that we've removed all uses of the set_channel
API except for the monitor channel and in libertas,
clarify this. Split the libertas mesh use into a
new libertas_set_mesh_channel() operation, just to
keep backward compatibility, and rename the normal
set_channel() to set_monitor_channel().

Also describe the desired set_monitor_channel()
semantics more clearly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/libertas/cfg.c |   39 +++++++++++++++++++++++++-------
 drivers/net/wireless/orinoco/cfg.c  |   10 ++++----
 include/net/cfg80211.h              |   24 ++++++++++++--------
 net/mac80211/cfg.c                  |    9 ++++++-
 net/wireless/chan.c                 |   43 ++++--------------------------------
 net/wireless/core.h                 |    5 +---
 net/wireless/mesh.c                 |   26 ++++++++++-----------
 net/wireless/mlme.c                 |    2 -
 net/wireless/nl80211.c              |   21 ++++++++++-------
 net/wireless/wext-compat.c          |   10 +-------
 net/wireless/wext-sme.c             |   10 ++++++--
 11 files changed, 100 insertions(+), 99 deletions(-)

--- a/include/net/cfg80211.h	2012-05-16 23:35:50.000000000 +0200
+++ b/include/net/cfg80211.h	2012-05-16 23:35:51.000000000 +0200
@@ -1420,11 +1420,14 @@ struct cfg80211_gtk_rekey_data {
  *
  * @set_txq_params: Set TX queue parameters
  *
- * @set_channel: Set channel for a given wireless interface. Some devices
- *	may support multi-channel operation (by channel hopping) so cfg80211
- *	doesn't verify much. Note, however, that the passed netdev may be
- *	%NULL as well if the user requested changing the channel for the
- *	device itself, or for a monitor interface.
+ * @libertas_set_mesh_channel: Only for backward compatibility for libertas,
+ *	as it doesn't implement join_mesh and needs to set the channel to
+ *	join the mesh instead.
+ *
+ * @set_monitor_channel: Set the monitor mode channel for the device. If other
+ *	interfaces are active this callback should reject the configuration.
+ *	If no interfaces are active or the device is down, the channel should
+ *	be stored for when a monitor interface becomes active.
  * @get_channel: Get the current operating channel, should return %NULL if
  *	there's no single defined operating channel if for example the
  *	device implements channel hopping for multi-channel virtual interfaces.
@@ -1614,9 +1617,13 @@ struct cfg80211_ops {
 	int	(*set_txq_params)(struct wiphy *wiphy, struct net_device *dev,
 				  struct ieee80211_txq_params *params);
 
-	int	(*set_channel)(struct wiphy *wiphy, struct net_device *dev,
-			       struct ieee80211_channel *chan,
-			       enum nl80211_channel_type channel_type);
+	int	(*libertas_set_mesh_channel)(struct wiphy *wiphy,
+					     struct net_device *dev,
+					     struct ieee80211_channel *chan);
+
+	int	(*set_monitor_channel)(struct wiphy *wiphy,
+				       struct ieee80211_channel *chan,
+				       enum nl80211_channel_type channel_type);
 
 	int	(*scan)(struct wiphy *wiphy, struct net_device *dev,
 			struct cfg80211_scan_request *request);
@@ -2325,7 +2332,6 @@ struct wireless_dev {
 	spinlock_t event_lock;
 
 	struct cfg80211_internal_bss *current_bss; /* associated / joined */
-	struct ieee80211_channel *channel;
 	struct ieee80211_channel *preset_chan;
 	enum nl80211_channel_type preset_chantype;
 
--- a/net/wireless/chan.c	2012-05-16 23:35:46.000000000 +0200
+++ b/net/wireless/chan.c	2012-05-16 23:35:51.000000000 +0200
@@ -78,50 +78,17 @@ bool cfg80211_can_beacon_sec_chan(struct
 }
 EXPORT_SYMBOL(cfg80211_can_beacon_sec_chan);
 
-int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
-		      struct wireless_dev *wdev, int freq,
-		      enum nl80211_channel_type channel_type)
+int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
+				 int freq, enum nl80211_channel_type chantype)
 {
 	struct ieee80211_channel *chan;
-	int result;
 
-	if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
-		wdev = NULL;
-
-	if (wdev) {
-		ASSERT_WDEV_LOCK(wdev);
-
-		if (!netif_running(wdev->netdev))
-			return -ENETDOWN;
-	}
-
-	if (!rdev->ops->set_channel)
+	if (!rdev->ops->set_monitor_channel)
 		return -EOPNOTSUPP;
 
-	chan = rdev_freq_to_chan(rdev, freq, channel_type);
+	chan = rdev_freq_to_chan(rdev, freq, chantype);
 	if (!chan)
 		return -EINVAL;
 
-	/* Both channels should be able to initiate communication */
-	if (wdev && (wdev->iftype == NL80211_IFTYPE_ADHOC ||
-		     wdev->iftype == NL80211_IFTYPE_AP ||
-		     wdev->iftype == NL80211_IFTYPE_AP_VLAN ||
-		     wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
-		     wdev->iftype == NL80211_IFTYPE_P2P_GO) &&
-	    !cfg80211_can_beacon_sec_chan(&rdev->wiphy, chan, channel_type)) {
-		printk(KERN_DEBUG
-		       "cfg80211: Secondary channel not allowed to beacon\n");
-		return -EINVAL;
-	}
-
-	result = rdev->ops->set_channel(&rdev->wiphy,
-					wdev ? wdev->netdev : NULL,
-					chan, channel_type);
-	if (result)
-		return result;
-
-	if (wdev)
-		wdev->channel = chan;
-
-	return 0;
+	return rdev->ops->set_monitor_channel(&rdev->wiphy, chan, chantype);
 }
--- a/net/wireless/mlme.c	2012-05-16 21:00:52.000000000 +0200
+++ b/net/wireless/mlme.c	2012-05-16 23:35:51.000000000 +0200
@@ -948,8 +948,6 @@ void cfg80211_ch_switch_notify(struct ne
 	if (WARN_ON(!chan))
 		goto out;
 
-	wdev->channel = chan;
-
 	nl80211_ch_switch_notify(rdev, dev, freq, type, GFP_KERNEL);
 out:
 	wdev_unlock(wdev);
--- a/net/wireless/wext-compat.c	2012-05-16 23:35:50.000000000 +0200
+++ b/net/wireless/wext-compat.c	2012-05-16 23:35:51.000000000 +0200
@@ -802,9 +802,7 @@ static int cfg80211_wext_siwfreq(struct
 		if (freq == 0)
 			return -EINVAL;
 		mutex_lock(&rdev->devlist_mtx);
-		wdev_lock(wdev);
-		err = cfg80211_set_freq(rdev, wdev, freq, NL80211_CHAN_NO_HT);
-		wdev_unlock(wdev);
+		err = cfg80211_set_monitor_channel(rdev, freq, NL80211_CHAN_NO_HT);
 		mutex_unlock(&rdev->devlist_mtx);
 		return err;
 	case NL80211_IFTYPE_MESH_POINT:
@@ -848,11 +846,7 @@ static int cfg80211_wext_giwfreq(struct
 		freq->e = 6;
 		return 0;
 	default:
-		if (!wdev->channel)
-			return -EINVAL;
-		freq->m = wdev->channel->center_freq;
-		freq->e = 6;
-		return 0;
+		return -EINVAL;
 	}
 }
 
--- a/net/wireless/nl80211.c	2012-05-16 23:35:50.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-05-16 23:35:51.000000000 +0200
@@ -921,7 +921,7 @@ static int nl80211_send_wiphy(struct sk_
 		if (nla_put_u32(msg, i, NL80211_CMD_SET_WIPHY_NETNS))
 			goto nla_put_failure;
 	}
-	if (dev->ops->set_channel || dev->ops->start_ap ||
+	if (dev->ops->set_monitor_channel || dev->ops->start_ap ||
 	    dev->ops->join_mesh) {
 		i++;
 		if (nla_put_u32(msg, i, NL80211_CMD_SET_CHANNEL))
@@ -1178,8 +1178,8 @@ static bool nl80211_can_set_dev_channel(
 	 * the channel in the start-ap or join-mesh commands instead.
 	 *
 	 * Monitors are special as they are normally slaved to
-	 * whatever else is going on, so they behave as though
-	 * you tried setting the wiphy channel itself.
+	 * whatever else is going on, so they have their own special
+	 * operation to set the monitor channel if possible.
 	 */
 	return !wdev ||
 		wdev->iftype == NL80211_IFTYPE_AP ||
@@ -1217,6 +1217,10 @@ static int __nl80211_set_channel(struct
 	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 	u32 freq;
 	int result;
+	enum nl80211_iftype iftype = NL80211_IFTYPE_MONITOR;
+
+	if (wdev)
+		iftype = wdev->iftype;
 
 	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
 		return -EINVAL;
@@ -1231,7 +1235,7 @@ static int __nl80211_set_channel(struct
 	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
 
 	mutex_lock(&rdev->devlist_mtx);
-	if (wdev) switch (wdev->iftype) {
+	switch (iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
 		if (wdev->beacon_interval) {
@@ -1252,12 +1256,11 @@ static int __nl80211_set_channel(struct
 	case NL80211_IFTYPE_MESH_POINT:
 		result = cfg80211_set_mesh_freq(rdev, wdev, freq, channel_type);
 		break;
+	case NL80211_IFTYPE_MONITOR:
+		result = cfg80211_set_monitor_channel(rdev, freq, channel_type);
+		break;
 	default:
-		wdev_lock(wdev);
-		result = cfg80211_set_freq(rdev, wdev, freq, channel_type);
-		wdev_unlock(wdev);
-	} else {
-		result = cfg80211_set_freq(rdev, NULL, freq, channel_type);
+		result = -EINVAL;
 	}
 	mutex_unlock(&rdev->devlist_mtx);
 
--- a/net/wireless/core.h	2012-05-16 23:35:50.000000000 +0200
+++ b/net/wireless/core.h	2012-05-16 23:35:51.000000000 +0200
@@ -444,9 +444,8 @@ cfg80211_can_add_interface(struct cfg802
 struct ieee80211_channel *
 rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 		  int freq, enum nl80211_channel_type channel_type);
-int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
-		      struct wireless_dev *wdev, int freq,
-		      enum nl80211_channel_type channel_type);
+int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
+				 int freq, enum nl80211_channel_type chantype);
 
 int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 			   const u8 *rates, unsigned int n_rates,
--- a/net/wireless/wext-sme.c	2012-05-16 21:00:52.000000000 +0200
+++ b/net/wireless/wext-sme.c	2012-05-16 23:35:51.000000000 +0200
@@ -111,9 +111,15 @@ int cfg80211_mgd_wext_siwfreq(struct net
 
 	wdev->wext.connect.channel = chan;
 
-	/* SSID is not set, we just want to switch channel */
+	/*
+	 * SSID is not set, we just want to switch monitor channel,
+	 * this is really just backward compatibility, if the SSID
+	 * is set then we use the channel to select the BSS to use
+	 * to connect to instead. If we were connected on another
+	 * channel we disconnected above and reconnect below.
+	 */
 	if (chan && !wdev->wext.connect.ssid_len) {
-		err = cfg80211_set_freq(rdev, wdev, freq, NL80211_CHAN_NO_HT);
+		err = cfg80211_set_monitor_channel(rdev, freq, NL80211_CHAN_NO_HT);
 		goto out;
 	}
 
--- a/net/mac80211/cfg.c	2012-05-16 23:35:50.000000000 +0200
+++ b/net/mac80211/cfg.c	2012-05-16 23:35:51.000000000 +0200
@@ -709,6 +709,13 @@ static int ieee80211_set_channel(struct
 	return 0;
 }
 
+static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
+					 struct ieee80211_channel *chan,
+					 enum nl80211_channel_type channel_type)
+{
+	return ieee80211_set_channel(wiphy, NULL, chan, channel_type);
+}
+
 static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 				    const u8 *resp, size_t resp_len)
 {
@@ -2930,7 +2937,7 @@ struct cfg80211_ops mac80211_config_ops
 #endif
 	.change_bss = ieee80211_change_bss,
 	.set_txq_params = ieee80211_set_txq_params,
-	.set_channel = ieee80211_set_channel,
+	.set_monitor_channel = ieee80211_set_monitor_channel,
 	.suspend = ieee80211_suspend,
 	.resume = ieee80211_resume,
 	.scan = ieee80211_scan,
--- a/net/wireless/mesh.c	2012-05-16 23:35:50.000000000 +0200
+++ b/net/wireless/mesh.c	2012-05-16 23:35:51.000000000 +0200
@@ -179,6 +179,13 @@ int cfg80211_set_mesh_freq(struct cfg802
 {
 	struct ieee80211_channel *channel;
 
+	channel = rdev_freq_to_chan(rdev, freq, channel_type);
+	if (!channel || !cfg80211_can_beacon_sec_chan(&rdev->wiphy,
+						      channel,
+						      channel_type)) {
+		return -EINVAL;
+	}
+
 	/*
 	 * Workaround for libertas (only!), it puts the interface
 	 * into mesh mode but doesn't implement join_mesh. Instead,
@@ -186,27 +193,20 @@ int cfg80211_set_mesh_freq(struct cfg802
 	 * you set the channel. Note that the libertas mesh isn't
 	 * compatible with 802.11 mesh.
 	 */
-	if (!rdev->ops->join_mesh) {
-		int err;
+	if (rdev->ops->libertas_set_mesh_channel) {
+		if (channel_type != NL80211_CHAN_NO_HT)
+			return -EINVAL;
 
 		if (!netif_running(wdev->netdev))
 			return -ENETDOWN;
-		wdev_lock(wdev);
-		err = cfg80211_set_freq(rdev, wdev, freq, channel_type);
-		wdev_unlock(wdev);
-
-		return err;
+		return rdev->ops->libertas_set_mesh_channel(&rdev->wiphy,
+							    wdev->netdev,
+							    channel);
 	}
 
 	if (wdev->mesh_id_len)
 		return -EBUSY;
 
-	channel = rdev_freq_to_chan(rdev, freq, channel_type);
-	if (!channel || !cfg80211_can_beacon_sec_chan(&rdev->wiphy,
-						      channel,
-						      channel_type)) {
-		return -EINVAL;
-	}
 	wdev->preset_chan = channel;
 	wdev->preset_chantype = channel_type;
 	return 0;
--- a/drivers/net/wireless/libertas/cfg.c	2012-05-16 21:00:52.000000000 +0200
+++ b/drivers/net/wireless/libertas/cfg.c	2012-05-16 23:35:51.000000000 +0200
@@ -435,10 +435,9 @@ static int lbs_add_wpa_tlv(u8 *tlv, cons
  * Set Channel
  */
 
-static int lbs_cfg_set_channel(struct wiphy *wiphy,
-	struct net_device *netdev,
-	struct ieee80211_channel *channel,
-	enum nl80211_channel_type channel_type)
+static int lbs_cfg_set_monitor_channel(struct wiphy *wiphy,
+				       struct ieee80211_channel *channel,
+				       enum nl80211_channel_type channel_type)
 {
 	struct lbs_private *priv = wiphy_priv(wiphy);
 	int ret = -ENOTSUPP;
@@ -449,10 +448,31 @@ static int lbs_cfg_set_channel(struct wi
 	if (channel_type != NL80211_CHAN_NO_HT)
 		goto out;
 
-	if (netdev == priv->mesh_dev)
-		ret = lbs_mesh_set_channel(priv, channel->hw_value);
-	else
-		ret = lbs_set_channel(priv, channel->hw_value);
+	ret = lbs_set_channel(priv, channel->hw_value);
+
+ out:
+	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
+	return ret;
+}
+
+static int lbs_cfg_set_mesh_channel(struct wiphy *wiphy,
+				    struct net_device *netdev,
+				    struct ieee80211_channel *channel,
+				    enum nl80211_channel_type channel_type)
+{
+	struct lbs_private *priv = wiphy_priv(wiphy);
+	int ret = -ENOTSUPP;
+
+	lbs_deb_enter_args(LBS_DEB_CFG80211, "iface %s freq %d, type %d",
+			   netdev_name(netdev), channel->center_freq, channel_type);
+
+	if (channel_type != NL80211_CHAN_NO_HT)
+		goto out;
+
+	if (netdev != priv->mesh_dev)
+		goto out;
+
+	ret = lbs_mesh_set_channel(priv, channel->hw_value);
 
  out:
 	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
@@ -2029,7 +2049,8 @@ static int lbs_leave_ibss(struct wiphy *
  */
 
 static struct cfg80211_ops lbs_cfg80211_ops = {
-	.set_channel = lbs_cfg_set_channel,
+	.set_monitor_channel = lbs_cfg_set_channel,
+	.libertas_set_mesh_channel = lbs_cfg_set_mesh_channel,
 	.scan = lbs_cfg_scan,
 	.connect = lbs_cfg_connect,
 	.disconnect = lbs_cfg_disconnect,
--- a/drivers/net/wireless/orinoco/cfg.c	2012-05-16 21:00:52.000000000 +0200
+++ b/drivers/net/wireless/orinoco/cfg.c	2012-05-16 23:35:51.000000000 +0200
@@ -160,10 +160,10 @@ static int orinoco_scan(struct wiphy *wi
 	return err;
 }
 
-static int orinoco_set_channel(struct wiphy *wiphy,
-			struct net_device *netdev,
-			struct ieee80211_channel *chan,
-			enum nl80211_channel_type channel_type)
+static int orinoco_set_monitor_channel(struct wiphy *wiphy,
+				       struct net_device *netdev,
+				       struct ieee80211_channel *chan,
+				       enum nl80211_channel_type channel_type)
 {
 	struct orinoco_private *priv = wiphy_priv(wiphy);
 	int err = 0;
@@ -286,7 +286,7 @@ static int orinoco_set_wiphy_params(stru
 
 const struct cfg80211_ops orinoco_cfg_ops = {
 	.change_virtual_intf = orinoco_change_vif,
-	.set_channel = orinoco_set_channel,
+	.set_monitor_channel = orinoco_set_monitor_channel,
 	.scan = orinoco_scan,
 	.set_wiphy_params = orinoco_set_wiphy_params,
 };


