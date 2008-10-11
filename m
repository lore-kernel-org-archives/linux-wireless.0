Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYJKI0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 04:26:38 -0400
Subject: [RFC] mac80211: fix short preamble determination
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Daniel Drake <dsd@gentoo.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain
Date: Sat, 11 Oct 2008 10:26:33 +0200
Message-Id: <1223713593.29811.38.camel@johannes.berg> (sfid-20081011_102647_748759_646E8F45)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When looking at this code during the rate control API rewrite
yesterday, we wondered whether the determination of short
preamble was correct or not. I don't think it was, and this
should be better.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- everything.orig/net/mac80211/tx.c	2008-10-11 10:06:51.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-10-11 10:22:53.000000000 +0200
@@ -474,10 +474,15 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 		txrc.rts = rts = true;
 	}
 
-	/* XXX: Is this really the right thing to check? */
-	if (ieee80211_is_data(hdr->frame_control) &&
-	    tx->sdata->vif.bss_conf.use_short_preamble &&
-	    (!tx->sta || test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE)))
+	/*
+	 * Use short preamble if the BSS can handle it, but not for
+	 * management frames unless we know the receiver can handle
+	 * that -- the management frame might be to a station that
+	 * just wants a probe response.
+	 */
+	if (tx->sdata->vif.bss_conf.use_short_preamble &&
+	    (ieee80211_is_data(hdr->frame_control) ||
+	     (tx->sta && test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE)))
 		txrc.short_preamble = short_preamble = true;
 
 


