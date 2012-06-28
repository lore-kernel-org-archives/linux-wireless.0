Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:56273 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825Ab2F1X2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 19:28:32 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas@net.t-labs.tu-berlin.de,
	nbd@openwrt.org
Subject: [PATCH] mac80211: correct size the argument to kzalloc in minstrel_ht
Date: Thu, 28 Jun 2012 16:28:05 -0700
Message-Id: <1340926085-54416-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120629_012835_418503_03DDA849)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

msp has type struct minstrel_ht_sta_priv not struct minstrel_ht_sta.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel_ht.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 2d1acc6..dc2b801 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -809,7 +809,7 @@ minstrel_ht_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 			max_rates = sband->n_bitrates;
 	}
 
-	msp = kzalloc(sizeof(struct minstrel_ht_sta), gfp);
+	msp = kzalloc(sizeof(struct minstrel_ht_sta_priv), gfp);
 	if (!msp)
 		return NULL;
 
-- 
1.7.10.4

