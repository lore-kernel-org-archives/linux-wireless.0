Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:41992 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbbBPFR3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 00:17:29 -0500
Received: from [117.222.159.239] (port=14037 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YNE3k-000EUz-3r
	for linux-wireless@vger.kernel.org; Mon, 16 Feb 2015 00:17:28 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 9/9] ath9k: Mute BT properly
Date: Mon, 16 Feb 2015 10:50:01 +0530
Message-Id: <1424064001-7009-10-git-send-email-sujith@msujith.org> (sfid-20150216_061733_990007_70AB07B0)
In-Reply-To: <1424064001-7009-1-git-send-email-sujith@msujith.org>
References: <1424064001-7009-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Set The BT/WLAN priority weights correctly and make sure
that MCI_LNA_TAKE is sent only for cards that share
PA/LNA.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 13 ++++++++++---
 drivers/net/wireless/ath/ath9k/reg_mci.h    |  5 +++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 133b867..bd169fa 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -771,8 +771,14 @@ exit:
 
 static void ar9003_mci_mute_bt(struct ath_hw *ah)
 {
+	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+
 	/* disable all MCI messages */
 	REG_WRITE(ah, AR_MCI_MSG_ATTRIBUTES_TABLE, 0xffff0000);
+	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS0, 0xffffffff);
+	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS1, 0xffffffff);
+	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS2, 0xffffffff);
+	REG_WRITE(ah, AR_BTCOEX_WL_WEIGHTS3, 0xffffffff);
 	REG_SET_BIT(ah, AR_MCI_TX_CTRL, AR_MCI_TX_CTRL_DISABLE_LNA_UPDATE);
 
 	/* wait pending HW messages to flush out */
@@ -783,9 +789,10 @@ static void ar9003_mci_mute_bt(struct ath_hw *ah)
 	 * 1. reset not after resuming from full sleep
 	 * 2. before reset MCI RX, to quiet BT and avoid MCI RX misalignment
 	 */
-	ar9003_mci_send_lna_take(ah, true);
-
-	udelay(5);
+	if (MCI_ANT_ARCH_PA_LNA_SHARED(mci)) {
+		ar9003_mci_send_lna_take(ah, true);
+		udelay(5);
+	}
 
 	ar9003_mci_send_sys_sleeping(ah, true);
 }
diff --git a/drivers/net/wireless/ath/ath9k/reg_mci.h b/drivers/net/wireless/ath/ath9k/reg_mci.h
index 3bd7c21..6251310 100644
--- a/drivers/net/wireless/ath/ath9k/reg_mci.h
+++ b/drivers/net/wireless/ath/ath9k/reg_mci.h
@@ -212,6 +212,11 @@
 #define AR_BTCOEX_CTRL_SPDT_POLARITY                    0x80000000
 #define AR_BTCOEX_CTRL_SPDT_POLARITY_S                  31
 
+#define AR_BTCOEX_WL_WEIGHTS0                           0x18b0
+#define AR_BTCOEX_WL_WEIGHTS1                           0x18b4
+#define AR_BTCOEX_WL_WEIGHTS2                           0x18b8
+#define AR_BTCOEX_WL_WEIGHTS3                           0x18bc
+
 #define AR_BTCOEX_MAX_TXPWR(_x)                         (0x18c0 + ((_x) << 2))
 #define AR_BTCOEX_WL_LNA                                0x1940
 #define AR_BTCOEX_RFGAIN_CTRL                           0x1944
-- 
2.3.0

