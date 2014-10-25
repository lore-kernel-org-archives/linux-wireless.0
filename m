Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:37650 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaJYTlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:41:04 -0400
Received: by mail-wg0-f49.google.com with SMTP id x12so3131231wgg.8
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:41:02 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 25/31] staging: vt6655: mac80211 conversion: PSbIsNextTBTTWakeUp convert to mac80211
Date: Sat, 25 Oct 2014 09:20:35 +0100
Message-Id: <1414225241-5480-26-git-send-email-tvboxspy@gmail.com> (sfid-20141025_214108_766148_B0E68ABD)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wake up to listen to next beacon when struct ieee80211_conf -> listen_interval == 1

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/power.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index fe33bb2..5371802 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -327,21 +327,14 @@ PSbIsNextTBTTWakeUp(
 )
 {
 	struct vnt_private *pDevice = hDeviceContext;
-	PSMgmtObject        pMgmt = pDevice->pMgmt;
+	struct ieee80211_hw *hw = pDevice->hw;
+	struct ieee80211_conf *conf = &hw->conf;
 	bool bWakeUp = false;
 
-	if (pMgmt->wListenInterval >= 2) {
-		if (pMgmt->wCountToWakeUp == 0)
-			pMgmt->wCountToWakeUp = pMgmt->wListenInterval;
-
-		pMgmt->wCountToWakeUp--;
-
-		if (pMgmt->wCountToWakeUp == 1) {
-			// Turn on wake up to listen next beacon
-			MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_LNBCN);
-			bWakeUp = true;
-		}
-
+	if (conf->listen_interval == 1) {
+		/* Turn on wake up to listen next beacon */
+		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_LNBCN);
+		bWakeUp = true;
 	}
 
 	return bWakeUp;
-- 
1.9.1

