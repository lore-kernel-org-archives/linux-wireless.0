Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36174 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbbKVJIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 04:08:14 -0500
Received: by wmww144 with SMTP id w144so63722853wmw.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2015 01:08:13 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/8] staging: vt6655: PSbIsNextTBTTWakeUp Rename bWakeUp wake_up
Date: Sun, 22 Nov 2015 09:07:21 +0000
Message-Id: <1448183242-3397-7-git-send-email-tvboxspy@gmail.com> (sfid-20151122_100843_528334_FC717751)
In-Reply-To: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com>
References: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/power.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index ad44746..5e968c9 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -151,7 +151,7 @@ PSbIsNextTBTTWakeUp(
 {
 	struct ieee80211_hw *hw = priv->hw;
 	struct ieee80211_conf *conf = &hw->conf;
-	bool bWakeUp = false;
+	bool wake_up = false;
 
 	if (conf->listen_interval > 1) {
 		if (!priv->wake_up_count)
@@ -163,9 +163,9 @@ PSbIsNextTBTTWakeUp(
 			/* Turn on wake up to listen next beacon */
 			MACvRegBitsOn(priv->PortOffset,
 				      MAC_REG_PSCTL, PSCTL_LNBCN);
-			bWakeUp = true;
+			wake_up = true;
 		}
 	}
 
-	return bWakeUp;
+	return wake_up;
 }
-- 
2.6.2

