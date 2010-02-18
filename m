Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50764 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab0BRL2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:23 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 13/22] wl1271: Optimized RX path packet retrieval
Date: Thu, 18 Feb 2010 13:25:48 +0200
Message-Id: <1266492357-462-14-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of acking RX packets read from the FW once all (of several possible)
buffered packets are retrieved, ack packets one by one as they are read. This
enables the FW to start receiving more packets from the network while the
host read operation is still ongoing.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_rx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index ca645f3..e8eee88 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -218,7 +218,7 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
 
 		wl->rx_counter++;
 		drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
+		wl1271_spi_write32(wl, RX_DRIVER_COUNTER_ADDRESS,
+				   wl->rx_counter);
 	}
-
-	wl1271_spi_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
 }
-- 
1.6.3.3

