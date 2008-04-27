Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:38007 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbYD0Ksf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 06:48:35 -0400
Received: by wa-out-1112.google.com with SMTP id m16so7170650waf.23
        for <linux-wireless@vger.kernel.org>; Sun, 27 Apr 2008 03:48:34 -0700 (PDT)
Subject: [PATCH] mac80211: incorrect shift direction
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 03:48:40 -0700
Message-Id: <1209293320.14173.63.camel@brick> (sfid-20080427_124848_301606_C75120F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks like  5d2cdcd4e85c5187db30a6b29f79fbbe59f39f78 got the
shifts wrong.

Noticed by sparse:
net/mac80211/tkip.c:234:25: warning: right shift by bigger than source value
net/mac80211/tkip.c:235:25: warning: right shift by bigger than source value
net/mac80211/tkip.c:236:25: warning: right shift by bigger than source value

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/tkip.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index dddbfd6..09093da 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -230,10 +230,8 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 
 	iv16 = data[hdr_len] << 8;
 	iv16 += data[hdr_len + 2];
-	iv32 = data[hdr_len + 4] +
-		(data[hdr_len + 5] >> 8) +
-		(data[hdr_len + 6] >> 16) +
-		(data[hdr_len + 7] >> 24);
+	iv32 = data[hdr_len + 4] | (data[hdr_len + 5] << 8) |
+	       (data[hdr_len + 6] << 16) | (data[hdr_len + 7] << 24);
 
 #ifdef CONFIG_TKIP_DEBUG
 	printk(KERN_DEBUG "TKIP encrypt: iv16 = 0x%04x, iv32 = 0x%08x\n",
-- 
1.5.5.1.270.g89765



