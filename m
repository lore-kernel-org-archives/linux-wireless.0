Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:36402 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaATIA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 03:00:58 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH] ath9k: Fix code mistake
Date: Mon, 20 Jan 2014 13:25:28 +0530
Message-Id: <1390204528-13015-1-git-send-email-sujith@msujith.org> (sfid-20140120_090107_014740_C01508E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The commit "ath9k: Process GTT interrupts" accidentally
had a line that was commented out.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 73a3655..5924f72 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -524,7 +524,7 @@ void ath9k_tasklet(unsigned long data)
 			 * successfully after a GTT interrupt, the GTT counter
 			 * gets reset to zero here.
 			 */
-			/* sc->gtt_cnt = 0; */
+			sc->gtt_cnt = 0;
 
 			ath_tx_edma_tasklet(sc);
 		} else {
-- 
1.8.5.3

