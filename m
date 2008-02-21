Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42370 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760124AbYBUJYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 04:24:34 -0500
Subject: [RFC] mac80211: allow specifying RTS/self-CTS protection when
	injecting packets
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 01:17:14 +0100
Message-Id: <1203553034.17534.119.camel@johannes.berg> (sfid-20080221_092528_405322_268F6EDA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I made this patch to test RTS/CTS operation in drivers, do you think
it's useful apart that and should be merged?

---
 Documentation/networking/mac80211-injection.txt |    6 ++++++
 net/mac80211/tx.c                               |   10 ++++++++++
 2 files changed, 16 insertions(+)

--- everything.orig/net/mac80211/tx.c	2008-02-19 18:41:18.401563530 +0100
+++ everything/net/mac80211/tx.c	2008-02-19 18:41:21.631563150 +0100
@@ -840,6 +840,7 @@ __ieee80211_parse_tx_radiotap(struct iee
 	struct ieee80211_supported_band *sband;
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len);
 	struct ieee80211_tx_control *control = tx->u.tx.control;
+	u16 val16;
 
 	sband = tx->local->hw.wiphy->bands[tx->local->hw.conf.channel->band];
 
@@ -922,6 +923,15 @@ __ieee80211_parse_tx_radiotap(struct iee
 				tx->flags |= IEEE80211_TXRXD_FRAGMENTED;
 			break;
 
+		case IEEE80211_RADIOTAP_TX_FLAGS:
+			val16 = le16_to_cpu(get_unaligned((__le16 *) iterator.this_arg));
+
+			if (val16 & IEEE80211_RADIOTAP_F_TX_RTS)
+				control->flags |= IEEE80211_TXCTL_USE_RTS_CTS;
+			else if (val16 & IEEE80211_RADIOTAP_F_TX_CTS)
+				control->flags |= IEEE80211_TXCTL_USE_CTS_PROTECT;
+			break;
+
 		/*
 		 * Please update the file
 		 * Documentation/networking/mac80211-injection.txt
--- everything.orig/Documentation/networking/mac80211-injection.txt	2008-02-18 15:29:41.068223795 +0100
+++ everything/Documentation/networking/mac80211-injection.txt	2008-02-19 18:41:21.661561252 +0100
@@ -40,6 +40,12 @@ radiotap headers and used to control inj
 			      this flag is only reliable when software
 			      fragmentation is enabled)
 
+ * IEEE80211_RADIOTAP_TX_FLAGS
+
+   IEEE80211_RADIOTAP_F_TX_RTS:	use RTS/CTS handshake
+   IEEE80211_RADIOTAP_F_TX_CTS:	use CTS-to-self protection
+
+
 The injection code can also skip all other currently defined radiotap fields
 facilitating replay of captured radiotap headers directly.
 


