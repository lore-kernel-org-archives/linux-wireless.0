Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:40049 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab3EISKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 14:10:50 -0400
From: a@pandem0nium
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 1/8] nl80211/cfg80211: add 5 and 10 MHz defines and wiphy flag
Date: Thu,  9 May 2013 20:10:29 +0200
Message-Id: <1368123036-22721-2-git-send-email-a> (sfid-20130509_201058_962846_970EA45C)
In-Reply-To: <1368123036-22721-1-git-send-email-a>
References: <1368123036-22721-1-git-send-email-a>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>

Add defines for 5 and 10 MHz channel width and fix channel
handling functions accordingly.

Also check for and report the WIPHY_FLAG_SUPPORTS_5_10_MHZ
capability.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/cfg80211.h       |    2 ++
 include/uapi/linux/nl80211.h |    4 ++++
 net/wireless/chan.c          |   29 +++++++++++++++++++++++++++++
 net/wireless/nl80211.c       |   21 +++++++++++++++++----
 4 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 26e9113..2aeecfa 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2321,6 +2321,7 @@ struct cfg80211_ops {
  *	responds to probe-requests in hardware.
  * @WIPHY_FLAG_OFFCHAN_TX: Device supports direct off-channel TX.
  * @WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL: Device supports remain-on-channel call.
+ * @WIPHY_FLAG_SUPPORTS_5_10_MHZ: Device supports 5 MHz and 10 MHz channels.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -2344,6 +2345,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD	= BIT(19),
 	WIPHY_FLAG_OFFCHAN_TX			= BIT(20),
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
+	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b484307..ed4f106 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2738,6 +2738,8 @@ enum nl80211_channel_type {
  *	and %NL80211_ATTR_CENTER_FREQ2 attributes must be provided as well
  * @NL80211_CHAN_WIDTH_160: 160 MHz channel, the %NL80211_ATTR_CENTER_FREQ1
  *	attribute must be provided as well
+ * @NL80211_CHAN_WIDTH_5: 5 MHz OFDM channel
+ * @NL80211_CHAN_WIDTH_10: 10 MHz OFDM channel
  */
 enum nl80211_chan_width {
 	NL80211_CHAN_WIDTH_20_NOHT,
@@ -2746,6 +2748,8 @@ enum nl80211_chan_width {
 	NL80211_CHAN_WIDTH_80,
 	NL80211_CHAN_WIDTH_80P80,
 	NL80211_CHAN_WIDTH_160,
+	NL80211_CHAN_WIDTH_5,
+	NL80211_CHAN_WIDTH_10,
 };
 
 /**
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index fd556ac..4052815 100644
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
@@ -349,6 +367,12 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
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
@@ -405,6 +429,11 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
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
index 9cdcd9e..f67d825 100644
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
 
@@ -6326,11 +6334,16 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
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

