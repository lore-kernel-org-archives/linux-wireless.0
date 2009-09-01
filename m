Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64576 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbZIAMYt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 08:24:49 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 05:24:52 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 1/2] ath9k: Move generic hw timer intr handler to bottom-half
Date: Tue, 1 Sep 2009 17:46:32 +0530
Message-ID: <1251807393-8262-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no point handling this in hard irq, move it to
tasklet.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4fae699..efee193 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -506,6 +506,10 @@ static void ath9k_tasklet(unsigned long data)
 		sc->sc_flags |= SC_OP_WAIT_FOR_BEACON | SC_OP_BEACON_SYNC;
 	}
 
+	if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
+		if (status & ATH9K_INT_GENTIMER)
+			ath_gen_timer_isr(sc->sc_ah);
+
 	/* re-enable hardware interrupt */
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 	ath9k_ps_restore(sc);
@@ -521,7 +525,8 @@ irqreturn_t ath_isr(int irq, void *dev)
 		ATH9K_INT_TX |			\
 		ATH9K_INT_BMISS |		\
 		ATH9K_INT_CST |			\
-		ATH9K_INT_TSFOOR)
+		ATH9K_INT_TSFOOR |		\
+		ATH9K_INT_GENTIMER)
 
 	struct ath_softc *sc = dev;
 	struct ath_hw *ah = sc->sc_ah;
@@ -602,10 +607,6 @@ irqreturn_t ath_isr(int irq, void *dev)
 			sc->sc_flags |= SC_OP_WAIT_FOR_BEACON;
 		}
 
-	if (sc->btcoex_info.btcoex_scheme == ATH_BTCOEX_CFG_3WIRE)
-		if (status & ATH9K_INT_GENTIMER)
-			ath_gen_timer_isr(ah);
-
 chip_reset:
 
 	ath_debug_stat_interrupt(sc, status);
-- 
1.5.5.1

