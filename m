Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37001 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031099AbbKFCNm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:13:42 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 32/73] staging: wilc1000: rename Ack_no variable
Date: Fri, 6 Nov 2015 11:12:53 +0900
Message-ID: <1446776014-28094-32-git-send-email-glen.lee@atmel.com> (sfid-20151106_033801_582027_D437743A)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the Ack_no variable to ack_no
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 6d72e09..52351c6 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -306,22 +306,25 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 					(u32)ip_hdr_ptr[3];
 			data_offset = ((u32)tcp_hdr_ptr[12] & 0xf0) >> 2;
 			if (total_length == (IHL + data_offset)) {
-				u32 seq_no, Ack_no;
+				u32 seq_no, ack_no;
 
 				seq_no	= (((u32)tcp_hdr_ptr[4]) << 24) + (((u32)tcp_hdr_ptr[5]) << 16) + (((u32)tcp_hdr_ptr[6]) << 8) + ((u32)tcp_hdr_ptr[7]);
 
-				Ack_no	= (((u32)tcp_hdr_ptr[8]) << 24) + (((u32)tcp_hdr_ptr[9]) << 16) + (((u32)tcp_hdr_ptr[10]) << 8) + ((u32)tcp_hdr_ptr[11]);
+				ack_no = ((u32)tcp_hdr_ptr[8] << 24) +
+					 ((u32)tcp_hdr_ptr[9] << 16) +
+					 ((u32)tcp_hdr_ptr[10] << 8) +
+					 (u32)tcp_hdr_ptr[11];
 
 				for (i = 0; i < tcp_session; i++) {
 					if (ack_session_info[i].seq_num == seq_no) {
-						update_tcp_session(i, Ack_no);
+						update_tcp_session(i, ack_no);
 						break;
 					}
 				}
 				if (i == tcp_session)
 					add_tcp_session(0, 0, seq_no);
 
-				add_tcp_pending_ack(Ack_no, i, tqe);
+				add_tcp_pending_ack(ack_no, i, tqe);
 			}
 
 		} else {
-- 
1.9.1

