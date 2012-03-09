Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31808 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2CIGcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 01:32:05 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: Fix enabling of MCI and RTT
Date: Fri, 9 Mar 2012 12:01:55 +0530
Message-ID: <1331274715-9035-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120309_073235_074941_EDAE117F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

tested in AR9462 Rev:2, both hardware capability flag are set

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   13 +++++++++++--
 drivers/net/wireless/ath/ath9k/reg.h |    1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d582cf7..02cc1ce 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2390,8 +2390,17 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		if (AR_SREV_9485_OR_LATER(ah))
 			ah->enabled_cals |= TX_IQ_ON_AGC_CAL;
 	}
-	if (AR_SREV_9462(ah))
-		pCap->hw_caps |= ATH9K_HW_CAP_RTT | ATH9K_HW_CAP_MCI;
+
+	if (AR_SREV_9462(ah)) {
+
+		if (!(ah->ent_mode & AR_ENT_OTP_49GHZ_DISABLE))
+			pCap->hw_caps |= ATH9K_HW_CAP_MCI;
+
+		if (AR_SREV_9462_20(ah))
+			pCap->hw_caps |= ATH9K_HW_CAP_RTT;
+
+	}
+
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 80b1856..458f81b 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1151,6 +1151,7 @@ enum {
 #define AR_INTR_PRIO_ASYNC_ENABLE (AR_SREV_9340(ah) ? 0x4094 : 0x40d4)
 #define AR_ENT_OTP		  0x40d8
 #define AR_ENT_OTP_CHAIN2_DISABLE               0x00020000
+#define AR_ENT_OTP_49GHZ_DISABLE		0x00100000
 #define AR_ENT_OTP_MIN_PKT_SIZE_DISABLE		0x00800000
 
 #define AR_CH0_BB_DPLL1		 0x16180
-- 
1.7.0.4

