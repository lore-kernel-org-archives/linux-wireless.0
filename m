Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3369 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbbJAHD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 03:03:59 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/12] staging: wilc1000: remove function pointer wlan_firmware_download
Date: Thu, 1 Oct 2015 16:03:32 +0900
Message-ID: <1443683023-6498-1-git-send-email-tony.cho@atmel.com> (sfid-20151001_090402_536143_76D88047)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes function pointer wlan_firmware_download and just call
the function wilc_wlan_firmware_download. Remove static from the function also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c   | 3 ++-
 drivers/staging/wilc1000/wilc_wlan.c    | 3 +--
 drivers/staging/wilc1000/wilc_wlan.h    | 1 +
 drivers/staging/wilc1000/wilc_wlan_if.h | 1 -
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 701d317..d7909d3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -670,7 +670,8 @@ static int linux_wlan_firmware_download(linux_wlan_t *p_nic)
 	 *      do the firmware download
 	 **/
 	PRINT_D(INIT_DBG, "Downloading Firmware ...\n");
-	ret = g_linux_wlan->oup.wlan_firmware_download(g_linux_wlan->wilc_firmware->data, g_linux_wlan->wilc_firmware->size);
+	ret = wilc_wlan_firmware_download(g_linux_wlan->wilc_firmware->data,
+					  g_linux_wlan->wilc_firmware->size);
 	if (ret < 0)
 		goto _FAIL_;
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 428e94f..5e9a4c2 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1398,7 +1398,7 @@ void wilc_handle_isr(void)
  *      Firmware download
  *
  ********************************************/
-static int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
+int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	u32 offset;
@@ -2027,7 +2027,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	/**
 	 *      export functions
 	 **/
-	oup->wlan_firmware_download = wilc_wlan_firmware_download;
 	oup->wlan_start = wilc_wlan_start;
 	oup->wlan_stop = wilc_wlan_stop;
 	oup->wlan_add_to_tx_que = wilc_wlan_txq_add_net_pkt;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 7b1a872..72d2ebf 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -305,4 +305,5 @@ typedef struct {
 	int (*cfg_init)(wilc_debug_func);
 } wilc_cfg_func_t;
 
+int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 7aa317d..e481446 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -122,7 +122,6 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define WILC_TX_ERR_NO_BUF	(-2)
 
 typedef struct {
-	int (*wlan_firmware_download)(const u8 *, u32);
 	int (*wlan_start)(void);
 	int (*wlan_stop)(void);
 	int (*wlan_add_to_tx_que)(void *, u8 *, u32, wilc_tx_complete_func_t);
-- 
1.9.1

