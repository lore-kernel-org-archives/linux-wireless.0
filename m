Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37812 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031601AbbKFCS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:18:26 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 64/73] staging: wilc1000: rename Handle_SetChannel function
Date: Fri, 6 Nov 2015 11:20:03 +0900
Message-ID: <1446776412-30670-15-git-send-email-glen.lee@atmel.com> (sfid-20151106_031829_678639_2A1C8685)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames Handle_SetChannel function to handle_set_channel
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7014915..16396e5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -323,7 +323,7 @@ static struct host_if_drv *get_handler_from_id(int id)
 	return wfidrv_list[id];
 }
 
-static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
+static s32 handle_set_channel(struct host_if_drv *hif_drv,
 			      struct channel_attr *hif_set_ch)
 {
 	s32 result = 0;
@@ -2893,7 +2893,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SET_CHANNEL:
-			Handle_SetChannel(msg.drv, &msg.body.channel_info);
+			handle_set_channel(msg.drv, &msg.body.channel_info);
 			break;
 
 		case HOST_IF_MSG_DISCONNECT:
-- 
1.9.1

