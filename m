Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:51914 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbJWF1L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:27:11 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/28] staging: wilc1000: wilc_wlan_txq_filter_dup_tcp_ack: add argument and use wilc
Date: Fri, 23 Oct 2015 14:28:29 +0900
Message-ID: <1445578124-31486-13-git-send-email-glen.lee@atmel.com> (sfid-20151023_074657_953003_92B74094)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add argument net_device dev and use netdev private data member wilc
instead of g_linux_wlan. Pass argument dev to the function.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index f694f2e..ae4b01f 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -406,14 +406,18 @@ static inline int tcp_process(struct txq_entry_t *tqe)
 }
 
 
-static int wilc_wlan_txq_filter_dup_tcp_ack(void)
+static int wilc_wlan_txq_filter_dup_tcp_ack(struct net_device *dev)
 {
-
+	perInterface_wlan_t *nic;
+	struct wilc *wl;
 	u32 i = 0;
 	u32 Dropped = 0;
 	wilc_wlan_dev_t *p = &g_wlan;
 
-	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, p->txq_spinlock_flags);
+	nic = netdev_priv(dev);
+	wl = nic->wilc;
+
+	spin_lock_irqsave(&wl->txq_spinlock, p->txq_spinlock_flags);
 	for (i = PendingAcks_arrBase; i < (PendingAcks_arrBase + Pending_Acks); i++) {
 		if (Pending_Acks_info[i].ack_num < Acks_keep_track_info[Pending_Acks_info[i].Session_index].Bigger_Ack_num) {
 			struct txq_entry_t *tqe;
@@ -440,12 +444,11 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 		PendingAcks_arrBase = 0;
 
 
-	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock,
-			       p->txq_spinlock_flags);
+	spin_unlock_irqrestore(&wl->txq_spinlock, p->txq_spinlock_flags);
 
 	while (Dropped > 0) {
 		/*consume the semaphore count of the removed packet*/
-		linux_wlan_lock_timeout(&g_linux_wlan->txq_event, 1);
+		linux_wlan_lock_timeout(&wl->txq_event, 1);
 		Dropped--;
 	}
 
@@ -842,7 +845,7 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *pu32TxqCount)
 		linux_wlan_lock_timeout(&wl->txq_add_to_head_cs,
 					CFG_PKTS_TIMEOUT);
 #ifdef	TCP_ACK_FILTER
-		wilc_wlan_txq_filter_dup_tcp_ack();
+		wilc_wlan_txq_filter_dup_tcp_ack(dev);
 #endif
 		/**
 		 *      build the vmm list
-- 
1.9.1

