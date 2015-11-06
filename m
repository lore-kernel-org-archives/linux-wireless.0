Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37895 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031061AbbKFCS4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:18:56 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 69/73] staging: wilc1000: rename Handle_SetMacAddress function
Date: Fri, 6 Nov 2015 11:20:08 +0900
Message-ID: <1446776412-30670-20-git-send-email-glen.lee@atmel.com> (sfid-20151106_031859_045292_238657E4)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames Handle_SetMacAddress function to handle_set_mac_address
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)
 mode change 100755 => 100644 drivers/staging/wilc1000/host_interface.c

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
old mode 100755
new mode 100644
index 9c4c0b2..2388e2d
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -464,8 +464,8 @@ s32 handle_get_ip_address(struct host_if_drv *hif_drv, u8 idx)
 	return result;
 }
 
-static s32 Handle_SetMacAddress(struct host_if_drv *hif_drv,
-				struct set_mac_addr *set_mac_addr)
+static s32 handle_set_mac_address(struct host_if_drv *hif_drv,
+				  struct set_mac_addr *set_mac_addr)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2990,7 +2990,8 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SET_MAC_ADDRESS:
-			Handle_SetMacAddress(msg.drv, &msg.body.set_mac_info);
+			handle_set_mac_address(msg.drv,
+					       &msg.body.set_mac_info);
 			break;
 
 		case HOST_IF_MSG_GET_MAC_ADDRESS:
-- 
1.9.1

