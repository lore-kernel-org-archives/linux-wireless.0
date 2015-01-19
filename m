Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:43861 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbbASSZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 13:25:00 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so3112397wgh.6
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 10:24:59 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/6] staging: vt6655: device_init_registers alway set initial antenna mode
Date: Mon, 19 Jan 2015 18:24:13 +0000
Message-Id: <1421691855-2927-4-git-send-email-tvboxspy@gmail.com> (sfid-20150119_192505_343641_3A0B97E8)
In-Reply-To: <1421691855-2927-1-git-send-email-tvboxspy@gmail.com>
References: <1421691855-2927-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BBvSetTxAntennaMode and BBvSetRxAntennaMode need to be set correcty
on start up

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 3093276..9e68f20 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -323,6 +323,10 @@ static void device_init_registers(struct vnt_private *pDevice)
 		}
 	}
 
+	/* Set initial antenna mode */
+	BBvSetTxAntennaMode(pDevice, pDevice->byTxAntennaMode);
+	BBvSetRxAntennaMode(pDevice, pDevice->byRxAntennaMode);
+
 	/* zonetype initial */
 	pDevice->byOriginalZonetype = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
 
-- 
2.1.0

