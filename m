Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:59660 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab2KVTRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:17:14 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [PATCH 2/3] mac80211: refactor ieee80211_set_qos_hdr
Date: Wed, 21 Nov 2012 18:40:31 -0800
Message-Id: <1353552032-15600-3-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121122_201722_444193_8459EF3B)
In-Reply-To: <1353552032-15600-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353552032-15600-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return early if not a QoS Data frame.
Give proper documentation.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/mac80211/wme.c |   40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index cea06e9..906f00c 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -160,31 +160,37 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	return ieee80211_downgrade_queue(sdata, skb);
 }
 
+/**
+ * ieee80211_set_qos_hdr - Fill in the QoS header if there is one.
+ *
+ * @sdata: local subif
+ * @skb: packet to be updated
+ */
 void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	u8 *p;
+	u8 ack_policy, tid;
 
-	/* Fill in the QoS header if there is one. */
-	if (ieee80211_is_data_qos(hdr->frame_control)) {
-		u8 *p = ieee80211_get_qos_ctl(hdr);
-		u8 ack_policy, tid;
-
-		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
+	if (!ieee80211_is_data_qos(hdr->frame_control))
+		return;
 
-		/* preserve EOSP bit */
-		ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
+	p = ieee80211_get_qos_ctl(hdr);
+	tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 
-		if (is_multicast_ether_addr(hdr->addr1) ||
-		    sdata->noack_map & BIT(tid)) {
-			ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
-			info->flags |= IEEE80211_TX_CTL_NO_ACK;
-		}
+	/* preserve EOSP bit */
+	ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
 
-		/* qos header is 2 bytes */
-		*p++ = ack_policy | tid;
-		*p = ieee80211_vif_is_mesh(&sdata->vif) ?
-			(IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT >> 8) : 0;
+	if (is_multicast_ether_addr(hdr->addr1) ||
+	    sdata->noack_map & BIT(tid)) {
+		ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
+		info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	}
+
+	/* qos header is 2 bytes */
+	*p++ = ack_policy | tid;
+	*p = ieee80211_vif_is_mesh(&sdata->vif) ?
+		(IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT >> 8) : 0;
 }
-- 
1.7.9.5

