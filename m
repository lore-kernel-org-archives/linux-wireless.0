Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42212 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755507AbbJ1HAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:00:50 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 32/80] staging: wilc1000: rename u16FrameType of struct reg_frame
Date: Wed, 28 Oct 2015 15:59:52 +0900
Message-ID: <1446015640-29398-32-git-send-email-glen.lee@atmel.com> (sfid-20151028_080100_504982_B7B044B9)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u16FrameType of struct reg_frame to frame_type
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 7 +++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 83d2606..cbcb621 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2555,7 +2555,7 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 
 	PRINT_D(HOSTINF_DBG, "Handling frame register : %d FrameType: %d\n",
 		pstrHostIfRegisterFrame->reg,
-		pstrHostIfRegisterFrame->u16FrameType);
+		pstrHostIfRegisterFrame->frame_type);
 
 	wid.id = (u16)WID_REGISTER_FRAME;
 	wid.type = WID_STR;
@@ -2567,8 +2567,7 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 
 	*pu8CurrByte++ = pstrHostIfRegisterFrame->reg;
 	*pu8CurrByte++ = pstrHostIfRegisterFrame->u8Regid;
-	memcpy(pu8CurrByte, &pstrHostIfRegisterFrame->u16FrameType,
-	       sizeof(u16));
+	memcpy(pu8CurrByte, &pstrHostIfRegisterFrame->frame_type, sizeof(u16));
 
 	wid.size = sizeof(u16) + 2;
 
@@ -4432,7 +4431,7 @@ s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool
 		PRINT_D(HOSTINF_DBG, "Not valid frame type\n");
 		break;
 	}
-	msg.body.reg_frame.u16FrameType = u16FrameType;
+	msg.body.reg_frame.frame_type = u16FrameType;
 	msg.body.reg_frame.reg = bReg;
 	msg.drv = hif_drv;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 4a588c4..58c3cbc 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -246,7 +246,7 @@ struct remain_ch {
 
 struct reg_frame {
 	bool reg;
-	u16 u16FrameType;
+	u16 frame_type;
 	u8 u8Regid;
 };
 
-- 
1.9.1

