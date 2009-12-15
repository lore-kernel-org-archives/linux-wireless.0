Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33646 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182AbZLOULB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 15:11:01 -0500
Message-Id: <20091215200740.011405708@sipsolutions.net>
Date: Tue, 15 Dec 2009 21:06:23 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Subject: [RFC/RFT 5/5] mac80211: re-enable re-transmission of filtered
 frames
References: <20091215200618.253970634@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In an earlier commit,

    mac80211: disable software retry for now
    
    Pavel Roskin reported a problem that seems to be due to
    software retry of already transmitted frames. It turns
    out that we've never done that correctly, but due to
    some recent changes it now crashes in the TX code. I've
    added a comment in the patch that explains the problem
    better and also points to possible solutions -- which
    I can't implement right now.

I disabled software retry of failed/filtered frames
because it was broken. With the work of the previous
patches, it now becomes fairly easy to re-enable it
by adding a flag indicating that the frame shouldn't
be modified, but still running it through the transmit
handlers to populate the control information.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h |    4 ++++
 net/mac80211/status.c  |   32 +++++---------------------------
 net/mac80211/tx.c      |    5 +++++
 3 files changed, 14 insertions(+), 27 deletions(-)

--- wireless-testing.orig/net/mac80211/status.c	2009-12-15 20:50:58.000000000 +0100
+++ wireless-testing/net/mac80211/status.c	2009-12-15 20:53:28.000000000 +0100
@@ -45,37 +45,16 @@ static void ieee80211_handle_filtered_fr
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	/*
-	 * XXX: This is temporary!
-	 *
-	 *	The problem here is that when we get here, the driver will
-	 *	quite likely have pretty much overwritten info->control by
-	 *	using info->driver_data or info->rate_driver_data. Thus,
-	 *	when passing out the frame to the driver again, we would be
-	 *	passing completely bogus data since the driver would then
-	 *	expect a properly filled info->control. In mac80211 itself
-	 *	the same problem occurs, since we need info->control.vif
-	 *	internally.
-	 *
-	 *	To fix this, we should send the frame through TX processing
-	 *	again. However, it's not that simple, since the frame will
-	 *	have been software-encrypted (if applicable) already, and
-	 *	encrypting it again doesn't do much good. So to properly do
-	 *	that, we not only have to skip the actual 'raw' encryption
-	 *	(key selection etc. still has to be done!) but also the
-	 *	sequence number assignment since that impacts the crypto
-	 *	encapsulation, of course.
-	 *
-	 *	Hence, for now, fix the bug by just dropping the frame.
-	 */
-	goto drop;
-
-	/*
 	 * This skb 'survived' a round-trip through the driver, and
 	 * hopefully the driver didn't mangle it too badly. However,
 	 * we can definitely not rely on the the control information
-	 * being correct. Clear it so we don't get junk there.
+	 * being correct. Clear it so we don't get junk there, and
+	 * indicate that it needs new processing, but must not be
+	 * modified/encrypted again.
 	 */
 	memset(&info->control, 0, sizeof(info->control));
+	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING |
+		       IEEE80211_TX_INTFL_RETRANSMISSION;
 
 	sta->tx_filtered_count++;
 
@@ -130,7 +109,6 @@ static void ieee80211_handle_filtered_fr
 		return;
 	}
 
- drop:
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	if (net_ratelimit())
 		printk(KERN_DEBUG "%s: dropped TX filtered frame, "
--- wireless-testing.orig/include/net/mac80211.h	2009-12-15 20:51:21.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-12-15 20:54:11.000000000 +0100
@@ -272,6 +272,9 @@ struct ieee80211_bss_conf {
  *	transmit function after the current frame, this can be used
  *	by drivers to kick the DMA queue only if unset or when the
  *	queue gets full.
+ * @IEEE80211_TX_INTFL_RETRANSMISSION: This frame is being retransmitted
+ *	after TX status because the destination was asleep, it must not
+ *	be modified again (no seqno assignment, crypto, etc.)
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -293,6 +296,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(16),
 	IEEE80211_TX_CTL_PSPOLL_RESPONSE	= BIT(17),
 	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(18),
+	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(19),
 };
 
 /**
--- wireless-testing.orig/net/mac80211/tx.c	2009-12-15 20:54:18.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-12-15 20:55:01.000000000 +0100
@@ -1211,6 +1211,7 @@ static int __ieee80211_tx(struct ieee802
 static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 {
 	struct sk_buff *skb = tx->skb;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	ieee80211_tx_result res = TX_DROP;
 
 #define CALL_TXH(txh) \
@@ -1227,6 +1228,10 @@ static int invoke_tx_handlers(struct iee
 	CALL_TXH(ieee80211_tx_h_michael_mic_add);
 	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
 		CALL_TXH(ieee80211_tx_h_rate_ctrl);
+
+	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION))
+		goto txh_done;
+
 	CALL_TXH(ieee80211_tx_h_sequence);
 	CALL_TXH(ieee80211_tx_h_fragment);
 	/* handlers after fragment must be aware of tx info fragmentation! */


