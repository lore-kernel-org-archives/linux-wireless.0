Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab1IVPtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 11:49:52 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R6lX4-0002N0-QR
	for linux-wireless@vger.kernel.org; Thu, 22 Sep 2011 17:49:51 +0200
Message-Id: <20110922154849.648785480@sipsolutions.net> (sfid-20110922_175005_498342_96324B57)
Date: Thu, 22 Sep 2011 17:47:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 04/15] mac80211: split PS buffers into ACs
References: <20110922154726.521122680@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For uAPSD support we'll need to have per-AC PS
buffers. As this is a major undertaking, split
the buffers before really adding support for
uAPSD. This already makes some reference to the
uapsd_queues variable, but for now that will
never be non-zero.

Since book-keeping is complicated, also change
the logic for keeping a maximum of frames only
and allow 64 frames per AC (up from 128 for a
station).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |    1 
 net/mac80211/debugfs_sta.c |   10 +-
 net/mac80211/sta_info.c    |  197 ++++++++++++++++++++++++++++++++++-----------
 net/mac80211/sta_info.h    |   24 ++---
 net/mac80211/status.c      |   17 +++
 net/mac80211/tx.c          |   42 +++++----
 6 files changed, 211 insertions(+), 80 deletions(-)

--- a/net/mac80211/sta_info.c	2011-09-22 14:39:19.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-22 15:47:13.000000000 +0200
@@ -309,8 +309,10 @@ struct sta_info *sta_info_alloc(struct i
 		 */
 		sta->timer_to_tid[i] = i;
 	}
-	skb_queue_head_init(&sta->ps_tx_buf);
-	skb_queue_head_init(&sta->tx_filtered);
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		skb_queue_head_init(&sta->ps_tx_buf[i]);
+		skb_queue_head_init(&sta->tx_filtered[i]);
+	}
 
 	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
 		sta->last_seq_ctrl[i] = cpu_to_le16(USHRT_MAX);
@@ -641,31 +643,73 @@ static inline void __bss_tim_clear(struc
 	bss->tim[aid / 8] &= ~(1 << (aid % 8));
 }
 
+static unsigned long ieee80211_tids_for_ac(int ac)
+{
+	/* If we ever support TIDs > 7, this obviously needs to be adjusted */
+	switch (ac) {
+	case IEEE80211_AC_VO:
+		return BIT(6) | BIT(7);
+	case IEEE80211_AC_VI:
+		return BIT(4) | BIT(5);
+	case IEEE80211_AC_BE:
+		return BIT(0) | BIT(3);
+	case IEEE80211_AC_BK:
+		return BIT(1) | BIT(2);
+	default:
+		WARN_ON(1);
+		return 0;
+	}
+}
+
 void sta_info_recalc_tim(struct sta_info *sta)
 {
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_if_ap *bss = sta->sdata->bss;
 	unsigned long flags;
-	bool have_data;
+	bool indicate_tim = false;
+	u8 ignore_for_tim = sta->sta.uapsd_queues;
+	int ac;
 
 	/* No need to do anything if the driver does all */
 	if (local->hw.flags & IEEE80211_HW_AP_LINK_PS)
 		return;
 
-	have_data = test_sta_flags(sta, WLAN_STA_PS_DRIVER_BUF) ||
-		    !skb_queue_empty(&sta->tx_filtered) ||
-		    !skb_queue_empty(&sta->ps_tx_buf);
+	/*
+	 * If all ACs are delivery-enabled then we should build
+	 * the TIM bit for all ACs anyway; if only some are then
+	 * we ignore those and build the TIM bit using only the
+	 * non-enabled ones.
+	 */
+	if (ignore_for_tim == BIT(IEEE80211_NUM_ACS) - 1)
+		ignore_for_tim = 0;
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		unsigned long tids;
+
+		if (ignore_for_tim & BIT(ac))
+			continue;
+
+		indicate_tim |= !skb_queue_empty(&sta->tx_filtered[ac]) ||
+				!skb_queue_empty(&sta->ps_tx_buf[ac]);
+		if (indicate_tim)
+			break;
+
+		tids = ieee80211_tids_for_ac(ac);
+
+		indicate_tim |=
+			sta->driver_buffered_tids & tids;
+	}
 
 	spin_lock_irqsave(&local->sta_lock, flags);
 
