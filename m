Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:34847 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab2JBKdh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2012 06:33:37 -0400
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, lindner_marek@yahoo.de,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL on AR9003
Date: Tue,  2 Oct 2012 12:33:29 +0200
Message-Id: <1349174009-16496-1-git-send-email-sven@narfation.org> (sfid-20121002_123341_615547_B10666BE)
In-Reply-To: <1348756862-8788-1-git-send-email-sven@narfation.org>
References: <1348756862-8788-1-git-send-email-sven@narfation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interrupts with the sync_cause AR_INTR_SYNC_HOST1_FATAL has to be handled
using a chip reset. Otherwise a interrupt storm with unhandled interrupts
will cause a hang or crash of the machine.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
I was informed that AR_INTR_SYNC_HOST1_PERR should not be handled this way
because it can create system freezes after an adhoc interface was created.

I really need some Atheros developer who can check the documentation to
verify the interpretation of these flags. Otherwise this is just guessing
and may lead to even bigger problems.

 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index d5b2e0e..6031bdf 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -311,6 +311,11 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 	if (sync_cause) {
 		ath9k_debug_sync_cause(common, sync_cause);
 
+		if (sync_cause & AR_INTR_SYNC_HOST1_FATAL) {
+			ath_dbg(common, ANY, "received PCI FATAL interrupt\n");
+			*masked |= ATH9K_INT_FATAL;
+		}
+
 		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
 			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
 			REG_WRITE(ah, AR_RC, 0);
-- 
1.7.10.4

