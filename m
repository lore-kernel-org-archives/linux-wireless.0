Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:5830 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147AbbJ1Hpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:45:43 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/12] staging: wilc1000: wilc_wlan_txq_remove_from_head: add new argument dev
Date: Wed, 28 Oct 2015 16:48:19 +0900
Message-ID: <1446018508-17889-3-git-send-email-glen.lee@atmel.com> (sfid-20151028_084554_959557_CB203629)
In-Reply-To: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
References: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new argument dev and use it instead of g_linux_wlan, and pass argument
dev to the function as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 6c7cbd1..5dcc4d2 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -159,13 +159,19 @@ static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 
 }
 
-static struct txq_entry_t *wilc_wlan_txq_remove_from_head(void)
+static struct txq_entry_t *
+wilc_wlan_txq_remove_from_head(struct net_device *dev)
 {
 	struct txq_entry_t *tqe;
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
+	perInterface_wlan_t *nic;
+	struct wilc *wilc;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	nic = netdev_priv(dev);
+	wilc = nic->wilc;
+
+	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 	if (p->txq_head) {
 		tqe = p->txq_head;
 		p->txq_head = tqe->next;
@@ -180,7 +186,7 @@ static struct txq_entry_t *wilc_wlan_txq_remove_from_head(void)
 	} else {
 		tqe = NULL;
 	}
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 	return tqe;
 }
 
@@ -1035,7 +1041,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 		offset = 0;
 		i = 0;
 		do {
-			tqe = wilc_wlan_txq_remove_from_head();
+			tqe = wilc_wlan_txq_remove_from_head(dev);
 			if (tqe != NULL && (vmm_table[i] != 0)) {
 				u32 header, buffer_offset;
 
@@ -1668,7 +1674,7 @@ void wilc_wlan_cleanup(struct net_device *dev)
 
 	p->quit = 1;
 	do {
-		tqe = wilc_wlan_txq_remove_from_head();
+		tqe = wilc_wlan_txq_remove_from_head(dev);
 		if (tqe == NULL)
 			break;
 		if (tqe->tx_complete_func)
-- 
1.9.1

