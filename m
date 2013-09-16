Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57741 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3IPFLA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 01:11:00 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] ath9k: Handle FATAL interrupts correctly
Date: Mon, 16 Sep 2013 10:37:00 +0530
Message-Id: <1379308021-20891-2-git-send-email-sujith@msujith.org> (sfid-20130916_071104_610993_789DC34C)
In-Reply-To: <1379308021-20891-1-git-send-email-sujith@msujith.org>
References: <1379308021-20891-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When a FATAL interrupt is received, a full chip reset is
required, which is done in the main tasklet. But since
the reset routine is scheduled as a work item, make sure
that interrupts are not enabled in the tasklet before the
reset is done.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e4f6590..cdb3b1e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -362,6 +362,13 @@ void ath9k_tasklet(unsigned long data)
 			type = RESET_TYPE_BB_WATCHDOG;
 
 		ath9k_queue_reset(sc, type);
+
+		/*
+		 * Increment the ref. counter here so that
+		 * interrupts are enabled in the reset routine.
+		 */
+		atomic_inc(&ah->intr_ref_cnt);
+		ath_dbg(common, ANY, "FATAL: Skipping interrupts\n");
 		goto out;
 	}
 
@@ -400,10 +407,9 @@ void ath9k_tasklet(unsigned long data)
 
 	ath9k_btcoex_handle_interrupt(sc, status);
 
-out:
 	/* re-enable hardware interrupt */
 	ath9k_hw_enable_interrupts(ah);
-
+out:
 	spin_unlock(&sc->sc_pcu_lock);
 	ath9k_ps_restore(sc);
 }
-- 
1.8.4

