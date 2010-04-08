Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46927 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933272Ab0DHT1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:47 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 066/102] ath9k_hw: add a helper for changing the TX/RX masks
Date: Thu,  8 Apr 2010 15:27:02 -0400
Message-Id: <1270754858-26266-67-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   14 ++++++++------
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |    4 ++++
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index e73b07a..faa7d0f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -247,13 +247,10 @@ static void ar9003_hw_init_bb(struct ath_hw *ah,
 	udelay(synthDelay + BASE_ACTIVATE_DELAY);
 }
 
-static void ar9003_hw_init_chain_masks(struct ath_hw *ah)
+void ar9003_hw_modify_chain_masks(struct ath_hw *ah,
+				  u8 rx_chainmask,
+				  u8 tx_chainmask)
 {
-	int rx_chainmask, tx_chainmask;
-
-	rx_chainmask = ah->rxchainmask;
-	tx_chainmask = ah->txchainmask;
-
 	switch (rx_chainmask) {
 	case 0x5:
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
@@ -276,6 +273,11 @@ static void ar9003_hw_init_chain_masks(struct ath_hw *ah)
 	}
 }
 
+static void ar9003_hw_init_chain_masks(struct ath_hw *ah)
+{
+	ar9003_hw_modify_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
+}
+
 /*
  * Override INI values with chip specific configuration.
  */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index b9a76d3..1aeeba3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -788,4 +788,8 @@
 
 #define AR_PHY_BB_WD_STATUS_CLR         0x00000008
 
+void ar9003_hw_modify_chain_masks(struct ath_hw *ah,
+				  u8 rx_chainmask,
+				  u8 tx_chainmask);
+
 #endif  /* AR9003_PHY_H */
-- 
1.6.3.3

