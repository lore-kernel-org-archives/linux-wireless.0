Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25534 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbbIXJNo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 05:13:44 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/15] staging: wilc1000: remove pointer variables of txq_add_to_head_cs
Date: Thu, 24 Sep 2015 18:15:00 +0900
Message-ID: <1443086106-20482-9-git-send-email-glen.lee@atmel.com> (sfid-20150924_111347_816017_F6A247B0)
In-Reply-To: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
References: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes txq_add_to_head_critical_section and txq_add_to_head_lock
which are pointer of g_linux_wlan->txq_add_to_head_cs.
Just use g_linux_wlan->txq_add_to_head_cs as argument of function.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   |  3 ---
 drivers/staging/wilc1000/wilc_wlan.c    | 13 ++++++-------
 drivers/staging/wilc1000/wilc_wlan_if.h |  3 ---
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2893776..61161b9 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1059,9 +1059,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 	nwi->os_context.os_private = (void *)nic;
 	nwi->os_context.tx_buffer_size = LINUX_TX_SIZE;
 	nwi->os_context.txq_critical_section = (void *)&g_linux_wlan->txq_cs;
-
-	nwi->os_context.txq_add_to_head_critical_section = (void *)&g_linux_wlan->txq_add_to_head_cs;
-
 #if defined(MEMORY_STATIC)
 	nwi->os_context.rx_buffer_size = LINUX_RX_SIZE;
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 5bca997..f042b78 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -68,7 +68,6 @@ typedef struct {
 	 **/
 	void *txq_lock;
 
-	struct semaphore *txq_add_to_head_lock;
 	unsigned long txq_spinlock_flags;
 
 	struct txq_entry_t *txq_head;
@@ -228,7 +227,8 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	unsigned long flags;
-	if (p->os_func.os_wait(p->txq_add_to_head_lock, CFG_PKTS_TIMEOUT))
+	if (p->os_func.os_wait(&g_linux_wlan->txq_add_to_head_cs,
+			       CFG_PKTS_TIMEOUT))
 		return -1;
 
 	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
@@ -248,7 +248,7 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
 
 	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
-	up(p->txq_add_to_head_lock);
+	up(&g_linux_wlan->txq_add_to_head_cs);
 
 
 	/**
@@ -843,7 +843,8 @@ static int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 		if (p->quit)
 			break;
 
-		p->os_func.os_wait(p->txq_add_to_head_lock, CFG_PKTS_TIMEOUT);
+		p->os_func.os_wait(&g_linux_wlan->txq_add_to_head_cs,
+				   CFG_PKTS_TIMEOUT);
 #ifdef	TCP_ACK_FILTER
 		wilc_wlan_txq_filter_dup_tcp_ack();
 #endif
@@ -1112,7 +1113,7 @@ _end_:
 		if (ret != 1)
 			break;
 	} while (0);
-	up(p->txq_add_to_head_lock);
+	up(&g_linux_wlan->txq_add_to_head_cs);
 
 	p->txq_exit = 1;
 	PRINT_D(TX_DBG, "THREAD: Exiting txq\n");
@@ -1971,8 +1972,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	g_wlan.hif_lock = inp->os_context.hif_critical_section;
 	g_wlan.txq_lock = inp->os_context.txq_critical_section;
 
-	g_wlan.txq_add_to_head_lock = inp->os_context.txq_add_to_head_critical_section;
-
 	g_wlan.tx_buffer_size = inp->os_context.tx_buffer_size;
 #if defined (MEMORY_STATIC)
 	g_wlan.rx_buffer_size = inp->os_context.rx_buffer_size;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index f761347..6f19277 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -112,9 +112,6 @@ typedef struct {
 
 	u32 tx_buffer_size;
 	void *txq_critical_section;
-
-	void *txq_add_to_head_critical_section;
-
 #if defined(MEMORY_STATIC)
 	u32 rx_buffer_size;
 #endif
-- 
1.9.1

