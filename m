Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42869 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab1EWB5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 21:57:06 -0400
Date: Sun, 22 May 2011 20:57:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH 2/7 V2] b43legacy: Fix warnings from gcc 4.6.0
Message-ID: <4dd9beef.QEBZSSJm3MQqq4Ew%Larry.Finger@lwfinger.net> (sfid-20110523_035710_671384_E26F4600)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc 4.6.0 warnings for b43legacy:

  CC [M]  drivers/net/wireless/b43legacy/main.o
drivers/net/wireless/b43legacy/main.c: In function ‘b43legacy_request_firmware’:
drivers/net/wireless/b43legacy/main.c:1567:6: warning: variable ‘tmshigh’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/b43legacy/main.c: In function ‘b43legacy_op_dev_config’:
drivers/net/wireless/b43legacy/main.c:2637:6: warning: variable ‘antenna_rx’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/b43legacy/main.c: In function ‘b43legacy_op_bss_info_changed’:
drivers/net/wireless/b43legacy/main.c:2778:24: warning: variable ‘phy’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/b43legacy/xmit.c: In function ‘generate_txhdr_fw3’:
drivers/net/wireless/b43legacy/xmit.c:324:7: warning: variable ‘rts_rate_ofdm’ set but not used [-Wunused-but-set-variable]
  CC [M]  drivers/net/wireless/b43legacy/dma.o
drivers/net/wireless/b43legacy/dma.c: In function ‘free_all_descbuffers’:
drivers/net/wireless/b43legacy/dma.c:820:36: warning: variable ‘desc’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/b43legacy/dma.c: In function ‘b43legacy_dma_tx’:
drivers/net/wireless/b43legacy/dma.c:1377:28: warning: variable ‘info’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/b43legacy/dma.c:1374:24: warning: variable ‘hdr’ set but not used [-Wunused-but-set-variable]
drivers/net/wireless/b43legacy/dma.c: In function ‘b43legacy_dma_handle_txstatus’:
drivers/net/wireless/b43legacy/dma.c:1438:36: warning: variable ‘desc’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: linux-2.6/drivers/net/wireless/b43legacy/dma.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/dma.c
+++ linux-2.6/drivers/net/wireless/b43legacy/dma.c
@@ -817,14 +817,13 @@ static void dmacontroller_cleanup(struct
 
 static void free_all_descbuffers(struct b43legacy_dmaring *ring)
 {
-	struct b43legacy_dmadesc_generic *desc;
 	struct b43legacy_dmadesc_meta *meta;
 	int i;
 
 	if (!ring->used_slots)
 		return;
 	for (i = 0; i < ring->nr_slots; i++) {
-		desc = ring->ops->idx2desc(ring, i, &meta);
+		ring->ops->idx2desc(ring, i, &meta);
 
 		if (!meta->skb) {
 			B43legacy_WARN_ON(!ring->tx);
@@ -1371,10 +1370,8 @@ int b43legacy_dma_tx(struct b43legacy_wl
 		     struct sk_buff *skb)
 {
 	struct b43legacy_dmaring *ring;
-	struct ieee80211_hdr *hdr;
 	int err = 0;
 	unsigned long flags;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	ring = priority_to_txring(dev, skb_get_queue_mapping(skb));
 	spin_lock_irqsave(&ring->lock, flags);
@@ -1401,8 +1398,6 @@ int b43legacy_dma_tx(struct b43legacy_wl
 
 	/* dma_tx_fragment might reallocate the skb, so invalidate pointers pointing
 	 * into the skb data or cb now. */
-	hdr = NULL;
-	info = NULL;
 	err = dma_tx_fragment(ring, &skb);
 	if (unlikely(err == -ENOKEY)) {
 		/* Drop this packet, as we don't have the encryption key
@@ -1435,7 +1430,6 @@ void b43legacy_dma_handle_txstatus(struc
 {
 	const struct b43legacy_dma_ops *ops;
 	struct b43legacy_dmaring *ring;
-	struct b43legacy_dmadesc_generic *desc;
 	struct b43legacy_dmadesc_meta *meta;
 	int retry_limit;
 	int slot;
@@ -1450,7 +1444,7 @@ void b43legacy_dma_handle_txstatus(struc
 	ops = ring->ops;
 	while (1) {
 		B43legacy_WARN_ON(!(slot >= 0 && slot < ring->nr_slots));
-		desc = ops->idx2desc(ring, slot, &meta);
+		ops->idx2desc(ring, slot, &meta);
 
 		if (meta->skb)
 			unmap_descbuffer(ring, meta->dmaaddr,
Index: linux-2.6/drivers/net/wireless/b43legacy/main.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/main.c
+++ linux-2.6/drivers/net/wireless/b43legacy/main.c
@@ -1564,10 +1564,10 @@ static int b43legacy_request_firmware(st
 	struct b43legacy_firmware *fw = &dev->fw;
 	const u8 rev = dev->dev->id.revision;
 	const char *filename;
-	u32 tmshigh;
 	int err;
 
-	tmshigh = ssb_read32(dev->dev, SSB_TMSHIGH);
+	/* do dummy read */
+	ssb_read32(dev->dev, SSB_TMSHIGH);
 	if (!fw->ucode) {
 		if (rev == 2)
 			filename = "ucode2";
@@ -2634,11 +2634,9 @@ static int b43legacy_op_dev_config(struc
 	unsigned long flags;
 	unsigned int new_phymode = 0xFFFF;
 	int antenna_tx;
-	int antenna_rx;
 	int err = 0;
 
 	antenna_tx = B43legacy_ANTENNA_DEFAULT;
-	antenna_rx = B43legacy_ANTENNA_DEFAULT;
 
 	mutex_lock(&wl->mutex);
 	dev = wl->current_dev;
@@ -2775,14 +2773,12 @@ static void b43legacy_op_bss_info_change
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev;
-	struct b43legacy_phy *phy;
 	unsigned long flags;
 
 	mutex_lock(&wl->mutex);
 	B43legacy_WARN_ON(wl->vif != vif);
 
 	dev = wl->current_dev;
-	phy = &dev->phy;
 
 	/* Disable IRQs while reconfiguring the device.
 	 * This makes it possible to drop the spinlock throughout
Index: linux-2.6/drivers/net/wireless/b43legacy/xmit.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/b43legacy/xmit.c
+++ linux-2.6/drivers/net/wireless/b43legacy/xmit.c
@@ -321,11 +321,9 @@ static int generate_txhdr_fw3(struct b43
 		struct ieee80211_hdr *hdr;
 		int rts_rate;
 		int rts_rate_fb;
-		int rts_rate_ofdm;
 		int rts_rate_fb_ofdm;
 
 		rts_rate = ieee80211_get_rts_cts_rate(dev->wl->hw, info)->hw_value;
-		rts_rate_ofdm = b43legacy_is_ofdm_rate(rts_rate);
 		rts_rate_fb = b43legacy_calc_fallback_rate(rts_rate);
 		rts_rate_fb_ofdm = b43legacy_is_ofdm_rate(rts_rate_fb);
 		if (rts_rate_fb_ofdm)
