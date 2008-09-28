Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3051 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYI1QKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 12:10:08 -0400
Date: Sun, 28 Sep 2008 12:09:43 -0400
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: write beacon control register twice when resetting tsf
Message-ID: <20080928160943.GA30901@hash.localnet> (sfid-20080928_181019_117330_6EA85D54)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the newly-released Atheros HAL code, asserting the
TSF reset bit will toggle a hardware internal state, resulting in a
spurious reset on the next chip reset.  Whenever we force a TSF bit,
write the bit twice to clear the internal signal.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

This was the only major difference I found between code we're currently
using in pcu.c and its equivalents in the HAL.  See comment in 
ar5212ResetTsf.  This is only compile-tested.

(There are other differences but they are in the key setup code or
beacon setup code that we are not using right now.)  

 drivers/net/wireless/ath5k/pcu.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
index c77cee2..c8f9170 100644
--- a/drivers/net/wireless/ath5k/pcu.c
+++ b/drivers/net/wireless/ath5k/pcu.c
@@ -633,8 +633,20 @@ u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
  */
 void ath5k_hw_reset_tsf(struct ath5k_hw *ah)
 {
+	u32 val;
+
 	ATH5K_TRACE(ah->ah_sc);
-	AR5K_REG_ENABLE_BITS(ah, AR5K_BEACON, AR5K_BEACON_RESET_TSF);
+
+	val = ath5k_hw_reg_read(ah, AR5K_BEACON) | AR5K_BEACON_RESET_TSF;
+
+	/* 
+ 	 * Each write to the RESET_TSF bit toggles a hardware internal
+ 	 * signal to reset TSF, but if left high it will cause a TSF reset
+ 	 * on the next chip reset as well.  Thus we always write the value
+ 	 * twice to clear the signal.
+ 	 */
+	ath5k_hw_reg_write(ah, val, AR5K_BEACON);
+	ath5k_hw_reg_write(ah, val, AR5K_BEACON);
 }
 
 /*
-- 
1.5.4.2.182.gb3092

-- 
Bob Copeland %% www.bobcopeland.com

