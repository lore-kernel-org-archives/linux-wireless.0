Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:58616 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbcHQNBE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 09:01:04 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH] mac80211: Move crypto IV generation to after TXQ dequeue.
Date: Wed, 17 Aug 2016 14:58:00 +0200
Message-Id: <20160817125800.19154-1-toke@toke.dk> (sfid-20160817_150108_704551_07DBB188)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The FQ portion of the intermediate queues will reorder packets, which
means that crypto IV generation needs to happen after dequeue when they
are enabled, or the receiver will throw packets away when receiving
them.

This fixes the performance regression introduced by enabling softq in
ath9k.

Cc: Felix Fietkau <nbd@nbd.name>
Tested-by: Dave Taht <dave@taht.net>
Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
---
 include/net/mac80211.h  |  2 ++
 net/mac80211/sta_info.h |  3 +--
 net/mac80211/tx.c       | 55 +++++++++++++++++++++++++++++++------------=
------
 3 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cca510a..b23deba 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1556,6 +1556,7 @@ enum ieee80211_key_flags {
  * @tx_pn: PN used for TX keys, may be used by the driver as well if it
  *	needs to do software PN assignment by itself (e.g. due to TSO)
  * @flags: key flags, see &enum ieee80211_key_flags.
+ * @pn_offs: offset where to put PN for crypto (or 0 if not needed)
  * @keyidx: the key index (0-3)
  * @keylen: key material length
  * @key: key material. For ALG_TKIP the key is encoded as a 256-bit (32 =
byte)
@@ -1573,6 +1574,7 @@ struct ieee80211_key_conf {
 	u8 iv_len;
 	u8 hw_key_idx;
 	u8 flags;
+	u8 pn_offs;
 	s8 keyidx;
 	u8 keylen;
 	u8 key[0];
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 0556be3..c9d4d69 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -266,7 +266,6 @@ struct sta_ampdu_mlme {
  * @hdr_len: actual 802.11 header length
  * @sa_offs: offset of the SA
  * @da_offs: offset of the DA
- * @pn_offs: offset where to put PN for crypto (or 0 if not needed)
  * @band: band this will be transmitted on, for tx_info
  * @rcu_head: RCU head to free this struct
  *
@@ -277,7 +276,7 @@ struct sta_ampdu_mlme {
 struct ieee80211_fast_tx {
 	struct ieee80211_key *key;
 	u8 hdr_len;
-	u8 sa_offs, da_offs, pn_offs;
+	u8 sa_offs, da_offs;
 	u8 band;
 	u8 hdr[30 + 2 + IEEE80211_FAST_XMIT_MAX_IV +
 	       sizeof(rfc1042_header)] __aligned(2);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1d0746d..4ae1f2c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1074,6 +1074,33 @@ ieee80211_tx_h_calculate_duration(struct ieee80211=
_tx_data *tx)
 	return TX_CONTINUE;
 }
=20
+static inline void ieee80211_set_crypto_pn(struct ieee80211_key_conf *co=
nf,
+					   struct sk_buff *skb)
+{
+	u64 pn;
+	u8 *crypto_hdr =3D skb->data + conf->pn_offs;
+
+	if (!conf->pn_offs)
+		return;
+
+	switch (conf->cipher) {
+	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_CCMP_256:
+	case WLAN_CIPHER_SUITE_GCMP:
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		pn =3D atomic64_inc_return(&conf->tx_pn);
+		crypto_hdr[0] =3D pn;
+		crypto_hdr[1] =3D pn >> 8;
+		crypto_hdr[4] =3D pn >> 16;
+		crypto_hdr[5] =3D pn >> 24;
+		crypto_hdr[6] =3D pn >> 32;
+		crypto_hdr[7] =3D pn >> 40;
+		break;
+	}
+}
+
+
+
 /* actual transmit path */
=20
 static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
@@ -1503,6 +1530,10 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80=
211_hw *hw,
 						    sta);
 		struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
=20
+		if (info->control.hw_key) {
+			ieee80211_set_crypto_pn(info->control.hw_key, skb);
+		}
+
 		hdr->seq_ctrl =3D ieee80211_tx_next_seq(sta, txq->tid);
 		if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
 			info->flags |=3D IEEE80211_TX_CTL_AMPDU;
@@ -2874,7 +2905,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta=
)
 			if (gen_iv) {
 				(build.hdr + build.hdr_len)[3] =3D
 					0x20 | (build.key->conf.keyidx << 6);
-				build.pn_offs =3D build.hdr_len;
+				build.key->conf.pn_offs =3D build.hdr_len;
 			}
 			if (gen_iv || iv_spc)
 				build.hdr_len +=3D IEEE80211_CCMP_HDR_LEN;
@@ -2885,7 +2916,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta=
)
 			if (gen_iv) {
 				(build.hdr + build.hdr_len)[3] =3D
 					0x20 | (build.key->conf.keyidx << 6);
-				build.pn_offs =3D build.hdr_len;
+				build.key->conf.pn_offs =3D build.hdr_len;
 			}
 			if (gen_iv || iv_spc)
 				build.hdr_len +=3D IEEE80211_GCMP_HDR_LEN;
@@ -3289,24 +3320,8 @@ static bool ieee80211_xmit_fast(struct ieee80211_s=
ub_if_data *sdata,
 	sta->tx_stats.bytes[skb_get_queue_mapping(skb)] +=3D skb->len;
 	sta->tx_stats.packets[skb_get_queue_mapping(skb)]++;
=20
-	if (fast_tx->pn_offs) {
-		u64 pn;
-		u8 *crypto_hdr =3D skb->data + fast_tx->pn_offs;
-
-		switch (fast_tx->key->conf.cipher) {
-		case WLAN_CIPHER_SUITE_CCMP:
-		case WLAN_CIPHER_SUITE_CCMP_256:
-		case WLAN_CIPHER_SUITE_GCMP:
-		case WLAN_CIPHER_SUITE_GCMP_256:
-			pn =3D atomic64_inc_return(&fast_tx->key->conf.tx_pn);
-			crypto_hdr[0] =3D pn;
-			crypto_hdr[1] =3D pn >> 8;
-			crypto_hdr[4] =3D pn >> 16;
-			crypto_hdr[5] =3D pn >> 24;
-			crypto_hdr[6] =3D pn >> 32;
-			crypto_hdr[7] =3D pn >> 40;
-			break;
-		}
+	if (fast_tx->key && !local->ops->wake_tx_queue) {
+		ieee80211_set_crypto_pn(&fast_tx->key->conf, skb);
 	}
=20
 	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)
--=20
2.9.2
