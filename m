Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46914 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab0CKB2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 20:28:32 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 14/14] ath9k_hw: add a helper for retrieving the MIB cycle counters
Date: Wed, 10 Mar 2010 20:28:31 -0500
Message-Id: <1268270911-24568-15-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
References: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This helper can be abstracted on each hardware family. While at it
document the registers involved, used to profile the MAC baseband
for Adaptive Noise Immunity (ANI).

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c |   67 ++++++++++++++++++++++++++++++++--
 1 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 71bf201..02db5c5 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -14,6 +14,13 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+/*
+ * Adaptive Noise Immunity
+ *
+ * Used to monitor your environment and adjust the MAC baseband accordingly to
+ * help with RX. ANI is extremely useful in environments with noise.
+ */
+
 #include "hw.h"
 
 static int ath9k_hw_get_ani_channel_idx(struct ath_hw *ah,
@@ -324,6 +331,18 @@ static void ath9k_hw_get_phy_err_count(struct ath_hw *ah,
 	*phy_err_count2 = REG_READ(ah, AR_PHY_ERR_2);
 }
 
+static void ath9k_hw_get_mib_cycle_counters(struct ath_hw *ah,
+					    u32 *rx_clear_count,
+					    u32 *rx_frame_count,
+					    u32 *tx_frame_count,
+					    u32 *cycle_count)
+{
+	*rx_clear_count = REG_READ(ah, AR_RCCNT);
+	*rx_frame_count = REG_READ(ah, AR_RFCNT);
+	*tx_frame_count = REG_READ(ah, AR_TFCNT);
+	*cycle_count = REG_READ(ah, AR_CCCNT);
+}
+
 static void ath9k_ani_restart(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
@@ -530,15 +549,57 @@ static void ath9k_hw_ani_lower_immunity(struct ath_hw *ah)
 	}
 }
 
+/**
+ * ath9k_hw_ani_get_listen_time - profile the MAC baseband for ANI
+ *
+ * @ah: atheros hardware structure
+ *
+ * This uses the Baseband Interface MIB Counters:
+ *
+ * 0x80ec - Transmit Frame Counter
+ * 0x80f0 - Receive Frame Counter
+ * 0x80f4 - Receive Clear Counter
+ * 0x80f8 - Cycle Counter
+ *
+ * for profiling of the MAC baseband and adjusting it accordingly.
+ *
+ * The baseband interface MIB counters are used to provide software a
+ * means of profiling the behavior at the MAC baseband interface for
+ * performance analysis.  These counters are based on the system clock
+ * domain which turns off during sleep.  The transmit frame counter
+ * counts the number of cycles the tx_frame signal is active.  The
+ * receive frame counter counts the number of cycles the rx_frame signal
+ * is active.  The receive clear counter counts the number of cycles the
+ * rx_clear signal is "NOT" active.  The cycle counter counts the number of
+ * clock cycles.  There are registers which controls the behaviour of
+ * these counters.  The PCI MIB freeze register will hold all the
+ * values of these registers.  PCI MIB clear will zero out all the
+ * values of these registers.  PCI MIB force will force increment of
+ * all the registers each cycle.  These register do not roll over or
+ * saturate but rather use a time weighted average to maintain the
+ * ratios of these MIB counter registers.  When the cycle counter
+ * register reaches 32'hFFFFFFFF, all the registers shift their
+ * values right by 1.  So the new cycle counter register will be
+ * 32'h7FFFFFFF.  Writes are allowed to verify correct averaging
+ * behaviour.
+ *
+ * The saturate cycle cnt bit if set in the DIAG_SW (0x8048) will
+ * cause the cycle counter register (0x80F8) to saturate instead
+ * of shifting to the right by 1 every time the count reaches
+ * 0xFFFFFFFF.
+ */
 static int32_t ath9k_hw_ani_get_listen_time(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
 	u32 txFrameCount, rxFrameCount, cycleCount;
+	u32 rx_clear_count; /* not actually used */
 	int32_t listenTime;
 
-	txFrameCount = REG_READ(ah, AR_TFCNT);
-	rxFrameCount = REG_READ(ah, AR_RFCNT);
-	cycleCount = REG_READ(ah, AR_CCCNT);
+	ath9k_hw_get_mib_cycle_counters(ah,
+					&rx_clear_count,
+					&rxFrameCount,
+					&txFrameCount,
+					&cycleCount);
 
 	aniState = ah->curani;
 	if (aniState->cycleCount == 0 || aniState->cycleCount > cycleCount) {
-- 
1.6.3.3

