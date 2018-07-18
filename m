Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:1269 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbeGSGpx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:45:53 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 02/23] staging: wilc1000: remove enum connect_status instead use ieee80211_statuscode
Date: Thu, 19 Jul 2018 04:14:58 +0530
Message-ID: <1531953919-20804-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080430_960538_14AE624C)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the use of enum 'connect_status' and instead use
predefined 'ieee80211_statuscode' for error code values.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  4 +++-
 drivers/staging/wilc1000/coreconfigurator.h       | 20 --------------------
 drivers/staging/wilc1000/host_interface.c         |  6 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
 4 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 0063895..a987953 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/ieee80211.h>
+
 #include "coreconfigurator.h"
 
 #define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
@@ -316,7 +318,7 @@ s32 wilc_parse_assoc_resp_info(u8 *buffer, u32 buffer_len,
 	u16 ies_len = 0;
 
 	ret_conn_info->status = get_asoc_status(buffer);
-	if (ret_conn_info->status == SUCCESSFUL_STATUSCODE) {
+	if (ret_conn_info->status == WLAN_STATUS_SUCCESS) {
 		ies = &buffer[CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN];
 		ies_len = buffer_len - (CAP_INFO_LEN + STATUS_CODE_LEN +
 					AID_LEN);
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 55b5531..90d3d65 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -24,26 +24,6 @@
 #define MAKE_WORD16(lsb, msb) ((((u16)(msb) << 8) & 0xFF00) | (lsb))
 #define MAKE_WORD32(lsw, msw) ((((u32)(msw) << 16) & 0xFFFF0000) | (lsw))
 
-enum connect_status {
-	SUCCESSFUL_STATUSCODE    = 0,
-	UNSPEC_FAIL              = 1,
-	UNSUP_CAP                = 10,
-	REASOC_NO_ASOC           = 11,
-	FAIL_OTHER               = 12,
-	UNSUPT_ALG               = 13,
-	AUTH_SEQ_FAIL            = 14,
-	CHLNG_FAIL               = 15,
-	AUTH_TIMEOUT             = 16,
-	AP_FULL                  = 17,
-	UNSUP_RATE               = 18,
-	SHORT_PREAMBLE_UNSUP     = 19,
-	PBCC_UNSUP               = 20,
-	CHANNEL_AGIL_UNSUP       = 21,
-	SHORT_SLOT_UNSUP         = 25,
-	OFDM_DSSS_UNSUP          = 26,
-	CONNECT_STS_FORCE_16_BIT = 0xFFFF
-};
-
 struct rssi_history_buffer {
 	bool full;
 	u8 index;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 918d06e..9b5bf3c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1336,7 +1336,7 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 	}
 
 	if (mac_status == MAC_STATUS_CONNECTED &&
-	    conn_info.status != SUCCESSFUL_STATUSCODE) {
+	    conn_info.status != WLAN_STATUS_SUCCESS) {
 		netdev_err(vif->ndev,
 			   "Received MAC status is MAC_STATUS_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
 		eth_zero_addr(wilc_connected_ssid);
@@ -1349,7 +1349,7 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 		memcpy(conn_info.bssid, hif_drv->usr_conn_req.bssid, 6);
 
 		if (mac_status == MAC_STATUS_CONNECTED &&
-		    conn_info.status == SUCCESSFUL_STATUSCODE) {
+		    conn_info.status == WLAN_STATUS_SUCCESS) {
 			memcpy(hif_drv->assoc_bssid,
 			       hif_drv->usr_conn_req.bssid, ETH_ALEN);
 		}
@@ -1369,7 +1369,7 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 					  hif_drv->usr_conn_req.arg);
 
 	if (mac_status == MAC_STATUS_CONNECTED &&
-	    conn_info.status == SUCCESSFUL_STATUSCODE) {
+	    conn_info.status == WLAN_STATUS_SUCCESS) {
 		wilc_set_power_mgmt(vif, 0, 0);
 
 		hif_drv->hif_state = HOST_IF_CONNECTED;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e96163f..f90b9b6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -489,7 +489,7 @@ static void cfg_connect_result(enum conn_event conn_disconn_evt,
 		connect_status = conn_info->status;
 
 		if (mac_status == MAC_STATUS_DISCONNECTED &&
-		    conn_info->status == SUCCESSFUL_STATUSCODE) {
+		    conn_info->status == WLAN_STATUS_SUCCESS) {
 			connect_status = WLAN_STATUS_UNSPECIFIED_FAILURE;
 			wilc_wlan_set_bssid(priv->dev, null_bssid,
 					    STATION_MODE);
-- 
2.7.4
