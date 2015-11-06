Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36894 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:13:07 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 26/73] staging: wilc1000: rename add_TCP_Pending_Ack function
Date: Fri, 6 Nov 2015 11:12:47 +0900
Message-ID: <1446776014-28094-26-git-send-email-glen.lee@atmel.com> (sfid-20151106_033758_459617_312A977B)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename the add_TCP_Pending_Ack function to add_tcp_pending_ack
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c4312bb..3e62abd 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -246,7 +246,8 @@ static inline int update_tcp_session(u32 index, u32 Ack)
 	return 0;
 }
 
-static inline int add_TCP_Pending_Ack(u32 Ack, u32 Session_index, struct txq_entry_t  *txqe)
+static inline int add_tcp_pending_ack(u32 Ack, u32 Session_index,
+				       struct txq_entry_t *txqe)
 {
 	total_acks++;
 	if (pending_acks < MAX_PENDING_ACKS) {
@@ -321,7 +322,7 @@ static inline int tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 				if (i == tcp_session)
 					add_tcp_session(0, 0, seq_no);
 
-				add_TCP_Pending_Ack(Ack_no, i, tqe);
+				add_tcp_pending_ack(Ack_no, i, tqe);
 			}
 
 		} else {
-- 
1.9.1

