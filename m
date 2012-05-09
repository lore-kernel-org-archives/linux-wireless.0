Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:65081 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab2EIFNx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 01:13:53 -0400
From: <Janusz.Dziedzic@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <anamtsov@gmail.com>
Date: Wed, 9 May 2012 08:11:20 +0300
Subject: [PATCH] mac80211: Add IV-room in the skb for TKIP and WEP
Message-ID: <3078A9B976EF864C8DDD0C499FFD07912143517010@EXMB01.eu.tieto.com> (sfid-20120509_071359_920173_910D6DCA)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Add IV-room in skb also for TKIP and WEP.
Extend patch: "mac80211: support adding IV-room in the skb for CCMP keys"

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/net/mac80211.h |    2 +-
 net/mac80211/wep.c     |   14 +++++++++++---
 net/mac80211/wpa.c     |    8 +++++++-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4d6e6c6..60e3766 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -939,7 +939,7 @@ static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
  *	CCMP key if it requires CCMP encryption of management frames (MFP) to
  *	be done in software.
  * @IEEE80211_KEY_FLAG_PUT_IV_SPACE: This flag should be set by the driver
- *	for a CCMP key if space should be prepared for the IV, but the IV
+ *	if space should be prepared for the IV, but the IV
  *	itself should not be generated. Do not set together with
  *	@IEEE80211_KEY_FLAG_GENERATE_IV on the same key.
  */
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 7aa31bb..e904401 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -92,6 +92,7 @@ static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 				int keylen, int keyidx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	unsigned int hdrlen;
 	u8 *newhdr;
 
@@ -104,6 +105,12 @@ static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	newhdr = skb_push(skb, WEP_IV_LEN);
 	memmove(newhdr, newhdr + WEP_IV_LEN, hdrlen);
+
+	/* the HW only needs room for the IV, but not the actual IV */
+	if (info->control.hw_key &&
+	    (info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE))
+		return newhdr + hdrlen;
+
 	ieee80211_wep_get_iv(local, keylen, keyidx, newhdr + hdrlen);
 	return newhdr + hdrlen;
 }
@@ -313,14 +320,15 @@ ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx)
 static int wep_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_key_conf *hw_key = info->control.hw_key;
 
-	if (!info->control.hw_key) {
+	if (!hw_key) {
 		if (ieee80211_wep_encrypt(tx->local, skb, tx->key->conf.key,
 					  tx->key->conf.keylen,
 					  tx->key->conf.keyidx))
 			return -1;
-	} else if (info->control.hw_key->flags &
-			IEEE80211_KEY_FLAG_GENERATE_IV) {
+	} else if ((hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
+		   (hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)) {
 		if (!ieee80211_wep_add_iv(tx->local, skb,
 					  tx->key->conf.keylen,
 					  tx->key->conf.keyidx))
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 0ae23c6..4d05ad9 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -183,7 +183,8 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	u8 *pos;
 
 	if (info->control.hw_key &&
-	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
+	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
+	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)) {
 		/* hwaccel - with no need for software-generated IV */
 		return 0;
 	}
@@ -204,6 +205,11 @@ static int tkip_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	memmove(pos, pos + TKIP_IV_LEN, hdrlen);
 	pos += hdrlen;
 
+	/* the HW only needs room for the IV, but not the actual IV */
+	if (info->control.hw_key &&
+	    (info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE))
+		return 0;
+
 	/* Increase IV for the frame */
 	spin_lock_irqsave(&key->u.tkip.txlock, flags);
 	key->u.tkip.tx.iv16++;
-- 
1.7.0.4