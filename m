Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:4972 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964921AbbJ2C6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:58:32 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 22/64] staging: wilc1000: rename au8Bssid of struct ba_session_info
Date: Thu, 29 Oct 2015 11:58:45 +0900
Message-ID: <1446087567-16728-22-git-send-email-glen.lee@atmel.com> (sfid-20151029_035835_253938_6051C585)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames au8Bssid of struct ba_session_info to bssid
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 22 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1ccf450..872f239 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2715,9 +2715,9 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	char *ptr = NULL;
 
 	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\nBufferSize == %d\nSessionTimeOut = %d\n",
-		strHostIfBASessionInfo->au8Bssid[0],
-		strHostIfBASessionInfo->au8Bssid[1],
-		strHostIfBASessionInfo->au8Bssid[2],
+		strHostIfBASessionInfo->bssid[0],
+		strHostIfBASessionInfo->bssid[1],
+		strHostIfBASessionInfo->bssid[2],
 		strHostIfBASessionInfo->u16BufferSize,
 		strHostIfBASessionInfo->u16SessionTimeout,
 		strHostIfBASessionInfo->u8Ted);
@@ -2730,7 +2730,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = 0x14;
 	*ptr++ = 0x3;
 	*ptr++ = 0x0;
-	memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
+	memcpy(ptr, strHostIfBASessionInfo->bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 	*ptr++ = 1;
@@ -2755,7 +2755,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = 15;
 	*ptr++ = 7;
 	*ptr++ = 0x2;
-	memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
+	memcpy(ptr, strHostIfBASessionInfo->bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 	*ptr++ = 8;
@@ -2778,9 +2778,9 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 	char *ptr = NULL;
 
 	PRINT_D(GENERIC_DBG, "Delete Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\n",
-		strHostIfBASessionInfo->au8Bssid[0],
-		strHostIfBASessionInfo->au8Bssid[1],
-		strHostIfBASessionInfo->au8Bssid[2],
+		strHostIfBASessionInfo->bssid[0],
+		strHostIfBASessionInfo->bssid[1],
+		strHostIfBASessionInfo->bssid[2],
 		strHostIfBASessionInfo->u8Ted);
 
 	wid.id = (u16)WID_DEL_ALL_RX_BA;
@@ -2791,7 +2791,7 @@ static s32 Handle_DelAllRxBASessions(struct host_if_drv *hif_drv,
 	*ptr++ = 0x14;
 	*ptr++ = 0x3;
 	*ptr++ = 0x2;
-	memcpy(ptr, strHostIfBASessionInfo->au8Bssid, ETH_ALEN);
+	memcpy(ptr, strHostIfBASessionInfo->bssid, ETH_ALEN);
 	ptr += ETH_ALEN;
 	*ptr++ = strHostIfBASessionInfo->u8Ted;
 	*ptr++ = 0;
@@ -4914,7 +4914,7 @@ s32 host_int_delBASession(struct host_if_drv *hif_drv, char *pBSSID, char TID)
 
 	msg.id = HOST_IF_MSG_DEL_BA_SESSION;
 
-	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
+	memcpy(pBASessionInfo->bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->u8Ted = TID;
 	msg.drv = hif_drv;
 
@@ -4944,7 +4944,7 @@ s32 host_int_del_All_Rx_BASession(struct host_if_drv *hif_drv,
 
 	msg.id = HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS;
 
-	memcpy(pBASessionInfo->au8Bssid, pBSSID, ETH_ALEN);
+	memcpy(pBASessionInfo->bssid, pBSSID, ETH_ALEN);
 	pBASessionInfo->u8Ted = TID;
 	msg.drv = hif_drv;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index a69be55..29cab4e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -229,7 +229,7 @@ struct get_mac_addr {
 };
 
 struct ba_session_info {
-	u8 au8Bssid[ETH_ALEN];
+	u8 bssid[ETH_ALEN];
 	u8 u8Ted;
 	u16 u16BufferSize;
 	u16 u16SessionTimeout;
-- 
1.9.1

