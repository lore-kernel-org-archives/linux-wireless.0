Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5009 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964921AbbJ2C6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:58:43 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 24/64] staging: wilc1000: rename u16BufferSize of struct ba_session_info
Date: Thu, 29 Oct 2015 11:58:47 +0900
Message-ID: <1446087567-16728-24-git-send-email-glen.lee@atmel.com> (sfid-20151029_035846_547565_4F621B96)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u16BufferSize of struct ba_session_info to buf_size
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 74d4c8f..75ad6d0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2718,7 +2718,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 		strHostIfBASessionInfo->bssid[0],
 		strHostIfBASessionInfo->bssid[1],
 		strHostIfBASessionInfo->bssid[2],
-		strHostIfBASessionInfo->u16BufferSize,
+		strHostIfBASessionInfo->buf_size,
 		strHostIfBASessionInfo->u16SessionTimeout,
 		strHostIfBASessionInfo->tid);
 
@@ -2734,8 +2734,8 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	ptr += ETH_ALEN;
 	*ptr++ = strHostIfBASessionInfo->tid;
 	*ptr++ = 1;
-	*ptr++ = (strHostIfBASessionInfo->u16BufferSize & 0xFF);
-	*ptr++ = ((strHostIfBASessionInfo->u16BufferSize >> 16) & 0xFF);
+	*ptr++ = (strHostIfBASessionInfo->buf_size & 0xFF);
+	*ptr++ = ((strHostIfBASessionInfo->buf_size >> 16) & 0xFF);
 	*ptr++ = (strHostIfBASessionInfo->u16SessionTimeout & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	*ptr++ = (AddbaTimeout & 0xFF);
@@ -2759,7 +2759,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	ptr += ETH_ALEN;
 	*ptr++ = strHostIfBASessionInfo->tid;
 	*ptr++ = 8;
-	*ptr++ = (strHostIfBASessionInfo->u16BufferSize & 0xFF);
+	*ptr++ = (strHostIfBASessionInfo->buf_size & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
 	*ptr++ = 3;
 	result = send_config_pkt(SET_CFG, &wid, 1,
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 9110e9e..e020a6d 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -231,7 +231,7 @@ struct get_mac_addr {
 struct ba_session_info {
 	u8 bssid[ETH_ALEN];
 	u8 tid;
-	u16 u16BufferSize;
+	u16 buf_size;
 	u16 u16SessionTimeout;
 };
 
-- 
1.9.1

