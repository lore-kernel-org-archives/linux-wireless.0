Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43404 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759265AbZCaCai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 22:30:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/9] ath9k: separate ath9k specific code from ath9k_regd_get_ctl()
Date: Mon, 30 Mar 2009 22:30:27 -0400
Message-Id: <1238466635-23280-2-git-send-email-lrodriguez@atheros.com> (sfid-20090331_043049_128768_99FFF21D)
In-Reply-To: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
References: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

Until ath5k and ath9k share common channel structures, they will have
to implement their own get_ctl() function.  Split out the portion that
only relies on the current band and reg domain so that it can be common
code.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/regd.c |   36 +++++++++++++++++++++++-------------
 1 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 4ca6251..43ed35b 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -16,6 +16,7 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <net/wireless.h>
 #include "ath9k.h"
 #include "regd_common.h"
 
@@ -492,28 +493,37 @@ int ath9k_regd_init(struct ath_hw *ah)
 	return 0;
 }
 
-u32 ath9k_regd_get_ctl(struct ath_hw *ah, struct ath9k_channel *chan)
+static
+u32 ath9k_regd_get_band_ctl(struct ath_hw *ah, enum ieee80211_band band)
 {
-	u32 ctl = NO_CTL;
-
 	if (!ah->regulatory.regpair ||
 	    (ah->regulatory.country_code == CTRY_DEFAULT &&
 	     is_wwr_sku(ath9k_regd_get_eepromRD(ah)))) {
-		if (IS_CHAN_B(chan))
-			ctl = SD_NO_CTL | CTL_11B;
-		else if (IS_CHAN_G(chan))
-			ctl = SD_NO_CTL | CTL_11G;
-		else
-			ctl = SD_NO_CTL | CTL_11A;
-		return ctl;
+		return SD_NO_CTL;
+	}
+
+	switch (band) {
+	case IEEE80211_BAND_2GHZ:
+		return ah->regulatory.regpair->reg_2ghz_ctl;
+	case IEEE80211_BAND_5GHZ:
+		return ah->regulatory.regpair->reg_5ghz_ctl;
+	default:
+		return NO_CTL;
 	}
 
+	return NO_CTL;
+}
+
+u32 ath9k_regd_get_ctl(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	u32 ctl = ath9k_regd_get_band_ctl(ah, chan->chan->band);
+
 	if (IS_CHAN_B(chan))
-		ctl = ah->regulatory.regpair->reg_2ghz_ctl | CTL_11B;
+		ctl |= CTL_11B;
 	else if (IS_CHAN_G(chan))
-		ctl = ah->regulatory.regpair->reg_2ghz_ctl | CTL_11G;
+		ctl |= CTL_11G;
 	else
-		ctl = ah->regulatory.regpair->reg_5ghz_ctl | CTL_11A;
+		ctl |= CTL_11A;
 
 	return ctl;
 }
-- 
1.6.0.6

