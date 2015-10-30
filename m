Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:20755 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757187AbbJ3DIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 23:08:23 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/17] staging: wilc1000: wilc_wlan_txq_add_to_head: add new argument net_device
Date: Fri, 30 Oct 2015 12:10:32 +0900
Message-ID: <1446174642-28570-7-git-send-email-glen.lee@atmel.com> (sfid-20151030_040825_663262_FFD372C9)
In-Reply-To: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct net_device and use netdev private data
member wilc instead of g_linux_wlan, pass dev to the function as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ec4bff4..b503f07 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -227,15 +227,21 @@ static void wilc_wlan_txq_add_to_tail(struct net_device *dev,
 	up(&wilc->txq_event);
 }
 
-static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
+static int wilc_wlan_txq_add_to_head(struct net_device *dev,
+				     struct txq_entry_t *tqe)
 {
+	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc *wilc;
 	wilc_wlan_dev_t *p = &g_wlan;
 	unsigned long flags;
-	if (linux_wlan_lock_timeout(&g_linux_wlan->txq_add_to_head_cs,
+
+	wilc = nic->wilc;
+
+	if (linux_wlan_lock_timeout(&wilc->txq_add_to_head_cs,
 				    CFG_PKTS_TIMEOUT))
 		return -1;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
+	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
 	if (p->txq_head == NULL) {
 		tqe->next = NULL;
@@ -251,14 +257,14 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	p->txq_entries += 1;
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
-	up(&g_linux_wlan->txq_add_to_head_cs);
+	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
+	up(&wilc->txq_add_to_head_cs);
 
 
 	/**
 	 *      wake up TX queue
 	 **/
-	up(&g_linux_wlan->txq_event);
+	up(&wilc->txq_event);
 	PRINT_D(TX_DBG, "Wake up the txq_handler\n");
 
 	return 0;
@@ -520,7 +526,7 @@ static int wilc_wlan_txq_add_cfg_pkt(struct net_device *dev,
 	 **/
 	PRINT_D(TX_DBG, "Adding the config packet at the Queue tail\n");
 
-	if (wilc_wlan_txq_add_to_head(tqe))
+	if (wilc_wlan_txq_add_to_head(dev, tqe))
 		return 0;
 	return 1;
 }
-- 
1.9.1

