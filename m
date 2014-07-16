Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54679 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaGPVaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:30:24 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so1985219wiv.13
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:30:19 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/21] staging: vt6656: rename BBvSetAntennaMode to vnt_set_antenna_mode
Date: Wed, 16 Jul 2014 22:21:52 +0100
Message-Id: <1405545731-6082-2-git-send-email-tvboxspy@gmail.com> (sfid-20140716_233027_507376_8F04CD9E)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dropping BB

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 2 +-
 drivers/staging/vt6656/baseband.h | 2 +-
 drivers/staging/vt6656/main_usb.c | 2 +-
 drivers/staging/vt6656/wcmd.c     | 8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index e56defa..6586614 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -345,7 +345,7 @@ void vnt_get_phy_field(struct vnt_private *priv, u32 frame_length,
  * Return Value: none
  *
  */
-void BBvSetAntennaMode(struct vnt_private *priv, u8 antenna_mode)
+void vnt_set_antenna_mode(struct vnt_private *priv, u8 antenna_mode)
 {
 	switch (antenna_mode) {
 	case ANT_TXA:
diff --git a/drivers/staging/vt6656/baseband.h b/drivers/staging/vt6656/baseband.h
index c73244b..a612690 100644
--- a/drivers/staging/vt6656/baseband.h
+++ b/drivers/staging/vt6656/baseband.h
@@ -95,7 +95,7 @@ void vnt_get_phy_field(struct vnt_private *, u32 frame_length,
 
 void BBvSetShortSlotTime(struct vnt_private *);
 void BBvSetVGAGainOffset(struct vnt_private *, u8 byData);
-void BBvSetAntennaMode(struct vnt_private *, u8 byAntennaMode);
+void vnt_set_antenna_mode(struct vnt_private *, u8);
 int BBbVT3184Init(struct vnt_private *);
 void BBvSetDeepSleep(struct vnt_private *);
 void BBvExitDeepSleep(struct vnt_private *);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index c595a15..7cd4c2b 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -371,7 +371,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 	}
 
 	/* Set initial antenna mode */
-	BBvSetAntennaMode(pDevice, pDevice->byRxAntennaMode);
+	vnt_set_antenna_mode(pDevice, pDevice->byRxAntennaMode);
 
 	/* get Auto Fall Back type */
 	pDevice->byAutoFBCtrl = AUTO_FB_0;
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index bf41e67..c56b7b3 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -151,15 +151,15 @@ void vnt_run_command(struct work_struct *work)
 		if (priv->dwRxAntennaSel == 0) {
 			priv->dwRxAntennaSel = 1;
 			if (priv->bTxRxAntInv == true)
-				BBvSetAntennaMode(priv, ANT_RXA);
+				vnt_set_antenna_mode(priv, ANT_RXA);
 			else
-				BBvSetAntennaMode(priv, ANT_RXB);
+				vnt_set_antenna_mode(priv, ANT_RXB);
 		} else {
 			priv->dwRxAntennaSel = 0;
 			if (priv->bTxRxAntInv == true)
-				BBvSetAntennaMode(priv, ANT_RXB);
+				vnt_set_antenna_mode(priv, ANT_RXB);
 			else
-				BBvSetAntennaMode(priv, ANT_RXA);
+				vnt_set_antenna_mode(priv, ANT_RXA);
 		}
 		break;
 
-- 
2.0.1

