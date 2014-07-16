Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35202 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaGPVXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:12 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so1553233wgg.16
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:11 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/21] staging: vt6656: rename BBbVT3184Init to vnt_vt3184_init
Date: Wed, 16 Jul 2014 22:21:53 +0100
Message-Id: <1405545731-6082-3-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232325_265569_6E365695)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dropping BB

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 4 ++--
 drivers/staging/vt6656/baseband.h | 2 +-
 drivers/staging/vt6656/main_usb.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 6586614..44068d0 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -29,7 +29,7 @@
  *	vnt_get_frame_time	- Calculate data frame transmitting time
  *	vnt_get_phy_field	- Calculate PhyLength, PhyService and Phy
  *				  Signal parameter for baseband Tx
- *	BBbVT3184Init		- VIA VT3184 baseband chip init code
+ *	vnt_vt3184_init		- VIA VT3184 baseband chip init code
  *
  * Revision History:
  *
@@ -378,7 +378,7 @@ void vnt_set_antenna_mode(struct vnt_private *priv, u8 antenna_mode)
  *
  */
 
-int BBbVT3184Init(struct vnt_private *priv)
+int vnt_vt3184_init(struct vnt_private *priv)
 {
 	int status;
 	u16 length;
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index a612690..f102ec0 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -96,7 +96,7 @@ void vnt_get_phy_field(struct vnt_private *, u32 frame_length,
 void BBvSetShortSlotTime(struct vnt_private *);
 void BBvSetVGAGainOffset(struct vnt_private *, u8 byData);
 void vnt_set_antenna_mode(struct vnt_private *, u8);
-int BBbVT3184Init(struct vnt_private *);
+int vnt_vt3184_init(struct vnt_private *);
 void BBvSetDeepSleep(struct vnt_private *);
 void BBvExitDeepSleep(struct vnt_private *);
 void BBvUpdatePreEDThreshold(struct vnt_private *, int scanning);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 7cd4c2b..caafb93 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -247,8 +247,8 @@ static int device_init_registers(struct vnt_private *pDevice)
 		}
 	}
 
-	if (!BBbVT3184Init(pDevice)) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" BBbVT3184Init fail\n");
+	if (!vnt_vt3184_init(pDevice)) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" vnt_vt3184_init fail\n");
 		return false;
 	}
 
-- 
2.0.1

