Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:4884 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964921AbbJ2C6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:58:04 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 17/64] staging: wilc1000: rename u8Regid of struct reg_frame
Date: Thu, 29 Oct 2015 11:58:40 +0900
Message-ID: <1446087567-16728-17-git-send-email-glen.lee@atmel.com> (sfid-20151029_035809_028250_8588A61C)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8Regid of struct reg_frame to reg_id
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3c17912..12e0d21 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2565,7 +2565,7 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 	pu8CurrByte = wid.val;
 
 	*pu8CurrByte++ = pstrHostIfRegisterFrame->reg;
-	*pu8CurrByte++ = pstrHostIfRegisterFrame->u8Regid;
+	*pu8CurrByte++ = pstrHostIfRegisterFrame->reg_id;
 	memcpy(pu8CurrByte, &pstrHostIfRegisterFrame->frame_type, sizeof(u16));
 
 	wid.size = sizeof(u16) + 2;
@@ -4422,12 +4422,12 @@ s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool
 	switch (u16FrameType) {
 	case ACTION:
 		PRINT_D(HOSTINF_DBG, "ACTION\n");
-		msg.body.reg_frame.u8Regid = ACTION_FRM_IDX;
+		msg.body.reg_frame.reg_id = ACTION_FRM_IDX;
 		break;
 
 	case PROBE_REQ:
 		PRINT_D(HOSTINF_DBG, "PROBE REQ\n");
-		msg.body.reg_frame.u8Regid = PROBE_REQ_IDX;
+		msg.body.reg_frame.reg_id = PROBE_REQ_IDX;
 		break;
 
 	default:
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f4239a7..6cca6e0 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -247,7 +247,7 @@ struct remain_ch {
 struct reg_frame {
 	bool reg;
 	u16 frame_type;
-	u8 u8Regid;
+	u8 reg_id;
 };
 
 
-- 
1.9.1

