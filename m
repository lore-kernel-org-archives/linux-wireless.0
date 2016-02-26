Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60825 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbcBZILK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 03:11:10 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 12/13] ath9k: use AR_SREV_9003_PCOEM to identify PCOEM chips
Date: Fri, 26 Feb 2016 16:08:42 +0800
Message-Id: <1456474123-10520-13-git-send-email-miaoqing@codeaurora.org> (sfid-20160226_091116_696408_2EC38D8F)
In-Reply-To: <1456474123-10520-1-git-send-email-miaoqing@codeaurora.org>
References: <1456474123-10520-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

commit f49c90db4d23 ("ath9k: Add a macro to identify PCOEM chips")
defined AR_SREV_9003_PCOEM macro, its more clear to use the macro
instead of checking one by one. Also removed PCOEM chips checking
in the callback of ar9003_hw_do_pcoem_manual_peak_cal() which only
for PCOEM chips.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 99bc1a6..e1573ab 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1311,9 +1311,6 @@ static void ar9003_hw_do_pcoem_manual_peak_cal(struct ath_hw *ah,
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	int i;
 
-	if (!AR_SREV_9462(ah) && !AR_SREV_9565(ah) && !AR_SREV_9485(ah))
-		return;
-
 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_RTT) && !run_rtt_cal)
 		return;
 
@@ -1707,7 +1704,7 @@ void ar9003_hw_attach_calib_ops(struct ath_hw *ah)
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
-	if (AR_SREV_9485(ah) || AR_SREV_9462(ah) || AR_SREV_9565(ah))
+	if (AR_SREV_9003_PCOEM(ah))
 		priv_ops->init_cal = ar9003_hw_init_cal_pcoem;
 	else
 		priv_ops->init_cal = ar9003_hw_init_cal_soc;
-- 
1.9.1

