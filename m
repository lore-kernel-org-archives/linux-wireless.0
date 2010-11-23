Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52337 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab0KWSuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 13:50:46 -0500
Received: by eye27 with SMTP id 27so4867549eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 10:50:45 -0800 (PST)
Date: Tue, 23 Nov 2010 20:50:16 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 06/30] ath5k: Use DCU early termination correctly
Message-ID: <20101123185016.GF4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * DCU early termination should be used to quickly flush QCU
 according to docs so don't enable it for all queues, enable
 it only when stopping each queue and disable it when we are
 done.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/dma.c |   14 ++++++++++++++
 drivers/net/wireless/ath/ath5k/qcu.c |    3 ---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index e39c953..bfdfcff 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -216,6 +216,14 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 		ath5k_hw_reg_write(ah, tx_queue, AR5K_CR);
 		ath5k_hw_reg_read(ah, AR5K_CR);
 	} else {
+
+		/*
+		 * Enable DCU early termination to quickly
+		 * flush any pending frames from QCU
+		 */
+		AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
+					AR5K_QCU_MISC_DCU_EARLY);
+
 		/*
 		 * Schedule TX disable and wait until queue is empty
 		 */
@@ -285,6 +293,12 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 					queue);
 		}
 
+		/*
+		 * Disable DCU early termination
+		 */
+		AR5K_REG_DISABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
+					AR5K_QCU_MISC_DCU_EARLY);
+
 		/* Clear register */
 		ath5k_hw_reg_write(ah, 0, AR5K_QCU_TXD);
 		if (pending) {
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 52eee34f..ed62273 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -340,9 +340,6 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 		/*
 		 * Set misc registers
 		 */
-		/* Enable DCU early termination for this queue */
-		AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
-					AR5K_QCU_MISC_DCU_EARLY);
 
 		/* Enable DCU to wait for next fragment from QCU */
 		AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
