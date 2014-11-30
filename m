Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:41501
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751650AbaK3UxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2014 15:53:03 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath5k: fix hardware queue index assignment
Date: Sun, 30 Nov 2014 21:52:57 +0100
Message-Id: <1417380777-25796-1-git-send-email-nbd@openwrt.org> (sfid-20141130_215307_864315_0AA58115)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Like with ath9k, ath5k queues also need to be ordered by priority.
queue_info->tqi_subtype already contains the correct index, so use it
instead of relying on the order of ath5k_hw_setup_tx_queue calls.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/qcu.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 0583c69..ddaad71 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -225,13 +225,7 @@ ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 	} else {
 		switch (queue_type) {
 		case AR5K_TX_QUEUE_DATA:
-			for (queue = AR5K_TX_QUEUE_ID_DATA_MIN;
-				ah->ah_txq[queue].tqi_type !=
-				AR5K_TX_QUEUE_INACTIVE; queue++) {
-
-				if (queue > AR5K_TX_QUEUE_ID_DATA_MAX)
-					return -EINVAL;
-			}
+			queue = queue_info->tqi_subtype;
 			break;
 		case AR5K_TX_QUEUE_UAPSD:
 			queue = AR5K_TX_QUEUE_ID_UAPSD;
-- 
2.1.2

