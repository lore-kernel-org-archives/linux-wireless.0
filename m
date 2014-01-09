Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:39350 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaAIPqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 10:46:30 -0500
Received: by mail-pb0-f53.google.com with SMTP id ma3so3165391pbc.12
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jan 2014 07:46:29 -0800 (PST)
From: Ujjal Roy <royujjal@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: add sanity check for retry limit in wext-compat
Date: Thu,  9 Jan 2014 21:16:14 +0530
Message-Id: <1389282374-12259-1-git-send-email-royujjal@gmail.com> (sfid-20140109_164633_430590_DB0CCCA8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Block setting the wrong values through iwconfig retry
command. Add sanity checking before sending the retry
limit to the driver.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
---
 net/wireless/wext-compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 051d961..5661a54 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -370,7 +370,7 @@ static int cfg80211_wext_siwretry(struct net_device *dev,
 	u8 oshort = wdev->wiphy->retry_short;
 	int err;
 
-	if (retry->disabled ||
+	if (retry->disabled || retry->value < 1 || retry->value > 255 ||
 	    (retry->flags & IW_RETRY_TYPE) != IW_RETRY_LIMIT)
 		return -EINVAL;
 
-- 
1.8.1.4

