Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:54088
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755011AbaKOCuV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 21:50:21 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, karl.beldan@rivierawaves.com
Subject: [PATCH] mac80211: skip legacy rate mask handling for VHT rates
Date: Sat, 15 Nov 2014 03:48:54 +0100
Message-Id: <1416019734-17509-1-git-send-email-nbd@openwrt.org> (sfid-20141115_035025_060445_C6858D08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rate mask code currently assumes that a rate is legacy if
IEEE80211_TX_RC_MCS is not set. This might be the cause of bogus VHT
rates being reported with minstrel_ht.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 6081329..f6fea67f 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -385,7 +385,7 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
 			*rate = alt_rate;
 			return;
 		}
-	} else {
+	} else if (!(rate->flags & IEEE80211_TX_RC_VHT_MCS)) {
 		/* handle legacy rates */
 		if (rate_idx_match_legacy_mask(rate, sband->n_bitrates, mask))
 			return;
-- 
2.1.2

