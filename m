Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119AbXLSPr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:47:26 -0500
Message-Id: <20071219003234.165617000@sipsolutions.net> (sfid-20071219_154746_846664_A75064E3)
References: <20071219003121.508296000@sipsolutions.net>
Date: Wed, 19 Dec 2007 01:31:23 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/6]  mac80211: clean up eapol handling in TX path
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous patch left only one user of the ieee80211_is_eapol()
function and that user can be eliminated easily by introducing
a new "frame is EAPOL" flag to handle the frame specially (we
already have this information) instead of doing the (expensive)
ieee80211_is_eapol() all the time.

Also, allow unencrypted frames to be sent when they are injected.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h     |    1 +
 net/mac80211/ieee80211.c   |    2 ++
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/tx.c          |    7 ++++++-
 net/mac80211/util.c        |   17 -----------------
 5 files changed, 10 insertions(+), 19 deletions(-)

--- everything.orig/include/net/mac80211.h	2007-12-19 00:35:35.883023653 +0100
+++ everything/include/net/mac80211.h	2007-12-19 00:42:11.913023383 +0100
@@ -307,6 +307,7 @@ struct ieee80211_tx_control {
 						  * using the through
 						  * set_retry_limit configured
 						  * long retry value */
+#define IEEE80211_TXCTL_EAPOL_FRAME	(1<<11) /* internal to mac80211 */
 	u32 flags;			       /* tx control flags defined
 						* above */
 	u8 key_idx;		/* keyidx from hw->set_key(), undefined if
--- everything.orig/net/mac80211/ieee80211.c	2007-12-19 00:35:35.613024685 +0100
+++ everything/net/mac80211/ieee80211.c	2007-12-19 00:42:11.923022461 +0100
@@ -732,6 +732,8 @@ static void ieee80211_remove_tx_extra(st
 		pkt_data->flags |= IEEE80211_TXPD_DO_NOT_ENCRYPT;
 	if (control->flags & IEEE80211_TXCTL_REQUEUE)
 		pkt_data->flags |= IEEE80211_TXPD_REQUEUE;
+	if (control->flags & IEEE80211_TXCTL_EAPOL_FRAME)
+		pkt_data->flags |= IEEE80211_TXPD_EAPOL_FRAME;
 	pkt_data->queue = control->queue;
 
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
--- everything.orig/net/mac80211/ieee80211_i.h	2007-12-19 00:40:00.863027777 +0100
+++ everything/net/mac80211/ieee80211_i.h	2007-12-19 00:42:11.923022461 +0100
@@ -164,6 +164,7 @@ struct ieee80211_txrx_data {
 #define IEEE80211_TXPD_REQ_TX_STATUS	BIT(0)
 #define IEEE80211_TXPD_DO_NOT_ENCRYPT	BIT(1)
 #define IEEE80211_TXPD_REQUEUE		BIT(2)
+#define IEEE80211_TXPD_EAPOL_FRAME	BIT(3)
 /* Stored in sk_buff->cb */
 struct ieee80211_tx_packet_data {
 	int ifindex;
@@ -798,7 +799,6 @@ extern void *mac80211_wiphy_privid; /* f
 extern const unsigned char rfc1042_header[6];
 extern const unsigned char bridge_tunnel_header[6];
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len);
-int ieee80211_is_eapol(const struct sk_buff *skb, int hdrlen);
 int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 			     int rate, int erp, int short_preamble);
 void mac80211_ev_michael_mic_failure(struct net_device *dev, int keyidx,
--- everything.orig/net/mac80211/tx.c	2007-12-19 00:40:00.873022460 +0100
+++ everything/net/mac80211/tx.c	2007-12-19 00:46:23.673022786 +0100
@@ -433,7 +433,8 @@ ieee80211_tx_h_select_key(struct ieee802
 	else if ((key = rcu_dereference(tx->sdata->default_key)))
 		tx->key = key;
 	else if (tx->sdata->drop_unencrypted &&
-		 !ieee80211_is_eapol(tx->skb, ieee80211_get_hdrlen(fc))) {
+		 !(tx->u.tx.control->flags & IEEE80211_TXCTL_EAPOL_FRAME) &&
+		 !(tx->flags & IEEE80211_TXRXD_TX_INJECTED)) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop_unencrypted);
 		return TXRX_DROP;
 	} else
@@ -1250,6 +1251,8 @@ int ieee80211_master_start_xmit(struct s
 		control.flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 	if (pkt_data->flags & IEEE80211_TXPD_REQUEUE)
 		control.flags |= IEEE80211_TXCTL_REQUEUE;
+	if (pkt_data->flags & IEEE80211_TXPD_EAPOL_FRAME)
+		control.flags |= IEEE80211_TXCTL_EAPOL_FRAME;
 	control.queue = pkt_data->queue;
 
 	ret = ieee80211_tx(odev, skb, &control);
@@ -1523,6 +1526,8 @@ int ieee80211_subif_start_xmit(struct sk
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
 	pkt_data->ifindex = dev->ifindex;
+	if (ethertype == ETH_P_PAE)
+		pkt_data->flags |= IEEE80211_TXPD_EAPOL_FRAME;
 
 	skb->dev = local->mdev;
 	dev->stats.tx_packets++;
--- everything.orig/net/mac80211/util.c	2007-12-19 00:35:35.713024848 +0100
+++ everything/net/mac80211/util.c	2007-12-19 00:42:11.933022568 +0100
@@ -40,10 +40,6 @@ const unsigned char rfc1042_header[] =
 const unsigned char bridge_tunnel_header[] =
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
 
-/* No encapsulation header if EtherType < 0x600 (=length) */
-static const unsigned char eapol_header[] =
-	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00, 0x88, 0x8e };
-
 
 static int rate_list_match(const int *rate_list, int rate)
 {
@@ -218,19 +214,6 @@ int ieee80211_get_hdrlen_from_skb(const 
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 
-int ieee80211_is_eapol(const struct sk_buff *skb, int hdrlen)
-{
-	if (unlikely(skb->len < 10))
-		return 0;
-
-	if (unlikely(skb->len >= hdrlen + sizeof(eapol_header) &&
-		     memcmp(skb->data + hdrlen, eapol_header,
-			    sizeof(eapol_header)) == 0))
-		return 1;
-
-	return 0;
-}
-
 void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;

-- 

