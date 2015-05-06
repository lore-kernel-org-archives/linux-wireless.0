Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36656 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbbEFN2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 09:28:36 -0400
Received: by wizk4 with SMTP id k4so202375039wiz.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 May 2015 06:28:35 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2] cfg80211: change GO_CONCURRENT to IR_CONCURRENT for STA
Date: Wed,  6 May 2015 16:28:31 +0300
Message-Id: <1430918911-14715-1-git-send-email-arik@wizery.com> (sfid-20150506_152840_617249_5E1E6643)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The GO_CONCURRENT regulatory definition can be extended to station
interfaces requesting to IR as part of TDLS off-channel operations.
Rename the GO_CONCURRENT flag to IR_CONCURRENT and allow the added
use-case.

Change internal users of GO_CONCURRENT to use the new definition.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |  2 +-
 include/net/cfg80211.h                       |  4 +--
 include/uapi/linux/nl80211.h                 | 28 +++++++++++---------
 net/wireless/chan.c                          | 38 ++++++++++++++++------------
 net/wireless/nl80211.c                       |  4 +--
 net/wireless/reg.c                           |  4 +--
 6 files changed, 45 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 83903a5..0b5a81d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -248,7 +248,7 @@ static u32 iwl_get_channel_flags(u8 ch_num, int ch_idx, bool is_5ghz,
 	 */
 	if ((nvm_flags & NVM_CHANNEL_GO_CONCURRENT) &&
 	    (flags & IEEE80211_CHAN_NO_IR))
-		flags |= IEEE80211_CHAN_GO_CONCURRENT;
+		flags |= IEEE80211_CHAN_IR_CONCURRENT;
 
 	return flags;
 }
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f8d6813..d63ecec 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -111,7 +111,7 @@ enum ieee80211_band {
  *	This may be due to the driver or due to regulatory bandwidth
  *	restrictions.
  * @IEEE80211_CHAN_INDOOR_ONLY: see %NL80211_FREQUENCY_ATTR_INDOOR_ONLY
- * @IEEE80211_CHAN_GO_CONCURRENT: see %NL80211_FREQUENCY_ATTR_GO_CONCURRENT
+ * @IEEE80211_CHAN_IR_CONCURRENT: see %NL80211_FREQUENCY_ATTR_IR_CONCURRENT
  * @IEEE80211_CHAN_NO_20MHZ: 20 MHz bandwidth is not permitted
  *	on this channel.
  * @IEEE80211_CHAN_NO_10MHZ: 10 MHz bandwidth is not permitted
@@ -129,7 +129,7 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_NO_80MHZ		= 1<<7,
 	IEEE80211_CHAN_NO_160MHZ	= 1<<8,
 	IEEE80211_CHAN_INDOOR_ONLY	= 1<<9,
-	IEEE80211_CHAN_GO_CONCURRENT	= 1<<10,
+	IEEE80211_CHAN_IR_CONCURRENT	= 1<<10,
 	IEEE80211_CHAN_NO_20MHZ		= 1<<11,
 	IEEE80211_CHAN_NO_10MHZ		= 1<<12,
 };
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 241220c..c0ab6b0 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2620,16 +2620,17 @@ enum nl80211_band_attr {
  *	an indoor surroundings, i.e., it is connected to AC power (and not
  *	through portable DC inverters) or is under the control of a master
  *	that is acting as an AP and is connected to AC power.
- * @NL80211_FREQUENCY_ATTR_GO_CONCURRENT: GO operation is allowed on this
+ * @NL80211_FREQUENCY_ATTR_IR_CONCURRENT: IR operation is allowed on this
  *	channel if it's connected concurrently to a BSS on the same channel on
  *	the 2 GHz band or to a channel in the same UNII band (on the 5 GHz
- *	band), and IEEE80211_CHAN_RADAR is not set. Instantiating a GO on a
- *	channel that has the GO_CONCURRENT attribute set can be done when there
- *	is a clear assessment that the device is operating under the guidance of
- *	an authorized master, i.e., setting up a GO while the device is also
- *	connected to an AP with DFS and radar detection on the UNII band (it is
- *	up to user-space, i.e., wpa_supplicant to perform the required
- *	verifications)
+ *	band), and IEEE80211_CHAN_RADAR is not set. Instantiating a GO or TDLS
+ *	off-channel on a channel that has the IR_CONCURRENT attribute set can be
+ *	done when there is a clear assessment that the device is operating under
+ *	the guidance of an authorized master, i.e., setting up a GO or TDLS
+ *	off-channel while the device is also connected to an AP with DFS and
+ *	radar detection on the UNII band (it is up to user-space, i.e.,
+ *	wpa_supplicant to perform the required verifications). Using this
+ *	attribute for IR is disallowed for master interfaces (IBSS, AP).
  * @NL80211_FREQUENCY_ATTR_NO_20MHZ: 20 MHz operation is not allowed
  *	on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_NO_10MHZ: 10 MHz operation is not allowed
