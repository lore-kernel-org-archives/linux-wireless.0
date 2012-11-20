Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42073 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2KTVow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 16:44:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 04/10] nl80211/cfg80211: support VHT channel configuration
Date: Tue, 20 Nov 2012 22:45:10 +0100
Message-Id: <1353447916-17304-5-git-send-email-johannes@sipsolutions.net> (sfid-20121120_224458_026592_A172E37F)
In-Reply-To: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
References: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Change nl80211 to support specifying a VHT (or HT)
using the control channel frequency (as before) and
new attributes for the channel width and first and
second center frequency. The old channel type is of
course still supported for HT.

Also change the cfg80211 channel definition struct
to support these by adding the relevant fields to
it (and removing the _type field.)

This also adds new helper functions:
 - cfg80211_chandef_create to create a channel def
   struct given the control channel and channel type,
 - cfg80211_chandef_identical to check if two channel
   definitions are identical
 - cfg80211_chandef_compatible to check if the given
   channel definitions are compatible, and return the
   wider of the two

This isn't entirely complete, but that doesn't matter
until we have a driver using it. In particular, it's
missing
 - regulatory checks on the usable bandwidth (if that
   even makes sense)
 - regulatory TX power (database can't deal with it)
 - a proper channel compatibility calculation for the
   new channel types

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  10 +-
 include/net/cfg80211.h                     |  73 ++++++++-
 include/uapi/linux/nl80211.h               |  61 +++++--
 net/mac80211/cfg.c                         |   5 +-
 net/mac80211/ibss.c                        |  13 +-
 net/wireless/chan.c                        | 249 ++++++++++++++++++++++++++---
 net/wireless/core.h                        |   6 +
 net/wireless/ibss.c                        |   4 +-
 net/wireless/mesh.c                        |   4 +-
 net/wireless/nl80211.c                     | 160 ++++++++++++------
 net/wireless/trace.h                       |  28 ++--
 net/wireless/wext-compat.c                 |   4 +-
 net/wireless/wext-sme.c                    |   3 +-
 13 files changed, 507 insertions(+), 113 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index c0cc2e5..51bbe85 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1099,12 +1099,10 @@ void ath6kl_cfg80211_ch_switch_notify(struct ath6kl_vif *vif, int freq,
 		   "channel switch notify nw_type %d freq %d mode %d\n",
 		   vif->nw_type, freq, mode);
 
-	chandef.chan = ieee80211_get_channel(vif->ar->wiphy, freq);
-	if (WARN_ON(!chandef.chan))
-		return;
-
-	chandef._type = (mode == WMI_11G_HT20) ?
-		NL80211_CHAN_HT20 : NL80211_CHAN_NO_HT;
+	cfg80211_chandef_create(&chandef,
+				ieee80211_get_channel(vif->ar->wiphy, freq),
+				(mode == WMI_11G_HT20) ?
+					NL80211_CHAN_HT20 : NL80211_CHAN_NO_HT);
 
 	cfg80211_ch_switch_notify(vif->ndev, &chandef);
 }
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 310d35f..fd4c3c1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -308,21 +308,86 @@ struct key_params {
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
 
+/**
+ * cfg80211_get_chandef_type - return old channel type from chandef
+ * @chandef: the channel definition
+ *
+ * Returns the old channel type (NOHT, HT20, HT40+/-) from a given
+ * chandef, which must have a bandwidth allowing this conversion.
+ */
 static inline enum nl80211_channel_type
 cfg80211_get_chandef_type(const struct cfg80211_chan_def *chandef)
 {
-	return chandef->_type;
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		return NL80211_CHAN_NO_HT;
+	case NL80211_CHAN_WIDTH_20:
+		return NL80211_CHAN_HT20;
+	case NL80211_CHAN_WIDTH_40:
+		if (chandef->center_freq1 > chandef->chan->center_freq)
+			return NL80211_CHAN_HT40PLUS;
+		return NL80211_CHAN_HT40MINUS;
+	default:
+		WARN_ON(1);
+		return NL80211_CHAN_NO_HT;
+	}
+}
+
+/**
+ * cfg80211_chandef_create - create channel definition using channel type
+ * @chandef: the channel definition struct to fill
+ * @channel: the control channel
+ * @chantype: the channel type
+ *
+ * Given a channel type, create a channel definition.
+ */
+void cfg80211_chandef_create(struct cfg80211_chan_def *chandef,
+			     struct ieee80211_channel *channel,
+			     enum nl80211_channel_type chantype);
+
+/**
+ * cfg80211_chandef_identical - check if two channel definitions are identical
+ * @chandef1: first channel definition
+ * @chandef2: second channel definition
+ *
+ * Returns %true if the channels defined by the channel definitions are
+ * identical, %false otherwise.
+ */
+static inline bool
+cfg80211_chandef_identical(const struct cfg80211_chan_def *chandef1,
+			   const struct cfg80211_chan_def *chandef2)
+{
+	return (chandef1->chan == chandef2->chan &&
+		chandef1->width == chandef2->width &&
+		chandef1->center_freq1 == chandef2->center_freq1 &&
+		chandef1->center_freq2 == chandef2->center_freq2);
 }
 
 /**
+ * cfg80211_chandef_compatible - check if two channel definitions are compatible
+ * @chandef1: first channel definition
+ * @chandef2: second channel definition
+ *
+ * Returns %NULL if the given channel definitions are incompatible,
+ * chandef1 or chandef2 otherwise.
+ */
+const struct cfg80211_chan_def *
+cfg80211_chandef_compatible(const struct cfg80211_chan_def *chandef1,
+			    const struct cfg80211_chan_def *chandef2);
+
+/**
  * enum survey_info_flags - survey information flags
  *
  * @SURVEY_INFO_NOISE_DBM: noise (in dBm) was filled in
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 82b5ad3..84f9c7d 100644
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
@@ -566,8 +567,8 @@
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
@@ -771,14 +772,26 @@ enum nl80211_commands {
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
+ *	channel, used for anything but 20 MHz bandwidth
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
@@ -1553,6 +1566,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SCAN_FLAGS,
 
+	NL80211_ATTR_CHANNEL_WIDTH,
+	NL80211_ATTR_CENTER_FREQ1,
+	NL80211_ATTR_CENTER_FREQ2,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2455,6 +2472,32 @@ enum nl80211_channel_type {
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
+ * @NL80211_CHAN_WIDTH_80P80: 80+80 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
+ *	and %NL80211_ATTR_CENTER_FREQ2 attributes must be provided as well
+ * @NL80211_CHAN_WIDTH_160: 160 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
+ *	attribute must be provided as well
+ */
+enum nl80211_chan_width {
+	NL80211_CHAN_WIDTH_20_NOHT,
+	NL80211_CHAN_WIDTH_20,
+	NL80211_CHAN_WIDTH_40,
+	NL80211_CHAN_WIDTH_80,
+	NL80211_CHAN_WIDTH_80P80,
+	NL80211_CHAN_WIDTH_160,
+};
+
+/**
  * enum nl80211_bss - netlink attributes for a BSS
  *
  * @__NL80211_BSS_INVALID: invalid
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fbb2d07..7136b94 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3125,8 +3125,9 @@ static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 	if (chanctx_conf) {
-		chandef->chan = chanctx_conf->channel;
-		chandef->_type = chanctx_conf->channel_type;
+		cfg80211_chandef_create(chandef,
+					chanctx_conf->channel,
+					chanctx_conf->channel_type);
 		ret = 0;
 	}
 	rcu_read_unlock();
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 567f1bb..49a36dc 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -52,6 +52,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	struct cfg80211_chan_def chandef;
+	enum nl80211_channel_type chan_type;
 
 	lockdep_assert_held(&ifibss->mtx);
 
@@ -79,13 +80,13 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	chandef.chan = chan;
-	chandef._type = ifibss->channel_type;
+	chan_type = ifibss->channel_type;
+	cfg80211_chandef_create(&chandef, chan, chan_type);
 	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef))
-		chandef._type = NL80211_CHAN_HT20;
+		chan_type = NL80211_CHAN_HT20;
 
 	ieee80211_vif_release_channel(sdata);
-	if (ieee80211_vif_use_channel(sdata, chan, chandef._type,
+	if (ieee80211_vif_use_channel(sdata, chan, chan_type,
 				      ifibss->fixed_channel ?
 					IEEE80211_CHANCTX_SHARED :
 					IEEE80211_CHANCTX_EXCLUSIVE)) {
@@ -159,7 +160,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		       ifibss->ie, ifibss->ie_len);
 
 	/* add HT capability and information IEs */
