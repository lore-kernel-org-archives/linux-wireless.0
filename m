Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbXFVIl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:41:28 -0400
Message-Id: <20070621221756.224604000@sipsolutions.net>
References: <20070621221603.778432000@sipsolutions.net>
Date: Fri, 22 Jun 2007 00:16:05 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: [PATCH 02/14] mac80211: move QoS rx handlers into rx.c
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves the QoS handlers into rx.c making it possible
to compile wme.c only when NET_SCHED is defined.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/Makefile |    2 -
 net/mac80211/rx.c     |   65 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/wme.c    |   73 --------------------------------------------------
 net/mac80211/wme.h    |    9 ++----
 4 files changed, 70 insertions(+), 79 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-06-21 19:29:20.218638003 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-06-21 19:29:25.278638003 +0200
@@ -31,6 +31,50 @@
  */
 
 static ieee80211_txrx_result
+ieee80211_rx_h_parse_qos(struct ieee80211_txrx_data *rx)
+{
+	u8 *data = rx->skb->data;
+	int tid;
+	unsigned int is_agg_frame = 0;
+
+	/* does the frame have a qos control field? */
+	if (WLAN_FC_IS_QOS_DATA(rx->fc)) {
+		u8 *qc = data + ieee80211_get_hdrlen(rx->fc) - QOS_CONTROL_LEN;
+
+		/* frame has qos control */
+		rx->u.rx.qos_control = le16_to_cpu(*((__le16*)qc));
+		tid = rx->u.rx.qos_control & QOS_CONTROL_TID_MASK;
+		if (rx->u.rx.qos_control &
+		    IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
+			is_agg_frame = 1;
+	} else {
+		if (unlikely((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)) {
+			/* Separate TID for management frames */
+			tid = NUM_RX_DATA_QUEUES - 1;
+		} else {
+			/* no qos control present */
+			tid = 0; /* 802.1d - Best Effort */
+		}
+		rx->u.rx.qos_control = 0;
+	}
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+	I802_DEBUG_INC(rx->local->wme_rx_queue[tid]);
+	if (rx->sta) {
+		I802_DEBUG_INC(rx->sta->wme_rx_queue[tid]);
+	}
+#endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
+
+	rx->u.rx.queue = tid;
+	rx->u.rx.is_agg_frame = is_agg_frame;
+	/* Set skb->priority to 1d tag if highest order bit of TID is not set.
+	 * For now, set skb->priority to 0 for other cases. */
+	rx->skb->priority = (tid > 7) ? 0 : tid;
+
+	return TXRX_CONTINUE;
+}
+
+
+static ieee80211_txrx_result
 ieee80211_rx_h_load_stats(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
@@ -777,6 +821,27 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 
 
 static ieee80211_txrx_result
+ieee80211_rx_h_remove_qos_control(struct ieee80211_txrx_data *rx)
+{
+	u16 fc = rx->fc;
+	u8 *data = rx->skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) data;
+
+	if (!WLAN_FC_IS_QOS_DATA(fc))
+		return TXRX_CONTINUE;
+
+	/* remove the qos control field, update frame type and meta-data */
+	memmove(data + 2, data, ieee80211_get_hdrlen(fc) - 2);
+	hdr = (struct ieee80211_hdr *) skb_pull(rx->skb, 2);
+	/* change frame type to non QOS */
+	rx->fc = fc &= ~IEEE80211_STYPE_QOS_DATA;
+	hdr->frame_control = cpu_to_le16(fc);
+
+	return TXRX_CONTINUE;
+}
+
+
+static ieee80211_txrx_result
 ieee80211_rx_h_802_1x_pae(struct ieee80211_txrx_data *rx)
 {
 	if (rx->sdata->eapol && ieee80211_is_eapol(rx->skb) &&
--- wireless-dev.orig/net/mac80211/wme.c	2007-06-21 19:29:07.088638003 +0200
+++ wireless-dev/net/mac80211/wme.c	2007-06-21 19:29:51.328638003 +0200
@@ -18,78 +18,6 @@
 #include "ieee80211_i.h"
 #include "wme.h"
 
-static inline int WLAN_FC_IS_QOS_DATA(u16 fc)
-{
-	return (fc & 0x8C) == 0x88;
-}
-
-
-ieee80211_txrx_result
-ieee80211_rx_h_parse_qos(struct ieee80211_txrx_data *rx)
-{
-	u8 *data = rx->skb->data;
-	int tid;
-	unsigned int is_agg_frame = 0;
-
-	/* does the frame have a qos control field? */
-	if (WLAN_FC_IS_QOS_DATA(rx->fc)) {
-		u8 *qc = data + ieee80211_get_hdrlen(rx->fc) - QOS_CONTROL_LEN;
-
-		/* frame has qos control */
-		rx->u.rx.qos_control = le16_to_cpu(*((__le16*)qc));
-		tid = rx->u.rx.qos_control & QOS_CONTROL_TID_MASK;
-		if (rx->u.rx.qos_control &
-		    IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
-			is_agg_frame = 1;
-	} else {
-		if (unlikely((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)) {
-			/* Separate TID for management frames */
-			tid = NUM_RX_DATA_QUEUES - 1;
-		} else {
-			/* no qos control present */
-			tid = 0; /* 802.1d - Best Effort */
-		}
-		rx->u.rx.qos_control = 0;
-	}
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-	I802_DEBUG_INC(rx->local->wme_rx_queue[tid]);
-	if (rx->sta) {
-		I802_DEBUG_INC(rx->sta->wme_rx_queue[tid]);
-	}
-#endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
-
-	rx->u.rx.queue = tid;
-	rx->u.rx.is_agg_frame = is_agg_frame;
-	/* Set skb->priority to 1d tag if highest order bit of TID is not set.
-	 * For now, set skb->priority to 0 for other cases. */
-	rx->skb->priority = (tid > 7) ? 0 : tid;
-
-	return TXRX_CONTINUE;
-}
-
-
-ieee80211_txrx_result
-ieee80211_rx_h_remove_qos_control(struct ieee80211_txrx_data *rx)
-{
-	u16 fc = rx->fc;
-	u8 *data = rx->skb->data;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) data;
-
-	if (!WLAN_FC_IS_QOS_DATA(fc))
-		return TXRX_CONTINUE;
-
-	/* remove the qos control field, update frame type and meta-data */
-	memmove(data + 2, data, ieee80211_get_hdrlen(fc) - 2);
-	hdr = (struct ieee80211_hdr *) skb_pull(rx->skb, 2);
-	/* change frame type to non QOS */
-	rx->fc = fc &= ~IEEE80211_STYPE_QOS_DATA;
-	hdr->frame_control = cpu_to_le16(fc);
-
-	return TXRX_CONTINUE;
-}
-
-
-#ifdef CONFIG_NET_SCHED
 /* maximum number of hardware queues we support. */
 #define TC_80211_MAX_QUEUES 8
 
@@ -709,4 +637,3 @@ void ieee80211_wme_unregister(void)
 {
 	unregister_qdisc(&wme_qdisc_ops);
 }
-#endif /* CONFIG_NET_SCHED */
--- wireless-dev.orig/net/mac80211/wme.h	2007-06-21 19:29:07.178638003 +0200
+++ wireless-dev/net/mac80211/wme.h	2007-06-21 19:29:25.288638003 +0200
@@ -24,11 +24,10 @@
 
 #define QOS_CONTROL_TAG1D_MASK 0x07
 
-ieee80211_txrx_result
-ieee80211_rx_h_parse_qos(struct ieee80211_txrx_data *rx);
-
-ieee80211_txrx_result
-ieee80211_rx_h_remove_qos_control(struct ieee80211_txrx_data *rx);
+static inline int WLAN_FC_IS_QOS_DATA(u16 fc)
+{
+	return (fc & 0x8C) == 0x88;
+}
 
 #ifdef CONFIG_NET_SCHED
 void ieee80211_install_qdisc(struct net_device *dev);
--- wireless-dev.orig/net/mac80211/Makefile	2007-06-21 19:29:53.828638003 +0200
+++ wireless-dev/net/mac80211/Makefile	2007-06-21 19:30:12.558638003 +0200
@@ -2,6 +2,7 @@ obj-$(CONFIG_MAC80211) += mac80211.o rc8
 
 mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
 mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += debugfs.o debugfs_sta.o debugfs_netdev.o debugfs_key.o
+mac80211-objs-$(CONFIG_NET_SCHED) += wme.o
 
 mac80211-objs := \
 	ieee80211.o \
@@ -16,7 +17,6 @@ mac80211-objs := \
 	regdomain.o \
 	tkip.o \
 	aes_ccm.o \
-	wme.o \
 	ieee80211_cfg.o \
 	rx.o \
 	$(mac80211-objs-y)

-- 

