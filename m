Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:33071 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbcHQOpq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 10:45:46 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
	linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH v2] mac80211: Move crypto IV generation to after TXQ dequeue.
Date: Wed, 17 Aug 2016 16:45:31 +0200
Message-Id: <20160817144531.4285-1-toke@toke.dk> (sfid-20160817_164550_842827_E5D1AFAC)
In-Reply-To: <20160817125800.19154-1-toke@toke.dk>
References: <20160817125800.19154-1-toke@toke.dk>
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
Changes since v1:
  - Recalculate pn_offs when needed instead of storing it.

 net/mac80211/sta_info.h |  3 +-
 net/mac80211/tx.c       | 85 +++++++++++++++++++++++++++++++++++++------=
------
 2 files changed, 66 insertions(+), 22 deletions(-)

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
index 1d0746d..9caf75f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1074,6 +1074,64 @@ ieee80211_tx_h_calculate_duration(struct ieee80211=
_tx_data *tx)
 	return TX_CONTINUE;
 }
=20
+static void ieee80211_gen_crypto_iv(struct ieee80211_key_conf *conf,
+					   struct sta_info *sta, struct sk_buff *skb)
+{
+	struct ieee80211_sub_if_data *sdata;
+	u64 pn;
+	u8 *crypto_hdr;
+	u8 pn_offs =3D 0;
+
+	if (!conf || !sta || !(conf->flags & IEEE80211_KEY_FLAG_GENERATE_IV))
+		return;
+
+	sdata =3D sta->sdata;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+		if (sdata->u.mgd.use_4addr) {
+			pn_offs =3D 30;
+			break;
+		}
+		pn_offs =3D 24;
+		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		if (sdata->wdev.use_4addr) {
+			pn_offs =3D 30;
+			break;
+		}
+		/* fall through */
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_AP:
+		pn_offs =3D 24;
+		break;
+	default:
+		return;
+	}
+
+	if (sta->sta.wme) {
+		pn_offs +=3D 2;
+	}
+
+	crypto_hdr =3D skb->data + pn_offs;
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
@@ -1503,6 +1561,11 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80=
211_hw *hw,
 						    sta);
 		struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
=20
+		if (info->control.hw_key) {
+			ieee80211_gen_crypto_iv(info->control.hw_key,
+			container_of(txq->sta, struct sta_info, sta), skb);
+		}
+
 		hdr->seq_ctrl =3D ieee80211_tx_next_seq(sta, txq->tid);
 		if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
 			info->flags |=3D IEEE80211_TX_CTL_AMPDU;
@@ -2874,7 +2937,6 @@ void ieee80211_check_fast_xmit(struct sta_info *sta=
)
 			if (gen_iv) {
 				(build.hdr + build.hdr_len)[3] =3D
 					0x20 | (build.key->conf.keyidx << 6);
-				build.pn_offs =3D build.hdr_len;
 			}
 			if (gen_iv || iv_spc)
 				build.hdr_len +=3D IEEE80211_CCMP_HDR_LEN;
@@ -2885,7 +2947,6 @@ void ieee80211_check_fast_xmit(struct sta_info *sta=
)
 			if (gen_iv) {
 				(build.hdr + build.hdr_len)[3] =3D
 					0x20 | (build.key->conf.keyidx << 6);
-				build.pn_offs =3D build.hdr_len;
 			}
 			if (gen_iv || iv_spc)
 				build.hdr_len +=3D IEEE80211_GCMP_HDR_LEN;
@@ -3289,24 +3350,8 @@ static bool ieee80211_xmit_fast(struct ieee80211_s=
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
+		ieee80211_gen_crypto_iv(&fast_tx->key->conf, sta, skb);
 	}
=20
 	if (sdata->vif.type =3D=3D NL80211_IFTYPE_AP_VLAN)
--=20
2.9.2
