Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36871 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758610AbcIMOq5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 10:46:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/6] cfg80211: validate key index better
Date: Tue, 13 Sep 2016 16:44:27 +0200
Message-Id: <1473777868-32429-5-git-send-email-johannes@sipsolutions.net> (sfid-20160913_164753_542057_C35FE506)
In-Reply-To: <1473777868-32429-1-git-send-email-johannes@sipsolutions.net>
References: <1473777868-32429-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Don't accept it if a key_idx < 0 snuck through, reject WEP keys with
key index 4 and 5 (which are used for IGTKs) and don't allow IGTKs
with key indices other than 4 and 5. This makes the key data match
expectations better.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/util.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 0675f513e7b9..81fa16b36d30 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -218,7 +218,7 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
 				   bool pairwise, const u8 *mac_addr)
 {
-	if (key_idx > 5)
+	if (key_idx < 0 || key_idx > 5)
 		return -EINVAL;
 
 	if (!pairwise && mac_addr && !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
@@ -249,7 +249,13 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 		/* Disallow BIP (group-only) cipher as pairwise cipher */
 		if (pairwise)
 			return -EINVAL;
+		if (key_idx < 4)
+			return -EINVAL;
 		break;
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		if (key_idx < 0 || key_idx > 3)
+			return -EINVAL;
 	default:
 		break;
 	}
-- 
2.8.1
