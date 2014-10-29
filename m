Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35259 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145AbaJ2Rpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:45:51 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so5280074wiv.14
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:45:50 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 23/34] staging: vt6655: mac80211 conversion: device_error remove legacy functions
Date: Wed, 29 Oct 2014 17:43:58 +0000
Message-Id: <1414604649-9105-24-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184948_186104_3EFBBE5F)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove netif_stop_queue, bCmdRunning and timer functions

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 451b608..0bd2ca8 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1313,10 +1313,6 @@ static void device_error(struct vnt_private *pDevice, unsigned short status)
 	if (status & ISR_FETALERR) {
 		dev_err(&pDevice->pcid->dev, "Hardware fatal error\n");
 
-		netif_stop_queue(pDevice->dev);
-		del_timer(&pDevice->sTimerCommand);
-		del_timer(&(pDevice->pMgmt->sTimerSecondCallback));
-		pDevice->bCmdRunning = false;
 		MACbShutdown(pDevice->PortOffset);
 		return;
 	}
-- 
2.1.0

