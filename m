Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21419 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbbIUDT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:19:58 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 23/34] staging: wilc1000: remove typedef from the struct tstrHostIFSetMulti
Date: Mon, 21 Sep 2015 12:16:52 +0900
Message-ID: <1442805423-3711-24-git-send-email-tony.cho@atmel.com> (sfid-20150921_054654_896543_B3B258E3)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
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
index 9824b00..f04e7b0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -298,7 +298,7 @@ struct del_beacon {
 };
 
 /*!
- *  @struct             tstrHostIFSetMulti
+ *  @struct             set_multicast
  *  @brief		set Multicast filter Address
  *  @details
  *  @todo
@@ -308,10 +308,10 @@ struct del_beacon {
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
@@ -433,7 +433,7 @@ union message_body {
 	struct sta_inactive_t strHostIfStaInactiveT;
 	struct set_ip_addr strHostIfSetIP;
 	struct drv_handler strHostIfSetDrvHandler;
-	tstrHostIFSetMulti strHostIfSetMulti;
+	struct set_multicast strHostIfSetMulti;
 	tstrHostIfSetOperationMode strHostIfSetOperationMode;
 	tstrHostIfSetMacAddress strHostIfSetMacAddress;
 	tstrHostIfGetMacAddress strHostIfGetMacAddress;
@@ -4032,13 +4032,14 @@ static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler,
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
@@ -4048,7 +4049,7 @@ static void Handle_SetMulticastFilter(tstrWILC_WFIDrv *drvHandler, tstrHostIFSet
 
 	strWID.u16WIDid = (u16)WID_SETUP_MULTICAST_FILTER;
 	strWID.enuWIDtype = WID_BIN;
-	strWID.s32ValueSize = sizeof(tstrHostIFSetMulti) + ((strHostIfSetMulti->u32count) * ETH_ALEN);
+	strWID.s32ValueSize = sizeof(struct set_multicast) + ((strHostIfSetMulti->u32count) * ETH_ALEN);
 	strWID.ps8WidVal = kmalloc(strWID.s32ValueSize, GFP_KERNEL);
 	if (strWID.ps8WidVal == NULL)
 		goto ERRORHANDLER;
@@ -7264,7 +7265,7 @@ s32 host_int_setup_multicast_filter(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u
 
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIFSetMulti *pstrMulticastFilterParam = &msg.body.strHostIfSetMulti;
+	struct set_multicast *pstrMulticastFilterParam = &msg.body.strHostIfSetMulti;
 
 
 	if (pstrWFIDrv == NULL) {
-- 
1.9.1

