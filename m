Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3676 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444AbZEMPP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 11:15:59 -0400
Date: Wed, 13 May 2009 11:14:39 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, forrest@hifulltech.com
Cc: ath5k-devel@lists.ath5k.org, mickflemm@gmail.com,
	jirislaby@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: fix exp off-by-one when computing OFDM delta slope
Message-ID: <20090513151439.GA28476@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


From: Forrest Zhang <forrest@hifulltech.com>

Commit e8f055f0c3ba226ca599c14c2e5fe829f6f57cbb subtly changed the
code that computes floating point values for the PHY3_TIMING register
such that the exponent is off by a decimal point, which can cause
problems with OFDM channel operation.

get_bitmask_order() actually returns the highest bit set plus one,
whereas the previous code wanted the highest bit set.  Instead, use
ilog2 which is what this code is really calculating.  Also check
coef_scaled to handle the (invalid) case where we need log2(0).

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

John, this plus 706d64453cce7179e05924c24d87777584a1275c fixes a 
regression for 2.6.30 5ghz operation (bugzilla 13077).  Any chance
they can both make it in?  I can send a backport of this patch if
you like (usual path change).

 drivers/net/wireless/ath/ath5k/reset.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 386bc8b..bd1940e 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -26,7 +26,7 @@
 \*****************************/
 
 #include <linux/pci.h> 		/* To determine if a card is pci-e */
-#include <linux/bitops.h>	/* For get_bitmask_order */
+#include <linux/log2.h>
 #include "ath5k.h"
 #include "reg.h"
 #include "base.h"
@@ -69,10 +69,10 @@ static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
 
 	/* Get exponent
 	 * ALGO: coef_exp = 14 - highest set bit position */
-	coef_exp = get_bitmask_order(coef_scaled);
+	coef_exp = ilog2(coef_scaled);
 
 	/* Doesn't make sense if it's zero*/
-	if (!coef_exp)
+	if (!coef_scaled || !coef_exp)
 		return -EINVAL;
 
 	/* Note: we've shifted coef_scaled by 24 */
-- 
1.6.0.6

-- 
Bob Copeland %% www.bobcopeland.com

