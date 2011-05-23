Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43906 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878Ab1EWBr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 21:47:28 -0400
Date: Sun, 22 May 2011 20:47:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, zajec5@gmail.com
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH 1/7] b43: Fix warnings from gcc 4.6.0
Message-ID: <4dd9bcab.qH804LVLKSCzYj13%Larry.Finger@lwfinger.net> (sfid-20110523_034731_914079_892C6D17)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc 4.6.0 warnings for b43:

  CC [M]  drivers/net/wireless/b43/lo.o
drivers/net/wireless/b43/lo.c: In function ‘lo_measure_gain_values’:
drivers/net/wireless/b43/lo.c:304:7: warning: variable ‘trsw_rx’ set but not used [-Wunused-but-set-variable]
  CC [M]  drivers/net/wireless/b43/dma.o
drivers/net/wireless/b43/dma.c: In function ‘free_all_descbuffers’:
drivers/net/wireless/b43/dma.c:760:30: warning: variable ‘desc’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/b43/dma.c: In function ‘b43_dma_handle_txstatus’:
drivers/net/wireless/b43/dma.c:1391:30: warning: variable ‘desc’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/b43/dma.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/dma.c
+++ wireless-testing/drivers/net/wireless/b43/dma.c
@@ -757,14 +757,14 @@ static void dmacontroller_cleanup(struct
 
 static void free_all_descbuffers(struct b43_dmaring *ring)
 {
-	struct b43_dmadesc_generic *desc;
 	struct b43_dmadesc_meta *meta;
 	int i;
 
 	if (!ring->used_slots)
 		return;
 	for (i = 0; i < ring->nr_slots; i++) {
-		desc = ring->ops->idx2desc(ring, i, &meta);
+		/* get meta - ignore returned value */
+		ring->ops->idx2desc(ring, i, &meta);
 
 		if (!meta->skb || b43_dma_ptr_is_poisoned(meta->skb)) {
 			B43_WARN_ON(!ring->tx);
@@ -1388,7 +1388,6 @@ void b43_dma_handle_txstatus(struct b43_
 {
 	const struct b43_dma_ops *ops;
 	struct b43_dmaring *ring;
-	struct b43_dmadesc_generic *desc;
 	struct b43_dmadesc_meta *meta;
 	int slot, firstused;
 	bool frame_succeed;
@@ -1416,7 +1415,8 @@ void b43_dma_handle_txstatus(struct b43_
 	ops = ring->ops;
 	while (1) {
 		B43_WARN_ON(slot < 0 || slot >= ring->nr_slots);
-		desc = ops->idx2desc(ring, slot, &meta);
+		/* get meta - ignore returned value */
+		ops->idx2desc(ring, slot, &meta);
 
 		if (b43_dma_ptr_is_poisoned(meta->skb)) {
 			b43dbg(dev->wl, "Poisoned TX slot %d (first=%d) "
Index: wireless-testing/drivers/net/wireless/b43/lo.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/lo.c
+++ wireless-testing/drivers/net/wireless/b43/lo.c
@@ -301,14 +301,12 @@ static void lo_measure_gain_values(struc
 		max_rx_gain = 0;
 
 	if (has_loopback_gain(phy)) {
-		int trsw_rx = 0;
 		int trsw_rx_gain;
 
 		if (use_trsw_rx) {
 			trsw_rx_gain = gphy->trsw_rx_gain / 2;
 			if (max_rx_gain >= trsw_rx_gain) {
 				trsw_rx_gain = max_rx_gain - trsw_rx_gain;
-				trsw_rx = 0x20;
 			}
 		} else
 			trsw_rx_gain = max_rx_gain;
