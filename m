Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37217 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaEZNAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 09:00:16 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so4321454wiw.16
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 06:00:13 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/11] staging: vt6656: remove dead code ControlvMaskByte
Date: Mon, 26 May 2014 13:59:05 +0100
Message-Id: <1401109148-3593-8-git-send-email-tvboxspy@gmail.com> (sfid-20140526_150023_915494_9169A3B4)
In-Reply-To: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
References: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/control.c | 14 --------------
 drivers/staging/vt6656/control.h |  3 ---
 2 files changed, 17 deletions(-)

diff --git a/drivers/staging/vt6656/control.c b/drivers/staging/vt6656/control.c
index 14346a6..b6e31f3 100644
--- a/drivers/staging/vt6656/control.c
+++ b/drivers/staging/vt6656/control.c
@@ -50,17 +50,3 @@ void ControlvReadByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
 			reg_off, reg, sizeof(u8), data);
 	return;
 }
-
-void ControlvMaskByte(struct vnt_private *pDevice, u8 reg_type, u8 reg_off,
-			u8 reg_mask, u8 data)
-{
-	u8 reg_data[2];
-
-	reg_data[0] = data;
-	reg_data[1] = reg_mask;
-
-	vnt_control_out(pDevice, MESSAGE_TYPE_WRITE_MASK, reg_off,
-			reg_type, ARRAY_SIZE(reg_data), reg_data);
-
-	return;
-}
diff --git a/drivers/staging/vt6656/control.h b/drivers/staging/vt6656/control.h
index e4e252e..48f4836 100644
--- a/drivers/staging/vt6656/control.h
+++ b/drivers/staging/vt6656/control.h
@@ -36,7 +36,4 @@
 void ControlvReadByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
 			u8 *data);
 
-void ControlvMaskByte(struct vnt_private *pDevice, u8 reg_type, u8 reg_off,
-			u8 reg_mask, u8 data);
-
 #endif /* __CONTROL_H__ */
-- 
1.9.1

