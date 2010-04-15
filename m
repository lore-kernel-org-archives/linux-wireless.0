Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab0DOVjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 93/97] ath9k_hw: add LDPC support for AR9003
Date: Thu, 15 Apr 2010 17:39:38 -0400
Message-Id: <1271367582-992-94-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    3 ++-
 drivers/net/wireless/ath/ath9k/hw.c         |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h         |    1 +
 drivers/net/wireless/ath/ath9k/mac.h        |    2 ++
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 582c880..7d111fb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -330,7 +330,8 @@ static void ar9003_hw_set11n_txdesc(struct ath_hw *ah, void *ds,
 		| (flags & ATH9K_TXDESC_EXT_ONLY ? AR_ExtOnly : 0)
 		| (flags & ATH9K_TXDESC_EXT_AND_CTL ? AR_ExtAndCtl : 0);
 
-	ads->ctl17 = SM(keyType, AR_EncrType);
+	ads->ctl17 = SM(keyType, AR_EncrType) |
+		     (flags & ATH9K_TXDESC_LDPC ? AR_LDPC : 0);
 	ads->ctl18 = 0;
 	ads->ctl19 = AR_Not_Sounding;
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4092090..44077cb 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2089,7 +2089,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	}
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
-		pCap->hw_caps |= ATH9K_HW_CAP_EDMA;
+		pCap->hw_caps |= ATH9K_HW_CAP_EDMA | ATH9K_HW_CAP_LDPC;
 		pCap->rx_hp_qdepth = ATH9K_HW_RX_HP_QDEPTH;
 		pCap->rx_lp_qdepth = ATH9K_HW_RX_LP_QDEPTH;
 		pCap->rx_status_len = sizeof(struct ar9003_rxs);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9d3796a..7ce5420 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -179,6 +179,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(16),
 	ATH9K_HW_CAP_EDMA			= BIT(17),
 	ATH9K_HW_CAP_RAC_SUPPORTED		= BIT(18),
+	ATH9K_HW_CAP_LDPC			= BIT(19),
 };
 
 enum ath9k_capability_type {
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index b591dc2..346d84a 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -264,6 +264,7 @@ struct ath_desc {
 #define ATH9K_TXDESC_VMF		0x0100
 #define ATH9K_TXDESC_FRAG_IS_ON 	0x0200
 #define ATH9K_TXDESC_LOWRXCHAIN		0x0400
+#define ATH9K_TXDESC_LDPC		0x00010000
 
 #define ATH9K_RXDESC_INTREQ		0x0020
 
@@ -413,6 +414,7 @@ struct ar5416_desc {
 #define AR_EncrType         0x0c000000
 #define AR_EncrType_S       26
 #define AR_TxCtlRsvd61      0xf0000000
+#define AR_LDPC             0x80000000
 
 #define AR_2040_0           0x00000001
 #define AR_GI0              0x00000002
-- 
1.6.3.3

