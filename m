Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out05.msg.oleane.net ([62.161.7.3]:42383 "EHLO
	smtp-out05.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3LKSY3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 13:24:29 -0500
Received: from smtp04.msg.oleane.net (smtp04.mail.priv [172.17.20.113])
	by smtp-out05.msg.oleane.net with ESMTP id rBBGCAjE031854
	for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 17:12:10 +0100
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp04.msg.oleane.net (MTA) with ESMTP id rBBFplx5014767
	for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 16:51:49 +0100
Subject: [RFC mac80211] Add field in radiotap parser
Date: Wed, 11 Dec 2013 16:51:45 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Message-ID: <773DB8A82AB6A046AE0195C68612A319016C1220@sbs2003.acksys.local> (sfid-20131211_192432_659202_4A00E55D)
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In radiotap parser I added the field management for
IEEE80211_RADIOTAP_RATE and IEEE80211_RADIOTAP_MCS (to inject packet at
specific rate).
My modifications worked on compat 2013-04-16 and ath9K.

I preparing the patch for the latest wireless version, and all value for
the flags field in struct ieee80211_tx_info are used (declared in enum
mac80211_tx_control_flags in mac80211.h).

I need to add this to bypass the RC in mac80211. 

How I can add the new flag ?
	- I change the flags type to u64
	- I add a second flag field in the struct ieee80211_tx_info (for
exemple flags_ext)

My patch for the compat 2013-04-16 (the bit 31 is not used in this
version)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 87a8e0b..0445c27 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -494,6 +494,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_STATUS_EOSP		= BIT(28),
 	IEEE80211_TX_CTL_USE_MINRATE		= BIT(29),
 	IEEE80211_TX_CTL_DONTFRAG		= BIT(30),
+	IEEE80211_TX_CTL_RC_BYPASS		= BIT(31),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
@@ -509,7 +510,8 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_STAT_AMPDU_NO_BACK |
\
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_NO_PS_BUFFER
|    \
 	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC |
\
-	IEEE80211_TX_CTL_STBC | IEEE80211_TX_STATUS_EOSP)
+	IEEE80211_TX_CTL_STBC | IEEE80211_TX_STATUS_EOSP |
\
+	IEEE80211_TX_CTL_RC_BYPASS)
 
 /**
  * enum mac80211_rate_control_flags - per-rate flags set by the
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 904c3b6..dc414d5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1308,7 +1308,8 @@ static int invoke_tx_handlers(struct
ieee80211_tx_data *tx)
 	CALL_TXH(ieee80211_tx_h_ps_buf);
 	CALL_TXH(ieee80211_tx_h_check_control_port_protocol);
 	CALL_TXH(ieee80211_tx_h_select_key);
-	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
+	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
+		!(info->flags & IEEE80211_TX_CTL_RC_BYPASS))
 		CALL_TXH(ieee80211_tx_h_rate_ctrl);
 
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION)) {
@@ -1462,16 +1463,25 @@ void ieee80211_xmit(struct ieee80211_sub_if_data
*sdata, struct sk_buff *skb,
 	ieee80211_tx(sdata, skb, false, band);
 }
 
-static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
+static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
+					struct ieee80211_local *local)
 {
 	struct ieee80211_radiotap_iterator iterator;
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr,
skb->len,
-						   NULL);
+	struct ieee80211_channel *chan = local->monitor_chandef.chan;
+	struct ieee80211_supported_band *sband =
+		local->hw.wiphy->bands[chan->band];
 	u16 txflags;
+	s8 rate_idx;
+	u16 bit_rate;
+	int i;
+	unsigned char known;
+	unsigned char flags;
 
+	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr,
skb->len,
+						   NULL);
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 		       IEEE80211_TX_CTL_DONTFRAG;
 
@@ -1521,6 +1531,58 @@ static bool ieee80211_parse_tx_radiotap(struct
sk_buff *skb)
 				info->flags |= IEEE80211_TX_CTL_NO_ACK;
 			break;
 
+		case IEEE80211_RADIOTAP_RATE:
+			rate_idx = -1;
+			/* convert legacy rate; NB: .5 Mb/s -> 100 kb/s
*/
+			bit_rate = *iterator.this_arg * 5;
+			for (i = 0; i<  sband->n_bitrates; i++){
+				if (sband->bitrates[i].bitrate ==
bit_rate) {
+					rate_idx = i;
+					break;
+				}
+			}
+			/* Rate not available - rejecting */
+			if (rate_idx<  0)
+				return false;
+
+			info->flags |= IEEE80211_TX_CTL_RC_BYPASS;
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
+				( flags & IEEE80211_RADIOTAP_MCS_SGI))
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
+			info->flags |= IEEE80211_TX_CTL_RC_BYPASS;
+			break;
+
 		/*
 		 * Please update the file
 		 * Documentation/networking/mac80211-injection.txt
@@ -1616,7 +1678,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct
sk_buff *skb,
 		      IEEE80211_TX_CTL_INJECTED;
 
 	/* process and remove the injection radiotap header */
-	if (!ieee80211_parse_tx_radiotap(skb))
+	if (!ieee80211_parse_tx_radiotap(skb,local))
 		goto fail;
 
 	rcu_read_lock();

Cedric Voncken

