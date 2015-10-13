Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2829 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235AbbJMKw1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:52:27 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 17/54] staging: wilc1000: rename pu8IEs of struct scan_attr
Date: Tue, 13 Oct 2015 19:49:42 +0900
Message-ID: <1444733419-17679-17-git-send-email-tony.cho@atmel.com> (sfid-20151013_125230_516087_8EB664B2)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8IEs of struct scan_attr to ies to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 205be22..4a33d16 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -100,7 +100,7 @@ struct scan_attr {
 	u8 type;
 	u8 *ch_freq_list;
 	u8 ch_list_len;
-	u8 *pu8IEs;
+	u8 *ies;
 	size_t IEsLen;
 	wilc_scan_result pfScanResult;
 	void *pvUserArg;
@@ -891,7 +891,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	{
 		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_PROBE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
-		strWIDList[u32WidsCount].val = pstrHostIFscanAttr->pu8IEs;
+		strWIDList[u32WidsCount].val = pstrHostIFscanAttr->ies;
 		strWIDList[u32WidsCount].size = pstrHostIFscanAttr->IEsLen;
 		u32WidsCount++;
 	}
@@ -948,9 +948,9 @@ ERRORHANDLER:
 		pstrHostIFscanAttr->ch_freq_list = NULL;
 	}
 
-	if (pstrHostIFscanAttr->pu8IEs != NULL)	{
-		kfree(pstrHostIFscanAttr->pu8IEs);
-		pstrHostIFscanAttr->pu8IEs = NULL;
+	if (pstrHostIFscanAttr->ies != NULL) {
+		kfree(pstrHostIFscanAttr->ies);
+		pstrHostIFscanAttr->ies = NULL;
 	}
 	if (pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo != NULL)	{
 		kfree(pstrHostIFscanAttr->strHiddenNetwork.pstrHiddenNetworkInfo);
@@ -4067,9 +4067,8 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	memcpy(msg.body.scan_info.ch_freq_list, pu8ChnlFreqList, u8ChnlListLen);
 
 	msg.body.scan_info.IEsLen = IEsLen;
-	msg.body.scan_info.pu8IEs = kmalloc(IEsLen, GFP_KERNEL);
-	memcpy(msg.body.scan_info.pu8IEs,
-		    pu8IEs, IEsLen);
+	msg.body.scan_info.ies = kmalloc(IEsLen, GFP_KERNEL);
+	memcpy(msg.body.scan_info.ies, pu8IEs, IEsLen);
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error) {
-- 
1.9.1

