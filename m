Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50089 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1GGQY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 12:24:58 -0400
Subject: [PATCH 3.0] mac80211: fix TKIP replay vulnerability
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 18:24:54 +0200
Message-ID: <1310055894.3924.4.camel@jlt3.sipsolutions.net> (sfid-20110707_182501_216172_0D9451F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Unlike CCMP, the presence or absence of the QoS
field doesn't change the encryption, only the
TID is used. When no QoS field is present, zero
is used as the TID value. This means that it is
possible for an attacker to take a QoS packet
with TID 0 and replay it as a non-QoS packet.

Unfortunately, mac80211 uses different IVs for
checking the validity of the packet's TKIP IV
when it checks TID 0 and when it checks non-QoS
packets. This means it is vulnerable to this
replay attack.

To fix this, use the same replay counter for
TID 0 and non-QoS packets by overriding the
rx->queue value to 0 if it is 16 (non-QoS).

This is a minimal fix for now. I caused this
issue in

commit 1411f9b531f0a910cd1c85a337737c1e6ffbae6a
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu Jul 10 10:11:02 2008 +0200

    mac80211: fix RX sequence number check

while fixing a sequence number issue (there,
a separate counter needs to be used).

Cc: stable@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/wpa.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/net/mac80211/wpa.c	2011-07-07 18:23:38.000000000 +0200
+++ b/net/mac80211/wpa.c	2011-07-07 18:23:48.000000000 +0200
@@ -86,6 +86,11 @@ ieee80211_rx_h_michael_mic_verify(struct
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	int queue = rx->queue;
+
+	/* otherwise, TKIP is vulnerable to TID 0 vs. non-QoS replays */
+	if (rx->queue == NUM_RX_DATA_QUEUES - 1)
+		queue = 0;
 
 	/*
 	 * it makes no sense to check for MIC errors on anything other
@@ -148,8 +153,8 @@ ieee80211_rx_h_michael_mic_verify(struct
 
 update_iv:
 	/* update IV in key information to be able to detect replays */
-	rx->key->u.tkip.rx[rx->queue].iv32 = rx->tkip_iv32;
-	rx->key->u.tkip.rx[rx->queue].iv16 = rx->tkip_iv16;
+	rx->key->u.tkip.rx[queue].iv32 = rx->tkip_iv32;
+	rx->key->u.tkip.rx[queue].iv16 = rx->tkip_iv16;
 
 	return RX_CONTINUE;
 
@@ -241,6 +246,11 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	struct ieee80211_key *key = rx->key;
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	int queue = rx->queue;
+
+	/* otherwise, TKIP is vulnerable to TID 0 vs. non-QoS replays */
+	if (rx->queue == NUM_RX_DATA_QUEUES - 1)
+		queue = 0;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
@@ -261,7 +271,7 @@ ieee80211_crypto_tkip_decrypt(struct iee
 	res = ieee80211_tkip_decrypt_data(rx->local->wep_rx_tfm,
 					  key, skb->data + hdrlen,
 					  skb->len - hdrlen, rx->sta->sta.addr,
-					  hdr->addr1, hwaccel, rx->queue,
+					  hdr->addr1, hwaccel, queue,
 					  &rx->tkip_iv32,
 					  &rx->tkip_iv16);
 	if (res != TKIP_DECRYPT_OK)