-	if (have_data)
+	if (indicate_tim)
 		__bss_tim_set(bss, sta->sta.aid);
 	else
 		__bss_tim_clear(bss, sta->sta.aid);
 
 	if (local->ops->set_tim) {
 		local->tim_in_locked_section = true;
-		drv_set_tim(local, &sta->sta, have_data);
+		drv_set_tim(local, &sta->sta, indicate_tim);
 		local->tim_in_locked_section = false;
 	}
 
@@ -692,8 +736,8 @@ static bool sta_info_buffer_expired(stru
 }
 
 
-static bool sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
-					     struct sta_info *sta)
+static bool sta_info_cleanup_expire_buffered_ac(struct ieee80211_local *local,
+						struct sta_info *sta, int ac)
 {
 	unsigned long flags;
 	struct sk_buff *skb;
@@ -706,13 +750,13 @@ static bool sta_info_cleanup_expire_buff
 	 * total_ps_buffered counter.
 	 */
 	for (;;) {
-		spin_lock_irqsave(&sta->tx_filtered.lock, flags);
-		skb = skb_peek(&sta->tx_filtered);
+		spin_lock_irqsave(&sta->tx_filtered[ac].lock, flags);
+		skb = skb_peek(&sta->tx_filtered[ac]);
 		if (sta_info_buffer_expired(sta, skb))
-			skb = __skb_dequeue(&sta->tx_filtered);
+			skb = __skb_dequeue(&sta->tx_filtered[ac]);
 		else
 			skb = NULL;
-		spin_unlock_irqrestore(&sta->tx_filtered.lock, flags);
+		spin_unlock_irqrestore(&sta->tx_filtered[ac].lock, flags);
 
 		/*
 		 * Frames are queued in order, so if this one
@@ -732,13 +776,13 @@ static bool sta_info_cleanup_expire_buff
 	 * buffered frames.
 	 */
 	for (;;) {
-		spin_lock_irqsave(&sta->ps_tx_buf.lock, flags);
-		skb = skb_peek(&sta->ps_tx_buf);
+		spin_lock_irqsave(&sta->ps_tx_buf[ac].lock, flags);
+		skb = skb_peek(&sta->ps_tx_buf[ac]);
 		if (sta_info_buffer_expired(sta, skb))
-			skb = __skb_dequeue(&sta->ps_tx_buf);
+			skb = __skb_dequeue(&sta->ps_tx_buf[ac]);
 		else
 			skb = NULL;
-		spin_unlock_irqrestore(&sta->ps_tx_buf.lock, flags);
+		spin_unlock_irqrestore(&sta->ps_tx_buf[ac].lock, flags);
 
 		/*
 		 * frames are queued in order, so if this one
@@ -768,8 +812,22 @@ static bool sta_info_cleanup_expire_buff
 	 * used to check whether the cleanup timer still needs to run,
 	 * if there are no frames we don't need to rearm the timer.
 	 */
-	return !(skb_queue_empty(&sta->ps_tx_buf) &&
-		 skb_queue_empty(&sta->tx_filtered));
+	return !(skb_queue_empty(&sta->ps_tx_buf[ac]) &&
+		 skb_queue_empty(&sta->tx_filtered[ac]));
+}
+
+static bool sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
+					     struct sta_info *sta)
+{
+	bool have_buffered = false;
+	int ac;
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		have_buffered |=
+			sta_info_cleanup_expire_buffered_ac(local, sta, ac);
+	}
+
+	return have_buffered;
 }
 
 static int __must_check __sta_info_destroy(struct sta_info *sta)
@@ -777,7 +835,7 @@ static int __must_check __sta_info_destr
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	unsigned long flags;
-	int ret, i;
+	int ret, i, ac;
 
 	might_sleep();
 
