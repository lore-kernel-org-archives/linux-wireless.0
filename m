Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:37937 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031061AbbKFCTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:19:07 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 71/73] staging: wilc1000: rename Handle_CfgParam function
Date: Fri, 6 Nov 2015 11:20:10 +0900
Message-ID: <1446776412-30670-22-git-send-email-glen.lee@atmel.com> (sfid-20151106_031910_901536_BE791BF0)
In-Reply-To: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
References: <1446776412-30670-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames Handle_CfgParam function to handle_cfg_param
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)
 mode change 100755 => 100644 drivers/staging/wilc1000/host_interface.c

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
old mode 100755
new mode 100644
index cbc53bc..4c91ae2
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -517,8 +517,8 @@ static s32 handle_get_mac_address(struct host_if_drv *hif_drv,
 	return result;
 }
 
-static s32 Handle_CfgParam(struct host_if_drv *hif_drv,
-			   struct cfg_param_attr *cfg_param_attr)
+static s32 handle_cfg_param(struct host_if_drv *hif_drv,
+			    struct cfg_param_attr *cfg_param_attr)
 {
 	s32 result = 0;
 	struct wid strWIDList[32];
@@ -2888,8 +2888,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_CFG_PARAMS:
-
-			Handle_CfgParam(msg.drv, &msg.body.cfg_info);
+			handle_cfg_param(msg.drv, &msg.body.cfg_info);
 			break;
 
 		case HOST_IF_MSG_SET_CHANNEL:
-- 
1.9.1

