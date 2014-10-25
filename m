Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:60909 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaJYTCx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:02:53 -0400
Received: by mail-wg0-f52.google.com with SMTP id y10so571607wgg.35
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:02:51 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 23/31] staging: vt6655: mac80211 conversion: device_error remove legacy functions
Date: Sat, 25 Oct 2014 09:20:33 +0100
Message-Id: <1414225241-5480-24-git-send-email-tvboxspy@gmail.com> (sfid-20141025_210259_774923_8B4A7ABA)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
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
1.9.1

