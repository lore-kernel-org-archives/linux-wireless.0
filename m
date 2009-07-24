Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZGXLYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 07:24:15 -0400
Subject: [PATCH] mac80211: fix PS-poll response, race
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	Christian Lamparter <chunkeey@web.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 13:23:09 +0200
Message-Id: <1248434589.9224.13.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a station queries us for a PS-poll response, we wrongly
queue the frame on the virtual interface's queue rather than
the pending queue.

Additionally, fix a race condition where we could potentially
send multiple frames to the sleeping station due to using a
station flag rather than a packet flag. When converting to a
packet flag, we can also convert p54 and remove the filter
clearing we added for it.

(Also remove a now dead function)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Reported-by: Bob Copeland <me@bobcopeland.com>
Tested-by: Bob Copeland <me@bobcopeland.com>
Cc: Christian Lamparter <chunkeey@web.de>
---
This seems to be fallout from the master netdev removal. Whichever tree
that is in now...

 drivers/net/wireless/p54/txrx.c |    2 +-
 include/net/mac80211.h          |    4 ++++
 net/mac80211/rx.c               |   11 ++++++-----
 net/mac80211/sta_info.h         |   13 -------------
 net/mac80211/tx.c               |   19 +------------------
 5 files changed, 12 insertions(+), 37 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-07-24 10:58:24.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-07-24 10:58:59.000000000 +0200
@@ -782,7 +782,7 @@ static void ap_sta_ps_start(struct sta_i
 	struct ieee80211_local *local = sdata->local;
 
 	atomic_inc(&sdata->bss->num_sta_ps);
-	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
+	set_sta_flags(sta, WLAN_STA_PS);
 	drv_sta_notify(local, &sdata->vif, STA_NOTIFY_SLEEP, &sta->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %pM aid %d enters power save mode\n",
@@ -798,7 +798,7 @@ static int ap_sta_ps_end(struct sta_info
 
 	atomic_dec(&sdata->bss->num_sta_ps);
 
-	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
+	clear_sta_flags(sta, WLAN_STA_PS);
 	drv_sta_notify(local, &sdata->vif, STA_NOTIFY_AWAKE, &sta->sta);
 
 	if (!skb_queue_empty(&sta->ps_tx_buf))
@@ -1116,14 +1116,15 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 		skb_queue_empty(&rx->sta->ps_tx_buf);
 
 	if (skb) {
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		struct ieee80211_hdr *hdr =
 			(struct ieee80211_hdr *) skb->data;
 
 		/*
-		 * Tell TX path to send one frame even though the STA may
+		 * Tell TX path to send this frame even though the STA may
 		 * still remain is PS mode after this frame exchange.
 		 */
-		set_sta_flags(rx->sta, WLAN_STA_PSPOLL);
+		info->flags |= IEEE80211_TX_CTL_PSPOLL_RESPONSE;
 
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "STA %pM aid %d: PS Poll (entries after %d)\n",
@@ -1138,7 +1139,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 		else
 			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 
-		dev_queue_xmit(skb);
+		ieee80211_add_pending_skb(rx->local, skb);
 
 		if (no_pending_pkts)
 			sta_info_clear_tim_bit(rx->sta);
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-07-24 10:58:04.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2009-07-24 10:59:28.000000000 +0200
@@ -30,7 +30,6 @@
  * @WLAN_STA_ASSOC_AP: We're associated to that station, it is an AP.
  * @WLAN_STA_WME: Station is a QoS-STA.
  * @WLAN_STA_WDS: Station is one of our WDS peers.
- * @WLAN_STA_PSPOLL: Station has just PS-polled us.
  * @WLAN_STA_CLEAR_PS_FILT: Clear PS filter in hardware (using the
  *	IEEE80211_TX_CTL_CLEAR_PS_FILT control flag) when the next
  *	frame to this station is transmitted.
@@ -47,7 +46,6 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_ASSOC_AP	= 1<<5,
 	WLAN_STA_WME		= 1<<6,
 	WLAN_STA_WDS		= 1<<7,
-	WLAN_STA_PSPOLL		= 1<<8,
 	WLAN_STA_CLEAR_PS_FILT	= 1<<9,
 	WLAN_STA_MFP		= 1<<10,
 	WLAN_STA_SUSPEND	= 1<<11
@@ -359,17 +357,6 @@ static inline void clear_sta_flags(struc
 	spin_unlock_irqrestore(&sta->flaglock, irqfl);
 }
 
-static inline void set_and_clear_sta_flags(struct sta_info *sta,
-					   const u32 set, const u32 clear)
-{
-	unsigned long irqfl;
-
-	spin_lock_irqsave(&sta->flaglock, irqfl);
-	sta->flags |= set;
-	sta->flags &= ~clear;
-	spin_unlock_irqrestore(&sta->flaglock, irqfl);
-}
-
 static inline u32 test_sta_flags(struct sta_info *sta, const u32 flags)
 {
 	u32 ret;
--- wireless-testing.orig/include/net/mac80211.h	2009-07-24 10:57:53.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2009-07-24 10:58:59.000000000 +0200
@@ -243,6 +243,9 @@ struct ieee80211_bss_conf {
  *	used to indicate that a frame was already retried due to PS
  * @IEEE80211_TX_INTFL_DONT_ENCRYPT: completely internal to mac80211,
  *	used to indicate frame should not be encrypted
+ * @IEEE80211_TX_CTL_PSPOLL_RESPONSE: (internal?)
+ *	This frame is a response to a PS-poll frame and should be sent
+ *	although the station is in powersave mode.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -262,6 +265,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(14),
 	IEEE80211_TX_INTFL_RETRIED		= BIT(15),
 	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(16),
+	IEEE80211_TX_CTL_PSPOLL_RESPONSE	= BIT(17),
 };
 
 /**
--- wireless-testing.orig/net/mac80211/tx.c	2009-07-24 10:58:24.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-07-24 11:05:23.000000000 +0200
@@ -373,7 +373,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 	staflags = get_sta_flags(sta);
 
 	if (unlikely((staflags & WLAN_STA_PS) &&
-		     !(staflags & WLAN_STA_PSPOLL))) {
+		     !(info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE))) {
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "STA %pM aid %d: PS buffer (entries "
 		       "before %d)\n",
@@ -412,24 +412,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		       sta->sta.addr);
 	}
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-	if (test_and_clear_sta_flags(sta, WLAN_STA_PSPOLL)) {
-		/*
-		 * The sleeping station with pending data is now snoozing.
-		 * It queried us for its buffered frames and will go back
-		 * to deep sleep once it got everything.
-		 *
-		 * inform the driver, in case the hardware does powersave
-		 * frame filtering and keeps a station  blacklist on its own
-		 * (e.g: p54), so that frames can be delivered unimpeded.
-		 *
-		 * Note: It should be safe to disable the filter now.
-		 * As, it is really unlikely that we still have any pending
-		 * frame for this station in the hw's buffers/fifos left,
-		 * that is not rejected with a unsuccessful tx_status yet.
-		 */
 
-		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
-	}
 	return TX_CONTINUE;
 }
 
--- wireless-testing.orig/drivers/net/wireless/p54/txrx.c	2009-07-24 11:05:09.000000000 +0200
+++ wireless-testing/drivers/net/wireless/p54/txrx.c	2009-07-24 11:05:17.000000000 +0200
@@ -614,7 +614,7 @@ static void p54_tx_80211_header(struct p
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
 		*flags |= P54_HDR_FLAG_DATA_OUT_SEQNR;
 
-	if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
+	if (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)
 		*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 
 	*queue = skb_get_queue_mapping(skb) + P54_QUEUE_DATA;


