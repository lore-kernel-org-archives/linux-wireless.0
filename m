Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62550 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbaFYUPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:42 -0400
Received: by mail-wi0-f174.google.com with SMTP id bs8so8628530wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:41 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 16/17] staging: vt6656: mac80211 conversion: device_alloc_bufs use dev_err
Date: Wed, 25 Jun 2014 21:14:37 +0100
Message-Id: <1403727278-6666-17-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221610_862379_29BFF20B)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

priv->dev->name is now null change to dev_err

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index ee63390..5cc3d42 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -650,9 +650,8 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 		tx_context = kmalloc(sizeof(struct vnt_usb_send_context),
 								GFP_KERNEL);
 		if (tx_context == NULL) {
-			DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
-				"%s : allocate tx usb context failed\n",
-					priv->dev->name);
+			dev_err(&priv->usb->dev,
+					"allocate tx usb context failed\n");
 			goto free_tx;
 		}
 
@@ -674,9 +673,7 @@ static bool device_alloc_bufs(struct vnt_private *priv)
 	priv->pRCBMem = kzalloc((sizeof(struct vnt_rcb) * priv->cbRD),
 								GFP_KERNEL);
 	if (priv->pRCBMem == NULL) {
-		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
-			"%s : alloc rx usb context failed\n",
-				priv->dev->name);
+		dev_err(&priv->usb->dev, "alloc rx usb context failed\n");
 		goto free_tx;
 	}
 
-- 
1.9.1

