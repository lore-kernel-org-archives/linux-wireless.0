Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25488 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbbIXJNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 05:13:30 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/15] staging: wilc1000: remove pointer variable of g_linux_wlan->txq_event
Date: Thu, 24 Sep 2015 18:14:58 +0900
Message-ID: <1443086106-20482-7-git-send-email-glen.lee@atmel.com> (sfid-20150924_111333_454252_4FF4EF7B)
In-Reply-To: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
References: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove variable txq_wait and txq_wait_event which are pointer varialbe
of g_linux_wlan->txq_event. No need to have extra pointer varialbe. Just use
g_linux_wlan->txq_event. Remove os_context.txq_wait_event, txq_wait and it's
related codes.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 2 --
 drivers/staging/wilc1000/wilc_wlan.c    | 8 +++-----
 drivers/staging/wilc1000/wilc_wlan_if.h | 2 --
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 71f996c..5bec7f2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1062,8 +1062,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 
 	nwi->os_context.txq_add_to_head_critical_section = (void *)&g_linux_wlan->txq_add_to_head_cs;
 
-	nwi->os_context.txq_wait_event = (void *)&g_linux_wlan->txq_event;
-
 #if defined(MEMORY_STATIC)
 	nwi->os_context.rx_buffer_size = LINUX_RX_SIZE;
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 81ec85e..e70c367 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -75,7 +75,6 @@ typedef struct {
 	struct txq_entry_t *txq_head;
 	struct txq_entry_t *txq_tail;
 	int txq_entries;
-	void *txq_wait;
 	int txq_exit;
 
 	/**
@@ -223,7 +222,7 @@ static void wilc_wlan_txq_add_to_tail(struct txq_entry_t *tqe)
 	 **/
 	PRINT_D(TX_DBG, "Wake the txq_handling\n");
 
-	up(p->txq_wait);
+	up(&g_linux_wlan->txq_event);
 }
 
 static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
@@ -256,7 +255,7 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 	/**
 	 *      wake up TX queue
 	 **/
-	up(p->txq_wait);
+	up(&g_linux_wlan->txq_event);
 	PRINT_D(TX_DBG, "Wake up the txq_handler\n");
 
 	return 0;
@@ -458,7 +457,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 
 	while (Dropped > 0) {
 		/*consume the semaphore count of the removed packet*/
-		p->os_func.os_wait(p->txq_wait, 1);
+		p->os_func.os_wait(&g_linux_wlan->txq_event, 1);
 		Dropped--;
 	}
 
@@ -1973,7 +1972,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 
 	g_wlan.txq_add_to_head_lock = inp->os_context.txq_add_to_head_critical_section;
 
-	g_wlan.txq_wait = inp->os_context.txq_wait_event;
 	g_wlan.cfg_wait = inp->os_context.cfg_wait_event;
 	g_wlan.tx_buffer_size = inp->os_context.tx_buffer_size;
 #if defined (MEMORY_STATIC)
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 454933d..1a0bfdb 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -115,8 +115,6 @@ typedef struct {
 
 	void *txq_add_to_head_critical_section;
 
-	void *txq_wait_event;
-
 #if defined(MEMORY_STATIC)
 	u32 rx_buffer_size;
 #endif
-- 
1.9.1

