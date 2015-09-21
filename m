Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21454 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbbIUDUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:20:12 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 25/34] staging: wilc1000: remove typedef from the struct tstrHostIfSetMacAddress
Date: Mon, 21 Sep 2015 12:16:54 +0900
Message-ID: <1442805423-3711-26-git-send-email-tony.cho@atmel.com> (sfid-20150921_054653_807701_57B7A2C1)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIfSetMacAddress and
renames it set_mac_addr in order to comply with the Linux coding style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 +++--
 drivers/staging/wilc1000/host_interface.h | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index cdeb191..031d289 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -435,7 +435,7 @@ union message_body {
 	struct drv_handler strHostIfSetDrvHandler;
 	struct set_multicast strHostIfSetMulti;
 	struct op_mode strHostIfSetOperationMode;
-	tstrHostIfSetMacAddress strHostIfSetMacAddress;
+	struct set_mac_addr strHostIfSetMacAddress;
 	tstrHostIfGetMacAddress strHostIfGetMacAddress;
 	tstrHostIfBASessionInfo strHostIfBASessionInfo;
 	tstrHostIfRemainOnChan strHostIfRemainOnChan;
@@ -852,7 +852,8 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
  *  @date		November 2013
  *  @version	7.0
  */
-static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAddress *pstrHostIfSetMacAddress)
+static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler,
+				struct set_mac_addr *pstrHostIfSetMacAddress)
 {
 
 	s32 s32Error = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 101e51f..fc7c521 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -263,9 +263,9 @@ struct op_mode {
 	u32 u32Mode;
 };
 
-typedef struct {
+struct set_mac_addr {
 	u8 u8MacAddress[ETH_ALEN];
-} tstrHostIfSetMacAddress;
+};
 
 typedef struct {
 	u8 *u8MacAddress;
-- 
1.9.1

