Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63019 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932626AbaESTeb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 15:34:31 -0400
Received: by mail-we0-f174.google.com with SMTP id k48so6095988wev.33
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2014 12:34:29 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/20] staging: vt6656: BBvSetAntennaMode remove camel case.
Date: Mon, 19 May 2014 20:33:04 +0100
Message-Id: <1400527992-3061-12-git-send-email-tvboxspy@gmail.com> (sfid-20140519_213435_539261_37A03ADC)
In-Reply-To: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
References: <1400527992-3061-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

changes
pDevice -> priv
byAntennaMode -> antenna_mode

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 5e2ffab..03ecde8 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -859,31 +859,31 @@ void BBvCalculateParameter(struct vnt_private *priv, u32 frame_length,
  *
  * Parameters:
  *  In:
- *      pDevice          - Device Structure
- *      byAntennaMode    - Antenna Mode
+ *	priv		- Device Structure
+ *	antenna_mode	- Antenna Mode
  *  Out:
  *      none
  *
  * Return Value: none
  *
  */
-void BBvSetAntennaMode(struct vnt_private *pDevice, u8 byAntennaMode)
+void BBvSetAntennaMode(struct vnt_private *priv, u8 antenna_mode)
 {
-	switch (byAntennaMode) {
+	switch (antenna_mode) {
 	case ANT_TXA:
 	case ANT_TXB:
 		break;
 	case ANT_RXA:
-		pDevice->byBBRxConf &= 0xFC;
+		priv->byBBRxConf &= 0xFC;
 		break;
 	case ANT_RXB:
-		pDevice->byBBRxConf &= 0xFE;
-		pDevice->byBBRxConf |= 0x02;
+		priv->byBBRxConf &= 0xFE;
+		priv->byBBRxConf |= 0x02;
 		break;
 	}
 
-	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_SET_ANTMD,
-		(u16)byAntennaMode, 0, 0, NULL);
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SET_ANTMD,
+		(u16)antenna_mode, 0, 0, NULL);
 }
 
 /*
-- 
1.9.1

