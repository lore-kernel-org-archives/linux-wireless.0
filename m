Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45840 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbbIRJPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:15:01 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 29/34] staging: wilc1000: remove typedef from the struct tstrHostIfRemainOnChan
Date: Fri, 18 Sep 2015 18:11:31 +0900
Message-ID: <1442567496-29331-29-git-send-email-tony.cho@atmel.com> (sfid-20150918_111653_777675_78D24F7A)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIfRemainOnChan and
renames it to remain_ch in order to comply with the Linux coding style

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 +++++---
 drivers/staging/wilc1000/host_interface.h | 6 +++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8894f90..59b2308 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -438,7 +438,7 @@ union message_body {
 	struct set_mac_addr strHostIfSetMacAddress;
 	struct get_mac_addr strHostIfGetMacAddress;
 	struct ba_session_info strHostIfBASessionInfo;
-	tstrHostIfRemainOnChan strHostIfRemainOnChan;
+	struct remain_ch strHostIfRemainOnChan;
 	tstrHostIfRegisterFrame strHostIfRegisterFrame;
 	char *pUserData;
 	tstrHostIFDelAllSta strHostIFDelAllSta;
@@ -3801,7 +3801,8 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnChan *pstrHostIfRemainOnChan)
+static int Handle_RemainOnChan(tstrWILC_WFIDrv *drvHandler,
+			       struct remain_ch *pstrHostIfRemainOnChan)
 {
 	s32 s32Error = 0;
 	u8 u8remain_on_chan_flag;
@@ -3937,7 +3938,8 @@ static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler, tstrHostIfRegisterF
  *  @version		1.0
  */
 #define FALSE_FRMWR_CHANNEL 100
-static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler, tstrHostIfRemainOnChan *pstrHostIfRemainOnChan)
+static u32 Handle_ListenStateExpired(tstrWILC_WFIDrv *drvHandler,
+				     struct remain_ch *pstrHostIfRemainOnChan)
 {
 	u8 u8remain_on_chan_flag;
 	tstrWID strWID;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 9a1d3599..59f83f5 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -279,14 +279,14 @@ struct ba_session_info {
 	u16 u16SessionTimeout;
 };
 
-typedef struct {
+struct remain_ch {
 	u16 u16Channel;
 	u32 u32duration;
 	tWILCpfRemainOnChanExpired pRemainOnChanExpired;
 	tWILCpfRemainOnChanReady pRemainOnChanReady;
 	void *pVoid;
 	u32 u32ListenSessionID;
-} tstrHostIfRemainOnChan;
+};
 
 typedef struct {
 
@@ -319,7 +319,7 @@ typedef struct {
 	tstrWILC_UsrConnReq strWILC_UsrConnReq;
 
 	/*Remain on channel struvture*/
-	tstrHostIfRemainOnChan strHostIfRemainOnChan;
+	struct remain_ch strHostIfRemainOnChan;
 	u8 u8RemainOnChan_pendingreq;
 	u64 u64P2p_MgmtTimeout;
 	u8 u8P2PConnect;
-- 
1.9.1

