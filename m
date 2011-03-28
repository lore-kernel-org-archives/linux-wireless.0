Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:17144 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab1C1HLr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 03:11:47 -0400
From: juuso.oikarinen@nokia.com
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: fix BSS double-unlinking (continued)
Date: Mon, 28 Mar 2011 10:11:35 +0300
Message-Id: <1301296295-3082-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch adds to the fix "fix BSS double-unlinking"
(commit 3207390a8b58bfc1335750f91cf6783c48ca19ca) by Johannes Berg.

It turns out, that the double-unlinking scenario can also occur if expired
BSS elements are removed whilst an interface is performing association.

To work around that, replace list_del with list_del_init also in the
"cfg80211_bss_expire" function, so that the check for whether the BSS still is
in the list works correctly in cfg80211_bss_expire.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/wireless/scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ea427f4..2823615 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -134,7 +134,7 @@ void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
 			continue;
 		if (!time_after(jiffies, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE))
 			continue;
-		list_del(&bss->list);
+		list_del_init(&bss->list);
 		rb_erase(&bss->rbn, &dev->bss_tree);
 		kref_put(&bss->ref, bss_release);
 		expired = true;
-- 
1.7.1

