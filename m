Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45909 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbbIRJPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:15:08 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 30/34] staging: wilc1000: remove typedef from the struct tstrHostIfRegisterFrame
Date: Fri, 18 Sep 2015 18:11:32 +0900
Message-ID: <1442567496-29331-30-git-send-email-tony.cho@atmel.com> (sfid-20150918_111514_298349_AF491361)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIfRegisterFrame and
renames it to reg_frame in order to comply with the Linux coding style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 5 +++--
 drivers/staging/wilc1000/host_interface.h | 7 ++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 59b2308..ce4384c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -439,7 +439,7 @@ union message_body {
 	struct get_mac_addr strHostIfGetMacAddress;
 	struct ba_session_info strHostIfBASessionInfo;
 	struct remain_ch strHostIfRemainOnChan;
-	tstrHostIfRegisterFrame strHostIfRegisterFrame;
+	struct reg_frame strHostIfRegisterFrame;
 	char *pUserData;
 	tstrHostIFDelAllSta strHostIFDelAllSta;
 };
@@ -3890,7 +3890,8 @@ ERRORHANDLER:
  *  @date
  *  @version	1.0
  */
-static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler, tstrHostIfRegisterFrame *pstrHostIfRegisterFrame)
+static int Handle_RegisterFrame(tstrWILC_WFIDrv *drvHandler,
+				struct reg_frame *pstrHostIfRegisterFrame)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 59f83f5..1da1d2d 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -288,14 +288,11 @@ struct remain_ch {
 	u32 u32ListenSessionID;
 };
 
-typedef struct {
-
+struct reg_frame {
 	bool bReg;
 	u16 u16FrameType;
 	u8 u8Regid;
-
-
-} tstrHostIfRegisterFrame;
+};
 
 
 #define ACTION			0xD0
-- 
1.9.1

