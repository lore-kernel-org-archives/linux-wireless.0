Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36768 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:12:27 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 20/73] staging: wilc1000: rename PendingAcks_arrBase variable
Date: Fri, 6 Nov 2015 11:12:41 +0900
Message-ID: <1446776014-28094-20-git-send-email-glen.lee@atmel.com> (sfid-20151106_033802_162756_2AA471B8)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the PendingAcks_arrBase variable to pending_base
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 7db42c0..a1b6067 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -218,7 +218,7 @@ struct ack_session_info *Alloc_head;
 struct ack_session_info ack_session_info[2 * MAX_TCP_SESSION];
 struct pending_acks_info pending_acks_info[MAX_PENDING_ACKS];
 
-u32 PendingAcks_arrBase;
+u32 pending_base;
 u32 Opened_TCP_session;
 u32 Pending_Acks;
 
@@ -250,10 +250,10 @@ static inline int add_TCP_Pending_Ack(u32 Ack, u32 Session_index, struct txq_ent
 {
 	total_acks++;
 	if (Pending_Acks < MAX_PENDING_ACKS) {
-		pending_acks_info[PendingAcks_arrBase + Pending_Acks].ack_num = Ack;
-		pending_acks_info[PendingAcks_arrBase + Pending_Acks].txqe = txqe;
-		pending_acks_info[PendingAcks_arrBase + Pending_Acks].session_index = Session_index;
-		txqe->tcp_PendingAck_index = PendingAcks_arrBase + Pending_Acks;
+		pending_acks_info[pending_base + Pending_Acks].ack_num = Ack;
+		pending_acks_info[pending_base + Pending_Acks].txqe = txqe;
+		pending_acks_info[pending_base + Pending_Acks].session_index = Session_index;
+		txqe->tcp_PendingAck_index = pending_base + Pending_Acks;
 		Pending_Acks++;
 	} else {
 
@@ -346,7 +346,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	wilc = nic->wilc;
 
 	spin_lock_irqsave(&wilc->txq_spinlock, p->txq_spinlock_flags);
-	for (i = PendingAcks_arrBase; i < (PendingAcks_arrBase + Pending_Acks); i++) {
+	for (i = pending_base; i < (pending_base + Pending_Acks); i++) {
 		if (pending_acks_info[i].ack_num < ack_session_info[pending_acks_info[i].session_index].bigger_ack_num) {
 			struct txq_entry_t *tqe;
 
@@ -367,10 +367,10 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 	Pending_Acks = 0;
 	Opened_TCP_session = 0;
 
-	if (PendingAcks_arrBase == 0)
-		PendingAcks_arrBase = MAX_TCP_SESSION;
+	if (pending_base == 0)
+		pending_base = MAX_TCP_SESSION;
 	else
-		PendingAcks_arrBase = 0;
+		pending_base = 0;
 
 	spin_unlock_irqrestore(&wilc->txq_spinlock, p->txq_spinlock_flags);
 
-- 
1.9.1

