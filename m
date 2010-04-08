Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22859 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436Ab0DHHav (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 03:30:51 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: delay skb linearising in rx decryption
Date: Thu,  8 Apr 2010 15:35:10 +0800
Message-Id: <1270712110-10370-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We delay the skb linearising in ieee80211_rx_h_decrypt so that
frames do not require software decryption are not linearized. We
are safe to do this because ieee80211_get_mmie_keyidx() only
requires to touch nonlinear data for management frames, which are
already linearized before getting here.

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c0ad7e8..052cee0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -820,7 +820,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 {
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	struct ieee80211_hdr *hdr;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	int keyidx;
 	int hdrlen;
 	ieee80211_rx_result result = RX_DROP_UNUSABLE;
@@ -861,11 +861,6 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
-	if (skb_linearize(rx->skb))
-		return RX_DROP_UNUSABLE;
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-
 	/* start without a key */
 	rx->key = NULL;
 
@@ -906,6 +901,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 			rx->key = key;
 		return RX_CONTINUE;
 	} else {
+		u8 keyid;
 		/*
 		 * The device doesn't give us the IV so we won't be
 		 * able to look up the key. That's ok though, we
@@ -928,7 +924,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		 * no need to call ieee80211_wep_get_keyidx,
 		 * it verifies a bunch of things we've done already
 		 */
-		keyidx = rx->skb->data[hdrlen + 3] >> 6;
+		skb_copy_bits(rx->skb, hdrlen + 3, &keyid, 1);
+		keyidx = keyid >> 6;
 
 		rx->key = rcu_dereference(rx->sdata->keys[keyidx]);
 
@@ -949,6 +946,11 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		return RX_DROP_MONITOR;
 	}
 
+	if (skb_linearize(rx->skb))
+		return RX_DROP_UNUSABLE;
+
+	hdr = (struct ieee80211_hdr *)rx->skb->data;
+
 	/* Check for weak IVs if possible */
 	if (rx->sta && rx->key->conf.alg == ALG_WEP &&
 	    ieee80211_is_data(hdr->frame_control) &&
