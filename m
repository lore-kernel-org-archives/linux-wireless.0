Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13382 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbbJEEvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 00:51:16 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 3/3] staging: wilc1000: rename strHostIFDelAllSta
Date: Mon, 5 Oct 2015 13:50:46 +0900
Message-ID: <1444020646-3000-3-git-send-email-tony.cho@atmel.com> (sfid-20151005_065119_200102_4AB73988)
In-Reply-To: <1444020646-3000-1-git-send-email-tony.cho@atmel.com>
References: <1444020646-3000-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIFDelAllSta to del_all_sta_info to avoid
CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
V2:
 rename strHostIfRegisterFrame to reg_frame instead of reg_f because it is
 ambiguous
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 10d4d9f..9f715cf 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -387,7 +387,7 @@ union message_body {
 	struct remain_ch remain_on_ch;
 	struct reg_frame reg_frame;
 	char *data;
-	struct del_all_sta strHostIFDelAllSta;
+	struct del_all_sta del_all_sta_info;
 };
 
 /*!
@@ -4206,7 +4206,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_DEL_ALL_STA:
-			Handle_DelAllSta(msg.drvHandler, &msg.body.strHostIFDelAllSta);
+			Handle_DelAllSta(msg.drvHandler, &msg.body.del_all_sta_info);
 			break;
 
 		default:
@@ -6719,7 +6719,7 @@ s32 host_int_del_allstation(tstrWILC_WFIDrv *hWFIDrv, u8 pu8MacAddr[][ETH_ALEN])
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	struct del_all_sta *pstrDelAllStationMsg = &msg.body.strHostIFDelAllSta;
+	struct del_all_sta *pstrDelAllStationMsg = &msg.body.del_all_sta_info;
 	u8 au8Zero_Buff[ETH_ALEN] = {0};
 	u32 i;
 	u8 u8AssocNumb = 0;
-- 
1.9.1

