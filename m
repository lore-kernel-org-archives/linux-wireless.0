Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:39950 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab0BNXch (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 18:32:37 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH 1/2] mac80211: Ignore replay for IBSS interfaces
Date: Mon, 15 Feb 2010 00:32:25 +0100
Message-Id: <1266190346-2247-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using WPA-NONE, the same key is used on multiple stations. As such, with
at least 3 nodes, a node will receive frames from the other 2 nodes and
frames from one of those nodes will be ignored since they are being
detected as replayed.

Note: WPA-NONE is not specified in 802.11i. Instead WPA2 should be used,
but it is not currently implemented.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/tkip.c |    6 +++++-
 net/mac80211/wpa.c  |   10 +++++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 7ef491e..f7e0062 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -234,6 +234,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 	u8 rc4key[16], keyid, *pos = payload;
 	int res;
 	const u8 *tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
+	bool tkip_decrypt_replay = 0;
 
 	if (payload_len < 12)
 		return -1;
@@ -271,7 +272,7 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 		       iv32, iv16, key->u.tkip.rx[queue].iv32,
 		       key->u.tkip.rx[queue].iv16);
 #endif
-		return TKIP_DECRYPT_REPLAY;
+		tkip_decrypt_replay = 1;
 	}
 
 	if (only_iv) {
@@ -338,5 +339,8 @@ int ieee80211_tkip_decrypt_data(struct crypto_blkcipher *tfm,
 		*out_iv16 = iv16;
 	}
 
+	if (tkip_decrypt_replay)
+		return TKIP_DECRYPT_REPLAY;
+
 	return res;
 }
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index f4971cd..da1186d 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -242,7 +242,9 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 					  hdr->addr1, hwaccel, rx->queue,
 					  &rx->tkip_iv32,
 					  &rx->tkip_iv16);
-	if (res != TKIP_DECRYPT_OK || wpa_test)
+	if ((res != TKIP_DECRYPT_OK || wpa_test) &&
+	    !(res == TKIP_DECRYPT_REPLAY &&
+	      rx->sdata->vif.type != NL80211_IFTYPE_ADHOC))
 		return RX_DROP_UNUSABLE;
 
 	/* Trim ICV */
@@ -453,7 +455,8 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 
 	ccmp_hdr2pn(pn, skb->data + hdrlen);
 
-	if (memcmp(pn, key->u.ccmp.rx_pn[rx->queue], CCMP_PN_LEN) <= 0) {
+	if ((memcmp(pn, key->u.ccmp.rx_pn[rx->queue], CCMP_PN_LEN) <= 0) &&
+	    (rx->sdata->vif.type != NL80211_IFTYPE_ADHOC)) {
 		key->u.ccmp.replays++;
 		return RX_DROP_UNUSABLE;
 	}
@@ -576,7 +579,8 @@ ieee80211_crypto_aes_cmac_decrypt(struct ieee80211_rx_data *rx)
 
 	bip_ipn_swap(ipn, mmie->sequence_number);
 
-	if (memcmp(ipn, key->u.aes_cmac.rx_pn, 6) <= 0) {
+	if ((memcmp(ipn, key->u.aes_cmac.rx_pn, 6) <= 0) &&
+	    (rx->sdata->vif.type != NL80211_IFTYPE_ADHOC)) {
 		key->u.aes_cmac.replays++;
 		return RX_DROP_UNUSABLE;
 	}
-- 
1.5.6.5

