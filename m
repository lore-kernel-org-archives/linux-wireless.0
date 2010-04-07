Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48561 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab0DGJ07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 05:26:59 -0400
Subject: [PATCH] mac80211: fix paged RX crypto
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 11:26:56 +0200
Message-ID: <1270632416.3858.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

WEP crypto was broken, but upon finding the problem
it is evident that other things were broken by the
paged RX patch as well.

To fix it, for now move the linearising in front.
This means that we linearise all frames, which is
not at all what we want, but at least it fixes the
problem for now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/rx.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-04-07 11:19:30.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-04-07 11:20:05.000000000 +0200
@@ -820,7 +820,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 {
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_hdr *hdr;
 	int keyidx;
 	int hdrlen;
 	ieee80211_rx_result result = RX_DROP_UNUSABLE;
@@ -861,6 +861,11 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
+	if (skb_linearize(rx->skb))
+		return RX_DROP_UNUSABLE;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+
 	/* start without a key */
 	rx->key = NULL;
 
@@ -944,9 +949,6 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		return RX_DROP_MONITOR;
 	}
 
-	if (skb_linearize(rx->skb))
-		return RX_DROP_UNUSABLE;
-
 	/* Check for weak IVs if possible */
 	if (rx->sta && rx->key->conf.alg == ALG_WEP &&
 	    ieee80211_is_data(hdr->frame_control) &&


