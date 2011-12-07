Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7751 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab1LGLXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 06:23:31 -0500
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] ath9k_hw: remove ATH9K_HW_CAP_CST
Date: Wed, 7 Dec 2011 16:51:39 +0530
Message-ID: <1323256899-16453-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111207_122337_099573_C38EB3CB)
In-Reply-To: <1323256899-16453-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1323256899-16453-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

its not used anywhere in the current code

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    6 ++----
 drivers/net/wireless/ath/ath9k/hw.h |   29 ++++++++++++++---------------
 2 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index caf572c..cdde849 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2371,12 +2371,10 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	else
 		pCap->num_gpio_pins = AR_NUM_GPIO;
 
-	if (AR_SREV_9160_10_OR_LATER(ah) || AR_SREV_9100(ah)) {
-		pCap->hw_caps |= ATH9K_HW_CAP_CST;
+	if (AR_SREV_9160_10_OR_LATER(ah) || AR_SREV_9100(ah))
 		pCap->rts_aggr_limit = ATH_AMPDU_LIMIT_MAX;
-	} else {
+	else
 		pCap->rts_aggr_limit = (8 * 1024);
-	}
 
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	ah->rfsilent = ah->eep_ops->get_eeprom(ah, EEP_RF_SILENT);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 36968c0..2aecaf6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -196,21 +196,20 @@ enum ath_ini_subsys {
 enum ath9k_hw_caps {
 	ATH9K_HW_CAP_HT                         = BIT(0),
 	ATH9K_HW_CAP_RFSILENT                   = BIT(1),
-	ATH9K_HW_CAP_CST                        = BIT(2),
-	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(4),
-	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(5),
-	ATH9K_HW_CAP_EDMA			= BIT(6),
-	ATH9K_HW_CAP_RAC_SUPPORTED		= BIT(7),
-	ATH9K_HW_CAP_LDPC			= BIT(8),
-	ATH9K_HW_CAP_FASTCLOCK			= BIT(9),
-	ATH9K_HW_CAP_SGI_20			= BIT(10),
-	ATH9K_HW_CAP_PAPRD			= BIT(11),
-	ATH9K_HW_CAP_ANT_DIV_COMB		= BIT(12),
-	ATH9K_HW_CAP_2GHZ			= BIT(13),
-	ATH9K_HW_CAP_5GHZ			= BIT(14),
-	ATH9K_HW_CAP_APM			= BIT(15),
-	ATH9K_HW_CAP_RTT			= BIT(16),
-	ATH9K_HW_CAP_MCI			= BIT(17),
+	ATH9K_HW_CAP_AUTOSLEEP                  = BIT(2),
+	ATH9K_HW_CAP_4KB_SPLITTRANS             = BIT(3),
+	ATH9K_HW_CAP_EDMA			= BIT(4),
+	ATH9K_HW_CAP_RAC_SUPPORTED		= BIT(5),
+	ATH9K_HW_CAP_LDPC			= BIT(6),
+	ATH9K_HW_CAP_FASTCLOCK			= BIT(7),
+	ATH9K_HW_CAP_SGI_20			= BIT(8),
+	ATH9K_HW_CAP_PAPRD			= BIT(9),
+	ATH9K_HW_CAP_ANT_DIV_COMB		= BIT(10),
+	ATH9K_HW_CAP_2GHZ			= BIT(11),
+	ATH9K_HW_CAP_5GHZ			= BIT(12),
+	ATH9K_HW_CAP_APM			= BIT(13),
+	ATH9K_HW_CAP_RTT			= BIT(14),
+	ATH9K_HW_CAP_MCI			= BIT(15),
 };
 
 struct ath9k_hw_capabilities {
-- 
1.7.0.4

