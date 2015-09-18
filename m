Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45595 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbbIRJOO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:14:14 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 22/34] staging: wilc1000: remove typedef from the struct tstrHostIfSetDrvHandler
Date: Fri, 18 Sep 2015 18:11:24 +0900
Message-ID: <1442567496-29331-22-git-send-email-tony.cho@atmel.com> (sfid-20150918_111422_285683_F2E7695A)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIfSetDrvHandler and
renames it to drv_handler in order to comply with the Linux coding
style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 7 ++++---
 drivers/staging/wilc1000/host_interface.h | 4 ++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8b995c3..80527b5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -433,7 +433,7 @@ union message_body {
 	struct power_mgmt_param strPowerMgmtparam;     /*!< Power Management message body */
 	struct sta_inactive_t strHostIfStaInactiveT;
 	struct set_ip_addr strHostIfSetIP;
-	tstrHostIfSetDrvHandler strHostIfSetDrvHandler;
+	struct drv_handler strHostIfSetDrvHandler;
 	tstrHostIFSetMulti strHostIfSetMulti;
 	tstrHostIfSetOperationMode strHostIfSetOperationMode;
 	tstrHostIfSetMacAddress strHostIfSetMacAddress;
@@ -667,14 +667,15 @@ static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler,
 /**
  *  @brief Handle_SetWfiDrvHandler
  *  @details    Sending config packet to firmware to set driver handler
- *  @param[in]   void * drvHandler,tstrHostIfSetDrvHandler* pstrHostIfSetDrvHandler
+ *  @param[in]   void * drvHandler,
+ *		 struct drv_handler *pstrHostIfSetDrvHandler
  *  @return     Error code.
  *  @author
  *  @date
  *  @version	1.0
  */
 static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
-				   tstrHostIfSetDrvHandler *pstrHostIfSetDrvHandler)
+				   struct drv_handler *pstrHostIfSetDrvHandler)
 {
 
 	s32 s32Error = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 90493c6..a023365 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -256,9 +256,9 @@ typedef struct {
 	void *u32UserConnectPvoid;
 } tstrWILC_UsrConnReq;
 
-typedef struct {
+struct drv_handler {
 	u32 u32Address;
-} tstrHostIfSetDrvHandler;
+};
 
 typedef struct {
 	u32 u32Mode;
-- 
1.9.1

