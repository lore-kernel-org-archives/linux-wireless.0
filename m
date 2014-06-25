Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37793 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbaFYUPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:45 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so8455630wib.6
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 15/17] staging: vt6656: vnt_mac_set_keyentry remove byLocalID check
Date: Wed, 25 Jun 2014 21:14:36 +0100
Message-Id: <1403727278-6666-16-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221619_769963_6977D329)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now set in vnt_set_keys.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index b06436f..a60240c 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -125,10 +125,6 @@ void vnt_mac_set_keyentry(struct vnt_private *priv, u16 key_ctl, u32 entry_idx,
 	struct vnt_mac_set_key set_key;
 	u16 offset;
 
-	if (priv->byLocalID <= MAC_REVISION_A1)
-		if (priv->vnt_mgmt.byCSSPK == KEY_CTL_CCMP)
-			return;
-
 	offset = MISCFIFO_KEYETRY0;
 	offset += (entry_idx * MISCFIFO_KEYENTRYSIZE);
 
-- 
1.9.1

