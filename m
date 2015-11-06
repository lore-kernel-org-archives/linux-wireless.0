Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36753 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:12:22 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 19/73] staging: wilc1000: rename Pending_Acks_info variable
Date: Fri, 6 Nov 2015 11:12:40 +0900
Message-ID: <1446776014-28094-19-git-send-email-glen.lee@atmel.com> (sfid-20151106_033801_292272_92389D89)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the Pending_Acks_info variable to pending_acks_info
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 359df26..7db42c0 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -216,7 +216,7 @@ struct ack_session_info *Alloc_head;
 #define MAX_TCP_SESSION		25
 #define MAX_PENDING_ACKS		256
 struct ack_session_info ack_session_info[2 * MAX_TCP_SESSION];
-struct pending_acks_info Pending_Acks_info[MAX_PENDING_ACKS];
+struct pending_acks_info pending_acks_info[MAX_PENDING_ACKS];
 
 u32 PendingAcks_arrBase;
 u32 Opened_TCP_session;
@@ -250,9 +250,9 @@ static inline int add_TCP_Pending_Ack(u32 Ack, u32 Session_index, struct txq_ent
 {
 	total_acks++;
 	if (Pending_Acks < MAX_PENDING_ACKS) {
-		Pending_Acks_info[PendingAcks_arrBase + Pending_Acks].ack_num = Ack;
-		Pending_Acks_info[PendingAcks_arrBase + Pending_Acks].txqe = txqe;
-		Pending_Acks_info[PendingAcks_arrBase + Pending_Acks].session_index = Session_index;
+		pending_acks_info[PendingAcks_arrBase + Pending_Acks].ack_num = Ack;
+		pending_acks_info[PendingAcks_arrBase + Pending_Acks].txqe = txqe;
+		pending_acks_info[PendingAcks_arrBase + Pending_Acks].session_index = Session_index;
 		txqe->tcp_PendingAck_index = PendingAcks_arrBase + Pending_Acks;
 		Pending_Acks++;
 	} else {
@@ -347,11 +347,12 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 
 	spin_lock_irqsave(&wilc->txq_spinlock, p->txq_spinlock_flags);
 	for (i = PendingAcks_arrBase; i < (PendingAcks_arrBase + Pending_Acks); i++) {
-		if (Pending_Acks_info[i].ack_num < ack_session_info[Pending_Acks_info[i].session_index].bigger_ack_num) {
+		if (pending_acks_info[i].ack_num < ack_session_info[pending_acks_info[i].session_index].bigger_ack_num) {
 			struct txq_entry_t *tqe;
 
-			PRINT_D(TCP_ENH, "DROP ACK: %u\n", Pending_Acks_info[i].ack_num);
-			tqe = Pending_Acks_info[i].txqe;
+			PRINT_D(TCP_ENH, "DROP ACK: %u\n",
+				pending_acks_info[i].ack_num);
+			tqe = pending_acks_info[i].txqe;
 			if (tqe) {
 				wilc_wlan_txq_remove(tqe);
 				dropped_acks++;
@@ -910,7 +911,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 					tqe->tx_complete_func(tqe->priv, tqe->status);
 				#ifdef TCP_ACK_FILTER
 				if (tqe->tcp_PendingAck_index != NOT_TCP_ACK)
-					Pending_Acks_info[tqe->tcp_PendingAck_index].txqe = NULL;
+					pending_acks_info[tqe->tcp_PendingAck_index].txqe = NULL;
 				#endif
 				kfree(tqe);
 			} else {
-- 
1.9.1

