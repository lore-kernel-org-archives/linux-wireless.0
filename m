Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43582 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1HME6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 00:58:05 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 02/11] ath9k: Fix rx overrun interrupt storm
Date: Sat, 13 Aug 2011 10:28:09 +0530
Message-ID: <1313211498-14442-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110813_065810_538320_015BCD0E)
In-Reply-To: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever RXEOL is received, both RXORN and RXEOL got cleared
to avoid rx overrun interrupt storm. This was handled only for
edma chips. The same scenario was also observered with AR9280,
doing frequent channel type switch b/w HT20/40 with bidi traffic
that is causing failure to stop rx dma. This patch clears
the RXEOL & RXORN interrupts for all chips.

ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
DMADBG_7=0x000062c0
ath: Could not stop RX, we could be confusing the DMA engine when we
start RX up
------------[ cut here ]------------
WARNING: at drivers/net/wireless/ath/ath9k/recv.c:532
ath_stoprecv+0x110/0x120 [ath9k]()
Call Trace:
 [<ffffffff8104a55a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8104a5a5>] warn_slowpath_null+0x15/0x20
 [<ffffffffa0560380>] ath_stoprecv+0x110/0x120 [ath9k]
 [<ffffffffa055e6fa>] ath_reset+0x6a/0x200 [ath9k]

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1e7fe8c..097c1eb 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -826,11 +826,9 @@ irqreturn_t ath_isr(int irq, void *dev)
 	if (status & ATH9K_INT_TXURN)
 		ath9k_hw_updatetxtriglevel(ah, true);
 
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
-		if (status & ATH9K_INT_RXEOL) {
-			ah->imask &= ~(ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
-			ath9k_hw_set_interrupts(ah, ah->imask);
-		}
+	if (status & ATH9K_INT_RXEOL) {
+		ah->imask &= ~(ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
+		ath9k_hw_set_interrupts(ah, ah->imask);
 	}
 
 	if (status & ATH9K_INT_MIB) {
-- 
1.7.6

