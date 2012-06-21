Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37084 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab2FUPDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 11:03:13 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k_hw: fix smatch warning in ar9003_hw_spur_mitigate_mrc_cck
Date: Thu, 21 Jun 2012 20:34:00 +0530
Message-ID: <1340291040-20349-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120621_170316_716389_58C293C7)
In-Reply-To: <1340291040-20349-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1340291040-20349-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath/ath9k/ar9003_phy.c:211
ar9003_hw_spur_mitigate_mrc_cck() error: potential NULL dereference
'spur_fbin_ptr'.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index f1975b9..6b91ebb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -173,7 +173,7 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 	int cur_bb_spur, negative = 0, cck_spur_freq;
 	int i;
 	int range, max_spur_cnts, synth_freq;
-	u8 *spur_fbin_ptr = NULL;
+	u8 *spur_fbin_ptr = ar9003_get_spur_chan_ptr(ah, IS_CHAN_2GHZ(chan));
 
 	/*
 	 * Need to verify range +/- 10 MHz in control channel, otherwise spur
@@ -181,8 +181,6 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 	 */
 
 	if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah)) {
-		spur_fbin_ptr = ar9003_get_spur_chan_ptr(ah,
-							 IS_CHAN_2GHZ(chan));
 		if (spur_fbin_ptr[0] == 0) /* No spur */
 			return;
 		max_spur_cnts = 5;
-- 
1.7.11

