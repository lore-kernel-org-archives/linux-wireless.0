Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56719 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1HME61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 00:58:27 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 05/11] ath9k: qinfo never be NULL in setuptxqueue
Date: Sat, 13 Aug 2011 10:28:12 +0530
Message-ID: <1313211498-14442-5-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110813_065829_044326_1FD3B049)
In-Reply-To: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mac.c |   17 ++---------------
 1 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 7ddca67..7ce9b32 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -345,21 +345,8 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 	}
 	memset(qi, 0, sizeof(struct ath9k_tx_queue_info));
 	qi->tqi_type = type;
-	if (qinfo == NULL) {
-		qi->tqi_qflags =
-			TXQ_FLAG_TXOKINT_ENABLE
-			| TXQ_FLAG_TXERRINT_ENABLE
-			| TXQ_FLAG_TXDESCINT_ENABLE | TXQ_FLAG_TXURNINT_ENABLE;
-		qi->tqi_aifs = INIT_AIFS;
-		qi->tqi_cwmin = ATH9K_TXQ_USEDEFAULT;
-		qi->tqi_cwmax = INIT_CWMAX;
-		qi->tqi_shretry = INIT_SH_RETRY;
-		qi->tqi_lgretry = INIT_LG_RETRY;
-		qi->tqi_physCompBuf = 0;
-	} else {
-		qi->tqi_physCompBuf = qinfo->tqi_physCompBuf;
-		(void) ath9k_hw_set_txq_props(ah, q, qinfo);
-	}
+	qi->tqi_physCompBuf = qinfo->tqi_physCompBuf;
+	(void) ath9k_hw_set_txq_props(ah, q, qinfo);
 
 	return q;
 }
-- 
1.7.6

