Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60392 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbaLDWNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 17:13:49 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so36184370wid.15
        for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2014 14:13:48 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/6] staging: vt6655: device_init_registers alway set initial antenna mode
Date: Thu,  4 Dec 2014 22:12:45 +0000
Message-Id: <1417731167-3231-4-git-send-email-tvboxspy@gmail.com> (sfid-20141204_231354_627962_21C823BB)
In-Reply-To: <1417731167-3231-1-git-send-email-tvboxspy@gmail.com>
References: <1417731167-3231-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BBvSetTxAntennaMode and BBvSetRxAntennaMode need to be set correcty
on start up

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 79b7be5..1d24cbb 100644
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

