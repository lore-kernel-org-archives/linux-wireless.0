Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0ECHMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 03:12:47 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1O8ppd-0002MN-L0
	for linux-wireless@vger.kernel.org; Mon, 03 May 2010 09:12:45 +0200
Subject: [RFC/RFT] cfg80211/mac80211: better channel handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 09:12:44 +0200
Message-ID: <1272870764.3614.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently (all tested with hwsim) you can do stupid
things like setting up an AP on a certain channel,
then adding another virtual interface and making
that associate on another channel -- this will make
the beaconing to move channel but obviously without
the necessary IEs data update.

In order to improve this situation, first make the
configuration APIs (cfg80211 and nl80211) aware of
multi-channel operation -- we'll eventually need
that in the future anyway. There's one userland API
change and one API addition. The API change is that
now SET_WIPHY must be called with virtual interface
index rather than only wiphy index in order to take
effect for that interface -- luckily all current
users (hostapd) do that. For monitor interfaces, the
old setting is preserved, but monitors are always
slaved to other devices anyway so no guarantees.

The second userland API change is the introduction
of a per virtual interface SET_CHANNEL command, that
hostapd should use going forward to make it easier
to understand what's going on (it can automatically
detect a kernel with this command).

Other than mac80211, no existing cfg80211 drivers
are affected by this change because they only allow
a single virtual interface.

mac80211, however, now needs to be aware that the
channel settings are per interface now, and needs
to disallow (for now) real multi-channel operation,
which is another important part of this patch.

One of the immediate benefits is that you can now
start hostapd to operate on a hardware that already
has a connection on another virtual interface, as
long as you specify the same channel.

Note that two things are left unhandled (this is an
improvement -- not a complete fix):
 * different HT/no-HT modes

   currently you could start an HT AP and then
   connect to a non-HT network on the same channel
   which would configure the hardware for no HT;
   that can be fixed fairly easily

 * CSA

   An AP we're connected to on a virtual interface
   might indicate switching channels, and in that
   case we would follow it, regardless of how many
   other interfaces are operating; this requires
   more effort to fix but is pretty rare after all

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
PLEASE test, especially all the monitoring people. I've done various
tests and it feels like a great improvement, and certainly shouldn't
really change anything in the typical 'single-interface' mode.

I'm going to subject this to some more testing, and post it for
inclusion in the next couple of days if all goes well, so there's your
chance :)

 drivers/net/wireless/libertas/cfg.c |    1 
 drivers/net/wireless/orinoco/cfg.c  |    1 
 drivers/net/wireless/rndis_wlan.c   |    4 
 include/linux/nl80211.h             |   13 ++
 include/net/cfg80211.h              |   11 +-
 net/mac80211/Makefile               |    3 
 net/mac80211/cfg.c                  |   41 +++++++++
 net/mac80211/chan.c                 |   57 ++++++++++++
 net/mac80211/ieee80211_i.h          |   11 ++
 net/wireless/chan.c                 |   56 +++---------
 net/wireless/core.h                 |   12 --
 net/wireless/ibss.c                 |    5 -
 net/wireless/nl80211.c              |  163 +++++++++++++++++++++++++++---------
 net/wireless/sme.c                  |    5 -
 net/wireless/wext-compat.c          |   15 ++-
 net/wireless/wext-sme.c             |    2 
 16 files changed, 291 insertions(+), 109 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2010-05-02 17:47:47.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2010-05-02 17:47:51.000000000 +0200
@@ -52,6 +52,8 @@
  *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE, %NL80211_ATTR_WIPHY_RETRY_SHORT,
  *	%NL80211_ATTR_WIPHY_RETRY_LONG, %NL80211_ATTR_WIPHY_FRAG_THRESHOLD,
  *	and/or %NL80211_ATTR_WIPHY_RTS_THRESHOLD.
+ *	However, for setting the channel, see %NL80211_CMD_SET_CHANNEL
+ *	instead, the support here is for backward compatibility only.
  * @NL80211_CMD_NEW_WIPHY: Newly created wiphy, response to get request
  *	or rename notification. Has attributes %NL80211_ATTR_WIPHY and
  *	%NL80211_ATTR_WIPHY_NAME.
