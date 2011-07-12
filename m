Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58705 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab1GLBCV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 21:02:21 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	mickflemm@gmail.com
Subject: [PATCH v3 6/8] ath5k: fix reference clock usec duration setting restore
Date: Tue, 12 Jul 2011 09:02:03 +0800
Message-Id: <1310432525-70077-6-git-send-email-nbd@openwrt.org> (sfid-20110712_030228_562640_AE46CDEF)
In-Reply-To: <1310432525-70077-5-git-send-email-nbd@openwrt.org>
References: <1310432525-70077-1-git-send-email-nbd@openwrt.org>
 <1310432525-70077-2-git-send-email-nbd@openwrt.org>
 <1310432525-70077-3-git-send-email-nbd@openwrt.org>
 <1310432525-70077-4-git-send-email-nbd@openwrt.org>
 <1310432525-70077-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

enabling the sleep clock alters the AR5K_USEC_32 field, but disabling
it didn't restore it.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/reset.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 57f2e56..0e89fc9 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -142,6 +142,7 @@ static void ath5k_hw_init_core_clock(struct ath5k_hw *ah)
 
 	/* Set 32MHz USEC counter */
 	if ((ah->ah_radio == AR5K_RF5112) ||
+	    (ah->ah_radio == AR5K_RF2413) ||
 	    (ah->ah_radio == AR5K_RF5413) ||
 	    (ah->ah_radio == AR5K_RF2316) ||
 	    (ah->ah_radio == AR5K_RF2317))
@@ -233,7 +234,7 @@ static void ath5k_hw_init_core_clock(struct ath5k_hw *ah)
 static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-	u32 scal, spending;
+	u32 scal, spending, sclock;
 
 	/* Only set 32KHz settings if we have an external
 	 * 32KHz crystal present */
@@ -317,6 +318,15 @@ static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
 
 		/* Set up tsf increment on each cycle */
 		AR5K_REG_WRITE_BITS(ah, AR5K_TSF_PARM, AR5K_TSF_PARM_INC, 1);
+
+		if ((ah->ah_radio == AR5K_RF5112) ||
+			(ah->ah_radio == AR5K_RF5413) ||
+			(ah->ah_radio == AR5K_RF2316) ||
+			(ah->ah_radio == AR5K_RF2317))
+			sclock = 40 - 1;
+		else
+			sclock = 32 - 1;
+		AR5K_REG_WRITE_BITS(ah, AR5K_USEC_5211, AR5K_USEC_32, sclock);
 	}
 }
 
-- 
1.7.3.2

