Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:33650 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab2AMAF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 19:05:26 -0500
Received: by yhjj52 with SMTP id j52so3429yhj.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2012 16:05:26 -0800 (PST)
From: Sam Leffler <sleffler@chromium.org>
Date: Thu, 12 Jan 2012 09:53:36 -0800
Subject: [PATCH] mac80211: support fixed rate packet injection
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Message-Id: <20120113000525.4226F5819C@lefflers.sfo.corp.google.com> (sfid-20120113_010530_774887_75179F1F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support setting the transmit rate, flags, and try count for
injected packets by parsing the IEEE80211_RADIOTAP_RATE,
IEEE80211_RADIOTAP_DATA_RETRIES, and IEEE80211_RADIOTAP_MCS radiotap tags.

Change-Id: Id5f3df0424e9a4a584cd565ffa6df35efedb8071
---
 Documentation/networking/mac80211-injection.txt |   13 ++++
 include/net/mac80211.h                          |    4 +
 net/mac80211/tx.c                               |   69 ++++++++++++++++++++++-
 net/wireless/radiotap.c                         |    1 +
 4 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/mac80211-injection.txt b/Documentation/networking/mac80211-injection.txt
index 3a93007..8847a4c 100644
--- a/Documentation/networking/mac80211-injection.txt
+++ b/Documentation/networking/mac80211-injection.txt
@@ -23,11 +23,24 @@ radiotap headers and used to control injection:
    IEEE80211_RADIOTAP_F_FRAG: frame will be fragmented if longer than the
 			      current fragmentation threshold.
 
+ * IEEE80211_RADIOTAP_RATE
+   legacy transmit rate in .5 Mb/s units (u8)
+
  * IEEE80211_RADIOTAP_TX_FLAGS
 
    IEEE80211_RADIOTAP_F_TX_NOACK: frame should be sent without waiting for
 				  an ACK even if it is a unicast frame
 
+ * IEEE80211_RADIOTAP_DATA_RETRIES
+   transmit retry count (u8): may be ignored if NOACK set or bcast/mcast address
+
+ * IEEE80211_RADIOTAP_MCS
+   have_flags(u8), flags(u8), mcs(u8)
+
+   IEEE80211_RADIOTAP_MCS_HAVE_MCS: use MCS value in mcs
+   IEEE80211_RADIOTAP_MCS_HAVE_GI: set GI according to flags
+   IEEE80211_RADIOTAP_MCS_HAVE_BW: set BW according to flags
+
 The injection code can also skip all other currently defined radiotap fields
 facilitating replay of captured radiotap headers directly.
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2a7523e..5045277 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -378,6 +378,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_DONTFRAG: Don't fragment this packet even if it
  *	would be fragmented by size (this is optional, only used for
  *	monitor injection).
+ * @IEEE80211_TX_CTL_NO_RC: This frame does not require rate control.
+ *	This flag is used when an injected frame includes a transmit
+ *	rate (and possibly flags and retry count) in the radiotap header.
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -412,6 +415,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_STATUS_EOSP		= BIT(28),
 	IEEE80211_TX_CTL_USE_MINRATE		= BIT(29),
 	IEEE80211_TX_CTL_DONTFRAG		= BIT(30),
+	IEEE80211_TX_CTL_NO_RC			= BIT(31),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index edcd1c7..5f99c7b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1325,7 +1325,8 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 	CALL_TXH(ieee80211_tx_h_ps_buf);
 	CALL_TXH(ieee80211_tx_h_check_control_port_protocol);
 	CALL_TXH(ieee80211_tx_h_select_key);
-	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
+	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
+	    !(info->flags & IEEE80211_TX_CTL_NO_RC))
 		CALL_TXH(ieee80211_tx_h_rate_ctrl);
 
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION)) {
@@ -1474,7 +1475,8 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	rcu_read_unlock();
 }
 
-static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
+static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
+					struct ieee80211_local *local)
 {
 	struct ieee80211_radiotap_iterator iterator;
 	struct ieee80211_radiotap_header *rthdr =
@@ -1482,6 +1484,8 @@ static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
 						   NULL);
+	u8 fixed_rate, fixed_rate_data_retries;
+	u32 fixed_rate_flags;
 	u16 txflags;
 
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
@@ -1527,12 +1531,36 @@ static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
 				info->flags &= ~IEEE80211_TX_CTL_DONTFRAG;
 			break;
 
