Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21145 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbbIUDSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:18:25 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 09/34] staging: wilc1000: remove typedef from the struct tstrRcvdNetworkInfo
Date: Mon, 21 Sep 2015 12:16:38 +0900
Message-ID: <1442805423-3711-10-git-send-email-tony.cho@atmel.com> (sfid-20150921_051827_414108_5B76A943)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrRcvdNetworkInfo and
renames it to rcvd_net_info in order to comply with the Linux coding
style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 7 ++++---
 drivers/staging/wilc1000/host_interface.h | 6 +++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a3015b1..256369c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -419,7 +419,7 @@ typedef struct {
 union message_body {
 	struct scan_attr strHostIFscanAttr;                           /*!< Host IF Scan Request Attributes message body */
 	struct connect_attr strHostIFconnectAttr;     /*!< Host IF Connect Request Attributes message body */
-	tstrRcvdNetworkInfo strRcvdNetworkInfo;                 /*!< Received Asynchronous Network Info message body */
+	struct rcvd_net_info strRcvdNetworkInfo;                 /*!< Received Asynchronous Network Info message body */
 	tstrRcvdGnrlAsyncInfo strRcvdGnrlAsyncInfo;     /*!< Received General Asynchronous Info message body */
 	tstrHostIFkeyAttr strHostIFkeyAttr;                             /*!<>*/
 	tstrHostIFCfgParamAttr strHostIFCfgParamAttr;            /*! <CFG Parameter message Body> */
@@ -2250,13 +2250,14 @@ static s32 Handle_ConnectTimeout(tstrWILC_WFIDrv *drvHandler)
 /**
  *  @brief Handle_RcvdNtwrkInfo
  *  @details       Handling received network information
- *  @param[in]    tstrRcvdNetworkInfo* pstrRcvdNetworkInfo
+ *  @param[in]    struct rcvd_net_info *pstrRcvdNetworkInfo
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdNetworkInfo *pstrRcvdNetworkInfo)
+static s32 Handle_RcvdNtwrkInfo(tstrWILC_WFIDrv *drvHandler,
+				struct rcvd_net_info *pstrRcvdNetworkInfo)
 {
 	u32 i;
 	bool bNewNtwrkFound;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c1a9cce..537845e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -202,7 +202,7 @@ typedef struct {
 } *WILC_WFIDrvHandle;
 
 /*!
- *  @struct             tstrRcvdNetworkInfo
+ *  @struct             rcvd_net_info
  *  @brief		Structure to hold Received Asynchronous Network info
  *  @details
  *  @todo
@@ -211,10 +211,10 @@ typedef struct {
  *  @date		25 March 2012
  *  @version		1.0
  */
-typedef struct _tstrRcvdNetworkInfo {
+struct rcvd_net_info {
 	u8 *pu8Buffer;
 	u32 u32Length;
-} tstrRcvdNetworkInfo;
+};
 
 typedef struct _tstrHiddenNetworkInfo {
 	u8  *pu8ssid;
-- 
1.9.1

