Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36741 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:12:16 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 18/73] staging: wilc1000: rename Acks_keep_track_info variable
Date: Fri, 6 Nov 2015 11:12:39 +0900
Message-ID: <1446776014-28094-18-git-send-email-glen.lee@atmel.com> (sfid-20151106_033804_607283_D1C0F142)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the Acks_keep_track_info variable to ack_session_info
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index af5a16e..359df26 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -215,7 +215,7 @@ struct ack_session_info *Alloc_head;
 
 #define MAX_TCP_SESSION		25
 #define MAX_PENDING_ACKS		256
-struct ack_session_info Acks_keep_track_info[2 * MAX_TCP_SESSION];
+struct ack_session_info ack_session_info[2 * MAX_TCP_SESSION];
 struct pending_acks_info Pending_Acks_info[MAX_PENDING_ACKS];
 
 u32 PendingAcks_arrBase;
@@ -229,10 +229,10 @@ static inline int Init_TCP_tracking(void)
 
 static inline int add_TCP_track_session(u32 src_prt, u32 dst_prt, u32 seq)
 {
-	Acks_keep_track_info[Opened_TCP_session].seq_num = seq;
-	Acks_keep_track_info[Opened_TCP_session].bigger_ack_num = 0;
-	Acks_keep_track_info[Opened_TCP_session].src_port = src_prt;
-	Acks_keep_track_info[Opened_TCP_session].dst_port = dst_prt;
+	ack_session_info[Opened_TCP_session].seq_num = seq;
+	ack_session_info[Opened_TCP_session].bigger_ack_num = 0;
+	ack_session_info[Opened_TCP_session].src_port = src_prt;
+	ack_session_info[Opened_TCP_session].dst_port = dst_prt;
 	Opened_TCP_session++;
 
 	PRINT_D(TCP_ENH, "TCP Session %d to Ack %d\n", Opened_TCP_session, seq);
@@ -241,8 +241,8 @@ static inline int add_TCP_track_session(u32 src_prt, u32 dst_prt, u32 seq)
 
 static inline int Update_TCP_track_session(u32 index, u32 Ack)
 {
-	if (Ack > Acks_keep_track_info[index].bigger_ack_num)
-		Acks_keep_track_info[index].bigger_ack_num = Ack;
+	if (Ack > ack_session_info[index].bigger_ack_num)
+		ack_session_info[index].bigger_ack_num = Ack;
 	return 0;
 }
 
@@ -313,7 +313,7 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 				Ack_no	= (((u32)tcp_hdr_ptr[8]) << 24) + (((u32)tcp_hdr_ptr[9]) << 16) + (((u32)tcp_hdr_ptr[10]) << 8) + ((u32)tcp_hdr_ptr[11]);
 
 				for (i = 0; i < Opened_TCP_session; i++) {
-					if (Acks_keep_track_info[i].seq_num == seq_no) {
+					if (ack_session_info[i].seq_num == seq_no) {
 						Update_TCP_track_session(i, Ack_no);
 						break;
 					}
@@ -347,7 +347,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 
 	spin_lock_irqsave(&wilc->txq_spinlock, p->txq_spinlock_flags);
 	for (i = PendingAcks_arrBase; i < (PendingAcks_arrBase + Pending_Acks); i++) {
-		if (Pending_Acks_info[i].ack_num < Acks_keep_track_info[Pending_Acks_info[i].session_index].bigger_ack_num) {
+		if (Pending_Acks_info[i].ack_num < ack_session_info[Pending_Acks_info[i].session_index].bigger_ack_num) {
 			struct txq_entry_t *tqe;
 
 			PRINT_D(TCP_ENH, "DROP ACK: %u\n", Pending_Acks_info[i].ack_num);
-- 
1.9.1

