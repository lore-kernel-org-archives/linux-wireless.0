Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54694 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965128AbaGESY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2014 14:24:58 -0400
Received: by mail-wg0-f42.google.com with SMTP id n12so963420wgh.1
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2014 11:24:57 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/8] staging: vt6656: vnt_set_channel remove power setting functions
Date: Sat,  5 Jul 2014 19:24:25 +0100
Message-Id: <1404584667-3582-6-git-send-email-tvboxspy@gmail.com> (sfid-20140705_202504_806473_49A3A046)
In-Reply-To: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com>
References: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Power setting is already done in vnt_config and vnt_tx_packet.

Just check that for connection_channel, if invalid return.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 1849e34..a5f8df1 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -74,15 +74,8 @@ static const u16 cwRXBCNTSFOff[MAX_RATE] =
 void vnt_set_channel(struct vnt_private *priv, u32 connection_channel)
 {
 
-	if (priv->byBBType == BB_TYPE_11A) {
-		if ((connection_channel < (CB_MAX_CHANNEL_24G + 1)) ||
-					(connection_channel > CB_MAX_CHANNEL))
-			connection_channel = (CB_MAX_CHANNEL_24G + 1);
-	} else {
-		if ((connection_channel > CB_MAX_CHANNEL_24G) ||
-						(connection_channel == 0))
-			connection_channel = 1;
-	}
+	if (connection_channel > CB_MAX_CHANNEL || !connection_channel)
+		return;
 
 	/* clear NAV */
 	vnt_mac_reg_bits_on(priv, MAC_REG_MACCR, MACCR_CLRNAV);
@@ -93,20 +86,6 @@ void vnt_set_channel(struct vnt_private *priv, u32 connection_channel)
 	vnt_control_out(priv, MESSAGE_TYPE_SELECT_CHANNLE,
 					connection_channel, 0, 0, NULL);
 
-	if (priv->byBBType == BB_TYPE_11A) {
-		priv->byCurPwr = 0xff;
-		vnt_rf_set_txpower(priv,
-			priv->abyOFDMAPwrTbl[connection_channel-15], RATE_54M);
-	} else if (priv->byBBType == BB_TYPE_11G) {
-		priv->byCurPwr = 0xff;
-		vnt_rf_set_txpower(priv,
-			priv->abyOFDMPwrTbl[connection_channel-1], RATE_54M);
-	} else {
-		priv->byCurPwr = 0xff;
-		vnt_rf_set_txpower(priv,
-			priv->abyCCKPwrTbl[connection_channel-1], RATE_1M);
-	}
-
 	vnt_control_out_u8(priv, MESSAGE_REQUEST_MACREG, MAC_REG_CHANNEL,
 		(u8)(connection_channel|0x80));
 }
-- 
1.9.1

