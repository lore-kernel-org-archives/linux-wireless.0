Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34930 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYBSMew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 07:34:52 -0500
Subject: [PATCH] mac80211: convert sta_info.pspoll to a flag
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 11:31:14 +0100
Message-Id: <1203417074.12963.32.camel@johannes.berg> (sfid-20080219_123455_289694_1B228E76)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This doesn't really need to be a full int variable since it's
just a flag to indicate a PS-poll is in progress.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c       |   13 +++++++------
 net/mac80211/sta_info.h |    3 ++-
 net/mac80211/tx.c       |    5 +++--
 3 files changed, 12 insertions(+), 9 deletions(-)

--- everything.orig/net/mac80211/rx.c	2008-02-19 11:24:15.273690810 +0100
+++ everything/net/mac80211/rx.c	2008-02-19 11:24:54.373690049 +0100
@@ -578,7 +578,7 @@ static void ap_sta_ps_start(struct net_d
 	if (sdata->bss)
 		atomic_inc(&sdata->bss->num_sta_ps);
 	sta->flags |= WLAN_STA_PS;
-	sta->pspoll = 0;
+	sta->flags &= ~WLAN_STA_PSPOLL;
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
 	       dev->name, print_mac(mac, sta->addr), sta->aid);
@@ -597,8 +597,7 @@ static int ap_sta_ps_end(struct net_devi
 	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 	if (sdata->bss)
 		atomic_dec(&sdata->bss->num_sta_ps);
-	sta->flags &= ~(WLAN_STA_PS | WLAN_STA_TIM);
-	sta->pspoll = 0;
+	sta->flags &= ~(WLAN_STA_PS | WLAN_STA_TIM | WLAN_STA_PSPOLL);
 	if (!skb_queue_empty(&sta->ps_tx_buf)) {
 		if (local->ops->set_tim)
 			local->ops->set_tim(local_to_hw(local), sta->aid, 0);
@@ -924,9 +923,11 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 		struct ieee80211_hdr *hdr =
 			(struct ieee80211_hdr *) skb->data;
 
-		/* tell TX path to send one frame even though the STA may
-		 * still remain is PS mode after this frame exchange */
-		rx->sta->pspoll = 1;
+		/*
+		 * Tell TX path to send one frame even though the STA may
+		 * still remain is PS mode after this frame exchange.
+		 */
+		rx->sta->flags |= WLAN_STA_PSPOLL;
 
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "STA %s aid %d: PS Poll (entries after %d)\n",
--- everything.orig/net/mac80211/sta_info.h	2008-02-19 11:23:32.013730903 +0100
+++ everything/net/mac80211/sta_info.h	2008-02-19 11:28:26.283690484 +0100
@@ -32,6 +32,7 @@
  * @WLAN_STA_ASSOC_AP: We're associated to that station, it is an AP.
  * @WLAN_STA_WME: Station is a QoS-STA.
  * @WLAN_STA_WDS: Station is one of our WDS peers.
+ * @WLAN_STA_PSPOLL: Station has just PS-polled us.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH		= 1<<0,
@@ -43,6 +44,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_ASSOC_AP	= 1<<6,
 	WLAN_STA_WME		= 1<<7,
 	WLAN_STA_WDS		= 1<<8,
+	WLAN_STA_PSPOLL		= 1<<9,
 };
 
 #define STA_TID_NUM 16
@@ -133,7 +135,6 @@ struct sta_info {
 
 	struct sk_buff_head ps_tx_buf; /* buffer of TX frames for station in
 					* power saving state */
-	int pspoll; /* whether STA has send a PS Poll frame */
 	struct sk_buff_head tx_filtered; /* buffer of TX frames that were
 					  * already given to low-level driver,
 					  * but were filtered */
--- everything.orig/net/mac80211/tx.c	2008-02-19 11:25:05.753690810 +0100
+++ everything/net/mac80211/tx.c	2008-02-19 11:26:05.173686632 +0100
@@ -395,7 +395,8 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		      (tx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP)))
 		return TX_CONTINUE;
 
-	if (unlikely((sta->flags & WLAN_STA_PS) && !sta->pspoll)) {
+	if (unlikely((sta->flags & WLAN_STA_PS) &&
+		     !(sta->flags & WLAN_STA_PSPOLL))) {
 		struct ieee80211_tx_packet_data *pkt_data;
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "STA %s aid %d: PS buffer (entries "
@@ -436,7 +437,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		       print_mac(mac, sta->addr));
 	}
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-	sta->pspoll = 0;
+	sta->flags &= ~WLAN_STA_PSPOLL;
 
 	return TX_CONTINUE;
 }


