Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21168 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbbIUDSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:18:31 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 10/34] staging: wilc1000: remove typedef from the struct tstrRcvdGnrlAsyncInfo
Date: Mon, 21 Sep 2015 12:16:39 +0900
Message-ID: <1442805423-3711-11-git-send-email-tony.cho@atmel.com> (sfid-20150921_051833_860486_420A47C4)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrRcvdGnrlAsyncInfo and
renames it to rcvd_async_info in order to comply with the Linux coding
style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 256369c..1706bef 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -201,7 +201,7 @@ struct connect_attr {
 };
 
 /*!
- *  @struct             tstrRcvdGnrlAsyncInfo
+ *  @struct             rcvd_async_info
  *  @brief		Structure to hold Received General Asynchronous info
  *  @details
  *  @todo
@@ -210,10 +210,10 @@ struct connect_attr {
  *  @date		25 March 2012
  *  @version		1.0
  */
-typedef struct _tstrRcvdGnrlAsyncInfo {
+struct rcvd_async_info {
 	u8 *pu8Buffer;
 	u32 u32Length;
-} tstrRcvdGnrlAsyncInfo;
+};
 
 /*!
  *  @struct             tstrHostIFSetChan
@@ -420,7 +420,7 @@ union message_body {
 	struct scan_attr strHostIFscanAttr;                           /*!< Host IF Scan Request Attributes message body */
 	struct connect_attr strHostIFconnectAttr;     /*!< Host IF Connect Request Attributes message body */
 	struct rcvd_net_info strRcvdNetworkInfo;                 /*!< Received Asynchronous Network Info message body */
-	tstrRcvdGnrlAsyncInfo strRcvdGnrlAsyncInfo;     /*!< Received General Asynchronous Info message body */
+	struct rcvd_async_info strRcvdGnrlAsyncInfo;     /*!< Received General Asynchronous Info message body */
 	tstrHostIFkeyAttr strHostIFkeyAttr;                             /*!<>*/
 	tstrHostIFCfgParamAttr strHostIFCfgParamAttr;            /*! <CFG Parameter message Body> */
 	tstrHostIFSetChan strHostIFSetChan;
@@ -2369,13 +2369,14 @@ done:
 /**
  *  @brief Handle_RcvdGnrlAsyncInfo
  *  @details       Handling received asynchrous general network information
- *  @param[in]    tstrRcvdGnrlAsyncInfo* pstrRcvdGnrlAsyncInfo
+ *  @param[in]     struct rcvd_async_info *pstrRcvdGnrlAsyncInfo
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsyncInfo *pstrRcvdGnrlAsyncInfo)
+static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler,
+				    struct rcvd_async_info *pstrRcvdGnrlAsyncInfo)
 {
 	/* TODO: mostafa: till now, this function just handles only the received mac status msg, */
 	/*				 which carries only 1 WID which have WID ID = WID_STATUS */
-- 
1.9.1

