Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60352 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbYBTSa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:30:57 -0500
Subject: [PATCH] mac80211: consolidate TIM handling code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 11:21:35 +0100
Message-Id: <1203502895.17534.10.camel@johannes.berg> (sfid-20080220_183100_914676_3CEBA9BC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This consolidates all TIM handling code to avoid re-introducing
errors with the bitmap/set_tim order and to reduce code. While
reading the code I noticed a possible problem so I also added
a comment about that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Module binary size on powerpc is reduced by 159 bytes :)

Anybody have comments on the FIXME comment?

 net/mac80211/ieee80211_i.h |   36 ------------------
 net/mac80211/rx.c          |   29 +++++++--------
 net/mac80211/sta_info.c    |   87 +++++++++++++++++++++++++++++++--------------
 net/mac80211/sta_info.h    |    4 +-
 net/mac80211/tx.c          |   11 ++---
 5 files changed, 84 insertions(+), 83 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-02-20 10:44:40.000000000 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-02-20 11:04:58.000000000 +0100
@@ -207,7 +207,7 @@ struct ieee80211_if_ap {
 
 	/* yes, this looks ugly, but guarantees that we can later use
 	 * bitmap_empty :)
-	 * NB: don't ever use set_bit, use bss_tim_set/bss_tim_clear! */
+	 * NB: don't touch this bitmap, use sta_info_{set,clear}_tim_bit */
 	u8 tim[sizeof(unsigned long) * BITS_TO_LONGS(IEEE80211_MAX_AID + 1)];
 	atomic_t num_sta_ps; /* number of stations in PS mode */
 	struct sk_buff_head ps_bc_buf;
@@ -640,40 +640,6 @@ struct sta_attribute {
 	ssize_t (*store)(struct sta_info *, const char *buf, size_t count);
 };
 
-static inline void __bss_tim_set(struct ieee80211_if_ap *bss, u16 aid)
-{
-	/*
-	 * This format has been mandated by the IEEE specifications,
-	 * so this line may not be changed to use the __set_bit() format.
-	 */
-	bss->tim[aid / 8] |= (1 << (aid % 8));
-}
-
-static inline void bss_tim_set(struct ieee80211_local *local,
-			       struct ieee80211_if_ap *bss, u16 aid)
-{
-	read_lock_bh(&local->sta_lock);
-	__bss_tim_set(bss, aid);
-	read_unlock_bh(&local->sta_lock);
-}
-
-static inline void __bss_tim_clear(struct ieee80211_if_ap *bss, u16 aid)
-{
-	/*
-	 * This format has been mandated by the IEEE specifications,
-	 * so this line may not be changed to use the __clear_bit() format.
-	 */
-	bss->tim[aid / 8] &= ~(1 << (aid % 8));
-}
-
-static inline void bss_tim_clear(struct ieee80211_local *local,
-				 struct ieee80211_if_ap *bss, u16 aid)
-{
-	read_lock_bh(&local->sta_lock);
-	__bss_tim_clear(bss, aid);
-	read_unlock_bh(&local->sta_lock);
-}
-
 static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
 {
 	return compare_ether_addr(raddr, addr) == 0 ||
--- everything.orig/net/mac80211/sta_info.c	2008-02-20 10:46:49.000000000 +0100
+++ everything/net/mac80211/sta_info.c	2008-02-20 11:09:22.000000000 +0100
@@ -191,6 +191,64 @@ struct sta_info * sta_info_add(struct ie
 	return sta;
 }
 
+static inline void __bss_tim_set(struct ieee80211_if_ap *bss, u16 aid)
+{
+	/*
+	 * This format has been mandated by the IEEE specifications,
+	 * so this line may not be changed to use the __set_bit() format.
+	 */
+	bss->tim[aid / 8] |= (1 << (aid % 8));
+}
+
+static inline void __bss_tim_clear(struct ieee80211_if_ap *bss, u16 aid)
+{
+	/*
+	 * This format has been mandated by the IEEE specifications,
+	 * so this line may not be changed to use the __clear_bit() format.
+	 */
+	bss->tim[aid / 8] &= ~(1 << (aid % 8));
+}
+
+static void __sta_info_set_tim_bit(struct ieee80211_if_ap *bss,
+				   struct sta_info *sta)
+{
+	if (bss)
+		__bss_tim_set(bss, sta->aid);
+	if (sta->local->ops->set_tim)
+		sta->local->ops->set_tim(local_to_hw(sta->local), sta->aid, 1);
+}
+
+void sta_info_set_tim_bit(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+
+	read_lock_bh(&sta->local->sta_lock);
+	__sta_info_set_tim_bit(sdata->bss, sta);
+	read_unlock_bh(&sta->local->sta_lock);
+}
+
+static void __sta_info_clear_tim_bit(struct ieee80211_if_ap *bss,
+				     struct sta_info *sta)
+{
+	if (bss)
+		__bss_tim_clear(bss, sta->aid);
+	if (sta->local->ops->set_tim)
+		sta->local->ops->set_tim(local_to_hw(sta->local), sta->aid, 0);
+}
+
+void sta_info_clear_tim_bit(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+
+	read_lock_bh(&sta->local->sta_lock);
+	__sta_info_clear_tim_bit(sdata->bss, sta);
+	read_unlock_bh(&sta->local->sta_lock);
+}
+
 /* Caller must hold local->sta_lock */
 void sta_info_remove(struct sta_info *sta)
 {
@@ -207,10 +265,9 @@ void sta_info_remove(struct sta_info *st
 		sta->flags &= ~WLAN_STA_PS;
 		if (sdata->bss)
 			atomic_dec(&sdata->bss->num_sta_ps);
+		__sta_info_clear_tim_bit(sdata->bss, sta);
 	}
 	local->num_sta--;
-	sta_info_remove_aid_ptr(sta);
-
 }
 
 void sta_info_free(struct sta_info *sta)
@@ -310,13 +367,8 @@ static void sta_info_cleanup_expire_buff
 		       "%s)\n", print_mac(mac, sta->addr));
 		dev_kfree_skb(skb);
 
-		if (skb_queue_empty(&sta->ps_tx_buf)) {
-			if (sdata->bss)
-				bss_tim_set(sta->local, sdata->bss, sta->aid);
-			if (sta->local->ops->set_tim)
-				sta->local->ops->set_tim(local_to_hw(sta->local),
-							 sta->aid, 0);
-		}
+		if (skb_queue_empty(&sta->ps_tx_buf))
+			sta_info_clear_tim_bit(sta);
 	}
 }
 
