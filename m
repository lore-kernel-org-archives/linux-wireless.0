Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:58763 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaEYUiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 May 2014 16:38:21 -0400
Received: by mail-we0-f176.google.com with SMTP id q59so6972678wes.7
        for <linux-wireless@vger.kernel.org>; Sun, 25 May 2014 13:38:20 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/8] staging: vt6656: card.c replace DBG_PRT debug messages.
Date: Sun, 25 May 2014 21:36:24 +0100
Message-Id: <1401050189-3249-3-git-send-email-tvboxspy@gmail.com> (sfid-20140525_223828_014270_E418C988)
In-Reply-To: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com>
References: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with dev_dbg

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index c162ce4..6da912b 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -59,9 +59,6 @@
 #include "datarate.h"
 #include "control.h"
 
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-static int          msglevel                =MSG_LEVEL_INFO;
-
 //const u16 cwRXBCNTSFOff[MAX_RATE] =
 //{17, 34, 96, 192, 34, 23, 17, 11, 8, 5, 4, 3};
 
@@ -161,12 +158,12 @@ static u16 swGetOFDMControlRate(struct vnt_private *priv, u16 rate_idx)
 {
 	u16 ui = rate_idx;
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BASIC RATE: %X\n",
-		priv->wBasicRate);
+	dev_dbg(&priv->usb->dev, "%s basic rate: %d\n",
+					__func__,  priv->wBasicRate);
 
 	if (!CARDbIsOFDMinBasicRate(priv)) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"swGetOFDMControlRate:(NO OFDM) %d\n", rate_idx);
+		dev_dbg(&priv->usb->dev, "%s (NO OFDM) %d\n",
+						__func__, rate_idx);
 		if (rate_idx > RATE_24M)
 			rate_idx = RATE_24M;
 		return rate_idx;
@@ -174,14 +171,14 @@ static u16 swGetOFDMControlRate(struct vnt_private *priv, u16 rate_idx)
 
 	while (ui > RATE_11M) {
 		if (priv->wBasicRate & (1 << ui)) {
-			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-				"swGetOFDMControlRate: %d\n", ui);
+			dev_dbg(&priv->usb->dev, "%s rate: %d\n",
+							__func__, ui);
 			return ui;
 		}
 		ui--;
 	}
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"swGetOFDMControlRate: 6M\n");
+	dev_dbg(&priv->usb->dev, "%s basic rate: 24M\n", __func__);
 
 	return RATE_24M;
 }
@@ -755,8 +752,7 @@ void CARDvUpdateNextTBTT(struct vnt_private *priv, u64 tsf,
 	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SET_TSFTBTT,
 		MESSAGE_REQUEST_TBTT, 0, 8, data);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-		"Card:Update Next TBTT[%8lx]\n", (unsigned long)tsf);
+	dev_dbg(&priv->usb->dev, "%s TBTT: %8llx\n", __func__, tsf);
 
 	return;
 }
-- 
1.9.1

