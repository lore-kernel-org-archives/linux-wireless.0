Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:20524 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab0BVGlb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:31 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH 10/22] wl1271: don't get received frames from hardware in PLT mode
Date: Mon, 22 Feb 2010 08:38:30 +0200
Message-Id: <1266820722-20202-11-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Most probably patch "wl1271: add most of the normal initialization commands
to PLT mode" enabled the RX path in firmware so that now driver received
frames and passed them to mac80211, which warned about them.

Workaround this by not retrieving frames from the hardware, just ignore them.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_rx.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index b7a7c06..2df7852 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -159,6 +159,13 @@ static void wl1271_rx_handle_data(struct wl1271 *wl, u32 length)
 	u8 *buf;
 	u8 beacon = 0;
 
+	/*
+	 * In PLT mode we seem to get frames and mac80211 warns about them,
+	 * workaround this by not retrieving them at all.
+	 */
+	if (unlikely(wl->state == WL1271_STATE_PLT))
+		return;
+
 	skb = __dev_alloc_skb(length, GFP_KERNEL);
 	if (!skb) {
 		wl1271_error("Couldn't allocate RX frame");
-- 
1.6.3.3

