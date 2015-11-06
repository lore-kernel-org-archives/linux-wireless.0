Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37874 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031061AbbKFCSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:18:50 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 68/73] staging: wilc1000: rename Handle_get_IPAddress function
Date: Fri, 6 Nov 2015 11:20:07 +0900
Message-ID: <1446776412-30670-19-git-send-email-glen.lee@atmel.com> (sfid-20151106_031854_605960_2F9BA084)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames Handle_get_IPAddress function to handle_get_ip_address
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
 mode change 100644 => 100755 drivers/staging/wilc1000/host_interface.c

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
old mode 100644
new mode 100755
index 4612723..9c4c0b2
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -430,7 +430,7 @@ s32 handle_set_ip_address(struct host_if_drv *hif_drv, u8 *ip_addr, u8 idx)
 	return result;
 }
 
-s32 Handle_get_IPAddress(struct host_if_drv *hif_drv, u8 idx)
+s32 handle_get_ip_address(struct host_if_drv *hif_drv, u8 idx)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2986,7 +2986,7 @@ static int hostIFthread(void *pvArg)
 
 		case HOST_IF_MSG_GET_IPADDRESS:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_SET_IPADDRESS\n");
-			Handle_get_IPAddress(msg.drv, msg.body.ip_info.idx);
+			handle_get_ip_address(msg.drv, msg.body.ip_info.idx);
 			break;
 
 		case HOST_IF_MSG_SET_MAC_ADDRESS:
-- 
1.9.1

