Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58365 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbbJ0J05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:26:57 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 19/27] staging: wilc1000: wilc_wlan_rxq_remove: add argument wilc and use it
Date: Tue, 27 Oct 2015 18:27:55 +0900
Message-ID: <1445938083-20445-19-git-send-email-glen.lee@atmel.com> (sfid-20151027_102659_927375_700960D5)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct wilc and use it instead of g_linux_wlan.
Pass wilc to wilc_wlan_rxq_remove.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 7473742..1461b61 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -612,7 +612,7 @@ static int wilc_wlan_rxq_add(struct rxq_entry_t *rqe)
 	return p->rxq_entries;
 }
 
-static struct rxq_entry_t *wilc_wlan_rxq_remove(void)
+static struct rxq_entry_t *wilc_wlan_rxq_remove(struct wilc *wilc)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 
@@ -620,12 +620,12 @@ static struct rxq_entry_t *wilc_wlan_rxq_remove(void)
 	if (p->rxq_head) {
 		struct rxq_entry_t *rqe;
 
-		mutex_lock(&g_linux_wlan->rxq_cs);
+		mutex_lock(&wilc->rxq_cs);
 		rqe = p->rxq_head;
 		p->rxq_head = p->rxq_head->next;
 		p->rxq_entries -= 1;
 		PRINT_D(RX_DBG, "RXQ entries decreased\n");
-		mutex_unlock(&g_linux_wlan->rxq_cs);
+		mutex_unlock(&wilc->rxq_cs);
 		return rqe;
 	}
 	PRINT_D(RX_DBG, "Nothing to get from Q\n");
@@ -1132,7 +1132,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 			up(&wilc->cfg_event);
 			break;
 		}
-		rqe = wilc_wlan_rxq_remove();
+		rqe = wilc_wlan_rxq_remove(wilc);
 		if (rqe == NULL) {
 			PRINT_D(RX_DBG, "nothing in the queue - exit 1st do-while\n");
 			break;
@@ -1654,6 +1654,11 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	struct rxq_entry_t *rqe;
 	u32 reg = 0;
 	int ret;
+	perInterface_wlan_t *nic;
+	struct wilc *wilc;
+
+	nic = netdev_priv(dev);
+	wilc = nic->wilc;
 
 	p->quit = 1;
 	do {
@@ -1666,7 +1671,7 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	} while (1);
 
 	do {
-		rqe = wilc_wlan_rxq_remove();
+		rqe = wilc_wlan_rxq_remove(wilc);
 		if (rqe == NULL)
 			break;
 #ifndef MEMORY_STATIC
-- 
1.9.1

