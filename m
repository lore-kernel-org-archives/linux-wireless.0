Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51018 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab2KHXMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 18:12:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: maheshp@posedge.com, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/2] nl80211/cfg80211: support VHT channel configuration
Date: Fri,  9 Nov 2012 00:12:37 +0100
Message-Id: <1352416357-17892-3-git-send-email-johannes@sipsolutions.net> (sfid-20121109_001218_527314_5BDC7D0C)
In-Reply-To: <1352416357-17892-1-git-send-email-johannes@sipsolutions.net>
References: <1352416357-17892-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

...

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  10 +-
 include/net/cfg80211.h                     |  28 ++++-
 include/uapi/linux/nl80211.h               |  61 ++++++++--
 net/mac80211/cfg.c                         |   5 +-
 net/mac80211/ibss.c                        |  13 ++-
 net/wireless/chan.c                        | 160 +++++++++++++++++++++++----
 net/wireless/core.h                        |   2 +
 net/wireless/ibss.c                        |   4 +-
 net/wireless/mesh.c                        |   4 +-
 net/wireless/nl80211.c                     | 172 +++++++++++++++++++++--------
 net/wireless/trace.h                       |  28 +++--
 net/wireless/wext-compat.c                 |   4 +-
 net/wireless/wext-sme.c                    |   3 +-
 13 files changed, 386 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 072d19c..1866c53 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1099,12 +1099,10 @@ void ath6kl_cfg80211_ch_switch_notify(struct ath6kl_vif *vif, int freq,
 		   "channel switch notify nw_type %d freq %d mode %d\n",
 		   vif->nw_type, freq, mode);
 
