Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45093 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbbIRJMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:12:36 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/34] staging: wilc1000: remove typedef from the struct tstrHostIFscanAttr
Date: Fri, 18 Sep 2015 18:11:09 +0900
Message-ID: <1442567496-29331-7-git-send-email-tony.cho@atmel.com> (sfid-20150918_111241_162840_6FCFCA04)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the structure tstrHostIFscanAttr and
changes the camelcase name, tstrHostIFscanAttr to scan_attr in order to
comply with the Linux coding style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8b1aa2f..4a02e10 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -155,7 +155,7 @@ typedef struct _tstrHostIFkeyAttr {
 
 
 /*!
- *  @struct             tstrHostIFscanAttr
+ *  @struct             scan_attr
  *  @brief		Structure to hold Host IF Scan Attributes
  *  @details
  *  @todo
@@ -164,7 +164,7 @@ typedef struct _tstrHostIFkeyAttr {
  *  @date		25 March 2012
  *  @version		1.0
  */
-typedef struct _tstrHostIFscanAttr {
+struct scan_attr {
 	u8 u8ScanSource;
 	u8 u8ScanType;
 	u8 *pu8ChnlFreqList;
@@ -175,8 +175,7 @@ typedef struct _tstrHostIFscanAttr {
 	void *pvUserArg;
 	/*BugID_4189*/
 	tstrHiddenNetwork strHiddenNetwork;
-
-} tstrHostIFscanAttr;
+};
 
 /*!
  *  @struct             tstrHostIFconnectAttr
@@ -419,7 +418,7 @@ typedef struct {
  *  @version		1.0
  */
 union message_body {
-	tstrHostIFscanAttr strHostIFscanAttr;                           /*!< Host IF Scan Request Attributes message body */
+	struct scan_attr strHostIFscanAttr;                           /*!< Host IF Scan Request Attributes message body */
 	tstrHostIFconnectAttr strHostIFconnectAttr;     /*!< Host IF Connect Request Attributes message body */
 	tstrRcvdNetworkInfo strRcvdNetworkInfo;                 /*!< Received Asynchronous Network Info message body */
 	tstrRcvdGnrlAsyncInfo strRcvdGnrlAsyncInfo;     /*!< Received General Asynchronous Info message body */
@@ -1285,13 +1284,14 @@ static s32 Handle_wait_msg_q_empty(void)
 /**
  *  @brief Handle_Scan
  *  @details       Sending config packet to firmware to set the scan params
- *  @param[in]    tstrHostIFscanAttr* pstrHostIFscanAttr
+ *  @param[in]    struct scan_attr *pstrHostIFscanAttr
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler, tstrHostIFscanAttr *pstrHostIFscanAttr)
+static s32 Handle_Scan(tstrWILC_WFIDrv *drvHandler,
+		       struct scan_attr *pstrHostIFscanAttr)
 {
 	s32 s32Error = 0;
 	tstrWID strWIDList[5];
-- 
1.9.1

