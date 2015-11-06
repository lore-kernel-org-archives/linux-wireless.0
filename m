Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45322 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031997AbbKFK76 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 05:59:58 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: remove string from unaligned packet warning
Date: Fri,  6 Nov 2015 11:59:55 +0100
Message-Id: <1446807595-12288-1-git-send-email-johannes@sipsolutions.net> (sfid-20151106_120001_371089_895EDEA4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This really should never happen except very early in the process
of bringing up a new driver, at which point you'll have to add
more debugging in the driver and this string isn't useful. Remove
it and save some size (when it's even compiled in.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8bae5de0dc44..78346e89e997 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -661,8 +661,7 @@ static void ieee80211_parse_qos(struct ieee80211_rx_data *rx)
 static void ieee80211_verify_alignment(struct ieee80211_rx_data *rx)
 {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	WARN_ONCE((unsigned long)rx->skb->data & 1,
-		  "unaligned packet at 0x%p\n", rx->skb->data);
+	WARN_ONCE((unsigned long)rx->skb->data & 1);
 #endif
 }
 
-- 
2.6.2

