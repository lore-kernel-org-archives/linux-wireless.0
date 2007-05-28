Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:42346 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923AbXE1Qm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2007 12:42:26 -0400
Message-Id: <20070528164200.239326973@localhost>
References: <20070528163845.448090722@localhost>
Date: Mon, 28 May 2007 09:38:46 -0700
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] hostap: Allocate enough tailroom for TKIP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brandon Craig Rhodes <brandon@rhodesmill.org>

When hostap_tx_encrypt() tries to allocate enough headroom and
tailroom for ieee80211 encryption, it only makes enough room for the
"mpdu" phase of the operation, but forgets about the "msdu" phase.
(For TKIP, these two phases require, respectively, 4 and 8 bytes of
tailroom, per the "ieee80211_crypt_tkip" structure at the bottom of
net/ieee80211/ieee80211_crypt_tkip.c.)

Signed-off-by: Brandon Craig Rhodes <brandon@rhodesmill.org>
Signed-off-by: Jouni Malinen <j@w1.fi>


Index: linux-2.6/drivers/net/wireless/hostap/hostap_80211_tx.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/hostap/hostap_80211_tx.c
+++ linux-2.6/drivers/net/wireless/hostap/hostap_80211_tx.c
@@ -311,7 +311,7 @@ static struct sk_buff * hostap_tx_encryp
 	local_info_t *local;
 	struct ieee80211_hdr_4addr *hdr;
 	u16 fc;
-	int hdr_len, res;
+	int prefix_len, postfix_len, hdr_len, res;
 
 	iface = netdev_priv(skb->dev);
 	local = iface->local;
@@ -337,10 +337,13 @@ static struct sk_buff * hostap_tx_encryp
 	if (skb == NULL)
 		return NULL;
 
-	if ((skb_headroom(skb) < crypt->ops->extra_mpdu_prefix_len ||
-	     skb_tailroom(skb) < crypt->ops->extra_mpdu_postfix_len) &&
-	    pskb_expand_head(skb, crypt->ops->extra_mpdu_prefix_len,
-			     crypt->ops->extra_mpdu_postfix_len, GFP_ATOMIC)) {
+	prefix_len = crypt->ops->extra_mpdu_prefix_len +
+		crypt->ops->extra_msdu_prefix_len;
+	postfix_len = crypt->ops->extra_mpdu_postfix_len +
+		crypt->ops->extra_msdu_postfix_len;
+	if ((skb_headroom(skb) < prefix_len ||
+	     skb_tailroom(skb) < postfix_len) &&
+	    pskb_expand_head(skb, prefix_len, postfix_len, GFP_ATOMIC)) {
 		kfree_skb(skb);
 		return NULL;
 	}

--

-- 
Jouni Malinen                                            PGP id EFC895FA
