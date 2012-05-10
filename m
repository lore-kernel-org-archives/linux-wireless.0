Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758240Ab2EJJQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:00 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:00 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 41/78] wl18xx: init Tx-released index to 0 on HW init
Date: Thu, 10 May 2012 12:13:46 +0300
Message-Id: <1336641263-5761-42-git-send-email-arik@wizery.com> (sfid-20120510_112150_182802_97AA50F7)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This ensures the index is 0 on FW recovery and prevents spurious error
prints - "WARNING illegal id in tx completion".

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 9aae0af..a8b9cea 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -850,11 +850,15 @@ static void wl18xx_tx_immediate_completion(struct wl1271 *wl)
 static int wl18xx_hw_init(struct wl1271 *wl)
 {
 	int ret;
+	struct wl18xx_priv *priv = wl->priv;
 	u32 host_cfg_bitmap = HOST_IF_CFG_RX_FIFO_ENABLE |
 		HOST_IF_CFG_ADD_RX_ALIGNMENT;
 
 	u32 sdio_align_size = 0;
 
+	/* (re)init private structures. Relevant on recovery as well. */
+	priv->last_fw_rls_idx = 0;
+
 	/* Enable Tx SDIO padding */
 	if (wl->quirks & WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN) {
 		host_cfg_bitmap |= HOST_IF_CFG_TX_PAD_TO_SDIO_BLK;
-- 
1.7.9.5

