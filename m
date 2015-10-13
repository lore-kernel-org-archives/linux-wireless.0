Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2919 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbbJMKwx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:52:53 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 21/54] staging: wilc1000: rename strHiddenNetwork of struct scan_attr
Date: Tue, 13 Oct 2015 19:49:46 +0900
Message-ID: <1444733419-17679-21-git-send-email-tony.cho@atmel.com> (sfid-20151013_125256_496704_E305EC1E)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames strHiddenNetwork of struct scan_attr to hidden_network to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6926a9e..506c73f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -104,7 +104,7 @@ struct scan_attr {
 	size_t ies_len;
 	wilc_scan_result result;
 	void *arg;
-	struct hidden_network strHiddenNetwork;
+	struct hidden_network hidden_network;
 };
 
 struct connect_attr {
@@ -865,21 +865,21 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].id = (u16)WID_SSID_PROBE_REQ;
 	strWIDList[u32WidsCount].type = WID_STR;
 
-	for (i = 0; i < pstrHostIFscanAttr->strHiddenNetwork.u8ssidnum; i++)
-		valuesize += ((pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen) + 1);
+	for (i = 0; i < pstrHostIFscanAttr->hidden_network.u8ssidnum; i++)
+		valuesize += ((pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen) + 1);
 	pu8HdnNtwrksWidVal = kmalloc(valuesize + 1, GFP_KERNEL);
 	strWIDList[u32WidsCount].val = pu8HdnNtwrksWidVal;
 	if (strWIDList[u32WidsCount].val != NULL) {
 		pu8Buffer = strWIDList[u32WidsCount].val;
 
-		*pu8Buffer++ = pstrHostIFscanAttr->strHiddenNetwork.u8ssidnum;
+		*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.u8ssidnum;
 
-		PRINT_D(HOSTINF_DBG, "In Handle_ProbeRequest number of ssid %d\n", pstrHostIFscanAttr->strHiddenNetwork.u8ssidnum);
+		PRINT_D(HOSTINF_DBG, "In Handle_ProbeRequest number of ssid %d\n", pstrHostIFscanAttr->hidden_network.u8ssidnum);
 
-		for (i = 0; i < pstrHostIFscanAttr->strHiddenNetwork.u8ssidnum; i++) {
-			*pu8Buffer++ = pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen;
-			memcpy(pu8Buffer, pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].pu8ssid, pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen);
-			pu8Buffer += pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo[i].u8ssidlen;
+		for (i = 0; i < pstrHostIFscanAttr->hidden_network.u8ssidnum; i++) {
+			*pu8Buffer++ = pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen;
+			memcpy(pu8Buffer, pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].pu8ssid, pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen);
+			pu8Buffer += pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo[i].u8ssidlen;
 		}
 
 
@@ -952,9 +952,9 @@ ERRORHANDLER:
 		kfree(pstrHostIFscanAttr->ies);
 		pstrHostIFscanAttr->ies = NULL;
 	}
-	if (pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo != NULL)	{
-		kfree(pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo);
-		pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo = NULL;
+	if (pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo != NULL)	{
+		kfree(pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo);
+		pstrHostIFscanAttr->hidden_network.pstrHiddenNetworkInfo = NULL;
 	}
 
 	if (pu8HdnNtwrksWidVal != NULL)
@@ -4050,8 +4050,8 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	msg.id = HOST_IF_MSG_SCAN;
 
 	if (pstrHiddenNetwork != NULL) {
-		msg.body.scan_info.strHiddenNetwork.pstrHiddenNetworkInfo = pstrHiddenNetwork->pstrHiddenNetworkInfo;
-		msg.body.scan_info.strHiddenNetwork.u8ssidnum = pstrHiddenNetwork->u8ssidnum;
+		msg.body.scan_info.hidden_network.pstrHiddenNetworkInfo = pstrHiddenNetwork->pstrHiddenNetworkInfo;
+		msg.body.scan_info.hidden_network.u8ssidnum = pstrHiddenNetwork->u8ssidnum;
 
 	} else
 		PRINT_D(HOSTINF_DBG, "pstrHiddenNetwork IS EQUAL TO NULL\n");
-- 
1.9.1

