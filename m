Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45120 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbbIRJMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:12:42 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/34] staging: wilc1000: remove typedef from the struct tstrHostIFconnectAttr
Date: Fri, 18 Sep 2015 18:11:10 +0900
Message-ID: <1442567496-29331-8-git-send-email-tony.cho@atmel.com> (sfid-20150918_111246_125784_9B61BA49)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIFconnectAttr and
renames it to connect_attr to comply with the Linux coding style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4a02e10..7f1b801 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -178,7 +178,7 @@ struct scan_attr {
 };
 
 /*!
- *  @struct             tstrHostIFconnectAttr
+ *  @struct             connect_attr
  *  @brief		Structure to hold Host IF Connect Attributes
  *  @details
  *  @todo
@@ -187,7 +187,7 @@ struct scan_attr {
  *  @date		25 March 2012
  *  @version		1.0
  */
-typedef struct _tstrHostIFconnectAttr {
+struct connect_attr {
 	u8 *pu8bssid;
 	u8 *pu8ssid;
 	size_t ssidLen;
@@ -199,7 +199,7 @@ typedef struct _tstrHostIFconnectAttr {
 	AUTHTYPE_T tenuAuth_type;
 	u8 u8channel;
 	void *pJoinParams;
-} tstrHostIFconnectAttr;
+};
 
 /*!
  *  @struct             tstrRcvdGnrlAsyncInfo
@@ -419,7 +419,7 @@ typedef struct {
  */
 union message_body {
 	struct scan_attr strHostIFscanAttr;                           /*!< Host IF Scan Request Attributes message body */
-	tstrHostIFconnectAttr strHostIFconnectAttr;     /*!< Host IF Connect Request Attributes message body */
+	struct connect_attr strHostIFconnectAttr;     /*!< Host IF Connect Request Attributes message body */
 	tstrRcvdNetworkInfo strRcvdNetworkInfo;                 /*!< Received Asynchronous Network Info message body */
 	tstrRcvdGnrlAsyncInfo strRcvdGnrlAsyncInfo;     /*!< Received General Asynchronous Info message body */
 	tstrHostIFkeyAttr strHostIFkeyAttr;                             /*!<>*/
@@ -1512,14 +1512,15 @@ static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent)
 /**
  *  @brief Handle_Connect
  *  @details       Sending config packet to firmware to starting connection
- *  @param[in]    tstrHostIFconnectAttr* pstrHostIFconnectAttr
+ *  @param[in]    struct connect_attr *pstrHostIFconnectAttr
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
 u8 u8ConnectedSSID[6] = {0};
-static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler, tstrHostIFconnectAttr *pstrHostIFconnectAttr)
+static s32 Handle_Connect(tstrWILC_WFIDrv *drvHandler,
+			  struct connect_attr *pstrHostIFconnectAttr)
 {
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
 	s32 s32Error = 0;
-- 
1.9.1

