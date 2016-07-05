Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19392 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbcGEIPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 04:15:19 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
	<usdutt@qti.qualcomm.com>, <pkushwah@qti.qualcomm.com>
Subject: [PATCH] nl80211: Move ACL parsing later to avoid a possible memory leak
Date: Tue, 5 Jul 2016 13:44:51 +0530
Message-ID: <1467706491-22859-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20160705_101523_664739_BDD373E1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No support for pbss results in a memory leak for the acl_data
(if parse_acl_data succeeds). Fix this by moving the ACL parsing later.

Fixes: 34d505193bd10 ("cfg80211: basic support for PBSS network type")
Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 net/wireless/nl80211.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 244d552..c11dccf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3532,16 +3532,16 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		params.smps_mode = NL80211_SMPS_OFF;
 	}
 
+	params.pbss = nla_get_flag(info->attrs[NL80211_ATTR_PBSS]);
+	if (params.pbss && !rdev->wiphy.bands[NL80211_BAND_60GHZ])
+		return -EOPNOTSUPP;
+
 	if (info->attrs[NL80211_ATTR_ACL_POLICY]) {
 		params.acl = parse_acl_data(&rdev->wiphy, info);
 		if (IS_ERR(params.acl))
 			return PTR_ERR(params.acl);
 	}
 
-	params.pbss = nla_get_flag(info->attrs[NL80211_ATTR_PBSS]);
-	if (params.pbss && !rdev->wiphy.bands[NL80211_BAND_60GHZ])
-		return -EOPNOTSUPP;
-
 	wdev_lock(wdev);
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
-- 
1.9.1

