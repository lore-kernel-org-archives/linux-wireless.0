Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44790 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1J2FFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Oct 2011 01:05:40 -0400
Received: by mail-pz0-f42.google.com with SMTP id 36so12352067pzk.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Oct 2011 22:05:40 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 2/4] mac80211: QoS multicast frames have No Ack policy
Date: Fri, 28 Oct 2011 22:05:30 -0700
Message-Id: <1319864732-11286-2-git-send-email-thomas@cozybit.com> (sfid-20111029_070543_455434_1E5A4A45)
In-Reply-To: <1319864732-11286-1-git-send-email-thomas@cozybit.com>
References: <1319864732-11286-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously QoS multicast frames had the Normal Acknowledgment QoS
control bits set. This would cause broadcast frames to be discarded by
peers with which we have a BA session, since their sequence number would
fall outside the allowed range. Set No Ack QoS control bits on multicast
QoS frames and filter these in de-aggregation code.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/rx.c  |    8 +++++++-
 net/mac80211/wme.c |    3 ++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b867bd5..ee9e71b 100644
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
@@ -760,6 +760,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 	if (!sta)
 		goto dont_reorder;
 
+	ack_policy = *ieee80211_get_qos_ctl(hdr) & ~IEEE80211_QOS_CTL_TID_MASK;
 	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
 
 	tid_agg_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
@@ -770,6 +771,11 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
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

