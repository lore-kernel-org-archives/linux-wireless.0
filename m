Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32091 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1K3Pbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 10:31:41 -0500
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
Subject: [PATCH v2] ath9k_hw: Fix TX IQ calibration for AR9003
Date: Wed, 30 Nov 2011 21:01:31 +0530
Message-ID: <1322667091-1123-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111130_163144_568897_0DB2C0DF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

only for AR9485 (or) later chipsets TxIQ calibration
runs as part of AGC calibration. without this patch
TX IQ cal completion i.e. ar9003_hw_tx_iq_cal_run won't be executed
for AR9003

Reviewed-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8876134..2de52d2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2332,7 +2332,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		ah->enabled_cals |= TX_IQ_CAL;
-		if (!AR_SREV_9330(ah))
+		if (AR_SREV_9485_OR_LATER(ah))
 			ah->enabled_cals |= TX_IQ_ON_AGC_CAL;
 	}
 	if (AR_SREV_9462(ah))
-- 
1.7.0.4

