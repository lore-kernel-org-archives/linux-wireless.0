Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:55593 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaFDR00 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 13:26:26 -0400
Received: by mail-wg0-f51.google.com with SMTP id x13so8868946wgg.10
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 10:26:25 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/15] staging: vt6656: PSvDisablePowerSaving remove camel case
Date: Wed,  4 Jun 2014 18:25:22 +0100
Message-Id: <1401902735-3882-2-git-send-email-tvboxspy@gmail.com> (sfid-20140604_192630_262551_02E70E9B)
In-Reply-To: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
References: <1401902735-3882-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/power.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index 718443f..b7c2720 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -125,24 +125,24 @@ void PSvEnablePowerSaving(struct vnt_private *priv, u16 listen_interval)
  *
  */
 
-void PSvDisablePowerSaving(struct vnt_private *pDevice)
+void PSvDisablePowerSaving(struct vnt_private *priv)
 {
 
 	/* disable power saving hw function */
-	vnt_control_out(pDevice, MESSAGE_TYPE_DISABLE_PS, 0,
+	vnt_control_out(priv, MESSAGE_TYPE_DISABLE_PS, 0,
 						0, 0, NULL);
 
 	/* clear AutoSleep */
-	vnt_mac_reg_bits_off(pDevice, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
+	vnt_mac_reg_bits_off(priv, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
 
 	/* set always listen beacon */
-	vnt_mac_reg_bits_on(pDevice, MAC_REG_PSCTL, PSCTL_ALBCN);
-	pDevice->bEnablePSMode = false;
+	vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_ALBCN);
+	priv->bEnablePSMode = false;
 
-	if (pDevice->op_mode == NL80211_IFTYPE_STATION)
-		PSbSendNullPacket(pDevice);
+	if (priv->op_mode == NL80211_IFTYPE_STATION)
+		PSbSendNullPacket(priv);
 
-	pDevice->bPWBitOn = false;
+	priv->bPWBitOn = false;
 }
 
 /*
-- 
1.9.1

