Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:65412 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbYFOGdk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 02:33:40 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3882106waf.23
        for <linux-wireless@vger.kernel.org>; Sat, 14 Jun 2008 23:33:39 -0700 (PDT)
Subject: [PATCH 3/4] b43: use frame control helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Jun 2008 23:33:39 -0700
Message-Id: <1213511619.11544.32.camel@brick> (sfid-20080615_083344_445766_1472B967)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/b43/xmit.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index f9e1cff..bf6f6c1 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -193,7 +193,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 	const struct ieee80211_hdr *wlhdr =
 	    (const struct ieee80211_hdr *)fragment_data;
 	int use_encryption = (!(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT));
-	u16 fctl = le16_to_cpu(wlhdr->frame_control);
+	__le16 fctl = wlhdr->frame_control;
 	struct ieee80211_rate *fbrate;
 	u8 rate, rate_fb;
 	int rate_ofdm, rate_fb_ofdm;
@@ -259,7 +259,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 			   B43_TXH_MAC_KEYIDX;
 		mac_ctl |= (key->algorithm << B43_TXH_MAC_KEYALG_SHIFT) &
 			   B43_TXH_MAC_KEYALG;
-		wlhdr_len = ieee80211_get_hdrlen(fctl);
+		wlhdr_len = ieee80211_hdrlen(fctl);
 		iv_len = min((size_t) info->control.iv_len,
 			     ARRAY_SIZE(txhdr->iv));
 		memcpy(txhdr->iv, ((u8 *) wlhdr) + wlhdr_len, iv_len);
@@ -317,8 +317,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 	/* MAC control */
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		mac_ctl |= B43_TXH_MAC_ACK;
-	if (!(((fctl & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
-	      ((fctl & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)))
+	if (!ieee80211_is_pspoll(fctl))
 		mac_ctl |= B43_TXH_MAC_HWSEQ;
 	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 		mac_ctl |= B43_TXH_MAC_STMSDU;
@@ -509,7 +508,7 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	struct b43_plcp_hdr6 *plcp;
 	struct ieee80211_hdr *wlhdr;
 	const struct b43_rxhdr_fw4 *rxhdr = _rxhdr;
-	u16 fctl;
+	__le16 fctl;
 	u16 phystat0, phystat3, chanstat, mactime;
 	u32 macstat;
 	u16 chanid;
@@ -549,7 +548,7 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 		goto drop;
 	}
 	wlhdr = (struct ieee80211_hdr *)(skb->data);
-	fctl = le16_to_cpu(wlhdr->frame_control);
+	fctl = wlhdr->frame_control;
 
 	if (macstat & B43_RX_MAC_DEC) {
 		unsigned int keyidx;
@@ -564,7 +563,7 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 		B43_WARN_ON(keyidx >= dev->max_nr_keys);
 
 		if (dev->key[keyidx].algorithm != B43_SEC_ALGO_NONE) {
-			wlhdr_len = ieee80211_get_hdrlen(fctl);
+			wlhdr_len = ieee80211_hdrlen(fctl);
 			if (unlikely(skb->len < (wlhdr_len + 3))) {
 				b43dbg(dev->wl,
 				       "RX: Packet size underrun (3)\n");
@@ -604,9 +603,7 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 	 * of timestamp, i.e. about 65 milliseconds after the PHY received
 	 * the first symbol.
 	 */
-	if (((fctl & (IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE))
-	    == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON)) ||
-	    dev->wl->radiotap_enabled) {
+	if (ieee80211_is_beacon(fctl) || dev->wl->radiotap_enabled) {
 		u16 low_mactime_now;
 
 		b43_tsf_read(dev, &status.mactime);
-- 
1.5.6.rc3.283.g198e


