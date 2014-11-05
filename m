Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51995 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaKEVJr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 16:09:47 -0500
Received: by mail-wi0-f178.google.com with SMTP id bs8so1267235wib.17
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 13:09:45 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/11] staging: vt6655: device_init_registers remove uConnectionRate
Date: Wed,  5 Nov 2014 21:08:55 +0000
Message-Id: <1415221739-3045-7-git-send-email-tvboxspy@gmail.com> (sfid-20141105_220952_774775_067B5F34)
In-Reply-To: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
References: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The device starts up with a default rate of 54M

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index ee60624..a35069b 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -456,10 +456,7 @@ static void device_init_registers(struct vnt_private *pDevice)
 
 	/* Set BB and packet type at the same time. */
 	/* Set Short Slot Time, xIFS, and RSPINF. */
-	if (pDevice->uConnectionRate == RATE_AUTO)
-		pDevice->wCurrentRate = RATE_54M;
-	else
-		pDevice->wCurrentRate = (unsigned short)pDevice->uConnectionRate;
+	pDevice->wCurrentRate = RATE_54M;
 
 	pDevice->bRadioOff = false;
 
-- 
2.1.0

