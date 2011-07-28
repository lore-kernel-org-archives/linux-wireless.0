Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7463 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab1G1R3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 13:29:54 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 5/9] ath9k_hw: Optimize rx descriptor processing for AR9003
Date: Thu, 28 Jul 2011 22:59:32 +0530
Message-ID: <1311874176-27569-5-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110728_192957_148974_1647D478)
In-Reply-To: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1311874176-27569-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to process RxDone and ds_info status again in case
valid rx status is given.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 8ff0b88..1aadc47 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -531,17 +531,18 @@ int ath9k_hw_process_rxdesc_edma(struct ath_hw *ah, struct ath_rx_status *rxs,
 
 	/* TODO: byte swap on big endian for ar9300_10 */
 
-	if ((rxsp->status11 & AR_RxDone) == 0)
-		return -EINPROGRESS;
+	if (!rxs) {
+		if ((rxsp->status11 & AR_RxDone) == 0)
+			return -EINPROGRESS;
 
-	if (MS(rxsp->ds_info, AR_DescId) != 0x168c)
-		return -EINVAL;
+		if (MS(rxsp->ds_info, AR_DescId) != 0x168c)
+			return -EINVAL;
 
-	if ((rxsp->ds_info & (AR_TxRxDesc | AR_CtrlStat)) != 0)
-		return -EINPROGRESS;
+		if ((rxsp->ds_info & (AR_TxRxDesc | AR_CtrlStat)) != 0)
+			return -EINPROGRESS;
 
-	if (!rxs)
 		return 0;
+	}
 
 	rxs->rs_status = 0;
 	rxs->rs_flags =  0;
-- 
1.7.6

