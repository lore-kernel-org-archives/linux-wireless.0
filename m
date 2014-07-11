Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:62760 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaGKAJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:09:37 -0400
Received: by mail-wg0-f51.google.com with SMTP id y10so290540wgg.10
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:09:35 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/13] staging: vt6656: rxtx replace debug messages DBG_PRT
Date: Fri, 11 Jul 2014 01:08:31 +0100
Message-Id: <1405037311-3666-13-git-send-email-tvboxspy@gmail.com> (sfid-20140711_022952_456135_59E76977)
In-Reply-To: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
References: <1405037311-3666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with dev_dbg

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 35edf41..3dc6d07 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -43,8 +43,6 @@
 #include "rf.h"
 #include "usbpipe.h"
 
-static int          msglevel                = MSG_LEVEL_INFO;
-
 static const u16 vnt_time_stampoff[2][MAX_RATE] = {
 	{384, 288, 226, 209, 54, 43, 37, 31, 28, 25, 24, 23},/* Long Preamble */
 	{384, 192, 130, 113, 54, 43, 37, 31, 28, 25, 24, 23},/* Short Preamble */
@@ -81,7 +79,7 @@ static struct vnt_usb_send_context
 	struct vnt_usb_send_context *context = NULL;
 	int ii;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"GetFreeContext()\n");
+	dev_dbg(&priv->usb->dev, "%s\n", __func__);
 
 	for (ii = 0; ii < priv->cbTD; ii++) {
 		if (!priv->apTD[ii])
@@ -100,7 +98,7 @@ static struct vnt_usb_send_context
 	}
 
 	if (ii == priv->cbTD)
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"No Free Tx Context\n");
+		dev_dbg(&priv->usb->dev, "%s No Free Tx Context\n", __func__);
 
 	return NULL;
 }
-- 
1.9.1

