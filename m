Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28304 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbXKSNg7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 08:36:59 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: restructuring data Rx handlers
Date: Mon, 19 Nov 2007 15:34:57 +0200
Message-Id: <11954792971872-git-send-email-ron.rindjunsky@intel.com> (sfid-20071119_133703_580876_1A34DFE3)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch restructures the Rx handlers chain by incorporating previously
handlers ieee80211_rx_h_802_1x_pae and ieee80211_rx_h_drop_unencrypted
into ieee80211_rx_h_data, already in 802.3 form. this scheme follows more
precisely after the IEEE802.11 data plane archituecture, and will prevent
code duplication to IEEE8021.11n A-MSDU handler.

added function:
 - ieee80211_data_to_8023: transfering 802.11 data frames to 802.3 frame
eliminated handlers:
 - ieee80211_rx_h_drop_unencrypted: now function ieee80211_drop_unencrypted
 - ieee80211_rx_h_802_1x_pae: now function ieee80211_802_1x_pae
changed handlers:
 - ieee80211_rx_h_data: now contains calls to three above function

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/rx.c          |   56 +++++++++++++++++++++++++++----------------
 net/mac80211/tx.c          |   13 ++++++----
 net/mac80211/util.c        |   14 +----------
 4 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b4e32ab..0444809 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -792,7 +792,7 @@ extern void *mac80211_wiphy_privid; /* for wiphy privid */
 extern const unsigned char rfc1042_header[6];
 extern const unsigned char bridge_tunnel_header[6];
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len);
-int ieee80211_is_eapol(const struct sk_buff *skb);
+int ieee80211_is_eapol(const struct sk_buff *skb, int hdrlen);
 int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 			     int rate, int erp, int short_preamble);
 void mac80211_ev_michael_mic_failure(struct net_device *dev, int keyidx,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 428a9fc..1909662 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -957,9 +957,9 @@ ieee80211_rx_h_remove_qos_control(struct ieee80211_txrx_data *rx)
 }
 
 static ieee80211_txrx_result
-ieee80211_rx_h_802_1x_pae(struct ieee80211_txrx_data *rx)
+ieee80211_802_1x_pae(struct ieee80211_txrx_data *rx, int hdrlen)
 {
-	if (rx->sdata->eapol && ieee80211_is_eapol(rx->skb) &&
+	if (rx->sdata->eapol && ieee80211_is_eapol(rx->skb, hdrlen) &&
 	    rx->sdata->type != IEEE80211_IF_TYPE_STA &&
 	    (rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
 		return TXRX_CONTINUE;
@@ -968,14 +968,10 @@ ieee80211_rx_h_802_1x_pae(struct ieee80211_txrx_data *rx)
 		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
 		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
 		     (!rx->sta || !(rx->sta->flags & WLAN_STA_AUTHORIZED)) &&
-		     !ieee80211_is_eapol(rx->skb))) {
+		     !ieee80211_is_eapol(rx->skb, hdrlen))) {
 #ifdef CONFIG_MAC80211_DEBUG
-		struct ieee80211_hdr *hdr =
-			(struct ieee80211_hdr *) rx->skb->data;
-		DECLARE_MAC_BUF(mac);
-		printk(KERN_DEBUG "%s: dropped frame from %s"
-		       " (unauthorized port)\n", rx->dev->name,
-		       print_mac(mac, hdr->addr2));
+		printk(KERN_DEBUG "%s: dropped frame "
+		       "(unauthorized port)\n", rx->dev->name);
 #endif /* CONFIG_MAC80211_DEBUG */
 		return TXRX_DROP;
 	}
@@ -984,7 +980,7 @@ ieee80211_rx_h_802_1x_pae(struct ieee80211_txrx_data *rx)
 }
 
 static ieee80211_txrx_result
