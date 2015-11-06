Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37602 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031044AbbKFCRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:17:16 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 52/73] staging: wilc1000: rename tcp_PendingAck_index of struct txq_entry_t
Date: Fri, 6 Nov 2015 11:19:51 +0900
Message-ID: <1446776412-30670-3-git-send-email-glen.lee@atmel.com> (sfid-20151106_031719_186708_5A7D4C69)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames tcp_PendingAck_index of struct txq_entry_t to index
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 12 ++++++------
 drivers/staging/wilc1000/wilc_wlan.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 68158c9..679ae7e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -251,7 +251,7 @@ static inline int add_tcp_pending_ack(u32 ack, u32 session_index,
 		pending_acks_info[pending_base + pending_acks].ack_num = ack;
 		pending_acks_info[pending_base + pending_acks].txqe = txqe;
 		pending_acks_info[pending_base + pending_acks].session_index = session_index;
-		txqe->tcp_PendingAck_index = pending_base + pending_acks;
+		txqe->index = pending_base + pending_acks;
 		pending_acks++;
 	}
 	return 0;
@@ -422,7 +422,7 @@ static int wilc_wlan_txq_add_cfg_pkt(u8 *buffer, u32 buffer_size)
 	tqe->tx_complete_func = NULL;
 	tqe->priv = NULL;
 #ifdef TCP_ACK_FILTER
-	tqe->tcp_PendingAck_index = NOT_TCP_ACK;
+	tqe->index = NOT_TCP_ACK;
 #endif
 	PRINT_D(TX_DBG, "Adding the config packet at the Queue tail\n");
 
@@ -452,7 +452,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 
 	PRINT_D(TX_DBG, "Adding mgmt packet at the Queue tail\n");
 #ifdef TCP_ACK_FILTER
-	tqe->tcp_PendingAck_index = NOT_TCP_ACK;
+	tqe->index = NOT_TCP_ACK;
 	if (is_tcp_ack_filter_enabled())
 		tcp_process(dev, tqe);
 #endif
@@ -479,7 +479,7 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	tqe->tx_complete_func = func;
 	tqe->priv = priv;
 #ifdef TCP_ACK_FILTER
-	tqe->tcp_PendingAck_index = NOT_TCP_ACK;
+	tqe->index = NOT_TCP_ACK;
 #endif
 	PRINT_D(TX_DBG, "Adding Network packet at the Queue tail\n");
 	wilc_wlan_txq_add_to_tail(dev, tqe);
@@ -911,8 +911,8 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 				if (tqe->tx_complete_func)
 					tqe->tx_complete_func(tqe->priv, tqe->status);
 				#ifdef TCP_ACK_FILTER
-				if (tqe->tcp_PendingAck_index != NOT_TCP_ACK)
-					pending_acks_info[tqe->tcp_PendingAck_index].txqe = NULL;
+				if (tqe->index != NOT_TCP_ACK)
+					pending_acks_info[tqe->index].txqe = NULL;
 				#endif
 				kfree(tqe);
 			} else {
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 55e4f19..ff852b4 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -231,7 +231,7 @@ struct txq_entry_t {
 	struct txq_entry_t *next;
 	struct txq_entry_t *prev;
 	int type;
-	int tcp_PendingAck_index;
+	int index;
 	u8 *buffer;
 	int buffer_size;
 	void *priv;
-- 
1.9.1

