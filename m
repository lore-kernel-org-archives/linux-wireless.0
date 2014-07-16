Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60359 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbaGPVXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:37 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so2049176wiw.12
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:36 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 17/21] staging: vt6656: main_usb.c Replace DEVICE_PARAM TxDescriptors0
Date: Wed, 16 Jul 2014 22:22:07 +0100
Message-Id: <1405545731-6082-17-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232348_874929_88BD303A)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with vnt_tx_buffers using module_param_named and
MODULE_PARM_DESC

Check user doe not set tx_buffer beyond the define limits of driver

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 6e79c4c..46f8491 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -83,7 +83,10 @@ module_param_named(rx_buffers, vnt_rx_buffers, int, 0644);
 MODULE_PARM_DESC(rx_buffers, "Number of receive usb rx buffers");
 
 #define TX_DESC_DEF0 64
-DEVICE_PARAM(TxDescriptors0, "Number of transmit usb desc buffer");
+static int vnt_tx_buffers = TX_DESC_DEF0;
+module_param_named(tx_buffers, vnt_rx_buffers, int, 0644);
+MODULE_PARM_DESC(tx_buffers, "Number of receive usb tx buffers");
+
 
 #define CHANNEL_DEF 6
 DEVICE_PARAM(Channel, "Channel number");
@@ -204,7 +207,11 @@ static void usb_device_reset(struct vnt_private *pDevice);
 
 static void device_set_options(struct vnt_private *priv)
 {
-	priv->cbTD = TX_DESC_DEF0;
+	/* Set number of TX buffers */
+	if (vnt_tx_buffers < CB_MIN_TX_DESC || vnt_tx_buffers > CB_MAX_TX_DESC)
+		priv->cbTD = TX_DESC_DEF0;
+	else
+		priv->cbTD = vnt_tx_buffers;
 
 	/* Set number of RX buffers */
 	if (vnt_rx_buffers < CB_MIN_RX_DESC || vnt_rx_buffers > CB_MAX_RX_DESC)
-- 
2.0.1

