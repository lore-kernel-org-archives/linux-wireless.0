Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59136 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab0LBLLZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 06:11:25 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 03:11:11 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 10/27] ath9k_hw: Find the maximum number of chains that hw supports
Date: Thu, 2 Dec 2010 03:06:54 -0800
Message-ID: <1291288031-3409-11-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Have it in ah->caps. This will be used during various
calibrations.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   14 +++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.h |    2 ++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b1d3c1e..ddbd6fb 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1777,7 +1777,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
 	u16 capField = 0, eeval;
-	u8 ant_div_ctl1;
+	u8 ant_div_ctl1, tx_chainmask, rx_chainmask;
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_0);
 	regulatory->current_rd = eeval;
@@ -1989,6 +1989,18 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		pCap->pcie_lcr_offset = 0x80;
 	}
 
+	tx_chainmask = pCap->tx_chainmask;
+	rx_chainmask = pCap->rx_chainmask;
+	while (tx_chainmask || rx_chainmask) {
+		if (tx_chainmask & BIT(0))
+			pCap->max_txchains++;
+		if (rx_chainmask & BIT(0))
+			pCap->max_rxchains++;
+
+		tx_chainmask >>= 1;
+		rx_chainmask >>= 1;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1eb6a14..bd0717e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -200,6 +200,8 @@ struct ath9k_hw_capabilities {
 	u16 rts_aggr_limit;
 	u8 tx_chainmask;
 	u8 rx_chainmask;
+	u8 max_txchains;
+	u8 max_rxchains;
 	u16 tx_triglevel_max;
 	u16 reg_cap;
 	u8 num_gpio_pins;
-- 
1.7.0.4

