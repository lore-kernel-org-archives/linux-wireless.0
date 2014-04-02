Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:59988 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaDBEAX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 00:00:23 -0400
Received: by mail-pd0-f175.google.com with SMTP id x10so10422072pdj.6
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 21:00:22 -0700 (PDT)
From: Fariya Fatima <fariyaf@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH 5/6] rsi: Fixed issue relating to index of q_num.
Date: Wed,  2 Apr 2014 09:29:54 +0530
Message-Id: <1396411195-5051-6-git-send-email-fariyaf@gmail.com> (sfid-20140402_060033_752397_01D1DA78)
In-Reply-To: <1396411195-5051-1-git-send-email-fariyaf@gmail.com>
References: <1396411195-5051-1-git-send-email-fariyaf@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima <fariyaf@gmail.com>

Signed-off-by: Fariya Fatima <fariyaf@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index e89535e..1a8d321 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -102,10 +102,10 @@ static u8 rsi_core_determine_hal_queue(struct rsi_common *common)
 	}
 
 get_queue_num:
-	q_num = 0;
 	recontend_queue = false;
 
 	q_num = rsi_determine_min_weight_queue(common);
+
 	q_len = skb_queue_len(&common->tx_queue[ii]);
 	ii = q_num;
 
@@ -118,7 +118,9 @@ get_queue_num:
 		}
 	}
 
-	common->tx_qinfo[q_num].pkt_contended = 0;
+	if (q_num < NUM_EDCA_QUEUES)
+		common->tx_qinfo[q_num].pkt_contended = 0;
+
 	/* Adjust the back off values for all queues again */
 	recontend_queue = rsi_recalculate_weights(common);
 
-- 
1.7.5.4

