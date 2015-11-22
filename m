Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34480 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbKVJIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 04:08:09 -0500
Received: by wmvv187 with SMTP id v187so123340172wmv.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2015 01:08:08 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/8] staging: vt6655: set_channel replace void handler.
Date: Sun, 22 Nov 2015 09:07:16 +0000
Message-Id: <1448183242-3397-2-git-send-email-tvboxspy@gmail.com> (sfid-20151122_100820_848349_652FC1E5)
In-Reply-To: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com>
References: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with struct vnt_private.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/channel.c | 3 +--
 drivers/staging/vt6655/channel.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index 6edccb42..d1c9116 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -174,9 +174,8 @@ void vnt_init_bands(struct vnt_private *priv)
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool set_channel(void *pDeviceHandler, struct ieee80211_channel *ch)
+bool set_channel(struct vnt_private *priv, struct ieee80211_channel *ch)
 {
-	struct vnt_private *priv = pDeviceHandler;
 	bool bResult = true;
 
 	if (priv->byCurrentCh == ch->hw_value)
diff --git a/drivers/staging/vt6655/channel.h b/drivers/staging/vt6655/channel.h
index e2be6fc..2d613e7 100644
--- a/drivers/staging/vt6655/channel.h
+++ b/drivers/staging/vt6655/channel.h
@@ -27,6 +27,6 @@
 
 void vnt_init_bands(struct vnt_private *);
 
-bool set_channel(void *pDeviceHandler, struct ieee80211_channel *);
+bool set_channel(struct vnt_private *, struct ieee80211_channel *);
 
 #endif /* _CHANNEL_H_ */
-- 
2.6.2

