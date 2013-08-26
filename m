Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:36884 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3HZGVK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 02:21:10 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix TX poll work locking
Date: Mon, 26 Aug 2013 11:47:22 +0530
Message-Id: <1377497842-14742-1-git-send-email-sujith@msujith.org> (sfid-20130826_082114_179434_EAAFC4E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

There is no need to call ath_txq_unlock_complete() in the
TX poll routine - frame completion is not done here,
so use ath_txq_unlock().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index fff5d3c..2f831db 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -41,7 +41,7 @@ void ath_tx_complete_poll_work(struct work_struct *work)
 				txq->axq_tx_inprogress = true;
 			}
 		}
-		ath_txq_unlock_complete(sc, txq);
+		ath_txq_unlock(sc, txq);
 	}
 
 	if (needreset) {
-- 
1.8.3.4

