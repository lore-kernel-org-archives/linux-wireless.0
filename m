Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:27819 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760650AbZKZPJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 10:09:43 -0500
Subject: [PATCH 07/12] wl1251: use __dev_alloc_skb() on RX
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2009 17:09:11 +0200
Message-ID: <20091126150911.917.96496.stgit@tikku>
In-Reply-To: <20091126150141.917.35278.stgit@tikku>
References: <20091126150141.917.35278.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

RX is handled in a workqueue therefore allocating for GFP_ATOMIC
is overkill and not required.

Based on a patch for wl1271 by Luis R. Rodriguez.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.c b/drivers/net/wireless/wl12xx/wl1251_rx.c
index 04f3dcd..5731dd7 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.c
@@ -131,7 +131,7 @@ static void wl1251_rx_body(struct wl1251 *wl,
 	if (wl->rx_current_buffer)
 		rx_packet_ring_addr += wl->data_path->rx_packet_ring_chunk_size;
 
-	skb = dev_alloc_skb(length + WL1251_RX_ALIGNMENT);
+	skb = __dev_alloc_skb(length + WL1251_RX_ALIGNMENT, GFP_KERNEL);
 	if (!skb) {
 		wl1251_error("Couldn't allocate RX frame");
 		return;

