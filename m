Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35958 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759937Ab1JGMFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 08:05:10 -0400
Message-Id: <20111007120217.591455761@sipsolutions.net> (sfid-20111007_140513_717649_244DB1B5)
Date: Fri, 07 Oct 2011 14:01:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] mac80211: parse radiotap header earlier
References: <20111007120122.982757001@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We can now move the radiotap header parsing into
ieee80211_monitor_start_xmit(). This moves it out of
the hotpath, and also helps the code since now the
radiotap header will no longer be present in
ieee80211_xmit() etc. which is easier to understand.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |    4 
 net/mac80211/tx.c      |  201 +++++++++++++++++++++----------------------------
 2 files changed, 89 insertions(+), 116 deletions(-)

--- a/net/mac80211/tx.c	2011-10-07 11:05:26.000000000 +0200
+++ b/net/mac80211/tx.c	2011-10-07 11:11:52.000000000 +0200
@@ -1035,103 +1035,6 @@ ieee80211_tx_h_calculate_duration(struct
 
 /* actual transmit path */
 
-/*
- * deal with packet injection down monitor interface
- * with Radiotap Header -- only called for monitor mode interface
- */
-static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
-					  struct sk_buff *skb)
-{
-	/*
-	 * this is the moment to interpret and discard the radiotap header that
-	 * must be at the start of the packet injected in Monitor mode
-	 *
-	 * Need to take some care with endian-ness since radiotap
-	 * args are little-endian
-	 */
-
-	struct ieee80211_radiotap_iterator iterator;
-	struct ieee80211_radiotap_header *rthdr =
-		(struct ieee80211_radiotap_header *) skb->data;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
-						   NULL);
-	u16 txflags;
-
-	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
-		       IEEE80211_TX_CTL_DONTFRAG;
-
-	/*
-	 * for every radiotap entry that is present
-	 * (ieee80211_radiotap_iterator_next returns -ENOENT when no more
-	 * entries present, or -EINVAL on error)
-	 */
-
-	while (!ret) {
-		ret = ieee80211_radiotap_iterator_next(&iterator);
-
-		if (ret)
-			continue;
-
-		/* see if this argument is something we can use */
-		switch (iterator.this_arg_index) {
-		/*
-		 * You must take care when dereferencing iterator.this_arg
-		 * for multibyte types... the pointer is not aligned.  Use
-		 * get_unaligned((type *)iterator.this_arg) to dereference
-		 * iterator.this_arg for type "type" safely on all arches.
-		*/
-		case IEEE80211_RADIOTAP_FLAGS:
-			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_FCS) {
-				/*
-				 * this indicates that the skb we have been
-				 * handed has the 32-bit FCS CRC at the end...
-				 * we should react to that by snipping it off
-				 * because it will be recomputed and added
-				 * on transmission
-				 */
-				if (skb->len < (iterator._max_length + FCS_LEN))
-					return false;
-
-				skb_trim(skb, skb->len - FCS_LEN);
-			}
-			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_WEP)
-				info->flags &= ~IEEE80211_TX_INTFL_DONT_ENCRYPT;
-			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_FRAG)
-				info->flags &= ~IEEE80211_TX_CTL_DONTFRAG;
-			break;
-
-		case IEEE80211_RADIOTAP_TX_FLAGS:
-			txflags = le16_to_cpu(get_unaligned((__le16*)
-						iterator.this_arg));
-			if (txflags & IEEE80211_RADIOTAP_F_TX_NOACK)
-				info->flags |= IEEE80211_TX_CTL_NO_ACK;
-			break;
-
-		/*
-		 * Please update the file
-		 * Documentation/networking/mac80211-injection.txt
-		 * when parsing new fields here.
-		 */
-
-		default:
-			break;
-		}
-	}
-
-	if (ret != -ENOENT) /* ie, if we didn't simply run out of fields */
-		return false;
-
-	/*
-	 * remove the radiotap header
-	 * iterator->_max_length was sanity-checked against
-	 * skb->len by iterator init
-	 */
-	skb_pull(skb, iterator._max_length);
-
-	return true;
-}
-
 static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 				  struct sk_buff *skb,
 				  struct ieee80211_tx_info *info,
