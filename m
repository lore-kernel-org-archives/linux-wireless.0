Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52433 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253AbbKSCCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 21:02:54 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/4] staging: wilc1000: rename index to tcp_pending_ack_idx
Date: Thu, 19 Nov 2015 11:06:00 +0900
Message-ID: <1447898761-6938-3-git-send-email-glen.lee@atmel.com> (sfid-20151119_030257_225757_797D006A)
In-Reply-To: <1447898761-6938-1-git-send-email-glen.lee@atmel.com>
References: <1447898761-6938-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames "index" of struct txq_entry_t to tcp_pending_ack_idx since
this name could be confused index of txq_entry_t. It is index of tcp pending
ack.

It fixes 8e55639d066f4ef402ba88fca08ed1be70e1c4da

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 12 ++++++------
 drivers/staging/wilc1000/wilc_wlan.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 10def3f..27a44ee 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -249,7 +249,7 @@ static inline int add_tcp_pending_ack(u32 ack, u32 session_index,
 		pending_acks_info[pending_base + pending_acks].ack_num = ack;
 		pending_acks_info[pending_base + pending_acks].txqe = txqe;
 		pending_acks_info[pending_base + pending_acks].session_index = session_index;
-		txqe->index = pending_base + pending_acks;
+		txqe->tcp_pending_ack_idx = pending_base + pending_acks;
 		pending_acks++;
 	}
 	return 0;
@@ -421,7 +421,7 @@ static int wilc_wlan_txq_add_cfg_pkt(struct wilc *wilc, u8 *buffer, u32 buffer_s
 	tqe->tx_complete_func = NULL;
 	tqe->priv = NULL;
 #ifdef TCP_ACK_FILTER
-	tqe->index = NOT_TCP_ACK;
+	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
 #endif
 	PRINT_D(TX_DBG, "Adding the config packet at the Queue tail\n");
 
@@ -451,7 +451,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 
 	PRINT_D(TX_DBG, "Adding mgmt packet at the Queue tail\n");
 #ifdef TCP_ACK_FILTER
-	tqe->index = NOT_TCP_ACK;
+	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
 	if (is_tcp_ack_filter_enabled())
 		tcp_process(dev, tqe);
 #endif
@@ -478,7 +478,7 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	tqe->tx_complete_func = func;
 	tqe->priv = priv;
 #ifdef TCP_ACK_FILTER
-	tqe->index = NOT_TCP_ACK;
+	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
 #endif
 	PRINT_D(TX_DBG, "Adding Network packet at the Queue tail\n");
 	wilc_wlan_txq_add_to_tail(dev, tqe);
@@ -923,8 +923,8 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 					tqe->tx_complete_func(tqe->priv,
 							      tqe->status);
 				#ifdef TCP_ACK_FILTER
-				if (tqe->index != NOT_TCP_ACK)
-					pending_acks_info[tqe->index].txqe = NULL;
+				if (tqe->tcp_pending_ack_idx != NOT_TCP_ACK)
+					pending_acks_info[tqe->tcp_pending_ack_idx].txqe = NULL;
 				#endif
 				kfree(tqe);
 			} else {
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 2ac63a3..27c7bbb 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -216,7 +216,7 @@ struct txq_entry_t {
 	struct txq_entry_t *next;
 	struct txq_entry_t *prev;
 	int type;
-	int index;
+	int tcp_pending_ack_idx;
 	u8 *buffer;
 	int buffer_size;
 	void *priv;
-- 
1.9.1

