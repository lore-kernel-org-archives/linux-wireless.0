Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43838 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab1KWUcr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 15:32:47 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so2078525iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 12:32:47 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 4/7] mac80211: fix forwarded mesh frame queue mapping
Date: Wed, 23 Nov 2011 12:32:23 -0800
Message-Id: <1322080347-7644-5-git-send-email-thomas@cozybit.com> (sfid-20111123_213251_472664_5D09D175)
In-Reply-To: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
References: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can't rely on ieee80211_select_queue() to do its job at this point
since the skb->protocol is not yet known. Instead, factor out and reuse
the queue mapping logic for injected frames.

Also, to mitigate congestion, forwarded frames should be dropped if the
outgoing queue was stopped.  This was not correctly implemented as we
were not checking the right queue.  Furthermore, we were dropping frames
that had arrived to their destination if that queue was stopped.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/iface.c |   15 +--------------
 net/mac80211/rx.c    |   15 ++++++++-------
 net/mac80211/wme.c   |   23 +++++++++++++++++++++++
 net/mac80211/wme.h   |    3 +++
 4 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b34ca0c..3070918 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -672,7 +672,6 @@ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_radiotap_header *rtap = (void *)skb->data;
-	u8 *p;
 
 	if (local->hw.queues < 4)
 		return 0;
@@ -683,19 +682,7 @@ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 
 	hdr = (void *)((u8 *)skb->data + le16_to_cpu(rtap->it_len));
 
-	if (!ieee80211_is_data(hdr->frame_control)) {
-		skb->priority = 7;
-		return ieee802_1d_to_ac[skb->priority];
-	}
-	if (!ieee80211_is_data_qos(hdr->frame_control)) {
-		skb->priority = 0;
-		return ieee802_1d_to_ac[skb->priority];
-	}
-
-	p = ieee80211_get_qos_ctl(hdr);
-	skb->priority = *p & IEEE80211_QOS_CTL_TAG1D_MASK;
-
-	return ieee80211_downgrade_queue(local, skb);
+	return ieee80211_select_queue_cooked(local, skb, hdr);
 }
 
 static const struct net_device_ops ieee80211_monitorif_ops = {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index eef5302..9da4528 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1902,6 +1902,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	u16 q;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -1920,12 +1921,6 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		/* illegal frame */
 		return RX_DROP_MONITOR;
 
-	if (ieee80211_queue_stopped(&local->hw, skb_get_queue_mapping(skb))) {
-		IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
-						dropped_frames_congestion);
-		return RX_DROP_MONITOR;
-	}
-
 	if (mesh_hdr->flags & MESH_FLAGS_AE) {
 		struct mesh_path *mppath;
 		char *proxied_addr;
@@ -1957,7 +1952,13 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	    compare_ether_addr(sdata->vif.addr, hdr->addr3) == 0)
 		return RX_CONTINUE;
 
-	skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, skb));
+	q = ieee80211_select_queue_cooked(local, skb, hdr);
+	if (ieee80211_queue_stopped(&local->hw, q)) {
+		IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
+					     dropped_frames_congestion);
+		return RX_DROP_MONITOR;
+	}
+	skb_set_queue_mapping(skb, q);
 	mesh_hdr->ttl--;
 
 	if (status->rx_flags & IEEE80211_RX_RA_MATCH) {
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 4332711..2b36754 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -52,6 +52,29 @@ static int wme_downgrade_ac(struct sk_buff *skb)
 	}
 }
 
+/* Indicate which queue to use for this fully formed 802.11 frame */
+u16 ieee80211_select_queue_cooked(struct ieee80211_local *local,
+				  struct sk_buff *skb,
+				  struct ieee80211_hdr *hdr) {
+	u8 *p;
+
+	if (local->hw.queues < 4)
+		return 0;
+
+	if (!ieee80211_is_data(hdr->frame_control)) {
+		skb->priority = 7;
+		return ieee802_1d_to_ac[skb->priority];
+	}
+	if (!ieee80211_is_data_qos(hdr->frame_control)) {
+		skb->priority = 0;
+		return ieee802_1d_to_ac[skb->priority];
+	}
+
+	p = ieee80211_get_qos_ctl(hdr);
+	skb->priority = *p & IEEE80211_QOS_CTL_TAG1D_MASK;
+
+	return ieee80211_downgrade_queue(local, skb);
+}
 
 /* Indicate which queue to use. */
 u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index 34e166f..1c46917 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -15,6 +15,9 @@
 
 extern const int ieee802_1d_to_ac[8];
 
+u16 ieee80211_select_queue_cooked(struct ieee80211_local *local,
+				  struct sk_buff *skb,
+				  struct ieee80211_hdr *hdr);
 u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb);
 void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
-- 
1.7.5.4

