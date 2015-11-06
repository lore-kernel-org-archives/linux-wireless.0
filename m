Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37914 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031061AbbKFCTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:19:01 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 70/73] staging: wilc1000: rename Handle_GetMacAddress function
Date: Fri, 6 Nov 2015 11:20:09 +0900
Message-ID: <1446776412-30670-21-git-send-email-glen.lee@atmel.com> (sfid-20151106_031906_022718_722C0C6F)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames Handle_GetMacAddress function to handle_get_mac_address
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)
 mode change 100644 => 100755 drivers/staging/wilc1000/host_interface.c

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
old mode 100644
new mode 100755
index 2388e2d..cbc53bc
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -494,8 +494,8 @@ static s32 handle_set_mac_address(struct host_if_drv *hif_drv,
 	return result;
 }
 
-static s32 Handle_GetMacAddress(struct host_if_drv *hif_drv,
-				struct get_mac_addr *get_mac_addr)
+static s32 handle_get_mac_address(struct host_if_drv *hif_drv,
+				  struct get_mac_addr *get_mac_addr)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2995,7 +2995,8 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_GET_MAC_ADDRESS:
-			Handle_GetMacAddress(msg.drv, &msg.body.get_mac_info);
+			handle_get_mac_address(msg.drv,
+					       &msg.body.get_mac_info);
 			break;
 
 		case HOST_IF_MSG_REMAIN_ON_CHAN:
-- 
1.9.1

