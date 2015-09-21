Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21473 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbbIUDUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:20:18 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 26/34] staging: wilc1000: remove typedef from the struct tstrHostIfGetMacAddress
Date: Mon, 21 Sep 2015 12:16:55 +0900
Message-ID: <1442805423-3711-27-git-send-email-tony.cho@atmel.com> (sfid-20150921_054657_194246_9DA273E4)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIfGetMacAddress and
renames it get_mac_addr in order to comply with the Linux coding style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 +++--
 drivers/staging/wilc1000/host_interface.h | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 031d289..d35122e3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -436,7 +436,7 @@ union message_body {
 	struct set_multicast strHostIfSetMulti;
 	struct op_mode strHostIfSetOperationMode;
 	struct set_mac_addr strHostIfSetMacAddress;
-	tstrHostIfGetMacAddress strHostIfGetMacAddress;
+	struct get_mac_addr strHostIfGetMacAddress;
 	tstrHostIfBASessionInfo strHostIfBASessionInfo;
 	tstrHostIfRemainOnChan strHostIfRemainOnChan;
 	tstrHostIfRegisterFrame strHostIfRegisterFrame;
@@ -895,7 +895,8 @@ static s32 Handle_SetMacAddress(tstrWILC_WFIDrv *drvHandler,
  *  @date		JAN 2013
  *  @version	8.0
  */
-static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler, tstrHostIfGetMacAddress *pstrHostIfGetMacAddress)
+static s32 Handle_GetMacAddress(tstrWILC_WFIDrv *drvHandler,
+				struct get_mac_addr *pstrHostIfGetMacAddress)
 {
 
 	s32 s32Error = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index fc7c521..c8b482f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -267,9 +267,9 @@ struct set_mac_addr {
 	u8 u8MacAddress[ETH_ALEN];
 };
 
-typedef struct {
+struct get_mac_addr {
 	u8 *u8MacAddress;
-} tstrHostIfGetMacAddress;
+};
 
 typedef struct {
 	u8 au8Bssid[ETH_ALEN];
-- 
1.9.1

