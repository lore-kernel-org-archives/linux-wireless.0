Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44875 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2FRNb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 09:31:29 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/4] ath9k_hw: fix BT mute at hw init
Date: Mon, 18 Jun 2012 19:02:37 +0530
Message-ID: <1340026360-18873-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120618_153133_988410_A88EC173)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WLAN driver initialization is muting BT which is terminating
the ongoing BT traffic. The reason to mute BT is to avoid any
incoming MCI messages from BT when MCI reset is in progress that
could corrupt WLAN MCI RX state machine. But we should not
dedicate radio completely to WLAN in driver init itself. So this
patch removes the wlan weightage changes from mute BT to retain
BT connection.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |    4 ----
 drivers/net/wireless/ath/ath9k/reg.h        |    4 ----
 2 files changed, 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index cc2853a..867238f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -767,10 +767,6 @@ static void ar9003_mci_mute_bt(struct ath_hw *ah)
 {
 	/* disable all MCI messages */
 	REG_WRITE(ah, AR_MCI_MSG_ATTRIBUTES_TABLE, 0xffff0000);
-	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS0, 0xffffffff);
-	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS1, 0xffffffff);
-	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS2, 0xffffffff);
-	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS3, 0xffffffff);
 	REG_SET_BIT(ah, AR_MCI_TX_CTRL, AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
 
 	/* wait pending HW messages to flush out */
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 75acefb..5046b28 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -2162,10 +2162,6 @@ enum {
 #define AR_BTCOEX_CTRL_SPDT_POLARITY			0x80000000
 #define AR_BTCOEX_CTRL_SPDT_POLARITY_S			31
 
-#define AR_BTCOEX_WL_WEIGHTS0				0x18b0
-#define AR_BTCOEX_WL_WEIGHTS1				0x18b4
-#define AR_BTCOEX_WL_WEIGHTS2				0x18b8
-#define AR_BTCOEX_WL_WEIGHTS3				0x18bc
 #define AR_BTCOEX_MAX_TXPWR(_x)				(0x18c0 + ((_x) << 2))
 #define AR_BTCOEX_WL_LNA				0x1940
 #define AR_BTCOEX_RFGAIN_CTRL				0x1944
-- 
1.7.10.4

