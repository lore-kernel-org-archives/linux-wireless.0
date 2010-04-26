Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39327 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0DZTEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:04:41 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 05/13] ath9k_hw: Fix usec to hw clock conversion in 5Ghz for ar9003
Date: Mon, 26 Apr 2010 15:04:33 -0400
Message-Id: <1272308681-32396-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
References: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Fast clock operation (44Mhz) is enabled for 5Ghz in ar9003, so
take care of the conversion from usec to hw clock.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   10 ++++++++--
 drivers/net/wireless/ath/ath9k/hw.h |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9af83e5..ca676cd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -26,6 +26,7 @@
 #define ATH9K_CLOCK_RATE_CCK		22
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
+#define ATH9K_CLOCK_FAST_RATE_5GHZ_OFDM 44
 
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type);
 
@@ -91,7 +92,11 @@ static u32 ath9k_hw_mac_clks(struct ath_hw *ah, u32 usecs)
 		return usecs *ATH9K_CLOCK_RATE_CCK;
 	if (conf->channel->band == IEEE80211_BAND_2GHZ)
 		return usecs *ATH9K_CLOCK_RATE_2GHZ_OFDM;
-	return usecs *ATH9K_CLOCK_RATE_5GHZ_OFDM;
+
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_FASTCLOCK)
+		return usecs * ATH9K_CLOCK_FAST_RATE_5GHZ_OFDM;
+	else
+		return usecs * ATH9K_CLOCK_RATE_5GHZ_OFDM;
 }
 
 static u32 ath9k_hw_mac_to_clks(struct ath_hw *ah, u32 usecs)
@@ -2192,7 +2197,8 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	}
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
-		pCap->hw_caps |= ATH9K_HW_CAP_EDMA | ATH9K_HW_CAP_LDPC;
+		pCap->hw_caps |= ATH9K_HW_CAP_EDMA | ATH9K_HW_CAP_LDPC |
+				 ATH9K_HW_CAP_FASTCLOCK;
 		pCap->rx_hp_qdepth = ATH9K_HW_RX_HP_QDEPTH;
 		pCap->rx_lp_qdepth = ATH9K_HW_RX_LP_QDEPTH;
 		pCap->rx_status_len = sizeof(struct ar9003_rxs);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6c84d31..7a1347b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -198,6 +198,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_EDMA			= BIT(17),
 	ATH9K_HW_CAP_RAC_SUPPORTED		= BIT(18),
 	ATH9K_HW_CAP_LDPC			= BIT(19),
+	ATH9K_HW_CAP_FASTCLOCK			= BIT(20),
 };
 
 enum ath9k_capability_type {
-- 
1.6.3.3

