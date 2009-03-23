Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33473 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781AbZCWNKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 09:10:32 -0400
Subject: [PATCH] mac80211: rate control status only for controlled packets
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 14:10:22 +0100
Message-Id: <1237813822.6147.14.camel@johannes.local> (sfid-20090323_141059_018830_D293F562)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes mac80211 to not notify the rate control algorithm's
tx_status() method when reporting status for a packet that didn't go
through the rate control algorithm's get_rate() method.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    4 ++++
 net/mac80211/rate.c    |    6 ++++--
 net/mac80211/rate.h    |    4 +++-
 3 files changed, 11 insertions(+), 3 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2009-03-23 13:59:31.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-03-23 14:00:12.000000000 +0100
@@ -245,6 +245,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_RATE_CTRL_PROBE: internal to mac80211, can be
  *	set by rate control algorithms to indicate probe rate, will
  *	be cleared for fragmented frames (except on the last fragment)
+ * @IEEE80211_TX_INTFL_RCALGO: mac80211 internal flag, do not test or
+ *	set this flag in the driver; indicates that the rate control
+ *	algorithm was used and should be notified of TX status
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -260,6 +263,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_STAT_AMPDU			= BIT(10),
 	IEEE80211_TX_STAT_AMPDU_NO_BACK		= BIT(11),
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(12),
+	IEEE80211_TX_INTFL_RCALGO		= BIT(13),
 };
 
 /**
--- wireless-testing.orig/net/mac80211/rate.c	2009-03-23 14:00:59.000000000 +0100
+++ wireless-testing/net/mac80211/rate.c	2009-03-23 14:01:17.000000000 +0100
@@ -219,10 +219,12 @@ void rate_control_get_rate(struct ieee80
 		info->control.rates[i].count = 1;
 	}
 
-	if (sta && sdata->force_unicast_rateidx > -1)
+	if (sta && sdata->force_unicast_rateidx > -1) {
 		info->control.rates[0].idx = sdata->force_unicast_rateidx;
-	else
+	} else {
 		ref->ops->get_rate(ref->priv, ista, priv_sta, txrc);
+		info->flags |= IEEE80211_TX_INTFL_RCALGO;
+	}
 
 	/*
 	 * try to enforce the maximum rate the user wanted
--- wireless-testing.orig/net/mac80211/rate.h	2009-03-23 14:00:19.000000000 +0100
+++ wireless-testing/net/mac80211/rate.h	2009-03-23 14:00:50.000000000 +0100
@@ -44,8 +44,10 @@ static inline void rate_control_tx_statu
 	struct rate_control_ref *ref = local->rate_ctrl;
 	struct ieee80211_sta *ista = &sta->sta;
 	void *priv_sta = sta->rate_ctrl_priv;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
-	ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
+	if (likely(info->flags & IEEE80211_TX_INTFL_RCALGO))
+		ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
 }
 
 


