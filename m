Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:12651 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbbJLH6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 03:58:12 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 15/41] staging: wilc1000: remove typedef from tstrJoinBssParam
Date: Mon, 12 Oct 2015 16:55:49 +0900
Message-ID: <1444636575-2486-15-git-send-email-tony.cho@atmel.com> (sfid-20151012_095820_962616_A7A42EBE)
In-Reply-To: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
References: <1444636575-2486-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrJoinBssParam
and renames it to join_bss_param.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 89b6cdd..0d83351 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -407,7 +407,7 @@ struct host_if_msg {
 };
 
 /*Struct containg joinParam of each AP*/
-typedef struct _tstrJoinBssParam {
+struct join_bss_param {
 	BSSTYPE_T bss_type;
 	u8 dtim_period;
 	u16 beacon_period;
@@ -435,7 +435,7 @@ typedef struct _tstrJoinBssParam {
 	u8 au8Duration[4];
 	u8 au8Interval[4];
 	u8 au8StartTime[4];
-} tstrJoinBssParam;
+};
 
 typedef enum {
 	SCAN_TIMER = 0,
@@ -1438,7 +1438,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 	u32 u32WidsCount = 0, dummyval = 0;
 	/* char passphrase[] = "12345678"; */
 	u8 *pu8CurrByte = NULL;
-	tstrJoinBssParam *ptstrJoinBssParam;
+	struct join_bss_param *ptstrJoinBssParam;
 
 	PRINT_D(GENERIC_DBG, "Handling connect request\n");
 
@@ -1453,7 +1453,7 @@ static s32 Handle_Connect(struct host_if_drv *drvHandler,
 
 	PRINT_INFO(HOSTINF_DBG, "Saving connection parameters in global structure\n");
 
-	ptstrJoinBssParam = (tstrJoinBssParam *)pstrHostIFconnectAttr->pJoinParams;
+	ptstrJoinBssParam = (struct join_bss_param *)pstrHostIFconnectAttr->pJoinParams;
 	if (ptstrJoinBssParam == NULL) {
 		PRINT_ER("Required BSSID not found\n");
 		s32Error = -ENOENT;
@@ -6700,7 +6700,7 @@ s32 host_int_setup_multicast_filter(struct host_if_drv *hWFIDrv, bool bIsEnabled
  *  @version		1.0**/
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 {
-	tstrJoinBssParam *pNewJoinBssParam = NULL;
+	struct join_bss_param *pNewJoinBssParam = NULL;
 	u8 *pu8IEs;
 	u16 u16IEsLen;
 	u16 index = 0;
@@ -6716,9 +6716,9 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 	pu8IEs = ptstrNetworkInfo->pu8IEs;
 	u16IEsLen = ptstrNetworkInfo->u16IEsLen;
 
-	pNewJoinBssParam = kmalloc(sizeof(tstrJoinBssParam), GFP_KERNEL);
+	pNewJoinBssParam = kmalloc(sizeof(struct join_bss_param), GFP_KERNEL);
 	if (pNewJoinBssParam != NULL) {
-		memset(pNewJoinBssParam, 0, sizeof(tstrJoinBssParam));
+		memset(pNewJoinBssParam, 0, sizeof(struct join_bss_param));
 		pNewJoinBssParam->dtim_period = ptstrNetworkInfo->u8DtimPeriod;
 		pNewJoinBssParam->beacon_period = ptstrNetworkInfo->u16BeaconPeriod;
 		pNewJoinBssParam->cap_info = ptstrNetworkInfo->u16CapInfo;
@@ -6902,8 +6902,8 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 
 void host_int_freeJoinParams(void *pJoinParams)
 {
-	if ((tstrJoinBssParam *)pJoinParams != NULL)
-		kfree((tstrJoinBssParam *)pJoinParams);
+	if ((struct bss_param *)pJoinParams != NULL)
+		kfree((struct bss_param *)pJoinParams);
 	else
 		PRINT_ER("Unable to FREE null pointer\n");
 }
-- 
1.9.1

