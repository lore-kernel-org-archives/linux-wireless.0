Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25519 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2FKGsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 02:48:41 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 3/9] ath9k_hw: Fix AR9462 power consumption on idle associated
Date: Mon, 11 Jun 2012 12:19:31 +0530
Message-ID: <1339397377-3374-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120611_084844_400844_B0EBE4EF)
In-Reply-To: <1339397377-3374-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339397377-3374-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The HW statemachine is sometimes found stuck in the state
WL_LNA_CTRL_DISABLE when BT is in sleep, which will cause
TX_HOLD always asserted and resmgr stuck in PENDING_TX state

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |   34 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |   10 ++++++--
 drivers/net/wireless/ath/ath9k/hw.c         |    3 +++
 3 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index b1ced2a..13907f6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1404,3 +1404,37 @@ void ar9003_mci_bt_gain_ctrl(struct ath_hw *ah)
 	/* Force another 2g5g update at next scanning */
 	mci->update_2g5g = true;
 }
+
+void ar9003_mci_set_power_awake(struct ath_hw *ah)
+{
+	u32 btcoex_ctrl2, diag_sw;
+	int i;
+	u8 lna_ctrl, bt_sleep;
+
+	for (i = 0; i < AH_WAIT_TIMEOUT; i++) {
+		btcoex_ctrl2 = REG_READ(ah, AR_BTCOEX_CTRL2);
+		if (btcoex_ctrl2 != 0xdeadbeef)
+			break;
+		udelay(AH_TIME_QUANTUM);
+	}
+	REG_WRITE(ah, AR_BTCOEX_CTRL2, (btcoex_ctrl2 | BIT(23)));
+
+	for (i = 0; i < AH_WAIT_TIMEOUT; i++) {
+		diag_sw = REG_READ(ah, AR_DIAG_SW);
+		if (diag_sw != 0xdeadbeef)
+			break;
+		udelay(AH_TIME_QUANTUM);
+	}
+	REG_WRITE(ah, AR_DIAG_SW, (diag_sw | BIT(27) | BIT(19) | BIT(18)));
+	lna_ctrl = REG_READ(ah, AR_OBS_BUS_CTRL) & 0x3;
+	bt_sleep = REG_READ(ah, AR_MCI_RX_STATUS) & AR_MCI_RX_REMOTE_SLEEP;
+
+	REG_WRITE(ah, AR_BTCOEX_CTRL2, btcoex_ctrl2);
+	REG_WRITE(ah, AR_DIAG_SW, diag_sw);
+
+	if (bt_sleep && (lna_ctrl == 2)) {
+		REG_SET_BIT(ah, AR_BTCOEX_RC, 0x1);
+		REG_CLR_BIT(ah, AR_BTCOEX_RC, 0x1);
+		udelay(50);
+	}
+}
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 10282e2..2a8c764 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -265,8 +265,6 @@ void ar9003_mci_setup(struct ath_hw *ah, u32 gpm_addr, void *gpm_buf,
 void ar9003_mci_cleanup(struct ath_hw *ah);
 void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
 			      u32 *rx_msg_intr);
-void ar9003_mci_bt_gain_ctrl(struct ath_hw *ah);
-
 /*
  * These functions are used by ath9k_hw.
  */
@@ -285,6 +283,8 @@ int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 		      bool is_full_sleep);
 void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked);
+void ar9003_mci_bt_gain_ctrl(struct ath_hw *ah);
+void ar9003_mci_set_power_awake(struct ath_hw *ah);
 
 #else
 
@@ -322,6 +322,12 @@ static inline void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 static inline void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 {
 }
+static inline void ar9003_mci_bt_gain_ctrl(struct ath_hw *ah)
+{
+}
+static inline void ar9003_mci_set_power_awake(struct ath_hw *ah)
+{
+}
 #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
 
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 45e6700..6d89333 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2111,6 +2111,9 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah)
 		    AR_RTC_FORCE_WAKE_EN);
 	udelay(50);
 
+	if (ath9k_hw_mci_is_enabled(ah))
+		ar9003_mci_set_power_awake(ah);
+
 	for (i = POWER_UP_TIME / 50; i > 0; i--) {
 		val = REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M;
 		if (val == AR_RTC_STATUS_ON)
-- 
1.7.10.4