-	if (chandef._type != NL80211_CHAN_NO_HT &&
+	if (chan_type != NL80211_CHAN_NO_HT &&
 	    sband->ht_cap.ht_supported) {
 		pos = skb_put(skb, 4 +
 				   sizeof(struct ieee80211_ht_cap) +
@@ -172,7 +173,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		 * keep them at 0
 		 */
 		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
-						 chan, chandef._type, 0);
+						 chan, chan_type, 0);
 	}
 
 	if (local->hw.queues >= IEEE80211_NUM_ACS) {
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index e834422..bf2dfd5 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -11,43 +11,252 @@
 #include "core.h"
 #include "rdev-ops.h"
 
-bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
-			     struct cfg80211_chan_def *chandef)
+void cfg80211_chandef_create(struct cfg80211_chan_def *chandef,
+			     struct ieee80211_channel *chan,
+			     enum nl80211_channel_type chan_type)
 {
-	struct ieee80211_channel *sec_chan;
-	int diff;
+	if (WARN_ON(!chan))
+		return;
 
-	trace_cfg80211_reg_can_beacon(wiphy, chandef);
+	chandef->chan = chan;
+	chandef->center_freq2 = 0;
 
-	switch (chandef->_type) {
+	switch (chan_type) {
+	case NL80211_CHAN_NO_HT:
+		chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
+		chandef->center_freq1 = chan->center_freq;
+		break;
+	case NL80211_CHAN_HT20:
+		chandef->width = NL80211_CHAN_WIDTH_20;
+		chandef->center_freq1 = chan->center_freq;
+		break;
 	case NL80211_CHAN_HT40PLUS:
-		diff = 20;
+		chandef->width = NL80211_CHAN_WIDTH_40;
+		chandef->center_freq1 = chan->center_freq + 10;
 		break;
 	case NL80211_CHAN_HT40MINUS:
-		diff = -20;
+		chandef->width = NL80211_CHAN_WIDTH_40;
+		chandef->center_freq1 = chan->center_freq - 10;
+		break;
+	default:
+		WARN_ON(1);
+	}
+}
+EXPORT_SYMBOL(cfg80211_chandef_create);
+
+bool cfg80211_chan_def_valid(const struct cfg80211_chan_def *chandef)
+{
+	u32 control_freq;
+
+	if (!chandef->chan)
+		return false;
+
+	control_freq = chandef->chan->center_freq;
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		if (chandef->center_freq1 != control_freq)
+			return false;
+		if (chandef->center_freq2)
+			return false;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		if (chandef->center_freq1 != control_freq + 10 &&
+		    chandef->center_freq1 != control_freq - 10)
+			return false;
+		if (chandef->center_freq2)
+			return false;
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
+		if (chandef->center_freq1 != control_freq + 30 &&
+		    chandef->center_freq1 != control_freq + 10 &&
+		    chandef->center_freq1 != control_freq - 10 &&
+		    chandef->center_freq1 != control_freq - 30)
+			return false;
+		if (!chandef->center_freq2)
+			return false;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		if (chandef->center_freq1 != control_freq + 30 &&
+		    chandef->center_freq1 != control_freq + 10 &&
+		    chandef->center_freq1 != control_freq - 10 &&
+		    chandef->center_freq1 != control_freq - 30)
+			return false;
+		if (chandef->center_freq2)
+			return false;
+		break;
+	case NL80211_CHAN_WIDTH_160:
+		if (chandef->center_freq1 != control_freq + 70 &&
+		    chandef->center_freq1 != control_freq + 50 &&
+		    chandef->center_freq1 != control_freq + 30 &&
+		    chandef->center_freq1 != control_freq + 10 &&
+		    chandef->center_freq1 != control_freq - 10 &&
+		    chandef->center_freq1 != control_freq - 30 &&
+		    chandef->center_freq1 != control_freq - 50 &&
+		    chandef->center_freq1 != control_freq - 70)
+			return false;
+		if (chandef->center_freq2)
+			return false;
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
+static void chandef_primary_freqs(const struct cfg80211_chan_def *c,
+				  int *pri40, int *pri80)
+{
+	int tmp;
+
+	switch (c->width) {
+	case NL80211_CHAN_WIDTH_40:
+		*pri40 = c->center_freq1;
+		*pri80 = 0;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_80P80:
+		*pri80 = c->center_freq1;
+		/* n_P20 */
+		tmp = (30 + c->chan->center_freq - c->center_freq1)/20;
+		/* n_P40 */
+		tmp /= 2;
+		/* freq_P40 */
+		*pri40 = c->center_freq1 - 20 + 40 * tmp;
+		break;
+	case NL80211_CHAN_WIDTH_160:
+		/* n_P20 */
+		tmp = (70 + c->chan->center_freq - c->center_freq1)/20;
+		/* n_P40 */
+		tmp /= 2;
+		/* freq_P40 */
+		*pri40 = c->center_freq1 - 60 + 40 * tmp;
+		/* n_P80 */
+		tmp /= 2;
+		*pri80 = c->center_freq1 - 40 + 80 * tmp;
 		break;
 	default:
-		trace_cfg80211_return_bool(true);
-		return true;
+		WARN_ON_ONCE(1);
 	}
+}
+
+const struct cfg80211_chan_def *
+cfg80211_chandef_compatible(const struct cfg80211_chan_def *c1,
+			    const struct cfg80211_chan_def *c2)
+{
+	u32 c1_pri40, c1_pri80, c2_pri40, c2_pri80;
 
-	sec_chan = ieee80211_get_channel(wiphy,
-					 chandef->chan->center_freq + diff);
-	if (!sec_chan) {
+	/* If they are identical, return */
+	if (cfg80211_chandef_identical(c1, c2))
+		return c1;
+
+	/* otherwise, must have same control channel */
+	if (c1->chan != c2->chan)
+		return NULL;
+
+	/*
+	 * If they have the same width, but aren't identical,
+	 * then they can't be compatible.
+	 */
+	if (c1->width == c2->width)
+		return NULL;
+
+	if (c1->width == NL80211_CHAN_WIDTH_20_NOHT ||
+	    c1->width == NL80211_CHAN_WIDTH_20)
+		return c2;
+
+	if (c2->width == NL80211_CHAN_WIDTH_20_NOHT ||
+	    c2->width == NL80211_CHAN_WIDTH_20)
+		return c1;
+
+	chandef_primary_freqs(c1, &c1_pri40, &c1_pri80);
+	chandef_primary_freqs(c2, &c2_pri40, &c2_pri80);
+
+	if (c1_pri40 != c2_pri40)
+		return NULL;
+
+	WARN_ON(!c1_pri80 && !c2_pri80);
+	if (c1_pri80 && c2_pri80 && c1_pri80 != c2_pri80)
+		return NULL;
+
+	if (c1->width > c2->width)
+		return c1;
+	return c2;
+}
+EXPORT_SYMBOL(cfg80211_chandef_compatible);
+
+bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
+				 u32 center_freq, u32 bandwidth,
+				 u32 prohibited_flags)
+{
+	struct ieee80211_channel *c;
+	u32 freq;
+
+	for (freq = center_freq - bandwidth/2 + 10;
+	     freq <= center_freq + bandwidth/2 - 10;
+	     freq += 20) {
+		c = ieee80211_get_channel(wiphy, freq);
+		if (!c || c->flags & prohibited_flags)
+			return false;
+	}
+
+	return true;
+}
+
+static bool cfg80211_check_beacon_chans(struct wiphy *wiphy,
+					u32 center_freq, u32 bw)
+{
+	return cfg80211_secondary_chans_ok(wiphy, center_freq, bw,
+					   IEEE80211_CHAN_DISABLED |
+					   IEEE80211_CHAN_PASSIVE_SCAN |
+					   IEEE80211_CHAN_NO_IBSS |
+					   IEEE80211_CHAN_RADAR);
+}
+
+bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
+			     struct cfg80211_chan_def *chandef)
+{
+	u32 width;
+	bool res;
+
+	trace_cfg80211_reg_can_beacon(wiphy, chandef);
+
+	if (WARN_ON(!cfg80211_chan_def_valid(chandef))) {
 		trace_cfg80211_return_bool(false);
 		return false;
 	}
 
-	/* we'll need a DFS capability later */
-	if (sec_chan->flags & (IEEE80211_CHAN_DISABLED |
-			       IEEE80211_CHAN_PASSIVE_SCAN |
-			       IEEE80211_CHAN_NO_IBSS |
-			       IEEE80211_CHAN_RADAR)) {
+	switch (chandef->width) {
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
+	res = cfg80211_check_beacon_chans(wiphy, chandef->center_freq1, width);
+
+	if (res && chandef->center_freq2)
+		res = cfg80211_check_beacon_chans(wiphy, chandef->center_freq2,
+						  width);
+
+	trace_cfg80211_return_bool(res);
+	return res;
 }
 EXPORT_SYMBOL(cfg80211_reg_can_beacon);
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 6183a0d..a0c8dec 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -483,6 +483,12 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype, int num);
 
+bool cfg80211_chan_def_valid(const struct cfg80211_chan_def *chandef);
+
+bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
+				 u32 center_freq, u32 bandwidth,
+				 u32 prohibited_flags);
+
 #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
 
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index ccc8865..9b9551e 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -252,7 +252,7 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 
 	/* try to find an IBSS channel if none requested ... */
 	if (!wdev->wext.ibss.chandef.chan) {
-		wdev->wext.ibss.chandef._type = NL80211_CHAN_NO_HT;
+		wdev->wext.ibss.chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
 
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 			struct ieee80211_supported_band *sband;
@@ -352,7 +352,7 @@ int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 
 	if (chan) {
 		wdev->wext.ibss.chandef.chan = chan;
-		wdev->wext.ibss.chandef._type = NL80211_CHAN_NO_HT;
+		wdev->wext.ibss.chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
 		wdev->wext.ibss.channel_fixed = true;
 	} else {
 		/* cfg80211_ibss_wext_join will pick one if needed */
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 12b5a57..3ee5a72 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -146,7 +146,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 		if (!setup->chandef.chan)
 			return -EINVAL;
 
-		setup->chandef._type = NL80211_CHAN_NO_HT;
+		setup->chandef.width = NL80211_CHAN_WIDTH_20_NOHT;;
 	}
 
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
@@ -198,7 +198,7 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 	 * compatible with 802.11 mesh.
 	 */
 	if (rdev->ops->libertas_set_mesh_channel) {
-		if (chandef->_type != NL80211_CHAN_NO_HT)
+		if (chandef->width != NL80211_CHAN_WIDTH_20_NOHT)
 			return -EINVAL;
 
 		if (!netif_running(wdev->netdev))
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 999108c..15158a3 100644
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
@@ -1360,35 +1365,13 @@ static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
 		wdev->iftype == NL80211_IFTYPE_P2P_GO;
 }
 
-static bool nl80211_valid_channel_type(struct genl_info *info,
-				       enum nl80211_channel_type *channel_type)
-{
-	enum nl80211_channel_type tmp;
-
-	if (!info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE])
-		return false;
-
-	tmp = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
-	if (tmp != NL80211_CHAN_NO_HT &&
-	    tmp != NL80211_CHAN_HT20 &&
-	    tmp != NL80211_CHAN_HT40PLUS &&
-	    tmp != NL80211_CHAN_HT40MINUS)
-		return false;
-
-	if (channel_type)
-		*channel_type = tmp;
-
-	return true;
-}
-
 static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 				 struct genl_info *info,
 				 struct cfg80211_chan_def *chandef)
 {
 	struct ieee80211_sta_ht_cap *ht_cap;
-	struct ieee80211_channel *sc;
-	u32 control_freq;
-	int offs;
+	struct ieee80211_sta_vht_cap *vht_cap;
+	u32 control_freq, width;
 
 	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
 		return -EINVAL;
@@ -1396,47 +1379,105 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 	control_freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
 
 	chandef->chan = ieee80211_get_channel(&rdev->wiphy, control_freq);
-	chandef->_type = NL80211_CHAN_NO_HT;
-
-	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
-	    !nl80211_valid_channel_type(info, &chandef->_type))
-		return -EINVAL;
+	chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
+	chandef->center_freq1 = control_freq;
+	chandef->center_freq2 = 0;
 
 	/* Primary channel not allowed */
 	if (!chandef->chan || chandef->chan->flags & IEEE80211_CHAN_DISABLED)
 		return -EINVAL;
 
