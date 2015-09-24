Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25451 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbbIXJNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 05:13:17 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/15] staging: wilc1000: use g_linux_wlan->txq_spinlock not the pointer of it
Date: Thu, 24 Sep 2015 18:14:56 +0900
Message-ID: <1443086106-20482-5-git-send-email-glen.lee@atmel.com> (sfid-20150924_111323_431697_5D42CFF3)
In-Reply-To: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
References: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use spinlock variable g_linux_wlan->txq_spinlock itself instead of
g_wlan.txq_spinlock which is pointer of g_linux_wlan->txq_spinlock.
Delete os_context.txq_spin_lock, g_wlan.txq_spinlock and it's related codes.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         |  2 --
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
 drivers/staging/wilc1000/wilc_wlan.c          | 37 ++++++++++++---------------
 drivers/staging/wilc1000/wilc_wlan_if.h       |  1 -
 4 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d2678a3..d953ffe 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1062,8 +1062,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 
 	nwi->os_context.txq_add_to_head_critical_section = (void *)&g_linux_wlan->txq_add_to_head_cs;
 
-	nwi->os_context.txq_spin_lock = (void *)&g_linux_wlan->txq_spinlock;
-
 	nwi->os_context.txq_wait_event = (void *)&g_linux_wlan->txq_event;
 
 #if defined(MEMORY_STATIC)
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 47e04c2..b24b9a9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -215,6 +215,7 @@ struct WILC_WFI_mon_priv {
 	struct net_device *real_ndev;
 };
 
+extern linux_wlan_t *g_linux_wlan;
 extern struct net_device *WILC_WFI_devs[];
 void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset);
 void linux_wlan_mac_indicate(int flag);
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 3e1479f..68826eb 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -70,7 +70,6 @@ typedef struct {
 	void *txq_lock;
 
 	struct semaphore *txq_add_to_head_lock;
-	void *txq_spinlock;
 	unsigned long txq_spinlock_flags;
 
 	struct txq_entry_t *txq_head;
@@ -179,7 +178,7 @@ static struct txq_entry_t *wilc_wlan_txq_remove_from_head(void)
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	unsigned long flags;
 
-	spin_lock_irqsave(p->txq_spinlock, flags);
+	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
 	if (p->txq_head) {
 		tqe = p->txq_head;
 		p->txq_head = tqe->next;
@@ -194,7 +193,7 @@ static struct txq_entry_t *wilc_wlan_txq_remove_from_head(void)
 	} else {
 		tqe = NULL;
 	}
-	spin_unlock_irqrestore(p->txq_spinlock, flags);
+	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
 	return tqe;
 }
 
@@ -202,7 +201,7 @@ static void wilc_wlan_txq_add_to_tail(struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	unsigned long flags;
-	spin_lock_irqsave(p->txq_spinlock, flags);
+	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
 
 	if (p->txq_head == NULL) {
 		tqe->next = NULL;
@@ -218,7 +217,7 @@ static void wilc_wlan_txq_add_to_tail(struct txq_entry_t *tqe)
 	p->txq_entries += 1;
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
 
-	spin_unlock_irqrestore(p->txq_spinlock, flags);
+	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
 
 	/**
 	 *      wake up TX queue
@@ -235,7 +234,7 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	if (p->os_func.os_wait(p->txq_add_to_head_lock, CFG_PKTS_TIMEOUT))
 		return -1;
 
-	spin_lock_irqsave(p->txq_spinlock, flags);
+	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
 
 	if (p->txq_head == NULL) {
 		tqe->next = NULL;
@@ -251,7 +250,7 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	p->txq_entries += 1;
 	PRINT_D(TX_DBG, "Number of entries in TxQ = %d\n", p->txq_entries);
 
-	spin_unlock_irqrestore(p->txq_spinlock, flags);
+	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
 	up(p->txq_add_to_head_lock);
 
 
@@ -352,9 +351,9 @@ static inline int remove_TCP_related(void)
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	unsigned long flags;
 
-	spin_lock_irqsave(p->txq_spinlock, flags);
+	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
 
-	spin_unlock_irqrestore(p->txq_spinlock, flags);
+	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
 	return 0;
 }
 
@@ -368,7 +367,7 @@ static inline int tcp_process(struct txq_entry_t *tqe)
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	unsigned long flags;
 
-	spin_lock_irqsave(p->txq_spinlock, flags);
+	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
 
 	eth_hdr_ptr = &buffer[0];
 	h_proto = ntohs(*((unsigned short *)&eth_hdr_ptr[12]));
@@ -416,7 +415,7 @@ static inline int tcp_process(struct txq_entry_t *tqe)
 	} else {
 		ret = 0;
 	}
-	spin_unlock_irqrestore(p->txq_spinlock, flags);
+	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
 	return ret;
 }
 
@@ -428,7 +427,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 	u32 Dropped = 0;
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 
-	spin_lock_irqsave(p->txq_spinlock, p->txq_spinlock_flags);
+	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, p->txq_spinlock_flags);
 	for (i = PendingAcks_arrBase; i < (PendingAcks_arrBase + Pending_Acks); i++) {
 		if (Pending_Acks_info[i].ack_num < Acks_keep_track_info[Pending_Acks_info[i].Session_index].Bigger_Ack_num) {
 			struct txq_entry_t *tqe;
@@ -455,7 +454,8 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 		PendingAcks_arrBase = 0;
 
 
-	spin_unlock_irqrestore(p->txq_spinlock, p->txq_spinlock_flags);
+	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock,
+			       p->txq_spinlock_flags);
 
 	while (Dropped > 0) {
 		/*consume the semaphore count of the removed packet*/
@@ -576,11 +576,11 @@ static struct txq_entry_t *wilc_wlan_txq_get_first(void)
 	struct txq_entry_t *tqe;
 	unsigned long flags;
 
-	spin_lock_irqsave(p->txq_spinlock, flags);
+	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
 
 	tqe = p->txq_head;
 
-	spin_unlock_irqrestore(p->txq_spinlock, flags);
+	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
 
 
 	return tqe;
@@ -588,12 +588,11 @@ static struct txq_entry_t *wilc_wlan_txq_get_first(void)
 
 static struct txq_entry_t *wilc_wlan_txq_get_next(struct txq_entry_t *tqe)
 {
-	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	unsigned long flags;
-	spin_lock_irqsave(p->txq_spinlock, flags);
+	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
 
 	tqe = tqe->next;
-	spin_unlock_irqrestore(p->txq_spinlock, flags);
+	spin_unlock_irqrestore(&g_linux_wlan->txq_spinlock, flags);
 
 
 	return tqe;
@@ -1975,8 +1974,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 
 	g_wlan.txq_add_to_head_lock = inp->os_context.txq_add_to_head_critical_section;
 
-	g_wlan.txq_spinlock = inp->os_context.txq_spin_lock;
-
 	g_wlan.rxq_lock = inp->os_context.rxq_critical_section;
 	g_wlan.txq_wait = inp->os_context.txq_wait_event;
 	g_wlan.cfg_wait = inp->os_context.cfg_wait_event;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index aafb492..e82d7a24 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -114,7 +114,6 @@ typedef struct {
 	void *txq_critical_section;
 
 	void *txq_add_to_head_critical_section;
-	void *txq_spin_lock;
 
 	void *txq_wait_event;
 
-- 
1.9.1

