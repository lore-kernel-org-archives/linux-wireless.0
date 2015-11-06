Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36718 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:12:10 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 17/73] staging: wilc1000: rename Session_index of struct pending_acks_info
Date: Fri, 6 Nov 2015 11:12:38 +0900
Message-ID: <1446776014-28094-17-git-send-email-glen.lee@atmel.com> (sfid-20151106_033800_387002_127DE865)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename Session_index of struct pending_acks_info to session_index
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index fb0e635..af5a16e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -204,7 +204,7 @@ struct ack_session_info {
 
 struct pending_acks_info {
 	u32 ack_num;
-	u32 Session_index;
+	u32 session_index;
 	struct txq_entry_t  *txqe;
 };
 
@@ -252,7 +252,7 @@ static inline int add_TCP_Pending_Ack(u32 Ack, u32 Session_index, struct txq_ent
 	if (Pending_Acks < MAX_PENDING_ACKS) {
 		Pending_Acks_info[PendingAcks_arrBase + Pending_Acks].ack_num = Ack;
 		Pending_Acks_info[PendingAcks_arrBase + Pending_Acks].txqe = txqe;
-		Pending_Acks_info[PendingAcks_arrBase + Pending_Acks].Session_index = Session_index;
+		Pending_Acks_info[PendingAcks_arrBase + Pending_Acks].session_index = Session_index;
 		txqe->tcp_PendingAck_index = PendingAcks_arrBase + Pending_Acks;
 		Pending_Acks++;
 	} else {
@@ -347,7 +347,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 
 	spin_lock_irqsave(&wilc->txq_spinlock, p->txq_spinlock_flags);
 	for (i = PendingAcks_arrBase; i < (PendingAcks_arrBase + Pending_Acks); i++) {
-		if (Pending_Acks_info[i].ack_num < Acks_keep_track_info[Pending_Acks_info[i].Session_index].bigger_ack_num) {
+		if (Pending_Acks_info[i].ack_num < Acks_keep_track_info[Pending_Acks_info[i].session_index].bigger_ack_num) {
 			struct txq_entry_t *tqe;
 
 			PRINT_D(TCP_ENH, "DROP ACK: %u\n", Pending_Acks_info[i].ack_num);
-- 
1.9.1

