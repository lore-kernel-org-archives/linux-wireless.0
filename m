Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:52163 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaJHDl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 23:41:57 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 2/3] ath9k: Set ATH_OP_HW_RESET before HW reset
Date: Wed,  8 Oct 2014 09:12:44 +0530
Message-Id: <1412739765-31679-3-git-send-email-sujith@msujith.org> (sfid-20141008_054208_623786_9820F4CD)
In-Reply-To: <1412739765-31679-1-git-send-email-sujith@msujith.org>
References: <1412739765-31679-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

When a HW reset is done, the interrupt tasklet is
disabled before ISRs are disabled in the HW. This
allows a small window where the HW can still generate
interrupts. Since the tasklet is disabled and not killed,
it is not scheduled but deferred for execution at a later
time.

This happens because ATH_OP_HW_RESET is not set when ath_reset()
is called. When the hw_reset_work workqueue is used, this
problem doesn't arise because ATH_OP_HW_RESET is set
and the ISR bails out.

Set ATH_OP_HW_RESET properly in ath_reset() to avoid
this race - all the ath_reset_internal() callers have
been converted to use ath_reset() in the previous patch.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index eb6ba9f..dda09ba 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -598,10 +598,17 @@ chip_reset:
 #undef SCHED_INTR
 }
 
+/*
+ * This function is called when a HW reset cannot be deferred
+ * and has to be immediate.
+ */
 int ath_reset(struct ath_softc *sc, struct ath9k_channel *hchan)
 {
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int r;
 
+	set_bit(ATH_OP_HW_RESET, &common->op_flags);
+
 	ath9k_ps_wakeup(sc);
 	r = ath_reset_internal(sc, hchan);
 	ath9k_ps_restore(sc);
@@ -609,6 +616,11 @@ int ath_reset(struct ath_softc *sc, struct ath9k_channel *hchan)
 	return r;
 }
 
+/*
+ * When a HW reset can be deferred, it is added to the
+ * hw_reset_work workqueue, but we set ATH_OP_HW_RESET before
+ * queueing.
+ */
 void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-- 
2.1.2