-	chan_def.chan = ieee80211_get_channel(vif->ar->wiphy, freq);
-	if (WARN_ON(!chan_def.chan))
-		return;
-
-	chan_def._type = (mode == WMI_11G_HT20) ?
-		NL80211_CHAN_HT20 : NL80211_CHAN_NO_HT;
+	cfg80211_create_chandef(&chan_def,
+				ieee80211_get_channel(vif->ar->wiphy, freq),
+				(mode == WMI_11G_HT20) ?
+					NL80211_CHAN_HT20 : NL80211_CHAN_NO_HT);
 
 	cfg80211_ch_switch_notify(vif->ndev, &chan_def);
 }
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ddabe1cb..3384d11 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -308,20 +308,40 @@ struct key_params {
 /**
  * struct cfg80211_chan_def - channel definition
  * @chan: the (control) channel
- * @_type: the channel type, don't use this field,
- *	use cfg80211_get_chandef_type() if needed.
+ * @width: channel width
+ * @center_freq1: center frequency of first segment
+ * @center_freq2: center frequency of second segment
+ *	(only with 80+80 MHz)
  */
 struct cfg80211_chan_def {
 	struct ieee80211_channel *chan;
-	enum nl80211_channel_type _type;
+	enum nl80211_chan_width width;
+	u32 center_freq1;
+	u32 center_freq2;
 };
 
 static inline enum nl80211_channel_type
 cfg80211_get_chandef_type(const struct cfg80211_chan_def *chan_def)
 {
-	return chan_def->_type;
+	switch (chan_def->width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		return NL80211_CHAN_NO_HT;
+	case NL80211_CHAN_WIDTH_20:
+		return NL80211_CHAN_HT20;
+	case NL80211_CHAN_WIDTH_40:
+		if (chan_def->center_freq1 > chan_def->chan->center_freq)
+			return NL80211_CHAN_HT40PLUS;
+		return NL80211_CHAN_HT40MINUS;
+	default:
+		WARN_ON(1);
+		return NL80211_CHAN_NO_HT;
+	}
 }
 
+void cfg80211_create_chandef(struct cfg80211_chan_def *chan_def,
+			     struct ieee80211_channel *chan,
+			     enum nl80211_channel_type chan_type);
+
 /**
  * enum survey_info_flags - survey information flags
  *
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index ac5c446..537361a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -118,8 +118,9 @@
  *	to get a list of all present wiphys.
  * @NL80211_CMD_SET_WIPHY: set wiphy parameters, needs %NL80211_ATTR_WIPHY or
  *	%NL80211_ATTR_IFINDEX; can be used to set %NL80211_ATTR_WIPHY_NAME,
- *	%NL80211_ATTR_WIPHY_TXQ_PARAMS, %NL80211_ATTR_WIPHY_FREQ,
- *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE, %NL80211_ATTR_WIPHY_RETRY_SHORT,
+ *	%NL80211_ATTR_WIPHY_TXQ_PARAMS, %NL80211_ATTR_WIPHY_FREQ (and the
+ *	attributes determining the channel width; this is used for setting
+ *	monitor mode channel),  %NL80211_ATTR_WIPHY_RETRY_SHORT,
  *	%NL80211_ATTR_WIPHY_RETRY_LONG, %NL80211_ATTR_WIPHY_FRAG_THRESHOLD,
  *	and/or %NL80211_ATTR_WIPHY_RTS_THRESHOLD.
  *	However, for setting the channel, see %NL80211_CMD_SET_CHANNEL
@@ -171,7 +172,7 @@
  *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
  *	%NL80211_ATTR_AUTH_TYPE and %NL80211_ATTR_INACTIVITY_TIMEOUT.
  *	The channel to use can be set on the interface or be given using the
- *	%NL80211_ATTR_WIPHY_FREQ and %NL80211_ATTR_WIPHY_CHANNEL_TYPE attrs.
+ *	%NL80211_ATTR_WIPHY_FREQ and the attributes determining channel width.
  * @NL80211_CMD_NEW_BEACON: old alias for %NL80211_CMD_START_AP
  * @NL80211_CMD_STOP_AP: Stop AP operation on the given interface
  * @NL80211_CMD_DEL_BEACON: old alias for %NL80211_CMD_STOP_AP
@@ -471,8 +472,8 @@
  *	command is used as an event to indicate the that a trigger level was
  *	reached.
  * @NL80211_CMD_SET_CHANNEL: Set the channel (using %NL80211_ATTR_WIPHY_FREQ
- *	and %NL80211_ATTR_WIPHY_CHANNEL_TYPE) the given interface (identifed
- *	by %NL80211_ATTR_IFINDEX) shall operate on.
+ *	and the attributes determining channel width) the given interface
+ *	(identifed by %NL80211_ATTR_IFINDEX) shall operate on.
  *	In case multiple channels are supported by the device, the mechanism
  *	with which it switches channels is implementation-defined.
  *	When a monitor interface is given, it can only switch channel while
@@ -560,8 +561,8 @@
  *
  * @NL80211_CMD_CH_SWITCH_NOTIFY: An AP or GO may decide to switch channels
  *	independently of the userspace SME, send this event indicating
- *	%NL80211_ATTR_IFINDEX is now on %NL80211_ATTR_WIPHY_FREQ with
- *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE.
+ *	%NL80211_ATTR_IFINDEX is now on %NL80211_ATTR_WIPHY_FREQ and the
+ *	attributes determining channel width.
  *
  * @NL80211_CMD_START_P2P_DEVICE: Start the given P2P Device, identified by
  *	its %NL80211_ATTR_WDEV identifier. It must have been created with
@@ -765,14 +766,26 @@ enum nl80211_commands {
  *	/sys/class/ieee80211/<phyname>/index
  * @NL80211_ATTR_WIPHY_NAME: wiphy name (used for renaming)
  * @NL80211_ATTR_WIPHY_TXQ_PARAMS: a nested array of TX queue parameters
- * @NL80211_ATTR_WIPHY_FREQ: frequency of the selected channel in MHz
+ * @NL80211_ATTR_WIPHY_FREQ: frequency of the selected channel in MHz,
+ *	defines the channel together with the (deprecated)
+ *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE attribute or the attributes
+ *	%NL80211_ATTR_CHANNEL_WIDTH and if needed %NL80211_ATTR_CENTER_FREQ1
+ *	and %NL80211_ATTR_CENTER_FREQ2
+ * @NL80211_ATTR_CHANNEL_WIDTH: u32 attribute containing one of the values
+ *	of &enum nl80211_chan_width, describing the channel width. See the
+ *	documentation of the enum for more information.
+ * @NL80211_ATTR_CENTER_FREQ1: Center frequency of the first part of the
+ *	channel, used for anything but 20 Mhz bandwidth
+ * @NL80211_ATTR_CENTER_FREQ2: Center frequency of the second part of the
+ *	channel, used only for 80+80 MHz bandwidth
  * @NL80211_ATTR_WIPHY_CHANNEL_TYPE: included with NL80211_ATTR_WIPHY_FREQ
- *	if HT20 or HT40 are allowed (i.e., 802.11n disabled if not included):
+ *	if HT20 or HT40 are to be used (i.e., HT disabled if not included):
  *	NL80211_CHAN_NO_HT = HT not allowed (i.e., same as not including
  *		this attribute)
  *	NL80211_CHAN_HT20 = HT20 only
  *	NL80211_CHAN_HT40MINUS = secondary channel is below the primary channel
  *	NL80211_CHAN_HT40PLUS = secondary channel is above the primary channel
+ *	This attribute is now deprecated.
  * @NL80211_ATTR_WIPHY_RETRY_SHORT: TX retry limit for frames whose length is
  *	less than or equal to the RTS threshold; allowed range: 1..255;
  *	dot11ShortRetryLimit; u8
@@ -1547,6 +1560,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SCAN_FLAGS,
 
+	NL80211_ATTR_CHANNEL_WIDTH,
+	NL80211_ATTR_CENTER_FREQ1,
+	NL80211_ATTR_CENTER_FREQ2,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2453,6 +2470,32 @@ enum nl80211_channel_type {
 };
 
 /**
+ * enum nl80211_chan_width - channel width definitions
+ *
+ * These values are used with the %NL80211_ATTR_CHANNEL_WIDTH
+ * attribute.
+ *
+ * @NL80211_CHAN_WIDTH_20_NOHT: 20 MHz, non-HT channel
+ * @NL80211_CHAN_WIDTH_20: 20 MHz HT channel
+ * @NL80211_CHAN_WIDTH_40: 40 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
+ *	attribute must be provided as well
+ * @NL80211_CHAN_WIDTH_80: 80 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
+ *	attribute must be provided as well
+ * @NL80211_CHAN_WIDTH_160: 160 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
+ *	attribute must be provided as well
+ * @NL80211_CHAN_WIDTH_80P80: 80+80 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
+ *	and %NL80211_ATTR_CENTER_FREQ2 attributes must be provided as well
+ */
+enum nl80211_chan_width {
+	NL80211_CHAN_WIDTH_20_NOHT,
+	NL80211_CHAN_WIDTH_20,
+	NL80211_CHAN_WIDTH_40,
+	NL80211_CHAN_WIDTH_80,
+	NL80211_CHAN_WIDTH_160,
+	NL80211_CHAN_WIDTH_80P80,
+};
+
+/**
  * enum nl80211_bss - netlink attributes for a BSS
  *
  * @__NL80211_BSS_INVALID: invalid
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 94e7d95..aab9593 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3152,8 +3152,9 @@ static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (chanctx_conf) {
-		chan_def->chan = chanctx_conf->channel;
-		chan_def->_type = chanctx_conf->channel_type;
+		cfg80211_create_chandef(chan_def,
+					chanctx_conf->channel,
+					chanctx_conf->channel_type);
 		ret = 0;
 	}
 	rcu_read_unlock();
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 869cd28..f4eb639 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -52,6 +52,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	struct cfg80211_chan_def chan_def;
+	enum nl80211_channel_type chan_type;
 
 	lockdep_assert_held(&ifibss->mtx);
 
@@ -79,13 +80,13 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	chan_def.chan = chan;
-	chan_def._type = ifibss->channel_type;
+	chan_type = ifibss->channel_type;
+	cfg80211_create_chandef(&chan_def, chan, chan_type);
 	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chan_def))
-		chan_def._type = NL80211_CHAN_HT20;
+		chan_type = NL80211_CHAN_HT20;
 
 	ieee80211_vif_release_channel(sdata);
-	if (ieee80211_vif_use_channel(sdata, chan, chan_def._type,
+	if (ieee80211_vif_use_channel(sdata, chan, chan_type,
 				      ifibss->fixed_channel ?
 					IEEE80211_CHANCTX_SHARED :
 					IEEE80211_CHANCTX_EXCLUSIVE)) {
@@ -159,7 +160,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		       ifibss->ie, ifibss->ie_len);
 
 	/* add HT capability and information IEs */
-	if (chan_def._type != NL80211_CHAN_NO_HT &&
+	if (chan_type != NL80211_CHAN_NO_HT &&
 	    sband->ht_cap.ht_supported) {
 		pos = skb_put(skb, 4 +
 				   sizeof(struct ieee80211_ht_cap) +
@@ -172,7 +173,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		 * keep them at 0
 		 */
 		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
-						 chan, chan_def._type, 0);
+						 chan, chan_type, 0);
 	}
 
 	if (local->hw.queues >= IEEE80211_NUM_ACS) {
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index f074cef..c77ed82 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -11,43 +11,163 @@
 #include "core.h"
 #include "rdev-ops.h"
 
-bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
-			     struct cfg80211_chan_def *chan_def)
+void cfg80211_create_chandef(struct cfg80211_chan_def *chan_def,
+			     struct ieee80211_channel *chan,
+			     enum nl80211_channel_type chan_type)
 {
-	struct ieee80211_channel *sec_chan;
-	int diff;
+	if (WARN_ON(!chan))
+		return;
 
-	trace_cfg80211_reg_can_beacon(wiphy, chan_def);
+	chan_def->chan = chan;
+	chan_def->center_freq2 = 0;
 
-	switch (chan_def->_type) {
+	switch (chan_type) {
+	case NL80211_CHAN_NO_HT:
+		chan_def->width = NL80211_CHAN_WIDTH_20_NOHT;
+		chan_def->center_freq1 = chan->center_freq;
+		break;
+	case NL80211_CHAN_HT20:
+		chan_def->width = NL80211_CHAN_WIDTH_20;
+		chan_def->center_freq1 = chan->center_freq;
+		break;
 	case NL80211_CHAN_HT40PLUS:
-		diff = 20;
+		chan_def->width = NL80211_CHAN_WIDTH_40;
+		chan_def->center_freq1 = chan->center_freq + 10;
 		break;
 	case NL80211_CHAN_HT40MINUS:
-		diff = -20;
+		chan_def->width = NL80211_CHAN_WIDTH_40;
+		chan_def->center_freq1 = chan->center_freq - 10;
+		break;
+	default:
+		WARN_ON(1);
+	}
+}
+EXPORT_SYMBOL(cfg80211_create_chandef);
+
+bool cfg80211_chandef_valid(const struct cfg80211_chan_def *chan_def)
+{
+	u32 control_freq;
+
+	if (!chan_def->chan)
+		return false;
+
+	control_freq = chan_def->chan->center_freq;
+
+	switch (chan_def->width) {
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		if (chan_def->center_freq1 != control_freq)
+			return false;
+		if (chan_def->center_freq2)
+			return false;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		if (chan_def->center_freq1 != control_freq + 10 &&
+		    chan_def->center_freq1 != control_freq - 10)
+			return false;
+		if (chan_def->center_freq2)
+			return false;
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
+		if (chan_def->center_freq1 != control_freq + 30 &&
+		    chan_def->center_freq1 != control_freq + 10 &&
+		    chan_def->center_freq1 != control_freq - 10 &&
+		    chan_def->center_freq1 != control_freq - 30)
+			return false;
+		if (!chan_def->center_freq2)
+			return false;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		if (chan_def->center_freq1 != control_freq + 30 &&
+		    chan_def->center_freq1 != control_freq + 10 &&
+		    chan_def->center_freq1 != control_freq - 10 &&
+		    chan_def->center_freq1 != control_freq - 30)
+			return false;
+		if (chan_def->center_freq2)
+			return false;
+		break;
+	case NL80211_CHAN_WIDTH_160:
+		if (chan_def->center_freq1 != control_freq + 70 &&
+		    chan_def->center_freq1 != control_freq + 50 &&
+		    chan_def->center_freq1 != control_freq + 30 &&
+		    chan_def->center_freq1 != control_freq + 10 &&
+		    chan_def->center_freq1 != control_freq - 10 &&
+		    chan_def->center_freq1 != control_freq - 30 &&
+		    chan_def->center_freq1 != control_freq - 50 &&
+		    chan_def->center_freq1 != control_freq - 70)
+			return false;
+		if (chan_def->center_freq2)
+			return false;
 		break;
 	default:
-		trace_cfg80211_return_bool(true);
-		return true;
+		return false;
 	}
 
-	sec_chan = ieee80211_get_channel(wiphy,
-					 chan_def->chan->center_freq + diff);
-	if (!sec_chan) {
+	return true;
+}
+
+static bool cfg80211_check_beacon_chans(struct wiphy *wiphy,
+					u32 center_freq, u32 bw)
+{
+	struct ieee80211_channel *c;
+	u32 freq;
+
+	for (freq = center_freq - bw/2 + 10;
+	     freq <= center_freq + bw/2 - 10;
+	     freq += 20) {
+		c = ieee80211_get_channel(wiphy, freq);
+		if (!c || c->flags & (IEEE80211_CHAN_DISABLED |
+				      IEEE80211_CHAN_PASSIVE_SCAN |
+				      IEEE80211_CHAN_NO_IBSS |
+				      IEEE80211_CHAN_RADAR))
+			return false;
+	}
+
+	return true;
+}
+
+bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
+			     struct cfg80211_chan_def *chan_def)
+{
+	u32 width;
+	bool res;
+
+	trace_cfg80211_reg_can_beacon(wiphy, chan_def);
+
+	if (WARN_ON(!cfg80211_chandef_valid(chan_def))) {
 		trace_cfg80211_return_bool(false);
 		return false;
 	}
 
-	/* we'll need a DFS capability later */
-	if (sec_chan->flags & (IEEE80211_CHAN_DISABLED |
-			       IEEE80211_CHAN_PASSIVE_SCAN |
-			       IEEE80211_CHAN_NO_IBSS |
-			       IEEE80211_CHAN_RADAR)) {
+	switch (chan_def->width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+		width = 20;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		width = 40;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_80P80:
+		width = 80;
+		break;
+	case NL80211_CHAN_WIDTH_160:
+		width = 160;
+		break;
+	default:
+		WARN_ON_ONCE(1);
 		trace_cfg80211_return_bool(false);
 		return false;
 	}
-	trace_cfg80211_return_bool(true);
-	return true;
+
+	res = cfg80211_check_beacon_chans(wiphy, chan_def->center_freq1, width);
+
+	if (res && chan_def->center_freq1)
+		res = cfg80211_check_beacon_chans(wiphy, chan_def->center_freq2,
+						  width);
+
+	trace_cfg80211_return_bool(res);
+	return res;
 }
 EXPORT_SYMBOL(cfg80211_reg_can_beacon);
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index fe2d136..8d82eb4 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -483,6 +483,8 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype, int num);
 
+bool cfg80211_chandef_valid(const struct cfg80211_chan_def *chan_def);
+
 #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
 
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 15206ee..24d7dbc 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -252,7 +252,7 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 
 	/* try to find an IBSS channel if none requested ... */
 	if (!wdev->wext.ibss.chan_def.chan) {
-		wdev->wext.ibss.chan_def._type = NL80211_CHAN_NO_HT;
+		wdev->wext.ibss.chan_def.width = NL80211_CHAN_WIDTH_20_NOHT;
 
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 			struct ieee80211_supported_band *sband;
@@ -352,7 +352,7 @@ int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 
 	if (chan) {
 		wdev->wext.ibss.chan_def.chan = chan;
-		wdev->wext.ibss.chan_def._type = NL80211_CHAN_NO_HT;
+		wdev->wext.ibss.chan_def.width = NL80211_CHAN_WIDTH_20_NOHT;
 		wdev->wext.ibss.channel_fixed = true;
 	} else {
 		/* cfg80211_ibss_wext_join will pick one if needed */
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index be83e00..e2856d5 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -146,7 +146,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		if (!setup->chan_def.chan)
 			return -EINVAL;
 
-		setup->chan_def._type = NL80211_CHAN_NO_HT;
+		setup->chan_def.width = NL80211_CHAN_WIDTH_20_NOHT;;
 	}
 
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chan_def))
@@ -198,7 +198,7 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 	 * compatible with 802.11 mesh.
 	 */
 	if (rdev->ops->libertas_set_mesh_channel) {
-		if (chan_def->_type != NL80211_CHAN_NO_HT)
+		if (chan_def->width != NL80211_CHAN_WIDTH_20_NOHT)
 			return -EINVAL;
 
 		if (!netif_running(wdev->netdev))
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 139fb67..244a76a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -223,8 +223,13 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
 				      .len = 20-1 },
 	[NL80211_ATTR_WIPHY_TXQ_PARAMS] = { .type = NLA_NESTED },
+
 	[NL80211_ATTR_WIPHY_FREQ] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_CHANNEL_TYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_CHANNEL_WIDTH] = { .type = NLA_U32 },
