Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:35328 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbaGNSoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 14:44:17 -0400
Received: by mail-we0-f178.google.com with SMTP id w61so3687058wes.9
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2014 11:44:15 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/2] staging: vt6656: set BBvSetAntennaMode in device_init_registers
Date: Mon, 14 Jul 2014 19:43:06 +0100
Message-Id: <1405363386-5799-2-git-send-email-tvboxspy@gmail.com> (sfid-20140714_204420_432707_7E62223E)
In-Reply-To: <1405363386-5799-1-git-send-email-tvboxspy@gmail.com>
References: <1405363386-5799-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BBvSetAntennaMode is not set at all, set to byRxAntennaMode

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index dffd0c7..f0388d6 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -371,6 +371,9 @@ static int device_init_registers(struct vnt_private *pDevice)
 		}
 	}
 
+	/* Set initial antenna mode */
+	BBvSetAntennaMode(pDevice, pDevice->byRxAntennaMode);
+
 	/* get Auto Fall Back type */
 	pDevice->byAutoFBCtrl = AUTO_FB_0;
 
-- 
2.0.1

