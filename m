Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3261 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbbJMKyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:54:38 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 37/54] staging: wilc1000: rename u8SetChan of struct channel_attr
Date: Tue, 13 Oct 2015 19:50:02 +0900
Message-ID: <1444733419-17679-37-git-send-email-tony.cho@atmel.com> (sfid-20151013_125440_961922_693D2262)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8SetChan of struct channel_attr to set_ch to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3d0796f..cd42364 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -127,7 +127,7 @@ struct rcvd_async_info {
 };
 
 struct channel_attr {
-	u8 u8SetChan;
+	u8 set_ch;
 };
 
 struct beacon_attr {
@@ -342,7 +342,7 @@ static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
 
 	strWID.id = (u16)WID_CURRENT_CHANNEL;
 	strWID.type = WID_CHAR;
-	strWID.val = (char *)&(pstrHostIFSetChan->u8SetChan);
+	strWID.val = (char *)&(pstrHostIFSetChan->set_ch);
 	strWID.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
@@ -3786,7 +3786,7 @@ int host_int_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_CHANNEL;
-	msg.body.channel_info.u8SetChan = channel;
+	msg.body.channel_info.set_ch = channel;
 	msg.drv = hif_drv;
 
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

