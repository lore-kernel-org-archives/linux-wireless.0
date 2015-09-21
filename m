Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21289 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbbIUDTL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:19:11 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 16/34] staging: wilc1000: remove typedef from the struct tstrHostIFDelBeacon
Date: Mon, 21 Sep 2015 12:16:45 +0900
Message-ID: <1442805423-3711-17-git-send-email-tony.cho@atmel.com> (sfid-20150921_054655_621921_AB565549)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIFDelBeacon and
renames it to del_beacon in order to comply with the Linux coding style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6f93908..f530e89 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -284,7 +284,7 @@ struct set_beacon {
 
 
 /*!
- *  @struct             tstrHostIFDelBeacon
+ *  @struct             del_beacon
  *  @brief		Del Beacon  message body
  *  @details
  *  @todo
@@ -293,9 +293,9 @@ struct set_beacon {
  *  @date		15 July 2012
  *  @version		1.0
  */
-typedef struct _tstrHostIFDelBeacon {
+struct del_beacon {
 	u8 u8dummy;
-} tstrHostIFDelBeacon;
+};
 
 /*!
  *  @struct             tstrHostIFSetMulti
@@ -425,7 +425,7 @@ union message_body {
 	struct set_channel strHostIFSetChan;
 	struct get_channel strHostIFGetChan;
 	struct set_beacon strHostIFSetBeacon;                 /*!< Set beacon message body */
-	tstrHostIFDelBeacon strHostIFDelBeacon;                 /*!< Del beacon message body */
+	struct del_beacon strHostIFDelBeacon;                 /*!< Del beacon message body */
 	tstrWILC_AddStaParam strAddStaParam;                    /*!< Add station message body */
 	tstrHostIFDelSta strDelStaParam;                                /*!< Del Station message body */
 	tstrWILC_AddStaParam strEditStaParam;                           /*!< Edit station message body */
@@ -3506,13 +3506,14 @@ ERRORHANDLER:
 /**
  *  @brief Handle_AddBeacon
  *  @details       Sending config packet to delete beacon
- *  @param[in]   tstrHostIFDelBeacon* pstrDelBeacon
+ *  @param[in]   struct del_beacon *pstrDelBeacon
  *  @return         NONE
  *  @author
  *  @date
  *  @version	1.0
  */
-static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelBeacon *pstrDelBeacon)
+static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler,
+			     struct del_beacon *pstrDelBeacon)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
-- 
1.9.1

