Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:33801 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbbBPFRY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 00:17:24 -0500
Received: from [117.222.159.239] (port=14037 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YNE3f-000EUz-OK
	for linux-wireless@vger.kernel.org; Mon, 16 Feb 2015 00:17:24 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 6/9] ath9k: Setup MCI statistics properly
Date: Mon, 16 Feb 2015 10:49:58 +0530
Message-Id: <1424064001-7009-7-git-send-email-sujith@msujith.org> (sfid-20150216_061729_148947_4EBE5A93)
In-Reply-To: <1424064001-7009-1-git-send-email-sujith@msujith.org>
References: <1424064001-7009-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Use a subroutine to enable MCI debug statistics
if it is present in the global configuration.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 23 ++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/reg_mci.h    |  5 +++++
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index aca9015..de65ce1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -821,6 +821,25 @@ static void ar9003_mci_osla_setup(struct ath_hw *ah, bool enable)
 		      AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN, 1);
 }
 
+static void ar9003_mci_stat_setup(struct ath_hw *ah)
+{
+	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
+
+	if (!AR_SREV_9565(ah))
+		return;
+
+	if (mci->config & ATH_MCI_CONFIG_MCI_STAT_DBG) {
+		REG_RMW_FIELD(ah, AR_MCI_DBG_CNT_CTRL,
+			      AR_MCI_DBG_CNT_CTRL_ENABLE, 1);
+		REG_RMW_FIELD(ah, AR_MCI_DBG_CNT_CTRL,
+			      AR_MCI_DBG_CNT_CTRL_BT_LINKID,
+			      MCI_STAT_ALL_BT_LINKID);
+	} else {
+		REG_RMW_FIELD(ah, AR_MCI_DBG_CNT_CTRL,
+			      AR_MCI_DBG_CNT_CTRL_ENABLE, 0);
+	}
+}
+
 static void ar9003_mci_set_btcoex_ctrl_9565_1ANT(struct ath_hw *ah)
 {
 	u32 regval;
@@ -984,10 +1003,8 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 
 	mci->ready = true;
 	ar9003_mci_prep_interface(ah);
+	ar9003_mci_stat_setup(ah);
 
-	if (AR_SREV_9565(ah))
-		REG_RMW_FIELD(ah, AR_MCI_DBG_CNT_CTRL,
-			      AR_MCI_DBG_CNT_CTRL_ENABLE, 0);
 	if (en_int)
 		ar9003_mci_enable_interrupt(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/reg_mci.h b/drivers/net/wireless/ath/ath9k/reg_mci.h
index 8d1572d..3bd7c21 100644
--- a/drivers/net/wireless/ath/ath9k/reg_mci.h
+++ b/drivers/net/wireless/ath/ath9k/reg_mci.h
@@ -265,9 +265,14 @@
 #define AR_MCI_MISC                                     0x1a74
 #define AR_MCI_MISC_HW_FIX_EN                           0x00000001
 #define AR_MCI_MISC_HW_FIX_EN_S                         0
+
 #define AR_MCI_DBG_CNT_CTRL                             0x1a78
 #define AR_MCI_DBG_CNT_CTRL_ENABLE                      0x00000001
 #define AR_MCI_DBG_CNT_CTRL_ENABLE_S                    0
+#define AR_MCI_DBG_CNT_CTRL_BT_LINKID                   0x000007f8
+#define AR_MCI_DBG_CNT_CTRL_BT_LINKID_S                 3
+
+#define MCI_STAT_ALL_BT_LINKID                          0xffff
 
 #define AR_MCI_INTERRUPT_DEFAULT (AR_MCI_INTERRUPT_SW_MSG_DONE         | \
 				  AR_MCI_INTERRUPT_RX_INVALID_HDR      | \
-- 
2.3.0