@@ -2641,7 +2642,7 @@ enum nl80211_band_attr {
  * See https://apps.fcc.gov/eas/comments/GetPublishedDocument.html?id=327&tn=528122
  * for more information on the FCC description of the relaxations allowed
  * by NL80211_FREQUENCY_ATTR_INDOOR_ONLY and
- * NL80211_FREQUENCY_ATTR_GO_CONCURRENT.
+ * NL80211_FREQUENCY_ATTR_IR_CONCURRENT.
  */
 enum nl80211_frequency_attr {
 	__NL80211_FREQUENCY_ATTR_INVALID,
@@ -2659,7 +2660,7 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_160MHZ,
 	NL80211_FREQUENCY_ATTR_DFS_CAC_TIME,
 	NL80211_FREQUENCY_ATTR_INDOOR_ONLY,
-	NL80211_FREQUENCY_ATTR_GO_CONCURRENT,
+	NL80211_FREQUENCY_ATTR_IR_CONCURRENT,
 	NL80211_FREQUENCY_ATTR_NO_20MHZ,
 	NL80211_FREQUENCY_ATTR_NO_10MHZ,
 
@@ -2672,6 +2673,8 @@ enum nl80211_frequency_attr {
 #define NL80211_FREQUENCY_ATTR_PASSIVE_SCAN	NL80211_FREQUENCY_ATTR_NO_IR
 #define NL80211_FREQUENCY_ATTR_NO_IBSS		NL80211_FREQUENCY_ATTR_NO_IR
 #define NL80211_FREQUENCY_ATTR_NO_IR		NL80211_FREQUENCY_ATTR_NO_IR
+#define NL80211_FREQUENCY_ATTR_GO_CONCURRENT \
+					NL80211_FREQUENCY_ATTR_IR_CONCURRENT
 
 /**
  * enum nl80211_bitrate_attr - bitrate attributes
@@ -2830,7 +2833,7 @@ enum nl80211_sched_scan_match_attr {
  * @NL80211_RRF_AUTO_BW: maximum available bandwidth should be calculated
  *	base on contiguous rules and wider channels will be allowed to cross
  *	multiple contiguous/overlapping frequency ranges.
- * @NL80211_RRF_GO_CONCURRENT: See &NL80211_FREQUENCY_ATTR_GO_CONCURRENT
+ * @NL80211_RRF_IR_CONCURRENT: See &NL80211_FREQUENCY_ATTR_IR_CONCURRENT
  * @NL80211_RRF_NO_HT40MINUS: channels can't be used in HT40- operation
  * @NL80211_RRF_NO_HT40PLUS: channels can't be used in HT40+ operation
  * @NL80211_RRF_NO_80MHZ: 80MHz operation not allowed
@@ -2847,7 +2850,7 @@ enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_IR		= 1<<7,
 	__NL80211_RRF_NO_IBSS		= 1<<8,
 	NL80211_RRF_AUTO_BW		= 1<<11,
-	NL80211_RRF_GO_CONCURRENT	= 1<<12,
+	NL80211_RRF_IR_CONCURRENT	= 1<<12,
 	NL80211_RRF_NO_HT40MINUS	= 1<<13,
 	NL80211_RRF_NO_HT40PLUS		= 1<<14,
 	NL80211_RRF_NO_80MHZ		= 1<<15,
@@ -2859,6 +2862,7 @@ enum nl80211_reg_rule_flags {
 #define NL80211_RRF_NO_IR		NL80211_RRF_NO_IR
 #define NL80211_RRF_NO_HT40		(NL80211_RRF_NO_HT40MINUS |\
 					 NL80211_RRF_NO_HT40PLUS)
+#define NL80211_RRF_GO_CONCURRENT	NL80211_RRF_IR_CONCURRENT
 
 /* For backport compatibility with older userspace */
 #define NL80211_RRF_NO_IR_ALL		(NL80211_RRF_NO_IR | __NL80211_RRF_NO_IBSS)
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 5bcffdb..915b328 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -698,19 +698,20 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 EXPORT_SYMBOL(cfg80211_chandef_usable);
 
 /*
- * For GO only, check if the channel can be used under permissive conditions
- * mandated by the some regulatory bodies, i.e., the channel is marked with
- * IEEE80211_CHAN_GO_CONCURRENT and there is an additional station interface
+ * Check if the channel can be used under permissive conditions mandated by
+ * some regulatory bodies, i.e., the channel is marked with
+ * IEEE80211_CHAN_IR_CONCURRENT and there is an additional station interface
  * associated to an AP on the same channel or on the same UNII band
  * (assuming that the AP is an authorized master).
- * In addition allow the GO to operate on a channel on which indoor operation is
+ * In addition allow operation on a channel on which indoor operation is
  * allowed, iff we are currently operating in an indoor environment.
  */
-static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
+static bool cfg80211_ir_permissive_chan(struct wiphy *wiphy,
+					enum nl80211_iftype iftype,
 					struct ieee80211_channel *chan)
 {
 	struct wireless_dev *wdev;
-	struct wiphy *wiphy = wiphy_idx_to_wiphy(rdev->wiphy_idx);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	ASSERT_RTNL();
 
@@ -718,16 +719,22 @@ static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
 	    !(wiphy->regulatory_flags & REGULATORY_ENABLE_RELAX_NO_IR))
 		return false;
 
+	/* only valid for GO and TDLS off-channel (station/p2p-CL) */
+	if (iftype != NL80211_IFTYPE_P2P_GO &&
+	    iftype != NL80211_IFTYPE_STATION &&
+	    iftype != NL80211_IFTYPE_P2P_CLIENT)
+		return false;
+
 	if (regulatory_indoor_allowed() &&
 	    (chan->flags & IEEE80211_CHAN_INDOOR_ONLY))
 		return true;
 
-	if (!(chan->flags & IEEE80211_CHAN_GO_CONCURRENT))
+	if (!(chan->flags & IEEE80211_CHAN_IR_CONCURRENT))
 		return false;
 
 	/*
 	 * Generally, it is possible to rely on another device/driver to allow
-	 * the GO concurrent relaxation, however, since the device can further
+	 * the IR concurrent relaxation, however, since the device can further
 	 * enforce the relaxation (by doing a similar verifications as this),
 	 * and thus fail the GO instantiation, consider only the interfaces of
 	 * the current registered device.
@@ -748,7 +755,8 @@ static bool cfg80211_go_permissive_chan(struct cfg80211_registered_device *rdev,
 		 * GO_CONCURRENT is disconnected now. But then we must make sure
 		 * we're not outdoor on an indoor-only channel.
 		 */
-		if (wdev->iftype == NL80211_IFTYPE_P2P_GO &&
+		if (iftype == NL80211_IFTYPE_P2P_GO &&
+		    wdev->iftype == NL80211_IFTYPE_P2P_GO &&
 		    wdev->beacon_interval &&
 		    !(chan->flags & IEEE80211_CHAN_INDOOR_ONLY))
 			other_chan = wdev->chandef.chan;
@@ -793,7 +801,6 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 			     struct cfg80211_chan_def *chandef,
 			     enum nl80211_iftype iftype)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	bool res;
 	u32 prohibited_flags = IEEE80211_CHAN_DISABLED |
 			       IEEE80211_CHAN_RADAR;
@@ -801,13 +808,12 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 	trace_cfg80211_reg_can_beacon(wiphy, chandef, iftype);
 
 	/*
-	 * Under certain conditions suggested by the some regulatory bodies
-	 * a GO can operate on channels marked with IEEE80211_NO_IR
-	 * so set this flag only if such relaxations are not enabled and
-	 * the conditions are not met.
+	 * Under certain conditions suggested by some regulatory bodies a
+	 * GO/STA can IR on channels marked with IEEE80211_NO_IR. Set this flag
+	 * only if such relaxations are not enabled and the conditions are not
+	 * met.
 	 */
-	if (iftype != NL80211_IFTYPE_P2P_GO ||
-	    !cfg80211_go_permissive_chan(rdev, chandef->chan))
+	if (!cfg80211_ir_permissive_chan(wiphy, iftype, chandef->chan))
 		prohibited_flags |= IEEE80211_CHAN_NO_IR;
 
 	if (cfg80211_chandef_dfs_required(wiphy, chandef, iftype) > 0 &&
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8a33bba..c264eff 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -639,8 +639,8 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 		if ((chan->flags & IEEE80211_CHAN_INDOOR_ONLY) &&
 		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_INDOOR_ONLY))
 			goto nla_put_failure;
-		if ((chan->flags & IEEE80211_CHAN_GO_CONCURRENT) &&
-		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_GO_CONCURRENT))
+		if ((chan->flags & IEEE80211_CHAN_IR_CONCURRENT) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_IR_CONCURRENT))
 			goto nla_put_failure;
 		if ((chan->flags & IEEE80211_CHAN_NO_20MHZ) &&
 		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_20MHZ))
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 0e347f8..d359e06 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -989,8 +989,8 @@ static u32 map_regdom_flags(u32 rd_flags)
 		channel_flags |= IEEE80211_CHAN_NO_OFDM;
 	if (rd_flags & NL80211_RRF_NO_OUTDOOR)
 		channel_flags |= IEEE80211_CHAN_INDOOR_ONLY;
-	if (rd_flags & NL80211_RRF_GO_CONCURRENT)
-		channel_flags |= IEEE80211_CHAN_GO_CONCURRENT;
+	if (rd_flags & NL80211_RRF_IR_CONCURRENT)
+		channel_flags |= IEEE80211_CHAN_IR_CONCURRENT;
 	if (rd_flags & NL80211_RRF_NO_HT40MINUS)
 		channel_flags |= IEEE80211_CHAN_NO_HT40MINUS;
 	if (rd_flags & NL80211_RRF_NO_HT40PLUS)
-- 
2.1.0

