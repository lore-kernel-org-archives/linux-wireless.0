Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:35900 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaAMCQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 21:16:11 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH v2 5/5] ath9k: Remove debug print in ISR
Date: Mon, 13 Jan 2014 07:40:56 +0530
Message-Id: <1389579056-13441-1-git-send-email-sujith@msujith.org> (sfid-20140113_031634_547442_190A9E36)
In-Reply-To: <1389578371-23943-5-git-send-email-sujith@msujith.org>
References: <1389578371-23943-5-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

There is no need to do this and we can avoid
an unused variable warning when CONFIG_ATH9K_WOW is
not selected.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
v2 - s/at9hk/ath9k in subject

 drivers/net/wireless/ath/ath9k/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 07fcf16..ca8aff1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -542,7 +542,6 @@ irqreturn_t ath_isr(int irq, void *dev)
 
 	struct ath_softc *sc = dev;
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
 	enum ath9k_int status;
 	u32 sync_cause = 0;
 	bool sched = false;
@@ -603,7 +602,6 @@ irqreturn_t ath_isr(int irq, void *dev)
 #ifdef CONFIG_ATH9K_WOW
 	if (status & ATH9K_INT_BMISS) {
 		if (atomic_read(&sc->wow_sleep_proc_intr) == 0) {
-			ath_dbg(common, ANY, "during WoW we got a BMISS\n");
 			atomic_inc(&sc->wow_got_bmiss_intr);
 			atomic_dec(&sc->wow_sleep_proc_intr);
 		}
-- 
1.8.5.2

