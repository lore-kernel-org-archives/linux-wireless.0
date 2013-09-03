Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:51721 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab3ICRne (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 13:43:34 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 2/4] nl80211/cfg80211: enable DFS for IBSS mode
Date: Tue,  3 Sep 2013 19:43:19 +0200
Message-Id: <1378230201-25446-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130903_194343_417711_4DB1344E)
In-Reply-To: <1378230201-25446-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1378230201-25446-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To use DFS in IBSS mode, userspace is required to react to radar events.
It can inform nl80211 that it is capable of doing so by adding a
NL80211_ATTR_CONTROL_PORT_DFS attribute when joining the IBSS.

If this attribute is supplied, DFS channels may be used if the driver
supports it. Support will be checked even if a channel without DFS will
be joined, as the channel might change later due to scan activity or
channel switch announcements.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/cfg80211.h       |    6 ++++++
 include/uapi/linux/nl80211.h |    7 +++++++
 net/wireless/chan.c          |    3 ++-
 net/wireless/ibss.c          |   24 ++++++++++++++++++++----
 net/wireless/nl80211.c       |    8 ++++++--
 net/wireless/util.c          |   11 +++++++++--
 6 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0a2aafe..b20e8ca 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1656,6 +1656,9 @@ struct cfg80211_disassoc_request {
  *	sets/clears %NL80211_STA_FLAG_AUTHORIZED. If true, the driver is
  *	required to assume that the port is unauthorized until authorized by
  *	user space. Otherwise, port is marked authorized by default.
+ * @control_port_dfs: whether user space controls DFS operation, i.e.
+ *	changes the channel when a radar is detected. This is required
+ *	to operate on DFS channels.
  * @basic_rates: bitmap of basic rates to use when creating the IBSS
  * @mcast_rate: per-band multicast rate index + 1 (0: disabled)
  * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
@@ -1673,6 +1676,7 @@ struct cfg80211_ibss_params {
 	bool channel_fixed;
 	bool privacy;
 	bool control_port;
+	bool control_port_dfs;
 	int mcast_rate[IEEE80211_NUM_BANDS];
 	struct ieee80211_ht_cap ht_capa;
 	struct ieee80211_ht_cap ht_capa_mask;
@@ -3053,6 +3057,7 @@ struct cfg80211_cached_keys;
  * @conn: (private) cfg80211 software SME connection state machine data
  * @connect_keys: (private) keys to set after connection is established
  * @ibss_fixed: (private) IBSS is using fixed BSSID
+ * @ibss_dfs_possible: (private) IBSS may change to a DFS channel
  * @event_list: (private) list for internal event processing
  * @event_lock: (private) lock for event list
  */
@@ -3091,6 +3096,7 @@ struct wireless_dev {
 	struct ieee80211_channel *channel;
 
 	bool ibss_fixed;
+	bool ibss_dfs_possible;
 
 	bool ps;
 	int ps_timeout;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fde2c02..80e68e0 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1496,6 +1496,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_RXMGMT_FLAGS: flags for nl80211_send_mgmt(), u32.
  *	As specified in the &enum nl80211_rxmgmt_flags.
  *
+ * @NL80211_ATTR_CONTROL_PORT_DFS: A flag indicating whether user space
+ *	controls DFS operation in IBSS mode. If the flag is included in
+ *	%NL80211_CMD_JOIN_IBSS request, the driver will allow use of DFS
+ *	channels and reports radar events to userspace.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1806,6 +1811,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_RXMGMT_FLAGS,
 
+	NL80211_ATTR_CONTROL_PORT_DFS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 80504e6..92cf75f 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -504,7 +504,8 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 	case NL80211_IFTYPE_ADHOC:
 		if (wdev->current_bss) {
 			*chan = wdev->current_bss->pub.channel;
-			*chanmode = wdev->ibss_fixed
+			*chanmode = (wdev->ibss_fixed &&
+				     !wdev->ibss_dfs_possible)
 				  ? CHAN_MODE_SHARED
 				  : CHAN_MODE_EXCLUSIVE;
 			return;
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 39bff7d..5edd69e 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -83,6 +83,8 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 			 struct cfg80211_cached_keys *connkeys)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct ieee80211_channel *check_chan;
+	u8 radar_detect_width = 0;
 	int err;
 
 	ASSERT_WDEV_LOCK(wdev);
@@ -114,14 +116,28 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 	wdev->connect_keys = connkeys;
 
 	wdev->ibss_fixed = params->channel_fixed;
+	wdev->ibss_dfs_possible = params->control_port_dfs;
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.ibss.chandef = params->chandef;
 #endif
+	check_chan = params->chandef.chan;
+	if (params->control_port_dfs) {
+		/* use channel NULL to check for radar even if the current
+		 * channel is not a radar channel - it might decide to change
+		 * to DFS channel later.
+		 */
+		radar_detect_width = BIT(params->chandef.width);
+		check_chan = NULL;
+	}
+
+	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+					   check_chan,
+					   (params->channel_fixed &&
+					    !radar_detect_width)
+					   ? CHAN_MODE_SHARED
+					   : CHAN_MODE_EXCLUSIVE,
+					   radar_detect_width);
 
-	err = cfg80211_can_use_chan(rdev, wdev, params->chandef.chan,
-				    params->channel_fixed
-				    ? CHAN_MODE_SHARED
-				    : CHAN_MODE_EXCLUSIVE);
 	if (err) {
 		wdev->connect_keys = NULL;
 		return err;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cbbef88..d10410a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -354,6 +354,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_CSA_IES] = { .type = NLA_NESTED },
 	[NL80211_ATTR_CSA_C_OFF_BEACON] = { .type = NLA_U16 },
 	[NL80211_ATTR_CSA_C_OFF_PRESP] = { .type = NLA_U16 },
+	[NL80211_ATTR_CONTROL_PORT_DFS] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -5722,9 +5723,9 @@ skip_beacons:
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
 
-	/* DFS channels are only supported for AP/P2P GO ... for now. */
 	if (dev->ieee80211_ptr->iftype == NL80211_IFTYPE_AP ||
-	    dev->ieee80211_ptr->iftype == NL80211_IFTYPE_P2P_GO) {
+	    dev->ieee80211_ptr->iftype == NL80211_IFTYPE_P2P_GO ||
+	    dev->ieee80211_ptr->iftype == NL80211_IFTYPE_ADHOC) {
 		err = cfg80211_chandef_dfs_required(wdev->wiphy,
 						    &params.chandef);
 		if (err < 0) {
@@ -6556,6 +6557,9 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	ibss.control_port =
 		nla_get_flag(info->attrs[NL80211_ATTR_CONTROL_PORT]);
 
+	ibss.control_port_dfs =
+		nla_get_flag(info->attrs[NL80211_ATTR_CONTROL_PORT_DFS]);
+
 	err = cfg80211_join_ibss(rdev, dev, &ibss, connkeys);
 	if (err)
 		kfree(connkeys);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index ce090c1..beee988 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1255,8 +1255,15 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_WDS:
-		radar_required = !!(chan &&
-				    (chan->flags & IEEE80211_CHAN_RADAR));
+		/* if the interface could potentially choose a DFS channel,
+		 * then mark DFS as required.
+		 */
+		if (!chan) {
+			if (chanmode != CHAN_MODE_UNDEFINED && radar_detect)
+				radar_required = true;
+			break;
+		}
+		radar_required = !!(chan->flags & IEEE80211_CHAN_RADAR);
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
-- 
1.7.10.4

