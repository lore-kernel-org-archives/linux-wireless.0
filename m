Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:37023
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751650AbaK3Tiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2014 14:38:54 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, h.feurstein@gmail.com, sujith@msujith.org,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 1/2] ath9k_hw: fix hardware queue allocation
Date: Sun, 30 Nov 2014 20:38:40 +0100
Message-Id: <1417376321-1906-1-git-send-email-nbd@openwrt.org> (sfid-20141130_203920_776685_B19BD51F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver passes the desired hardware queue index for a WMM data queue
in qinfo->tqi_subtype. This was ignored in ath9k_hw_setuptxqueue, which
instead relied on the order in which the function is called.

Cc: stable@vger.kernel.org
Reported-by: Hubert Feurstein <h.feurstein@gmail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/mac.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 275205a..3e58bfa 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -311,14 +311,7 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 		q = ATH9K_NUM_TX_QUEUES - 3;
 		break;
 	case ATH9K_TX_QUEUE_DATA:
-		for (q = 0; q < ATH9K_NUM_TX_QUEUES; q++)
-			if (ah->txq[q].tqi_type ==
-			    ATH9K_TX_QUEUE_INACTIVE)
-				break;
-		if (q == ATH9K_NUM_TX_QUEUES) {
-			ath_err(common, "No available TX queue\n");
-			return -1;
-		}
+		q = qinfo->tqi_subtype;
 		break;
 	default:
 		ath_err(common, "Invalid TX queue type: %u\n", type);
-- 
2.1.2

