Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42441 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbbJ1HBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:01:43 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 41/80] staging: wilc1000: rename u16SessionTimeout of struct ba_session_info
Date: Wed, 28 Oct 2015 16:00:01 +0900
Message-ID: <1446015640-29398-41-git-send-email-glen.lee@atmel.com> (sfid-20151028_080145_651144_45A90906)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
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
index ec0ec1a..1033dd6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2724,7 +2724,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 		strHostIfBASessionInfo->bssid[1],
 		strHostIfBASessionInfo->bssid[2],
 		strHostIfBASessionInfo->buf_size,
-		strHostIfBASessionInfo->u16SessionTimeout,
+		strHostIfBASessionInfo->time_out,
 		strHostIfBASessionInfo->tid);
 
 	wid.id = (u16)WID_11E_P_ACTION_REQ;
@@ -2741,8 +2741,8 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
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
@@ -2765,7 +2765,7 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
 	*ptr++ = strHostIfBASessionInfo->tid;
 	*ptr++ = 8;
 	*ptr++ = (strHostIfBASessionInfo->buf_size & 0xFF);
-	*ptr++ = ((strHostIfBASessionInfo->u16SessionTimeout >> 16) & 0xFF);
+	*ptr++ = ((strHostIfBASessionInfo->time_out >> 16) & 0xFF);
 	*ptr++ = 3;
 	result = send_config_pkt(SET_CFG, &wid, 1,
 				 get_id_from_handler(hif_drv));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e69168b..40dab56 100644
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