-ieee80211_rx_h_drop_unencrypted(struct ieee80211_txrx_data *rx)
+ieee80211_drop_unencrypted(struct ieee80211_txrx_data *rx, int hdrlen)
 {
 	/*
 	 * Pass through unencrypted frames if the hardware has
@@ -998,7 +994,8 @@ ieee80211_rx_h_drop_unencrypted(struct ieee80211_txrx_data *rx)
 		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
 		     (rx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_NULLFUNC &&
 		     rx->sdata->drop_unencrypted &&
-		     (rx->sdata->eapol == 0 || !ieee80211_is_eapol(rx->skb)))) {
+		     (rx->sdata->eapol == 0 ||
+		      !ieee80211_is_eapol(rx->skb, hdrlen)))) {
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: RX non-WEP frame, but expected "
 			       "encryption\n", rx->dev->name);
@@ -1008,16 +1005,15 @@ ieee80211_rx_h_drop_unencrypted(struct ieee80211_txrx_data *rx)
 }
 
 static ieee80211_txrx_result
-ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
+ieee80211_data_to_8023(struct ieee80211_txrx_data *rx)
 {
 	struct net_device *dev = rx->dev;
-	struct ieee80211_local *local = rx->local;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
 	u16 fc, hdrlen, ethertype;
 	u8 *payload;
 	u8 dst[ETH_ALEN];
 	u8 src[ETH_ALEN];
-	struct sk_buff *skb = rx->skb, *skb2;
+	struct sk_buff *skb = rx->skb;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	DECLARE_MAC_BUF(mac);
 	DECLARE_MAC_BUF(mac2);
@@ -1025,8 +1021,6 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 	DECLARE_MAC_BUF(mac4);
 
 	fc = rx->fc;
-	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
-		return TXRX_CONTINUE;
 
 	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
 		return TXRX_DROP;
@@ -1107,8 +1101,6 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 		break;
 	}
 
-	payload = skb->data + hdrlen;
-
 	if (unlikely(skb->len - hdrlen < 8)) {
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG "%s: RX too short data frame "
@@ -1117,6 +1109,7 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 		return TXRX_DROP;
 	}
 
+	payload = skb->data + hdrlen;
 	ethertype = (payload[6] << 8) | payload[7];
 
 	if (likely((compare_ether_addr(payload, rfc1042_header) == 0 &&
@@ -1137,8 +1130,31 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 		memcpy(ehdr->h_source, src, ETH_ALEN);
 		ehdr->h_proto = len;
 	}
-	skb->dev = dev;
+	return TXRX_CONTINUE;
+}
+
+static ieee80211_txrx_result
+ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
+{
+	struct net_device *dev = rx->dev;
+	struct ieee80211_local *local = rx->local;
+	u16 fc;
+	struct sk_buff *skb, *skb2;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
+	fc = rx->fc;
+	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
+		return TXRX_CONTINUE;
+
+	if (ieee80211_data_to_8023(rx) == TXRX_DROP)
+		return TXRX_DROP;
+	if (ieee80211_802_1x_pae(rx, sizeof(struct ethhdr)) == TXRX_DROP)
+		return TXRX_DROP;
+	if (ieee80211_drop_unencrypted(rx, sizeof(struct ethhdr)) == TXRX_DROP)
+		return TXRX_DROP;
+
+	skb = rx->skb;
+	skb->dev = dev;
 	skb2 = NULL;
 
 	dev->stats.rx_packets++;
@@ -1341,8 +1357,6 @@ ieee80211_rx_handler ieee80211_rx_handlers[] =
 	 * are not passed to user space by these functions
 	 */
 	ieee80211_rx_h_remove_qos_control,
-	ieee80211_rx_h_802_1x_pae,
-	ieee80211_rx_h_drop_unencrypted,
 	ieee80211_rx_h_data,
 	ieee80211_rx_h_mgmt,
 	NULL
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1a53154..9a2553f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -420,7 +420,6 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_txrx_data *tx)
 	return TXRX_CONTINUE;
 }
 
-
 static ieee80211_txrx_result
 ieee80211_tx_h_ps_buf(struct ieee80211_txrx_data *tx)
 {
@@ -433,13 +432,17 @@ ieee80211_tx_h_ps_buf(struct ieee80211_txrx_data *tx)
 		return ieee80211_tx_h_multicast_ps_buf(tx);
 }
 
-
-
-
 static ieee80211_txrx_result
 ieee80211_tx_h_select_key(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_key *key;
+	const struct ieee80211_hdr *hdr;
+	u16 fc;
+	int hdrlen;
+
+	hdr = (const struct ieee80211_hdr *) tx->skb->data;
+	fc = le16_to_cpu(hdr->frame_control);
+	hdrlen = ieee80211_get_hdrlen(fc);
 
 	if (unlikely(tx->u.tx.control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
 		tx->key = NULL;
@@ -448,7 +451,7 @@ ieee80211_tx_h_select_key(struct ieee80211_txrx_data *tx)
 	else if ((key = rcu_dereference(tx->sdata->default_key)))
 		tx->key = key;
 	else if (tx->sdata->drop_unencrypted &&
-		 !(tx->sdata->eapol && ieee80211_is_eapol(tx->skb))) {
+		 !(tx->sdata->eapol && ieee80211_is_eapol(tx->skb, hdrlen))) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TXRX_DROP;
 	} else {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 5a0564e..f90287a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -217,23 +217,11 @@ int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 
-int ieee80211_is_eapol(const struct sk_buff *skb)
+int ieee80211_is_eapol(const struct sk_buff *skb, int hdrlen)
 {
-	const struct ieee80211_hdr *hdr;
-	u16 fc;
-	int hdrlen;
-
 	if (unlikely(skb->len < 10))
 		return 0;
 
-	hdr = (const struct ieee80211_hdr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_control);
-
-	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
-		return 0;
-
-	hdrlen = ieee80211_get_hdrlen(fc);
-
 	if (unlikely(skb->len >= hdrlen + sizeof(eapol_header) &&
 		     memcmp(skb->data + hdrlen, eapol_header,
 			    sizeof(eapol_header)) == 0))
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
