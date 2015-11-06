Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36908 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCNN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:13:13 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 27/73] staging: wilc1000: rename Ack member variable
Date: Fri, 6 Nov 2015 11:12:48 +0900
Message-ID: <1446776014-28094-27-git-send-email-glen.lee@atmel.com> (sfid-20151106_033802_790899_C18E0260)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the Ack member variable to ack
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 3e62abd..58043dc 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -239,19 +239,19 @@ static inline int add_tcp_session(u32 src_prt, u32 dst_prt, u32 seq)
 	return 0;
 }
 
-static inline int update_tcp_session(u32 index, u32 Ack)
+static inline int update_tcp_session(u32 index, u32 ack)
 {
-	if (Ack > ack_session_info[index].bigger_ack_num)
-		ack_session_info[index].bigger_ack_num = Ack;
+	if (ack > ack_session_info[index].bigger_ack_num)
+		ack_session_info[index].bigger_ack_num = ack;
 	return 0;
 }
 
-static inline int add_tcp_pending_ack(u32 Ack, u32 Session_index,
+static inline int add_tcp_pending_ack(u32 ack, u32 Session_index,
 				       struct txq_entry_t *txqe)
 {
 	total_acks++;
 	if (pending_acks < MAX_PENDING_ACKS) {
-		pending_acks_info[pending_base + pending_acks].ack_num = Ack;
+		pending_acks_info[pending_base + pending_acks].ack_num = ack;
 		pending_acks_info[pending_base + pending_acks].txqe = txqe;
 		pending_acks_info[pending_base + pending_acks].session_index = Session_index;
 		txqe->tcp_PendingAck_index = pending_base + pending_acks;
-- 
1.9.1

