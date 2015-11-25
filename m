Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:10233 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266AbbKYC5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 21:57:08 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/10] staging: wilc1000: Handle_AddBASession: remove unused function
Date: Wed, 25 Nov 2015 11:59:47 +0900
Message-ID: <1448420389-4192-8-git-send-email-glen.lee@atmel.com> (sfid-20151125_035722_074147_FB624CC8)
In-Reply-To: <1448420389-4192-1-git-send-email-glen.lee@atmel.com>
References: <1448420389-4192-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes unused a function Handle_AddBASession.
And, removes the relation define.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 69 -------------------------------
 1 file changed, 69 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8f27227..0b85640 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -43,7 +43,6 @@
 #define HOST_IF_MSG_FLUSH_CONNECT               30
 #define HOST_IF_MSG_GET_STATISTICS              31
 #define HOST_IF_MSG_SET_MULTICAST_FILTER        32
-#define HOST_IF_MSG_ADD_BA_SESSION              33
 #define HOST_IF_MSG_DEL_BA_SESSION              34
 #define HOST_IF_MSG_Q_IDLE                      35
 #define HOST_IF_MSG_DEL_ALL_STA                 36
@@ -2741,70 +2740,6 @@ ERRORHANDLER:
 	kfree(wid.val);
 }
 
-static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
-			       struct ba_session_info *strHostIfBASessionInfo)
-{
-	s32 result = 0;
-	struct wid wid;
-	int AddbaTimeout = 100;
-	char *ptr = NULL;
-
-	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\nBufferSize == %d\nSessionTimeOut = %d\n",
-		strHostIfBASessionInfo->bssid[0],
-		strHostIfBASessionInfo->bssid[1],
-		strHostIfBASessionInfo->bssid[2],
-		strHostIfBASessionInfo->buf_size,
-		strHostIfBASessionInfo->time_out,
-		strHostIfBASessionInfo->tid);
-
-	wid.id = (u16)WID_11E_P_ACTION_REQ;
-	wid.type = WID_STR;
-	wid.val = kmalloc(BLOCK_ACK_REQ_SIZE, GFP_KERNEL);
-	wid.size = BLOCK_ACK_REQ_SIZE;
-	ptr = wid.val;
-	*ptr++ = 0x14;
-	*ptr++ = 0x3;
-	*ptr++ = 0x0;
-	memcpy(ptr, strHostIfBASessionInfo->bssid, ETH_ALEN);
-	ptr += ETH_ALEN;
-	*ptr++ = strHostIfBASessionInfo->tid;
-	*ptr++ = 1;
-	*ptr++ = (strHostIfBASessionInfo->buf_size & 0xFF);
-	*ptr++ = ((strHostIfBASessionInfo->buf_size >> 16) & 0xFF);
-	*ptr++ = (strHostIfBASessionInfo->time_out & 0xFF);
-	*ptr++ = ((strHostIfBASessionInfo->time_out >> 16) & 0xFF);
-	*ptr++ = (AddbaTimeout & 0xFF);
-	*ptr++ = ((AddbaTimeout >> 16) & 0xFF);
-	*ptr++ = 8;
-	*ptr++ = 0;
-
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
-	if (result)
-		PRINT_D(HOSTINF_DBG, "Couldn't open BA Session\n");
-
-	wid.id = (u16)WID_11E_P_ACTION_REQ;
-	wid.type = WID_STR;
-	wid.size = 15;
-	ptr = wid.val;
-	*ptr++ = 15;
-	*ptr++ = 7;
-	*ptr++ = 0x2;
-	memcpy(ptr, strHostIfBASessionInfo->bssid, ETH_ALEN);
-	ptr += ETH_ALEN;
-	*ptr++ = strHostIfBASessionInfo->tid;
-	*ptr++ = 8;
-	*ptr++ = (strHostIfBASessionInfo->buf_size & 0xFF);
-	*ptr++ = ((strHostIfBASessionInfo->time_out >> 16) & 0xFF);
-	*ptr++ = 3;
-	result = wilc_send_config_pkt(hif_drv->wilc, SET_CFG, &wid, 1,
-				 get_id_from_handler(hif_drv));
-
-	kfree(wid.val);
-
-	return result;
-}
-
 static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 				     struct ba_session_info *strHostIfBASessionInfo)
 {
@@ -3035,10 +2970,6 @@ static int hostIFthread(void *pvArg)
 			Handle_SetMulticastFilter(msg.drv, &msg.body.multicast_info);
 			break;
 
-		case HOST_IF_MSG_ADD_BA_SESSION:
-			Handle_AddBASession(msg.drv, &msg.body.session_info);
-			break;
-
 		case HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS:
 			Handle_DelAllRxBASessions(msg.drv, &msg.body.session_info);
 			break;
-- 
1.9.1

