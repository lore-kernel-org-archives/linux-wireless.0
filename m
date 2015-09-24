Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25469 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbbIXJNX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 05:13:23 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/15] staging: wilc1000: use g_linux_wlan->rxq_cs for function arguemnt
Date: Thu, 24 Sep 2015 18:14:57 +0900
Message-ID: <1443086106-20482-6-git-send-email-glen.lee@atmel.com> (sfid-20150924_111328_382576_AD60ACDE)
In-Reply-To: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
References: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use mutex variable g_linux_wlan->rxq_cs instead of pointer varialbe.
No need to make extra pointer variable for the mutex. Remove
rxq_critical_section, rxq_lock and it's related codes.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   |  1 -
 drivers/staging/wilc1000/wilc_wlan.c    | 10 ++++------
 drivers/staging/wilc1000/wilc_wlan_if.h |  1 -
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d953ffe..71f996c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1067,7 +1067,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 #if defined(MEMORY_STATIC)
 	nwi->os_context.rx_buffer_size = LINUX_RX_SIZE;
 #endif
-	nwi->os_context.rxq_critical_section = (void *)&g_linux_wlan->rxq_cs;
 	nwi->os_context.cfg_wait_event = (void *)&g_linux_wlan->cfg_event;
 
 	nwi->os_func.os_wait = linux_wlan_lock_timeout;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 68826eb..81ec85e 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -81,7 +81,6 @@ typedef struct {
 	/**
 	 *      RX queue
 	 **/
-	struct mutex *rxq_lock;
 	struct rxq_entry_t *rxq_head;
 	struct rxq_entry_t *rxq_tail;
 	int rxq_entries;
@@ -605,7 +604,7 @@ static int wilc_wlan_rxq_add(struct rxq_entry_t *rqe)
 	if (p->quit)
 		return 0;
 
-	mutex_lock(p->rxq_lock);
+	mutex_lock(&g_linux_wlan->rxq_cs);
 	if (p->rxq_head == NULL) {
 		PRINT_D(RX_DBG, "Add to Queue head\n");
 		rqe->next = NULL;
@@ -619,7 +618,7 @@ static int wilc_wlan_rxq_add(struct rxq_entry_t *rqe)
 	}
 	p->rxq_entries += 1;
 	PRINT_D(RX_DBG, "Number of queue entries: %d\n", p->rxq_entries);
-	mutex_unlock(p->rxq_lock);
+	mutex_unlock(&g_linux_wlan->rxq_cs);
 	return p->rxq_entries;
 }
 
@@ -631,12 +630,12 @@ static struct rxq_entry_t *wilc_wlan_rxq_remove(void)
 	if (p->rxq_head) {
 		struct rxq_entry_t *rqe;
 
-		mutex_lock(p->rxq_lock);
+		mutex_lock(&g_linux_wlan->rxq_cs);
 		rqe = p->rxq_head;
 		p->rxq_head = p->rxq_head->next;
 		p->rxq_entries -= 1;
 		PRINT_D(RX_DBG, "RXQ entries decreased\n");
-		mutex_unlock(p->rxq_lock);
+		mutex_unlock(&g_linux_wlan->rxq_cs);
 		return rqe;
 	}
 	PRINT_D(RX_DBG, "Nothing to get from Q\n");
@@ -1974,7 +1973,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 
 	g_wlan.txq_add_to_head_lock = inp->os_context.txq_add_to_head_critical_section;
 
-	g_wlan.rxq_lock = inp->os_context.rxq_critical_section;
 	g_wlan.txq_wait = inp->os_context.txq_wait_event;
 	g_wlan.cfg_wait = inp->os_context.cfg_wait_event;
 	g_wlan.tx_buffer_size = inp->os_context.tx_buffer_size;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index e82d7a24..454933d 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -120,7 +120,6 @@ typedef struct {
 #if defined(MEMORY_STATIC)
 	u32 rx_buffer_size;
 #endif
-	void *rxq_critical_section;
 
 	struct semaphore *cfg_wait_event;
 } wilc_wlan_os_context_t;
-- 
1.9.1

