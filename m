Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:34252 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab0AaU41 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2010 15:56:27 -0500
Message-ID: <4B65EE79.5050000@openwrt.org>
Date: Sun, 31 Jan 2010 21:56:25 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix monitor mode tx radiotap header handling
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an injected frame gets buffered for a powersave STA or filtered
and retransmitted, mac80211 attempts to parse the radiotap header
again, which doesn't work because it's gone at that point.
This patch adds a new flag for checking the availability of a radiotap
header, so that it only attempts to parse it once, reusing the tx info
on the next call to ieee80211_tx().
This fixes severe issues with rekeying in AP mode.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -274,6 +274,8 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_INTFL_RETRANSMISSION: This frame is being retransmitted
  *	after TX status because the destination was asleep, it must not
  *	be modified again (no seqno assignment, crypto, etc.)
+ * @IEEE80211_TX_INTFL_HAS_RADIOTAP: This frame was injected and still
+ *	has a radiotap header at skb->data.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -295,6 +297,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_PSPOLL_RESPONSE	= BIT(17),
 	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(18),
 	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(19),
+	IEEE80211_TX_INTFL_HAS_RADIOTAP		= BIT(20),
 };
 
 /**
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1110,7 +1110,7 @@ ieee80211_tx_prepare(struct ieee80211_su
 	tx->flags |= IEEE80211_TX_FRAGMENTED;
 
 	/* process and remove the injection radiotap header */
-	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED)) {
+	if (unlikely(info->flags & IEEE80211_TX_INTFL_HAS_RADIOTAP)) {
 		if (!__ieee80211_parse_tx_radiotap(tx, skb))
 			return TX_DROP;
 
@@ -1119,6 +1119,7 @@ ieee80211_tx_prepare(struct ieee80211_su
 		 * the radiotap header that was present and pre-filled
 		 * 'tx' with tx control information.
 		 */
+		info->flags &= ~IEEE80211_TX_INTFL_HAS_RADIOTAP;
 	}
 
 	/*
@@ -1501,7 +1502,8 @@ static void ieee80211_xmit(struct ieee80
 		int hdrlen;
 		u16 len_rthdr;
 
-		info->flags |= IEEE80211_TX_CTL_INJECTED;
+		info->flags |= IEEE80211_TX_CTL_INJECTED |
+			       IEEE80211_TX_INTFL_HAS_RADIOTAP;
 
 		len_rthdr = ieee80211_get_radiotap_len(skb->data);
 		hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
