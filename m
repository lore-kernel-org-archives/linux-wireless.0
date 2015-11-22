Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34488 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbbKVJIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 04:08:10 -0500
Received: by wmvv187 with SMTP id v187so123340439wmv.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2015 01:08:09 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/8] staging: vt6655: set_channel replace bResult with ret
Date: Sun, 22 Nov 2015 09:07:17 +0000
Message-Id: <1448183242-3397-3-git-send-email-tvboxspy@gmail.com> (sfid-20151122_100828_685441_C33FCA9E)
In-Reply-To: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com>
References: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/channel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index d1c9116..9ac1ef9 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -176,10 +176,10 @@ void vnt_init_bands(struct vnt_private *priv)
  */
 bool set_channel(struct vnt_private *priv, struct ieee80211_channel *ch)
 {
-	bool bResult = true;
+	bool ret = true;
 
 	if (priv->byCurrentCh == ch->hw_value)
-		return bResult;
+		return ret;
 
 	/* Set VGA to max sensitivity */
 	if (priv->bUpdateBBVGA &&
@@ -200,8 +200,8 @@ bool set_channel(struct vnt_private *priv, struct ieee80211_channel *ch)
 						  ch->hw_value);
 
 	priv->byCurrentCh = ch->hw_value;
-	bResult &= RFbSelectChannel(priv, priv->byRFType,
-				    ch->hw_value);
+	ret &= RFbSelectChannel(priv, priv->byRFType,
+				ch->hw_value);
 
 	/* Init Synthesizer Table */
 	if (priv->bEnablePSMode)
@@ -232,5 +232,5 @@ bool set_channel(struct vnt_private *priv, struct ieee80211_channel *ch)
 	else
 		RFbSetPower(priv, RATE_6M, priv->byCurrentCh);
 
-	return bResult;
+	return ret;
 }
-- 
2.6.2

