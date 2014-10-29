Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51431 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbaJ2RpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:45:12 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so5301943wiv.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:45:11 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 15/34] staging: vt6655: mac80211 conversion: enable power saving
Date: Wed, 29 Oct 2014 17:43:50 +0000
Message-Id: <1414604649-9105-16-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185356_361202_5A94280F)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert PSvEnablePowerSaving and PSvEnablePowerSaving

Remove mgmt->wCurrAID and use pDevice->current_aid

We nolonger send the PSbSendNullPacket.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/power.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index 08241b9..fe33bb2 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -73,8 +73,7 @@ PSvEnablePowerSaving(
 )
 {
 	struct vnt_private *pDevice = hDeviceContext;
-	PSMgmtObject    pMgmt = pDevice->pMgmt;
-	unsigned short wAID = pMgmt->wCurrAID | BIT14 | BIT15;
+	u16 wAID = pDevice->current_aid | BIT(14) | BIT(15);
 
 	// set period of power up before TBTT
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_PWBT, C_PWBT);
@@ -83,7 +82,9 @@ PSvEnablePowerSaving(
 		VNSvOutPortW(pDevice->PortOffset + MAC_REG_AIDATIM, wAID);
 	} else {
 		// set ATIM Window
+#if 0 /* TODO atim window */
 		MACvWriteATIMW(pDevice->PortOffset, pMgmt->wCurrATIMWindow);
+#endif
 	}
 	// Set AutoSleep
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
@@ -95,22 +96,15 @@ PSvEnablePowerSaving(
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_ALBCN);
 		// first time set listen next beacon
 		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_LNBCN);
-		pMgmt->wCountToWakeUp = wListenInterval;
 	} else {
 		// always listen beacon
 		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_ALBCN);
-		pMgmt->wCountToWakeUp = 0;
 	}
 
 	// enable power saving hw function
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_PSEN);
 	pDevice->bEnablePSMode = true;
 
-	/* We don't send null pkt in ad hoc mode since beacon will handle this. */
-	if (pDevice->op_mode != NL80211_IFTYPE_ADHOC &&
-	    pDevice->op_mode == NL80211_IFTYPE_STATION)
-		PSbSendNullPacket(pDevice);
-
 	pDevice->bPWBitOn = true;
 	pr_debug("PS:Power Saving Mode Enable...\n");
 }
@@ -143,9 +137,6 @@ PSvDisablePowerSaving(
 
 	pDevice->bEnablePSMode = false;
 
-	if (pDevice->op_mode == NL80211_IFTYPE_STATION)
-		PSbSendNullPacket(pDevice);
-
 	pDevice->bPWBitOn = false;
 }
 
-- 
2.1.0