@@ -814,9 +872,11 @@ static int __must_check __sta_info_destr
 
 	sta->dead = true;
 
-	local->total_ps_buffered -= skb_queue_len(&sta->ps_tx_buf);
-	__skb_queue_purge(&sta->ps_tx_buf);
-	__skb_queue_purge(&sta->tx_filtered);
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		local->total_ps_buffered -= skb_queue_len(&sta->ps_tx_buf[ac]);
+		__skb_queue_purge(&sta->ps_tx_buf[ac]);
+		__skb_queue_purge(&sta->tx_filtered[ac]);
+	}
 
 	if (test_and_clear_sta_flags(sta,
 				WLAN_STA_PS_STA | WLAN_STA_PS_DRIVER)) {
@@ -1044,17 +1104,33 @@ void ieee80211_sta_ps_deliver_wakeup(str
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
-	int sent, buffered;
+	struct sk_buff_head pending;
+	int filtered = 0, buffered = 0, ac;
+
+	BUILD_BUG_ON(BITS_TO_LONGS(STA_TID_NUM) > 1);
+	sta->driver_buffered_tids = 0;
 
-	clear_sta_flags(sta, WLAN_STA_PS_DRIVER_BUF);
 	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
 		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
 
+	skb_queue_head_init(&pending);
+
 	/* Send all buffered frames to the station */
-	sent = ieee80211_add_pending_skbs(local, &sta->tx_filtered);
-	buffered = ieee80211_add_pending_skbs_fn(local, &sta->ps_tx_buf,
-						 clear_sta_ps_flags, sta);
-	sent += buffered;
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		int count = skb_queue_len(&pending), tmp;
+
+		skb_queue_splice_tail_init(&sta->tx_filtered[ac], &pending);
+		tmp = skb_queue_len(&pending);
+		filtered += tmp - count;
+		count = tmp;
+
+		skb_queue_splice_tail_init(&sta->ps_tx_buf[ac], &pending);
+		tmp = skb_queue_len(&pending);
+		buffered += tmp - count;
+	}
+
+	ieee80211_add_pending_skbs_fn(local, &pending, clear_sta_ps_flags, sta);
+
 	local->total_ps_buffered -= buffered;
 
 	sta_info_recalc_tim(sta);
@@ -1062,7 +1138,7 @@ void ieee80211_sta_ps_deliver_wakeup(str
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %pM aid %d sending %d filtered/%d PS frames "
 	       "since STA not sleeping anymore\n", sdata->name,
-	       sta->sta.addr, sta->sta.aid, sent - buffered, buffered);
+	       sta->sta.addr, sta->sta.aid, filtered, buffered);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 }
 
@@ -1070,17 +1146,43 @@ void ieee80211_sta_ps_deliver_poll_respo
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	int no_pending_pkts;
+	struct sk_buff *skb = NULL;
+	bool more_data = false;
+	int ac;
+	u8 ignore_for_response = sta->sta.uapsd_queues;
+
+	/*
+	 * If all ACs are delivery-enabled then we should reply
+	 * from any of them, if only some are enabled we reply
+	 * only from the non-enabled ones.
+	 */
+	if (ignore_for_response == BIT(IEEE80211_NUM_ACS) - 1)
+		ignore_for_response = 0;
+
+	/*
+	 * Get response frame and more data bit for it.
+	 */
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		if (ignore_for_response & BIT(ac))
+			continue;
+
+		if (!skb) {
+			skb = skb_dequeue(&sta->tx_filtered[ac]);
+			if (!skb) {
+				skb = skb_dequeue(&sta->ps_tx_buf[ac]);
+				if (skb)
+					local->total_ps_buffered--;
+			}
+		}
+
+		/* FIXME: take into account driver-buffered frames */
 
