Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54203 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756176AbcLNTrM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 14:47:12 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas.huehn@evernet-eg.de
Subject: [PATCH 03/10] mac80211: minstrel_ht: make att_hist and succ_hist u32 instead of u64
Date: Wed, 14 Dec 2016 20:46:56 +0100
Message-Id: <20161214194703.33429-3-nbd@nbd.name> (sfid-20161214_204743_128094_44958F75)
In-Reply-To: <20161214194703.33429-1-nbd@nbd.name>
References: <20161214194703.33429-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They are only used for debugging purposes and take a very long time to
overflow. Visibly reduces the size of the per-sta rate control data.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index c230bbe..209961c 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -59,7 +59,7 @@ struct minstrel_rate_stats {
 	u16 success, last_success;
 
 	/* total attempts/success counters */
-	u64 att_hist, succ_hist;
+	u32 att_hist, succ_hist;
 
 	/* statistis of packet delivery probability
 	 *  cur_prob  - current prob within last update intervall
-- 
2.10.1
