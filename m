Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13778 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbbI3Jqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:46:43 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/32] staging: wilc1000: rename strHostIFconnectAttr
Date: Wed, 30 Sep 2015 18:44:21 +0900
Message-ID: <1443606289-25407-4-git-send-email-tony.cho@atmel.com> (sfid-20150930_114646_219559_0B4A5461)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIFconnectAttr to con_info to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 32 +++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a039f04..96f0b69 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -415,7 +415,7 @@ struct sta_inactive_t {
  */
 union message_body {
 	struct scan_attr scan_info;
-	struct connect_attr strHostIFconnectAttr;
+	struct connect_attr con_info;
 	struct rcvd_net_info strRcvdNetworkInfo;
 	struct rcvd_async_info strRcvdGnrlAsyncInfo;
 	struct key_attr strHostIFkeyAttr;
@@ -4103,7 +4103,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_CONNECT:
-			Handle_Connect(msg.drvHandler, &msg.body.strHostIFconnectAttr);
+			Handle_Connect(msg.drvHandler, &msg.body.con_info);
 			break;
 
 		case HOST_IF_MSG_FLUSH_CONNECT:
@@ -5084,32 +5084,32 @@ s32 host_int_set_join_req(tstrWILC_WFIDrv *hWFIDrv, u8 *pu8bssid,
 
 	msg.id = HOST_IF_MSG_CONNECT;
 
-	msg.body.strHostIFconnectAttr.u8security = u8security;
-	msg.body.strHostIFconnectAttr.tenuAuth_type = tenuAuth_type;
-	msg.body.strHostIFconnectAttr.u8channel = u8channel;
-	msg.body.strHostIFconnectAttr.pfConnectResult = pfConnectResult;
-	msg.body.strHostIFconnectAttr.pvUserArg = pvUserArg;
-	msg.body.strHostIFconnectAttr.pJoinParams = pJoinParams;
+	msg.body.con_info.u8security = u8security;
+	msg.body.con_info.tenuAuth_type = tenuAuth_type;
+	msg.body.con_info.u8channel = u8channel;
+	msg.body.con_info.pfConnectResult = pfConnectResult;
+	msg.body.con_info.pvUserArg = pvUserArg;
+	msg.body.con_info.pJoinParams = pJoinParams;
 	msg.drvHandler = hWFIDrv;
 
 	if (pu8bssid != NULL) {
-		msg.body.strHostIFconnectAttr.pu8bssid = kmalloc(6, GFP_KERNEL); /* will be deallocated by the receiving thread */
-		memcpy(msg.body.strHostIFconnectAttr.pu8bssid,
+		msg.body.con_info.pu8bssid = kmalloc(6, GFP_KERNEL); /* will be deallocated by the receiving thread */
+		memcpy(msg.body.con_info.pu8bssid,
 			    pu8bssid, 6);
 	}
 
 	if (pu8ssid != NULL) {
-		msg.body.strHostIFconnectAttr.ssidLen = ssidLen;
-		msg.body.strHostIFconnectAttr.pu8ssid = kmalloc(ssidLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
-		memcpy(msg.body.strHostIFconnectAttr.pu8ssid,
+		msg.body.con_info.ssidLen = ssidLen;
+		msg.body.con_info.pu8ssid = kmalloc(ssidLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
+		memcpy(msg.body.con_info.pu8ssid,
 
 			    pu8ssid, ssidLen);
 	}
 
 	if (pu8IEs != NULL) {
-		msg.body.strHostIFconnectAttr.IEsLen = IEsLen;
-		msg.body.strHostIFconnectAttr.pu8IEs = kmalloc(IEsLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
-		memcpy(msg.body.strHostIFconnectAttr.pu8IEs,
+		msg.body.con_info.IEsLen = IEsLen;
+		msg.body.con_info.pu8IEs = kmalloc(IEsLen, GFP_KERNEL); /* will be deallocated by the receiving thread */
+		memcpy(msg.body.con_info.pu8IEs,
 			    pu8IEs, IEsLen);
 	}
 	if (pstrWFIDrv->enuHostIFstate < HOST_IF_CONNECTING)
-- 
1.9.1

