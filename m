Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab2CLMwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 08:52:00 -0400
Message-Id: <20120312125128.861816315@sipsolutions.net> (sfid-20120312_135206_199300_8A52DD92)
Date: Mon, 12 Mar 2012 13:49:14 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mac80211: linearize SKBs as needed for crypto
References: <20120312124912.474580156@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Not linearizing every SKB will help actually pass
non-linear SKBs all the way up when on an encrypted
connection. For now, linearize TKIP completely as
it is lower performance and I don't quite grok all
the details.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c  |    6 ++----
 net/mac80211/wep.c |   11 ++++++++---
 net/mac80211/wpa.c |   22 +++++++++++++++++++++-
 3 files changed, 31 insertions(+), 8 deletions(-)

--- a/net/mac80211/rx.c	2012-03-12 13:22:57.000000000 +0100
+++ b/net/mac80211/rx.c	2012-03-12 13:24:05.000000000 +0100
@@ -1063,10 +1063,6 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		return RX_DROP_MONITOR;
 	}
 
-	if (skb_linearize(rx->skb))
-		return RX_DROP_UNUSABLE;
-	/* the hdr variable is invalid now! */
-
 	switch (rx->key->conf.cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
@@ -1089,6 +1085,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		return RX_DROP_UNUSABLE;
 	}
 
+	/* the hdr variable is invalid after the decrypt handlers */
+
 	/* either the frame has been decrypted or will be dropped */
 	status->flag |= RX_FLAG_DECRYPTED;
 
--- a/net/mac80211/wep.c	2012-03-12 13:22:57.000000000 +0100
+++ b/net/mac80211/wep.c	2012-03-12 13:45:23.000000000 +0100
@@ -284,22 +284,27 @@ ieee80211_crypto_wep_decrypt(struct ieee
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	__le16 fc = hdr->frame_control;
 
-	if (!ieee80211_is_data(hdr->frame_control) &&
-	    !ieee80211_is_auth(hdr->frame_control))
+	if (!ieee80211_is_data(fc) && !ieee80211_is_auth(fc))
 		return RX_CONTINUE;
 
 	if (!(status->flag & RX_FLAG_DECRYPTED)) {
+		if (skb_linearize(rx->skb))
+			return RX_DROP_UNUSABLE;
 		if (rx->sta && ieee80211_wep_is_weak_iv(rx->skb, rx->key))
 			rx->sta->wep_weak_iv_count++;
 		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key))
 			return RX_DROP_UNUSABLE;
 	} else if (!(status->flag & RX_FLAG_IV_STRIPPED)) {
+		if (!pskb_may_pull(rx->skb, ieee80211_hdrlen(fc) + WEP_IV_LEN))
+			return RX_DROP_UNUSABLE;
 		if (rx->sta && ieee80211_wep_is_weak_iv(rx->skb, rx->key))
 			rx->sta->wep_weak_iv_count++;
 		ieee80211_wep_remove_iv(rx->local, rx->skb, rx->key);
 		/* remove ICV */
-		skb_trim(rx->skb, rx->skb->len - WEP_ICV_LEN);
+		if (pskb_trim(rx->skb, rx->skb->len - WEP_ICV_LEN))
+			return RX_DROP_UNUSABLE;
 	}
 
 	return RX_CONTINUE;
--- a/net/mac80211/wpa.c	2012-03-10 09:17:06.000000000 +0100
+++ b/net/mac80211/wpa.c	2012-03-12 13:45:50.000000000 +0100
@@ -138,6 +138,10 @@ ieee80211_rx_h_michael_mic_verify(struct
 	if (skb->len < hdrlen + MICHAEL_MIC_LEN)
 		return RX_DROP_UNUSABLE;
 
+	if (skb_linearize(rx->skb))
+		return RX_DROP_UNUSABLE;
+	hdr = (void *)skb->data;
+
 	data = skb->data + hdrlen;
 	data_len = skb->len - hdrlen - MICHAEL_MIC_LEN;
 	key = &rx->key->conf.key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY];
@@ -253,6 +257,11 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	if (!rx->sta || skb->len - hdrlen < 12)
 		return RX_DROP_UNUSABLE;
 
+	/* it may be possible to optimize this a bit more */
+	if (skb_linearize(rx->skb))
+		return RX_DROP_UNUSABLE;
+	hdr = (void *)skb->data;
+
 	/*
 	 * Let TKIP code verify IV, but skip decryption.
 	 * In the case where hardware checks the IV as well,
@@ -484,6 +493,14 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 	if (!rx->sta || data_len < 0)
 		return RX_DROP_UNUSABLE;
 
+	if (status->flag & RX_FLAG_DECRYPTED) {
+		if (!pskb_may_pull(rx->skb, hdrlen + CCMP_HDR_LEN))
+			return RX_DROP_UNUSABLE;
+	} else {
+		if (skb_linearize(rx->skb))
+			return RX_DROP_UNUSABLE;
+	}
+
 	ccmp_hdr2pn(pn, skb->data + hdrlen);
 
 	queue = rx->security_idx;
@@ -509,7 +526,8 @@ ieee80211_crypto_ccmp_decrypt(struct iee
 	memcpy(key->u.ccmp.rx_pn[queue], pn, CCMP_PN_LEN);
 
 	/* Remove CCMP header and MIC */
-	skb_trim(skb, skb->len - CCMP_MIC_LEN);
+	if (pskb_trim(skb, skb->len - CCMP_MIC_LEN))
+		return RX_DROP_UNUSABLE;
 	memmove(skb->data + CCMP_HDR_LEN, skb->data, hdrlen);
 	skb_pull(skb, CCMP_HDR_LEN);
 
@@ -609,6 +627,8 @@ ieee80211_crypto_aes_cmac_decrypt(struct
 	if (!ieee80211_is_mgmt(hdr->frame_control))
 		return RX_CONTINUE;
 
+	/* management frames are already linear */
+
 	if (skb->len < 24 + sizeof(*mmie))
 		return RX_DROP_UNUSABLE;
 


