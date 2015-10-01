Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3484 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbbJAHEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 03:04:32 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/12] staging: wilc1000: remove function pointer wlan_handle_rx_isr
Date: Thu, 1 Oct 2015 16:03:37 +0900
Message-ID: <1443683023-6498-6-git-send-email-tony.cho@atmel.com> (sfid-20151001_090435_307580_707C5D82)
In-Reply-To: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
References: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes function pointer wlan_handle_rx_isr and just call
the function wilc_handle_isr.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 5 +----
 drivers/staging/wilc1000/wilc_wlan.c    | 1 -
 drivers/staging/wilc1000/wilc_wlan.h    | 1 +
 drivers/staging/wilc1000/wilc_wlan_if.h | 1 -
 4 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index c2c9f3a..e278d94 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -313,10 +313,7 @@ irqreturn_t isr_bh_routine(int irq, void *userdata)
 	}
 
 	PRINT_D(INT_DBG, "Interrupt received BH\n");
-	if (g_linux_wlan->oup.wlan_handle_rx_isr != 0)
-		g_linux_wlan->oup.wlan_handle_rx_isr();
-	else
-		PRINT_ER("wlan_handle_rx_isr() hasn't been initialized\n");
+	wilc_handle_isr();
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 32045a9..e9af745 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -2028,7 +2028,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	/**
 	 *      export functions
 	 **/
-	oup->wlan_handle_rx_isr = wilc_handle_isr;
 	oup->wlan_cleanup = wilc_wlan_cleanup;
 	oup->wlan_cfg_set = wilc_wlan_cfg_set;
 	oup->wlan_cfg_get = wilc_wlan_cfg_get;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 7a395cf..2054ad5 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -311,4 +311,5 @@ int wilc_wlan_stop(void);
 int wilc_wlan_txq_add_net_pkt(void *priv, u8 *buffer, u32 buffer_size,
 			      wilc_tx_complete_func_t func);
 int wilc_wlan_handle_txq(u32 *pu32TxqCount);
+void wilc_handle_isr(void);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index d41a1d4..91bf68a 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -122,7 +122,6 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define WILC_TX_ERR_NO_BUF	(-2)
 
 typedef struct {
-	void (*wlan_handle_rx_isr)(void);
 	void (*wlan_cleanup)(void);
 	int (*wlan_cfg_set)(int, u32, u8 *, u32, int, u32);
 	int (*wlan_cfg_get)(int, u32, int, u32);
-- 
1.9.1