@@ -329,6 +331,15 @@
  * @NL80211_CMD_NOTIFY_CQM: Connection quality monitor notification. This
  *	command is used as an event to indicate the that a trigger level was
  *	reached.
+ * @NL80211_CMD_SET_CHANNEL: Set the channel (using %NL80211_ATTR_WIPHY_FREQ
+ *	and %NL80211_ATTR_WIPHY_CHANNEL_TYPE) the given interface (identifed
+ *	by %NL80211_ATTR_IFINDEX) shall operate on.
+ *	In case multiple channels are supported by the device, the mechanism
+ *	with which it switches channels is implementation-defined.
+ *	When a monitor interface is given, it can only switch channel while
+ *	no other interfaces are operating to avoid disturbing the operation
+ *	of any other interfaces, and other interfaces will again take
+ *	precedence when they are used.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -428,6 +439,8 @@ enum nl80211_commands {
 	NL80211_CMD_SET_CQM,
 	NL80211_CMD_NOTIFY_CQM,
 
+	NL80211_CMD_SET_CHANNEL,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
--- wireless-testing.orig/net/wireless/nl80211.c	2010-05-02 17:47:47.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-05-02 17:47:51.000000000 +0200
@@ -689,10 +689,90 @@ static int parse_txq_params(struct nlatt
 	return 0;
 }
 
+static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
+{
+	/*
+	 * You can only set the channel explicitly for AP, mesh
+	 * and WDS type interfaces; all others have their channel
+	 * managed via their respective "establish a connection"
+	 * command (connect, join, ...)
+	 *
+	 * Monitors are special as they are normally slaved to
+	 * whatever else is going on, so they behave as though
+	 * you tried setting the wiphy channel itself.
+	 */
+	return !wdev ||
+		wdev->iftype == NL80211_IFTYPE_AP ||
+		wdev->iftype == NL80211_IFTYPE_WDS ||
+		wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
+		wdev->iftype == NL80211_IFTYPE_MONITOR;
+}
+
+static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
+				 struct wireless_dev *wdev,
+				 struct genl_info *info)
+{
+	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
+	u32 freq;
+	int result;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
+		return -EINVAL;
+
+	if (!nl80211_can_set_dev_channel(wdev))
+		return -EOPNOTSUPP;
+
+	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
+		channel_type = nla_get_u32(info->attrs[
+				   NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+		if (channel_type != NL80211_CHAN_NO_HT &&
+		    channel_type != NL80211_CHAN_HT20 &&
+		    channel_type != NL80211_CHAN_HT40PLUS &&
+		    channel_type != NL80211_CHAN_HT40MINUS)
+			return -EINVAL;
+	}
+
+	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+
+	mutex_lock(&rdev->devlist_mtx);
+	if (wdev) {
+		wdev_lock(wdev);
+		result = cfg80211_set_freq(rdev, wdev, freq, channel_type);
+		wdev_unlock(wdev);
+	} else {
+		result = cfg80211_set_freq(rdev, NULL, freq, channel_type);
+	}
+	mutex_unlock(&rdev->devlist_mtx);
+
+	return result;
+}
+
+static int nl80211_set_channel(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct net_device *netdev;
+	int result;
+
+	rtnl_lock();
+
+	result = get_rdev_dev_by_info_ifindex(info, &rdev, &netdev);
+	if (result)
+		goto unlock;
+
+	result = __nl80211_set_channel(rdev, netdev->ieee80211_ptr, info);
+
+ unlock:
+	rtnl_unlock();
+
+	return result;
+}
+
 static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev;
-	int result = 0, rem_txq_params = 0;
+	struct net_device *netdev;
+	struct wireless_dev *wdev;
+	int result, rem_txq_params = 0;
 	struct nlattr *nl_txq_params;
 	u32 changed;
 	u8 retry_short = 0, retry_long = 0;
@@ -701,16 +781,41 @@ static int nl80211_set_wiphy(struct sk_b
 
 	rtnl_lock();
 
+	/*
+	 * Try to find the wiphy and netdev. Normally this
+	 * function shouldn't need the netdev, but this is
+	 * done for backward compatibility -- previously
+	 * setting the channel was done per wiphy, but now
+	 * it is per netdev. Previous userland like hostapd
+	 * also passed a netdev to set_wiphy, so that it is
+	 * possible to let that go to the right netdev!
+	 */
+	result = get_rdev_dev_by_info_ifindex(info, &rdev, &netdev);
+
 	mutex_lock(&cfg80211_mutex);
+	if (result) {
+		rdev = __cfg80211_rdev_from_info(info);
+		if (IS_ERR(rdev)) {
+			mutex_unlock(&cfg80211_mutex);
+			result = PTR_ERR(rdev);
+			goto unlock;
+		}
+		wdev = NULL;
+		netdev = NULL;
+		result = 0;
+
+		mutex_lock(&rdev->mtx);
+	} else if (netif_running(netdev) &&
+		   nl80211_can_set_dev_channel(netdev->ieee80211_ptr))
+		wdev = netdev->ieee80211_ptr;
+	else
+		wdev = NULL;
 
-	rdev = __cfg80211_rdev_from_info(info);
-	if (IS_ERR(rdev)) {
-		mutex_unlock(&cfg80211_mutex);
-		result = PTR_ERR(rdev);
-		goto unlock;
-	}
+	/*
+	 * end workaround code, by now the rdev is available
+	 * and locked, and wdev may or may not be NULL
+	 */
 
-	mutex_lock(&rdev->mtx);
 
 	if (info->attrs[NL80211_ATTR_WIPHY_NAME])
 		result = cfg80211_dev_rename(
@@ -749,26 +854,7 @@ static int nl80211_set_wiphy(struct sk_b
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
-		u32 freq;
-
-		result = -EINVAL;
-
-		if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
-			channel_type = nla_get_u32(info->attrs[
-					   NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
-			if (channel_type != NL80211_CHAN_NO_HT &&
-			    channel_type != NL80211_CHAN_HT20 &&
-			    channel_type != NL80211_CHAN_HT40PLUS &&
-			    channel_type != NL80211_CHAN_HT40MINUS)
-				goto bad_res;
-		}
-
-		freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
-
-		mutex_lock(&rdev->devlist_mtx);
-		result = rdev_set_freq(rdev, NULL, freq, channel_type);
-		mutex_unlock(&rdev->devlist_mtx);
+		result = __nl80211_set_channel(rdev, wdev, info);
 		if (result)
 			goto bad_res;
 	}
@@ -865,6 +951,8 @@ static int nl80211_set_wiphy(struct sk_b
 
  bad_res:
 	mutex_unlock(&rdev->mtx);
+	if (netdev)
+		dev_put(netdev);
  unlock:
 	rtnl_unlock();
 	return result;
@@ -3562,9 +3650,8 @@ static int nl80211_associate(struct sk_b
 {
 	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
-	struct wireless_dev *wdev;
 	struct cfg80211_crypto_settings crypto;
-	struct ieee80211_channel *chan, *fixedchan;
+	struct ieee80211_channel *chan;
 	const u8 *bssid, *ssid, *ie = NULL, *prev_bssid = NULL;
 	int err, ssid_len, ie_len = 0;
 	bool use_mfp = false;
@@ -3607,16 +3694,6 @@ static int nl80211_associate(struct sk_b
 		goto out;
 	}
 
-	mutex_lock(&rdev->devlist_mtx);
-	wdev = dev->ieee80211_ptr;
-	fixedchan = rdev_fixed_channel(rdev, wdev);
-	if (fixedchan && chan != fixedchan) {
-		err = -EBUSY;
-		mutex_unlock(&rdev->devlist_mtx);
-		goto out;
-	}
-	mutex_unlock(&rdev->devlist_mtx);
-
 	ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
 	ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
 
@@ -5186,6 +5263,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_CHANNEL,
+		.doit = nl80211_set_channel,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
--- wireless-testing.orig/include/net/cfg80211.h	2010-05-02 17:47:47.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-05-02 17:47:51.000000000 +0200
@@ -966,7 +966,11 @@ struct cfg80211_pmksa {
  *
  * @set_txq_params: Set TX queue parameters
  *
- * @set_channel: Set channel
+ * @set_channel: Set channel for a given wireless interface. Some devices
+ *	may support multi-channel operation (by channel hopping) so cfg80211
+ *	doesn't verify much. Note, however, that the passed netdev may be
+ *	%NULL as well if the user requested changing the channel for the
+ *	device itself, or for a monitor interface.
  *
  * @scan: Request to do a scan. If returning zero, the scan request is given
  *	the driver, and will be valid until passed to cfg80211_scan_done().
@@ -1095,7 +1099,7 @@ struct cfg80211_ops {
 	int	(*set_txq_params)(struct wiphy *wiphy,
 				  struct ieee80211_txq_params *params);
 
-	int	(*set_channel)(struct wiphy *wiphy,
+	int	(*set_channel)(struct wiphy *wiphy, struct net_device *dev,
 			       struct ieee80211_channel *chan,
 			       enum nl80211_channel_type channel_type);
 
@@ -1461,6 +1465,8 @@ struct cfg80211_cached_keys;
  * @list: (private) Used to collect the interfaces
  * @netdev: (private) Used to reference back to the netdev
  * @current_bss: (private) Used by the internal configuration code
+ * @channel: (private) Used by the internal configuration code to track
+ *	user-set AP, monitor and WDS channels for wireless extensions
  * @bssid: (private) Used by the internal configuration code
  * @ssid: (private) Used by the internal configuration code
  * @ssid_len: (private) Used by the internal configuration code
@@ -1507,6 +1513,7 @@ struct wireless_dev {
 	struct cfg80211_internal_bss *authtry_bsses[MAX_AUTH_BSSES];
 	struct cfg80211_internal_bss *auth_bsses[MAX_AUTH_BSSES];
 	struct cfg80211_internal_bss *current_bss; /* associated / joined */
+	struct ieee80211_channel *channel;
 
 	bool ps;
 	int ps_timeout;
--- wireless-testing.orig/net/wireless/chan.c	2010-05-02 17:47:47.000000000 +0200
+++ wireless-testing/net/wireless/chan.c	2010-05-02 17:47:51.000000000 +0200
@@ -10,38 +10,6 @@
 #include "core.h"
 
 struct ieee80211_channel *
-rdev_fixed_channel(struct cfg80211_registered_device *rdev,
-		   struct wireless_dev *for_wdev)
-{
-	struct wireless_dev *wdev;
-	struct ieee80211_channel *result = NULL;
-
-	WARN_ON(!mutex_is_locked(&rdev->devlist_mtx));
-
-	list_for_each_entry(wdev, &rdev->netdev_list, list) {
-		if (wdev == for_wdev)
-			continue;
-
-		/*
-		 * Lock manually to tell lockdep about allowed
-		 * nesting here if for_wdev->mtx is held already.
-		 * This is ok as it's all under the rdev devlist
-		 * mutex and as such can only be done once at any
-		 * given time.
-		 */
-		mutex_lock_nested(&wdev->mtx, SINGLE_DEPTH_NESTING);
-		if (wdev->current_bss)
-			result = wdev->current_bss->pub.channel;
-		wdev_unlock(wdev);
-
-		if (result)
-			break;
-	}
-
-	return result;
-}
-
-struct ieee80211_channel *
 rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 		  int freq, enum nl80211_channel_type channel_type)
 {
@@ -75,15 +43,22 @@ rdev_freq_to_chan(struct cfg80211_regist
 	return chan;
 }
 
-int rdev_set_freq(struct cfg80211_registered_device *rdev,
-		  struct wireless_dev *for_wdev,
-		  int freq, enum nl80211_channel_type channel_type)
+int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
+		      struct wireless_dev *wdev, int freq,
+		      enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_channel *chan;
 	int result;
 
-	if (rdev_fixed_channel(rdev, for_wdev))
-		return -EBUSY;
+	if (wdev->iftype == NL80211_IFTYPE_MONITOR)
+		wdev = NULL;
+
+	if (wdev) {
+		ASSERT_WDEV_LOCK(wdev);
+
+		if (!netif_running(wdev->netdev))
+			return -ENETDOWN;
+	}
 
 	if (!rdev->ops->set_channel)
 		return -EOPNOTSUPP;
@@ -92,11 +67,14 @@ int rdev_set_freq(struct cfg80211_regist
 	if (!chan)
 		return -EINVAL;
 
-	result = rdev->ops->set_channel(&rdev->wiphy, chan, channel_type);
+	result = rdev->ops->set_channel(&rdev->wiphy,
+					wdev ? wdev->netdev : NULL,
+					chan, channel_type);
 	if (result)
 		return result;
 
-	rdev->channel = chan;
+	if (wdev)
+		wdev->channel = chan;
 
 	return 0;
 }
--- wireless-testing.orig/net/wireless/core.h	2010-05-02 17:47:47.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2010-05-02 17:47:51.000000000 +0200
@@ -70,9 +70,6 @@ struct cfg80211_registered_device {
 	struct work_struct conn_work;
 	struct work_struct event_work;
 
-	/* current channel */
-	struct ieee80211_channel *channel;
-
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __attribute__((__aligned__(NETDEV_ALIGN)));
@@ -388,14 +385,11 @@ int cfg80211_change_iface(struct cfg8021
 void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
 
 struct ieee80211_channel *
-rdev_fixed_channel(struct cfg80211_registered_device *rdev,
-		   struct wireless_dev *for_wdev);
-struct ieee80211_channel *
 rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 		  int freq, enum nl80211_channel_type channel_type);
-int rdev_set_freq(struct cfg80211_registered_device *rdev,
-		  struct wireless_dev *for_wdev,
-		  int freq, enum nl80211_channel_type channel_type);
+int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
+		      struct wireless_dev *wdev, int freq,
+		      enum nl80211_channel_type channel_type);
 
 u16 cfg80211_calculate_bitrate(struct rate_info *rate);
 
--- wireless-testing.orig/net/wireless/wext-compat.c	2010-05-02 17:47:47.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2010-05-02 17:47:51.000000000 +0200
@@ -782,16 +782,22 @@ int cfg80211_wext_siwfreq(struct net_dev
 		return cfg80211_mgd_wext_siwfreq(dev, info, wextfreq, extra);
 	case NL80211_IFTYPE_ADHOC:
 		return cfg80211_ibss_wext_siwfreq(dev, info, wextfreq, extra);
-	default:
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_WDS:
+	case NL80211_IFTYPE_MESH_POINT:
 		freq = cfg80211_wext_freq(wdev->wiphy, wextfreq);
 		if (freq < 0)
 			return freq;
 		if (freq == 0)
 			return -EINVAL;
+		wdev_lock(wdev);
 		mutex_lock(&rdev->devlist_mtx);
-		err = rdev_set_freq(rdev, NULL, freq, NL80211_CHAN_NO_HT);
+		err = cfg80211_set_freq(rdev, wdev, freq, NL80211_CHAN_NO_HT);
 		mutex_unlock(&rdev->devlist_mtx);
+		wdev_unlock(wdev);
 		return err;
+	default:
+		return -EOPNOTSUPP;
 	}
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_siwfreq);
@@ -801,7 +807,6 @@ int cfg80211_wext_giwfreq(struct net_dev
 			  struct iw_freq *freq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_STATION:
@@ -809,9 +814,9 @@ int cfg80211_wext_giwfreq(struct net_dev
 	case NL80211_IFTYPE_ADHOC:
 		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
 	default:
-		if (!rdev->channel)
+		if (!wdev->channel)
 			return -EINVAL;
-		freq->m = rdev->channel->center_freq;
+		freq->m = wdev->channel->center_freq;
 		freq->e = 6;
 		return 0;
 	}
--- wireless-testing.orig/net/wireless/wext-sme.c	2010-05-02 17:47:47.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2010-05-02 17:47:51.000000000 +0200
@@ -108,7 +108,7 @@ int cfg80211_mgd_wext_siwfreq(struct net
 
 	/* SSID is not set, we just want to switch channel */
 	if (chan && !wdev->wext.connect.ssid_len) {
-		err = rdev_set_freq(rdev, wdev, freq, NL80211_CHAN_NO_HT);
+		err = cfg80211_set_freq(rdev, wdev, freq, NL80211_CHAN_NO_HT);
 		goto out;
 	}
 
--- wireless-testing.orig/net/wireless/ibss.c	2010-05-02 17:47:47.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2010-05-02 17:47:51.000000000 +0200
@@ -81,15 +81,10 @@ int __cfg80211_join_ibss(struct cfg80211
 			 struct cfg80211_cached_keys *connkeys)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct ieee80211_channel *chan;
 	int err;
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	chan = rdev_fixed_channel(rdev, wdev);
-	if (chan && chan != params->channel)
-		return -EBUSY;
-
 	if (wdev->ssid_len)
 		return -EALREADY;
 
--- wireless-testing.orig/net/wireless/sme.c	2010-05-02 17:47:47.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2010-05-02 17:47:51.000000000 +0200
@@ -741,7 +741,6 @@ int __cfg80211_connect(struct cfg80211_r
 		       const u8 *prev_bssid)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct ieee80211_channel *chan;
 	struct cfg80211_bss *bss = NULL;
 	int err;
 
@@ -750,10 +749,6 @@ int __cfg80211_connect(struct cfg80211_r
 	if (wdev->sme_state != CFG80211_SME_IDLE)
 		return -EALREADY;
 
-	chan = rdev_fixed_channel(rdev, wdev);
-	if (chan && chan != connect->channel)
-		return -EBUSY;
-
 	if (WARN_ON(wdev->connect_keys)) {
 		kfree(wdev->connect_keys);
 		wdev->connect_keys = NULL;
--- wireless-testing.orig/drivers/net/wireless/libertas/cfg.c	2010-05-02 17:47:48.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/cfg.c	2010-05-02 17:47:51.000000000 +0200
@@ -79,6 +79,7 @@ static const u32 cipher_suites[] = {
 
 
 static int lbs_cfg_set_channel(struct wiphy *wiphy,
+	struct net_device *netdev,
 	struct ieee80211_channel *chan,
 	enum nl80211_channel_type channel_type)
 {
--- wireless-testing.orig/drivers/net/wireless/orinoco/cfg.c	2010-05-02 17:47:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/orinoco/cfg.c	2010-05-02 17:47:51.000000000 +0200
@@ -159,6 +159,7 @@ static int orinoco_scan(struct wiphy *wi
 }
 
 static int orinoco_set_channel(struct wiphy *wiphy,
+			struct net_device *netdev,
 			struct ieee80211_channel *chan,
 			enum nl80211_channel_type channel_type)
 {
--- wireless-testing.orig/drivers/net/wireless/rndis_wlan.c	2010-05-02 17:47:47.000000000 +0200
+++ wireless-testing/drivers/net/wireless/rndis_wlan.c	2010-05-02 17:47:51.000000000 +0200
@@ -535,7 +535,7 @@ static int rndis_join_ibss(struct wiphy
 
 static int rndis_leave_ibss(struct wiphy *wiphy, struct net_device *dev);
 
-static int rndis_set_channel(struct wiphy *wiphy,
+static int rndis_set_channel(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_channel *chan, enum nl80211_channel_type channel_type);
 
 static int rndis_add_key(struct wiphy *wiphy, struct net_device *netdev,
@@ -2291,7 +2291,7 @@ static int rndis_leave_ibss(struct wiphy
 	return deauthenticate(usbdev);
 }
 
-static int rndis_set_channel(struct wiphy *wiphy,
+static int rndis_set_channel(struct wiphy *wiphy, struct net_device *netdev,
 	struct ieee80211_channel *chan, enum nl80211_channel_type channel_type)
 {
 	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
--- wireless-testing.orig/net/mac80211/cfg.c	2010-05-02 17:47:47.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-05-02 17:47:51.000000000 +0200
@@ -1162,11 +1162,24 @@ static int ieee80211_set_txq_params(stru
 }
 
 static int ieee80211_set_channel(struct wiphy *wiphy,
+				 struct net_device *netdev,
 				 struct ieee80211_channel *chan,
 				 enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 
+	switch (ieee80211_get_channel_mode(local, NULL)) {
+	case CHAN_MODE_HOPPING:
+		return -EBUSY;
+	case CHAN_MODE_FIXED:
+		if (local->oper_channel == chan &&
+		    local->oper_channel_type == channel_type)
+			return 0;
+		return -EBUSY;
+	case CHAN_MODE_UNDEFINED:
+		break;
+	}
+
 	local->oper_channel = chan;
 	local->oper_channel_type = channel_type;
 
@@ -1214,6 +1227,20 @@ static int ieee80211_auth(struct wiphy *
 static int ieee80211_assoc(struct wiphy *wiphy, struct net_device *dev,
 			   struct cfg80211_assoc_request *req)
 {
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	switch (ieee80211_get_channel_mode(local, sdata)) {
+	case CHAN_MODE_HOPPING:
+		return -EBUSY;
+	case CHAN_MODE_FIXED:
+		if (local->oper_channel == req->bss->channel)
+			break;
+		return -EBUSY;
+	case CHAN_MODE_UNDEFINED:
+		break;
+	}
+
 	return ieee80211_mgd_assoc(IEEE80211_DEV_TO_SUB_IF(dev), req);
 }
 
@@ -1236,8 +1263,22 @@ static int ieee80211_disassoc(struct wip
 static int ieee80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 			       struct cfg80211_ibss_params *params)
 {
+	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+	switch (ieee80211_get_channel_mode(local, sdata)) {
+	case CHAN_MODE_HOPPING:
+		return -EBUSY;
+	case CHAN_MODE_FIXED:
+		if (!params->channel_fixed)
+			return -EBUSY;
+		if (local->oper_channel == params->channel)
+			break;
+		return -EBUSY;
+	case CHAN_MODE_UNDEFINED:
+		break;
+	}
+
 	return ieee80211_ibss_join(sdata, params);
 }
 
--- wireless-testing.orig/net/mac80211/Makefile	2010-05-02 17:47:47.000000000 +0200
+++ wireless-testing/net/mac80211/Makefile	2010-05-02 17:47:51.000000000 +0200
@@ -23,7 +23,8 @@ mac80211-y := \
 	key.o \
 	util.o \
 	wme.o \
-	event.o
+	event.o \
+	chan.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += led.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/mac80211/chan.c	2010-05-02 17:47:51.000000000 +0200
@@ -0,0 +1,57 @@
+/*
+ * mac80211 - channel management
+ */
+
+#include "ieee80211_i.h"
+
+enum ieee80211_chan_mode
+__ieee80211_get_channel_mode(struct ieee80211_local *local,
+			     struct ieee80211_sub_if_data *ignore)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	WARN_ON(!mutex_is_locked(&local->iflist_mtx));
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (sdata == ignore)
+			continue;
+
+		if (!ieee80211_sdata_running(sdata))
+			continue;
+
+		if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
+			continue;
+
+		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+		    !sdata->u.mgd.associated)
+			continue;
+
+		if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+			if (!sdata->u.ibss.ssid_len)
+				continue;
+			if (!sdata->u.ibss.fixed_channel)
+				return CHAN_MODE_HOPPING;
+		}
+
+		if (sdata->vif.type == NL80211_IFTYPE_AP &&
+		    !sdata->u.ap.beacon)
+			continue;
+
+		return CHAN_MODE_FIXED;
+	}
+
+	return CHAN_MODE_UNDEFINED;
+}
+
+enum ieee80211_chan_mode
+ieee80211_get_channel_mode(struct ieee80211_local *local,
+			   struct ieee80211_sub_if_data *ignore)
+{
+	enum ieee80211_chan_mode mode;
+
+	mutex_lock(&local->iflist_mtx);
+	mode = __ieee80211_get_channel_mode(local, ignore);
+	mutex_unlock(&local->iflist_mtx);
+
+	return mode;
+}
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-05-02 17:47:50.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-05-02 17:47:51.000000000 +0200
@@ -1229,6 +1229,17 @@ int ieee80211_wk_remain_on_channel(struc
 int ieee80211_wk_cancel_remain_on_channel(
 	struct ieee80211_sub_if_data *sdata, u64 cookie);
 
+/* channel management */
+enum ieee80211_chan_mode {
+	CHAN_MODE_UNDEFINED,
+	CHAN_MODE_HOPPING,
+	CHAN_MODE_FIXED,
+};
+
+enum ieee80211_chan_mode
+ieee80211_get_channel_mode(struct ieee80211_local *local,
+			   struct ieee80211_sub_if_data *ignore);
+
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else


