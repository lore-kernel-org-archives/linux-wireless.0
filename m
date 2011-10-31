Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39712 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab1JaHMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 03:12:51 -0400
Received: by mail-pz0-f42.google.com with SMTP id 36so17635694pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 00:12:51 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v2 2/4] mac80211: QoS multicast frames have No Ack policy
Date: Mon, 31 Oct 2011 00:12:39 -0700
Message-Id: <1320045161-16144-2-git-send-email-thomas@cozybit.com> (sfid-20111031_081256_644595_10204183)
In-Reply-To: <1320045161-16144-1-git-send-email-thomas@cozybit.com>
References: <1320045161-16144-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously QoS multicast frames had the Normal Acknowledgment QoS
control bits set. This would cause broadcast frames to be discarded by
peers with which we have a BA session, since their sequence number would
fall outside the allowed range. Set No Ack QoS control bits on multicast
QoS frames and filter these in de-aggregation code.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

---
v2: Use proper QoS Ack Policy control field mask (Christian)
 include/linux/ieee80211.h |    1 +
 net/mac80211/rx.c         |    9 ++++++++-
 net/mac80211/wme.c        |    3 ++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 48363c3..bc61e69 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -128,6 +128,7 @@
 #define IEEE80211_QOS_CTL_ACK_POLICY_NOACK	0x0020
 #define IEEE80211_QOS_CTL_ACK_POLICY_NO_EXPL	0x0040
 #define IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK	0x0060
+#define IEEE80211_QOS_CTL_ACK_POLICY_MASK	0x0060
 /* A-MSDU 802.11n */
 #define IEEE80211_QOS_CTL_A_MSDU_PRESENT	0x0080
 /* Mesh Control 802.11s */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b867bd5..b9d3236 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -747,7 +747,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 	struct sta_info *sta = rx->sta;
 	struct tid_ampdu_rx *tid_agg_rx;
 	u16 sc;
-	int tid;
+	u8 tid, ack_policy;
 
 	if (!ieee80211_is_data_qos(hdr->frame_control))
 		goto dont_reorder;
@@ -760,6 +760,8 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 	if (!sta)
 		goto dont_reorder;
 
+	ack_policy = *ieee80211_get_qos_ctl(hdr) &
+		     IEEE80211_QOS_CTL_ACK_POLICY_MASK;
 	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
 
 	tid_agg_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
@@ -770,6 +772,11 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 	if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
 		goto dont_reorder;
 
+	/* not part of a BA session */
+	if (!((ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_BLOCKACK) ||
+	      (ack_policy == IEEE80211_QOS_CTL_ACK_POLICY_NORMAL)))
+		goto dont_reorder;
+
 	/* new, potentially un-ordered, ampdu frame - process it */
 
 	/* reset session timer */
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index fd52e69..a440a4a 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -147,7 +147,8 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 
-		if (unlikely(sdata->local->wifi_wme_noack_test))
+		if (unlikely(sdata->local->wifi_wme_noack_test) ||
+		    is_multicast_ether_addr(hdr->addr1))
 			ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
 		/* qos header is 2 bytes */
 		*p++ = ack_policy | tid;
-- 
1.7.5.4

