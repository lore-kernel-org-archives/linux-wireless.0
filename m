Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60595 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2K1JnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:16 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq7so4584332wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:15 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Yair Shapira <yair.shapira@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 10/20] wl18xx: fix a bug in wl->num_rx_desc initialization
Date: Wed, 28 Nov 2012 11:42:39 +0200
Message-Id: <1354095769-8724-11-git-send-email-arik@wizery.com> (sfid-20121128_104324_471768_72C815C7)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yair Shapira <yair.shapira@ti.com>

wl->num_rx_desc was mistakenly initialized with WL18XX_NUM_TX_DESCRIPTORS
but it should use WL18XX_NUM_RX_DESCRIPTORS instead.

This bug was passed unnoticed because currently both RX and TX descriptors
are initialized to the same value (32).

Signed-off-by: Yair Shapira <yair.shapira@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 9685fc3..dc73f8a 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1538,7 +1538,7 @@ static int wl18xx_setup(struct wl1271 *wl)
 
 	wl->rtable = wl18xx_rtable;
 	wl->num_tx_desc = WL18XX_NUM_TX_DESCRIPTORS;
-	wl->num_rx_desc = WL18XX_NUM_TX_DESCRIPTORS;
+	wl->num_rx_desc = WL18XX_NUM_RX_DESCRIPTORS;
 	wl->num_channels = 2;
 	wl->num_mac_addr = WL18XX_NUM_MAC_ADDRESSES;
 	wl->band_rate_to_idx = wl18xx_band_rate_to_idx;
-- 
1.7.9.5

