Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21233 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbbIUDSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:18:51 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 13/34] staging: wilc1000: remove typedef from the struct tstrHostIFSetChan
Date: Mon, 21 Sep 2015 12:16:42 +0900
Message-ID: <1442805423-3711-14-git-send-email-tony.cho@atmel.com> (sfid-20150921_054656_698123_E5897154)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIFSetChan and ranames
it to set_channel in order to comply with the Linux coding style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2fdef1e..8058f38 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -215,7 +215,7 @@ struct rcvd_async_info {
 };
 
 /*!
- *  @struct             tstrHostIFSetChan
+ *  @struct             set_channel
  *  @brief		Set Channel  message body
  *  @details
  *  @todo
@@ -224,9 +224,9 @@ struct rcvd_async_info {
  *  @date		25 March 2012
  *  @version		1.0
  */
-typedef struct _tstrHostIFSetChan {
+struct set_channel {
 	u8 u8SetChan;
-} tstrHostIFSetChan;
+};
 
 /*!
  *  @struct             tstrHostIFSetChan
@@ -422,7 +422,7 @@ union message_body {
 	struct rcvd_async_info strRcvdGnrlAsyncInfo;     /*!< Received General Asynchronous Info message body */
 	struct key_attr strHostIFkeyAttr;                             /*!<>*/
 	struct cfg_param_attr strHostIFCfgParamAttr;            /*! <CFG Parameter message Body> */
-	tstrHostIFSetChan strHostIFSetChan;
+	struct set_channel strHostIFSetChan;
 	tstrHostIFGetChan strHostIFGetChan;
 	tstrHostIFSetBeacon strHostIFSetBeacon;                 /*!< Set beacon message body */
 	tstrHostIFDelBeacon strHostIFDelBeacon;                 /*!< Del beacon message body */
@@ -633,13 +633,14 @@ static tstrWILC_WFIDrv *get_handler_from_id(int id)
 /**
  *  @brief Handle_SetChannel
  *  @details    Sending config packet to firmware to set channel
- *  @param[in]   tstrHostIFSetChan* pstrHostIFSetChan
+ *  @param[in]   struct set_channel *pstrHostIFSetChan
  *  @return     Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
-static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetChan *pstrHostIFSetChan)
+static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler,
+			     struct set_channel *pstrHostIFSetChan)
 {
 
 	s32 s32Error = 0;
-- 
1.9.1

