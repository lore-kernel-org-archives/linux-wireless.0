Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3568 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbbJAHFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 03:05:00 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/12] staging: wilc1000: remove function pointer wlan_cfg_get
Date: Thu, 1 Oct 2015 16:03:41 +0900
Message-ID: <1443683023-6498-10-git-send-email-tony.cho@atmel.com> (sfid-20151001_090503_485346_30586F1F)
In-Reply-To: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
References: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes function pointer wlan_cfg_get and just call
the function wilc_wlan_cfg_get. Remove static from the function also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 13 ++++---------
 drivers/staging/wilc1000/linux_wlan.c       |  2 +-
 drivers/staging/wilc1000/wilc_wlan.c        |  3 +--
 drivers/staging/wilc1000/wilc_wlan.h        |  1 +
 drivers/staging/wilc1000/wilc_wlan_if.h     |  1 -
 5 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 4e9feca..74ff763 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -614,19 +614,14 @@ s32 send_config_pkt(u8 u8Mode, tstrWID *pstrWIDs,
 	} else {
 		PRINT_D(CORECONFIG_DBG, "Net Dev is initialized\n");
 	}
-	if (gpstrWlanOps->wlan_cfg_get == NULL)	{
-		PRINT_D(CORECONFIG_DBG, "Set and Get is still not initialized\n");
-		return 1;
-	} else {
-		PRINT_D(CORECONFIG_DBG, "SET is initialized\n");
-	}
 	if (u8Mode == GET_CFG) {
 		for (counter = 0; counter < u32WIDsCount; counter++) {
 			PRINT_INFO(CORECONFIG_DBG, "Sending CFG packet [%d][%d]\n", !counter,
 				   (counter == u32WIDsCount - 1));
-			if (!gpstrWlanOps->wlan_cfg_get(!counter,
-							pstrWIDs[counter].u16WIDid,
-							(counter == u32WIDsCount - 1), drvHandler)) {
+			if (!wilc_wlan_cfg_get(!counter,
+					       pstrWIDs[counter].u16WIDid,
+					       (counter == u32WIDsCount - 1),
+					       drvHandler)) {
 				ret = -1;
 				printk("[Sendconfigpkt]Get Timed out\n");
 				break;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index ad4d64e..a1e6f68 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1284,7 +1284,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 
 		wilc_bus_set_max_speed();
 
-		if (g_linux_wlan->oup.wlan_cfg_get(1, WID_FIRMWARE_VERSION, 1, 0)) {
+		if (wilc_wlan_cfg_get(1, WID_FIRMWARE_VERSION, 1, 0)) {
 			int size;
 			char Firmware_ver[20];
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 3687a06..ce0f054 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1789,7 +1789,7 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 
 	return ret_size;
 }
-static int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
+int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 {
 	wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
 	u32 offset;
@@ -2029,7 +2029,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	/**
 	 *      export functions
 	 **/
-	oup->wlan_cfg_get = wilc_wlan_cfg_get;
 	oup->wlan_cfg_get_value = wilc_wlan_cfg_get_val;
 
 	oup->wlan_add_mgmt_to_tx_que = wilc_wlan_txq_add_mgmt_pkt;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index be589f0..eb61db0 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -313,4 +313,5 @@ void wilc_handle_isr(void);
 void wilc_wlan_cleanup(void);
 int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		      int commit, u32 drvHandler);
+int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 8897910..31d8983 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -122,7 +122,6 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define WILC_TX_ERR_NO_BUF	(-2)
 
 typedef struct {
-	int (*wlan_cfg_get)(int, u32, int, u32);
 	int (*wlan_cfg_get_value)(u32, u8 *, u32);
 	int (*wlan_add_mgmt_to_tx_que)(void *, u8 *, u32,
 				       wilc_tx_complete_func_t);
-- 
1.9.1

