Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36784 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:12:33 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 21/73] staging: wilc1000: rename Opened_TCP_session variable
Date: Fri, 6 Nov 2015 11:12:42 +0900
Message-ID: <1446776014-28094-21-git-send-email-glen.lee@atmel.com> (sfid-20151106_033804_291505_19F59E2B)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the Opened_TCP_session variable to tcp_session
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index a1b6067..34e1097 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -219,7 +219,7 @@ struct ack_session_info ack_session_info[2 * MAX_TCP_SESSION];
 struct pending_acks_info pending_acks_info[MAX_PENDING_ACKS];
 
 u32 pending_base;
-u32 Opened_TCP_session;
+u32 tcp_session;
 u32 Pending_Acks;
 
 static inline int Init_TCP_tracking(void)
@@ -229,13 +229,13 @@ static inline int Init_TCP_tracking(void)
 
 static inline int add_TCP_track_session(u32 src_prt, u32 dst_prt, u32 seq)
 {
-	ack_session_info[Opened_TCP_session].seq_num = seq;
-	ack_session_info[Opened_TCP_session].bigger_ack_num = 0;
-	ack_session_info[Opened_TCP_session].src_port = src_prt;
-	ack_session_info[Opened_TCP_session].dst_port = dst_prt;
-	Opened_TCP_session++;
+	ack_session_info[tcp_session].seq_num = seq;
+	ack_session_info[tcp_session].bigger_ack_num = 0;
+	ack_session_info[tcp_session].src_port = src_prt;
+	ack_session_info[tcp_session].dst_port = dst_prt;
+	tcp_session++;
 
-	PRINT_D(TCP_ENH, "TCP Session %d to Ack %d\n", Opened_TCP_session, seq);
+	PRINT_D(TCP_ENH, "TCP Session %d to Ack %d\n", tcp_session, seq);
 	return 0;
 }
 
@@ -312,13 +312,13 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 
 				Ack_no	= (((u32)tcp_hdr_ptr[8]) << 24) + (((u32)tcp_hdr_ptr[9]) << 16) + (((u32)tcp_hdr_ptr[10]) << 8) + ((u32)tcp_hdr_ptr[11]);
 
-				for (i = 0; i < Opened_TCP_session; i++) {
+				for (i = 0; i < tcp_session; i++) {
 					if (ack_session_info[i].seq_num == seq_no) {
 						Update_TCP_track_session(i, Ack_no);
 						break;
 					}
 				}
-				if (i == Opened_TCP_session)
+				if (i == tcp_session)
 					add_TCP_track_session(0, 0, seq_no);
 
 				add_TCP_Pending_Ack(Ack_no, i, tqe);
@@ -365,7 +365,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 		}
 	}
 	Pending_Acks = 0;
-	Opened_TCP_session = 0;
+	tcp_session = 0;
 
 	if (pending_base == 0)
 		pending_base = MAX_TCP_SESSION;
-- 
1.9.1

