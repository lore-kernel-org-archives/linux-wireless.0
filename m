Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753132AbeBSPab (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:31 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/14] staging: wilc1000: rename pstrRcvdGnrlAsyncInfo to avoid camelCase
Date: Mon, 19 Feb 2018 20:59:37 +0530
Message-ID: <1519054184-14301-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163046_591607_99AA2BFD)
In-Reply-To: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
References: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f685da2..d489b27 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1319,7 +1319,7 @@ static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 				       u32 *rcvd_assoc_resp_info_len);
 
 static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
-				    struct rcvd_async_info *pstrRcvdGnrlAsyncInfo)
+				    struct rcvd_async_info *rcvd_info)
 {
 	s32 result = 0;
 	u8 u8MsgType = 0;
@@ -1343,26 +1343,26 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 	if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP ||
 	    hif_drv->hif_state == HOST_IF_CONNECTED ||
 	    hif_drv->usr_scan_req.scan_result) {
-		if (!pstrRcvdGnrlAsyncInfo->buffer ||
+		if (!rcvd_info->buffer ||
 		    !hif_drv->usr_conn_req.conn_result) {
 			netdev_err(vif->ndev, "driver is null\n");
 			return -EINVAL;
 		}
 
-		u8MsgType = pstrRcvdGnrlAsyncInfo->buffer[0];
+		u8MsgType = rcvd_info->buffer[0];
 
 		if ('I' != u8MsgType) {
 			netdev_err(vif->ndev, "Received Message incorrect.\n");
 			return -EFAULT;
 		}
 
-		u8MsgID = pstrRcvdGnrlAsyncInfo->buffer[1];
-		u16MsgLen = MAKE_WORD16(pstrRcvdGnrlAsyncInfo->buffer[2], pstrRcvdGnrlAsyncInfo->buffer[3]);
-		u16WidID = MAKE_WORD16(pstrRcvdGnrlAsyncInfo->buffer[4], pstrRcvdGnrlAsyncInfo->buffer[5]);
-		u8WidLen = pstrRcvdGnrlAsyncInfo->buffer[6];
-		u8MacStatus  = pstrRcvdGnrlAsyncInfo->buffer[7];
-		u8MacStatusReasonCode = pstrRcvdGnrlAsyncInfo->buffer[8];
-		u8MacStatusAdditionalInfo = pstrRcvdGnrlAsyncInfo->buffer[9];
+		u8MsgID = rcvd_info->buffer[1];
+		u16MsgLen = MAKE_WORD16(rcvd_info->buffer[2], rcvd_info->buffer[3]);
+		u16WidID = MAKE_WORD16(rcvd_info->buffer[4], rcvd_info->buffer[5]);
+		u8WidLen = rcvd_info->buffer[6];
+		u8MacStatus  = rcvd_info->buffer[7];
+		u8MacStatusReasonCode = rcvd_info->buffer[8];
+		u8MacStatusAdditionalInfo = rcvd_info->buffer[9];
 		if (hif_drv->hif_state == HOST_IF_WAITING_CONN_RESP) {
 			u32 u32RcvdAssocRespInfoLen = 0;
 			struct connect_resp_info *pstrConnectRespInfo = NULL;
@@ -1519,8 +1519,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 		}
 	}
 
-	kfree(pstrRcvdGnrlAsyncInfo->buffer);
-	pstrRcvdGnrlAsyncInfo->buffer = NULL;
+	kfree(rcvd_info->buffer);
+	rcvd_info->buffer = NULL;
 
 	return result;
 }
-- 
2.7.4
