Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49598 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbZKFKfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 05:35:54 -0500
Subject: [PATCH] mac80211: async station powersave handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Nov 2009 11:35:50 +0100
Message-ID: <1257503750.29454.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices require that all frames to a station
are flushed when that station goes into powersave
mode before being able to send frames to that
station again when it wakes up or polls -- all in
order to avoid reordering and too many or too few
frames being sent to the station when it polls.

Normally, this is the case unless the station
goes to sleep and wakes up very quickly again.
But in that case, frames for it may be pending
on the hardware queues, and thus races could
happen in the case of multiple hardware queues
used for QoS/WMM. Normally this isn't a problem,
but with the iwlwifi mechanism we need to make
sure the race doesn't happen.

This makes mac80211 able to cope with the race
with driver help by a new WLAN_STA_PS_DRIVER
per-station flag that can be controlled by the
driver and tells mac80211 whether it can transmit
frames or not. This flag must be set according to
very specific rules outlined in the documentation
for the function that controls it.

When we buffer new frames for the station, we
normally set the TIM bit right away, but while
the driver has blocked transmission to that sta
we need to avoid that as well since we cannot
respond to the station if it wakes up due to the
TIM bit. Once the driver unblocks, we can set
the TIM bit.

Similarly, when the station just wakes up, we
need to wait until all other frames are flushed
before we can transmit frames to that station,
so the same applies here, we need to wait for
the driver to give the OK.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/mac80211.h     |   32 ++++++++++++
 net/mac80211/debugfs_sta.c |    5 +
 net/mac80211/main.c        |    8 +--
 net/mac80211/rx.c          |   86 +++++---------------------------
 net/mac80211/sta_info.c    |  118 ++++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.h    |   23 +++++++-
 net/mac80211/tx.c          |   13 +++-
 7 files changed, 200 insertions(+), 85 deletions(-)

