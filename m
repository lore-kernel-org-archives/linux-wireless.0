Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:38042 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753372AbZESOCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 10:02:47 -0400
Message-Id: <20090519140240.851596601@atheros.com>
References: <20090519140137.708996030@atheros.com>
Date: Tue, 19 May 2009 17:01:44 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 7/7] mac80211: Do not override AID in the duration field
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When updating the duration field for TX frames, skip the update for
PS-Poll frames that use this field for other purposes (AID).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/mac80211/tx.c	2009-05-19 16:32:25.000000000 +0300
+++ wireless-testing/net/mac80211/tx.c	2009-05-19 16:32:42.000000000 +0300
@@ -872,6 +872,8 @@ ieee80211_tx_h_calculate_duration(struct
 
 	do {
 		hdr = (void *) skb->data;
+		if (ieee80211_is_pspoll(hdr->frame_control))
+			continue; /* must not overwrite AID */
 		next_len = skb->next ? skb->next->len : 0;
 		group_addr = is_multicast_ether_addr(hdr->addr1);
 

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
