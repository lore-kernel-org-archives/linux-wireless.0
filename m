Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27296 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965285AbbJ2DGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:06:20 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 62/64] staging: wilc1000: rename pstrHostIFSetChan of fuction Handle_SetChannel
Date: Thu, 29 Oct 2015 12:05:54 +0900
Message-ID: <1446087956-19054-29-git-send-email-glen.lee@atmel.com> (sfid-20151029_040623_155025_1AD128AF)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pstrHostIFSetChan of fuction Handle_SetChannel to hif_set_ch
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 34b3455..819306b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -325,14 +325,14 @@ static struct host_if_drv *get_handler_from_id(int id)
 }
 
 static s32 Handle_SetChannel(struct host_if_drv *hif_drv,
-			     struct channel_attr *pstrHostIFSetChan)
+			      struct channel_attr *hif_set_ch)
 {
 	s32 result = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_CURRENT_CHANNEL;
 	wid.type = WID_CHAR;
-	wid.val = (char *)&pstrHostIFSetChan->set_ch;
+	wid.val = (char *)&hif_set_ch->set_ch;
 	wid.size = sizeof(char);
 
 	PRINT_D(HOSTINF_DBG, "Setting channel\n");
-- 
1.9.1

