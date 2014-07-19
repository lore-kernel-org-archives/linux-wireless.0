Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56632 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760710AbaGSLbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:31:13 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so4526954wgh.15
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:31:12 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/16] staging: vt6656: replace bExistSWNetAddr with exist_sw_net_addr
Date: Sat, 19 Jul 2014 12:30:12 +0100
Message-Id: <1405769418-2815-10-git-send-email-tvboxspy@gmail.com> (sfid-20140719_133119_484584_9ACDFF84)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Always needed as u8 type.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/main_usb.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 0c18e26..9f1216d 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -309,7 +309,7 @@ struct vnt_private {
 	u8 current_net_addr[ETH_ALEN];
 	u8 permanent_net_addr[ETH_ALEN];
 
-	int bExistSWNetAddr;
+	u8 exist_sw_net_addr;
 
 	u64 qwCurrTSF;
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 0bf207c..9aaa816 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -125,7 +125,7 @@ static void device_set_options(struct vnt_private *priv)
 	priv->byPacketType = priv->byBBType;
 	priv->byAutoFBCtrl = AUTO_FB_0;
 	priv->byPreambleType = 0;
-	priv->bExistSWNetAddr = false;
+	priv->exist_sw_net_addr = false;
 }
 
 /*
@@ -163,7 +163,7 @@ static int device_init_registers(struct vnt_private *priv)
 	}
 
 	init_cmd->init_class = DEVICE_INIT_COLD;
-	init_cmd->exist_sw_net_addr = (u8) priv->bExistSWNetAddr;
+	init_cmd->exist_sw_net_addr = priv->exist_sw_net_addr;
 	for (ii = 0; ii < 6; ii++)
 		init_cmd->sw_net_addr[ii] = priv->current_net_addr[ii];
 	init_cmd->short_retry_limit = priv->byShortRetryLimit;
-- 
2.0.1

