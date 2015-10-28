Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42234 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbbJ1HA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:00:56 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 33/80] staging: wilc1000: rename u8Regid of struct reg_frame
Date: Wed, 28 Oct 2015 15:59:53 +0900
Message-ID: <1446015640-29398-33-git-send-email-glen.lee@atmel.com> (sfid-20151028_080101_837656_4EA8910C)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
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
index cbcb621..543d223 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2566,7 +2566,7 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 	pu8CurrByte = wid.val;
 
 	*pu8CurrByte++ = pstrHostIfRegisterFrame->reg;
-	*pu8CurrByte++ = pstrHostIfRegisterFrame->u8Regid;
+	*pu8CurrByte++ = pstrHostIfRegisterFrame->reg_id;
 	memcpy(pu8CurrByte, &pstrHostIfRegisterFrame->frame_type, sizeof(u16));
 
 	wid.size = sizeof(u16) + 2;
@@ -4419,12 +4419,12 @@ s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool
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
index 58c3cbc..14563d3 100644
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

