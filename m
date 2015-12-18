Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36484 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966146AbbLRJWL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 04:22:11 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH] staging: wilc1000: fix a bug when unload driver
Date: Fri, 18 Dec 2015 18:26:02 +0900
Message-ID: <1450430762-8462-1-git-send-email-glen.lee@atmel.com> (sfid-20151218_102607_877780_904826FC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kernel crashes when load and unload driver several times. I used git bisect to
track down and found that removing NULL setting caused the panic.
This reverts only related codes of the patch(a4ab1ade75a3).

Fixes: a4ab1ade75a3 ("staging: wilc1000: replace drvHandler and hWFIDrv with hif_drv")
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0125e3d..851560f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1366,9 +1366,12 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 
 	hif_drv->usr_conn_req.ssid_len = 0;
 	kfree(hif_drv->usr_conn_req.pu8ssid);
+	hif_drv->usr_conn_req.pu8ssid = NULL;
 	kfree(hif_drv->usr_conn_req.pu8bssid);
+	hif_drv->usr_conn_req.pu8bssid = NULL;
 	hif_drv->usr_conn_req.ies_len = 0;
 	kfree(hif_drv->usr_conn_req.ies);
+	hif_drv->usr_conn_req.ies = NULL;
 
 	eth_zero_addr(wilc_connected_ssid);
 
@@ -1624,9 +1627,12 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			strConnectInfo.pu8ReqIEs = NULL;
 			hif_drv->usr_conn_req.ssid_len = 0;
 			kfree(hif_drv->usr_conn_req.pu8ssid);
+			hif_drv->usr_conn_req.pu8ssid = NULL;
 			kfree(hif_drv->usr_conn_req.pu8bssid);
+			hif_drv->usr_conn_req.pu8bssid = NULL;
 			hif_drv->usr_conn_req.ies_len = 0;
 			kfree(hif_drv->usr_conn_req.ies);
+			hif_drv->usr_conn_req.ies = NULL;
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
 			   (hif_drv->hif_state == HOST_IF_CONNECTED)) {
 			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW\n");
@@ -1660,9 +1666,12 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 
 			hif_drv->usr_conn_req.ssid_len = 0;
 			kfree(hif_drv->usr_conn_req.pu8ssid);
+			hif_drv->usr_conn_req.pu8ssid = NULL;
 			kfree(hif_drv->usr_conn_req.pu8bssid);
+			hif_drv->usr_conn_req.pu8bssid = NULL;
 			hif_drv->usr_conn_req.ies_len = 0;
 			kfree(hif_drv->usr_conn_req.ies);
+			hif_drv->usr_conn_req.ies = NULL;
 
 			if (join_req && join_req_vif == vif) {
 				kfree(join_req);
@@ -2034,9 +2043,12 @@ static void Handle_Disconnect(struct wilc_vif *vif)
 
 		hif_drv->usr_conn_req.ssid_len = 0;
 		kfree(hif_drv->usr_conn_req.pu8ssid);
+		hif_drv->usr_conn_req.pu8ssid = NULL;
 		kfree(hif_drv->usr_conn_req.pu8bssid);
+		hif_drv->usr_conn_req.pu8bssid = NULL;
 		hif_drv->usr_conn_req.ies_len = 0;
 		kfree(hif_drv->usr_conn_req.ies);
+		hif_drv->usr_conn_req.ies = NULL;
 
 		if (join_req && join_req_vif == vif) {
 			kfree(join_req);
-- 
1.9.1

