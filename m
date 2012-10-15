Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27533 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2JOKA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 06:00:29 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 01/11] ath9k_hw: Enable OSLA hw fix for AR9565
Date: Mon, 15 Oct 2012 15:29:45 +0530
Message-ID: <1350295195-23410-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121015_120032_950368_01E3F444)
In-Reply-To: <1350295195-23410-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1350295195-23410-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 3 +++
 drivers/net/wireless/ath/ath9k/reg.h        | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 9aa8704..9fa6d22 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -799,6 +799,9 @@ static void ar9003_mci_osla_setup(struct ath_hw *ah, bool enable)
 	REG_RMW_FIELD(ah, AR_MCI_SCHD_TABLE_2,
 		      AR_MCI_SCHD_TABLE_2_MEM_BASED, 1);
 
+	if (AR_SREV_9565(ah))
+		REG_RMW_FIELD(ah, AR_MCI_MISC, AR_MCI_MISC_HW_FIX_EN, 1);
+
 	if (!(mci->config & ATH_MCI_CONFIG_DISABLE_AGGR_THRESH)) {
 		thresh = MS(mci->config, ATH_MCI_CONFIG_AGGR_THRESH);
 		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL,
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 4e6760f..c7a9ea7 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -2360,4 +2360,8 @@ enum {
 #define AR_GLB_SWREG_DISCONT_MODE         0x2002c
 #define AR_GLB_SWREG_DISCONT_EN_BT_WLAN   0x3
 
+#define AR_MCI_MISC                    0x1a74
+#define AR_MCI_MISC_HW_FIX_EN          0x00000001
+#define AR_MCI_MISC_HW_FIX_EN_S        0
+
 #endif
-- 
1.7.12.2

