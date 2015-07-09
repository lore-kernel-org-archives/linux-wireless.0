Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37405 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbbGIQBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 12:01:45 -0400
Received: by wiclp1 with SMTP id lp1so113450727wic.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 09:01:43 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/4] staging: vt6655: Correct listen interval TBTT wake up
Date: Thu,  9 Jul 2015 17:01:27 +0100
Message-Id: <1436457687-3113-4-git-send-email-tvboxspy@gmail.com> (sfid-20150709_180152_552581_21CDC59C)
In-Reply-To: <1436457687-3113-1-git-send-email-tvboxspy@gmail.com>
References: <1436457687-3113-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PSbIsNextTBTTWakeUp is called at beacon intervals.

The should listen to next beacon on count down of wake_up_count == 1.

This restores this back to vendors code but modified for mac80211.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h |  1 +
 drivers/staging/vt6655/power.c  | 16 ++++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 5cf1b33..6aebb49 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -403,6 +403,7 @@ struct vnt_private {
 	unsigned char abyEEPROM[EEP_MAX_CONTEXT_SIZE]; /* unsigned long alignment */
 
 	unsigned short wBeaconInterval;
+	u16 wake_up_count;
 
 	struct work_struct interrupt_work;
 
diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index be3c4e9..06e6b9d 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -157,10 +157,18 @@ PSbIsNextTBTTWakeUp(
 	struct ieee80211_conf *conf = &hw->conf;
 	bool bWakeUp = false;
 
-	if (conf->listen_interval == 1) {
-		/* Turn on wake up to listen next beacon */
-		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_LNBCN);
-		bWakeUp = true;
+	if (conf->listen_interval > 1) {
+		if (!pDevice->wake_up_count)
+			pDevice->wake_up_count = conf->listen_interval;
+
+		--pDevice->wake_up_count;
+
+		if (pDevice->wake_up_count == 1) {
+			/* Turn on wake up to listen next beacon */
+			MACvRegBitsOn(pDevice->PortOffset,
+				      MAC_REG_PSCTL, PSCTL_LNBCN);
+			bWakeUp = true;
+		}
 	}
 
 	return bWakeUp;
-- 
2.1.4

