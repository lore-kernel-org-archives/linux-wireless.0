Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:52713 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755595Ab0C3GgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 02:36:23 -0400
Date: Mon, 29 Mar 2010 23:36:15 -0700
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix dropping of unprotected robust multicast
 frames
Message-ID: <20100330063615.GD4953@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When selecting the RX key for group-addressed robust management
frames, we do not actually select any BIP key if the frame is
unprotected (since we cannot find the key index from MMIE). This
results in the drop_unencrypted check in failing to drop the frame. It
is enough to verify that we have a STA entry for the transmitter and
that MFP is enabled for that STA; we do not need to check rx->key
here. This fixes BIP processing for unprotected, group-addressed,
robust management frames.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/mac80211/rx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-03-29 23:32:20.000000000 -0700
+++ wireless-testing/net/mac80211/rx.c	2010-03-29 23:35:35.000000000 -0700
@@ -1413,8 +1413,7 @@ ieee80211_drop_unencrypted_mgmt(struct i
 			return -EACCES;
 		/* BIP does not use Protected field, so need to check MMIE */
 		if (unlikely(ieee80211_is_multicast_robust_mgmt_frame(rx->skb) &&
-			     ieee80211_get_mmie_keyidx(rx->skb) < 0 &&
-			     rx->key))
+			     ieee80211_get_mmie_keyidx(rx->skb) < 0))
 			return -EACCES;
 		/*
 		 * When using MFP, Action frames are not allowed prior to

-- 
Jouni Malinen                                            PGP id EFC895FA
