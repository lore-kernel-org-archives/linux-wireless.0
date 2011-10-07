Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937Ab1JGMFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 08:05:06 -0400
Message-Id: <20111007120217.261654601@sipsolutions.net> (sfid-20111007_140509_329343_E84A008B)
Date: Fri, 07 Oct 2011 14:01:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mac80211: move fragment flag to info flag as
 dont-fragment
References: <20111007120122.982757001@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The purpose of this is two-fold:
 1) by moving it out of tx_data.flags, we can in
    another patch move the radiotap parsing so it
    no longer is in the hotpath
 2) if a device implements fragmentation but can
    optionally skip it, the radiotap request for
    not doing fragmentation may be honoured

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |    4 ++++
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/tx.c          |   39 ++++++++++++++-------------------------
 net/mac80211/wpa.c         |    3 ++-
 4 files changed, 20 insertions(+), 27 deletions(-)

--- a/include/net/mac80211.h	2011-10-07 11:01:01.000000000 +0200
+++ b/include/net/mac80211.h	2011-10-07 11:01:03.000000000 +0200
@@ -375,6 +375,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_USE_MINRATE: This frame will be sent at lowest rate.
  *	This flag is used to send nullfunc frame at minimum rate when
  *	the nullfunc is used for connection monitoring purpose.
+ * @IEEE80211_TX_CTL_DONTFRAG: Don't fragment this packet even if it
+ *	would be fragmented by size (this is optional, only used for
+ *	monitor injection).
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -408,6 +411,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(27),
 	IEEE80211_TX_STATUS_EOSP		= BIT(28),
 	IEEE80211_TX_CTL_USE_MINRATE		= BIT(29),
+	IEEE80211_TX_CTL_DONTFRAG		= BIT(30),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
--- a/net/mac80211/ieee80211_i.h	2011-10-07 11:01:01.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-10-07 11:01:03.000000000 +0200
@@ -136,7 +136,6 @@ typedef unsigned __bitwise__ ieee80211_t
 #define TX_DROP		((__force ieee80211_tx_result) 1u)
 #define TX_QUEUED	((__force ieee80211_tx_result) 2u)
 
-#define IEEE80211_TX_FRAGMENTED		BIT(0)
 #define IEEE80211_TX_UNICAST		BIT(1)
 #define IEEE80211_TX_PS_BUFFERED	BIT(2)
 
--- a/net/mac80211/tx.c	2011-10-07 11:01:01.000000000 +0200
+++ b/net/mac80211/tx.c	2011-10-07 11:05:26.000000000 +0200
@@ -898,7 +898,10 @@ ieee80211_tx_h_fragment(struct ieee80211
 	int hdrlen;
 	int fragnum;
 
-	if (!(tx->flags & IEEE80211_TX_FRAGMENTED))
+	if (info->flags & IEEE80211_TX_CTL_DONTFRAG)
+		return TX_CONTINUE;
+
+	if (tx->local->ops->set_frag_threshold)
 		return TX_CONTINUE;
 
 	/*
@@ -911,7 +914,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
-	/* internal error, why is TX_FRAGMENTED set? */
+	/* internal error, why isn't DONTFRAG set? */
 	if (WARN_ON(skb->len + FCS_LEN <= frag_threshold))
 		return TX_DROP;
 
@@ -1050,17 +1053,13 @@ static bool __ieee80211_parse_tx_radiota
 	struct ieee80211_radiotap_iterator iterator;
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
-	bool hw_frag;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
 						   NULL);
 	u16 txflags;
 
-	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-	tx->flags &= ~IEEE80211_TX_FRAGMENTED;
-
-	/* packet is fragmented in HW if we have a non-NULL driver callback */
-	hw_frag = (tx->local->ops->set_frag_threshold != NULL);
+	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
+		       IEEE80211_TX_CTL_DONTFRAG;
 
 	/*
 	 * for every radiotap entry that is present
@@ -1098,9 +1097,8 @@ static bool __ieee80211_parse_tx_radiota
 			}
 			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_WEP)
 				info->flags &= ~IEEE80211_TX_INTFL_DONT_ENCRYPT;
-			if ((*iterator.this_arg & IEEE80211_RADIOTAP_F_FRAG) &&
-								!hw_frag)
-				tx->flags |= IEEE80211_TX_FRAGMENTED;
+			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_FRAG)
+				info->flags &= ~IEEE80211_TX_CTL_DONTFRAG;
 			break;
 
 		case IEEE80211_RADIOTAP_TX_FLAGS:
@@ -1206,13 +1204,6 @@ ieee80211_tx_prepare(struct ieee80211_su
 	tx->local = local;
 	tx->sdata = sdata;
 	tx->channel = local->hw.conf.channel;
-	/*
-	 * Set this flag (used below to indicate "automatic fragmentation"),
-	 * it will be cleared/left by radiotap as desired.
-	 * Only valid when fragmentation is done by the stack.
-	 */
-	if (!local->ops->set_frag_threshold)
-		tx->flags |= IEEE80211_TX_FRAGMENTED;
 
 	/* process and remove the injection radiotap header */
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_HAS_RADIOTAP)) {
@@ -1281,13 +1272,11 @@ ieee80211_tx_prepare(struct ieee80211_su
 		 */
 	}
 
-	if (tx->flags & IEEE80211_TX_FRAGMENTED) {
-		if ((tx->flags & IEEE80211_TX_UNICAST) &&
-		    skb->len + FCS_LEN > local->hw.wiphy->frag_threshold &&
-		    !(info->flags & IEEE80211_TX_CTL_AMPDU))
-			tx->flags |= IEEE80211_TX_FRAGMENTED;
-		else
-			tx->flags &= ~IEEE80211_TX_FRAGMENTED;
+	if (!(info->flags & IEEE80211_TX_CTL_DONTFRAG)) {
+		if (!(tx->flags & IEEE80211_TX_UNICAST) ||
+		    skb->len + FCS_LEN <= local->hw.wiphy->frag_threshold ||
+		    info->flags & IEEE80211_TX_CTL_AMPDU)
+			info->flags |= IEEE80211_TX_CTL_DONTFRAG;
 	}
 
 	if (!tx->sta)
--- a/net/mac80211/wpa.c	2011-10-07 11:01:01.000000000 +0200
+++ b/net/mac80211/wpa.c	2011-10-07 11:01:18.000000000 +0200
@@ -53,7 +53,8 @@ ieee80211_tx_h_michael_mic_add(struct ie
 	}
 
 	if (info->control.hw_key &&
-	    !(tx->flags & IEEE80211_TX_FRAGMENTED) &&
+	    (info->flags & IEEE80211_TX_CTL_DONTFRAG ||
+	     tx->local->ops->set_frag_threshold) &&
 	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC)) {
 		/* hwaccel - with no need for SW-generated MMIC */
 		return TX_CONTINUE;


