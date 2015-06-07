Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:47820 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbbFGN4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 09:56:37 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 1/6] wil6210: modparam for bcast ring size
Date: Sun,  7 Jun 2015 16:56:26 +0300
Message-Id: <1433685391-9026-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150607_155647_651845_38BC30CD)
In-Reply-To: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Control Bcast ring size in similar way as Rx and Tx ones,
through "bcast_ring_order" modparam, actual ring size is 1 << order

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 6d704ae..b9febab 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -100,6 +100,8 @@ module_param_cb(rx_ring_order, &ring_order_ops, &rx_ring_order, S_IRUGO);
 MODULE_PARM_DESC(rx_ring_order, " Rx ring order; size = 1 << order");
 module_param_cb(tx_ring_order, &ring_order_ops, &tx_ring_order, S_IRUGO);
 MODULE_PARM_DESC(tx_ring_order, " Tx ring order; size = 1 << order");
+module_param_cb(bcast_ring_order, &ring_order_ops, &bcast_ring_order, S_IRUGO);
+MODULE_PARM_DESC(bcast_ring_order, " Bcast ring order; size = 1 << order");
 
 #define RST_DELAY (20) /* msec, for loop in @wil_target_reset */
 #define RST_COUNT (1 + 1000/RST_DELAY) /* round up to be above 1 sec total */
-- 
2.1.4

