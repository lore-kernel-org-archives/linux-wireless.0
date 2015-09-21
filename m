Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21566 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbbIUDUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:20:52 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 31/34] staging: wilc1000: remove typedef from the struct tstrHostIFDelAllSta
Date: Mon, 21 Sep 2015 12:17:00 +0900
Message-ID: <1442805423-3711-32-git-send-email-tony.cho@atmel.com> (sfid-20150921_052054_448917_0E1E15CE)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
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
index 34eb349..0c8bc05 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -314,7 +314,7 @@ struct set_multicast {
 };
 
 /*!
- *  @struct             tstrHostIFDelAllSta
+ *  @struct             del_all_sta
  *  @brief		Deauth station message body
  *  @details
  *  @todo
@@ -323,11 +323,10 @@ struct set_multicast {
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
@@ -440,7 +439,7 @@ union message_body {
 	struct remain_ch strHostIfRemainOnChan;
 	struct reg_frame strHostIfRegisterFrame;
 	char *pUserData;
-	tstrHostIFDelAllSta strHostIFDelAllSta;
+	struct del_all_sta strHostIFDelAllSta;
 };
 
 /*!
@@ -3647,7 +3646,8 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelAllSta *pstrDelAllStaParam)
+static void Handle_DelAllSta(tstrWILC_WFIDrv *drvHandler,
+			     struct del_all_sta *pstrDelAllStaParam)
 {
 	s32 s32Error = 0;
 
@@ -7140,7 +7140,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
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

