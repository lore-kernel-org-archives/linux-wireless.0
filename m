Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42189 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbbJ1HAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:00:44 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 31/80] staging: wilc1000: rename bReg of struct reg_frame
Date: Wed, 28 Oct 2015 15:59:51 +0900
Message-ID: <1446015640-29398-31-git-send-email-glen.lee@atmel.com> (sfid-20151028_081655_014787_91F42B71)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames bReg of struct reg_frame to reg
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 +++++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b29d651..83d2606 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2553,7 +2553,9 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 	struct wid wid;
 	u8 *pu8CurrByte;
 
-	PRINT_D(HOSTINF_DBG, "Handling frame register Flag : %d FrameType: %d\n", pstrHostIfRegisterFrame->bReg, pstrHostIfRegisterFrame->u16FrameType);
+	PRINT_D(HOSTINF_DBG, "Handling frame register : %d FrameType: %d\n",
+		pstrHostIfRegisterFrame->reg,
+		pstrHostIfRegisterFrame->u16FrameType);
 
 	wid.id = (u16)WID_REGISTER_FRAME;
 	wid.type = WID_STR;
@@ -2563,7 +2565,7 @@ static int Handle_RegisterFrame(struct host_if_drv *hif_drv,
 
 	pu8CurrByte = wid.val;
 
-	*pu8CurrByte++ = pstrHostIfRegisterFrame->bReg;
+	*pu8CurrByte++ = pstrHostIfRegisterFrame->reg;
 	*pu8CurrByte++ = pstrHostIfRegisterFrame->u8Regid;
 	memcpy(pu8CurrByte, &pstrHostIfRegisterFrame->u16FrameType,
 	       sizeof(u16));
@@ -4431,7 +4433,7 @@ s32 host_int_frame_register(struct host_if_drv *hif_drv, u16 u16FrameType, bool
 		break;
 	}
 	msg.body.reg_frame.u16FrameType = u16FrameType;
-	msg.body.reg_frame.bReg = bReg;
+	msg.body.reg_frame.reg = bReg;
 	msg.drv = hif_drv;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 627ea43..4a588c4 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -245,7 +245,7 @@ struct remain_ch {
 };
 
 struct reg_frame {
-	bool bReg;
+	bool reg;
 	u16 u16FrameType;
 	u8 u8Regid;
 };
-- 
1.9.1

