Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:59966 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3LXFTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Dec 2013 00:19:33 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/11] ath9k: Fix PHY restart workaround
Date: Tue, 24 Dec 2013 10:44:21 +0530
Message-Id: <1387862067-25457-5-git-send-email-sujith@msujith.org> (sfid-20131224_062016_977458_E9E5F35B)
In-Reply-To: <1387862067-25457-1-git-send-email-sujith@msujith.org>
References: <1387862067-25457-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The PHY restart workaround that handles baseband hangs
for packets with unsupported rates is required only
for a HW bug in AR9300 v2.2. All the subsequent chips in
the AR9003 family do not require this driver fix since
it has been addressed in the HW.

Since the value of the AR_PHY_RESTART register is written
with the default initvals, make sure that PHY restart is
always disabled once this particular BB hang signaure has
been encountered.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 17 ++++++++---------
 drivers/net/wireless/ath/ath9k/hw.c         |  5 +++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 9f051a0..b020331 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1930,6 +1930,7 @@ EXPORT_SYMBOL(ar9003_hw_bb_watchdog_dbg_info);
 
 void ar9003_hw_disable_phy_restart(struct ath_hw *ah)
 {
+	u8 result;
 	u32 val;
 
 	/* While receiving unsupported rate frame rx state machine
@@ -1937,15 +1938,13 @@ void ar9003_hw_disable_phy_restart(struct ath_hw *ah)
 	 * state, BB would go hang. If RXSM is in 0xb state after
 	 * first bb panic, ensure to disable the phy_restart.
 	 */
-	if (!((MS(ah->bb_watchdog_last_status,
-		  AR_PHY_WATCHDOG_RX_OFDM_SM) == 0xb) ||
-	    ah->bb_hang_rx_ofdm))
-		return;
-
-	ah->bb_hang_rx_ofdm = true;
-	val = REG_READ(ah, AR_PHY_RESTART);
-	val &= ~AR_PHY_RESTART_ENA;
+	result = MS(ah->bb_watchdog_last_status, AR_PHY_WATCHDOG_RX_OFDM_SM);
 
-	REG_WRITE(ah, AR_PHY_RESTART, val);
+	if ((result == 0xb) || ah->bb_hang_rx_ofdm) {
+		ah->bb_hang_rx_ofdm = true;
+		val = REG_READ(ah, AR_PHY_RESTART);
+		val &= ~AR_PHY_RESTART_ENA;
+		REG_WRITE(ah, AR_PHY_RESTART, val);
+	}
 }
 EXPORT_SYMBOL(ar9003_hw_disable_phy_restart);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7aa7835..fc4bb48 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1935,10 +1935,11 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	ath9k_hw_loadnf(ah, chan);
 	ath9k_hw_start_nfcal(ah, true);
 
-	if (AR_SREV_9300_20_OR_LATER(ah)) {
+	if (AR_SREV_9300_20_OR_LATER(ah))
 		ar9003_hw_bb_watchdog_config(ah);
+
+	if (ah->config.hw_hang_checks & HW_PHYRESTART_CLC_WAR)
 		ar9003_hw_disable_phy_restart(ah);
-	}
 
 	ath9k_hw_apply_gpio_override(ah);
 
-- 
1.8.5.2

