Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36671 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:11:59 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/73] staging: wilc1000: rename Bigger_Ack_num of struct ack_session_info
Date: Fri, 6 Nov 2015 11:12:36 +0900
Message-ID: <1446776014-28094-15-git-send-email-glen.lee@atmel.com> (sfid-20151106_033805_554475_F6D9B2D7)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename Bigger_Ack_num of struct ack_session_info to bigger_ack_num
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 7162473..4aec892 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -196,7 +196,7 @@ u32 total_acks = 0, dropped_acks = 0;
 struct ack_session_info;
 struct ack_session_info {
 	u32 seq_num;
-	u32 Bigger_Ack_num;
+	u32 bigger_ack_num;
 	u16 src_port;
 	u16 dst_port;
 	u16 status;
@@ -230,7 +230,7 @@ static inline int Init_TCP_tracking(void)
 static inline int add_TCP_track_session(u32 src_prt, u32 dst_prt, u32 seq)
 {
 	Acks_keep_track_info[Opened_TCP_session].seq_num = seq;
-	Acks_keep_track_info[Opened_TCP_session].Bigger_Ack_num = 0;
+	Acks_keep_track_info[Opened_TCP_session].bigger_ack_num = 0;
 	Acks_keep_track_info[Opened_TCP_session].src_port = src_prt;
 	Acks_keep_track_info[Opened_TCP_session].dst_port = dst_prt;
 	Opened_TCP_session++;
@@ -241,8 +241,8 @@ static inline int add_TCP_track_session(u32 src_prt, u32 dst_prt, u32 seq)
 
 static inline int Update_TCP_track_session(u32 index, u32 Ack)
 {
-	if (Ack > Acks_keep_track_info[index].Bigger_Ack_num)
-		Acks_keep_track_info[index].Bigger_Ack_num = Ack;
+	if (Ack > Acks_keep_track_info[index].bigger_ack_num)
+		Acks_keep_track_info[index].bigger_ack_num = Ack;
 	return 0;
 }
 
@@ -347,7 +347,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 
 	spin_lock_irqsave(&wilc->txq_spinlock, p->txq_spinlock_flags);
 	for (i = PendingAcks_arrBase; i < (PendingAcks_arrBase + Pending_Acks); i++) {
-		if (Pending_Acks_info[i].ack_num < Acks_keep_track_info[Pending_Acks_info[i].Session_index].Bigger_Ack_num) {
+		if (Pending_Acks_info[i].ack_num < Acks_keep_track_info[Pending_Acks_info[i].Session_index].bigger_ack_num) {
 			struct txq_entry_t *tqe;
 
 			PRINT_D(TCP_ENH, "DROP ACK: %u\n", Pending_Acks_info[i].ack_num);
-- 
1.9.1

