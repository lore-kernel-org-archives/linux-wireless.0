Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:5883 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147AbbJ1Hp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:45:56 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/12] staging: wilc1000: wilc_wlan_txq_add_to_tail: add argument net_device
Date: Wed, 28 Oct 2015 16:48:21 +0900
Message-ID: <1446018508-17889-5-git-send-email-glen.lee@atmel.com> (sfid-20151028_084603_528602_8A51DF43)
In-Reply-To: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
References: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument dev and use netdev private data member wilc
instead of g_linux_wlan, pass the function dev also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 3dc0a80..03593b7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -190,11 +190,18 @@ wilc_wlan_txq_remove_from_head(struct net_device *dev)
 	return tqe;
 }
 
-static void wilc_wlan_txq_add_to_tail(struct txq_entry_t *tqe)
+static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
+				      struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	perInterface_wlan_t *nic;
+	struct wilc *wilc;
+
+	nic = netdev_priv(dev);
+	wilc = nic->wilc;
+
+	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
 	if (p->txq_head == NULL) {
 		tqe->next = NULL;
@@ -210,14 +217,14 @@ static void wilc_wlan_txq_add_to_tail(struct txq_entry_t *tqe)
 	p->txq_entries += 1;
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
+	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
 
 	/**
 	 *      wake up TX queue
 	 **/
 	PRINT_D(TX_DBG, "Wake the txq_handling\n");
 
-	up(&g_linux_wlan->txq_event);
+	up(&wilc->txq_event);
 }
 
 static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
@@ -538,7 +545,7 @@ int wilc_wlan_txq_add_net_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	if (is_TCP_ACK_Filter_Enabled())
 		tcp_process(dev, tqe);
 #endif
-	wilc_wlan_txq_add_to_tail(tqe);
+	wilc_wlan_txq_add_to_tail(dev, tqe);
 	/*return number of itemes in the queue*/
 	return p->txq_entries;
 }
@@ -566,7 +573,7 @@ int wilc_wlan_txq_add_mgmt_pkt(struct net_device *dev, void *priv, u8 *buffer,
 	tqe->tcp_PendingAck_index = NOT_TCP_ACK;
 #endif
 	PRINT_D(TX_DBG, "Adding Network packet at the Queue tail\n");
-	wilc_wlan_txq_add_to_tail(tqe);
+	wilc_wlan_txq_add_to_tail(dev, tqe);
 	return 1;
 }
 
-- 
1.9.1

