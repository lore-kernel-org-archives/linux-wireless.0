Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:59000
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755075AbbFBIv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 04:51:28 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH] ath9k: fix DMA stop sequence for AR9003+
Date: Tue,  2 Jun 2015 10:38:32 +0200
Message-Id: <1433234312-78045-1-git-send-email-nbd@openwrt.org> (sfid-20150602_105132_586870_FF2C9279)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR93xx and newer needs to stop rx before tx to avoid getting the DMA
engine or MAC into a stuck state.
This should reduce/fix the occurence of "Failed to stop Tx DMA" logspam.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d285e3a..cfd45cb 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -216,11 +216,13 @@ static bool ath_prepare_reset(struct ath_softc *sc)
 	ath_stop_ani(sc);
 	ath9k_hw_disable_interrupts(ah);
 
-	if (!ath_drain_all_txq(sc))
-		ret = false;
-
-	if (!ath_stoprecv(sc))
-		ret = false;
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		ret &= ath_stoprecv(sc);
+		ret &= ath_drain_all_txq(sc);
+	} else {
+		ret &= ath_drain_all_txq(sc);
+		ret &= ath_stoprecv(sc);
+	}
 
 	return ret;
 }
-- 
2.2.2

