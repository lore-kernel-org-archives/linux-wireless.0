Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:45829 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289AbZESQ0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 12:26:12 -0400
Date: Tue, 19 May 2009 19:25:58 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 7/7] mac80211: Do not override AID in the duration field
Message-ID: <20090519162558.GA7702@jm.kir.nu>
References: <20090519140137.708996030@atheros.com> <20090519140240.851596601@atheros.com> <1242744770.4797.26.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242744770.4797.26.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When updating the duration field for TX frames, skip the update for
PS-Poll frames that use this field for other purposes (AID).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/tx.c |    2 ++
 1 file changed, 2 insertions(+)

v2: add unlikely() and change continue to break to avoid unnecessary
    check for a fragment of PS-Poll frame

--- wireless-testing.orig/net/mac80211/tx.c	2009-05-14 21:03:49.000000000 +0300
+++ wireless-testing/net/mac80211/tx.c	2009-05-19 19:20:57.000000000 +0300
@@ -872,6 +872,8 @@ ieee80211_tx_h_calculate_duration(struct
 
 	do {
 		hdr = (void *) skb->data;
+		if (unlikely(ieee80211_is_pspoll(hdr->frame_control)))
+			break; /* must not overwrite AID */
 		next_len = skb->next ? skb->next->len : 0;
 		group_addr = is_multicast_ether_addr(hdr->addr1);
 
-- 
Jouni Malinen                                            PGP id EFC895FA
