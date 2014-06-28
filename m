Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46664 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaF1W4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2014 18:56:37 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so6597831wgg.8
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 15:56:36 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 8/8] staging: vt6656: device_init_registers move out vnt_set_bss_mode
Date: Sat, 28 Jun 2014 23:55:46 +0100
Message-Id: <1403996146-4082-8-git-send-email-tvboxspy@gmail.com> (sfid-20140629_005641_723503_D10FDD90)
In-Reply-To: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com>
References: <1403996146-4082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move to vnt_add_interface and allow to refresh at the start
of every software scan in vnt_sw_scan_start

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index e0ed1bb..14845ec 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -438,7 +438,6 @@ static int device_init_registers(struct vnt_private *pDevice)
 		pDevice->bShortSlotTime = false;
 
 	BBvSetShortSlotTime(pDevice);
-	vnt_set_bss_mode(pDevice);
 
 	pDevice->byRadioCtl = pDevice->abyEEPROM[EEP_OFS_RADIOCTL];
 	pDevice->bHWRadioOff = false;
@@ -749,6 +748,8 @@ static int vnt_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	priv->op_mode = vif->type;
 
+	vnt_set_bss_mode(priv);
+
 	/* LED blink on TX */
 	vnt_mac_set_led(priv, LEDSTS_STS, LEDSTS_INTER);
 
@@ -992,6 +993,7 @@ static void vnt_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct vnt_private *priv = hw->priv;
 
+	vnt_set_bss_mode(priv);
 	/* Set max sensitivity*/
 	BBvUpdatePreEDThreshold(priv, true);
 }
-- 
1.9.1

