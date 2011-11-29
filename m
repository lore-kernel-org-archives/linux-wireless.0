Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7576 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab1K2O5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 09:57:50 -0500
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	Russell Hu <rhu@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Wilson Tsao <wtsao@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 13/17] ath9k_hw: MCI related changes in set_reset_reg
Date: Tue, 29 Nov 2011 20:25:34 +0530
Message-ID: <1322578538-18912-14-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111129_155754_261667_4F767EFA)
In-Reply-To: <1322578538-18912-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1322578538-18912-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ba5734a..1d71d1b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1350,6 +1350,7 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 {
+	bool ret = false;
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		REG_WRITE(ah, AR_WA, ah->WARegVal);
@@ -1361,13 +1362,20 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 
 	switch (type) {
 	case ATH9K_RESET_POWER_ON:
-		return ath9k_hw_set_reset_power_on(ah);
+		ret = ath9k_hw_set_reset_power_on(ah);
+		break;
 	case ATH9K_RESET_WARM:
 	case ATH9K_RESET_COLD:
-		return ath9k_hw_set_reset(ah, type);
+		ret = ath9k_hw_set_reset(ah, type);
+		break;
 	default:
-		return false;
+		break;
 	}
+
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
+		REG_WRITE(ah, AR_RTC_KEEP_AWAKE, 0x2);
+
+	return ret;
 }
 
 static bool ath9k_hw_chip_reset(struct ath_hw *ah,
-- 
1.7.0.4

