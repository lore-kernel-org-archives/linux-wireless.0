Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:43086 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbbJ1HFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:05:12 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 59/80] staging: wilc1000: rename WPAPtk of enum KEY_TYPE
Date: Wed, 28 Oct 2015 16:07:04 +0900
Message-ID: <1446016045-32154-9-git-send-email-glen.lee@atmel.com> (sfid-20151028_080520_439401_E74BD63F)
In-Reply-To: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
References: <1446016045-32154-1-git-send-email-glen.lee@atmel.com>
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
index 4b4e8563..669f67c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1870,7 +1870,7 @@ _WPARxGtk_end_case_:
 
 		break;
 
-	case WPAPtk:
+	case WPA_PTK:
 		if (pstrHostIFkeyAttr->action & ADDKEY_AP) {
 			pu8keybuf = kmalloc(PTK_KEY_MSG_LEN + 1, GFP_KERNEL);
 			if (!pu8keybuf) {
@@ -3219,7 +3219,7 @@ s32 host_int_add_ptk(struct host_if_drv *hif_drv, const u8 *pu8Ptk,
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_KEY;
-	msg.body.key_info.type = WPAPtk;
+	msg.body.key_info.type = WPA_PTK;
 	if (mode == AP_MODE) {
 		msg.body.key_info.action = ADDKEY_AP;
 		msg.body.key_info.attr.wpa.index = u8Idx;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 96c7c41..06c5826 100644
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

