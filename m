Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934546AbZKYNjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 08:39:12 -0500
Message-Id: <20091125133345.837096333@sipsolutions.net>
Date: Wed, 25 Nov 2009 14:32:44 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] mac80211: move cmntr flag out of rx flags
References: <20091125133243.163478670@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RX flags should soon be used only for flags
that cannot change within an a-MPDU, so move the
cooked monitor flag into the RX status flags.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h     |    4 ++++
 net/mac80211/ieee80211_i.h |    3 +--
 net/mac80211/rx.c          |    4 ++--
 3 files changed, 7 insertions(+), 4 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-11-19 14:38:32.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-11-19 14:38:33.000000000 +0100
@@ -513,6 +513,9 @@ ieee80211_tx_info_clear_status(struct ie
  * @RX_FLAG_HT: HT MCS was used and rate_idx is MCS index
  * @RX_FLAG_40MHZ: HT40 (40 MHz) was used
  * @RX_FLAG_SHORT_GI: Short guard interval was used
+ * @RX_FLAG_INTERNAL_CMTR: set internally after frame was reported
+ *	on cooked monitor to avoid double-reporting it for multiple
+ *	virtual interfaces
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR	= 1<<0,
@@ -526,6 +529,7 @@ enum mac80211_rx_flags {
 	RX_FLAG_HT		= 1<<9,
 	RX_FLAG_40MHZ		= 1<<10,
 	RX_FLAG_SHORT_GI	= 1<<11,
+	RX_FLAG_INTERNAL_CMTR	= 1<<12,
 };
 
 /**
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-11-19 14:38:32.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-11-19 14:38:33.000000000 +0100
@@ -163,8 +163,7 @@ typedef unsigned __bitwise__ ieee80211_r
 /* frame is destined to interface currently processed (incl. multicast frames) */
 #define IEEE80211_RX_RA_MATCH		BIT(1)
 #define IEEE80211_RX_AMSDU		BIT(2)
-#define IEEE80211_RX_CMNTR_REPORTED	BIT(3)
-#define IEEE80211_RX_FRAGMENTED		BIT(4)
+#define IEEE80211_RX_FRAGMENTED		BIT(3)
 
 struct ieee80211_rx_data {
 	struct sk_buff *skb;
--- wireless-testing.orig/net/mac80211/rx.c	2009-11-19 14:38:32.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-11-19 14:38:33.000000000 +0100
@@ -1868,7 +1868,7 @@ static void ieee80211_rx_cooked_monitor(
 	struct net_device *prev_dev = NULL;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
-	if (rx->flags & IEEE80211_RX_CMNTR_REPORTED)
+	if (status->flag & RX_FLAG_INTERNAL_CMTR)
 		goto out_free_skb;
 
 	if (skb_headroom(skb) < sizeof(*rthdr) &&
@@ -1929,7 +1929,7 @@ static void ieee80211_rx_cooked_monitor(
 	} else
 		goto out_free_skb;
 
-	rx->flags |= IEEE80211_RX_CMNTR_REPORTED;
+	status->flag |= RX_FLAG_INTERNAL_CMTR;
 	return;
 
  out_free_skb:


