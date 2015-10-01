Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3580 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbbJAHFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 03:05:06 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/12] staging: wilc1000: remove function pointer wlan_cfg_get_value
Date: Thu, 1 Oct 2015 16:03:42 +0900
Message-ID: <1443683023-6498-11-git-send-email-tony.cho@atmel.com> (sfid-20151001_091654_041366_4F94CC09)
In-Reply-To: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
References: <1443683023-6498-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes function pointer wlan_cfg_get_value and just call
the function wilc_wlan_cfg_get_val. Remove static from the function also.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 5 +++--
 drivers/staging/wilc1000/linux_wlan.c       | 4 ++--
 drivers/staging/wilc1000/wilc_wlan.c        | 4 +---
 drivers/staging/wilc1000/wilc_wlan.h        | 1 +
 drivers/staging/wilc1000/wilc_wlan_if.h     | 1 -
 5 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 74ff763..246abb5 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -629,9 +629,10 @@ s32 send_config_pkt(u8 u8Mode, tstrWID *pstrWIDs,
 		}
 		counter = 0;
 		for (counter = 0; counter < u32WIDsCount; counter++) {
-			pstrWIDs[counter].s32ValueSize = gpstrWlanOps->wlan_cfg_get_value(
+			pstrWIDs[counter].s32ValueSize = wilc_wlan_cfg_get_val(
 					pstrWIDs[counter].u16WIDid,
-					pstrWIDs[counter].ps8WidVal, pstrWIDs[counter].s32ValueSize);
+					pstrWIDs[counter].ps8WidVal,
+					pstrWIDs[counter].s32ValueSize);
 
 		}
 	} else if (u8Mode == SET_CFG) {
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index a1e6f68..e91192c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -395,7 +395,7 @@ void linux_wlan_mac_indicate(int flag)
 	int status;
 
 	if (flag == WILC_MAC_INDICATE_STATUS) {
-		pd->oup.wlan_cfg_get_value(WID_STATUS, (unsigned char *)&status, 4);
+		wilc_wlan_cfg_get_val(WID_STATUS, (unsigned char *)&status, 4);
 		if (pd->mac_status == WILC_MAC_STATUS_INIT) {
 			pd->mac_status = status;
 			up(&pd->sync_event);
@@ -1288,7 +1288,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			int size;
 			char Firmware_ver[20];
 
-			size = g_linux_wlan->oup.wlan_cfg_get_value(
+			size = wilc_wlan_cfg_get_val(
 					WID_FIRMWARE_VERSION,
 					Firmware_ver, sizeof(Firmware_ver));
 			Firmware_ver[size] = '\0';
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ce0f054..f4e57d8 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1828,7 +1828,7 @@ int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 	return ret_size;
 }
 
-static int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size)
+int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size)
 {
 	int ret;
 
@@ -2029,8 +2029,6 @@ int wilc_wlan_init(wilc_wlan_inp_t *inp, wilc_wlan_oup_t *oup)
 	/**
 	 *      export functions
 	 **/
-	oup->wlan_cfg_get_value = wilc_wlan_cfg_get_val;
-
 	oup->wlan_add_mgmt_to_tx_que = wilc_wlan_txq_add_mgmt_pkt;
 
 	if (!init_chip()) {
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index eb61db0..3ffd558 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -314,4 +314,5 @@ void wilc_wlan_cleanup(void);
 int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 		      int commit, u32 drvHandler);
 int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler);
+int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 31d8983..baa13e2 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -122,7 +122,6 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define WILC_TX_ERR_NO_BUF	(-2)
 
 typedef struct {
-	int (*wlan_cfg_get_value)(u32, u8 *, u32);
 	int (*wlan_add_mgmt_to_tx_que)(void *, u8 *, u32,
 				       wilc_tx_complete_func_t);
 } wilc_wlan_oup_t;
-- 
1.9.1

