Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47626 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab3E1VUS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 17:20:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] cfg80211: fix a crash in the active monitor check
Date: Tue, 28 May 2013 23:20:14 +0200
Message-Id: <1369776014-10148-1-git-send-email-nbd@openwrt.org> (sfid-20130528_232022_189451_6A305400)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

flags can be NULL

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 820b756..ede00e2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2391,7 +2391,7 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 		change = true;
 	}
 
-	if ((*flags & NL80211_MNTR_FLAG_ACTIVE) &&
+	if (flags && (*flags & NL80211_MNTR_FLAG_ACTIVE) &&
 	    !(rdev->wiphy.features & NL80211_FEATURE_ACTIVE_MONITOR))
 		return -EOPNOTSUPP;
 
-- 
1.8.0.2

