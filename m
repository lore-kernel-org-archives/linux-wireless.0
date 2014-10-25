Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57539 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbaJYTSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:18:12 -0400
Received: by mail-wg0-f48.google.com with SMTP id m15so1210070wgh.7
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:18:11 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/31] staging: vt6655: mac80211 conversion: changes to set channel
Date: Sat, 25 Oct 2014 09:20:24 +0100
Message-Id: <1414225241-5480-15-git-send-email-tvboxspy@gmail.com> (sfid-20141025_211824_938824_C3BF6EC0)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
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
index 5f0cf90..48ad8a4 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -668,16 +668,6 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
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
 	// clear NAV
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_MACCR, MACCR_CLRNAV);
 
@@ -707,7 +697,7 @@ bool set_channel(void *pDeviceHandler, unsigned int uConnectionChannel)
 		MACvSelectPage0(pDevice->PortOffset);
 	}
 
-	if (pDevice->eCurrentPHYType == PHY_TYPE_11B)
+	if (pDevice->byBBType == BB_TYPE_11B)
 		RFbSetPower(pDevice, RATE_1M, pDevice->byCurrentCh);
 	else
 		RFbSetPower(pDevice, RATE_6M, pDevice->byCurrentCh);
-- 
1.9.1

