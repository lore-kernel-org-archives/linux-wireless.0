Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59136 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab1JCL4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 07:56:33 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] ath6kl: Fix htc_packet leak in ath6kl_htc_rx_fetch()
Date: Mon, 3 Oct 2011 17:26:25 +0530
Message-ID: <1317642987-16026-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111003_135636_090333_870EA6DE)
In-Reply-To: <1317642987-16026-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1317642987-16026-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is found during the code review. As the leak would happen only
in failure case, the imapct is not easily visible.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

V2 -- Change in commit log

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 7bc9884..4a03dac 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -1715,12 +1715,10 @@ static int ath6kl_htc_rx_fetch(struct htc_target *target,
 			packet = list_first_entry(rx_pktq, struct htc_packet,
 						   list);
 
-			list_del(&packet->list);
-
 			/* fully synchronous */
 			packet->completion = NULL;
 
-			if (!list_empty(rx_pktq))
+			if (!list_is_singular(rx_pktq))
 				/*
 				 * look_aheads in all packet
 				 * except the last one in the
@@ -1735,7 +1733,7 @@ static int ath6kl_htc_rx_fetch(struct htc_target *target,
 			if (status)
 				return status;
 
-			list_add_tail(&packet->list, comp_pktq);
+			list_move_tail(&packet->list, comp_pktq);
 		}
 	}
 
-- 
1.7.0.4

