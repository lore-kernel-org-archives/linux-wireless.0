Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59093 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbZCML75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 07:59:57 -0400
Date: Fri, 13 Mar 2009 13:59:39 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix panic on fragmentation with power saving
Message-ID: <20090313115939.GA24310@jm.kir.nu> (sfid-20090313_130000_554737_16FE064E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible to hit a kernel panic on NULL pointer dereference in
dev_queue_xmit() when sending power save buffered frames to a STA that
woke up from sleep. This happened when the buffered frame was requeued
for transmission in ap_sta_ps_end(). In order to avoid the panic, copy
the skb->dev and skb->iif values from the first fragment to all other
fragments.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- kernel-debug.orig/net/mac80211/tx.c	2009-03-13 13:16:00.000000000 +0200
+++ kernel-debug/net/mac80211/tx.c	2009-03-13 13:39:01.000000000 +0200
@@ -784,6 +784,8 @@ ieee80211_tx_h_fragment(struct ieee80211
 		skb_copy_queue_mapping(frag, first);
 
 		frag->do_not_encrypt = first->do_not_encrypt;
+		frag->dev = first->dev;
+		frag->iif = first->iif;
 
 		pos += copylen;
 		left -= copylen;

-- 
Jouni Malinen                                            PGP id EFC895FA
