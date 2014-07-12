Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:54426 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaGLGyo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 02:54:44 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so1992651wev.20
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 23:54:43 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/10] staging: vt6656: wcmd replace debug message with dev_dbg
Date: Sat, 12 Jul 2014 07:53:48 +0100
Message-Id: <1405148028-4053-10-git-send-email-tvboxspy@gmail.com> (sfid-20140712_085450_221185_D3F3F027)
In-Reply-To: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
References: <1405148028-4053-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 9130f14..ade0f81 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -49,9 +49,6 @@
 #include "rf.h"
 #include "channel.h"
 
-static int msglevel = MSG_LEVEL_INFO;
-//static int msglevel = MSG_LEVEL_DEBUG;
-
 static int s_bCommandComplete(struct vnt_private *);
 
 static void vCommandTimerWait(struct vnt_private *priv, unsigned long msecs)
@@ -108,8 +105,8 @@ void vRunCommand(struct work_struct *work)
 		break;
 
 	case WLAN_CMD_CHANGE_ANTENNA_START:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"Change from Antenna%d to", (int)priv->dwRxAntennaSel);
+		dev_dbg(&priv->usb->dev, "Change from Antenna%d to",
+							priv->dwRxAntennaSel);
 
 		if (priv->dwRxAntennaSel == 0) {
 			priv->dwRxAntennaSel = 1;
-- 
1.9.1

