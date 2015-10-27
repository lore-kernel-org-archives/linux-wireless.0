Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:57888 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbJ0JZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 05:25:24 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 04/27] staging: wilc1000: wilc_handle_isr: add argument wilc to wilc_handle_isr
Date: Tue, 27 Oct 2015 18:27:40 +0900
Message-ID: <1445938083-20445-4-git-send-email-glen.lee@atmel.com> (sfid-20151027_102528_168197_CB575D65)
In-Reply-To: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
References: <1445938083-20445-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add new argument wilc to wilc_handle_isr and pass wilc to
the function.
It is void type for now because wilc_wlan.c was implemented platform
independently at the beginning (linux_wlan.c is implementation of LINUX part),
so the header file which defines struct wilc cannot be included at this moment,
but this driver is dedicated to LINUX so wilc_wlan.c and linux_wlan.c will be
merged. After that, this void type will be changed with struct wilc as well as
other functions which are using void type in wilc_wlan.h.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c      | 2 +-
 drivers/staging/wilc1000/linux_wlan_sdio.c | 7 +++++--
 drivers/staging/wilc1000/wilc_wlan.c       | 2 +-
 drivers/staging/wilc1000/wilc_wlan.h       | 2 +-
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index ac2bc06..54e077d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -261,7 +261,7 @@ irqreturn_t isr_bh_routine(int irq, void *userdata)
 	}
 
 	PRINT_D(INT_DBG, "Interrupt received BH\n");
-	wilc_handle_isr();
+	wilc_handle_isr(wilc);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 1f8d874..4aff953 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -27,7 +27,6 @@ struct wilc_sdio {
 };
 
 struct sdio_func *local_sdio_func;
-extern void wilc_handle_isr(void);
 
 static unsigned int sdio_default_speed;
 
@@ -42,9 +41,13 @@ static const struct sdio_device_id wilc_sdio_ids[] = {
 
 static void wilc_sdio_interrupt(struct sdio_func *func)
 {
+	struct wilc_sdio *wl_sdio;
+
+	wl_sdio = sdio_get_drvdata(func);
+
 #ifndef WILC_SDIO_IRQ_GPIO
 	sdio_release_host(func);
-	wilc_handle_isr();
+	wilc_handle_isr(wl_sdio->wilc);
 	sdio_claim_host(func);
 #endif
 }
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 67b0c52..be6f631 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1353,7 +1353,7 @@ _end_:
 	wilc_wlan_handle_rxq();
 }
 
-void wilc_handle_isr(void)
+void wilc_handle_isr(void *wilc)
 {
 	u32 int_status;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index bd89689..a07375b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -301,7 +301,7 @@ int wilc_wlan_stop(void);
 int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size,
 			      wilc_tx_complete_func_t func);
 int wilc_wlan_handle_txq(u32 *pu32TxqCount);
-void wilc_handle_isr(void);
+void wilc_handle_isr(void *wilc);
 void wilc_wlan_cleanup(void);
 int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		      int commit, u32 drvHandler);
-- 
1.9.1

