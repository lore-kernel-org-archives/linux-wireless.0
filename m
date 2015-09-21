Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21441 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbbIUDUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:20:05 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 24/34] staging: wilc1000: remove typedef from the struct tstrHostIfSetOperationMode
Date: Mon, 21 Sep 2015 12:16:53 +0900
Message-ID: <1442805423-3711-25-git-send-email-tony.cho@atmel.com> (sfid-20150921_054655_154668_E34B1648)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIfSetOperationMode
and renames it to op_mode in order to comply with the Linux coding
style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 +++--
 drivers/staging/wilc1000/host_interface.h | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f04e7b0..cdeb191 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -434,7 +434,7 @@ union message_body {
 	struct set_ip_addr strHostIfSetIP;
 	struct drv_handler strHostIfSetDrvHandler;
 	struct set_multicast strHostIfSetMulti;
-	tstrHostIfSetOperationMode strHostIfSetOperationMode;
+	struct op_mode strHostIfSetOperationMode;
 	tstrHostIfSetMacAddress strHostIfSetMacAddress;
 	tstrHostIfGetMacAddress strHostIfGetMacAddress;
 	tstrHostIfBASessionInfo strHostIfBASessionInfo;
@@ -713,7 +713,8 @@ static s32 Handle_SetWfiDrvHandler(tstrWILC_WFIDrv *drvHandler,
  *  @date
  *  @version	1.0
  */
-static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetOperationMode *pstrHostIfSetOperationMode)
+static s32 Handle_SetOperationMode(tstrWILC_WFIDrv *drvHandler,
+				   struct op_mode *pstrHostIfSetOperationMode)
 {
 
 	s32 s32Error = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index dc6fe73..101e51f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -259,9 +259,9 @@ struct drv_handler {
 	u32 u32Address;
 };
 
-typedef struct {
+struct op_mode {
 	u32 u32Mode;
-} tstrHostIfSetOperationMode;
+};
 
 typedef struct {
 	u8 u8MacAddress[ETH_ALEN];
-- 
1.9.1

