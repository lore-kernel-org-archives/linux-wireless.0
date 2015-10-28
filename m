Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42388 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbbJ1HBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:01:31 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 39/80] staging: wilc1000: rename u8Ted of struct ba_session_info
Date: Wed, 28 Oct 2015 15:59:59 +0900
Message-ID: <1446015640-29398-39-git-send-email-glen.lee@atmel.com> (sfid-20151028_080135_712296_1F92B7F2)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
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
index 48a232f..eef64f6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2725,7 +2725,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 		strHostIfBASessionInfo->bssid[2],
 		strHostIfBASessionInfo->u16BufferSize,
 		strHostIfBASessionInfo->u16SessionTimeout,
-		strHostIfBASessionInfo->u8Ted);
+		strHostIfBASessionInfo->tid);
 
 	wid.id = (u16)WID_11E_P_ACTION_REQ;
 	wid.type = WID_STR;
@@ -2737,7 +2737,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = 0x0;
 	memcpy(ptr, strHostIfBASessionInfo->bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
-	*ptr++ = strHostIfBASessionInfo->u8Ted;
+	*ptr++ = strHostIfBASessionInfo->tid;
 	*ptr++ = 1;
 	*ptr++ = (strHostIfBASessionInfo->u16BufferSize & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->u16BufferSize >> 16) & 0xFF);
@@ -2762,7 +2762,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = 0x2;
 	memcpy(ptr, strHostIfBASessionInfo->bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
-	*ptr++ = strHostIfBASessionInfo->u8Ted;
+	*ptr++ = strHostIfBASessionInfo->tid;
 	*ptr++ = 8;
 	*ptr++ = (strHostIfBASessionInfo->u16BufferSize & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
@@ -2788,7 +2788,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 		strHostIfBASessionInfo->bssid[0],
 		strHostIfBASessionInfo->bssid[1],
 		strHostIfBASessionInfo->bssid[2],
-		strHostIfBASessionInfo->u8Ted);
+		strHostIfBASessionInfo->tid);
 
 	wid.id = (u16)WID_DEL_ALL_RX_BA;
 	wid.type = WID_STR;
@@ -2800,7 +2800,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 	*ptr++ = 0x2;
 	memcpy(ptr, strHostIfBASessionInfo->bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
-	*ptr++ = strHostIfBASessionInfo->u8Ted;
+	*ptr++ = strHostIfBASessionInfo->tid;
 	*ptr++ = 0;
 	*ptr++ = 32;
 
@@ -4918,7 +4918,7 @@ s32 host_int_delBASession(struct host_if_drv *hif_drv, char *pBSSID, char TID)
 	msg.id = HOST_IF_MSG_DEL_BA_SESSION;
 
 	memcpy(pBASessionInfo->bssid, pBSSID, ETH_ALEN);
-	pBASessionInfo->u8Ted = TID;
+	pBASessionInfo->tid = TID;
 	msg.drv = hif_drv;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -4948,7 +4948,7 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
 	msg.id = HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS;
 
 	memcpy(pBASessionInfo->bssid, pBSSID, ETH_ALEN);
-	pBASessionInfo->u8Ted = TID;
+	pBASessionInfo->tid = TID;
 	msg.drv = hif_drv;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 0b6220e..65995d0 100644
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

