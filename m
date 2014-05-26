Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36310 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaEZNAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 09:00:05 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so4342738wiw.10
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 06:00:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/11] staging: vt6656: mac.c remove DBG_PRT debug message.
Date: Mon, 26 May 2014 13:59:00 +0100
Message-Id: <1401109148-3593-3-git-send-email-tvboxspy@gmail.com> (sfid-20140526_150013_946554_1FB75B0E)
In-Reply-To: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
References: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with dev_dbg

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 573ea4f..9211ec1 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -37,9 +37,6 @@
 #include "80211hdr.h"
 #include "control.h"
 
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-static int          msglevel                =MSG_LEVEL_INFO;
-
 /*
  * Description:
  *      Write MAC Multicast Address Mask
@@ -143,8 +140,7 @@ void MACvSetKeyEntry(struct vnt_private *priv, u16 key_ctl, u32 entry_idx,
 
 	memcpy(set_key.key, key, WLAN_KEY_LEN_CCMP);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-		"offset %d key ctl %d set key %24ph\n",
+	dev_dbg(&priv->usb->dev, "offset %d key ctl %d set key %24ph\n",
 				offset, key_ctl, (u8 *)&set_key);
 
 	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SETKEY, offset,
-- 
1.9.1

