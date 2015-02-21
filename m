Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:46781 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbbBUPxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2015 10:53:01 -0500
Received: by lbjf15 with SMTP id f15so11390212lbj.13
        for <linux-wireless@vger.kernel.org>; Sat, 21 Feb 2015 07:53:00 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 1/3] cfg80211: add VHT support for IBSS
Date: Sat, 21 Feb 2015 16:52:39 +0100
Message-Id: <1424533961-3869-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150221_165310_049279_5DFCD02F)
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
index 68b294e..a7ce571 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4327,11 +4327,13 @@ enum nl80211_feature_flags {
 
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
index 454d7a0..472e8f5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7259,8 +7259,18 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
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

