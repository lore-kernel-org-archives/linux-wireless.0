Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33051 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450Ab0DOVjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v3 96/97] ath9k_hw: Abort rx if hw is not coming out of full sleep in reset
Date: Thu, 15 Apr 2010 17:39:41 -0400
Message-Id: <1271367582-992-97-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    7 +++++++
 drivers/net/wireless/ath/ath9k/mac.c |    8 ++++++++
 drivers/net/wireless/ath/ath9k/mac.h |    1 +
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 44077cb..b9921e9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1138,6 +1138,13 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ah->txchainmask = common->tx_chainmask;
 	ah->rxchainmask = common->rx_chainmask;
 
+	if (!ah->chip_fullsleep) {
+		ath9k_hw_abortpcurecv(ah);
+		if (!ath9k_hw_stopdmarecv(ah))
+			ath_print(common, ATH_DBG_XMIT,
+				"Failed to stop receive dma\n");
+	}
+
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return -EIO;
 
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index c003baf..b54e857 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -747,6 +747,14 @@ void ath9k_hw_stoppcurecv(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_stoppcurecv);
 
+void ath9k_hw_abortpcurecv(struct ath_hw *ah)
+{
+	REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_RX_ABORT | AR_DIAG_RX_DIS);
+
+	ath9k_hw_disable_mib_counters(ah);
+}
+EXPORT_SYMBOL(ath9k_hw_abortpcurecv);
+
 bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
 {
 #define AH_RX_STOP_DMA_TIMEOUT 10000   /* usec */
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 346d84a..68eb8d0 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -711,6 +711,7 @@ bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set);
 void ath9k_hw_putrxbuf(struct ath_hw *ah, u32 rxdp);
 void ath9k_hw_startpcureceive(struct ath_hw *ah);
 void ath9k_hw_stoppcurecv(struct ath_hw *ah);
+void ath9k_hw_abortpcurecv(struct ath_hw *ah);
 bool ath9k_hw_stopdmarecv(struct ath_hw *ah);
 int ath9k_hw_beaconq_setup(struct ath_hw *ah);
 
-- 
1.6.3.3

