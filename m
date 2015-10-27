Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:57927 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbbJ0JZh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:25:37 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 06/27] staging: wilc1000: wilc_wlan_handle_rxq: add new argument and use wilc
Date: Tue, 27 Oct 2015 18:27:42 +0900
Message-ID: <1445938083-20445-6-git-send-email-glen.lee@atmel.com> (sfid-20151027_102540_496328_8D29DE68)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct wilc and use it instead of g_linux_wlan.
Pass wilc to the function as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 5141fe0..4fc88ef 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1107,7 +1107,7 @@ _end_:
 	return ret;
 }
 
-static void wilc_wlan_handle_rxq(void)
+static void wilc_wlan_handle_rxq(struct wilc *wilc)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	int offset = 0, size, has_packet = 0;
@@ -1122,7 +1122,7 @@ static void wilc_wlan_handle_rxq(void)
 	do {
 		if (p->quit) {
 			PRINT_D(RX_DBG, "exit 1st do-while due to Clean_UP function\n");
-			up(&g_linux_wlan->cfg_event);
+			up(&wilc->cfg_event);
 			break;
 		}
 		rqe = wilc_wlan_rxq_remove();
@@ -1194,7 +1194,7 @@ static void wilc_wlan_handle_rxq(void)
 						 **/
 						PRINT_D(RX_DBG, "p->cfg_seq_no = %d - rsp.seq_no = %d\n", p->cfg_seq_no, rsp.seq_no);
 						if (p->cfg_seq_no == rsp.seq_no)
-							up(&g_linux_wlan->cfg_event);
+							up(&wilc->cfg_event);
 					} else if (rsp.type == WILC_CFG_RSP_STATUS) {
 						/**
 						 *      Call back to indicate status...
@@ -1350,7 +1350,7 @@ _end_:
 #endif
 		}
 	}
-	wilc_wlan_handle_rxq();
+	wilc_wlan_handle_rxq(wilc);
 }
 
 void wilc_handle_isr(void *wilc)
-- 
1.9.1

