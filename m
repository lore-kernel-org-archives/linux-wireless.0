Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57055 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbXIZPyr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 11:54:47 -0400
Message-Id: <20070926155432.371718000@sipsolutions.net>
References: <20070926155313.955049000@sipsolutions.net>
Date: Wed, 26 Sep 2007 17:53:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [patch 1/7] mac80211: move sta_process rx handler later
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This moves the sta_process RX handler to after decryption
so that frames that cannot be decrypted don't influence
statistics, it is likely that they were injected or something
else is totally wrong.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c |   96 +++++++++++++++++++++++++++---------------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-09-26 15:56:17.608936654 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-26 15:56:22.718936654 +0200
@@ -512,6 +512,53 @@ ieee80211_rx_h_load_key(struct ieee80211
 	return TXRX_CONTINUE;
 }
 
+static ieee80211_txrx_result
+ieee80211_rx_h_wep_weak_iv_detection(struct ieee80211_txrx_data *rx)
+{
+	if (!rx->sta || !(rx->fc & IEEE80211_FCTL_PROTECTED) ||
+	    (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
+	    !rx->key || rx->key->conf.alg != ALG_WEP ||
+	    !(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
+		return TXRX_CONTINUE;
+
+	/* Check for weak IVs, if hwaccel did not remove IV from the frame */
+	if (!(rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED) ||
+	    !(rx->u.rx.status->flag & RX_FLAG_DECRYPTED))
+		if (ieee80211_wep_is_weak_iv(rx->skb, rx->key))
+			rx->sta->wep_weak_iv_count++;
+
+	return TXRX_CONTINUE;
+}
+
+static ieee80211_txrx_result
+ieee80211_rx_h_decrypt(struct ieee80211_txrx_data *rx)
+{
+	if (!(rx->fc & IEEE80211_FCTL_PROTECTED))
+		return TXRX_CONTINUE;
+
+	if (!rx->key) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: RX protected frame,"
+			       " but have no key\n", rx->dev->name);
+		return TXRX_DROP;
+	}
+
+	switch (rx->key->conf.alg) {
+	case ALG_WEP:
+		return ieee80211_crypto_wep_decrypt(rx);
+	case ALG_TKIP:
+		return ieee80211_crypto_tkip_decrypt(rx);
+	case ALG_CCMP:
+		return ieee80211_crypto_ccmp_decrypt(rx);
+	case ALG_NONE:
+		return TXRX_CONTINUE;
+	}
+
+	/* not reached */
+	WARN_ON(1);
+	return TXRX_DROP;
+}
+
 static void ap_sta_ps_start(struct net_device *dev, struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -637,53 +684,6 @@ ieee80211_rx_h_sta_process(struct ieee80
 	return TXRX_CONTINUE;
 } /* ieee80211_rx_h_sta_process */
 
-static ieee80211_txrx_result
-ieee80211_rx_h_wep_weak_iv_detection(struct ieee80211_txrx_data *rx)
-{
-	if (!rx->sta || !(rx->fc & IEEE80211_FCTL_PROTECTED) ||
-	    (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
-	    !rx->key || rx->key->conf.alg != ALG_WEP ||
-	    !(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
-		return TXRX_CONTINUE;
-
-	/* Check for weak IVs, if hwaccel did not remove IV from the frame */
-	if (!(rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED) ||
-	    !(rx->u.rx.status->flag & RX_FLAG_DECRYPTED))
-		if (ieee80211_wep_is_weak_iv(rx->skb, rx->key))
-			rx->sta->wep_weak_iv_count++;
-
-	return TXRX_CONTINUE;
-}
-
-static ieee80211_txrx_result
-ieee80211_rx_h_decrypt(struct ieee80211_txrx_data *rx)
-{
-	if (!(rx->fc & IEEE80211_FCTL_PROTECTED))
-		return TXRX_CONTINUE;
-
-	if (!rx->key) {
-		if (net_ratelimit())
-			printk(KERN_DEBUG "%s: RX protected frame,"
-			       " but have no key\n", rx->dev->name);
-		return TXRX_DROP;
-	}
-
-	switch (rx->key->conf.alg) {
-	case ALG_WEP:
-		return ieee80211_crypto_wep_decrypt(rx);
-	case ALG_TKIP:
-		return ieee80211_crypto_tkip_decrypt(rx);
-	case ALG_CCMP:
-		return ieee80211_crypto_ccmp_decrypt(rx);
-	case ALG_NONE:
-		return TXRX_CONTINUE;
-	}
-
-	/* not reached */
-	WARN_ON(1);
-	return TXRX_DROP;
-}
-
 static inline struct ieee80211_fragment_entry *
 ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
 			 unsigned int frag, unsigned int seq, int rx_queue,
@@ -1349,9 +1349,9 @@ ieee80211_rx_handler ieee80211_rx_handle
 	ieee80211_rx_h_passive_scan,
 	ieee80211_rx_h_check,
 	ieee80211_rx_h_load_key,
-	ieee80211_rx_h_sta_process,
 	ieee80211_rx_h_wep_weak_iv_detection,
 	ieee80211_rx_h_decrypt,
+	ieee80211_rx_h_sta_process,
 	ieee80211_rx_h_defragment,
 	ieee80211_rx_h_ps_poll,
 	ieee80211_rx_h_michael_mic_verify,

-- 

