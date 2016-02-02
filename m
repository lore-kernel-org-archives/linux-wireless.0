Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9524 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbcBBMHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 07:07:09 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/26] staging: wilc1000: renames bNewNetwork of connect_resp_info structure
Date: Tue, 2 Feb 2016 21:02:25 +0900
Message-ID: <1454414556-9822-15-git-send-email-leo.kim@atmel.com> (sfid-20160202_130713_622854_ABB6A953)
In-Reply-To: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
References: <1454414556-9822-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
index 7b4f05b..ffa175d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1394,7 +1394,7 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 
 					hif_drv->usr_scan_req.rcvd_ch_cnt++;
 
-					pstrNetworkInfo->bNewNetwork = true;
+					pstrNetworkInfo->new_network = true;
 					pJoinParams = host_int_ParseJoinBssParam(pstrNetworkInfo);
 
 					hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
@@ -1403,7 +1403,7 @@ static s32 Handle_RcvdNtwrkInfo(struct wilc_vif *vif,
 				}
 			}
 		} else {
-			pstrNetworkInfo->bNewNetwork = false;
+			pstrNetworkInfo->new_network = false;
 			hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
 							  hif_drv->usr_scan_req.arg, NULL);
 		}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4767aa0..b5c19ed 100644
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

