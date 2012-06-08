Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43851 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab2FHRiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 13:38:16 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 3/9] ath9k_hw: Fix AR9462 power consumption on idle associated
Date: Fri, 8 Jun 2012 23:09:02 +0530
Message-ID: <1339177148-21672-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120608_193819_354026_373B234F)
In-Reply-To: <1339177148-21672-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339177148-21672-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The HW statemachine is sometimes found stuck in the state
WL_LNA_CTRL_DISABLE when BT is in sleep, which will cause
TX_HOLD always asserted and resmgr stuck in PENDING_TX state

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 45e6700..db3dfc9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2086,8 +2086,9 @@ static void ath9k_set_power_network_sleep(struct ath_hw *ah)
 
 static bool ath9k_hw_set_power_awake(struct ath_hw *ah)
 {
-	u32 val;
+	u32 val, btcoex_ctrl2, diag_sw;
 	int i;
+	u8 lna_ctrl, bt_sleep;
 
 	/* Set Bits 14 and 17 of AR_WA before powering on the chip. */
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
@@ -2111,6 +2112,37 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah)
 		    AR_RTC_FORCE_WAKE_EN);
 	udelay(50);
 
+	if (!AR_SREV_9462_20(ah))
+		goto skip_btcoex;
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
+
+skip_btcoex:
 	for (i = POWER_UP_TIME / 50; i > 0; i--) {
 		val = REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M;
 		if (val == AR_RTC_STATUS_ON)
-- 
1.7.10.3

