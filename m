Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21396 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbbIUDTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:19:51 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 22/34] staging: wilc1000: remove typedef from the struct tstrHostIfSetDrvHandler
Date: Mon, 21 Sep 2015 12:16:51 +0900
Message-ID: <1442805423-3711-23-git-send-email-tony.cho@atmel.com> (sfid-20150921_054656_939789_263B13FD)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
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
index 689832a..9824b00 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -432,7 +432,7 @@ union message_body {
 	struct power_mgmt_param strPowerMgmtparam;     /*!< Power Management message body */
 	struct sta_inactive_t strHostIfStaInactiveT;
 	struct set_ip_addr strHostIfSetIP;
-	tstrHostIfSetDrvHandler strHostIfSetDrvHandler;
+	struct drv_handler strHostIfSetDrvHandler;
 	tstrHostIFSetMulti strHostIfSetMulti;
 	tstrHostIfSetOperationMode strHostIfSetOperationMode;
 	tstrHostIfSetMacAddress strHostIfSetMacAddress;
@@ -665,14 +665,15 @@ static s32 Handle_SetChannel(tstrWILC_WFIDrv *drvHandler,
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
index b24eeb6..dc6fe73 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -255,9 +255,9 @@ typedef struct {
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