@@ -395,23 +447,6 @@ void sta_info_stop(struct ieee80211_loca
 	sta_info_flush(local, NULL);
 }
 
-void sta_info_remove_aid_ptr(struct sta_info *sta)
-{
-	struct ieee80211_sub_if_data *sdata;
-
-	if (sta->aid <= 0)
-		return;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
-
-	if (sdata->bss)
-		__bss_tim_clear(sdata->bss, sta->aid);
-	if (sdata->local->ops->set_tim)
-		sdata->local->ops->set_tim(local_to_hw(sdata->local),
-					  sta->aid, 0);
-}
-
-
 /**
  * sta_info_flush - flush matching STA entries from the STA table
  * @local: local interface data
--- everything.orig/net/mac80211/sta_info.h	2008-02-20 10:45:37.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-20 10:58:29.000000000 +0100
@@ -244,7 +244,9 @@ void sta_info_free(struct sta_info *sta)
 void sta_info_init(struct ieee80211_local *local);
 int sta_info_start(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
-void sta_info_remove_aid_ptr(struct sta_info *sta);
 void sta_info_flush(struct ieee80211_local *local, struct net_device *dev);
 
+void sta_info_set_tim_bit(struct sta_info *sta);
+void sta_info_clear_tim_bit(struct sta_info *sta);
+
 #endif /* STA_INFO_H */
--- everything.orig/net/mac80211/rx.c	2008-02-20 10:59:28.000000000 +0100
+++ everything/net/mac80211/rx.c	2008-02-20 11:02:11.000000000 +0100
@@ -595,19 +595,20 @@ static int ap_sta_ps_end(struct net_devi
 	DECLARE_MAC_BUF(mac);
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+
 	if (sdata->bss)
 		atomic_dec(&sdata->bss->num_sta_ps);
+
 	sta->flags &= ~(WLAN_STA_PS | WLAN_STA_PSPOLL);
-	if (!skb_queue_empty(&sta->ps_tx_buf)) {
-		if (sdata->bss)
-			bss_tim_clear(local, sdata->bss, sta->aid);
-		if (local->ops->set_tim)
-			local->ops->set_tim(local_to_hw(local), sta->aid, 0);
-	}
+
+	if (!skb_queue_empty(&sta->ps_tx_buf))
+		sta_info_clear_tim_bit(sta);
+
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d exits power save mode\n",
 	       dev->name, print_mac(mac, sta->addr), sta->aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
+
 	/* Send all buffered frames to the station */
 	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
 		pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
@@ -944,20 +945,20 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 
 		dev_queue_xmit(skb);
 
-		if (no_pending_pkts) {
-			if (rx->sdata->bss)
-				bss_tim_clear(rx->local, rx->sdata->bss, rx->sta->aid);
-			if (rx->local->ops->set_tim)
-				rx->local->ops->set_tim(local_to_hw(rx->local),
-						       rx->sta->aid, 0);
-		}
+		if (no_pending_pkts)
+			sta_info_clear_tim_bit(rx->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	} else if (!rx->u.rx.sent_ps_buffered) {
+		/*
+		 * FIXME: This can be the result of a race condition between
+		 *	  us expiring a frame and the station polling for it.
+		 *	  Should we send it a null-func frame indicating we
+		 *	  have nothing buffered for it?
+		 */
 		printk(KERN_DEBUG "%s: STA %s sent PS Poll even "
 		       "though there is no buffered frames for it\n",
 		       rx->dev->name, print_mac(mac, rx->sta->addr));
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-
 	}
 
 	/* Free PS Poll skb here instead of returning RX_DROP that would
--- everything.orig/net/mac80211/tx.c	2008-02-20 11:02:32.000000000 +0100
+++ everything/net/mac80211/tx.c	2008-02-20 11:03:04.000000000 +0100
@@ -416,14 +416,11 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 			dev_kfree_skb(old);
 		} else
 			tx->local->total_ps_buffered++;
+
 		/* Queue frame to be sent after STA sends an PS Poll frame */
-		if (skb_queue_empty(&sta->ps_tx_buf)) {
-			if (tx->sdata->bss)
-				bss_tim_set(tx->local, tx->sdata->bss, sta->aid);
-			if (tx->local->ops->set_tim)
-				tx->local->ops->set_tim(local_to_hw(tx->local),
-						       sta->aid, 1);
-		}
+		if (skb_queue_empty(&sta->ps_tx_buf))
+			sta_info_set_tim_bit(sta);
+
 		pkt_data = (struct ieee80211_tx_packet_data *)tx->skb->cb;
 		pkt_data->jiffies = jiffies;
 		skb_queue_tail(&sta->ps_tx_buf, tx->skb);


