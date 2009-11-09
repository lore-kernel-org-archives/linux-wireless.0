Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f212.google.com ([209.85.217.212]:48381 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457AbZKIQHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 11:07:16 -0500
Received: by gxk4 with SMTP id 4so387987gxk.8
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 08:07:21 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 9 Nov 2009 17:07:20 +0100
Message-ID: <f74418680911090807g4e83a15cr2ce21ea21a86ea23@mail.gmail.com>
Subject: [PATCH]: setting bit-rate when injecting
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: technoboy85@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I and my Matteo Croce made a patch which adds the capability
to set the bit-rate when injecting in monitor mode.

The code parse the bit-rate field from the radiotap header and passes the info
to the struct ieee80211_tx_info

--- a/net/mac80211/tx.c	2009-11-09 16:41:15.000000000 +0100
+++ b/net/mac80211/tx.c	2009-11-09 16:50:12.000000000 +0100
@@ -505,6 +505,9 @@
 	struct ieee80211_tx_rate_control txrc;
 	u32 sta_flags;

+	if (info->control.vif->type == NL80211_IFTYPE_MONITOR)
+		return TX_CONTINUE;
+
 	memset(&txrc, 0, sizeof(txrc));

 	sband = tx->local->hw.wiphy->bands[tx->channel->band];
@@ -932,7 +935,9 @@
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len);
+	int i, ret = ieee80211_radiotap_iterator_init(&iterator,
+			rthdr, skb->len);
+	struct ieee80211_rate *rates;

 	sband = tx->local->hw.wiphy->bands[tx->channel->band];

@@ -979,6 +984,25 @@
 				tx->flags |= IEEE80211_TX_FRAGMENTED;
 			break;

+		case IEEE80211_RADIOTAP_RATE:
+			rates = sband->bitrates;
+			for (i = 0; i < sband->n_bitrates; i++) {
+				if (rates[i].bitrate/5 == *iterator.this_arg) {
+					info->control.rates[0].idx = i;
+					break;
+				}
+			}
+			info->control.rates[0].flags = 0;
+			info->control.rates[1].idx = -1;
+			info->control.rates[2].idx = -1;
+			info->control.rates[3].idx = -1;
+			info->control.rates[4].idx = -1;
+			break;
+
+		case IEEE80211_RADIOTAP_DATA_RETRIES:
+			info->control.rates[0].count = *iterator.this_arg;
+			break;
+
 		/*
 		 * Please update the file
 		 * Documentation/networking/mac80211-injection.txt
@@ -1518,7 +1542,6 @@
 					 struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_channel *chan = local->hw.conf.channel;
 	struct ieee80211_radiotap_header *prthdr =
 		(struct ieee80211_radiotap_header *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1540,9 +1563,6 @@
 	 * radar detection by itself. We can do that later by adding a
 	 * monitor flag interfaces used for AP support.
 	 */
-	if ((chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR |
-	     IEEE80211_CHAN_PASSIVE_SCAN)))
-		goto fail;

 	/* check for not even having the fixed radiotap header part */
 	if (unlikely(skb->len < sizeof(struct ieee80211_radiotap_header)))