-	skb = skb_dequeue(&sta->tx_filtered);
-	if (!skb) {
-		skb = skb_dequeue(&sta->ps_tx_buf);
-		if (skb)
-			local->total_ps_buffered--;
+		if (!skb_queue_empty(&sta->tx_filtered[ac]) ||
+		    !skb_queue_empty(&sta->ps_tx_buf[ac])) {
+			more_data = true;
+			break;
+		}
 	}
-	no_pending_pkts = skb_queue_empty(&sta->tx_filtered) &&
-		skb_queue_empty(&sta->ps_tx_buf);
 
 	if (skb) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1094,14 +1196,13 @@ void ieee80211_sta_ps_deliver_poll_respo
 		info->flags |= IEEE80211_TX_CTL_PSPOLL_RESPONSE;
 
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-		printk(KERN_DEBUG "STA %pM aid %d: PS Poll (entries after %d)\n",
-		       sta->sta.addr, sta->sta.aid,
-		       skb_queue_len(&sta->ps_tx_buf));
+		printk(KERN_DEBUG "STA %pM aid %d: PS Poll\n",
+		       sta->sta.addr, sta->sta.aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 
 		/* Use MoreData flag to indicate whether there are more
 		 * buffered frames for this STA */
-		if (no_pending_pkts)
+		if (!more_data)
 			hdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
 		else
 			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
@@ -1143,10 +1244,14 @@ void ieee80211_sta_set_buffered(struct i
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 
-	if (!buffered)
+	if (WARN_ON(tid >= STA_TID_NUM))
 		return;
 
-	set_sta_flags(sta, WLAN_STA_PS_DRIVER_BUF);
+	if (buffered)
+		set_bit(tid, &sta->driver_buffered_tids);
+	else
+		clear_bit(tid, &sta->driver_buffered_tids);
+
 	sta_info_recalc_tim(sta);
 }
 EXPORT_SYMBOL(ieee80211_sta_set_buffered);
--- a/net/mac80211/sta_info.h	2011-09-22 14:39:19.000000000 +0200
+++ b/net/mac80211/sta_info.h	2011-09-22 15:47:33.000000000 +0200
@@ -43,8 +43,6 @@
  *	be in the queues
  * @WLAN_STA_PSPOLL: Station sent PS-poll while driver was keeping
  *	station in power-save mode, reply when the driver unblocks.
- * @WLAN_STA_PS_DRIVER_BUF: Station has frames pending in driver internal
- *	buffers. Automatically cleared on station wake-up.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
@@ -60,7 +58,6 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_BLOCK_BA	= 1<<11,
 	WLAN_STA_PS_DRIVER	= 1<<12,
 	WLAN_STA_PSPOLL		= 1<<13,
-	WLAN_STA_PS_DRIVER_BUF	= 1<<14,
 };
 
 #define STA_TID_NUM 16
