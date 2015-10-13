Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2729 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbbJMKwC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:52:02 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/54] staging: wilc1000: rename u8ScanType of struct scan_attr
Date: Tue, 13 Oct 2015 19:49:38 +0900
Message-ID: <1444733419-17679-13-git-send-email-tony.cho@atmel.com> (sfid-20151013_125206_878186_F43EA6AD)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8ScanType of struct scan_attr to type to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9180ea6..b7eb272 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -97,7 +97,7 @@ struct key_attr {
 
 struct scan_attr {
 	u8 src;
-	u8 u8ScanType;
+	u8 type;
 	u8 *pu8ChnlFreqList;
 	u8 u8ChnlListLen;
 	u8 *pu8IEs;
@@ -899,7 +899,7 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].id = WID_SCAN_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)(&(pstrHostIFscanAttr->u8ScanType));
+	strWIDList[u32WidsCount].val = (s8 *)(&(pstrHostIFscanAttr->type));
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = WID_SCAN_CHANNEL_LIST;
@@ -4063,7 +4063,7 @@ s32 host_int_scan(struct host_if_drv *hif_drv, u8 u8ScanSource,
 
 	msg.drv = hif_drv;
 	msg.body.scan_info.src = u8ScanSource;
-	msg.body.scan_info.u8ScanType = u8ScanType;
+	msg.body.scan_info.type = u8ScanType;
 	msg.body.scan_info.pfScanResult = ScanResult;
 	msg.body.scan_info.pvUserArg = pvUserArg;
 
-- 
1.9.1

