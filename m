Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36867 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:13:01 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 25/73] staging: wilc1000: rename Update_TCP_track_session function
Date: Fri, 6 Nov 2015 11:12:46 +0900
Message-ID: <1446776014-28094-25-git-send-email-glen.lee@atmel.com> (sfid-20151106_033800_677444_72F53011)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the Update_TCP_track_session function to update_tcp_session
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 75b35b8..c4312bb 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -239,7 +239,7 @@ static inline int add_tcp_session(u32 src_prt, u32 dst_prt, u32 seq)
 	return 0;
 }
 
-static inline int Update_TCP_track_session(u32 index, u32 Ack)
+static inline int update_tcp_session(u32 index, u32 Ack)
 {
 	if (Ack > ack_session_info[index].bigger_ack_num)
 		ack_session_info[index].bigger_ack_num = Ack;
@@ -314,7 +314,7 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 
 				for (i = 0; i < tcp_session; i++) {
 					if (ack_session_info[i].seq_num == seq_no) {
-						Update_TCP_track_session(i, Ack_no);
+						update_tcp_session(i, Ack_no);
 						break;
 					}
 				}
-- 
1.9.1

