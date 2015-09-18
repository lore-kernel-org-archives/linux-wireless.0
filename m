Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45634 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbbIRJOV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:14:21 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 23/34] staging: wilc1000: remove typedef from the struct tstrHostIFSetMulti
Date: Fri, 18 Sep 2015 18:11:25 +0900
Message-ID: <1442567496-29331-23-git-send-email-tony.cho@atmel.com> (sfid-20150918_111427_331846_D385EB8F)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIFSetMulti and
renames it to set_multicast in order to comply with the Linux coding
style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 80527b5..c484619 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -299,7 +299,7 @@ struct del_beacon {
 };
 
 /*!
- *  @struct             tstrHostIFSetMulti
+ *  @struct             set_multicast
  *  @brief		set Multicast filter Address
  *  @details
  *  @todo
@@ -309,10 +309,10 @@ struct del_beacon {
  *  @version		1.0 Description
  */
 
-typedef struct {
+struct set_multicast {
 	bool bIsEnabled;
 	u32 u32count;
-} tstrHostIFSetMulti;
+};
 
 /*!
  *  @struct             tstrHostIFDelAllSta
@@ -434,7 +434,7 @@ union message_body {
 	struct sta_inactive_t strHostIfStaInactiveT;
 	struct set_ip_addr strHostIfSetIP;
 	struct drv_handler strHostIfSetDrvHandler;
-	tstrHostIFSetMulti strHostIfSetMulti;
+	struct set_multicast strHostIfSetMulti;
 	tstrHostIfSetOperationMode strHostIfSetOperationMode;
 	tstrHostIfSetMacAddress strHostIfSetMacAddress;
 	tstrHostIfGetMacAddress strHostIfGetMacAddress;
@@ -4050,13 +4050,14 @@ static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler,
 /**
  *  @brief Handle_SetMulticastFilter
  *  @details        Set Multicast filter in firmware
- *  @param[in]   tstrHostIFSetMulti* strHostIfSetMulti
+ *  @param[in]   struct set_multicast *strHostIfSetMulti
  *  @return         NONE
  *  @author		asobhy
  *  @date
  *  @version	1.0
  */
-static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetMulti *strHostIfSetMulti)
+static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler,
+				      struct set_multicast *strHostIfSetMulti)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
@@ -4066,7 +4067,7 @@ static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSet
 
 	strWID.u16WIDid = (u16)WID_SETUP_MULTICAST_FILTER;
 	strWID.enuWIDtype = WID_BIN;
-	strWID.s32ValueSize = sizeof(tstrHostIFSetMulti) + ((strHostIfSetMulti->u32count) * ETH_ALEN);
+	strWID.s32ValueSize = sizeof(struct set_multicast) + ((strHostIfSetMulti->u32count) * ETH_ALEN);
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		goto ERRORHANDLER;
@@ -7301,7 +7302,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIFSetMulti *pstrMulticastFilterParam = &msg.body.strHostIfSetMulti;
+	struct set_multicast *pstrMulticastFilterParam = &msg.body.strHostIfSetMulti;
 
 
 	if (pstrWFIDrv == NULL) {
-- 
1.9.1

