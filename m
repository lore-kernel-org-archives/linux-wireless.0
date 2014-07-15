Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:51299 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933130AbaGOSzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 14:55:40 -0400
Received: by mail-we0-f180.google.com with SMTP id w61so249148wes.25
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 11:55:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/12] staging: vt6656: int.c Replace DBG_PRT debug messages
Date: Tue, 15 Jul 2014 19:54:33 +0100
Message-Id: <1405450483-2875-2-git-send-email-tvboxspy@gmail.com> (sfid-20140715_205544_592795_4CEF1283)
In-Reply-To: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
References: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with dev_dbg

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/int.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index 54016f9..ddf58f7 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -37,8 +37,6 @@
 #include "power.h"
 #include "usbpipe.h"
 
-static int msglevel = MSG_LEVEL_INFO; /* MSG_LEVEL_DEBUG */
-
 static const u8 fallback_rate0[5][5] = {
 	{RATE_18M, RATE_18M, RATE_12M, RATE_12M, RATE_12M},
 	{RATE_24M, RATE_24M, RATE_18M, RATE_12M, RATE_12M},
@@ -82,7 +80,7 @@ void INTvWorkItem(struct vnt_private *priv)
 	unsigned long flags;
 	int status;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Interrupt Polling Thread\n");
+	dev_dbg(&priv->usb->dev, "---->Interrupt Polling Thread\n");
 
 	spin_lock_irqsave(&priv->lock, flags);
 
@@ -152,7 +150,7 @@ void INTnsProcessData(struct vnt_private *priv)
 	struct vnt_interrupt_data *int_data;
 	struct ieee80211_low_level_stats *low_stats = &priv->low_stats;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->s_nsInterruptProcessData\n");
+	dev_dbg(&priv->usb->dev, "---->s_nsInterruptProcessData\n");
 
 	int_data = (struct vnt_interrupt_data *)priv->int_buf.data_buf;
 
-- 
2.0.1

