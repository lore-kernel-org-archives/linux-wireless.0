Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5028 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964824AbbJ2C6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:58:49 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 25/64] staging: wilc1000: rename u16SessionTimeout of struct ba_session_info
Date: Thu, 29 Oct 2015 11:58:48 +0900
Message-ID: <1446087567-16728-25-git-send-email-glen.lee@atmel.com> (sfid-20151029_035852_090551_D1EAEC36)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u16SessionTimeout of struct ba_session_info to time_out
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 75ad6d0..5bc85dd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2719,7 +2719,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 		strHostIfBASessionInfo->bssid[1],
 		strHostIfBASessionInfo->bssid[2],
 		strHostIfBASessionInfo->buf_size,
-		strHostIfBASessionInfo->u16SessionTimeout,
+		strHostIfBASessionInfo->time_out,
 		strHostIfBASessionInfo->tid);
 
 	wid.id = (u16)WID_11E_P_ACTION_REQ;
@@ -2736,8 +2736,8 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = 1;
 	*ptr++ = (strHostIfBASessionInfo->buf_size & 0xFF);
 	*ptr++ = ((strHostIfBASessionInfo->buf_size >> 16) & 0xFF);
-	*ptr++ = (strHostIfBASessionInfo->u16SessionTimeout & 0xFF);
-	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
+	*ptr++ = (strHostIfBASessionInfo->time_out & 0xFF);
+	*ptr++ = ((strHostIfBASessionInfo->time_out >> 16) & 0xFF);
 	*ptr++ = (AddbaTimeout & 0xFF);
 	*ptr++ = ((AddbaTimeout >> 16) & 0xFF);
 	*ptr++ = 8;
@@ -2760,7 +2760,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = strHostIfBASessionInfo->tid;
 	*ptr++ = 8;
 	*ptr++ = (strHostIfBASessionInfo->buf_size & 0xFF);
-	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
+	*ptr++ = ((strHostIfBASessionInfo->time_out >> 16) & 0xFF);
 	*ptr++ = 3;
 	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e020a6d..2050fbe 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -232,7 +232,7 @@ struct ba_session_info {
 	u8 bssid[ETH_ALEN];
 	u8 tid;
 	u16 buf_size;
-	u16 u16SessionTimeout;
+	u16 time_out;
 };
 
 struct remain_ch {
-- 
1.9.1

