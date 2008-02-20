Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759145AbYBTSaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:30:11 -0500
Subject: [PATCH] mac80211: remove sta TIM flag, fix expiry TIM handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 02:07:21 +0100
Message-Id: <1203469641.10983.14.camel@johannes.berg> (sfid-20080220_183027_484133_5D3EEFAC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TIM flag that is kept in each station's info is completely
useless, there's no code (aside from the debugfs display code)
checking it, hence it can be removed. While doing that, I noticed
that the TIM handling is broken when buffered frames expire, so
fix that.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/debugfs_sta.c |    3 +--
 net/mac80211/rx.c          |    7 +++----
 net/mac80211/sta_info.c    |   28 ++++++++++++++++++----------
 net/mac80211/sta_info.h    |   14 ++++++--------
 net/mac80211/tx.c          |    1 -
 5 files changed, 28 insertions(+), 25 deletions(-)

--- everything.orig/net/mac80211/debugfs_sta.c	2008-02-20 01:51:32.000000000 +0100
+++ everything/net/mac80211/debugfs_sta.c	2008-02-20 01:51:38.000000000 +0100
@@ -74,11 +74,10 @@ static ssize_t sta_flags_read(struct fil
 {
 	char buf[100];
 	struct sta_info *sta = file->private_data;
-	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s%s",
+	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s",
 		sta->flags & WLAN_STA_AUTH ? "AUTH\n" : "",
 		sta->flags & WLAN_STA_ASSOC ? "ASSOC\n" : "",
 		sta->flags & WLAN_STA_PS ? "PS\n" : "",
-		sta->flags & WLAN_STA_TIM ? "TIM\n" : "",
 		sta->flags & WLAN_STA_AUTHORIZED ? "AUTHORIZED\n" : "",
 		sta->flags & WLAN_STA_SHORT_PREAMBLE ? "SHORT PREAMBLE\n" : "",
 		sta->flags & WLAN_STA_WME ? "WME\n" : "",
--- everything.orig/net/mac80211/rx.c	2008-02-20 01:51:55.000000000 +0100
+++ everything/net/mac80211/rx.c	2008-02-20 01:52:08.000000000 +0100
@@ -597,7 +597,7 @@ static int ap_sta_ps_end(struct net_devi
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 	if (sdata->bss)
 		atomic_dec(&sdata->bss->num_sta_ps);
-	sta->flags &= ~(WLAN_STA_PS | WLAN_STA_TIM | WLAN_STA_PSPOLL);
+	sta->flags &= ~(WLAN_STA_PS | WLAN_STA_PSPOLL);
 	if (!skb_queue_empty(&sta->ps_tx_buf)) {
 		if (sdata->bss)
 			bss_tim_clear(local, sdata->bss, sta->aid);
@@ -937,10 +937,9 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 
 		/* Use MoreData flag to indicate whether there are more
 		 * buffered frames for this STA */
-		if (no_pending_pkts) {
+		if (no_pending_pkts)
 			hdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
-			rx->sta->flags &= ~WLAN_STA_TIM;
-		} else
+		else
 			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 
 		dev_queue_xmit(skb);
--- everything.orig/net/mac80211/sta_info.c	2008-02-20 01:52:32.000000000 +0100
+++ everything/net/mac80211/sta_info.c	2008-02-20 01:58:44.000000000 +0100
@@ -286,6 +286,7 @@ static void sta_info_cleanup_expire_buff
 {
 	unsigned long flags;
 	struct sk_buff *skb;
+	struct ieee80211_sub_if_data *sdata;
 	DECLARE_MAC_BUF(mac);
 
 	if (skb_queue_empty(&sta->ps_tx_buf))
@@ -294,21 +295,28 @@ static void sta_info_cleanup_expire_buff
 	for (;;) {
 		spin_lock_irqsave(&sta->ps_tx_buf.lock, flags);
 		skb = skb_peek(&sta->ps_tx_buf);
-		if (sta_info_buffer_expired(local, sta, skb)) {
+		if (sta_info_buffer_expired(local, sta, skb))
 			skb = __skb_dequeue(&sta->ps_tx_buf);
-			if (skb_queue_empty(&sta->ps_tx_buf))
-				sta->flags &= ~WLAN_STA_TIM;
-		} else
+		else
 			skb = NULL;
 		spin_unlock_irqrestore(&sta->ps_tx_buf.lock, flags);
 
-		if (skb) {
-			local->total_ps_buffered--;
-			printk(KERN_DEBUG "Buffered frame expired (STA "
-			       "%s)\n", print_mac(mac, sta->addr));
-			dev_kfree_skb(skb);
-		} else
+		if (!skb)
 			break;
+
+		sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+		local->total_ps_buffered--;
+		printk(KERN_DEBUG "Buffered frame expired (STA "
+		       "%s)\n", print_mac(mac, sta->addr));
+		dev_kfree_skb(skb);
+
+		if (skb_queue_empty(&sta->ps_tx_buf)) {
+			if (sdata->bss)
+				bss_tim_set(sta->local, sdata->bss, sta->aid);
+			if (sta->local->ops->set_tim)
+				sta->local->ops->set_tim(local_to_hw(sta->local),
+							 sta->aid, 0);
+		}
 	}
 }
 
--- everything.orig/net/mac80211/sta_info.h	2008-02-20 01:51:43.000000000 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-20 01:51:50.000000000 +0100
@@ -23,7 +23,6 @@
  * @WLAN_STA_AUTH: Station is authenticated.
  * @WLAN_STA_ASSOC: Station is associated.
  * @WLAN_STA_PS: Station is in power-save mode
- * @WLAN_STA_TIM: TIM bit is on for this PS station (traffic buffered)
  * @WLAN_STA_AUTHORIZED: Station is authorized to send/receive traffic.
  *	This bit is always checked so needs to be enabled for all stations
  *	when virtual port control is not in use.
@@ -38,13 +37,12 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
 	WLAN_STA_ASSOC		= 1<<1,
 	WLAN_STA_PS		= 1<<2,
-	WLAN_STA_TIM		= 1<<3,
-	WLAN_STA_AUTHORIZED	= 1<<4,
-	WLAN_STA_SHORT_PREAMBLE	= 1<<5,
-	WLAN_STA_ASSOC_AP	= 1<<6,
-	WLAN_STA_WME		= 1<<7,
-	WLAN_STA_WDS		= 1<<8,
-	WLAN_STA_PSPOLL		= 1<<9,
+	WLAN_STA_AUTHORIZED	= 1<<3,
+	WLAN_STA_SHORT_PREAMBLE	= 1<<4,
+	WLAN_STA_ASSOC_AP	= 1<<5,
+	WLAN_STA_WME		= 1<<6,
+	WLAN_STA_WDS		= 1<<7,
+	WLAN_STA_PSPOLL		= 1<<8,
 };
 
 #define STA_TID_NUM 16
--- everything.orig/net/mac80211/tx.c	2008-02-20 01:52:20.000000000 +0100
+++ everything/net/mac80211/tx.c	2008-02-20 01:52:27.000000000 +0100
@@ -404,7 +404,6 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		       print_mac(mac, sta->addr), sta->aid,
 		       skb_queue_len(&sta->ps_tx_buf));
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-		sta->flags |= WLAN_STA_TIM;
 		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
 			purge_old_ps_buffers(tx->local);
 		if (skb_queue_len(&sta->ps_tx_buf) >= STA_MAX_TX_BUFFER) {


