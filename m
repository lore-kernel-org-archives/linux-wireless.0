Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36799 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:12:43 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 22/73] staging: wilc1000: rename Pending_Acks variable
Date: Fri, 6 Nov 2015 11:12:43 +0900
Message-ID: <1446776014-28094-22-git-send-email-glen.lee@atmel.com> (sfid-20151106_033800_052218_9679F3EC)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the Pending_Acks variable to pending_acks
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 34e1097..df20d4d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -220,7 +220,7 @@ struct pending_acks_info pending_acks_info[MAX_PENDING_ACKS];
 
 u32 pending_base;
 u32 tcp_session;
-u32 Pending_Acks;
+u32 pending_acks;
 
 static inline int Init_TCP_tracking(void)
 {
@@ -249,12 +249,12 @@ static inline int Update_TCP_track_session(u32 index, u32 Ack)
 static inline int add_TCP_Pending_Ack(u32 Ack, u32 Session_index, struct txq_entry_t  *txqe)
 {
 	total_acks++;
-	if (Pending_Acks < MAX_PENDING_ACKS) {
-		pending_acks_info[pending_base + Pending_Acks].ack_num = Ack;
-		pending_acks_info[pending_base + Pending_Acks].txqe = txqe;
-		pending_acks_info[pending_base + Pending_Acks].session_index = Session_index;
-		txqe->tcp_PendingAck_index = pending_base + Pending_Acks;
-		Pending_Acks++;
+	if (pending_acks < MAX_PENDING_ACKS) {
+		pending_acks_info[pending_base + pending_acks].ack_num = Ack;
+		pending_acks_info[pending_base + pending_acks].txqe = txqe;
+		pending_acks_info[pending_base + pending_acks].session_index = Session_index;
+		txqe->tcp_PendingAck_index = pending_base + pending_acks;
+		pending_acks++;
 	} else {
 
 	}
@@ -346,7 +346,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	wilc = nic->wilc;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, p->txq_spinlock_flags);
-	for (i = pending_base; i < (pending_base + Pending_Acks); i++) {
+	for (i = pending_base; i < (pending_base + pending_acks); i++) {
 		if (pending_acks_info[i].ack_num < ack_session_info[pending_acks_info[i].session_index].bigger_ack_num) {
 			struct txq_entry_t *tqe;
 
@@ -364,7 +364,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 			}
 		}
 	}
-	Pending_Acks = 0;
+	pending_acks = 0;
 	tcp_session = 0;
 
 	if (pending_base == 0)
-- 
1.9.1

