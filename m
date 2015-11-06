Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36651 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:11:52 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 14/73] staging: wilc1000: rename Ack_seq_num of struct ack_session_info
Date: Fri, 6 Nov 2015 11:12:35 +0900
Message-ID: <1446776014-28094-14-git-send-email-glen.lee@atmel.com> (sfid-20151106_033756_895407_64F23261)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename Ack_seq_num of struct ack_session_info to seq_num
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index f3968fd..7162473 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -195,7 +195,7 @@ u32 total_acks = 0, dropped_acks = 0;
 #ifdef	TCP_ACK_FILTER
 struct ack_session_info;
 struct ack_session_info {
-	u32 Ack_seq_num;
+	u32 seq_num;
 	u32 Bigger_Ack_num;
 	u16 src_port;
 	u16 dst_port;
@@ -229,7 +229,7 @@ static inline int Init_TCP_tracking(void)
 
 static inline int add_TCP_track_session(u32 src_prt, u32 dst_prt, u32 seq)
 {
-	Acks_keep_track_info[Opened_TCP_session].Ack_seq_num = seq;
+	Acks_keep_track_info[Opened_TCP_session].seq_num = seq;
 	Acks_keep_track_info[Opened_TCP_session].Bigger_Ack_num = 0;
 	Acks_keep_track_info[Opened_TCP_session].src_port = src_prt;
 	Acks_keep_track_info[Opened_TCP_session].dst_port = dst_prt;
@@ -313,7 +313,7 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 				Ack_no	= (((u32)tcp_hdr_ptr[8]) << 24) + (((u32)tcp_hdr_ptr[9]) << 16) + (((u32)tcp_hdr_ptr[10]) << 8) + ((u32)tcp_hdr_ptr[11]);
 
 				for (i = 0; i < Opened_TCP_session; i++) {
-					if (Acks_keep_track_info[i].Ack_seq_num == seq_no) {
+					if (Acks_keep_track_info[i].seq_num == seq_no) {
 						Update_TCP_track_session(i, Ack_no);
 						break;
 					}
-- 
1.9.1

