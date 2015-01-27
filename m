Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:50116 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbbA0IpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 03:45:16 -0500
Received: by mail-we0-f177.google.com with SMTP id l61so13498166wev.8
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 00:45:14 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFCv4 1/3] cfg80211: add VHT support for IBSS
Date: Tue, 27 Jan 2015 09:44:01 +0100
Message-Id: <1422348243-4928-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150127_094524_829410_948C672D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add NL80211_EXT_FEATURE_VHT_IBSS flag and VHT
support for IBSS.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/uapi/linux/nl80211.h |  2 ++
 net/wireless/nl80211.c       | 14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 735ab43..ed491b2 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4204,11 +4204,13 @@ enum nl80211_feature_flags {
 
 /**
  * enum nl80211_ext_feature_index - bit index of extended features.
+ * @NL80211_EXT_FEATURE_VHT_IBSS: This driver supports IBSS with VHT datarates.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
 enum nl80211_ext_feature_index {
+	NL80211_EXT_FEATURE_VHT_IBSS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 39753de..a662cd1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7092,8 +7092,18 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		break;
 	case NL80211_CHAN_WIDTH_20:
 	case NL80211_CHAN_WIDTH_40:
-		if (rdev->wiphy.features & NL80211_FEATURE_HT_IBSS)
-			break;
+		if (!(rdev->wiphy.features & NL80211_FEATURE_HT_IBSS))
+			return -EINVAL;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_80P80:
+	case NL80211_CHAN_WIDTH_160:
+		if (!(rdev->wiphy.features & NL80211_FEATURE_HT_IBSS))
+			return -EINVAL;
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_VHT_IBSS))
+			return -EINVAL;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
1.9.1

