Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41674 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759429Ab2EPVzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 17:55:05 -0400
Message-Id: <20120516215038.639976237@sipsolutions.net> (sfid-20120516_235550_751089_03F722BF)
Date: Wed, 16 May 2012 23:50:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 4/7] cfg80211: provide channel to start_ap function
References: <20120516215014.379333357@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of setting the channel first and then
starting the AP, let cfg80211 store the channel
and provide it as one of the AP settings.

This means that now you have to set the channel
before you can start an AP interface, but since
hostapd/wpa_supplicant always do that we're OK
with this change.

Alternatively, it's now possible to give the
channel as an attribute to the start-ap nl80211
command, overriding any preset channel.

Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   36 +------------------
 drivers/net/wireless/ath/ath6kl/core.h     |    3 -
 drivers/net/wireless/ath/ath6kl/main.c     |    1 
 include/linux/nl80211.h                    |    2 +
 include/net/cfg80211.h                     |   12 ++++++
 net/mac80211/cfg.c                         |    5 ++
 net/wireless/nl80211.c                     |   53 +++++++++++++++++++++++++++--
 7 files changed, 72 insertions(+), 40 deletions(-)

--- a/include/net/cfg80211.h	2012-05-16 23:35:46.000000000 +0200
+++ b/include/net/cfg80211.h	2012-05-16 23:49:23.000000000 +0200
@@ -404,6 +404,8 @@ struct cfg80211_beacon_data {
  *
  * Used to configure an AP interface.
  *
+ * @channel: the channel to start the AP on
+ * @channel_type: the channel type to use
  * @beacon: beacon data
  * @beacon_interval: beacon interval
  * @dtim_period: DTIM period
@@ -417,6 +419,9 @@ struct cfg80211_beacon_data {
  * @inactivity_timeout: time in seconds to determine station's inactivity.
  */
 struct cfg80211_ap_settings {
+	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
+
 	struct cfg80211_beacon_data beacon;
 
 	int beacon_interval, dtim_period;
@@ -2263,7 +2268,10 @@ struct cfg80211_cached_keys;
  * @netdev: (private) Used to reference back to the netdev
  * @current_bss: (private) Used by the internal configuration code
  * @channel: (private) Used by the internal configuration code to track
- *	user-set AP, monitor and WDS channels for wireless extensions
+ *	the user-set AP, monitor and WDS channel
+ * @preset_chan: (private) Used by the internal configuration code to
+ *	track the channel to be used for AP later
+ * @preset_chantype: (private) the corresponding channel type
  * @bssid: (private) Used by the internal configuration code
  * @ssid: (private) Used by the internal configuration code
  * @ssid_len: (private) Used by the internal configuration code
@@ -2314,6 +2322,8 @@ struct wireless_dev {
 
 	struct cfg80211_internal_bss *current_bss; /* associated / joined */
 	struct ieee80211_channel *channel;
+	struct ieee80211_channel *preset_chan;
+	enum nl80211_channel_type preset_chantype;
 
 	bool ps;
 	int ps_timeout;
--- a/net/wireless/nl80211.c	2012-05-16 21:15:51.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-05-16 23:49:23.000000000 +0200
@@ -921,7 +921,11 @@ static int nl80211_send_wiphy(struct sk_
 		if (nla_put_u32(msg, i, NL80211_CMD_SET_WIPHY_NETNS))
 			goto nla_put_failure;
 	}
-	CMD(set_channel, SET_CHANNEL);
+	if (dev->ops->set_channel || dev->ops->start_ap) {
+		i++;
+		if (nla_put_u32(msg, i, NL80211_CMD_SET_CHANNEL))
+			goto nla_put_failure;
+	}
 	CMD(set_wds_peer, SET_WDS_PEER);
 	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) {
 		CMD(tdls_mgmt, TDLS_MGMT);
@@ -1170,6 +1174,9 @@ static bool nl80211_can_set_dev_channel(
 	 * Monitors are special as they are normally slaved to
 	 * whatever else is going on, so they behave as though
 	 * you tried setting the wiphy channel itself.
+	 *
+	 * For AP/GO modes, it's only for compatibility, you can
+	 * also give the channel to the start-AP command.
 	 */
 	return !wdev ||
 		wdev->iftype == NL80211_IFTYPE_AP ||
@@ -1204,6 +1211,7 @@ static int __nl80211_set_channel(struct
 				 struct wireless_dev *wdev,
 				 struct genl_info *info)
 {
+	struct ieee80211_channel *channel;
 	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 	u32 freq;
 	int result;
@@ -1221,7 +1229,25 @@ static int __nl80211_set_channel(struct
 	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
 
 	mutex_lock(&rdev->devlist_mtx);
-	if (wdev) {
+	if (wdev) switch (wdev->iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		if (wdev->beacon_interval) {
+			result = -EBUSY;
+			break;
+		}
+		channel = rdev_freq_to_chan(rdev, freq, channel_type);
+		if (!channel || !cfg80211_can_beacon_sec_chan(&rdev->wiphy,
+							      channel,
+							      channel_type)) {
+			result = -EINVAL;
+			break;
+		}
+		wdev->preset_chan = channel;
+		wdev->preset_chantype = channel_type;
+		result = 0;
+		break;
+	default:
 		wdev_lock(wdev);
 		result = cfg80211_set_freq(rdev, wdev, freq, channel_type);
 		wdev_unlock(wdev);
@@ -2299,6 +2325,29 @@ static int nl80211_start_ap(struct sk_bu
 			info->attrs[NL80211_ATTR_INACTIVITY_TIMEOUT]);
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
+		enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
+
+		if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
+		    !nl80211_valid_channel_type(info, &channel_type))
+			return -EINVAL;
+
+		params.channel = rdev_freq_to_chan(rdev,
+			nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
+			channel_type);
+		if (!params.channel)
+			return -EINVAL;
+		params.channel_type = channel_type;
+	} else if (wdev->preset_chan) {
+		params.channel = wdev->preset_chan;
+		params.channel_type = wdev->preset_chantype;
+	} else
+		return -EINVAL;
+
+	if (!cfg80211_can_beacon_sec_chan(&rdev->wiphy, params.channel,
+					  params.channel_type))
+		return -EINVAL;
+
 	err = rdev->ops->start_ap(&rdev->wiphy, dev, &params);
 	if (!err)
 		wdev->beacon_interval = params.beacon_interval;
--- a/include/linux/nl80211.h	2012-05-16 21:15:51.000000000 +0200
+++ b/include/linux/nl80211.h	2012-05-16 23:35:47.000000000 +0200
@@ -170,6 +170,8 @@
  *	%NL80211_ATTR_CIPHER_GROUP, %NL80211_ATTR_WPA_VERSIONS,
  *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
  *	%NL80211_ATTR_AUTH_TYPE and %NL80211_ATTR_INACTIVITY_TIMEOUT.
+ *	The channel to use can be set on the interface or be given using the
+ *	%NL80211_ATTR_WIPHY_FREQ and %NL80211_ATTR_WIPHY_CHANNEL_TYPE attrs.
  * @NL80211_CMD_NEW_BEACON: old alias for %NL80211_CMD_START_AP
  * @NL80211_CMD_STOP_AP: Stop AP operation on the given interface
  * @NL80211_CMD_DEL_BEACON: old alias for %NL80211_CMD_STOP_AP
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c	2012-05-16 21:15:51.000000000 +0200
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c	2012-05-16 23:35:47.000000000 +0200
@@ -2585,35 +2585,6 @@ static int ath6kl_set_ies(struct ath6kl_
 	return 0;
 }
 
-static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
-			      struct ieee80211_channel *chan,
-			      enum nl80211_channel_type channel_type)
-{
-	struct ath6kl_vif *vif;
-
-	/*
-	 * 'dev' could be NULL if a channel change is required for the hardware
-	 * device itself, instead of a particular VIF.
-	 *
-	 * FIXME: To be handled properly when monitor mode is supported.
-	 */
-	if (!dev)
-		return -EBUSY;
-
-	vif = netdev_priv(dev);
-
-	if (!ath6kl_cfg80211_ready(vif))
-		return -EIO;
-
-	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: center_freq=%u hw_value=%u\n",
-		   __func__, chan->center_freq, chan->hw_value);
-	vif->next_chan = chan->center_freq;
-	vif->next_ch_type = channel_type;
-	vif->next_ch_band = chan->band;
-
-	return 0;
-}
-
 static int ath6kl_get_rsn_capab(struct cfg80211_beacon_data *beacon,
 				u8 *rsn_capab)
 {
@@ -2791,7 +2762,7 @@ static int ath6kl_start_ap(struct wiphy
 	p.ssid_len = vif->ssid_len;
 	memcpy(p.ssid, vif->ssid, vif->ssid_len);
 	p.dot11_auth_mode = vif->dot11_auth_mode;
-	p.ch = cpu_to_le16(vif->next_chan);
+	p.ch = cpu_to_le16(info->channel->center_freq);
 
 	/* Enable uAPSD support by default */
 	res = ath6kl_wmi_ap_set_apsd(ar->wmi, vif->fw_vif_idx, true);
@@ -2815,8 +2786,8 @@ static int ath6kl_start_ap(struct wiphy
 			return res;
 	}
 
-	if (ath6kl_set_htcap(vif, vif->next_ch_band,
-			     vif->next_ch_type != NL80211_CHAN_NO_HT))
+	if (ath6kl_set_htcap(vif, info->channel->band,
+			     info->channel_type != NL80211_CHAN_NO_HT))
 		return -EIO;
 
 	/*
@@ -3271,7 +3242,6 @@ static struct cfg80211_ops ath6kl_cfg802
 	.suspend = __ath6kl_cfg80211_suspend,
 	.resume = __ath6kl_cfg80211_resume,
 #endif
-	.set_channel = ath6kl_set_channel,
 	.start_ap = ath6kl_start_ap,
 	.change_beacon = ath6kl_change_beacon,
 	.stop_ap = ath6kl_stop_ap,
--- a/drivers/net/wireless/ath/ath6kl/core.h	2012-05-16 21:15:51.000000000 +0200
+++ b/drivers/net/wireless/ath/ath6kl/core.h	2012-05-16 23:35:47.000000000 +0200
@@ -553,9 +553,6 @@ struct ath6kl_vif {
 	u32 last_cancel_roc_id;
 	u32 send_action_id;
 	bool probe_req_report;
-	u16 next_chan;
-	enum nl80211_channel_type next_ch_type;
-	enum ieee80211_band next_ch_band;
 	u16 assoc_bss_beacon_int;
 	u16 listen_intvl_t;
 	u16 bmiss_time_t;
--- a/net/mac80211/cfg.c	2012-05-16 23:35:45.000000000 +0200
+++ b/net/mac80211/cfg.c	2012-05-16 23:49:23.000000000 +0200
@@ -823,6 +823,11 @@ static int ieee80211_start_ap(struct wip
 	if (old)
 		return -EALREADY;
 
+	err = ieee80211_set_channel(wiphy, dev, params->channel,
+				    params->channel_type);
+	if (err)
+		return err;
+
 	/*
 	 * Apply control port protocol, this allows us to
 	 * not encrypt dynamic WEP control frames.
--- a/drivers/net/wireless/ath/ath6kl/main.c	2012-05-16 21:15:51.000000000 +0200
+++ b/drivers/net/wireless/ath/ath6kl/main.c	2012-05-16 23:50:01.000000000 +0200
@@ -598,7 +598,6 @@ static int ath6kl_commit_ch_switch(struc
 
 	struct ath6kl *ar = vif->ar;
 
-	vif->next_chan = channel;
 	vif->profile.ch = cpu_to_le16(channel);
 
 	switch (vif->nw_type) {


