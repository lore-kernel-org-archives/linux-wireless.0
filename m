Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:28803 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbYDYAAz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 20:00:55 -0400
Received: from [192.168.1.21] (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 79AD2619058
	for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2008 20:00:54 -0400 (EDT)
Subject: [PATCH RFT] tkip: fix iv32 calculation in ieee80211_get_tkip_key()
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 24 Apr 2008 20:00:53 -0400
Message-Id: <1209081653.12561.50.camel@dv> (sfid-20080425_020124_946641_227370FA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
It's a side product of testing a sparse patch by Linus Torvalds.
Compile tested only.

 net/mac80211/tkip.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index dddbfd6..b9ecd65 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -231,9 +231,9 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
 	iv16 = data[hdr_len] << 8;
 	iv16 += data[hdr_len + 2];
 	iv32 = data[hdr_len + 4] +
-		(data[hdr_len + 5] >> 8) +
-		(data[hdr_len + 6] >> 16) +
-		(data[hdr_len + 7] >> 24);
+		(data[hdr_len + 5] << 8) +
+		(data[hdr_len + 6] << 16) +
+		(data[hdr_len + 7] << 24);
 
 #ifdef CONFIG_TKIP_DEBUG
 	printk(KERN_DEBUG "TKIP encrypt: iv16 = 0x%04x, iv32 = 0x%08x\n",


-- 
Regards,
Pavel Roskin