@@ -207,11 +204,13 @@ struct sta_ampdu_mlme {
  * @drv_unblock_wk: used for driver PS unblocking
  * @listen_interval: listen interval of this station, when we're acting as AP
  * @flags: STA flags, see &enum ieee80211_sta_info_flags
- * @ps_tx_buf: buffer of frames to transmit to this station
- *	when it leaves power saving state
- * @tx_filtered: buffer of frames we already tried to transmit
- *	but were filtered by hardware due to STA having entered
- *	power saving state
+ * @ps_tx_buf: buffers (per AC) of frames to transmit to this station
+ *	when it leaves power saving state or polls
+ * @tx_filtered: buffers (per AC) of frames we already tried to
+ *	transmit but were filtered by hardware due to STA having
+ *	entered power saving state, these are also delivered to
+ *	the station when it leaves powersave or polls for frames
+ * @driver_buffered_tids: bitmap of TIDs the driver has data buffered on
  * @rx_packets: Number of MSDUs received from this STA
  * @rx_bytes: Number of bytes received from this STA
  * @wep_weak_iv_count: number of weak WEP IVs received from this station
@@ -281,8 +280,9 @@ struct sta_info {
 	 * STA powersave frame queues, no more than the internal
 	 * locking required.
 	 */
-	struct sk_buff_head ps_tx_buf;
-	struct sk_buff_head tx_filtered;
+	struct sk_buff_head ps_tx_buf[IEEE80211_NUM_ACS];
+	struct sk_buff_head tx_filtered[IEEE80211_NUM_ACS];
+	unsigned long driver_buffered_tids;
 
 	/* Updated from RX path only, no locking requirements */
 	unsigned long rx_packets, rx_bytes;
@@ -429,8 +429,8 @@ rcu_dereference_protected_tid_tx(struct
 #define STA_HASH(sta) (sta[5])
 
 
-/* Maximum number of frames to buffer per power saving station */
-#define STA_MAX_TX_BUFFER 128
+/* Maximum number of frames to buffer per power saving station per AC */
+#define STA_MAX_TX_BUFFER	64
 
 /* Minimum buffered frame expiry time. If STA uses listen interval that is
  * smaller than this value, the minimum value here is used instead. */
--- a/include/net/mac80211.h	2011-09-22 14:39:19.000000000 +0200
+++ b/include/net/mac80211.h	2011-09-22 15:47:13.000000000 +0200
@@ -109,6 +109,7 @@ enum ieee80211_ac_numbers {
 	IEEE80211_AC_BE		= 2,
 	IEEE80211_AC_BK		= 3,
 };
+#define IEEE80211_NUM_ACS	4
 
 /**
  * struct ieee80211_tx_queue_params - transmit queue configuration
--- a/net/mac80211/status.c	2011-09-22 14:39:19.000000000 +0200
+++ b/net/mac80211/status.c	2011-09-22 15:47:13.000000000 +0200
@@ -14,6 +14,7 @@
 #include "rate.h"
 #include "mesh.h"
 #include "led.h"
+#include "wme.h"
 
 
 void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
@@ -43,6 +44,8 @@ static void ieee80211_handle_filtered_fr
 					    struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+	int ac;
 
 	/*
 	 * This skb 'survived' a round-trip through the driver, and
@@ -62,6 +65,14 @@ static void ieee80211_handle_filtered_fr
 
 	sta->tx_filtered_count++;
 
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		int tid = *ieee80211_get_qos_ctl(hdr) &
+					IEEE80211_QOS_CTL_TID_MASK;
+		ac = ieee802_1d_to_ac[tid & 7];
+	} else {
+		ac = IEEE80211_AC_BE;
+	}
+
 	/*
 	 * Clear the TX filter mask for this STA when sending the next
 	 * packet. If the STA went to power save mode, this will happen
@@ -104,8 +115,8 @@ static void ieee80211_handle_filtered_fr
 	 *	unknown.
 	 */
 	if (test_sta_flags(sta, WLAN_STA_PS_STA) &&
-	    skb_queue_len(&sta->tx_filtered) < STA_MAX_TX_BUFFER) {
-		skb_queue_tail(&sta->tx_filtered, skb);
+	    skb_queue_len(&sta->tx_filtered[ac]) < STA_MAX_TX_BUFFER) {
+		skb_queue_tail(&sta->tx_filtered[ac], skb);
 		sta_info_recalc_tim(sta);
 
 		if (!timer_pending(&local->sta_cleanup))
@@ -127,7 +138,7 @@ static void ieee80211_handle_filtered_fr
 	if (net_ratelimit())
 		wiphy_debug(local->hw.wiphy,
 			    "dropped TX filtered frame, queue_len=%d PS=%d @%lu\n",
-			    skb_queue_len(&sta->tx_filtered),
+			    skb_queue_len(&sta->tx_filtered[ac]),
 			    !!test_sta_flags(sta, WLAN_STA_PS_STA), jiffies);
 #endif
 	dev_kfree_skb(skb);
--- a/net/mac80211/debugfs_sta.c	2011-09-22 14:38:53.000000000 +0200
+++ b/net/mac80211/debugfs_sta.c	2011-09-22 15:47:10.000000000 +0200
@@ -78,8 +78,14 @@ static ssize_t sta_num_ps_buf_frames_rea
 					  size_t count, loff_t *ppos)
 {
 	struct sta_info *sta = file->private_data;
-	return mac80211_format_buffer(userbuf, count, ppos, "%u\n",
-				      skb_queue_len(&sta->ps_tx_buf));
+	char buf[17*IEEE80211_NUM_ACS], *p = buf;
+	int ac;
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+		p += scnprintf(p, sizeof(buf)+buf-p, "AC%d: %d\n", ac,
+			       skb_queue_len(&sta->ps_tx_buf[ac]) +
+			       skb_queue_len(&sta->tx_filtered[ac]));
+	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
 }
 STA_OPS(num_ps_buf_frames);
 
--- a/net/mac80211/tx.c	2011-09-22 14:39:19.000000000 +0200
+++ b/net/mac80211/tx.c	2011-09-22 15:47:12.000000000 +0200
@@ -343,13 +343,22 @@ static void purge_old_ps_buffers(struct
 		total += skb_queue_len(&ap->ps_bc_buf);
 	}
 
+	/*
+	 * Drop one frame from each station from the lowest-priority
+	 * AC that has frames at all.
+	 */
 	list_for_each_entry_rcu(sta, &local->sta_list, list) {
-		skb = skb_dequeue(&sta->ps_tx_buf);
-		if (skb) {
-			purged++;
-			dev_kfree_skb(skb);
+		int ac;
+
+		for (ac = IEEE80211_AC_BK; ac >= IEEE80211_AC_VO; ac--) {
+			skb = skb_dequeue(&sta->ps_tx_buf[ac]);
+			total += skb_queue_len(&sta->ps_tx_buf[ac]);
+			if (skb) {
+				purged++;
+				dev_kfree_skb(skb);
+				break;
+			}
 		}
-		total += skb_queue_len(&sta->ps_tx_buf);
 	}
 
 	rcu_read_unlock();
@@ -448,22 +457,21 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 
 	if (unlikely((staflags & (WLAN_STA_PS_STA | WLAN_STA_PS_DRIVER)) &&
 		     !(info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE))) {
+		int ac = skb_get_queue_mapping(tx->skb);
+
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-		printk(KERN_DEBUG "STA %pM aid %d: PS buffer (entries "
-		       "before %d)\n",
-		       sta->sta.addr, sta->sta.aid,
-		       skb_queue_len(&sta->ps_tx_buf));
+		printk(KERN_DEBUG "STA %pM aid %d: PS buffer for AC %d\n",
+		       sta->sta.addr, sta->sta.aid, ac);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
 			purge_old_ps_buffers(tx->local);
-		if (skb_queue_len(&sta->ps_tx_buf) >= STA_MAX_TX_BUFFER) {
-			struct sk_buff *old = skb_dequeue(&sta->ps_tx_buf);
+		if (skb_queue_len(&sta->ps_tx_buf[ac]) >= STA_MAX_TX_BUFFER) {
+			struct sk_buff *old = skb_dequeue(&sta->ps_tx_buf[ac]);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-			if (net_ratelimit()) {
-				printk(KERN_DEBUG "%s: STA %pM TX "
-				       "buffer full - dropping oldest frame\n",
-				       tx->sdata->name, sta->sta.addr);
-			}
+			if (net_ratelimit())
+				printk(KERN_DEBUG "%s: STA %pM TX buffer for "
+				       "AC %d full - dropping oldest frame\n",
+				       tx->sdata->name, sta->sta.addr, ac);
 #endif
 			dev_kfree_skb(old);
 		} else
@@ -472,7 +480,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		info->control.jiffies = jiffies;
 		info->control.vif = &tx->sdata->vif;
 		info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
-		skb_queue_tail(&sta->ps_tx_buf, tx->skb);
+		skb_queue_tail(&sta->ps_tx_buf[ac], tx->skb);
 
 		if (!timer_pending(&local->sta_cleanup))
 			mod_timer(&local->sta_cleanup,


