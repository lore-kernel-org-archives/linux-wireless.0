Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26992 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965314AbbJ2DEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:04:24 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 42/64] staging: wilc1000: rename WPARxGtk of enum KEY_TYPE
Date: Thu, 29 Oct 2015 12:05:34 +0900
Message-ID: <1446087956-19054-9-git-send-email-glen.lee@atmel.com> (sfid-20151029_040427_744602_2F59F7B2)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames WPARxGtk of enum KEY_TYPE to WPA_RX_GTK
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 590d8a4..ead99ab 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1795,7 +1795,7 @@ static int Handle_Key(struct host_if_drv *hif_drv,
 		up(&hif_drv->sem_test_key_block);
 		break;
 
-	case WPARxGtk:
+	case WPA_RX_GTK:
 		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
 			pu8keybuf = kzalloc(RX_MIC_KEY_MSG_LEN, GFP_KERNEL);
 			if (!pu8keybuf) {
@@ -3285,7 +3285,7 @@ s32 host_int_add_rx_gtk(struct host_if_drv *hif_drv, const u8 *pu8RxGtk,
 	}
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.key_info.type = WPARxGtk;
+	msg.body.key_info.type = WPA_RX_GTK;
 	msg.drv = hif_drv;
 
 	if (mode == AP_MODE) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 59b1949..b3e74d1 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -163,7 +163,7 @@ enum conn_event {
 
 enum KEY_TYPE {
 	WEP,
-	WPARxGtk,
+	WPA_RX_GTK,
 	WPAPtk,
 	PMKSA,
 };
-- 
1.9.1

