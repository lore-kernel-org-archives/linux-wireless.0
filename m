Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13714 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbbI3JqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:46:17 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 03/32] staging: wilc1000: rename strHostIFscanAttr
Date: Wed, 30 Sep 2015 18:44:20 +0900
Message-ID: <1443606289-25407-3-git-send-email-tony.cho@atmel.com> (sfid-20150930_114620_153248_4DD7CDA1)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIFscanAttr to scan_info in order to avoid
CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index be01de5..a039f04 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -414,7 +414,7 @@ struct sta_inactive_t {
  *  @version		1.0
  */
 union message_body {
-	struct scan_attr strHostIFscanAttr;
+	struct scan_attr scan_info;
 	struct connect_attr strHostIFconnectAttr;
 	struct rcvd_net_info strRcvdNetworkInfo;
 	struct rcvd_async_info strRcvdGnrlAsyncInfo;
@@ -4099,7 +4099,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SCAN:
-			Handle_Scan(msg.drvHandler, &msg.body.strHostIFscanAttr);
+			Handle_Scan(msg.drvHandler, &msg.body.scan_info);
 			break;
 
 		case HOST_IF_MSG_CONNECT:
@@ -5789,26 +5789,26 @@ s32 host_int_scan(tstrWILC_WFIDrv *hWFIDrv, u8 u8ScanSource,
 	msg.id = HOST_IF_MSG_SCAN;
 
 	if (pstrHiddenNetwork != NULL) {
-		msg.body.strHostIFscanAttr.strHiddenNetwork.pstrHiddenNetworkInfo = pstrHiddenNetwork->pstrHiddenNetworkInfo;
-		msg.body.strHostIFscanAttr.strHiddenNetwork.u8ssidnum = pstrHiddenNetwork->u8ssidnum;
+		msg.body.scan_info.strHiddenNetwork.pstrHiddenNetworkInfo = pstrHiddenNetwork->pstrHiddenNetworkInfo;
+		msg.body.scan_info.strHiddenNetwork.u8ssidnum = pstrHiddenNetwork->u8ssidnum;
 
 	} else
 		PRINT_D(HOSTINF_DBG, "pstrHiddenNetwork IS EQUAL TO NULL\n");
 
 	msg.drvHandler = hWFIDrv;
-	msg.body.strHostIFscanAttr.u8ScanSource = u8ScanSource;
-	msg.body.strHostIFscanAttr.u8ScanType = u8ScanType;
-	msg.body.strHostIFscanAttr.pfScanResult = ScanResult;
-	msg.body.strHostIFscanAttr.pvUserArg = pvUserArg;
-
-	msg.body.strHostIFscanAttr.u8ChnlListLen = u8ChnlListLen;
-	msg.body.strHostIFscanAttr.pu8ChnlFreqList = kmalloc(u8ChnlListLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
-	memcpy(msg.body.strHostIFscanAttr.pu8ChnlFreqList,
+	msg.body.scan_info.u8ScanSource = u8ScanSource;
+	msg.body.scan_info.u8ScanType = u8ScanType;
+	msg.body.scan_info.pfScanResult = ScanResult;
+	msg.body.scan_info.pvUserArg = pvUserArg;
+
+	msg.body.scan_info.u8ChnlListLen = u8ChnlListLen;
+	msg.body.scan_info.pu8ChnlFreqList = kmalloc(u8ChnlListLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
+	memcpy(msg.body.scan_info.pu8ChnlFreqList,
 		    pu8ChnlFreqList, u8ChnlListLen);
 
-	msg.body.strHostIFscanAttr.IEsLen = IEsLen;
-	msg.body.strHostIFscanAttr.pu8IEs = kmalloc(IEsLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
-	memcpy(msg.body.strHostIFscanAttr.pu8IEs,
+	msg.body.scan_info.IEsLen = IEsLen;
+	msg.body.scan_info.pu8IEs = kmalloc(IEsLen, GFP_KERNEL);        /* will be deallocated by the receiving thread */
+	memcpy(msg.body.scan_info.pu8IEs,
 		    pu8IEs, IEsLen);
 
 	/* send the message */
-- 
1.9.1

