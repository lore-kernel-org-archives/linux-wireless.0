Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46912 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab0CKB2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 20:28:32 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 13/14] ath9k_hw: remove unused and buggy ath9k_hw_GetMibCycleCountsPct()
Date: Wed, 10 Mar 2010 20:28:30 -0500
Message-Id: <1268270911-24568-14-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
References: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_hw_GetMibCycleCountsPct() is unused and in fact it would be buggy
if used anyway. The right implementation is done throguh
ath9k_hw_ani_get_listen_time() which is already present as well.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c |   41 ----------------------------------
 drivers/net/wireless/ath/ath9k/ani.h |    2 -
 2 files changed, 0 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 7e87cf4..71bf201 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -750,47 +750,6 @@ void ath9k_hw_disable_mib_counters(struct ath_hw *ah)
 	REG_WRITE(ah, AR_FILT_CCK, 0);
 }
 
-u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah,
-				  u32 *rxc_pcnt,
-				  u32 *rxf_pcnt,
-				  u32 *txf_pcnt)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	static u32 cycles, rx_clear, rx_frame, tx_frame;
-	u32 good = 1;
-
-	u32 rc = REG_READ(ah, AR_RCCNT);
-	u32 rf = REG_READ(ah, AR_RFCNT);
-	u32 tf = REG_READ(ah, AR_TFCNT);
-	u32 cc = REG_READ(ah, AR_CCCNT);
-
-	if (cycles == 0 || cycles > cc) {
-		ath_print(common, ATH_DBG_ANI,
-			  "cycle counter wrap. ExtBusy = 0\n");
-		good = 0;
-	} else {
-		u32 cc_d = cc - cycles;
-		u32 rc_d = rc - rx_clear;
-		u32 rf_d = rf - rx_frame;
-		u32 tf_d = tf - tx_frame;
-
-		if (cc_d != 0) {
-			*rxc_pcnt = rc_d * 100 / cc_d;
-			*rxf_pcnt = rf_d * 100 / cc_d;
-			*txf_pcnt = tf_d * 100 / cc_d;
-		} else {
-			good = 0;
-		}
-	}
-
-	cycles = cc;
-	rx_frame = rf;
-	rx_clear = rc;
-	tx_frame = tf;
-
-	return good;
-}
-
 /*
  * Process a MIB interrupt.  We may potentially be invoked because
  * any of the MIB counters overflow/trigger so don't assume we're
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 4e1ab94..01c07e2 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -113,8 +113,6 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 			  struct ath9k_channel *chan);
 void ath9k_enable_mib_counters(struct ath_hw *ah);
 void ath9k_hw_disable_mib_counters(struct ath_hw *ah);
-u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah, u32 *rxc_pcnt,
-				  u32 *rxf_pcnt, u32 *txf_pcnt);
 void ath9k_hw_procmibevent(struct ath_hw *ah);
 void ath9k_hw_ani_setup(struct ath_hw *ah);
 void ath9k_hw_ani_init(struct ath_hw *ah);
-- 
1.6.3.3