+	[NL80211_ATTR_CENTER_FREQ1] = { .type = NLA_U32 },
+	[NL80211_ATTR_CENTER_FREQ2] = { .type = NLA_U32 },
+
 	[NL80211_ATTR_WIPHY_RETRY_SHORT] = { .type = NLA_U8 },
 	[NL80211_ATTR_WIPHY_RETRY_LONG] = { .type = NLA_U8 },
 	[NL80211_ATTR_WIPHY_FRAG_THRESHOLD] = { .type = NLA_U32 },
@@ -1360,25 +1365,21 @@ static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
 		wdev->iftype == NL80211_IFTYPE_P2P_GO;
 }
 
-static bool nl80211_valid_channel_type(struct genl_info *info,
-				       enum nl80211_channel_type *channel_type)
+static int nl80211_check_sec_chans(struct cfg80211_registered_device *rdev,
+				   u32 center_freq, u32 bw)
 {
-	enum nl80211_channel_type tmp;
-
-	if (!info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE])
-		return false;
+	struct ieee80211_channel *c;
+	u32 freq;
 
-	tmp = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
-	if (tmp != NL80211_CHAN_NO_HT &&
-	    tmp != NL80211_CHAN_HT20 &&
-	    tmp != NL80211_CHAN_HT40PLUS &&
-	    tmp != NL80211_CHAN_HT40MINUS)
-		return false;
-
-	if (channel_type)
-		*channel_type = tmp;
+	for (freq = center_freq - bw/2 + 10;
+	     freq <= center_freq + bw/2 - 10;
+	     freq += 20) {
+		c = ieee80211_get_channel(&rdev->wiphy, freq);
+		if (!c || c->flags & IEEE80211_CHAN_DISABLED)
+			return -EINVAL;
+	}
 