--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2009-11-06 11:34:24.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_sta.c	2009-11-06 11:34:30.000000000 +0100
@@ -66,10 +66,11 @@ static ssize_t sta_flags_read(struct fil
 	char buf[100];
 	struct sta_info *sta = file->private_data;
 	u32 staflags = get_sta_flags(sta);
-	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s%s",
+	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s%s%s",
 		staflags & WLAN_STA_AUTH ? "AUTH\n" : "",
 		staflags & WLAN_STA_ASSOC ? "ASSOC\n" : "",
-		staflags & WLAN_STA_PS ? "PS\n" : "",
+		staflags & WLAN_STA_PS_STA ? "PS (sta)\n" : "",
+		staflags & WLAN_STA_PS_DRIVER ? "PS (driver)\n" : "",
 		staflags & WLAN_STA_AUTHORIZED ? "AUTHORIZED\n" : "",
 		staflags & WLAN_STA_SHORT_PREAMBLE ? "SHORT PREAMBLE\n" : "",
 		staflags & WLAN_STA_WME ? "WME\n" : "",
--- wireless-testing.orig/net/mac80211/main.c	2009-11-06 11:34:25.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-11-06 11:34:30.000000000 +0100
@@ -385,13 +385,13 @@ static void ieee80211_handle_filtered_fr
 	 *      can be unknown, for example with different interrupt status
 	 *	bits.
 	 */
-	if (test_sta_flags(sta, WLAN_STA_PS) &&
+	if (test_sta_flags(sta, WLAN_STA_PS_STA) &&
 	    skb_queue_len(&sta->tx_filtered) < STA_MAX_TX_BUFFER) {
 		skb_queue_tail(&sta->tx_filtered, skb);
 		return;
 	}
 
-	if (!test_sta_flags(sta, WLAN_STA_PS) &&
+	if (!test_sta_flags(sta, WLAN_STA_PS_STA) &&
 	    !(info->flags & IEEE80211_TX_INTFL_RETRIED)) {
 		/* Software retry the packet once */
 		info->flags |= IEEE80211_TX_INTFL_RETRIED;
@@ -406,7 +406,7 @@ static void ieee80211_handle_filtered_fr
 		       "queue_len=%d PS=%d @%lu\n",
 		       wiphy_name(local->hw.wiphy),
 		       skb_queue_len(&sta->tx_filtered),
-		       !!test_sta_flags(sta, WLAN_STA_PS), jiffies);
+		       !!test_sta_flags(sta, WLAN_STA_PS_STA), jiffies);
 #endif
 	dev_kfree_skb(skb);
 }
@@ -446,7 +446,7 @@ void ieee80211_tx_status(struct ieee8021
 
 	if (sta) {
 		if (!(info->flags & IEEE80211_TX_STAT_ACK) &&
-		    test_sta_flags(sta, WLAN_STA_PS)) {
+		    test_sta_flags(sta, WLAN_STA_PS_STA)) {
 			/*
 			 * The STA is in power save mode, so assume
 			 * that this TX packet failed because of that.
--- wireless-testing.orig/net/mac80211/rx.c	2009-11-06 11:34:24.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-11-06 11:34:30.000000000 +0100
@@ -781,7 +781,7 @@ static void ap_sta_ps_start(struct sta_i
 	struct ieee80211_local *local = sdata->local;
 
 	atomic_inc(&sdata->bss->num_sta_ps);
-	set_sta_flags(sta, WLAN_STA_PS);
+	set_sta_flags(sta, WLAN_STA_PS_STA);
 	drv_sta_notify(local, &sdata->vif, STA_NOTIFY_SLEEP, &sta->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %pM aid %d enters power save mode\n",
@@ -792,33 +792,25 @@ static void ap_sta_ps_start(struct sta_i
 static void ap_sta_ps_end(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct ieee80211_local *local = sdata->local;
-	int sent, buffered;
 
 	atomic_dec(&sdata->bss->num_sta_ps);
 
-	clear_sta_flags(sta, WLAN_STA_PS);
-	drv_sta_notify(local, &sdata->vif, STA_NOTIFY_AWAKE, &sta->sta);
-
-	if (!skb_queue_empty(&sta->ps_tx_buf))
-		sta_info_clear_tim_bit(sta);
+	clear_sta_flags(sta, WLAN_STA_PS_STA);
 
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %pM aid %d exits power save mode\n",
 	       sdata->dev->name, sta->sta.addr, sta->sta.aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
 
-	/* Send all buffered frames to the station */
-	sent = ieee80211_add_pending_skbs(local, &sta->tx_filtered);
-	buffered = ieee80211_add_pending_skbs(local, &sta->ps_tx_buf);
-	sent += buffered;
-	local->total_ps_buffered -= buffered;
-
+	if (test_sta_flags(sta, WLAN_STA_PS_DRIVER)) {
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-	printk(KERN_DEBUG "%s: STA %pM aid %d sending %d filtered/%d PS frames "
-	       "since STA not sleeping anymore\n", sdata->dev->name,
-	       sta->sta.addr, sta->sta.aid, sent - buffered, buffered);
+		printk(KERN_DEBUG "%s: STA %pM aid %d driver-ps-blocked\n",
+		       sdata->dev->name, sta->sta.addr, sta->sta.aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+		return;
+	}
+
+	ieee80211_sta_ps_deliver_wakeup(sta);
 }
 
 static ieee80211_rx_result debug_noinline
@@ -866,7 +858,7 @@ ieee80211_rx_h_sta_process(struct ieee80
 	if (!ieee80211_has_morefrags(hdr->frame_control) &&
 	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
 	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {
-		if (test_sta_flags(sta, WLAN_STA_PS)) {
+		if (test_sta_flags(sta, WLAN_STA_PS_STA)) {
 			/*
 			 * Ignore doze->wake transitions that are
 			 * indicated by non-data frames, the standard
@@ -1094,9 +1086,7 @@ ieee80211_rx_h_defragment(struct ieee802
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_ps_poll(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
-	struct sk_buff *skb;
-	int no_pending_pkts;
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	__le16 fc = ((struct ieee80211_hdr *)rx->skb->data)->frame_control;
 
 	if (likely(!rx->sta || !ieee80211_is_pspoll(fc) ||
@@ -1107,56 +1097,10 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 	    (sdata->vif.type != NL80211_IFTYPE_AP_VLAN))
 		return RX_DROP_UNUSABLE;
 
-	skb = skb_dequeue(&rx->sta->tx_filtered);
-	if (!skb) {
-		skb = skb_dequeue(&rx->sta->ps_tx_buf);
-		if (skb)
-			rx->local->total_ps_buffered--;
-	}
-	no_pending_pkts = skb_queue_empty(&rx->sta->tx_filtered) &&
-		skb_queue_empty(&rx->sta->ps_tx_buf);
-
-	if (skb) {
-		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-		struct ieee80211_hdr *hdr =
-			(struct ieee80211_hdr *) skb->data;
-
-		/*
-		 * Tell TX path to send this frame even though the STA may
-		 * still remain is PS mode after this frame exchange.
-		 */
-		info->flags |= IEEE80211_TX_CTL_PSPOLL_RESPONSE;
-
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-		printk(KERN_DEBUG "STA %pM aid %d: PS Poll (entries after %d)\n",
-		       rx->sta->sta.addr, rx->sta->sta.aid,
-		       skb_queue_len(&rx->sta->ps_tx_buf));
-#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-
-		/* Use MoreData flag to indicate whether there are more
-		 * buffered frames for this STA */
-		if (no_pending_pkts)
-			hdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
-		else
-			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
-
-		ieee80211_add_pending_skb(rx->local, skb);
-
-		if (no_pending_pkts)
-			sta_info_clear_tim_bit(rx->sta);
-#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-	} else {
-		/*
-		 * FIXME: This can be the result of a race condition between
-		 *	  us expiring a frame and the station polling for it.
-		 *	  Should we send it a null-func frame indicating we
-		 *	  have nothing buffered for it?
-		 */
-		printk(KERN_DEBUG "%s: STA %pM sent PS Poll even "
-		       "though there are no buffered frames for it\n",
-		       rx->dev->name, rx->sta->sta.addr);
-#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-	}
+	if (!test_sta_flags(rx->sta, WLAN_STA_PS_DRIVER))
+		ieee80211_sta_ps_deliver_poll_response(rx->sta);
+	else
+		set_sta_flags(rx->sta, WLAN_STA_PSPOLL);
 
 	/* Free PS Poll skb here instead of returning RX_DROP that would
 	 * count as an dropped frame. */
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-11-06 11:34:24.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-11-06 11:34:30.000000000 +0100
@@ -173,6 +173,8 @@ void sta_info_destroy(struct sta_info *s
 
 	local = sta->local;
 
+	cancel_work_sync(&sta->drv_unblock_wk);
+
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
 
@@ -278,6 +280,21 @@ static int sta_prepare_rate_control(stru
 	return 0;
 }
 
+static void sta_unblock(struct work_struct *wk)
+{
+	struct sta_info *sta;
+
+	sta = container_of(wk, struct sta_info, drv_unblock_wk);
+
+	if (sta->dead)
+		return;
+
+	if (!test_sta_flags(sta, WLAN_STA_PS_STA))
+		ieee80211_sta_ps_deliver_wakeup(sta);
+	else if (test_and_clear_sta_flags(sta, WLAN_STA_PSPOLL))
+		ieee80211_sta_ps_deliver_poll_response(sta);
+}
+
 struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 				u8 *addr, gfp_t gfp)
 {
@@ -291,6 +308,7 @@ struct sta_info *sta_info_alloc(struct i
 
 	spin_lock_init(&sta->lock);
 	spin_lock_init(&sta->flaglock);
+	INIT_WORK(&sta->drv_unblock_wk, sta_unblock);
 
 	memcpy(sta->sta.addr, addr, ETH_ALEN);
 	sta->local = local;
@@ -493,8 +511,10 @@ static void __sta_info_unlink(struct sta
 	}
 
 	list_del(&(*sta)->list);
+	(*sta)->dead = true;
 
-	if (test_and_clear_sta_flags(*sta, WLAN_STA_PS)) {
+	if (test_and_clear_sta_flags(*sta,
+				WLAN_STA_PS_STA | WLAN_STA_PS_DRIVER)) {
 		BUG_ON(!sdata->bss);
 
 		atomic_dec(&sdata->bss->num_sta_ps);
@@ -840,3 +860,99 @@ struct ieee80211_sta *ieee80211_find_sta
 	return ieee80211_find_sta_by_hw(&sdata->local->hw, addr);
 }
 EXPORT_SYMBOL(ieee80211_find_sta);
+
+/* powersave support code */
+void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+	int sent, buffered;
+
+	drv_sta_notify(local, &sdata->vif, STA_NOTIFY_AWAKE, &sta->sta);
+
+	if (!skb_queue_empty(&sta->ps_tx_buf))
+		sta_info_clear_tim_bit(sta);
+
+	/* Send all buffered frames to the station */
+	sent = ieee80211_add_pending_skbs(local, &sta->tx_filtered);
+	buffered = ieee80211_add_pending_skbs(local, &sta->ps_tx_buf);
+	sent += buffered;
+	local->total_ps_buffered -= buffered;
+
+#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
+	printk(KERN_DEBUG "%s: STA %pM aid %d sending %d filtered/%d PS frames "
+	       "since STA not sleeping anymore\n", sdata->dev->name,
+	       sta->sta.addr, sta->sta.aid, sent - buffered, buffered);
+#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+}
+
+void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	int no_pending_pkts;
+
+	skb = skb_dequeue(&sta->tx_filtered);
+	if (!skb) {
+		skb = skb_dequeue(&sta->ps_tx_buf);
+		if (skb)
+			local->total_ps_buffered--;
+	}
+	no_pending_pkts = skb_queue_empty(&sta->tx_filtered) &&
+		skb_queue_empty(&sta->ps_tx_buf);
+
+	if (skb) {
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+		struct ieee80211_hdr *hdr =
+			(struct ieee80211_hdr *) skb->data;
+
+		/*
+		 * Tell TX path to send this frame even though the STA may
+		 * still remain is PS mode after this frame exchange.
+		 */
+		info->flags |= IEEE80211_TX_CTL_PSPOLL_RESPONSE;
+
+#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
+		printk(KERN_DEBUG "STA %pM aid %d: PS Poll (entries after %d)\n",
+		       sta->sta.addr, sta->sta.aid,
+		       skb_queue_len(&sta->ps_tx_buf));
+#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+
+		/* Use MoreData flag to indicate whether there are more
+		 * buffered frames for this STA */
+		if (no_pending_pkts)
+			hdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
+		else
+			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+
+		ieee80211_add_pending_skb(local, skb);
+
+		if (no_pending_pkts)
+			sta_info_clear_tim_bit(sta);
+#ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
+	} else {
+		/*
+		 * FIXME: This can be the result of a race condition between
+		 *	  us expiring a frame and the station polling for it.
+		 *	  Should we send it a null-func frame indicating we
+		 *	  have nothing buffered for it?
+		 */
+		printk(KERN_DEBUG "%s: STA %pM sent PS Poll even "
+		       "though there are no buffered frames for it\n",
+		       sdata->dev->name, sta->sta.addr);
+#endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+	}
+}
+
+void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
+			       struct ieee80211_sta *pubsta, bool block)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+
+	if (block)
+		set_sta_flags(sta, WLAN_STA_PS_DRIVER);
+	else
+		ieee80211_queue_work(hw, &sta->drv_unblock_wk);
+}
+EXPORT_SYMBOL(ieee80211_sta_block_awake);
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-11-06 11:34:24.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-11-06 11:34:30.000000000 +0100
@@ -12,6 +12,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
+#include <linux/workqueue.h>
 #include "key.h"
 
 /**
@@ -21,7 +22,7 @@
  *
  * @WLAN_STA_AUTH: Station is authenticated.
  * @WLAN_STA_ASSOC: Station is associated.
- * @WLAN_STA_PS: Station is in power-save mode
+ * @WLAN_STA_PS_STA: Station is in power-save mode
  * @WLAN_STA_AUTHORIZED: Station is authorized to send/receive traffic.
  *	This bit is always checked so needs to be enabled for all stations
  *	when virtual port control is not in use.
@@ -36,11 +37,16 @@
  * @WLAN_STA_MFP: Management frame protection is used with this STA.
  * @WLAN_STA_SUSPEND: Set/cleared during a suspend/resume cycle.
  *	Used to deny ADDBA requests (both TX and RX).
+ * @WLAN_STA_PS_DRIVER: driver requires keeping this station in
+ *	power-save mode logically to flush frames that might still
+ *	be in the queues
+ * @WLAN_STA_PSPOLL: Station sent PS-poll while driver was keeping
+ *	station in power-save mode, reply when the driver unblocks.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
 	WLAN_STA_ASSOC		= 1<<1,
-	WLAN_STA_PS		= 1<<2,
+	WLAN_STA_PS_STA		= 1<<2,
 	WLAN_STA_AUTHORIZED	= 1<<3,
 	WLAN_STA_SHORT_PREAMBLE	= 1<<4,
 	WLAN_STA_ASSOC_AP	= 1<<5,
@@ -48,7 +54,9 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_WDS		= 1<<7,
 	WLAN_STA_CLEAR_PS_FILT	= 1<<9,
 	WLAN_STA_MFP		= 1<<10,
-	WLAN_STA_SUSPEND	= 1<<11
+	WLAN_STA_SUSPEND	= 1<<11,
+	WLAN_STA_PS_DRIVER	= 1<<12,
+	WLAN_STA_PSPOLL		= 1<<13,
 };
 
 #define STA_TID_NUM 16
@@ -216,6 +224,8 @@ struct sta_ampdu_mlme {
  * @plink_timer_was_running: used by suspend/resume to restore timers
  * @debugfs: debug filesystem info
  * @sta: station information we share with the driver
+ * @dead: set to true when sta is unlinked
+ * @drv_unblock_wk used for driver PS unblocking
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -229,8 +239,12 @@ struct sta_info {
 	spinlock_t lock;
 	spinlock_t flaglock;
 
+	struct work_struct drv_unblock_wk;
+
 	u16 listen_interval;
 
+	bool dead;
+
 	/*
 	 * for use by the internal lifetime management,
 	 * see __sta_info_unlink
@@ -430,4 +444,7 @@ int sta_info_flush(struct ieee80211_loca
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
 
+void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
+void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta);
+
 #endif /* STA_INFO_H */
--- wireless-testing.orig/net/mac80211/tx.c	2009-11-06 11:34:24.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-11-06 11:34:30.000000000 +0100
@@ -374,7 +374,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 
 	staflags = get_sta_flags(sta);
 
-	if (unlikely((staflags & WLAN_STA_PS) &&
+	if (unlikely((staflags & (WLAN_STA_PS_STA | WLAN_STA_PS_DRIVER)) &&
 		     !(info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE))) {
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "STA %pM aid %d: PS buffer (entries "
@@ -397,8 +397,13 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		} else
 			tx->local->total_ps_buffered++;
 
-		/* Queue frame to be sent after STA sends an PS Poll frame */
-		if (skb_queue_empty(&sta->ps_tx_buf))
+		/*
+		 * Queue frame to be sent after STA wakes up/polls,
+		 * but don't set the TIM bit if the driver is blocking
+		 * wakeup or poll response transmissions anyway.
+		 */
+		if (skb_queue_empty(&sta->ps_tx_buf) &&
+		    !(staflags & WLAN_STA_PS_DRIVER))
 			sta_info_set_tim_bit(sta);
 
 		info->control.jiffies = jiffies;
@@ -408,7 +413,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		return TX_QUEUED;
 	}
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
-	else if (unlikely(test_sta_flags(sta, WLAN_STA_PS))) {
+	else if (unlikely(staflags & WLAN_STA_PS_STA)) {
 		printk(KERN_DEBUG "%s: STA %pM in PS mode, but pspoll "
 		       "set -> send frame\n", tx->dev->name,
 		       sta->sta.addr);
--- wireless-testing.orig/include/net/mac80211.h	2009-11-06 11:34:25.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-11-06 11:34:30.000000000 +0100
@@ -2151,6 +2151,38 @@ struct ieee80211_sta *ieee80211_find_sta
 					       const u8 *addr);
 
 /**
+ * ieee80211_sta_block_awake - block station from waking up
+ * @hw: the hardware
+ * @pubsta: the station
+ * @block: whether to block or unblock
+ *
+ * Some devices require that all frames that are on the queues
+ * for a specific station that went to sleep are flushed before
+ * a poll response or frames after the station woke up can be
+ * delivered to that it. Note that such frames must be rejected
+ * by the driver as filtered, with the appropriate status flag.
+ *
+ * This function allows implementing this mode in a race-free
+ * manner.
+ *
+ * To do this, a driver must keep track of the number of frames
+ * still enqueued for a specific station. If this number is not
+ * zero when the station goes to sleep, the driver must call
+ * this function to force mac80211 to consider the station to
+ * be asleep regardless of the station's actual state. Once the
+ * number of outstanding frames reaches zero, the driver must
+ * call this function again to unblock the station. That will
+ * cause mac80211 to be able to send ps-poll responses, and if
+ * the station queried in the meantime then frames will also
+ * be sent out as a result of this. Additionally, the driver
+ * will be notified that the station woke up some time after
+ * it is unblocked, regardless of whether the station actually
+ * woke up while blocked or not.
+ */
+void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
+			       struct ieee80211_sta *pubsta, bool block);
+
+/**
  * ieee80211_beacon_loss - inform hardware does not receive beacons
  *
  * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.


