Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:64299 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaGPVXc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:32 -0400
Received: by mail-wi0-f177.google.com with SMTP id ho1so2056318wib.4
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:30 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/21] staging: vt6656: power.c replace DBG_PRT debug messages
Date: Wed, 16 Jul 2014 22:22:04 +0100
Message-Id: <1405545731-6082-14-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232408_251682_44CF266F)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with dev_dbg

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/power.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index dbda303..0ffbaed 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -42,8 +42,6 @@
 #include "card.h"
 #include "usbpipe.h"
 
-static int msglevel = MSG_LEVEL_INFO;
-
 /*
  *
  * Routine Description:
@@ -93,7 +91,7 @@ void vnt_enable_power_saving(struct vnt_private *priv, u16 listen_interval)
 		vnt_mac_reg_bits_on(priv, MAC_REG_PSCTL, PSCTL_ALBCN);
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "PS:Power Saving Mode Enable...\n");
+	dev_dbg(&priv->usb->dev,  "PS:Power Saving Mode Enable...\n");
 }
 
 /*
-- 
2.0.1

