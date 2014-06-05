Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out05.msg.oleane.net ([62.161.7.3]:60558 "EHLO
	smtp-out05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaFEMfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 08:35:39 -0400
Received: from smtp29.msg.oleane.net (smtp29.mail.priv [172.17.20.151])
	by smtp-out05.msg.oleane.net with ESMTP id s55C0Ham000543
	for <linux-wireless@vger.kernel.org>; Thu, 5 Jun 2014 14:00:17 +0200
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp29.msg.oleane.net (MTA) with ESMTP id s55Bdlqe009605
	for <linux-wireless@vger.kernel.org>; Thu, 5 Jun 2014 13:39:47 +0200
Subject: [RFC]mac80211: Add radiotap field in parser
Date: Thu, 5 Jun 2014 13:39:46 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A319017BCF52@sbs2003.acksys.local> (sfid-20140605_143543_135886_AB0F0F46)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
From: "Cedric Debarge" <cedric.debarge@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the radiotap field IEEE80211_RADIOTAP_RATE and IEEE80211_RADIOTAP_MCS radiotap parser.

These additions are compatible with the radiotap definition
(http://www.radiotap.org/Radiotap)

Previous attempts were made on this mailing list using a new flag in ieee80211_tx_info. But since this field is now full, I choose to use a bit field in the rate control part of the ieee80211_tx_info.

signed-off-by: Cédric Debarge <cedric.debarge@acksys.fr>
---
 include/net/mac80211.h |    1 +
 net/mac80211/tx.c      |   72 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h index 421b6ec..3ed63d8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -721,6 +721,7 @@ struct ieee80211_tx_info {
 					u8 use_cts_prot:1;
 					u8 short_preamble:1;
 					u8 skip_table:1;
+					u8 tx_ctl_rc_bypass:1;
 					/* 2 bytes free */
 				};
 				/* only needed before rate control */ diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c index 5214686..7aff9b5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -657,6 +657,9 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	struct ieee80211_sta_rates *ratetbl = NULL;
 	bool assoc = false;
 
+	if (info->control.tx_ctl_rc_bypass)
+		return TX_CONTINUE;
+
 	memset(&txrc, 0, sizeof(txrc));
 
 	sband = tx->local->hw.wiphy->bands[info->band];
@@ -1530,19 +1533,30 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 	ieee80211_tx(sdata, skb, false, band);  }
 
-static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
+static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
+										struct ieee80211_local *local)
 {
 	struct ieee80211_radiotap_iterator iterator;
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_channel *chan = local->monitor_chandef.chan; 
+	struct ieee80211_supported_band *sband =
+		local->hw.wiphy->bands[chan->band];
+ 	u16 txflags;
+	s8 rate_idx;
+	u16 bit_rate;
+	int i;
+	unsigned char known;
+	unsigned char flags;
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
 						   NULL);
-	u16 txflags;
 
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 		       IEEE80211_TX_CTL_DONTFRAG;
 
+	info->control.tx_ctl_rc_bypass = 0;
+
 	/*
 	 * for every radiotap entry that is present
 	 * (ieee80211_radiotap_iterator_next returns -ENOENT when no more @@ -1589,6 +1603,58 @@ static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
 				info->flags |= IEEE80211_TX_CTL_NO_ACK;
 			break;
 
+		case IEEE80211_RADIOTAP_RATE: 
+			rate_idx = -1;
+			/* convert legacy rate; NB: .5 Mb/s -> 100 kb/s */
+			bit_rate = *iterator.this_arg * 5;
+			for (i = 0; i < sband->n_bitrates; i++){
+				if (sband->bitrates[i].bitrate == bit_rate) {
+					rate_idx = i;
+					break;
+				}
+			}
+			/* Rate not available - rejecting */
+			if (rate_idx < 0)
+				return false;
+
+			info->control.tx_ctl_rc_bypass = 1;
+			info->control.rates[0].idx = rate_idx;
+			info->control.rates[0].count = 1;
+			break;
+				
+		case IEEE80211_RADIOTAP_MCS:
+			known = iterator.this_arg[0];
+			flags = iterator.this_arg[1];
+			rate_idx = iterator.this_arg[2];
+
+			/* 11n not supported - rejecting */
+			if(!sband->ht_cap.ht_supported) {
+				return false;
+			}
+
+			/* set mcs */
+			if(known & IEEE80211_RADIOTAP_MCS_HAVE_MCS) {
+				info->control.rates[0].idx = rate_idx;
+				info->control.rates[0].flags |= 
+					IEEE80211_TX_RC_MCS;
+			}
+
+			/* set GI */
+			if ((known & IEEE80211_RADIOTAP_MCS_HAVE_GI) &&
+				(flags & IEEE80211_RADIOTAP_MCS_SGI))
+				info->control.rates[0].flags |= 
+					IEEE80211_TX_RC_SHORT_GI;
+
+			/* set bandwith */
+			if ((known & IEEE80211_RADIOTAP_MCS_HAVE_BW) &&
+			    (flags & IEEE80211_RADIOTAP_MCS_BW_40))
+				info->control.rates[0].flags |= 
+					IEEE80211_TX_RC_40_MHZ_WIDTH;
+
+			info->control.rates[0].count = 1;
+			info->control.tx_ctl_rc_bypass = 1;
+			break;
+
 		/*
 		 * Please update the file
 		 * Documentation/networking/mac80211-injection.txt
@@ -1684,7 +1750,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 		      IEEE80211_TX_CTL_INJECTED;
 
 	/* process and remove the injection radiotap header */
-	if (!ieee80211_parse_tx_radiotap(skb))
+	if (!ieee80211_parse_tx_radiotap(skb, local))
 		goto fail;
 
 	rcu_read_lock();
--
1.7.9.5

Cédric DEBARGE
