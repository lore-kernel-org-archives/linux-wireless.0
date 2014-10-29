Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:43714 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbaJ2RpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:45:10 -0400
Received: by mail-wg0-f50.google.com with SMTP id z12so2447452wgg.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:45:09 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 14/34] staging: vt6655: mac80211 conversion: changes to set channel
Date: Wed, 29 Oct 2014 17:43:49 +0000
Message-Id: <1414604649-9105-15-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185348_444131_92092590)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove call to sChannelTbl, the channel under mac80211 is always valid.

CARDbSetPhyParameter is nolonger set here.

RFbSetPower is now set on byBBType

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/channel.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index 4b3c798..2379696 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -665,16 +665,6 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 	if (pDevice->byCurrentCh == uConnectionChannel)
 		return bResult;
 
-	if (!sChannelTbl[uConnectionChannel].bValid)
-		return false;
-
-	if ((uConnectionChannel > CB_MAX_CHANNEL_24G) &&
-	    (pDevice->eCurrentPHYType != PHY_TYPE_11A)) {
-		CARDbSetPhyParameter(pDevice, PHY_TYPE_11A, 0, 0, NULL, NULL);
-	} else if ((uConnectionChannel <= CB_MAX_CHANNEL_24G) &&
-		   (pDevice->eCurrentPHYType == PHY_TYPE_11A)) {
-		CARDbSetPhyParameter(pDevice, PHY_TYPE_11G, 0, 0, NULL, NULL);
-	}
 	/* clear NAV */
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_MACCR, MACCR_CLRNAV);
 
@@ -702,7 +692,7 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 		MACvSelectPage0(pDevice->PortOffset);
 	}
 
-	if (pDevice->eCurrentPHYType == PHY_TYPE_11B)
+	if (pDevice->byBBType == BB_TYPE_11B)
 		RFbSetPower(pDevice, RATE_1M, pDevice->byCurrentCh);
 	else
 		RFbSetPower(pDevice, RATE_6M, pDevice->byCurrentCh);
-- 
2.1.0