+	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
+		enum nl80211_channel_type chantype;
+
+		chantype = nla_get_u32(
+				info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+
+		switch (chantype) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
+		case NL80211_CHAN_HT40PLUS:
+		case NL80211_CHAN_HT40MINUS:
+			cfg80211_chandef_create(chandef, chandef->chan,
+						chantype);
+			break;
+		default:
+			return -EINVAL;
+		}
+	} else if (info->attrs[NL80211_ATTR_CHANNEL_WIDTH]) {
+		chandef->width =
+			nla_get_u32(info->attrs[NL80211_ATTR_CHANNEL_WIDTH]);
+		if (info->attrs[NL80211_ATTR_CENTER_FREQ1])
+			chandef->center_freq1 =
+				nla_get_u32(
+					info->attrs[NL80211_ATTR_CENTER_FREQ1]);
+		if (info->attrs[NL80211_ATTR_CENTER_FREQ2])
+			chandef->center_freq2 =
+				nla_get_u32(
+					info->attrs[NL80211_ATTR_CENTER_FREQ2]);
+	}
+
 	ht_cap = &rdev->wiphy.bands[chandef->chan->band]->ht_cap;
+	vht_cap = &rdev->wiphy.bands[chandef->chan->band]->vht_cap;
 
-	switch (chandef->_type) {
-	case NL80211_CHAN_NO_HT:
+	if (!cfg80211_chan_def_valid(chandef))
+		return -EINVAL;
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_20:
+		if (!ht_cap->ht_supported)
+			return -EINVAL;
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		width = 20;
 		break;
-	case NL80211_CHAN_HT40MINUS:
-		if (chandef->chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
+	case NL80211_CHAN_WIDTH_40:
+		width = 40;
+		/* quick early regulatory check */
+		if (chandef->center_freq1 < control_freq &&
+		    chandef->chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
+			return -EINVAL;
+		if (chandef->center_freq1 > control_freq &&
+		    chandef->chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
+			return -EINVAL;
+		if (!ht_cap->ht_supported)
 			return -EINVAL;
-		offs = -20;
-		/* fall through */
-	case NL80211_CHAN_HT40PLUS:
-		if (chandef->_type == NL80211_CHAN_HT40PLUS) {
-			if (chandef->chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
-				return -EINVAL;
-			offs = 20;
-		}
 		if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
 		    ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT)
 			return -EINVAL;
-
-		sc = ieee80211_get_channel(&rdev->wiphy,
-					   chandef->chan->center_freq + offs);
-		if (!sc || sc->flags & IEEE80211_CHAN_DISABLED)
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		width = 80;
+		if (!vht_cap->vht_supported)
 			return -EINVAL;
-		/* fall through */
-	case NL80211_CHAN_HT20:
-		if (!ht_cap->ht_supported)
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
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
 
+	if (!cfg80211_secondary_chans_ok(&rdev->wiphy, chandef->center_freq1,
+					 width, IEEE80211_CHAN_DISABLED))
+		return -EINVAL;
+	if (chandef->center_freq2 &&
+	    !cfg80211_secondary_chans_ok(&rdev->wiphy, chandef->center_freq2,
+					 width, IEEE80211_CHAN_DISABLED))
+		return -EINVAL;
+
+	/* TODO: missing regulatory check on bandwidth */
+
 	return 0;
 }
 
@@ -1800,10 +1841,28 @@ static inline u64 wdev_id(struct wireless_dev *wdev)
 static int nl80211_send_chandef(struct sk_buff *msg,
 				 struct cfg80211_chan_def *chandef)
 {
+	WARN_ON(!cfg80211_chan_def_valid(chandef));
+
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
 			chandef->chan->center_freq))
 		return -ENOBUFS;
-	if (nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE, chandef->_type))
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_40:
+		if (nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
+				cfg80211_get_chandef_type(chandef)))
+			return -ENOBUFS;
+		break;
+	default:
+		break;
+	}
+	if (nla_put_u32(msg, NL80211_ATTR_CHANNEL_WIDTH, chandef->width))
+		return -ENOBUFS;
+	if (nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ1, chandef->center_freq1))
+		return -ENOBUFS;
+	if (chandef->center_freq2 &&
+	    nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ2, chandef->center_freq2))
 		return -ENOBUFS;
 	return 0;
 }
