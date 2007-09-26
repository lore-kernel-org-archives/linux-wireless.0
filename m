Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57046 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbXIZPym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 11:54:42 -0400
Message-Id: <20070926155433.980871000@sipsolutions.net>
References: <20070926155313.955049000@sipsolutions.net>
Date: Wed, 26 Sep 2007 17:53:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [patch 3/7] mac80211: use RX_FLAG_DECRYPTED for sw decrypted as  well
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes mac80211 set the RX_FLAG_DECRYPTED flag for frames
decrypted in software allowing us to handle some things more
uniformly.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-09-26 17:21:48.997337342 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-26 17:39:36.717337342 +0200
@@ -522,6 +522,9 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	    ieee80211_wep_is_weak_iv(rx->skb, rx->key))
 		rx->sta->wep_weak_iv_count++;
 
+	/* either the frame will be decrypted or dropped */
+	rx->u.rx.status->flag |= RX_FLAG_DECRYPTED;
+
 	switch (rx->key->conf.alg) {
 	case ALG_WEP:
 		return ieee80211_crypto_wep_decrypt(rx);
@@ -530,8 +533,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	case ALG_CCMP:
 		return ieee80211_crypto_ccmp_decrypt(rx);
 	case ALG_NONE:
-		WARN_ON(1);
-		return TXRX_CONTINUE;
+		/* fall through, not reached */
 	}
 
 	/* not reached */
@@ -993,9 +995,8 @@ ieee80211_rx_h_drop_unencrypted(struct i
 	if (unlikely(!(rx->fc & IEEE80211_FCTL_PROTECTED) &&
 		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
 		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
-		     (rx->key || rx->sdata->drop_unencrypted) &&
-		     (rx->sdata->eapol == 0 ||
-		      !ieee80211_is_eapol(rx->skb)))) {
+		     rx->sdata->drop_unencrypted &&
+		     (rx->sdata->eapol == 0 || !ieee80211_is_eapol(rx->skb)))) {
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: RX non-WEP frame, but expected "
 			       "encryption\n", rx->dev->name);

-- 