-	return true;
+	return 0;
 }
 
 static int nl80211_parse_chan_def(struct cfg80211_registered_device *rdev,
@@ -1386,9 +1387,8 @@ static int nl80211_parse_chan_def(struct cfg80211_registered_device *rdev,
 				  struct cfg80211_chan_def *chan_def)
 {
 	struct ieee80211_sta_ht_cap *ht_cap;
-	struct ieee80211_channel *sc;
-	u32 control_freq;
-	int offs;
+	struct ieee80211_sta_vht_cap *vht_cap;
+	u32 control_freq, width;
 
 	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
 		return -EINVAL;
@@ -1396,47 +1396,110 @@ static int nl80211_parse_chan_def(struct cfg80211_registered_device *rdev,
 	control_freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
 
 	chan_def->chan = ieee80211_get_channel(&rdev->wiphy, control_freq);
-	chan_def->_type = NL80211_CHAN_NO_HT;
-
-	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
-	    !nl80211_valid_channel_type(info, &chan_def->_type))
-		return -EINVAL;
+	chan_def->width = NL80211_CHAN_WIDTH_20_NOHT;
+	chan_def->center_freq1 = control_freq;
+	chan_def->center_freq2 = 0;
 
 	/* Primary channel not allowed */
 	if (!chan_def->chan || chan_def->chan->flags & IEEE80211_CHAN_DISABLED)
 		return -EINVAL;
 
+	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
+		enum nl80211_channel_type chantype;
+
+		chantype = nla_get_u32(
+				info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+
+		switch (chantype) {
+		case NL80211_CHAN_NO_HT:
+			chan_def->width = NL80211_CHAN_WIDTH_20_NOHT;
+			break;
+		case NL80211_CHAN_HT20:
+			chan_def->width = NL80211_CHAN_WIDTH_20;
+			break;
+		case NL80211_CHAN_HT40PLUS:
+			chan_def->width = NL80211_CHAN_WIDTH_40;
+			chan_def->center_freq1 = control_freq + 10;
+			break;
+		case NL80211_CHAN_HT40MINUS:
+			chan_def->width = NL80211_CHAN_WIDTH_40;
+			chan_def->center_freq1 = control_freq - 10;
+			break;
+		default:
+			return -EINVAL;
+		}
+	} else if (info->attrs[NL80211_ATTR_CHANNEL_WIDTH]) {
+		if (!info->attrs[NL80211_ATTR_CENTER_FREQ1])
+			return -EINVAL;
+		chan_def->width =
+			nla_get_u32(info->attrs[NL80211_ATTR_CHANNEL_WIDTH]);
+		chan_def->center_freq1 =
+			nla_get_u32(info->attrs[NL80211_ATTR_CENTER_FREQ1]);
+		if (info->attrs[NL80211_ATTR_CENTER_FREQ2])
+			chan_def->center_freq2 =
+				nla_get_u32(
+					info->attrs[NL80211_ATTR_CENTER_FREQ2]);
+	}
+
 	ht_cap = &rdev->wiphy.bands[chan_def->chan->band]->ht_cap;
+	vht_cap = &rdev->wiphy.bands[chan_def->chan->band]->vht_cap;
+
+	if (!cfg80211_chandef_valid(chan_def))
+		return -EINVAL;
 
-	switch (chan_def->_type) {
-	case NL80211_CHAN_NO_HT:
+	switch (chan_def->width) {
+	case NL80211_CHAN_WIDTH_20:
+		if (!ht_cap->ht_supported)
+			return -EINVAL;
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		width = 20;
 		break;
-	case NL80211_CHAN_HT40MINUS:
-		if (chan_def->chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
+	case NL80211_CHAN_WIDTH_40:
+		width = 40;
+		/* quick early regulatory check */
+		if (chan_def->center_freq1 < control_freq &&
+		    chan_def->chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
+			return -EINVAL;
+		if (chan_def->center_freq1 > control_freq &&
+		    chan_def->chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
+			return -EINVAL;
+		if (!ht_cap->ht_supported)
 			return -EINVAL;
-		offs = -20;
-		/* fall through */
-	case NL80211_CHAN_HT40PLUS:
-		if (chan_def->_type == NL80211_CHAN_HT40PLUS) {
-			if (chan_def->chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
-				return -EINVAL;
-			offs = 20;
-		}
 		if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
 		    ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT)
 			return -EINVAL;
-
-		sc = ieee80211_get_channel(&rdev->wiphy,
-					   chan_def->chan->center_freq + offs);
-		if (!sc || sc->flags & IEEE80211_CHAN_DISABLED)
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
+		width = 80;
+		if (!vht_cap->vht_supported)
 			return -EINVAL;
-		/* fall through */
-	case NL80211_CHAN_HT20:
-		if (!ht_cap->ht_supported)
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		width = 80;
+		if (!vht_cap->vht_supported)
+			return -EINVAL;
+		if (!(vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ))
+			return -EINVAL;
+		break;
+	case NL80211_CHAN_WIDTH_160:
+		width = 160;
+		if (!vht_cap->vht_supported)
+			return -EINVAL;
+		if (!(vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ))
 			return -EINVAL;
 		break;
+	default:
+		return -EINVAL;
 	}
 
+	if (nl80211_check_sec_chans(rdev, chan_def->center_freq1, width))
+		return -EINVAL;
+	if (chan_def->center_freq2 &&
+	    nl80211_check_sec_chans(rdev, chan_def->center_freq2, width))
+		return -EINVAL;
+
+	/* XXX: missing regulatory check on bandwidth */
+
 	return 0;
 }
 
@@ -1800,10 +1863,28 @@ static inline u64 wdev_id(struct wireless_dev *wdev)
 static int nl80211_send_chan_def(struct sk_buff *msg,
 				 struct cfg80211_chan_def *chan_def)
 {
+	WARN_ON(!cfg80211_chandef_valid(chan_def));
+
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
 			chan_def->chan->center_freq))
 		return -ENOBUFS;
-	if (nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE, chan_def->_type))
+	switch (chan_def->width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_40:
+		if (nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
+				cfg80211_get_chandef_type(chan_def)))
+			return -ENOBUFS;
+		break;
+	default:
+		break;
+	}
+	if (nla_put_u32(msg, NL80211_ATTR_CHANNEL_WIDTH, chan_def->width))
+		return -ENOBUFS;
+	if (nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ1, chan_def->center_freq1))
+		return -ENOBUFS;
+	if (chan_def->center_freq2 &&
+	    nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ2, chan_def->center_freq2))
 		return -ENOBUFS;
 	return 0;
 }
