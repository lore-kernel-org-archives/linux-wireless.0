Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63313 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759038AbaGRWBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 18:01:48 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so3952098wgh.17
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2014 15:01:47 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/5] staging: vt6656: put radio power off and on into correct state every time.
Date: Fri, 18 Jul 2014 23:00:54 +0100
Message-Id: <1405720856-2737-3-git-send-email-tvboxspy@gmail.com> (sfid-20140719_000151_776942_68E4C800)
In-Reply-To: <1405720856-2737-1-git-send-email-tvboxspy@gmail.com>
References: <1405720856-2737-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When radio is off bit GPIO3_INTMD should be on and off when radio is on.

Add these to the tail of vnt_radio_power_off and vnt_radio_power_on
and remove variable bHWRadioOff.

In device_init_registers just check GPIO3_DATA are in correct state and
always power on.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     |  7 ++++---
 drivers/staging/vt6656/device.h   |  1 -
 drivers/staging/vt6656/main_usb.c | 15 +++------------
 3 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index ca77a19..19a7931 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -750,6 +750,8 @@ int vnt_radio_power_off(struct vnt_private *priv)
 
 	vnt_set_deep_sleep(priv);
 
+	vnt_mac_reg_bits_on(priv, MAC_REG_GPIOCTL1, GPIO3_INTMD);
+
 	return ret;
 }
 
@@ -769,9 +771,6 @@ int vnt_radio_power_on(struct vnt_private *priv)
 {
 	int ret = true;
 
-	if (priv->bHWRadioOff == true)
-		return false;
-
 	vnt_exit_deep_sleep(priv);
 
 	vnt_mac_reg_bits_on(priv, MAC_REG_HOSTCR, HOSTCR_RXON);
@@ -788,6 +787,8 @@ int vnt_radio_power_on(struct vnt_private *priv)
 		break;
 	}
 
+	vnt_mac_reg_bits_off(priv, MAC_REG_GPIOCTL1, GPIO3_INTMD);
+
 	return ret;
 }
 
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 69cac95..ffcbaca 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -326,7 +326,6 @@ struct vnt_private {
 	u8 byRxAntennaMode;
 	u8 byTxAntennaMode;
 	u8 byRadioCtl;
-	u8 bHWRadioOff;
 
 	/* IFS & Cw */
 	u32 uSIFS;  /* Current SIFS */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 68367414..0802ecd 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -354,7 +354,6 @@ static int device_init_registers(struct vnt_private *priv)
 	vnt_set_short_slot_time(priv);
 
 	priv->byRadioCtl = priv->abyEEPROM[EEP_OFS_RADIOCTL];
-	priv->bHWRadioOff = false;
 
 	if ((priv->byRadioCtl & EEP_RADIOCTL_ENABLE) != 0) {
 		status = vnt_control_in(priv, MESSAGE_TYPE_READ,
@@ -363,16 +362,12 @@ static int device_init_registers(struct vnt_private *priv)
 		if (status != STATUS_SUCCESS)
 			return false;
 
-		if ((tmp & GPIO3_DATA) == 0) {
-			priv->bHWRadioOff = true;
+		if ((tmp & GPIO3_DATA) == 0)
 			vnt_mac_reg_bits_on(priv, MAC_REG_GPIOCTL1,
 								GPIO3_INTMD);
-		} else {
+		else
 			vnt_mac_reg_bits_off(priv, MAC_REG_GPIOCTL1,
 								GPIO3_INTMD);
-			priv->bHWRadioOff = false;
-		}
-
 	}
 
 	vnt_mac_set_led(priv, LEDSTS_TMLEN, 0x38);
@@ -381,11 +376,7 @@ static int device_init_registers(struct vnt_private *priv)
 
 	vnt_mac_reg_bits_on(priv, MAC_REG_GPIOCTL0, 0x01);
 
-	if (priv->bHWRadioOff == true) {
-		vnt_radio_power_off(priv);
-	} else {
-		vnt_radio_power_on(priv);
-	}
+	vnt_radio_power_on(priv);
 
 	dev_dbg(&priv->usb->dev, "<----INIbInitAdapter Exit\n");
 
-- 
2.0.1

