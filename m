Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:39947 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab0BNXch (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 18:32:37 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH 2/2] mac80211: Fix WPA-NONE for RX unicast frames
Date: Mon, 15 Feb 2010 00:32:26 +0100
Message-Id: <1266190346-2247-2-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <1266190346-2247-1-git-send-email-benoit.papillault@free.fr>
References: <1266190346-2247-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch might have side effect which needs to be studied

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/rx.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 22ae6ee..f73fe9b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -923,6 +923,13 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		rx->key = rcu_dereference(rx->sdata->keys[keyidx]);
 
 		/*
+		 * Using WPA-NONE in IBSS, all frames, be it unicast or
+		 * multicast (including broadcast) are encrypted with the
+		 * same group key. In this case, we should not reset the key
+		 * to NULL
+		 */
+#if 0
+		/*
 		 * RSNA-protected unicast frames should always be sent with
 		 * pairwise or station-to-station keys, but for WEP we allow
 		 * using a key index as well.
@@ -930,6 +937,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		if (rx->key && rx->key->conf.alg != ALG_WEP &&
 		    !is_multicast_ether_addr(hdr->addr1))
 			rx->key = NULL;
+#endif
 	}
 
 	if (rx->key) {
-- 
1.5.6.5

