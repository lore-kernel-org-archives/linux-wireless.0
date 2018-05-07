Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:6902 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752277AbeEGIn4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:43:56 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 05/30] staging: wilc1000: fix line over 80 chars in host_int_parse_assoc_resp_info()
Date: Mon, 7 May 2018 14:13:09 +0530
Message-ID: <1525682614-3824-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104402_203999_8E9AE1CD)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix line over 80 characters issue reported by checkpatch.pl in
host_int_parse_assoc_resp_info().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 37 ++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 55a61d5..a341ff1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1293,6 +1293,23 @@ static inline void host_int_free_user_conn_req(struct host_if_drv *hif_drv)
 	hif_drv->usr_conn_req.ies = NULL;
 }
 
+static void host_int_copy_conn_info(struct connect_resp_info *conn_resp_info,
+				    struct connect_info *conn_info)
+{
+	conn_info->status = conn_resp_info->status;
+
+	if (conn_info->status == SUCCESSFUL_STATUSCODE && conn_resp_info->ies) {
+		conn_info->resp_ies = kmemdup(conn_resp_info->ies,
+					      conn_resp_info->ies_len,
+					      GFP_KERNEL);
+		if (conn_info->resp_ies)
+			conn_info->resp_ies_len = conn_resp_info->ies_len;
+	}
+
+	kfree(conn_resp_info->ies);
+	kfree(conn_resp_info);
+}
+
 static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 						  u8 mac_status)
 {
@@ -1316,25 +1333,13 @@ static inline void host_int_parse_assoc_resp_info(struct wilc_vif *vif,
 
 			err = wilc_parse_assoc_resp_info(rcv_assoc_resp, rcvd_assoc_resp_info_len,
 							 &connect_resp_info);
-			if (err) {
+			if (err)
 				netdev_err(vif->ndev,
 					   "wilc_parse_assoc_resp_info() returned error %d\n",
 					   err);
-			} else {
-				conn_info.status = connect_resp_info->status;
-
-				if (conn_info.status == SUCCESSFUL_STATUSCODE &&
-				    connect_resp_info->ies) {
-					conn_info.resp_ies = kmemdup(connect_resp_info->ies,
-								     connect_resp_info->ies_len,
-								     GFP_KERNEL);
-					if (conn_info.resp_ies)
-						conn_info.resp_ies_len = connect_resp_info->ies_len;
-				}
-
-				kfree(connect_resp_info->ies);
-				kfree(connect_resp_info);
-			}
+			else
+				host_int_copy_conn_info(connect_resp_info,
+							&conn_info);
 		}
 	}
 
-- 
2.7.4
