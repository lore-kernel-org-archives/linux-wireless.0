Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45946 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbbIRJPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:15:15 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 31/34] staging: wilc1000: remove typedef from the struct tstrHostIFDelAllSta
Date: Fri, 18 Sep 2015 18:11:33 +0900
Message-ID: <1442567496-29331-31-git-send-email-tony.cho@atmel.com> (sfid-20150918_111603_186745_537F2190)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIFDelAllSta and
renames it to del_all_sta in order to comply with the Linux coding
style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ce4384c..5d72246 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -315,7 +315,7 @@ struct set_multicast {
 };
 
 /*!
- *  @struct             tstrHostIFDelAllSta
+ *  @struct             del_all_sta
  *  @brief		Deauth station message body
  *  @details
  *  @todo
@@ -324,11 +324,10 @@ struct set_multicast {
  *  @date		09 April 2014
  *  @version		1.0 Description
  */
-
-typedef struct {
+struct del_all_sta {
 	u8 au8Sta_DelAllSta[MAX_NUM_STA][ETH_ALEN];
 	u8 u8Num_AssocSta;
-} tstrHostIFDelAllSta;
+};
 
 /*!
  *  @struct             del_sta
@@ -441,7 +440,7 @@ union message_body {
 	struct remain_ch strHostIfRemainOnChan;
 	struct reg_frame strHostIfRegisterFrame;
 	char *pUserData;
-	tstrHostIFDelAllSta strHostIFDelAllSta;
+	struct del_all_sta strHostIFDelAllSta;
 };
 
 /*!
@@ -3664,7 +3663,8 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelAllSta *pstrDelAllStaParam)
+static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler,
+			     struct del_all_sta *pstrDelAllStaParam)
 {
 	s32 s32Error = 0;
 
@@ -7175,7 +7175,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIFDelAllSta *pstrDelAllStationMsg = &msg.body.strHostIFDelAllSta;
+	struct del_all_sta *pstrDelAllStationMsg = &msg.body.strHostIFDelAllSta;
 	u8 au8Zero_Buff[ETH_ALEN] = {0};
 	u32 i;
 	u8 u8AssocNumb = 0;
-- 
1.9.1

