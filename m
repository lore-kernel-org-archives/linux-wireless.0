Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58100 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbaJ2Rpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:45:55 -0400
Received: by mail-wi0-f173.google.com with SMTP id n3so2400192wiv.12
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:45:54 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 25/34] staging: vt6655: mac80211 conversion: PSbIsNextTBTTWakeUp convert to mac80211
Date: Wed, 29 Oct 2014 17:44:00 +0000
Message-Id: <1414604649-9105-26-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184840_514175_0AB6566C)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
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
2.1.0

