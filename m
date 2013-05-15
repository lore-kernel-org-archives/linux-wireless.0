Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40202 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759110Ab3EOOTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:19:33 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 01/18] nl80211/cfg80211: add 5 and 10 MHz defines and wiphy flag
Date: Wed, 15 May 2013 16:18:52 +0200
Message-Id: <1368627549-22518-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130515_161938_998510_F1985D8D)
In-Reply-To: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add defines for 5 and 10 MHz channel width and fix channel
handling functions accordingly.

Also check for and report the WIPHY_FLAG_SUPPORTS_5_10_MHZ
capability.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/cfg80211.h       |    2 ++
 include/uapi/linux/nl80211.h |    4 +++
 net/wireless/chan.c          |   57 ++++++++++++++++++++++++++++++++++++------
 net/wireless/nl80211.c       |   21 +++++++++++++---
 4 files changed, 72 insertions(+), 12 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 26b5b69..08489cc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2307,6 +2307,7 @@ struct cfg80211_ops {
  *	responds to probe-requests in hardware.
  * @WIPHY_FLAG_OFFCHAN_TX: Device supports direct off-channel TX.
  * @WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL: Device supports remain-on-channel call.
+ * @WIPHY_FLAG_SUPPORTS_5_10_MHZ: Device supports 5 MHz and 10 MHz channels.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -2330,6 +2331,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD	= BIT(19),
 	WIPHY_FLAG_OFFCHAN_TX			= BIT(20),
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
+	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d1e48b5..3e95e74 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2730,6 +2730,8 @@ enum nl80211_channel_type {
  *	and %NL80211_ATTR_CENTER_FREQ2 attributes must be provided as well
  * @NL80211_CHAN_WIDTH_160: 160 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
  *	attribute must be provided as well
+ * @NL80211_CHAN_WIDTH_5: 5 MHz OFDM channel
+ * @NL80211_CHAN_WIDTH_10: 10 MHz OFDM channel
  */
 enum nl80211_chan_width {
 	NL80211_CHAN_WIDTH_20_NOHT,
@@ -2738,6 +2740,8 @@ enum nl80211_chan_width {
 	NL80211_CHAN_WIDTH_80,
 	NL80211_CHAN_WIDTH_80P80,
 	NL80211_CHAN_WIDTH_160,
+	NL80211_CHAN_WIDTH_5,
+	NL80211_CHAN_WIDTH_10,
 };
 
 /**
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index fd556ac..598b609 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -54,6 +54,8 @@ bool cfg80211_chandef_valid(const struct cfg80211_chan_def *chandef)
 	control_freq = chandef->chan->center_freq;
 
 	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
 	case NL80211_CHAN_WIDTH_20:
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		if (chandef->center_freq1 != control_freq)
@@ -152,6 +154,12 @@ static int cfg80211_chandef_get_width(const struct cfg80211_chan_def *c)
 	int width;
 
 	switch (c->width) {
+	case NL80211_CHAN_WIDTH_5:
+		width = 5;
+		break;
+	case NL80211_CHAN_WIDTH_10:
+		width = 10;
+		break;
 	case NL80211_CHAN_WIDTH_20:
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		width = 20;
@@ -194,6 +202,16 @@ cfg80211_chandef_compatible(const struct cfg80211_chan_def *c1,
 	if (c1->width == c2->width)
 		return NULL;
 
+	/*
+	 * can't be compatible if one of them are 5 or 10 MHz,
+	 * but they have not the same width.
+	 */
+	if (c1->width == NL80211_CHAN_WIDTH_5 ||
+	    c1->width == NL80211_CHAN_WIDTH_10 ||
+	    c2->width == NL80211_CHAN_WIDTH_5 ||
+	    c2->width == NL80211_CHAN_WIDTH_10)
+		return NULL;
+
 	if (c1->width == NL80211_CHAN_WIDTH_20_NOHT ||
 	    c1->width == NL80211_CHAN_WIDTH_20)
 		return c2;
@@ -264,11 +282,17 @@ static int cfg80211_get_chans_dfs_required(struct wiphy *wiphy,
 					    u32 bandwidth)
 {
 	struct ieee80211_channel *c;
-	u32 freq;
+	u32 freq, start_freq, end_freq;
 
-	for (freq = center_freq - bandwidth/2 + 10;
-	     freq <= center_freq + bandwidth/2 - 10;
-	     freq += 20) {
+	if (bandwidth <= 20) {
+		start_freq = center_freq;
+		end_freq = center_freq;
+	} else {
+		start_freq = center_freq - bandwidth/2 + 10;
+		end_freq = center_freq + bandwidth/2 - 10;
+	}
+
+	for (freq = start_freq; freq <= end_freq; freq += 20) {
 		c = ieee80211_get_channel(wiphy, freq);
 		if (!c)
 			return -EINVAL;
@@ -310,11 +334,17 @@ static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 					u32 prohibited_flags)
 {
 	struct ieee80211_channel *c;
-	u32 freq;
+	u32 freq, start_freq, end_freq;
 
-	for (freq = center_freq - bandwidth/2 + 10;
-	     freq <= center_freq + bandwidth/2 - 10;
-	     freq += 20) {
+	if (bandwidth <= 20) {
+		start_freq = end_freq;
+		end_freq = center_freq;
+	} else {
+		start_freq = center_freq - bandwidth/2 + 10;
+		end_freq = center_freq + bandwidth/2 - 10;
+	}
+
+	for (freq = start_freq; freq <= end_freq; freq += 20) {
 		c = ieee80211_get_channel(wiphy, freq);
 		if (!c)
 			return false;
@@ -349,6 +379,12 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 	control_freq = chandef->chan->center_freq;
 
 	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_5:
+		width = 5;
+		break;
+	case NL80211_CHAN_WIDTH_10:
+		width = 10;
+		break;
 	case NL80211_CHAN_WIDTH_20:
 		if (!ht_cap->ht_supported)
 			return false;
@@ -405,6 +441,11 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 	if (width > 20)
 		prohibited_flags |= IEEE80211_CHAN_NO_OFDM;
 
+	/* 5 and 10 MHz are only defined for the OFDM PHY */
+	if (width < 20)
+		prohibited_flags |= IEEE80211_CHAN_NO_OFDM;
+
+
 	if (!cfg80211_secondary_chans_ok(wiphy, chandef->center_freq1,
 					 width, prohibited_flags))
 		return false;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index afa2838..75070da 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1228,6 +1228,9 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		if ((dev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP) &&
 		    nla_put_flag(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP))
 			goto nla_put_failure;
+		if ((dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_5_10_MHZ) &&
+		    nla_put_flag(msg, WIPHY_FLAG_SUPPORTS_5_10_MHZ))
+			goto nla_put_failure;
 
 		(*split_start)++;
 		if (split)
@@ -1771,6 +1774,11 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 				     IEEE80211_CHAN_DISABLED))
 		return -EINVAL;
 
+	if ((chandef->width == NL80211_CHAN_WIDTH_5 ||
+	     chandef->width == NL80211_CHAN_WIDTH_10) &&
+	    !(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_5_10_MHZ))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -6288,11 +6296,16 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef))
 		return -EINVAL;
 
-	if (ibss.chandef.width > NL80211_CHAN_WIDTH_40)
-		return -EINVAL;
-	if (ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
-	    !(rdev->wiphy.features & NL80211_FEATURE_HT_IBSS))
+	switch (ibss.chandef.width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		break;
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_40:
+		if (rdev->wiphy.features & NL80211_FEATURE_HT_IBSS)
+			break;
+	default:
 		return -EINVAL;
+	}
 
 	ibss.channel_fixed = !!info->attrs[NL80211_ATTR_FREQ_FIXED];
 	ibss.privacy = !!info->attrs[NL80211_ATTR_PRIVACY];
-- 
1.7.10.4

