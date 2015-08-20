Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23011 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbbHTBWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 21:22:04 -0400
From: <miaoqing@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>,
	<kvalo@qca.qualcomm.com>, Miaoqing Pan <miaoqing@qti.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH v2 2/2] ath9k: fix incorrect calibration initial for ar9561
Date: Thu, 20 Aug 2015 09:21:39 +0800
Message-ID: <1440033699-11121-2-git-send-email-miaoqing@qca.qualcomm.com> (sfid-20150820_032207_867785_99D86FFE)
In-Reply-To: <1440033699-11121-1-git-send-email-miaoqing@qca.qualcomm.com>
References: <1440033699-11121-1-git-send-email-miaoqing@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

One stuck issue was found on AP152, the root cause is using wrong
calibration initial function.

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 174442b..3880df7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1310,7 +1310,8 @@ static void ar9003_hw_do_pcoem_manual_peak_cal(struct ath_hw *ah,
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	int i;
 
-	if (!AR_SREV_9462(ah) && !AR_SREV_9565(ah) && !AR_SREV_9485(ah))
+	if (!AR_SREV_9462(ah) && !AR_SREV_9565(ah) && !AR_SREV_9485(ah) &&
+	    !AR_SREV_9561(ah))
 		return;
 
 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_RTT) && !run_rtt_cal)
@@ -1707,7 +1708,8 @@ void ar9003_hw_attach_calib_ops(struct ath_hw *ah)
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
-	if (AR_SREV_9485(ah) || AR_SREV_9462(ah) || AR_SREV_9565(ah))
+	if (AR_SREV_9485(ah) || AR_SREV_9462(ah) || AR_SREV_9565(ah) ||
+	    AR_SREV_9561(ah))
 		priv_ops->init_cal = ar9003_hw_init_cal_pcoem;
 	else
 		priv_ops->init_cal = ar9003_hw_init_cal_soc;
-- 
1.9.1

