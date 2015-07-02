Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:41965
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753333AbbGBLkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 07:40:33 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH] ath9k: make DMA stop related messages debug-only
Date: Thu,  2 Jul 2015 13:40:29 +0200
Message-Id: <1435837229-94571-1-git-send-email-nbd@openwrt.org> (sfid-20150702_134037_263416_68AFF237)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A long time ago, ath9k had issues during reset where the DMA engine
would stay active and could potentially corrupt memory.
To debug those issues, the driver would print warnings whenever they
occur.

Nowadays, these issues are gone and the primary cause of these messages
is if the MAC is stuck during reset or busy processing a long
transmission. This is fairly harmless, yet these messages continue to
worry users.

To reduce the number of bogus bug reports, turn these messages into
debug messages and count their occurence in the "reset" debugfs file.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c | 2 ++
 drivers/net/wireless/ath/ath9k/debug.h | 2 ++
 drivers/net/wireless/ath/ath9k/recv.c  | 7 +++----
 drivers/net/wireless/ath/ath9k/xmit.c  | 7 +++++--
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index dbf8f49..da32c8f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -765,6 +765,8 @@ static int read_file_reset(struct seq_file *file, void *data)
 		[RESET_TYPE_BEACON_STUCK] = "Stuck Beacon",
 		[RESET_TYPE_MCI] = "MCI Reset",
 		[RESET_TYPE_CALIBRATION] = "Calibration error",
+		[RESET_TX_DMA_ERROR] = "Tx DMA stop error",
+		[RESET_RX_DMA_ERROR] = "Rx DMA stop error",
 	};
 	int i;
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index a8e9319..cd68c5f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -50,6 +50,8 @@ enum ath_reset_type {
 	RESET_TYPE_BEACON_STUCK,
 	RESET_TYPE_MCI,
 	RESET_TYPE_CALIBRATION,
+	RESET_TX_DMA_ERROR,
+	RESET_RX_DMA_ERROR,
 	__RESET_TYPE_MAX
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b777209..ce79219 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -491,10 +491,9 @@ bool ath_stoprecv(struct ath_softc *sc)
 
 	if (!(ah->ah_flags & AH_UNPLUGGED) &&
 	    unlikely(!stopped)) {
-		ath_err(ath9k_hw_common(sc->sc_ah),
-			"Could not stop RX, we could be "
-			"confusing the DMA engine when we start RX up\n");
-		ATH_DBG_WARN_ON_ONCE(!stopped);
+		ath_dbg(ath9k_hw_common(sc->sc_ah), RESET,
+			"Failed to stop Rx DMA\n");
+		RESET_STAT_INC(sc, RESET_RX_DMA_ERROR);
 	}
 	return stopped && !reset;
 }
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3ad79bb..2c627f1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1883,8 +1883,11 @@ bool ath_drain_all_txq(struct ath_softc *sc)
 			npend |= BIT(i);
 	}
 
-	if (npend)
-		ath_err(common, "Failed to stop TX DMA, queues=0x%03x!\n", npend);
+	if (npend) {
+		RESET_STAT_INC(sc, RESET_TX_DMA_ERROR);
+		ath_dbg(common, RESET,
+			"Failed to stop TX DMA, queues=0x%03x!\n", npend);
+	}
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 		if (!ATH_TXQ_SETUP(sc, i))
-- 
2.2.2

