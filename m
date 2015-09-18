Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45237 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbbIRJNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:13:08 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/34] staging: wilc1000: remove typedef from the struct tstrHostIFCfgParamAttr
Date: Fri, 18 Sep 2015 18:11:14 +0900
Message-ID: <1442567496-29331-12-git-send-email-tony.cho@atmel.com> (sfid-20150918_111654_412685_57E5B215)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIFCfgParamAttr and
renames it to cfg_param_attr in order to comply with the Linux coding
style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1f0c842..d863a8c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -65,7 +65,7 @@ extern u8 g_wilc_initialized;
 /*****************************************************************************/
 
 /*!
- *  @struct             tstrHostIFCfgParamAttr
+ *  @struct             cfg_param_attr
  *  @brief		Structure to hold Host IF CFG Params Attributes
  *  @details
  *  @todo
@@ -74,10 +74,9 @@ extern u8 g_wilc_initialized;
  *  @date		02 April 2012
  *  @version		1.0
  */
-typedef struct _tstrHostIFCfgParamAttr {
+struct cfg_param_attr {
 	tstrCfgParamVal pstrCfgParamVal;
-
-} tstrHostIFCfgParamAttr;
+};
 
 /*!
  *  @struct             tstrHostIFwpaAttr
@@ -423,7 +422,7 @@ union message_body {
 	struct rcvd_net_info strRcvdNetworkInfo;                 /*!< Received Asynchronous Network Info message body */
 	struct rcvd_async_info strRcvdGnrlAsyncInfo;     /*!< Received General Asynchronous Info message body */
 	struct key_attr strHostIFkeyAttr;                             /*!<>*/
-	tstrHostIFCfgParamAttr strHostIFCfgParamAttr;            /*! <CFG Parameter message Body> */
+	struct cfg_param_attr strHostIFCfgParamAttr;            /*! <CFG Parameter message Body> */
 	tstrHostIFSetChan strHostIFSetChan;
 	tstrHostIFGetChan strHostIFGetChan;
 	tstrHostIFSetBeacon strHostIFSetBeacon;                 /*!< Set beacon message body */
@@ -925,13 +924,14 @@ static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfGetMacAdd
 /**
  *  @brief Handle_CfgParam
  *  @details    Sending config packet to firmware to set CFG params
- *  @param[in]   tstrHostIFCfgParamAttr* strHostIFCfgParamAttr
+ *  @param[in]   struct cfg_param_attr *strHostIFCfgParamAttr
  *  @return     Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler, tstrHostIFCfgParamAttr *strHostIFCfgParamAttr)
+static s32 Handle_CfgParam(tstrWILC_WFIDrv *drvHandler,
+			   struct cfg_param_attr *strHostIFCfgParamAttr)
 {
 	s32 s32Error = 0;
 	tstrWID strWIDList[32];
-- 
1.9.1

