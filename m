Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3396 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbJAHEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 03:04:06 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 02/12] staging: wilc1000: remove function pointer wlan_start
Date: Thu, 1 Oct 2015 16:03:33 +0900
Message-ID: <1443683023-6498-2-git-send-email-tony.cho@atmel.com> (sfid-20151001_090409_326859_FD6B0BE1)
In-Reply-To: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
References: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes function pointer wlan_start and just call
the function wilc_wlan_start. Remove static from the function also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c    | 3 +--
 drivers/staging/wilc1000/wilc_wlan.h    | 1 +
 drivers/staging/wilc1000/wilc_wlan_if.h | 1 -
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index d7909d3..f515fca 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -622,7 +622,7 @@ static int linux_wlan_start_firmware(perInterface_wlan_t *nic)
 	int ret = 0;
 	/* start firmware */
 	PRINT_D(INIT_DBG, "Starting Firmware ...\n");
-	ret = g_linux_wlan->oup.wlan_start();
+	ret = wilc_wlan_start();
 	if (ret < 0) {
 		PRINT_ER("Failed to start Firmware\n");
 		goto _fail_;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 5e9a4c2..6e2bf4c 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1471,7 +1471,7 @@ _fail_1:
  *      Common
  *
  ********************************************/
-static int wilc_wlan_start(void)
+int wilc_wlan_start(void)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	u32 reg = 0;
@@ -2027,7 +2027,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	/**
 	 *      export functions
 	 **/
-	oup->wlan_start = wilc_wlan_start;
 	oup->wlan_stop = wilc_wlan_stop;
 	oup->wlan_add_to_tx_que = wilc_wlan_txq_add_net_pkt;
 	oup->wlan_handle_tx_que = wilc_wlan_handle_txq;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 72d2ebf..15ae9ae 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -306,4 +306,5 @@ typedef struct {
 } wilc_cfg_func_t;
 
 int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size);
+int wilc_wlan_start(void);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index e481446..e752092 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -122,7 +122,6 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define WILC_TX_ERR_NO_BUF	(-2)
 
 typedef struct {
-	int (*wlan_start)(void);
 	int (*wlan_stop)(void);
 	int (*wlan_add_to_tx_que)(void *, u8 *, u32, wilc_tx_complete_func_t);
 	int (*wlan_handle_tx_que)(u32 *);
-- 
1.9.1

