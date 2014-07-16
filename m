Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64857 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbaGPVXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:24 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so1504060wgh.13
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:23 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/21] staging: vt6656: device_set_options remove camel case
Date: Wed, 16 Jul 2014 22:22:00 +0100
Message-Id: <1405545731-6082-10-git-send-email-tvboxspy@gmail.com> (sfid-20140716_235209_310507_A68D2694)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 40594a1..37541f0 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -203,18 +203,18 @@ static bool device_alloc_bufs(struct vnt_private *pDevice);
 
 static void usb_device_reset(struct vnt_private *pDevice);
 
-static void device_set_options(struct vnt_private *pDevice)
+static void device_set_options(struct vnt_private *priv)
 {
-	pDevice->cbTD = TX_DESC_DEF0;
-	pDevice->cbRD = RX_DESC_DEF0;
-	pDevice->byShortRetryLimit = SHORT_RETRY_DEF;
-	pDevice->byLongRetryLimit = LONG_RETRY_DEF;
-	pDevice->op_mode = NL80211_IFTYPE_UNSPECIFIED;
-	pDevice->byBBType = BBP_TYPE_DEF;
-	pDevice->byPacketType = pDevice->byBBType;
-	pDevice->byAutoFBCtrl = AUTO_FB_0;
-	pDevice->byPreambleType = 0;
-	pDevice->bExistSWNetAddr = false;
+	priv->cbTD = TX_DESC_DEF0;
+	priv->cbRD = RX_DESC_DEF0;
+	priv->byShortRetryLimit = SHORT_RETRY_DEF;
+	priv->byLongRetryLimit = LONG_RETRY_DEF;
+	priv->op_mode = NL80211_IFTYPE_UNSPECIFIED;
+	priv->byBBType = BBP_TYPE_DEF;
+	priv->byPacketType = priv->byBBType;
+	priv->byAutoFBCtrl = AUTO_FB_0;
+	priv->byPreambleType = 0;
+	priv->bExistSWNetAddr = false;
 }
 
 /*
-- 
2.0.1

