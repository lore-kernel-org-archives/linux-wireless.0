Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53690 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387963AbeGWRFN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 13:05:13 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 3/9] ath9k: force rx_clear when disabling rx
Date: Mon, 23 Jul 2018 18:02:54 +0200
Message-Id: <20180723160300.58024-3-nbd@nbd.name> (sfid-20180723_180323_210355_FAD0265B)
In-Reply-To: <20180723160300.58024-1-nbd@nbd.name>
References: <20180723160300.58024-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

This makes stopping Rx more reliable and should reduce the frequency of
Rx related DMA stop warnings. Don't use rx_clear in TX99 mode.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/mac.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 58d02c19b6d0..c9d2bf3fa135 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -678,13 +678,18 @@ void ath9k_hw_startpcureceive(struct ath_hw *ah, bool is_scanning)
 
 	ath9k_ani_reset(ah, is_scanning);
 
-	REG_CLR_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
+	REG_CLR_BIT(ah, AR_DIAG_SW,
+		    AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT | AR_DIAG_FORCE_RX_CLEAR);
 }
 EXPORT_SYMBOL(ath9k_hw_startpcureceive);
 
 void ath9k_hw_abortpcurecv(struct ath_hw *ah)
 {
-	REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_RX_ABORT | AR_DIAG_RX_DIS);
+	u32 reg = AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT;
+
+	if (!IS_ENABLED(CPTCFG_ATH9K_TX99))
+		reg |= AR_DIAG_FORCE_RX_CLEAR;
+	REG_SET_BIT(ah, AR_DIAG_SW, reg);
 
 	ath9k_hw_disable_mib_counters(ah);
 }
-- 
2.17.0
