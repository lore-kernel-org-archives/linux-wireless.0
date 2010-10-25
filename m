Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33262 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab0JYJZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 05:25:05 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o9P9OvYm001113
	for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 12:25:02 +0300
From: juuso.oikarinen@nokia.com
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl1271: Fix RX path stall
Date: Mon, 25 Oct 2010 12:24:29 +0300
Message-Id: <1287998669-27209-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The wl1271_rx function loops through packets in an aggregated buffer. Each
packet in the buffer is handled by a call to wl1271_rx_handle_data, which will
fail if skb memory allocation fails or production mode is enabled. These
failures currently prevent the rx counters to be incremented, thus causing the
rx loop to run forever.

Fix this by ignoring error codes reported wl1271_rx_handle_data function.
This essentially means that frames will be dropped in production mode, which
is the intetion, and frames will be dropped if memory allocation fails, which
is a decent way to recover from that situation.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_rx.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 35448e7..cacfee5 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -184,10 +184,14 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
 		while (pkt_offset < buf_size) {
 			pkt_length = wl1271_rx_get_buf_size(status,
 					drv_rx_counter);
-			if (wl1271_rx_handle_data(wl,
-					wl->aggr_buf + pkt_offset,
-					pkt_length) < 0)
-				break;
+			/*
+			 * the handle data call can only fail in memory-outage
+			 * conditions, in that case the received frame will just
+			 * be dropped.
+			 */
+			wl1271_rx_handle_data(wl,
+					      wl->aggr_buf + pkt_offset,
+					      pkt_length);
 			wl->rx_counter++;
 			drv_rx_counter++;
 			drv_rx_counter &= NUM_RX_PKT_DESC_MOD_MASK;
-- 
1.7.0.4

