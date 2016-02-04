Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:59038 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbcBDJd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 04:33:27 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 59/70] staging: wilc1000: renames bNewNetwork of connect_resp_info structure
Date: Thu, 4 Feb 2016 18:24:20 +0900
Message-ID: <1454577871-667-20-git-send-email-glen.lee@atmel.com> (sfid-20160204_103338_816851_EBB108D9)
In-Reply-To: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
References: <1454577871-667-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames bNewNetwork variable to new_network.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       | 2 +-
 drivers/staging/wilc1000/host_interface.c         | 4 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 0e10c75..fd3b5d4 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -87,7 +87,7 @@ struct network_info {
 	u8 ch;
 	unsigned long time_scan_cached;
 	unsigned long time_scan;
-	bool bNewNetwork;
+	bool new_network;
 	u8 u8Found;
 	u32 u32Tsf;
 	u8 *pu8IEs;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index df33197..c0171f9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1390,7 +1390,7 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 
 					hif_drv->usr_scan_req.rcvd_ch_cnt++;
 
-					pstrNetworkInfo->bNewNetwork = true;
+					pstrNetworkInfo->new_network = true;
 					pJoinParams = host_int_ParseJoinBssParam(pstrNetworkInfo);
 
 					hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
@@ -1399,7 +1399,7 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 				}
 			}
 		} else {
-			pstrNetworkInfo->bNewNetwork = false;
+			pstrNetworkInfo->new_network = false;
 			hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
 							  hif_drv->usr_scan_req.arg, NULL);
 		}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 44d1855..ab3390c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -434,7 +434,7 @@ static void CfgScanResult(enum scan_event scan_event,
 					   network_info->cap_info,
 					   network_info->beacon_period);
 
-				if (network_info->bNewNetwork) {
+				if (network_info->new_network) {
 					if (priv->u32RcvdChCount < MAX_NUM_SCANNED_NETWORKS) {
 						PRINT_D(CFG80211_DBG,
 							"Network %s found\n",
-- 
1.9.1

