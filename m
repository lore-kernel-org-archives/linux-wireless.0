Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2779 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbbJMKwP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:52:15 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/54] staging: wilc1000: rename pu8ChnlFreqList of struct scan_attr
Date: Tue, 13 Oct 2015 19:49:40 +0900
Message-ID: <1444733419-17679-15-git-send-email-tony.cho@atmel.com> (sfid-20151013_125217_671189_5AB855DD)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8ChnlFreqList of struct scan_attr to ch_freq_list to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1e2a4ec..49097ad 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -98,7 +98,7 @@ struct key_attr {
 struct scan_attr {
 	u8 src;
 	u8 type;
-	u8 *pu8ChnlFreqList;
+	u8 *ch_freq_list;
 	u8 u8ChnlListLen;
 	u8 *pu8IEs;
 	size_t IEsLen;
@@ -905,16 +905,16 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].id = WID_SCAN_CHANNEL_LIST;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
 
-	if (pstrHostIFscanAttr->pu8ChnlFreqList != NULL && pstrHostIFscanAttr->u8ChnlListLen > 0) {
+	if (pstrHostIFscanAttr->ch_freq_list != NULL && pstrHostIFscanAttr->u8ChnlListLen > 0) {
 		int i;
 
 		for (i = 0; i < pstrHostIFscanAttr->u8ChnlListLen; i++)	{
-			if (pstrHostIFscanAttr->pu8ChnlFreqList[i] > 0)
-				pstrHostIFscanAttr->pu8ChnlFreqList[i] = pstrHostIFscanAttr->pu8ChnlFreqList[i] - 1;
+			if (pstrHostIFscanAttr->ch_freq_list[i] > 0)
+				pstrHostIFscanAttr->ch_freq_list[i] = pstrHostIFscanAttr->ch_freq_list[i] - 1;
 		}
 	}
 
-	strWIDList[u32WidsCount].val = pstrHostIFscanAttr->pu8ChnlFreqList;
+	strWIDList[u32WidsCount].val = pstrHostIFscanAttr->ch_freq_list;
 	strWIDList[u32WidsCount].size = pstrHostIFscanAttr->u8ChnlListLen;
 	u32WidsCount++;
 
@@ -943,9 +943,9 @@ ERRORHANDLER:
 		Handle_ScanDone(hif_drv, SCAN_EVENT_ABORTED);
 	}
 
-	if (pstrHostIFscanAttr->pu8ChnlFreqList != NULL) {
-		kfree(pstrHostIFscanAttr->pu8ChnlFreqList);
-		pstrHostIFscanAttr->pu8ChnlFreqList = NULL;
+	if (pstrHostIFscanAttr->ch_freq_list != NULL) {
+		kfree(pstrHostIFscanAttr->ch_freq_list);
+		pstrHostIFscanAttr->ch_freq_list = NULL;
 	}
 
 	if (pstrHostIFscanAttr->pu8IEs != NULL)	{
@@ -4063,9 +4063,8 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	msg.body.scan_info.pvUserArg = pvUserArg;
 
 	msg.body.scan_info.u8ChnlListLen = u8ChnlListLen;
-	msg.body.scan_info.pu8ChnlFreqList = kmalloc(u8ChnlListLen, GFP_KERNEL);
-	memcpy(msg.body.scan_info.pu8ChnlFreqList,
-		    pu8ChnlFreqList, u8ChnlListLen);
+	msg.body.scan_info.ch_freq_list = kmalloc(u8ChnlListLen, GFP_KERNEL);
+	memcpy(msg.body.scan_info.ch_freq_list, pu8ChnlFreqList, u8ChnlListLen);
 
 	msg.body.scan_info.IEsLen = IEsLen;
 	msg.body.scan_info.pu8IEs = kmalloc(IEsLen, GFP_KERNEL);
-- 
1.9.1

