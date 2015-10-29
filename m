Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27006 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965314AbbJ2DEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:04:30 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 43/64] staging: wilc1000: rename WPAPtk of enum KEY_TYPE
Date: Thu, 29 Oct 2015 12:05:35 +0900
Message-ID: <1446087956-19054-10-git-send-email-glen.lee@atmel.com> (sfid-20151029_040433_081306_1ACF16B7)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames WPAPtk of enum KEY_TYPE to WPA_PTK
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ead99ab..3e7c6e4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1869,7 +1869,7 @@ _WPARxGtk_end_case_:
 
 		break;
 
-	case WPAPtk:
+	case WPA_PTK:
 		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
 			if (!pu8keybuf) {
@@ -3216,7 +3216,7 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.key_info.type = WPAPtk;
+	msg.body.key_info.type = WPA_PTK;
 	if (mode == AP_MODE) {
 		msg.body.key_info.action = ADDKEY_AP;
 		msg.body.key_info.attr.wpa.index = u8Idx;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index b3e74d1..f94bba6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -164,7 +164,7 @@ enum conn_event {
 enum KEY_TYPE {
 	WEP,
 	WPA_RX_GTK,
-	WPAPtk,
+	WPA_PTK,
 	PMKSA,
 };
 
-- 
1.9.1

