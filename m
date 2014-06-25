Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:60821 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbaFYUPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:30 -0400
Received: by mail-we0-f178.google.com with SMTP id x48so2532968wes.9
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/17] staging: vt6656: mac80211 conversion: enable power saving
Date: Wed, 25 Jun 2014 21:14:29 +0100
Message-Id: <1403727278-6666-9-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221557_579585_9A9C4556)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert vnt_enable_power_saving and vnt_disable_power_saving

Remove mgmt->wCurrAID and use priv->current_aid

We nolonger send the PSbSendNullPacket from vnt_enable_power_saving

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/power.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index cc28192..6c34d36 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -60,8 +60,7 @@ static int msglevel = MSG_LEVEL_INFO;
 
 void vnt_enable_power_saving(struct vnt_private *priv, u16 listen_interval)
 {
-	struct vnt_manager *mgmt = &priv->vnt_mgmt;
-	u16 aid = mgmt->wCurrAID | BIT14 | BIT15;
+	u16 aid = priv->current_aid | BIT(14) | BIT(15);
 
 	/* set period of power up before TBTT */
 	vnt_mac_write_word(priv, MAC_REG_PWBT, C_PWBT);
@@ -92,26 +91,12 @@ void vnt_enable_power_saving(struct vnt_private *priv, u16 listen_interval)
 
 		/* first time set listen next beacon */
 		vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_LNBCN);
-
-		mgmt->wCountToWakeUp = listen_interval;
-
 	} else {
 
 		/* always listen beacon */
 		vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_ALBCN);
-
-		mgmt->wCountToWakeUp = 0;
 	}
 
-	priv->bEnablePSMode = true;
-
-	/* We don't send null pkt in ad hoc mode
-	 * since beacon will handle this.
-	 */
-	if (priv->op_mode == NL80211_IFTYPE_STATION)
-		PSbSendNullPacket(priv);
-
-	priv->bPWBitOn = true;
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS:Power Saving Mode Enable...\n");
 }
 
@@ -137,12 +122,6 @@ void vnt_disable_power_saving(struct vnt_private *priv)
 
 	/* set always listen beacon */
 	vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_ALBCN);
-	priv->bEnablePSMode = false;
-
-	if (priv->op_mode == NL80211_IFTYPE_STATION)
-		PSbSendNullPacket(priv);
-
-	priv->bPWBitOn = false;
 }
 
 /*
-- 
1.9.1

