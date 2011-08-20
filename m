Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11882 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab1HTLvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Aug 2011 07:51:47 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH 1/2] ath9k_hw: Fix descriptor status of TxOpExceeded
Date: Sat, 20 Aug 2011 17:22:09 +0530
Message-ID: <1313841130-7787-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110820_135200_077676_CE4C5B1B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 81ccce1..8ace36e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -253,8 +253,6 @@ static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 		return -EIO;
 	}
 
-	if (status & AR_TxOpExceeded)
-		ts->ts_status |= ATH9K_TXERR_XTXOP;
 	ts->ts_rateindex = MS(status, AR_FinalTxIdx);
 	ts->ts_seqnum = MS(status, AR_SeqNum);
 	ts->tid = MS(status, AR_TxTid);
@@ -264,6 +262,8 @@ static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	ts->ts_status = 0;
 	ts->ts_flags  = 0;
 
+	if (status & AR_TxOpExceeded)
+		ts->ts_status |= ATH9K_TXERR_XTXOP;
 	status = ACCESS_ONCE(ads->status2);
 	ts->ts_rssi_ctl0 = MS(status, AR_TxRSSIAnt00);
 	ts->ts_rssi_ctl1 = MS(status, AR_TxRSSIAnt01);
-- 
1.7.6

