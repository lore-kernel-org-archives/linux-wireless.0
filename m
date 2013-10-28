Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34149 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab3J1OH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:07:56 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [PATCH] nl80211: fix channel switch parsing
Date: Mon, 28 Oct 2013 15:07:47 +0100
Message-Id: <1382969267-25506-1-git-send-email-johannes@sipsolutions.net> (sfid-20131028_150759_995954_87DD2560)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

The nl80211 attribute NL80211_ATTR_CSA_C_OFF_BEACON should be nested
inside NL80211_ATTR_CSA_IES, but commit ee4bc9e75811d2c0cb5f2a2fc5b5
("nl80211: enable IBSS support for channel switch announcements")
added a check in the outer message attributes.

Fix channel switch calls by removing the erroneus condition.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
[reword commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c49f0af..8ced6bc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5713,9 +5713,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	/* only important for AP, IBSS and mesh create IEs internally */
-	if (need_new_beacon &&
-	    (!info->attrs[NL80211_ATTR_CSA_IES] ||
-	     !info->attrs[NL80211_ATTR_CSA_C_OFF_BEACON]))
+	if (need_new_beacon && !info->attrs[NL80211_ATTR_CSA_IES])
 		return -EINVAL;
 
 	params.count = nla_get_u32(info->attrs[NL80211_ATTR_CH_SWITCH_COUNT]);
-- 
1.8.4.rc3

