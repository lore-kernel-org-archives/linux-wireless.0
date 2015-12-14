Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13759 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbLNFoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 00:44:02 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/12] staging: wilc1000: change join_req_drv type and it's name
Date: Mon, 14 Dec 2015 14:46:58 +0900
Message-ID: <1450072023-13013-8-git-send-email-glen.lee@atmel.com> (sfid-20151214_064406_958984_EFA746FA)
In-Reply-To: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
References: <1450072023-13013-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To use wilc_get_vif_idx instead of the last get_id_from_handler, join_req_drv
needs to be changed it's type with wilc_vif and name as well.
As a result, get_id_from_handler is not used anymore, so remove it.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 33 +++++++++----------------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 840253b..76e891c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -259,7 +259,7 @@ static u8 mode_11i;
 static u8 auth_type;
 static u32 join_req_size;
 static u32 info_element_size;
-static struct host_if_drv *join_req_drv;
+static struct wilc_vif *join_req_vif;
 #define REAL_JOIN_REQ 0
 #define FLUSHED_JOIN_REQ 1
 #define FLUSHED_BYTE_POS 79
@@ -294,21 +294,6 @@ static int remove_handler_in_list(struct host_if_drv *handler)
 	return -EINVAL;
 }
 
-static int get_id_from_handler(struct host_if_drv *handler)
-{
-	int i;
-
-	if (!handler)
-		return 0;
-
-	for (i = 1; i < ARRAY_SIZE(wfidrv_list); i++) {
-		if (wfidrv_list[i] == handler)
-			return i;
-	}
-
-	return 0;
-}
-
 /* The u8IfIdx starts from 0 to NUM_CONCURRENT_IFC -1, but 0 index used as
  * special purpose in wilc device, so we add 1 to the index to starts from 1.
  * As a result, the returned index will be 1 to NUM_CONCURRENT_IFC.
@@ -1235,7 +1220,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
 		memcpy(join_req, pu8CurrByte, join_req_size);
-		join_req_drv = hif_drv;
+		join_req_vif = vif;
 	}
 
 	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
@@ -1349,7 +1334,7 @@ static s32 Handle_FlushConnect(struct wilc_vif *vif)
 
 	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, strWIDList,
 				      u32WidsCount,
-				      get_id_from_handler(join_req_drv));
+				      wilc_get_vif_idx(join_req_vif));
 	if (result) {
 		PRINT_ER("failed to send config packet\n");
 		result = -EINVAL;
@@ -1423,12 +1408,12 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 
 	eth_zero_addr(wilc_connected_ssid);
 
-	if (join_req && join_req_drv == hif_drv) {
+	if (join_req && join_req_vif == vif) {
 		kfree(join_req);
 		join_req = NULL;
 	}
 
-	if (info_element && join_req_drv == hif_drv) {
+	if (info_element && join_req_vif == vif) {
 		kfree(info_element);
 		info_element = NULL;
 	}
@@ -1715,12 +1700,12 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			hif_drv->usr_conn_req.ies_len = 0;
 			kfree(hif_drv->usr_conn_req.ies);
 
-			if (join_req && join_req_drv == hif_drv) {
+			if (join_req && join_req_vif == vif) {
 				kfree(join_req);
 				join_req = NULL;
 			}
 
-			if (info_element && join_req_drv == hif_drv) {
+			if (info_element && join_req_vif == vif) {
 				kfree(info_element);
 				info_element = NULL;
 			}
@@ -2089,12 +2074,12 @@ static void Handle_Disconnect(struct wilc_vif *vif)
 		hif_drv->usr_conn_req.ies_len = 0;
 		kfree(hif_drv->usr_conn_req.ies);
 
-		if (join_req && join_req_drv == hif_drv) {
+		if (join_req && join_req_vif == vif) {
 			kfree(join_req);
 			join_req = NULL;
 		}
 
-		if (info_element && join_req_drv == hif_drv) {
+		if (info_element && join_req_vif == vif) {
 			kfree(info_element);
 			info_element = NULL;
 		}
-- 
1.9.1

