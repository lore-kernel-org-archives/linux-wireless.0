Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:4990 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964921AbbJ2C6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:58:38 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 23/64] staging: wilc1000: rename u8Ted of struct ba_session_info
Date: Thu, 29 Oct 2015 11:58:46 +0900
Message-ID: <1446087567-16728-23-git-send-email-glen.lee@atmel.com> (sfid-20151029_035840_719281_FC154DB2)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8Ted of struct ba_session_info to tid
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 14 +++++++-------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 872f239..74d4c8f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2720,7 +2720,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 		strHostIfBASessionInfo->bssid[2],
 		strHostIfBASessionInfo->u16BufferSize,
 		strHostIfBASessionInfo->u16SessionTimeout,
-		strHostIfBASessionInfo->u8Ted);
+		strHostIfBASessionInfo->tid);
 
 	wid.id = (u16)WID_11E_P_ACTION_REQ;
 	wid.type = WID_STR;
@@ -2732,7 +2732,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = 0x0;
 	memcpy(ptr, strHostIfBASessionInfo->bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
-	*ptr++ = strHostIfBASessionInfo->u8Ted;
+	*ptr++ = strHostIfBASessionInfo->tid;
 	*ptr++ = 1;
 	*ptr++ = (strHostIfBASessionInfo->u16BufferSize & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->u16BufferSize >> 16) & 0xFF);
@@ -2757,7 +2757,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = 0x2;
 	memcpy(ptr, strHostIfBASessionInfo->bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
-	*ptr++ = strHostIfBASessionInfo->u8Ted;
+	*ptr++ = strHostIfBASessionInfo->tid;
 	*ptr++ = 8;
 	*ptr++ = (strHostIfBASessionInfo->u16BufferSize & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
@@ -2781,7 +2781,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 		strHostIfBASessionInfo->bssid[0],
 		strHostIfBASessionInfo->bssid[1],
 		strHostIfBASessionInfo->bssid[2],
-		strHostIfBASessionInfo->u8Ted);
+		strHostIfBASessionInfo->tid);
 
 	wid.id = (u16)WID_DEL_ALL_RX_BA;
 	wid.type = WID_STR;
@@ -2793,7 +2793,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 	*ptr++ = 0x2;
 	memcpy(ptr, strHostIfBASessionInfo->bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
-	*ptr++ = strHostIfBASessionInfo->u8Ted;
+	*ptr++ = strHostIfBASessionInfo->tid;
 	*ptr++ = 0;
 	*ptr++ = 32;
 
@@ -4915,7 +4915,7 @@ s32 host_int_delBASession(struct host_if_drv *hif_drv, char *pBSSID, char TID)
 	msg.id = HOST_IF_MSG_DEL_BA_SESSION;
 
 	memcpy(pBASessionInfo->bssid, pBSSID, ETH_ALEN);
-	pBASessionInfo->u8Ted = TID;
+	pBASessionInfo->tid = TID;
 	msg.drv = hif_drv;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -4945,7 +4945,7 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
 	msg.id = HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS;
 
 	memcpy(pBASessionInfo->bssid, pBSSID, ETH_ALEN);
-	pBASessionInfo->u8Ted = TID;
+	pBASessionInfo->tid = TID;
 	msg.drv = hif_drv;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 29cab4e..9110e9e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -230,7 +230,7 @@ struct get_mac_addr {
 
 struct ba_session_info {
 	u8 bssid[ETH_ALEN];
-	u8 u8Ted;
+	u8 tid;
 	u16 u16BufferSize;
 	u16 u16SessionTimeout;
 };
-- 
1.9.1

