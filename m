Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:25584 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbbIXJN5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 05:13:57 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/15] staging: wilc1000: remove variable tx_buffer_size
Date: Thu, 24 Sep 2015 18:15:02 +0900
Message-ID: <1443086106-20482-11-git-send-email-glen.lee@atmel.com> (sfid-20150924_111402_260981_DD12D278)
In-Reply-To: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
References: <1443086106-20482-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary two variables tx_buffer_size and just use
LINUX_TX_SIZE as argument.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 1 -
 drivers/staging/wilc1000/wilc_wlan.c    | 6 ++----
 drivers/staging/wilc1000/wilc_wlan_if.h | 1 -
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 5bb5588..62ca83f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1056,7 +1056,6 @@ void linux_to_wlan(wilc_wlan_inp_t *nwi, linux_wlan_t *nic)
 	PRINT_D(INIT_DBG, "Linux to Wlan services ...\n");
 
 	nwi->os_context.os_private = (void *)nic;
-	nwi->os_context.tx_buffer_size = LINUX_TX_SIZE;
 	nwi->os_context.txq_critical_section = (void *)&g_linux_wlan->txq_cs;
 #if defined(MEMORY_STATIC)
 	nwi->os_context.rx_buffer_size = LINUX_RX_SIZE;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 9df2110..4fc0a6a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -58,7 +58,6 @@ typedef struct {
 	/**
 	 *      TX buffer
 	 **/
-	u32 tx_buffer_size;
 	u8 *tx_buffer;
 	u32 tx_buffer_offset;
 
@@ -873,7 +872,7 @@ static int wilc_wlan_handle_txq(u32 *pu32TxqCount)
 				if (vmm_sz & 0x3) {                                                                                                     /* has to be word aligned */
 					vmm_sz = (vmm_sz + 4) & ~0x3;
 				}
-				if ((sum + vmm_sz) > p->tx_buffer_size) {
+				if ((sum + vmm_sz) > LINUX_TX_SIZE) {
 					break;
 				}
 				PRINT_D(TX_DBG, "VMM Size AFTER alignment = %d\n", vmm_sz);
@@ -1970,7 +1969,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	memcpy((void *)&g_wlan.io_func, (void *)&inp->io_func, sizeof(wilc_wlan_io_func_t));
 	g_wlan.txq_lock = inp->os_context.txq_critical_section;
 
-	g_wlan.tx_buffer_size = inp->os_context.tx_buffer_size;
 #if defined (MEMORY_STATIC)
 	g_wlan.rx_buffer_size = inp->os_context.rx_buffer_size;
 #endif
@@ -2017,7 +2015,7 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	 *      alloc tx, rx buffer
 	 **/
 	if (g_wlan.tx_buffer == NULL)
-		g_wlan.tx_buffer = kmalloc(g_wlan.tx_buffer_size, GFP_KERNEL);
+		g_wlan.tx_buffer = kmalloc(LINUX_TX_SIZE, GFP_KERNEL);
 	PRINT_D(TX_DBG, "g_wlan.tx_buffer = %p\n", g_wlan.tx_buffer);
 
 	if (g_wlan.tx_buffer == NULL) {
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 42013e7..a746ad4 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -107,7 +107,6 @@ typedef struct {
 
 typedef struct {
 	void *os_private;
-	u32 tx_buffer_size;
 	void *txq_critical_section;
 #if defined(MEMORY_STATIC)
 	u32 rx_buffer_size;
-- 
1.9.1

