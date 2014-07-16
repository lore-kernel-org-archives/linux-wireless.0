Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64655 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaGPVXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:37 -0400
Received: by mail-wg0-f52.google.com with SMTP id a1so1504665wgh.11
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:36 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 16/21] staging: vt6656: main_usb.c Replace DEVICE_PARAM RxDescriptors0
Date: Wed, 16 Jul 2014 22:22:06 +0100
Message-Id: <1405545731-6082-16-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232347_642058_89CAC0F8)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with vnt_rx_buffers using module_param_named and
MODULE_PARM_DESC

Check user doe not set rx_buffer beyond the define limits of driver

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index ed56b60..6e79c4c 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -78,7 +78,9 @@ MODULE_DESCRIPTION(DEVICE_FULL_DRV_NAM);
 	MODULE_PARM_DESC(N, D)
 
 #define RX_DESC_DEF0 64
-DEVICE_PARAM(RxDescriptors0, "Number of receive usb desc buffer");
+static int vnt_rx_buffers = RX_DESC_DEF0;
+module_param_named(rx_buffers, vnt_rx_buffers, int, 0644);
+MODULE_PARM_DESC(rx_buffers, "Number of receive usb rx buffers");
 
 #define TX_DESC_DEF0 64
 DEVICE_PARAM(TxDescriptors0, "Number of transmit usb desc buffer");
@@ -203,7 +205,13 @@ static void usb_device_reset(struct vnt_private *pDevice);
 static void device_set_options(struct vnt_private *priv)
 {
 	priv->cbTD = TX_DESC_DEF0;
-	priv->cbRD = RX_DESC_DEF0;
+
+	/* Set number of RX buffers */
+	if (vnt_rx_buffers < CB_MIN_RX_DESC || vnt_rx_buffers > CB_MAX_RX_DESC)
+		priv->cbRD = RX_DESC_DEF0;
+	else
+		priv->cbRD = vnt_rx_buffers;
+
 	priv->byShortRetryLimit = SHORT_RETRY_DEF;
 	priv->byLongRetryLimit = LONG_RETRY_DEF;
 	priv->op_mode = NL80211_IFTYPE_UNSPECIFIED;
-- 
2.0.1

