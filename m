Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:63867 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbaAFQ0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 11:26:35 -0500
Received: by mail-pd0-f174.google.com with SMTP id x10so18440539pdj.33
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 08:26:35 -0800 (PST)
From: Ujjal Roy <royujjal@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Kernel <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: fix wext-compat for getting retry value
Date: Mon,  6 Jan 2014 21:56:11 +0530
Message-Id: <1389025571-309-1-git-send-email-royujjal@gmail.com> (sfid-20140106_172638_988609_D55F20A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While getting the retry limit, wext-compat returns the value
without updating the flag for retry->flags is 0. Also in this
case, it updates long retry flag when short and long retry
value are unequal.

So, iwconfig never showing "Retry short limit" and showing
"Retry long limit" when both values are unequal.

Updated the flags and corrected the condition properly.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
---
 net/wireless/wext-compat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index e7c6e86..051d961 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -412,9 +412,9 @@ int cfg80211_wext_giwretry(struct net_device *dev,
 		 * First return short value, iwconfig will ask long value
 		 * later if needed
 		 */
-		retry->flags |= IW_RETRY_LIMIT;
+		retry->flags |= IW_RETRY_LIMIT | IW_RETRY_SHORT;
 		retry->value = wdev->wiphy->retry_short;
-		if (wdev->wiphy->retry_long != wdev->wiphy->retry_short)
+		if (wdev->wiphy->retry_long == wdev->wiphy->retry_short)
 			retry->flags |= IW_RETRY_LONG;
 
 		return 0;
-- 
1.8.1.4

