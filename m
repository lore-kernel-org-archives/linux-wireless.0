Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:27180 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965Ab0ENHrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 03:47:01 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH v2 3/3] wl1271: Fix RX data path frame lengths
Date: Fri, 14 May 2010 10:46:24 +0300
Message-Id: <1273823184-9381-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1273823184-9381-1-git-send-email-luciano.coelho@nokia.com>
References: <1273823184-9381-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The current frame length used by the driver for RX frames is the SPI bus
transfer length. This length has padding bytes, which do not belong to the
WLAN frame.

As there is no other length information in the WLAN frame except the skb
length this problem caused for instance extra ESSID's to be listed at the
end of scan results (IE id 0) with zero length.

Fix the frame length by removing padding.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_rx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 57f4bfd..b98fb64 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -113,6 +113,8 @@ static void wl1271_rx_handle_data(struct wl1271 *wl, u32 length)
 	wl1271_debug(DEBUG_RX, "rx skb 0x%p: %d B %s", skb, skb->len,
 		     beacon ? "beacon" : "");
 
+	skb_trim(skb, skb->len - desc->pad_len);
+
 	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
 	ieee80211_rx_ni(wl->hw, skb);
 }
-- 
1.6.3.3