+		case IEEE80211_RADIOTAP_RATE:		/* u8 */
+			fixed_rate = *iterator.this_arg;
+			break;
+
 		case IEEE80211_RADIOTAP_TX_FLAGS:
 			txflags = get_unaligned_le16(iterator.this_arg);
 			if (txflags & IEEE80211_RADIOTAP_F_TX_NOACK)
 				info->flags |= IEEE80211_TX_CTL_NO_ACK;
 			break;
 
+		case IEEE80211_RADIOTAP_DATA_RETRIES:	/* u8 */
+			fixed_rate_data_retries = *iterator.this_arg;
+			break;
+
+		case IEEE80211_RADIOTAP_MCS: {		/* u8,u8,u8 */
+			u8 mcs_have = iterator.this_arg[0];
+			if (mcs_have & IEEE80211_RADIOTAP_MCS_HAVE_MCS) {
+				fixed_rate = iterator.this_arg[2];
+				fixed_rate_flags |= IEEE80211_TX_RC_MCS;
+			}
+			if ((mcs_have & IEEE80211_RADIOTAP_MCS_HAVE_GI) &&
+			    (iterator.this_arg[1] & IEEE80211_RADIOTAP_MCS_SGI))
+				fixed_rate_flags |= IEEE80211_TX_RC_SHORT_GI;
+			if ((mcs_have & IEEE80211_RADIOTAP_MCS_HAVE_BW) &&
+			    (iterator.this_arg[1]&IEEE80211_RADIOTAP_MCS_BW_40))
+				fixed_rate_flags |=
+					IEEE80211_TX_RC_40_MHZ_WIDTH;
+			break;
+		}
+
 		/*
 		 * Please update the file
 		 * Documentation/networking/mac80211-injection.txt
@@ -1547,6 +1575,41 @@ static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
 	if (ret != -ENOENT) /* ie, if we didn't simply run out of fields */
 		return false;
 
+	if (fixed_rate != -1) {
+		struct ieee80211_channel *chan = local->hw.conf.channel;
+		struct ieee80211_supported_band *sband =
+			local->hw.wiphy->bands[chan->band];
+		struct ieee80211_tx_rate *rates = info->control.rates;
+		int i;
+
+		if (fixed_rate_flags & IEEE80211_TX_RC_MCS) {
+			WARN_ON(!sband->ht_cap.ht_supported);
+			rates[0].idx = fixed_rate;
+		} else {
+			/* convert legacy rate; NB: .5 Mb/s -> 100 kb/s */
+			int bitrate = fixed_rate*5;
+			rates[0].idx = 0;	/* default to lowest rate */
+			for (i = 0; i < sband->n_bitrates; i++)
+				if (bitrate == sband->bitrates[i].bitrate) {
+					rates[0].idx = i;
+					break;
+				}
+		}
+
+		rates[0].count = 1+fixed_rate_data_retries;
+		if (rates[0].count > local->hw.max_rate_tries)
+			rates[0].count = local->hw.max_rate_tries;
+		rates[0].flags = fixed_rate_flags;
+
+		for (i = 1; i < IEEE80211_TX_MAX_RATES; i++) {
+			rates[i].idx = -1;
+			rates[i].count = 0;
+			rates[i].flags = 0;
+		}
+
+		info->flags |= IEEE80211_TX_CTL_NO_RC;
+	}
+
 	/*
 	 * remove the radiotap header
 	 * iterator->_max_length was sanity-checked against
@@ -1647,7 +1710,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 		      IEEE80211_TX_CTL_INJECTED;
 
 	/* process and remove the injection radiotap header */
-	if (!ieee80211_parse_tx_radiotap(skb))
+	if (!ieee80211_parse_tx_radiotap(skb, local))
 		goto fail;
 
 	rcu_read_lock();
diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index c4ad795..0e99cb7 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -41,6 +41,7 @@ static const struct radiotap_align_size rtap_namespace_sizes[] = {
 	[IEEE80211_RADIOTAP_TX_FLAGS] = { .align = 2, .size = 2, },
 	[IEEE80211_RADIOTAP_RTS_RETRIES] = { .align = 1, .size = 1, },
 	[IEEE80211_RADIOTAP_DATA_RETRIES] = { .align = 1, .size = 1, },
+	[IEEE80211_RADIOTAP_MCS] = { .align = 1, .size = 3, },
 	/*
 	 * add more here as they are defined in radiotap.h
 	 */
-- 
1.7.7.3