@@ -5471,7 +5552,8 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		if (IS_ERR(connkeys))
 			return PTR_ERR(connkeys);
 
-		if ((ibss.chan_def._type != NL80211_CHAN_NO_HT) && no_ht) {
+		if ((ibss.chan_def.width != NL80211_CHAN_WIDTH_20_NOHT) &&
+		    no_ht) {
 			kfree(connkeys);
 			return -EINVAL;
 		}
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 7b8515b..9554eab 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -126,25 +126,33 @@
 #define CHAN_PR_FMT ", band: %d, freq: %u"
 #define CHAN_PR_ARG __entry->band, __entry->center_freq
 
-#define CHAN_DEF_ENTRY __field(enum ieee80211_band, band)	\
-		       __field(u16, center_freq)		\
-		       __field(u32, channel_type)
+#define CHAN_DEF_ENTRY __field(enum ieee80211_band, band)		\
+		       __field(u32, control_freq)			\
+		       __field(u32, width)				\
+		       __field(u32, center_freq1)			\
+		       __field(u32, center_freq2)
 #define CHAN_DEF_ASSIGN(chan_def)					\
 	do {								\
 		if ((chan_def)->chan) {					\
 			__entry->band = (chan_def)->chan->band;		\
-			__entry->center_freq =				\
+			__entry->control_freq =				\
 				(chan_def)->chan->center_freq;		\
-			__entry->channel_type = (chan_def)->_type;	\
+			__entry->width = (chan_def)->width;		\
+			__entry->center_freq1 = (chan_def)->center_freq1;\
+			__entry->center_freq2 = (chan_def)->center_freq2;\
 		} else {						\
 			__entry->band = 0;				\
-			__entry->center_freq = 0;			\
-			__entry->channel_type = 0;			\
+			__entry->control_freq = 0;			\
+			__entry->width = 0;				\
+			__entry->center_freq1 = 0;			\
+			__entry->center_freq2 = 0;			\
 		}							\
 	} while (0)
-#define CHAN_DEF_PR_FMT ", band: %d, freq: %u, chantype: %d"
-#define CHAN_DEF_PR_ARG __entry->band, __entry->center_freq,		\
-			__entry->channel_type
+#define CHAN_DEF_PR_FMT 						\
+	", band: %d, control freq: %u, width: %d, cf1: %u, cf2: %u"
+#define CHAN_DEF_PR_ARG __entry->band, __entry->control_freq,		\
+			__entry->width, __entry->center_freq1,		\
+			__entry->center_freq2
 
 #define SINFO_ENTRY __field(int, generation)	    \
 		    __field(u32, connected_time)    \
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 752d947..0e8d147 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -785,7 +785,7 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	struct cfg80211_chan_def chan_def = {
-		._type = NL80211_CHAN_NO_HT,
+		.width = NL80211_CHAN_WIDTH_20_NOHT,
 	};
 	int freq, err;
 
@@ -800,6 +800,7 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 			return freq;
 		if (freq == 0)
 			return -EINVAL;
+		chan_def.center_freq1 = freq;
 		chan_def.chan = ieee80211_get_channel(&rdev->wiphy, freq);
 		if (!chan_def.chan)
 			return -EINVAL;
@@ -813,6 +814,7 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 			return freq;
 		if (freq == 0)
 			return -EINVAL;
+		chan_def.center_freq1 = freq;
 		chan_def.chan = ieee80211_get_channel(&rdev->wiphy, freq);
 		if (!chan_def.chan)
 			return -EINVAL;
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index b63a29f..ab8e374 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -120,7 +120,8 @@ int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
 	 */
 	if (chan && !wdev->wext.connect.ssid_len) {
 		struct cfg80211_chan_def chan_def = {
-			._type = NL80211_CHAN_NO_HT,
+			.width = NL80211_CHAN_WIDTH_20_NOHT,
+			.center_freq1 = freq,
 		};
 
 		chan_def.chan = ieee80211_get_channel(&rdev->wiphy, freq);
-- 
1.8.0

