Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39322 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0DZTEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:04:41 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Paul Shaw <Paul.Shaw@Atheros.com>,
	Thomas Hammel <Thomas.Hammel@atheros.com>
Subject: [PATCH 04/13] ath9k_hw: disable TX IQ calibration for AR9003
Date: Mon, 26 Apr 2010 15:04:32 -0400
Message-Id: <1272308681-32396-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
References: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable TX IQ calibration, it was prematurely enabled in
previous versions.

Cc: Paul Shaw <Paul.Shaw@Atheros.com>
Cc: Thomas Hammel <Thomas.Hammel@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    3 ++-
 drivers/net/wireless/ath/ath9k/hw.c           |    6 ++++++
 drivers/net/wireless/ath/ath9k/hw.h           |    1 +
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 5e20b48..5fcafb4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -755,7 +755,8 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	}
 
 	/* Do Tx IQ Calibration */
-	ar9003_hw_tx_iq_cal(ah);
+	if (ah->config.tx_iq_calibration)
+		ar9003_hw_tx_iq_cal(ah);
 
 	/* Revert chainmasks to their original values before NF cal */
 	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5a29048..9af83e5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -387,6 +387,12 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	ah->config.rx_intr_mitigation = true;
 
 	/*
+	 * Tx IQ Calibration (ah->config.tx_iq_calibration) is only
+	 * used by AR9003, but it is showing reliability issues.
+	 * It will take a while to fix so this is currently disabled.
+	 */
+
+	/*
 	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
 	 * _and_ if on non-uniprocessor systems (Multiprocessor/HT).
 	 * This means we use it for all AR5416 devices, and the few
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a78e09b..6c84d31 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -261,6 +261,7 @@ struct ath9k_ops_config {
 #define AR_BASE_FREQ_5GHZ   	4900
 #define AR_SPUR_FEEQ_BOUND_HT40 19
 #define AR_SPUR_FEEQ_BOUND_HT20 10
+	bool tx_iq_calibration; /* Only available for >= AR9003 */
 	int spurmode;
 	u16 spurchans[AR_EEPROM_MODAL_SPURS][2];
 	u8 max_txtrig_level;
-- 
1.6.3.3

