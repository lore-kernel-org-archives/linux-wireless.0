Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61600 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759038AbaGRWBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 18:01:44 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so1507310wiw.6
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2014 15:01:43 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/5] staging: vt6656: struct vnt_private remove unused variable bRadioControlOff
Date: Fri, 18 Jul 2014 23:00:52 +0100
Message-Id: <1405720856-2737-1-git-send-email-tvboxspy@gmail.com> (sfid-20140719_000147_864304_D91A07C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This variable is never set.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 2 +-
 drivers/staging/vt6656/device.h   | 1 -
 drivers/staging/vt6656/main_usb.c | 3 +--
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 34ca2a6..ddf7385 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -771,7 +771,7 @@ int vnt_radio_power_on(struct vnt_private *priv)
 {
 	int ret = true;
 
-	if (priv->bHWRadioOff == true || priv->bRadioControlOff == true)
+	if (priv->bHWRadioOff == true)
 		return false;
 
 	priv->bRadioOff = false;
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 757d500..358c620 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -368,7 +368,6 @@ struct vnt_private {
 	int bShortSlotTime;
 	int bBarkerPreambleMd;
 
-	int bRadioControlOff;
 	int bRadioOff;
 
 	/* Power save */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index ff4e18d..68367414 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -381,8 +381,7 @@ static int device_init_registers(struct vnt_private *priv)
 
 	vnt_mac_reg_bits_on(priv, MAC_REG_GPIOCTL0, 0x01);
 
-	if ((priv->bHWRadioOff == true) ||
-				(priv->bRadioControlOff == true)) {
+	if (priv->bHWRadioOff == true) {
 		vnt_radio_power_off(priv);
 	} else {
 		vnt_radio_power_on(priv);
-- 
2.0.1

