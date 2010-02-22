Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22510 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab0BVGlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:24 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/22] wl1271: Aggregate RX acknowledgements to FW
Date: Mon, 22 Feb 2010 08:38:35 +0200
Message-Id: <1266820722-20202-16-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch will ack RX frames read from the firmware in one single write,
instead of acking all the frames separately. This will reduce the amount of
required communication per frame.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_rx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 2df7852..b824c6c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -224,6 +224,7 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
 
 		wl->rx_counter++;
 		drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
-		wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
 	}
+
+	wl1271_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
 }
-- 
1.6.3.3

