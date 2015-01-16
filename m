Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55566 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbbAPKjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 05:39:37 -0500
Received: by mail-wi0-f182.google.com with SMTP id n3so1221856wiv.3
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 02:39:36 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFCv2 2/6] cfg80211: add VHT support for IBSS
Date: Fri, 16 Jan 2015 11:38:40 +0100
Message-Id: <1421404724-32326-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150116_113943_556197_6AAC2326)
In-Reply-To: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add NL80211_FEATURE_VHT_IBSS flag and VHT
support for IBSS.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/uapi/linux/nl80211.h |  2 ++
 net/wireless/nl80211.c       | 14 ++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b6c1a00..8f7422e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4308,11 +4308,13 @@ enum nl80211_feature_flags {
 
 /**
  * enum nl80211_ext_feature_index - bit index of extended features.
+ * @NL80211_FEATURE_VHT_IBSS: This driver supports IBSS with VHT datarates.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
 enum nl80211_ext_feature_index {
+	NL80211_FEATURE_VHT_IBSS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 38078437..4b79340 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7240,8 +7240,18 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
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
+					     NL80211_FEATURE_VHT_IBSS))
+			return -EINVAL;
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
1.9.1

