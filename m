Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60485 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbYBTS0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:26:34 -0500
Subject: [PATCH] mac80211: invoke set_tim() callback after setting own TIM
	info
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 01:36:16 +0100
Message-Id: <1203467776.10983.1.camel@johannes.berg> (sfid-20080220_182640_458493_436B888E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers should be allowed to simply get a complete new beacon when
set_tim() is invoked (and set_tim() is required for drivers that
just want a beacon template!), so we need to update our own TIM
bitmap before calling set_tim() so that getting the beacon will
now get an already updated beacon.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c       |    8 ++++----
 net/mac80211/sta_info.c |    4 ++--
 net/mac80211/tx.c       |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-02-20 01:21:39.000000000 +0100
+++ everything/net/mac80211/rx.c	2008-02-20 01:22:00.000000000 +0100
@@ -599,10 +599,10 @@ static int ap_sta_ps_end(struct net_devi
 		atomic_dec(&sdata->bss->num_sta_ps);
 	sta->flags &= ~(WLAN_STA_PS | WLAN_STA_TIM | WLAN_STA_PSPOLL);
 	if (!skb_queue_empty(&sta->ps_tx_buf)) {
-		if (local->ops->set_tim)
-			local->ops->set_tim(local_to_hw(local), sta->aid, 0);
 		if (sdata->bss)
 			bss_tim_clear(local, sdata->bss, sta->aid);
+		if (local->ops->set_tim)
+			local->ops->set_tim(local_to_hw(local), sta->aid, 0);
 	}
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d exits power save mode\n",
@@ -946,11 +946,11 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 		dev_queue_xmit(skb);
 
 		if (no_pending_pkts) {
+			if (rx->sdata->bss)
+				bss_tim_clear(rx->local, rx->sdata->bss, rx->sta->aid);
 			if (rx->local->ops->set_tim)
 				rx->local->ops->set_tim(local_to_hw(rx->local),
 						       rx->sta->aid, 0);
-			if (rx->sdata->bss)
-				bss_tim_clear(rx->local, rx->sdata->bss, rx->sta->aid);
 		}
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	} else if (!rx->u.rx.sent_ps_buffered) {
--- everything.orig/net/mac80211/sta_info.c	2008-02-20 01:22:04.000000000 +0100
+++ everything/net/mac80211/sta_info.c	2008-02-20 01:22:09.000000000 +0100
@@ -396,11 +396,11 @@ void sta_info_remove_aid_ptr(struct sta_
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 
+	if (sdata->bss)
+		__bss_tim_clear(sdata->bss, sta->aid);
 	if (sdata->local->ops->set_tim)
 		sdata->local->ops->set_tim(local_to_hw(sdata->local),
 					  sta->aid, 0);
-	if (sdata->bss)
-		__bss_tim_clear(sdata->bss, sta->aid);
 }
 
 
--- everything.orig/net/mac80211/tx.c	2008-02-20 01:22:12.000000000 +0100
+++ everything/net/mac80211/tx.c	2008-02-20 01:22:18.000000000 +0100
@@ -419,11 +419,11 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 			tx->local->total_ps_buffered++;
 		/* Queue frame to be sent after STA sends an PS Poll frame */
 		if (skb_queue_empty(&sta->ps_tx_buf)) {
+			if (tx->sdata->bss)
+				bss_tim_set(tx->local, tx->sdata->bss, sta->aid);
 			if (tx->local->ops->set_tim)
 				tx->local->ops->set_tim(local_to_hw(tx->local),
 						       sta->aid, 1);
-			if (tx->sdata->bss)
-				bss_tim_set(tx->local, tx->sdata->bss, sta->aid);
 		}
 		pkt_data = (struct ieee80211_tx_packet_data *)tx->skb->cb;
 		pkt_data->jiffies = jiffies;


