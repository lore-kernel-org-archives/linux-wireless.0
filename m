Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54224 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756527AbcLNTrR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 14:47:17 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, thomas.huehn@evernet-eg.de
Subject: [PATCH 06/10] mac80211: minstrel: reduce MINSTREL_SCALE
Date: Wed, 14 Dec 2016 20:46:59 +0100
Message-Id: <20161214194703.33429-6-nbd@nbd.name> (sfid-20161214_204742_851193_0D79CBC1)
In-Reply-To: <20161214194703.33429-1-nbd@nbd.name>
References: <20161214194703.33429-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The loss of a bit of extra precision does not hurt the calculation, 12
bits is still enough to calculate probabilities well. Reducing the scale
makes it easier to avoid overflows

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 94b89b1..03716fd 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -14,7 +14,7 @@
 #define SAMPLE_COLUMNS	10	/* number of columns in sample table */
 
 /* scaled fraction values */
-#define MINSTREL_SCALE  16
+#define MINSTREL_SCALE  12
 #define MINSTREL_FRAC(val, div) (((val) << MINSTREL_SCALE) / div)
 #define MINSTREL_TRUNC(val) ((val) >> MINSTREL_SCALE)
 
-- 
2.10.1
