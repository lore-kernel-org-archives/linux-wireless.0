Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2701 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbbJMKv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:51:56 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/54] staging: wilc1000: rename u8ScanSource of struct scan_attr
Date: Tue, 13 Oct 2015 19:49:37 +0900
Message-ID: <1444733419-17679-12-git-send-email-tony.cho@atmel.com> (sfid-20151013_125158_765942_5DE9414E)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8ScanSource of struct scan_attr to src to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 14a01ce..9180ea6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -96,7 +96,7 @@ struct key_attr {
 };
 
 struct scan_attr {
-	u8 u8ScanSource;
+	u8 src;
 	u8 u8ScanType;
 	u8 *pu8ChnlFreqList;
 	u8 u8ChnlListLen;
@@ -921,7 +921,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].id = WID_START_SCAN_REQ;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)(&(pstrHostIFscanAttr->u8ScanSource));
+	strWIDList[u32WidsCount].val = (s8 *)(&(pstrHostIFscanAttr->src));
 	u32WidsCount++;
 
 	if (hif_drv->enuHostIFstate == HOST_IF_CONNECTED)
@@ -4062,7 +4062,7 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 		PRINT_D(HOSTINF_DBG, "pstrHiddenNetwork IS EQUAL TO NULL\n");
 
 	msg.drv = hif_drv;
-	msg.body.scan_info.u8ScanSource = u8ScanSource;
+	msg.body.scan_info.src = u8ScanSource;
 	msg.body.scan_info.u8ScanType = u8ScanType;
 	msg.body.scan_info.pfScanResult = ScanResult;
 	msg.body.scan_info.pvUserArg = pvUserArg;
-- 
1.9.1

