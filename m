Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:52503 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755578Ab0C3Gfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 02:35:30 -0400
Date: Mon, 29 Mar 2010 23:35:23 -0700
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix BIP to be used only with group-addressed
 frames
Message-ID: <20100330063523.GC4953@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BIP (part of IEEE 802.11w) is only supposed to be used with
group-addressed frames. We ended up picking it as a default mechanism
for every management whenever we did not have a STA entry for the
destination (e.g., for Probe Response to a STA that is not
associated). While the extra MMIE in the end of management frames
should not break frames completed in most cases, there is no point in
doing this. Fix key selection to pick the default management key only
if the frame is sent to multicast/broadcast address and the frame is a
robust management frame.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/mac80211/tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/mac80211/tx.c	2010-03-29 23:22:51.000000000 -0700
+++ wireless-testing/net/mac80211/tx.c	2010-03-29 23:33:24.000000000 -0700
@@ -513,6 +513,8 @@ ieee80211_tx_h_select_key(struct ieee802
 	else if (tx->sta && (key = rcu_dereference(tx->sta->key)))
 		tx->key = key;
 	else if (ieee80211_is_mgmt(hdr->frame_control) &&
+		 is_multicast_ether_addr(hdr->addr1) &&
+		 ieee80211_is_robust_mgmt_frame(hdr) &&
 		 (key = rcu_dereference(tx->sdata->default_mgmt_key)))
 		tx->key = key;
 	else if ((key = rcu_dereference(tx->sdata->default_key)))

-- 
Jouni Malinen                                            PGP id EFC895FA
