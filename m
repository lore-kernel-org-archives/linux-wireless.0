Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2812 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbbJMKwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:52:21 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/54] staging: wilc1000: rename u8ChnlListLen of struct scan_attr
Date: Tue, 13 Oct 2015 19:49:41 +0900
Message-ID: <1444733419-17679-16-git-send-email-tony.cho@atmel.com> (sfid-20151013_125223_766583_2452A6F7)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8ChnlListLen of struct scan_attr to ch_list_len to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 49097ad..205be22 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -99,7 +99,7 @@ struct scan_attr {
 	u8 src;
 	u8 type;
 	u8 *ch_freq_list;
-	u8 u8ChnlListLen;
+	u8 ch_list_len;
 	u8 *pu8IEs;
 	size_t IEsLen;
 	wilc_scan_result pfScanResult;
@@ -905,17 +905,17 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].id = WID_SCAN_CHANNEL_LIST;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
 
-	if (pstrHostIFscanAttr->ch_freq_list != NULL && pstrHostIFscanAttr->u8ChnlListLen > 0) {
+	if (pstrHostIFscanAttr->ch_freq_list != NULL && pstrHostIFscanAttr->ch_list_len > 0) {
 		int i;
 
-		for (i = 0; i < pstrHostIFscanAttr->u8ChnlListLen; i++)	{
+		for (i = 0; i < pstrHostIFscanAttr->ch_list_len; i++)	{
 			if (pstrHostIFscanAttr->ch_freq_list[i] > 0)
 				pstrHostIFscanAttr->ch_freq_list[i] = pstrHostIFscanAttr->ch_freq_list[i] - 1;
 		}
 	}
 
 	strWIDList[u32WidsCount].val = pstrHostIFscanAttr->ch_freq_list;
-	strWIDList[u32WidsCount].size = pstrHostIFscanAttr->u8ChnlListLen;
+	strWIDList[u32WidsCount].size = pstrHostIFscanAttr->ch_list_len;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_START_SCAN_REQ;
@@ -4062,7 +4062,7 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 	msg.body.scan_info.pfScanResult = ScanResult;
 	msg.body.scan_info.pvUserArg = pvUserArg;
 
-	msg.body.scan_info.u8ChnlListLen = u8ChnlListLen;
+	msg.body.scan_info.ch_list_len = u8ChnlListLen;
 	msg.body.scan_info.ch_freq_list = kmalloc(u8ChnlListLen, GFP_KERNEL);
 	memcpy(msg.body.scan_info.ch_freq_list, pu8ChnlFreqList, u8ChnlListLen);
 
-- 
1.9.1

