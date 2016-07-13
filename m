Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43196 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbcGMJAP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 05:00:15 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: remove skb header offset mangling in ieee80211_build_hdr
Date: Wed, 13 Jul 2016 11:00:02 +0200
Message-Id: <20160713090002.51127-1-nbd@nbd.name> (sfid-20160713_110026_870407_78F1A4E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the code only touches the MAC headers, the offsets to the
network/transport headers remain the same throughout this function.
Remove pointless pieces of code that try to 'preserve' them.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/tx.c | 28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 24ec38a..cc2ca09 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2325,7 +2325,6 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	struct mesh_path __maybe_unused *mppath = NULL, *mpath = NULL;
 	const u8 *encaps_data;
 	int encaps_len, skip_header_bytes;
-	int nh_pos, h_pos;
 	bool wme_sta = false, authorized = false;
 	bool tdls_peer;
 	bool multicast;
@@ -2634,13 +2633,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		encaps_len = 0;
 	}
 
-	nh_pos = skb_network_header(skb) - skb->data;
-	h_pos = skb_transport_header(skb) - skb->data;
-
 	skb_pull(skb, skip_header_bytes);
-	nh_pos -= skip_header_bytes;
-	h_pos -= skip_header_bytes;
-
 	head_need = hdrlen + encaps_len + meshhdrlen - skb_headroom(skb);
 	head_need += padsize;
 
@@ -2667,18 +2660,12 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (encaps_data) {
+	if (encaps_data)
 		memcpy(skb_push(skb, encaps_len), encaps_data, encaps_len);
-		nh_pos += encaps_len;
-		h_pos += encaps_len;
-	}
 
 #ifdef CONFIG_MAC80211_MESH
-	if (meshhdrlen > 0) {
+	if (meshhdrlen > 0)
 		memcpy(skb_push(skb, meshhdrlen), &mesh_hdr, meshhdrlen);
-		nh_pos += meshhdrlen;
-		h_pos += meshhdrlen;
-	}
 #endif
 
 	if (padsize)
@@ -2697,15 +2684,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	} else
 		memcpy(skb_push(skb, hdrlen), &hdr, hdrlen);
 
-	nh_pos += hdrlen + padsize;
-	h_pos += hdrlen + padsize;
-
-	/* Update skb pointers to various headers since this modified frame
-	 * is going to go through Linux networking code that may potentially
-	 * need things like pointer to IP header. */
 	skb_reset_mac_header(skb);
-	skb_set_network_header(skb, nh_pos);
-	skb_set_transport_header(skb, h_pos);
 
 	info = IEEE80211_SKB_CB(skb);
 	memset(info, 0, sizeof(*info));
@@ -4391,9 +4370,6 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 	int ac = ieee802_1d_to_ac[tid & 7];
 
 	skb_reset_mac_header(skb);
-	skb_reset_network_header(skb);
-	skb_reset_transport_header(skb);
-
 	skb_set_queue_mapping(skb, ac);
 	skb->priority = tid;
 
-- 
2.8.4

