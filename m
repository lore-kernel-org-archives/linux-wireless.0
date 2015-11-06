Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36602 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030909AbbKFCLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:11:41 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/73] staging: wilc1000: rename Statisitcs_DroppedAcks variable
Date: Fri, 6 Nov 2015 11:12:33 +0900
Message-ID: <1446776014-28094-12-git-send-email-glen.lee@atmel.com> (sfid-20151106_033803_703357_2780EA00)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch rename Statisitcs_DroppedAcks variable to dropped_acks
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 8d6215b..9b1ca17 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -190,7 +190,7 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	return 0;
 }
 
-u32 total_acks = 0, Statisitcs_DroppedAcks = 0;
+u32 total_acks = 0, dropped_acks = 0;
 
 #ifdef	TCP_ACK_FILTER
 struct Ack_session_info;
@@ -354,7 +354,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 			tqe = Pending_Acks_info[i].txqe;
 			if (tqe) {
 				wilc_wlan_txq_remove(tqe);
-				Statisitcs_DroppedAcks++;
+				dropped_acks++;
 				tqe->status = 1;
 				if (tqe->tx_complete_func)
 					tqe->tx_complete_func(tqe->priv, tqe->status);
-- 
1.9.1