@@ -5447,7 +5506,8 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		if (IS_ERR(connkeys))
 			return PTR_ERR(connkeys);
 
-		if ((ibss.chandef._type != NL80211_CHAN_NO_HT) && no_ht) {
+		if ((ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT) &&
+		    no_ht) {
 			kfree(connkeys);
 			return -EINVAL;
 		}
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 1370d52..3c7aa12 100644
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
 #define CHAN_DEF_ASSIGN(chandef)					\
 	do {								\
 		if ((chandef) && (chandef)->chan) {			\
 			__entry->band = (chandef)->chan->band;		\
-			__entry->center_freq =				\
+			__entry->control_freq =				\
 				(chandef)->chan->center_freq;		\
-			__entry->channel_type = (chandef)->_type;	\
+			__entry->width = (chandef)->width;		\
+			__entry->center_freq1 = (chandef)->center_freq1;\
+			__entry->center_freq2 = (chandef)->center_freq2;\
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
+#define CHAN_DEF_PR_FMT							\
+	", band: %d, control freq: %u, width: %d, cf1: %u, cf2: %u"
+#define CHAN_DEF_PR_ARG __entry->band, __entry->control_freq,		\
+			__entry->width, __entry->center_freq1,		\
+			__entry->center_freq2
 
 #define SINFO_ENTRY __field(int, generation)	    \
 		    __field(u32, connected_time)    \
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index da3307f..f9680c9 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -785,7 +785,7 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	struct cfg80211_chan_def chandef = {
-		._type = NL80211_CHAN_NO_HT,
+		.width = NL80211_CHAN_WIDTH_20_NOHT,
 	};
 	int freq, err;
 
@@ -800,6 +800,7 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 			return freq;
 		if (freq == 0)
 			return -EINVAL;
+		chandef.center_freq1 = freq;
 		chandef.chan = ieee80211_get_channel(&rdev->wiphy, freq);
 		if (!chandef.chan)
 			return -EINVAL;
@@ -813,6 +814,7 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 			return freq;
 		if (freq == 0)
 			return -EINVAL;
+		chandef.center_freq1 = freq;
 		chandef.chan = ieee80211_get_channel(&rdev->wiphy, freq);
 		if (!chandef.chan)
 			return -EINVAL;
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index e6e5dbf..873af63 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -120,7 +120,8 @@ int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
 	 */
 	if (chan && !wdev->wext.connect.ssid_len) {
 		struct cfg80211_chan_def chandef = {
-			._type = NL80211_CHAN_NO_HT,
+			.width = NL80211_CHAN_WIDTH_20_NOHT,
+			.center_freq1 = freq,
 		};
 
 		chandef.chan = ieee80211_get_channel(&rdev->wiphy, freq);
-- 
1.8.0

