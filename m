Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45207 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbbIRJNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:13:01 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/34] staging: wilc1000: remove typedef from the struct tstrHostIFkeyAttr
Date: Fri, 18 Sep 2015 18:11:13 +0900
Message-ID: <1442567496-29331-11-git-send-email-tony.cho@atmel.com> (sfid-20150918_111654_110550_488F1313)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIFkeyAttr and renames
it to key_attr in oder to comply with the Linux coding style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c80d00e..1f0c842 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -136,7 +136,7 @@ typedef union _tuniHostIFkeyAttr {
 } tuniHostIFkeyAttr;
 
 /*!
- *  @struct             tstrHostIFkeyAttr
+ *  @struct             key_attr
  *  @brief		Structure to hold Host IF Scan Attributes
  *  @details
  *  @todo
@@ -145,11 +145,11 @@ typedef union _tuniHostIFkeyAttr {
  *  @date		25 March 2012
  *  @version		1.0
  */
-typedef struct _tstrHostIFkeyAttr {
+struct key_attr {
 	tenuKeyType enuKeyType;
 	u8 u8KeyAction;
 	tuniHostIFkeyAttr uniHostIFkeyAttr;
-} tstrHostIFkeyAttr;
+};
 
 
 
@@ -422,7 +422,7 @@ union message_body {
 	struct connect_attr strHostIFconnectAttr;     /*!< Host IF Connect Request Attributes message body */
 	struct rcvd_net_info strRcvdNetworkInfo;                 /*!< Received Asynchronous Network Info message body */
 	struct rcvd_async_info strRcvdGnrlAsyncInfo;     /*!< Received General Asynchronous Info message body */
-	tstrHostIFkeyAttr strHostIFkeyAttr;                             /*!<>*/
+	struct key_attr strHostIFkeyAttr;                             /*!<>*/
 	tstrHostIFCfgParamAttr strHostIFCfgParamAttr;            /*! <CFG Parameter message Body> */
 	tstrHostIFSetChan strHostIFSetChan;
 	tstrHostIFGetChan strHostIFGetChan;
@@ -2711,13 +2711,14 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler,
 /**
  *  @brief Handle_Key
  *  @details       Sending config packet to firmware to set key
- *  @param[in]    tstrHostIFkeyAttr* pstrHostIFkeyAttr
+ *  @param[in]    struct key_attr *pstrHostIFkeyAttr
  *  @return         Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-static int Handle_Key(tstrWILC_WFIDrv *drvHandler, tstrHostIFkeyAttr *pstrHostIFkeyAttr)
+static int Handle_Key(tstrWILC_WFIDrv *drvHandler,
+		      struct key_attr *pstrHostIFkeyAttr)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
-- 
1.9.1

