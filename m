Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:54875 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2JYLrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 07:47:07 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/4] ath9k_hw: Fix concurrent tx on lower tx power
Date: Thu, 25 Oct 2012 17:16:52 +0530
Message-ID: <1351165614-12691-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121025_134712_365163_BD714488)
In-Reply-To: <1351165614-12691-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1351165614-12691-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever WLAN receives scheduling msg from BT, it reduces tx power
based on RSSI level. And then BT starts simultaneous transmission
along with WLAN. Sometimes HW MAC compares tx power that is used
prior to power reduction which is causing BT transmission to defer.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 5 ++++-
 drivers/net/wireless/ath/ath9k/reg.h        | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index b04fa46..42b4412 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -881,9 +881,12 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 	REG_RMW_FIELD(ah, AR_BTCOEX_CTRL3,
 		      AR_BTCOEX_CTRL3_CONT_INFO_TIMEOUT, 20);
 
-	REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2, AR_BTCOEX_CTRL2_RX_DEWEIGHT, 1);
+	REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2, AR_BTCOEX_CTRL2_RX_DEWEIGHT, 0);
 	REG_RMW_FIELD(ah, AR_PCU_MISC, AR_PCU_BT_ANT_PREVENT_RX, 0);
 
+	/* Set the time out to 3.125ms (5 BT slots) */
+	REG_RMW_FIELD(ah, AR_BTCOEX_WL_LNA, AR_BTCOEX_WL_LNA_TIMEOUT, 0x3D090);
+
 	/* concurrent tx priority */
 	if (mci->config & ATH_MCI_CONFIG_CONCUR_TX) {
 		REG_RMW_FIELD(ah, AR_BTCOEX_CTRL2,
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index e9dec13..ad3c82c 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -2311,6 +2311,8 @@ enum {
 #define AR_BTCOEX_MAX_TXPWR(_x)				(0x18c0 + ((_x) << 2))
 #define AR_BTCOEX_WL_LNA				0x1940
 #define AR_BTCOEX_RFGAIN_CTRL				0x1944
+#define AR_BTCOEX_WL_LNA_TIMEOUT			0x003FFFFF
+#define AR_BTCOEX_WL_LNA_TIMEOUT_S			0
 
 #define AR_BTCOEX_CTRL2					0x1948
 #define AR_BTCOEX_CTRL2_TXPWR_THRESH			0x0007F800
-- 
1.8.0

