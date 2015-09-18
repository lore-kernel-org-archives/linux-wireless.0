Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45380 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbbIRJNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:13:34 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/34] staging: wilc1000: remove typedef from the struct tstrHostIFDelBeacon
Date: Fri, 18 Sep 2015 18:11:18 +0900
Message-ID: <1442567496-29331-16-git-send-email-tony.cho@atmel.com> (sfid-20150918_111653_943422_CB09475F)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
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
index 06091da..8733c1b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -285,7 +285,7 @@ struct set_beacon {
 
 
 /*!
- *  @struct             tstrHostIFDelBeacon
+ *  @struct             del_beacon
  *  @brief		Del Beacon  message body
  *  @details
  *  @todo
@@ -294,9 +294,9 @@ struct set_beacon {
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
@@ -426,7 +426,7 @@ union message_body {
 	struct set_channel strHostIFSetChan;
 	struct get_channel strHostIFGetChan;
 	struct set_beacon strHostIFSetBeacon;                 /*!< Set beacon message body */
-	tstrHostIFDelBeacon strHostIFDelBeacon;                 /*!< Del beacon message body */
+	struct del_beacon strHostIFDelBeacon;                 /*!< Del beacon message body */
 	tstrWILC_AddStaParam strAddStaParam;                    /*!< Add station message body */
 	tstrHostIFDelSta strDelStaParam;                                /*!< Del Station message body */
 	tstrWILC_AddStaParam strEditStaParam;                           /*!< Edit station message body */
@@ -3523,13 +3523,14 @@ ERRORHANDLER:
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

