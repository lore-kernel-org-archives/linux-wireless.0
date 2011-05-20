Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59053 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935738Ab1ETMWo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 08:22:44 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 05:22:13 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 4/6] ath9k_hw: disable phy restart on baseband panic caused by RXSM
Date: Fri, 20 May 2011 17:52:13 +0530
Message-ID: <1305894135-14036-4-git-send-email-rmanoharan@atheros.com> (sfid-20110520_142248_532744_CCFD7F39)
In-Reply-To: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
References: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While receiving unsupported rate frame rx state machine
gets into a state 0xb and if phy_restart happens in that
state, BB would go hang. If RXSM is in 0xb state after
first bb panic, ensure to disable the phy_restart.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   22 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c         |    5 ++++-
 drivers/net/wireless/ath/ath9k/hw.h         |    2 ++
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index eee23ec..892c48b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1381,3 +1381,25 @@ void ar9003_hw_bb_watchdog_dbg_info(struct ath_hw *ah)
 		"==== BB update: done ====\n\n");
 }
 EXPORT_SYMBOL(ar9003_hw_bb_watchdog_dbg_info);
+
+void ar9003_hw_disable_phy_restart(struct ath_hw *ah)
+{
+	u32 val;
+
+	/* While receiving unsupported rate frame rx state machine
+	 * gets into a state 0xb and if phy_restart happens in that
+	 * state, BB would go hang. If RXSM is in 0xb state after
+	 * first bb panic, ensure to disable the phy_restart.
+	 */
+	if (!((MS(ah->bb_watchdog_last_status,
+		  AR_PHY_WATCHDOG_RX_OFDM_SM) == 0xb) ||
+	    ah->bb_hang_rx_ofdm))
+		return;
+
+	ah->bb_hang_rx_ofdm = true;
+	val = REG_READ(ah, AR_PHY_RESTART);
+	val &= ~AR_PHY_RESTART_ENA;
+
+	REG_WRITE(ah, AR_PHY_RESTART, val);
+}
+EXPORT_SYMBOL(ar9003_hw_disable_phy_restart);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8300ed1..6de2655 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1555,9 +1555,12 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (ah->btcoex_hw.enabled)
 		ath9k_hw_btcoex_enable(ah);
 
-	if (AR_SREV_9300_20_OR_LATER(ah))
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		ar9003_hw_bb_watchdog_config(ah);
 
+		ar9003_hw_disable_phy_restart(ah);
+	}
+
 	ath9k_hw_apply_gpio_override(ah);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f8a626d..5111553 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -841,6 +841,7 @@ struct ath_hw {
 
 	u32 bb_watchdog_last_status;
 	u32 bb_watchdog_timeout_ms; /* in ms, 0 to disable */
+	u8 bb_hang_rx_ofdm; /* true if bb hang due to rx_ofdm */
 
 	unsigned int paprd_target_power;
 	unsigned int paprd_training_power;
@@ -989,6 +990,7 @@ void ar9002_hw_enable_wep_aggregation(struct ath_hw *ah);
 void ar9003_hw_bb_watchdog_config(struct ath_hw *ah);
 void ar9003_hw_bb_watchdog_read(struct ath_hw *ah);
 void ar9003_hw_bb_watchdog_dbg_info(struct ath_hw *ah);
+void ar9003_hw_disable_phy_restart(struct ath_hw *ah);
 void ar9003_paprd_enable(struct ath_hw *ah, bool val);
 void ar9003_paprd_populate_single_table(struct ath_hw *ah,
 					struct ath9k_hw_cal_data *caldata,
-- 
1.7.5.1

