Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45721 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbbIRJOf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:14:35 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 25/34] staging: wilc1000: remove typedef from the struct tstrHostIfSetMacAddress
Date: Fri, 18 Sep 2015 18:11:27 +0900
Message-ID: <1442567496-29331-25-git-send-email-tony.cho@atmel.com> (sfid-20150918_111438_810485_A0B31A4F)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIfSetMacAddress and
renames it set_mac_addr in order to comply with the Linux coding style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 +++--
 drivers/staging/wilc1000/host_interface.h | 5 ++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1433417..756555d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -436,7 +436,7 @@ union message_body {
 	struct drv_handler strHostIfSetDrvHandler;
 	struct set_multicast strHostIfSetMulti;
 	struct op_mode strHostIfSetOperationMode;
-	tstrHostIfSetMacAddress strHostIfSetMacAddress;
+	struct set_mac_addr strHostIfSetMacAddress;
 	tstrHostIfGetMacAddress strHostIfGetMacAddress;
 	tstrHostIfBASessionInfo strHostIfBASessionInfo;
 	tstrHostIfRemainOnChan strHostIfRemainOnChan;
@@ -854,7 +854,8 @@ s32 Handle_get_IPAddress(tstrWILC_WFIDrv *drvHandler, u8 *pu8IPAddr, u8 idx)
  *  @date		November 2013
  *  @version	7.0
  */
-static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfSetMacAddress *pstrHostIfSetMacAddress)
+static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler,
+				struct set_mac_addr *pstrHostIfSetMacAddress)
 {
 
 	s32 s32Error = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 078bb54..5ca7734 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -264,10 +264,9 @@ struct op_mode {
 	u32 u32Mode;
 };
 
-/*BugID_5077*/
-typedef struct {
+struct set_mac_addr {
 	u8 u8MacAddress[ETH_ALEN];
-} tstrHostIfSetMacAddress;
+};
 
 /*BugID_5213*/
 typedef struct {
-- 
1.9.1

