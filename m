Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52162 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbbJWF2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:28:17 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 24/28] staging: wilc1000: wilc_wlan_rxq_add: add argument wilc and use it
Date: Fri, 23 Oct 2015 14:28:40 +0900
Message-ID: <1445578124-31486-24-git-send-email-glen.lee@atmel.com> (sfid-20151023_074658_516930_BBD27D3E)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct wilc and use it instead of g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 8cc533a..5393b6f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -586,14 +586,14 @@ static struct txq_entry_t *wilc_wlan_txq_get_next(struct txq_entry_t *tqe)
 	return tqe;
 }
 
-static int wilc_wlan_rxq_add(struct rxq_entry_t *rqe)
+static int wilc_wlan_rxq_add(struct wilc *wilc, struct rxq_entry_t *rqe)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 
 	if (p->quit)
 		return 0;
 
-	mutex_lock(&g_linux_wlan->rxq_cs);
+	mutex_lock(&wilc->rxq_cs);
 	if (p->rxq_head == NULL) {
 		PRINT_D(RX_DBG, "Add to Queue head\n");
 		rqe->next = NULL;
@@ -607,7 +607,7 @@ static int wilc_wlan_rxq_add(struct rxq_entry_t *rqe)
 	}
 	p->rxq_entries += 1;
 	PRINT_D(RX_DBG, "Number of queue entries: %d\n", p->rxq_entries);
-	mutex_unlock(&g_linux_wlan->rxq_cs);
+	mutex_unlock(&wilc->rxq_cs);
 	return p->rxq_entries;
 }
 
@@ -1349,7 +1349,7 @@ _end_:
 				rqe->buffer = buffer;
 				rqe->buffer_size = size;
 				PRINT_D(RX_DBG, "rxq entery Size= %d - Address = %p\n", rqe->buffer_size, rqe->buffer);
-				wilc_wlan_rxq_add(rqe);
+				wilc_wlan_rxq_add(wilc, rqe);
 			}
 		} else {
 #ifndef MEMORY_STATIC
-- 
1.9.1

