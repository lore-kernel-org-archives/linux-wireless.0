Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:34645 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab2I0OlK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 10:41:10 -0400
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] ath9k_hw: Handle AR_INTR_SYNC_HOST1_(FATAL|PERR) on AR9003
Date: Thu, 27 Sep 2012 16:41:02 +0200
Message-Id: <1348756862-8788-1-git-send-email-sven@narfation.org> (sfid-20120927_164132_243932_6945E048)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interrupts with the sync_cause AR_INTR_SYNC_HOST1_FATAL and
AR_INTR_SYNC_HOST1_PERR have to be handled using a chip reset. Otherwise a
interrupt storm with unhandled interrupts will cause a hang or crash of the
machine.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
I don't have any hardware documentation. So I need someone who checks the
flags whether this is really like AR9002 and not another thing which only
gets fixed by accident using this patch.

 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index d5b2e0e..301bf72 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -182,6 +182,7 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 sync_cause = 0, async_cause, async_mask = AR_INTR_MAC_IRQ;
+	bool fatal_int;
 
 	if (ath9k_hw_mci_is_enabled(ah))
 		async_mask |= AR_INTR_ASYNC_MASK_MCI;
@@ -310,6 +311,22 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 
 	if (sync_cause) {
 		ath9k_debug_sync_cause(common, sync_cause);
+		fatal_int =
+			(sync_cause &
+			 (AR_INTR_SYNC_HOST1_FATAL | AR_INTR_SYNC_HOST1_PERR))
+			? true : false;
+
+		if (fatal_int) {
+			if (sync_cause & AR_INTR_SYNC_HOST1_FATAL) {
+				ath_dbg(common, ANY,
+					"received PCI FATAL interrupt\n");
+			}
+			if (sync_cause & AR_INTR_SYNC_HOST1_PERR) {
+				ath_dbg(common, ANY,
+					"received PCI PERR interrupt\n");
+			}
+			*masked |= ATH9K_INT_FATAL;
+		}
 
 		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
 			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
-- 
1.7.10.4

