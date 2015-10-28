Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42511 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbbJ1HCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:02:01 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 44/80] staging: wilc1000: rename u32UserScanPvoid of struct user_scan_req
Date: Wed, 28 Oct 2015 16:00:04 +0900
Message-ID: <1446015640-29398-44-git-send-email-glen.lee@atmel.com> (sfid-20151028_080205_535151_8116A6C8)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32UserScanPvoid of struct user_scan_req to arg
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 drivers/staging/wilc1000/host_interface.h |  3 +--
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d07421f..8bb3480 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -823,7 +823,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	PRINT_D(HOSTINF_DBG, "Scanning: In [%d] state\n", hif_drv->hif_state);
 
 	hif_drv->usr_scan_req.scan_result = pstrHostIFscanAttr->result;
-	hif_drv->usr_scan_req.u32UserScanPvoid = pstrHostIFscanAttr->arg;
+	hif_drv->usr_scan_req.arg = pstrHostIFscanAttr->arg;
 
 	if ((hif_drv->hif_state >= HOST_IF_SCANNING) &&
 	    (hif_drv->hif_state < HOST_IF_CONNECTED)) {
@@ -971,7 +971,7 @@ static s32 Handle_ScanDone(struct host_if_drv *hif_drv,
 
 	if (hif_drv->usr_scan_req.scan_result) {
 		hif_drv->usr_scan_req.scan_result(enuEvent, NULL,
-						  hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
+						  hif_drv->usr_scan_req.arg, NULL);
 		hif_drv->usr_scan_req.scan_result = NULL;
 	}
 
@@ -1448,7 +1448,7 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 					pJoinParams = host_int_ParseJoinBssParam(pstrNetworkInfo);
 
 					hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
-									  hif_drv->usr_scan_req.u32UserScanPvoid,
+									  hif_drv->usr_scan_req.arg,
 									  pJoinParams);
 				}
 			} else {
@@ -1457,7 +1457,7 @@ static s32 Handle_RcvdNtwrkInfo(struct host_if_drv *hif_drv,
 		} else {
 			pstrNetworkInfo->bNewNetwork = false;
 			hif_drv->usr_scan_req.scan_result(SCAN_EVENT_NETWORK_FOUND, pstrNetworkInfo,
-							  hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
+							  hif_drv->usr_scan_req.arg, NULL);
 		}
 	}
 
@@ -2002,7 +2002,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 		if (hif_drv->usr_scan_req.scan_result) {
 			del_timer(&hif_drv->scan_timer);
 			hif_drv->usr_scan_req.scan_result(SCAN_EVENT_ABORTED, NULL,
-							  hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
+							  hif_drv->usr_scan_req.arg, NULL);
 			hif_drv->usr_scan_req.scan_result = NULL;
 		}
 
@@ -4213,7 +4213,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 
 	if (hif_drv->usr_scan_req.scan_result) {
 		hif_drv->usr_scan_req.scan_result(SCAN_EVENT_ABORTED, NULL,
-						  hif_drv->usr_scan_req.u32UserScanPvoid, NULL);
+						  hif_drv->usr_scan_req.arg, NULL);
 		hif_drv->usr_scan_req.scan_result = NULL;
 	}
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 22dc8b0..9d86227 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -193,8 +193,7 @@ struct hidden_network {
 
 struct user_scan_req {
 	wilc_scan_result scan_result;
-	void *u32UserScanPvoid;
-
+	void *arg;
 	u32 u32RcvdChCount;
 	struct found_net_info astrFoundNetworkInfo[MAX_NUM_SCANNED_NETWORKS];
 };
-- 
1.9.1