@@ -1205,19 +1108,6 @@ ieee80211_tx_prepare(struct ieee80211_su
 	tx->sdata = sdata;
 	tx->channel = local->hw.conf.channel;
 
-	/* process and remove the injection radiotap header */
-	if (unlikely(info->flags & IEEE80211_TX_INTFL_HAS_RADIOTAP)) {
-		if (!__ieee80211_parse_tx_radiotap(tx, skb))
-			return TX_DROP;
-
-		/*
-		 * __ieee80211_parse_tx_radiotap has now removed
-		 * the radiotap header that was present and pre-filled
-		 * 'tx' with tx control information.
-		 */
-		info->flags &= ~IEEE80211_TX_INTFL_HAS_RADIOTAP;
-	}
-
 	/*
 	 * If this flag is set to true anywhere, and we get here,
 	 * we are doing the needed processing, so remove the flag
@@ -1559,6 +1449,89 @@ void ieee80211_xmit(struct ieee80211_sub
 	rcu_read_unlock();
 }
 
+static bool ieee80211_parse_tx_radiotap(struct sk_buff *skb)
+{
+	struct ieee80211_radiotap_iterator iterator;
+	struct ieee80211_radiotap_header *rthdr =
+		(struct ieee80211_radiotap_header *) skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
+						   NULL);
+	u16 txflags;
+
+	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
+		       IEEE80211_TX_CTL_DONTFRAG;
+
+	/*
+	 * for every radiotap entry that is present
+	 * (ieee80211_radiotap_iterator_next returns -ENOENT when no more
+	 * entries present, or -EINVAL on error)
+	 */
+
+	while (!ret) {
+		ret = ieee80211_radiotap_iterator_next(&iterator);
+
+		if (ret)
+			continue;
+
+		/* see if this argument is something we can use */
+		switch (iterator.this_arg_index) {
+		/*
+		 * You must take care when dereferencing iterator.this_arg
+		 * for multibyte types... the pointer is not aligned.  Use
+		 * get_unaligned((type *)iterator.this_arg) to dereference
+		 * iterator.this_arg for type "type" safely on all arches.
+		*/
+		case IEEE80211_RADIOTAP_FLAGS:
+			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_FCS) {
+				/*
+				 * this indicates that the skb we have been
+				 * handed has the 32-bit FCS CRC at the end...
+				 * we should react to that by snipping it off
+				 * because it will be recomputed and added
+				 * on transmission
+				 */
+				if (skb->len < (iterator._max_length + FCS_LEN))
+					return false;
+
+				skb_trim(skb, skb->len - FCS_LEN);
+			}
+			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_WEP)
+				info->flags &= ~IEEE80211_TX_INTFL_DONT_ENCRYPT;
+			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_FRAG)
+				info->flags &= ~IEEE80211_TX_CTL_DONTFRAG;
+			break;
+
+		case IEEE80211_RADIOTAP_TX_FLAGS:
+			txflags = get_unaligned_le16(iterator.this_arg);
+			if (txflags & IEEE80211_RADIOTAP_F_TX_NOACK)
+				info->flags |= IEEE80211_TX_CTL_NO_ACK;
+			break;
+
+		/*
+		 * Please update the file
+		 * Documentation/networking/mac80211-injection.txt
+		 * when parsing new fields here.
+		 */
+
+		default:
+			break;
+		}
+	}
+
+	if (ret != -ENOENT) /* ie, if we didn't simply run out of fields */
+		return false;
+
+	/*
+	 * remove the radiotap header
+	 * iterator->_max_length was sanity-checked against
+	 * skb->len by iterator init
+	 */
+	skb_pull(skb, iterator._max_length);
+
+	return true;
+}
+
 netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev)
 {
@@ -1646,8 +1619,11 @@ netdev_tx_t ieee80211_monitor_start_xmit
 	memset(info, 0, sizeof(*info));
 
 	info->flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
-		      IEEE80211_TX_CTL_INJECTED |
-		      IEEE80211_TX_INTFL_HAS_RADIOTAP;
+		      IEEE80211_TX_CTL_INJECTED;
+
+	/* process and remove the injection radiotap header */
+	if (!ieee80211_parse_tx_radiotap(skb))
+		goto fail;
 
 	rcu_read_lock();
 
@@ -1674,7 +1650,6 @@ netdev_tx_t ieee80211_monitor_start_xmit
 		}
 	}
 
-	/* pass the radiotap header up to xmit */
 	ieee80211_xmit(sdata, skb);
 	rcu_read_unlock();
 
--- a/include/net/mac80211.h	2011-10-07 11:01:03.000000000 +0200
+++ b/include/net/mac80211.h	2011-10-07 11:09:41.000000000 +0200
@@ -349,8 +349,6 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_INTFL_RETRANSMISSION: This frame is being retransmitted
  *	after TX status because the destination was asleep, it must not
  *	be modified again (no seqno assignment, crypto, etc.)
- * @IEEE80211_TX_INTFL_HAS_RADIOTAP: This frame was injected and still
- *	has a radiotap header at skb->data.
  * @IEEE80211_TX_INTFL_NL80211_FRAME_TX: Frame was requested through nl80211
  *	MLME command (internal to mac80211 to figure out whether to send TX
  *	status to user space)
@@ -402,7 +400,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_POLL_RESPONSE		= BIT(17),
 	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(18),
 	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(19),
-	IEEE80211_TX_INTFL_HAS_RADIOTAP		= BIT(20),
+	/* hole at 20, use later */
 	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
 	IEEE80211_TX_CTL_LDPC			= BIT(22),
 	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),


