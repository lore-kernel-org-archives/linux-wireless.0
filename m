Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25607 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbbIXJOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 05:14:04 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/15] staging: wilc1000: remove variable rx_buffer_size
Date: Thu, 24 Sep 2015 18:15:03 +0900
Message-ID: <1443086106-20482-12-git-send-email-glen.lee@atmel.com> (sfid-20150924_111408_600028_4F6F8E94)
In-Reply-To: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
References: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes two variables rx_buffer_size and use LINUX_RX_SIZE as
argument.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 3 ---
 drivers/staging/wilc1000/wilc_wlan.c    | 9 ++-------
 drivers/staging/wilc1000/wilc_wlan_if.h | 3 ---
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 62ca83f..519fb16 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1057,9 +1057,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 
 	nwi->os_context.os_private = (void *)nic;
 	nwi->os_context.txq_critical_section = (void *)&g_linux_wlan->txq_cs;
-#if defined(MEMORY_STATIC)
-	nwi->os_context.rx_buffer_size = LINUX_RX_SIZE;
-#endif
 	nwi->os_func.os_wait = linux_wlan_lock_timeout;
 
 #ifdef WILC_SDIO
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 4fc0a6a..84e544d 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -51,7 +51,6 @@ typedef struct {
 	 *      RX buffer
 	 **/
 	#ifdef MEMORY_STATIC
-	u32 rx_buffer_size;
 	u8 *rx_buffer;
 	u32 rx_buffer_offset;
 	#endif
@@ -1308,7 +1307,7 @@ static void wilc_wlan_handle_isr_ext(u32 int_status)
 
 	if (size > 0) {
 #ifdef MEMORY_STATIC
-		if (p->rx_buffer_size - offset < size)
+		if (LINUX_RX_SIZE - offset < size)
 			offset = 0;
 
 		if (p->rx_buffer)
@@ -1968,10 +1967,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	memcpy((void *)&g_wlan.os_func, (void *)&inp->os_func, sizeof(wilc_wlan_os_func_t));
 	memcpy((void *)&g_wlan.io_func, (void *)&inp->io_func, sizeof(wilc_wlan_io_func_t));
 	g_wlan.txq_lock = inp->os_context.txq_critical_section;
-
-#if defined (MEMORY_STATIC)
-	g_wlan.rx_buffer_size = inp->os_context.rx_buffer_size;
-#endif
 	/***
 	 *      host interface init
 	 **/
@@ -2028,7 +2023,7 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 /* rx_buffer is not used unless we activate USE_MEM STATIC which is not applicable, allocating such memory is useless*/
 #if defined (MEMORY_STATIC)
 	if (g_wlan.rx_buffer == NULL)
-		g_wlan.rx_buffer = kmalloc(g_wlan.rx_buffer_size, GFP_KERNEL);
+		g_wlan.rx_buffer = kmalloc(LINUX_RX_SIZE, GFP_KERNEL);
 	PRINT_D(TX_DBG, "g_wlan.rx_buffer =%p\n", g_wlan.rx_buffer);
 	if (g_wlan.rx_buffer == NULL) {
 		/* ENOBUFS	105 */
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index a746ad4..9ab34ca 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -108,9 +108,6 @@ typedef struct {
 typedef struct {
 	void *os_private;
 	void *txq_critical_section;
-#if defined(MEMORY_STATIC)
-	u32 rx_buffer_size;
-#endif
 } wilc_wlan_os_context_t;
 
 typedef struct {
-- 
1.9.1

