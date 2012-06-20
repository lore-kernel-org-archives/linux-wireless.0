Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:56943 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237Ab2FTMoq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 08:44:46 -0400
Received: by ghy10 with SMTP id 10so5655335ghy.2
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 05:44:45 -0700 (PDT)
From: Yoni Divinsky <yoni.divinsky@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>, Yoni Divinsky <yoni.divinsky@ti.com>
Subject: [PATCH] mac80211: save wmm_acm per sdata
Date: Wed, 20 Jun 2012 15:39:13 +0300
Message-Id: <1340195953-25343-1-git-send-email-yoni.divinsky@ti.com> (sfid-20120620_144450_095427_04C445A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Save and configure the wmm_acm per sdata, rather than
per hardware.

If wmm_acm is saved per hardware when running two
interfaces simultaneously on the same hardware one
interface's wmm policy will be affected by the other
interface.

Signed-off-by: Yoni Divinsky <yoni.divinsky@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/iface.c       |    2 +-
 net/mac80211/mlme.c        |   10 +++++-----
 net/mac80211/rx.c          |    2 +-
 net/mac80211/wme.c         |   11 ++++++-----
 net/mac80211/wme.h         |    2 +-
 6 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 34af2e5..a73315b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -726,6 +726,7 @@ struct ieee80211_sub_if_data {
 		struct dentry *default_mgmt_key;
 	} debugfs;
 #endif
+	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 	/* must be last, dynamically sized area in this! */
 	struct ieee80211_vif vif;
 };
@@ -1025,7 +1026,6 @@ struct ieee80211_local {
 	int total_ps_buffered; /* total number of all buffered unicast and
 				* multicast packets for power saving stations
 				*/
-	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
 	bool pspolling;
 	bool offchannel_ps_enabled;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 87aeb4f..728d3ea 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -808,7 +808,7 @@ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 
 	hdr = (void *)((u8 *)skb->data + le16_to_cpu(rtap->it_len));
 
-	return ieee80211_select_queue_80211(local, skb, hdr);
+	return ieee80211_select_queue_80211(sdata, skb, hdr);
 }
 
 static const struct net_device_ops ieee80211_monitorif_ops = {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fa927c6..644513d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1141,7 +1141,7 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 
 	memset(&params, 0, sizeof(params));
 
-	local->wmm_acm = 0;
+	sdata->wmm_acm = 0;
 	for (; left >= 4; left -= 4, pos += 4) {
 		int aci = (pos[0] >> 5) & 0x03;
 		int acm = (pos[0] >> 4) & 0x01;
@@ -1152,21 +1152,21 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		case 1: /* AC_BK */
 			queue = 3;
 			if (acm)
-				local->wmm_acm |= BIT(1) | BIT(2); /* BK/- */
+				sdata->wmm_acm |= BIT(1) | BIT(2); /* BK/- */
 			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BK)
 				uapsd = true;
 			break;
 		case 2: /* AC_VI */
 			queue = 1;
 			if (acm)
-				local->wmm_acm |= BIT(4) | BIT(5); /* CL/VI */
+				sdata->wmm_acm |= BIT(4) | BIT(5); /* CL/VI */
 			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VI)
 				uapsd = true;
 			break;
 		case 3: /* AC_VO */
 			queue = 0;
 			if (acm)
-				local->wmm_acm |= BIT(6) | BIT(7); /* VO/NC */
+				sdata->wmm_acm |= BIT(6) | BIT(7); /* VO/NC */
 			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
 				uapsd = true;
 			break;
@@ -1174,7 +1174,7 @@ static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		default:
 			queue = 2;
 			if (acm)
-				local->wmm_acm |= BIT(0) | BIT(3); /* BE/EE */
+				sdata->wmm_acm |= BIT(0) | BIT(3); /* BE/EE */
 			if (uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BE)
 				uapsd = true;
 			break;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 072e8f3..446a327 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1935,7 +1935,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	    ether_addr_equal(sdata->vif.addr, hdr->addr3))
 		return RX_CONTINUE;
 
-	q = ieee80211_select_queue_80211(local, skb, hdr);
+	q = ieee80211_select_queue_80211(sdata, skb, hdr);
 	if (ieee80211_queue_stopped(&local->hw, q)) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_congestion);
 		return RX_DROP_MONITOR;
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index c3d643a..cea06e9 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -52,11 +52,11 @@ static int wme_downgrade_ac(struct sk_buff *skb)
 	}
 }
 
-static u16 ieee80211_downgrade_queue(struct ieee80211_local *local,
+static u16 ieee80211_downgrade_queue(struct ieee80211_sub_if_data *sdata,
 				     struct sk_buff *skb)
 {
 	/* in case we are a client verify acm is not set for this ac */
-	while (unlikely(local->wmm_acm & BIT(skb->priority))) {
+	while (unlikely(sdata->wmm_acm & BIT(skb->priority))) {
 		if (wme_downgrade_ac(skb)) {
 			/*
 			 * This should not really happen. The AP has marked all
@@ -73,10 +73,11 @@ static u16 ieee80211_downgrade_queue(struct ieee80211_local *local,
 }
 
 /* Indicate which queue to use for this fully formed 802.11 frame */
-u16 ieee80211_select_queue_80211(struct ieee80211_local *local,
+u16 ieee80211_select_queue_80211(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb,
 				 struct ieee80211_hdr *hdr)
 {
+	struct ieee80211_local *local = sdata->local;
 	u8 *p;
 
 	if (local->hw.queues < IEEE80211_NUM_ACS)
@@ -94,7 +95,7 @@ u16 ieee80211_select_queue_80211(struct ieee80211_local *local,
 	p = ieee80211_get_qos_ctl(hdr);
 	skb->priority = *p & IEEE80211_QOS_CTL_TAG1D_MASK;
 
-	return ieee80211_downgrade_queue(local, skb);
+	return ieee80211_downgrade_queue(sdata, skb);
 }
 
 /* Indicate which queue to use. */
@@ -156,7 +157,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	 * data frame has */
 	skb->priority = cfg80211_classify8021d(skb);
 
-	return ieee80211_downgrade_queue(local, skb);
+	return ieee80211_downgrade_queue(sdata, skb);
 }
 
 void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index ca80818..7fea4bb 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -15,7 +15,7 @@
 
 extern const int ieee802_1d_to_ac[8];
 
-u16 ieee80211_select_queue_80211(struct ieee80211_local *local,
+u16 ieee80211_select_queue_80211(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb,
 				 struct ieee80211_hdr *hdr);
 u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
-- 
1.7.0.4

