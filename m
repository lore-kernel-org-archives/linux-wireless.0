Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54222 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756531AbcLNTrR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 14:47:17 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas.huehn@evernet-eg.de
Subject: [PATCH 08/10] mac80211: minstrel: make prob_ewma u16 instead of u32
Date: Wed, 14 Dec 2016 20:47:01 +0100
Message-Id: <20161214194703.33429-8-nbd@nbd.name> (sfid-20161214_204753_528592_887A5BEE)
In-Reply-To: <20161214194703.33429-1-nbd@nbd.name>
References: <20161214194703.33429-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Saves about 1.2 KiB memory per station

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index ea86e67..be6c3f3 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -59,7 +59,7 @@ struct minstrel_rate_stats {
 	/* statistis of packet delivery probability
 	 *  prob_ewma - exponential weighted moving average of prob
 	 *  prob_ewmsd - exp. weighted moving standard deviation of prob */
-	unsigned int prob_ewma;
+	u16 prob_ewma;
 	u16 prob_ewmv;
 
 	/* maximum retry counts */
-- 
2.10.1
