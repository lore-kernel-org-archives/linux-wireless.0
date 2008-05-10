Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50395 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYEJWWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 18:22:04 -0400
Received: from [91.5.117.77] (helo=[10.0.0.127])
	by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1JuxS7-0000zD-CH
	for linux-wireless@vger.kernel.org; Sun, 11 May 2008 00:22:03 +0200
Message-Id: <20080510221905.646038000@sipsolutions.net> (sfid-20080511_002228_245832_9AA59424)
References: <20080510221845.340428000@sipsolutions.net>
Date: Sun, 11 May 2008 00:18:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFT/C 1/7] mac80211: use skb_header_cloned()
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 doesn't need to care here about cloned status but rather
about whether the skb header data area is modifiable.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/tx.c	2008-05-10 23:00:06.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-05-10 23:00:37.000000000 +0200
@@ -1563,13 +1563,13 @@ int ieee80211_subif_start_xmit(struct sk
 	 * be cloned. This could happen, e.g., with Linux bridge code passing
 	 * us broadcast frames. */
 
-	if (head_need > 0 || skb_cloned(skb)) {
+	if (head_need > 0 || skb_header_cloned(skb)) {
 #if 0
 		printk(KERN_DEBUG "%s: need to reallocate buffer for %d bytes "
 		       "of headroom\n", dev->name, head_need);
 #endif
 
-		if (skb_cloned(skb))
+		if (skb_header_cloned(skb))
 			I802_DEBUG_INC(local->tx_expand_skb_head_cloned);
 		else
 			I802_DEBUG_INC(local->tx_expand_skb_head);

-- 

