Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25644 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbbIXJOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 05:14:17 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 14/15] staging: wilc1000: remove function pointer os_wait
Date: Thu, 24 Sep 2015 18:15:05 +0900
Message-ID: <1443086106-20482-14-git-send-email-glen.lee@atmel.com> (sfid-20150924_111421_566868_23F9D03A)
In-Reply-To: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
References: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function pointer os_wait which is pointer of
linux_wlan_lock_timeout and just call the real name function directly.
Remove also static from linux_wlan_lock_timeout declaration.
As os_wait is deleted, structure wilc_wlan_os_func_t is useless. Delete
wilc_wlan_os_func_t, os_func and it's related codes.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         |  3 +--
 drivers/staging/wilc1000/wilc_sdio.c          |  2 --
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
 drivers/staging/wilc1000/wilc_wlan.c          | 20 +++++++++-----------
 drivers/staging/wilc1000/wilc_wlan_if.h       |  5 -----
 5 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3547750..701d317 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -381,7 +381,7 @@ void linux_wlan_dbg(u8 *buff)
 	PRINT_D(INIT_DBG, "%d\n", *buff);
 }
 
-static int linux_wlan_lock_timeout(void *vp, u32 timeout)
+int linux_wlan_lock_timeout(void *vp, u32 timeout)
 {
 	int error = -1;
 
@@ -1052,7 +1052,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
 
 	nwi->os_context.os_private = (void *)nic;
-	nwi->os_func.os_wait = linux_wlan_lock_timeout;
 
 #ifdef WILC_SDIO
 	nwi->io_func.io_type = HIF_SDIO;
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 48834c6..c22b35e 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -14,7 +14,6 @@
 
 typedef struct {
 	void *os_context;
-	wilc_wlan_os_func_t os_func;
 	u32 block_size;
 	int (*sdio_cmd52)(sdio_cmd52_t *);
 	int (*sdio_cmd53)(sdio_cmd53_t *);
@@ -586,7 +585,6 @@ static int sdio_init(wilc_wlan_inp_t *inp, wilc_debug_func func)
 
 	g_sdio.dPrint = func;
 	g_sdio.os_context = inp->os_context.os_private;
-	memcpy((void *)&g_sdio.os_func, (void *)&inp->os_func, sizeof(wilc_wlan_os_func_t));
 
 	if (inp->io_func.io_init) {
 		if (!inp->io_func.io_init(g_sdio.os_context)) {
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index e844306..af49c91 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -220,5 +220,6 @@ void frmw_to_linux(u8 *buff, u32 size, u32 pkt_offset);
 void linux_wlan_mac_indicate(int flag);
 void linux_wlan_rx_complete(void);
 void linux_wlan_dbg(u8 *buff);
+int linux_wlan_lock_timeout(void *vp, u32 timeout);
 
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 6ed5ecf..24a3aa1 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -30,7 +30,6 @@ typedef struct {
 	/**
 	 *      input interface functions
 	 **/
-	wilc_wlan_os_func_t os_func;
 	wilc_wlan_io_func_t io_func;
 
 	/**
@@ -223,8 +222,8 @@ static int wilc_wlan_txq_add_to_head(struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	unsigned long flags;
-	if (p->os_func.os_wait(&g_linux_wlan->txq_add_to_head_cs,
-			       CFG_PKTS_TIMEOUT))
+	if (linux_wlan_lock_timeout(&g_linux_wlan->txq_add_to_head_cs,
+				    CFG_PKTS_TIMEOUT))
 		return -1;
 
 	spin_lock_irqsave(&g_linux_wlan->txq_spinlock, flags);
@@ -452,7 +451,7 @@ static int wilc_wlan_txq_filter_dup_tcp_ack(void)
 
 	while (Dropped > 0) {
 		/*consume the semaphore count of the removed packet*/
-		p->os_func.os_wait(&g_linux_wlan->txq_event, 1);
+		linux_wlan_lock_timeout(&g_linux_wlan->txq_event, 1);
 		Dropped--;
 	}
 
@@ -839,8 +838,8 @@ static int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 		if (p->quit)
 			break;
 
-		p->os_func.os_wait(&g_linux_wlan->txq_add_to_head_cs,
-				   CFG_PKTS_TIMEOUT);
+		linux_wlan_lock_timeout(&g_linux_wlan->txq_add_to_head_cs,
+					CFG_PKTS_TIMEOUT);
 #ifdef	TCP_ACK_FILTER
 		wilc_wlan_txq_filter_dup_tcp_ack();
 #endif
@@ -1777,8 +1776,8 @@ static int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size, in
 		if (wilc_wlan_cfg_commit(WILC_CFG_SET, drvHandler))
 			ret_size = 0;
 
-		if (p->os_func.os_wait(&g_linux_wlan->cfg_event,
-				       CFG_PKTS_TIMEOUT)) {
+		if (linux_wlan_lock_timeout(&g_linux_wlan->cfg_event,
+					    CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Set Timed Out\n");
 			ret_size = 0;
 		}
@@ -1815,8 +1814,8 @@ static int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 			ret_size = 0;
 
 
-		if (p->os_func.os_wait(&g_linux_wlan->cfg_event,
-				       CFG_PKTS_TIMEOUT)) {
+		if (linux_wlan_lock_timeout(&g_linux_wlan->cfg_event,
+					    CFG_PKTS_TIMEOUT)) {
 			PRINT_D(TX_DBG, "Get Timed Out\n");
 			ret_size = 0;
 		}
@@ -1963,7 +1962,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	/**
 	 *      store the input
 	 **/
-	memcpy((void *)&g_wlan.os_func, (void *)&inp->os_func, sizeof(wilc_wlan_os_func_t));
 	memcpy((void *)&g_wlan.io_func, (void *)&inp->io_func, sizeof(wilc_wlan_io_func_t));
 	/***
 	 *      host interface init
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index df4e3bb..1f4c27f 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -75,10 +75,6 @@ typedef struct {
 } sdio_cmd53_t;
 
 typedef struct {
-	int (*os_wait)(void *, u32);
-} wilc_wlan_os_func_t;
-
-typedef struct {
 	int io_type;
 	int (*io_init)(void *);
 	void (*io_deinit)(void *);
@@ -111,7 +107,6 @@ typedef struct {
 
 typedef struct {
 	wilc_wlan_os_context_t os_context;
-	wilc_wlan_os_func_t os_func;
 	wilc_wlan_io_func_t io_func;
 } wilc_wlan_inp_t;
 
-- 
1.9.1

