Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYBUJYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 04:24:08 -0500
Subject: [PATCH] mac80211: rework TX filtered frame code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 23:59:33 +0100
Message-Id: <1203548373.17534.96.camel@johannes.berg> (sfid-20080221_092523_165595_9C6CEDE8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reworks the code for TX filtered frames, splitting it out to
a new function to handle those cases, making the clear instruction
a flag and renaming a few things to be easier to understand and
less Atheros hardware specific. Finally, it also makes the comments
explain more.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h   |    3 -
 net/mac80211/ieee80211.c |  121 ++++++++++++++++++++++++++++++-----------------
 net/mac80211/sta_info.h  |    6 +-
 net/mac80211/tx.c        |   12 ++--
 4 files changed, 91 insertions(+), 51 deletions(-)

--- everything.orig/net/mac80211/ieee80211.c	2008-02-20 23:23:36.000000000 +0100
+++ everything/net/mac80211/ieee80211.c	2008-02-20 23:56:50.000000000 +0100
@@ -1178,6 +1178,77 @@ no_key:
 	}
 }
 
+static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
+					    struct sta_info *sta,
+					    struct sk_buff *skb,
+					    struct ieee80211_tx_status *status)
+{
+	sta->tx_filtered_count++;
+
+	/*
+	 * Clear the TX filter mask for this STA when sending the next
+	 * packet. If the STA went to power save mode, this will happen
+	 * happen when it wakes up for the next time.
+	 */
+	sta->flags |= WLAN_STA_CLEAR_PS_FILT;
+
+	/*
+	 * This code races in the following way:
+	 *
+	 *  (1) STA sends frame indicating it will go to sleep and does so
+	 *  (2) hardware/firmware adds STA to filter list, passes frame up
+	 *  (3) hardware/firmware processes TX fifo and suppresses a frame
+	 *  (4) we get TX status before having processed the frame and
+	 *	knowing that the STA has gone to sleep.
+	 *
+	 * This is actually quite unlikely even when both those events are
+	 * processed from interrupts coming in quickly after one another or
+	 * even at the same time because we queue both TX status events and
+	 * RX frames to be processed by a tasklet and process them in the
+	 * same order that they were received or TX status last. Hence, there
+	 * is no race as long as the frame RX is processed before the next TX
+	 * status, which drivers can ensure, see below.
+	 *
+	 * Note that this can only happen if the hardware or firmware can
+	 * actually add STAs to the filter list, if this is done by the
+	 * driver in response to set_tim() (which will only reduce the race
+	 * this whole filtering tries to solve, not completely solve it)
+	 * this situation cannot happen.
+	 *
+	 * To completely solve this race drivers need to make sure that they
+	 *  (a) don't mix the irq-safe/not irq-safe TX status/RX processing
+	 *	functions and
+	 *  (b) always process RX events before TX status events if ordering
+	 *      can be unknown, for example with different interrupt status
+	 *	bits.
+	 */
+	if (sta->flags & WLAN_STA_PS &&
+	    skb_queue_len(&sta->tx_filtered) < STA_MAX_TX_BUFFER) {
+		ieee80211_remove_tx_extra(local, sta->key, skb,
+					  &status->control);
+		skb_queue_tail(&sta->tx_filtered, skb);
+		return;
+	}
+
+	if (!(sta->flags & WLAN_STA_PS) &&
+	    !(status->control.flags & IEEE80211_TXCTL_REQUEUE)) {
+		/* Software retry the packet once */
+		status->control.flags |= IEEE80211_TXCTL_REQUEUE;
+		ieee80211_remove_tx_extra(local, sta->key, skb,
+					  &status->control);
+		dev_queue_xmit(skb);
+		return;
+	}
+
+	if (net_ratelimit())
+		printk(KERN_DEBUG "%s: dropped TX filtered frame, "
+		       "queue_len=%d PS=%d @%lu\n",
+		       wiphy_name(local->hw.wiphy),
+		       skb_queue_len(&sta->tx_filtered),
+		       !!(sta->flags & WLAN_STA_PS), jiffies);
+	dev_kfree_skb(skb);
+}
+
 void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
 			 struct ieee80211_tx_status *status)
 {
@@ -1202,11 +1273,16 @@ void ieee80211_tx_status(struct ieee8021
 		sta = sta_info_get(local, hdr->addr1);
 		if (sta) {
 			if (sta->flags & WLAN_STA_PS) {
-				/* The STA is in power save mode, so assume
+				/*
+				 * The STA is in power save mode, so assume
 				 * that this TX packet failed because of that.
 				 */
 				status->excessive_retries = 0;
 				status->flags |= IEEE80211_TX_STATUS_TX_FILTERED;
+				ieee80211_handle_filtered_frame(local, sta,
+								skb, status);
+				sta_info_put(sta);
+				return;
 			}
 			sta_info_put(sta);
 		}
@@ -1216,47 +1292,8 @@ void ieee80211_tx_status(struct ieee8021
 		struct sta_info *sta;
 		sta = sta_info_get(local, hdr->addr1);
 		if (sta) {
-			sta->tx_filtered_count++;
-
-			/* Clear the TX filter mask for this STA when sending
-			 * the next packet. If the STA went to power save mode,
-			 * this will happen when it is waking up for the next
-			 * time. */
-			sta->clear_dst_mask = 1;
-
-			/* TODO: Is the WLAN_STA_PS flag always set here or is
-			 * the race between RX and TX status causing some
-			 * packets to be filtered out before 80211.o gets an
-			 * update for PS status? This seems to be the case, so
-			 * no changes are likely to be needed. */
-			if (sta->flags & WLAN_STA_PS &&
-			    skb_queue_len(&sta->tx_filtered) <
-			    STA_MAX_TX_BUFFER) {
-				ieee80211_remove_tx_extra(local, sta->key,
-							  skb,
-							  &status->control);
-				skb_queue_tail(&sta->tx_filtered, skb);
-			} else if (!(sta->flags & WLAN_STA_PS) &&
-				   !(status->control.flags & IEEE80211_TXCTL_REQUEUE)) {
-				/* Software retry the packet once */
-				status->control.flags |= IEEE80211_TXCTL_REQUEUE;
-				ieee80211_remove_tx_extra(local, sta->key,
-							  skb,
-							  &status->control);
-				dev_queue_xmit(skb);
-			} else {
-				if (net_ratelimit()) {
-					printk(KERN_DEBUG "%s: dropped TX "
-					       "filtered frame queue_len=%d "
-					       "PS=%d @%lu\n",
-					       wiphy_name(local->hw.wiphy),
-					       skb_queue_len(
-						       &sta->tx_filtered),
-					       !!(sta->flags & WLAN_STA_PS),
-					       jiffies);
-				}
-				dev_kfree_skb(skb);
-			}
+			ieee80211_handle_filtered_frame(local, sta, skb,
+							status);
 			sta_info_put(sta);
 			return;
 		}
--- everything.orig/include/net/mac80211.h	2008-02-20 23:23:36.000000000 +0100
+++ everything/include/net/mac80211.h	2008-02-20 23:23:37.000000000 +0100
@@ -228,7 +228,8 @@ struct ieee80211_tx_control {
 #define IEEE80211_TXCTL_NO_ACK		(1<<4) /* tell the low level not to
 						* wait for an ack */
 #define IEEE80211_TXCTL_RATE_CTRL_PROBE	(1<<5)
-#define IEEE80211_TXCTL_CLEAR_DST_MASK	(1<<6)
+#define IEEE80211_TXCTL_CLEAR_PS_FILT	(1<<6) /* clear powersave filter
+						* for destination station */
 #define IEEE80211_TXCTL_REQUEUE		(1<<7)
 #define IEEE80211_TXCTL_FIRST_FRAGMENT	(1<<8) /* this is a first fragment of
 						* the frame */
--- everything.orig/net/mac80211/sta_info.h	2008-02-20 23:23:37.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-20 23:23:37.000000000 +0100
@@ -32,6 +32,9 @@
  * @WLAN_STA_WME: Station is a QoS-STA.
  * @WLAN_STA_WDS: Station is one of our WDS peers.
  * @WLAN_STA_PSPOLL: Station has just PS-polled us.
+ * @WLAN_STA_CLEAR_PS_FILT: Clear PS filter in hardware (using the
+ *	IEEE80211_TXCTL_CLEAR_PS_FILT control flag) when the next
+ *	frame to this station is transmitted.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
@@ -43,6 +46,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_WME		= 1<<6,
 	WLAN_STA_WDS		= 1<<7,
 	WLAN_STA_PSPOLL		= 1<<8,
+	WLAN_STA_CLEAR_PS_FILT	= 1<<9,
 };
 
 #define STA_TID_NUM 16
@@ -136,8 +140,6 @@ struct sta_info {
 	struct sk_buff_head tx_filtered; /* buffer of TX frames that were
 					  * already given to low-level driver,
 					  * but were filtered */
-	int clear_dst_mask;
-
 	unsigned long rx_packets, tx_packets; /* number of RX/TX MSDUs */
 	unsigned long rx_bytes, tx_bytes;
 	unsigned long tx_retry_failed, tx_retry_count;
--- everything.orig/net/mac80211/tx.c	2008-02-20 23:23:37.000000000 +0100
+++ everything/net/mac80211/tx.c	2008-02-20 23:23:37.000000000 +0100
@@ -1020,10 +1020,10 @@ __ieee80211_tx_prepare(struct ieee80211_
 	}
 
 	if (!tx->sta)
-		control->flags |= IEEE80211_TXCTL_CLEAR_DST_MASK;
-	else if (tx->sta->clear_dst_mask) {
-		control->flags |= IEEE80211_TXCTL_CLEAR_DST_MASK;
-		tx->sta->clear_dst_mask = 0;
+		control->flags |= IEEE80211_TXCTL_CLEAR_PS_FILT;
+	else if (tx->sta->flags & WLAN_STA_CLEAR_PS_FILT) {
+		control->flags |= IEEE80211_TXCTL_CLEAR_PS_FILT;
+		tx->sta->flags &= ~WLAN_STA_CLEAR_PS_FILT;
 	}
 
 	hdrlen = ieee80211_get_hdrlen(tx->fc);
@@ -1084,7 +1084,7 @@ static int __ieee80211_tx(struct ieee802
 	if (tx->u.tx.extra_frag) {
 		control->flags &= ~(IEEE80211_TXCTL_USE_RTS_CTS |
 				    IEEE80211_TXCTL_USE_CTS_PROTECT |
-				    IEEE80211_TXCTL_CLEAR_DST_MASK |
+				    IEEE80211_TXCTL_CLEAR_PS_FILT |
 				    IEEE80211_TXCTL_FIRST_FRAGMENT);
 		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
 			if (!tx->u.tx.extra_frag[i])
@@ -1806,7 +1806,7 @@ struct sk_buff *ieee80211_beacon_get(str
 		control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
 		control->flags |= IEEE80211_TXCTL_NO_ACK;
 		control->retry_limit = 1;
-		control->flags |= IEEE80211_TXCTL_CLEAR_DST_MASK;
+		control->flags |= IEEE80211_TXCTL_CLEAR_PS_FILT;
 	}
 
 	ap->num_beacons++;


