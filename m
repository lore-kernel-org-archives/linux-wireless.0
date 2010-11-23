Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45822 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab0KWSrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 13:47:36 -0500
Received: by eye27 with SMTP id 27so4865424eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 10:47:35 -0800 (PST)
Date: Tue, 23 Nov 2010 20:47:31 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 05/30] ath5k: Debug DMA timeouts
Message-ID: <20101123184731.GE4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Increase timeouts on ath5k_hw_stop_tx_dma and also wait for
 tx queue to stop before checking for pending frames

 * Add a new debug level to debug dma start/stop

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/debug.c |    1 +
 drivers/net/wireless/ath/ath5k/debug.h |    2 +
 drivers/net/wireless/ath/ath5k/dma.c   |   34 +++++++++++++++++++++++++++----
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 7d785cb..5341dd2 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -312,6 +312,7 @@ static const struct {
 	{ ATH5K_DEBUG_DUMP_RX,	"dumprx",	"print received skb content" },
 	{ ATH5K_DEBUG_DUMP_TX,	"dumptx",	"print transmit skb content" },
 	{ ATH5K_DEBUG_DUMPBANDS, "dumpbands",	"dump bands" },
+	{ ATH5K_DEBUG_DMA,	"dma",		"dma start/stop" },
 	{ ATH5K_DEBUG_ANI,	"ani",		"adaptive noise immunity" },
 	{ ATH5K_DEBUG_DESC,	"desc",		"descriptor chains" },
 	{ ATH5K_DEBUG_ANY,	"all",		"show all debug levels" },
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index 236edbd..3e34428 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -95,6 +95,7 @@ struct ath5k_dbg_info {
  * @ATH5K_DEBUG_DUMP_RX: print received skb content
  * @ATH5K_DEBUG_DUMP_TX: print transmit skb content
  * @ATH5K_DEBUG_DUMPBANDS: dump bands
+ * @ATH5K_DEBUG_DMA: debug dma start/stop
  * @ATH5K_DEBUG_TRACE: trace function calls
  * @ATH5K_DEBUG_DESC: descriptor setup
  * @ATH5K_DEBUG_ANY: show at any debug level
@@ -118,6 +119,7 @@ enum ath5k_debug_level {
 	ATH5K_DEBUG_DUMP_RX	= 0x00000100,
 	ATH5K_DEBUG_DUMP_TX	= 0x00000200,
 	ATH5K_DEBUG_DUMPBANDS	= 0x00000400,
+	ATH5K_DEBUG_DMA		= 0x00000800,
 	ATH5K_DEBUG_ANI		= 0x00002000,
 	ATH5K_DEBUG_DESC	= 0x00004000,
 	ATH5K_DEBUG_ANY		= 0xffffffff
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index ca0467e..e39c953 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -70,7 +70,11 @@ int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
 	for (i = 1000; i > 0 &&
 			(ath5k_hw_reg_read(ah, AR5K_CR) & AR5K_CR_RXE) != 0;
 			i--)
-		udelay(10);
+		udelay(100);
+
+	if (i)
+		ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_DMA,
+				"failed to stop RX DMA !\n");
 
 	return i ? 0 : -EBUSY;
 }
@@ -217,7 +221,18 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 		 */
 		AR5K_REG_WRITE_Q(ah, AR5K_QCU_TXD, queue);
 
-		/*Check for pending frames*/
+		/* Wait for queue to stop */
+		for (i = 1000; i > 0 &&
+		(AR5K_REG_READ_Q(ah, AR5K_QCU_TXE, queue) != 0);
+		i--)
+			udelay(100);
+
+		if (AR5K_REG_READ_Q(ah, AR5K_QCU_TXE, queue))
+			ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_DMA,
+				"queue %i didn't stop !\n", queue);
+
+		/* Check for pending frames */
+		i = 1000;
 		do {
 			pending = ath5k_hw_reg_read(ah,
 				AR5K_QUEUE_STATUS(queue)) &
@@ -248,12 +263,12 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 					AR5K_DIAG_SW_CHANNEL_IDLE_HIGH);
 
 			/* Wait a while and disable mechanism */
-			udelay(200);
+			udelay(400);
 			AR5K_REG_DISABLE_BITS(ah, AR5K_QUIET_CTL1,
 						AR5K_QUIET_CTL1_QT_EN);
 
 			/* Re-check for pending frames */
-			i = 40;
+			i = 100;
 			do {
 				pending = ath5k_hw_reg_read(ah,
 					AR5K_QUEUE_STATUS(queue)) &
@@ -263,12 +278,21 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 
 			AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW_5211,
 					AR5K_DIAG_SW_CHANNEL_IDLE_HIGH);
+
+			if (pending)
+				ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_DMA,
+					"quiet mechanism didn't work q:%i !\n",
+					queue);
 		}
 
 		/* Clear register */
 		ath5k_hw_reg_write(ah, 0, AR5K_QCU_TXD);
-		if (pending)
+		if (pending) {
+			ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_DMA,
+					"tx dma didn't stop (q:%i, frm:%i) !\n",
+					queue, pending);
 			return -EBUSY;
+		}
 	}
 
 	/* TODO: Check for success on 5210 else return error */
