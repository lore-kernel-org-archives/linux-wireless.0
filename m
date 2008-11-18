Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27503 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbYKRDjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:39:12 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:39:12 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14386.993159.12774@gargle.gargle.HOWL> (sfid-20081118_043915_354833_98EA8D09)
Date: Tue, 18 Nov 2008 09:06:18 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 08/18] ath9k: We don't support non-HT devices, so remove superfluous code.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   39 -------------------------------------
 1 files changed, 0 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 8937728..44735b6 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -14,10 +14,6 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-/*
- * Implementation of transmit path.
- */
-
 #include "core.h"
 
 #define BITS_PER_BYTE           8
@@ -699,41 +695,6 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	}
 
 	/*
-	 * For non-HT devices, calculate RTS/CTS duration in software
-	 * and disable multi-rate retry.
-	 */
-	if (flags && !(ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)) {
-		/*
-		 * Compute the transmit duration based on the frame
-		 * size and the size of an ACK frame.  We call into the
-		 * HAL to do the computation since it depends on the
-		 * characteristics of the actual PHY being used.
-		 *
-		 * NB: CTS is assumed the same size as an ACK so we can
-		 *     use the precalculated ACK durations.
-		 */
-		if (flags & ATH9K_TXDESC_RTSENA) {    /* SIFS + CTS */
-			ctsduration += bf_isshpreamble(bf) ?
-				rt->info[cix].spAckDuration :
-				rt->info[cix].lpAckDuration;
-		}
-
-		ctsduration += series[0].PktDuration;
-
-		if ((bf->bf_flags & ATH9K_TXDESC_NOACK) == 0) { /* SIFS + ACK */
-			ctsduration += bf_isshpreamble(bf) ?
-				rt->info[rix].spAckDuration :
-				rt->info[rix].lpAckDuration;
-		}
-
-		/*
-		 * Disable multi-rate retry when using RTS/CTS by clearing
-		 * series 1, 2 and 3.
-		 */
-		memset(&series[1], 0, sizeof(struct ath9k_11n_rate_series) * 3);
-	}
-
-	/*
 	 * set dur_update_en for l-sig computation except for PS-Poll frames
 	 */
 	ath9k_hw_set11n_ratescenario(ah, ds, lastds,
-- 
1.6.0.3

