Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:27748 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760641AbZKZPJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 10:09:10 -0500
Subject: [PATCH 06/12] wl1251: fix payload alignment
To: linville@tuxdriver.com
From: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2009 17:09:04 +0200
Message-ID: <20091126150904.917.8182.stgit@tikku>
In-Reply-To: <20091126150141.917.35278.stgit@tikku>
References: <20091126150141.917.35278.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

mac80211 complained that in some cases IP payload was not aligned, this
happens if the 802.11 header is not aligned with four. In that case we have
to move entire packet to make the payload properly aligned.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1251_rx.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.c b/drivers/net/wireless/wl12xx/wl1251_rx.c
index f84cc89..04f3dcd 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.c
@@ -22,6 +22,7 @@
  *
  */
 
+#include <linux/string.h>
 #include <linux/skbuff.h>
 #include <net/mac80211.h>
 
@@ -32,6 +33,9 @@
 #include "wl1251_cmd.h"
 #include "wl1251_acx.h"
 
+/* needs to be divisible by four because of DMA */
+#define WL1251_RX_ALIGNMENT	4
+
 static void wl1251_rx_header(struct wl1251 *wl,
 			     struct wl1251_rx_descriptor *desc)
 {
@@ -106,6 +110,7 @@ static void wl1251_rx_body(struct wl1251 *wl,
 	struct sk_buff *skb;
 	struct ieee80211_rx_status status;
 	u8 *rx_buffer, beacon = 0;
+	unsigned char *from, *to;
 	u16 length, *fc;
 	u32 curr_id, last_id_inc, rx_packet_ring_addr;
 
@@ -126,12 +131,15 @@ static void wl1251_rx_body(struct wl1251 *wl,
 	if (wl->rx_current_buffer)
 		rx_packet_ring_addr += wl->data_path->rx_packet_ring_chunk_size;
 
-	skb = dev_alloc_skb(length);
+	skb = dev_alloc_skb(length + WL1251_RX_ALIGNMENT);
 	if (!skb) {
 		wl1251_error("Couldn't allocate RX frame");
 		return;
 	}
 
+	/* for the case if payload is unaligned */
+	skb_reserve(skb, WL1251_RX_ALIGNMENT);
+
 	rx_buffer = skb_put(skb, length);
 	wl1251_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
 
@@ -140,6 +148,13 @@ static void wl1251_rx_body(struct wl1251 *wl,
 
 	fc = (u16 *)skb->data;
 
+	if (ieee80211_hdrlen(*fc) & 0x3) {
+		from = skb->data;
+		to = skb_push(skb, 2);
+		memmove(to, from, skb->len);
+		fc = (u16 *) skb->data;
+	}
+
 	if ((*fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)
 		beacon = 1;
 

