Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42960 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754783AbcJLMTS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 08:19:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: preserve more bits when building QoS header
Date: Wed, 12 Oct 2016 14:19:08 +0200
Message-Id: <1476274748-29036-1-git-send-email-johannes@sipsolutions.net> (sfid-20161012_141937_645512_8B29BC86)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Michael Braun reported that when trying to inject A-MSDUs over
monitor interfaces, the frame doesn't come out right since the
QoS header A-MSDU bit is overwritten.

Rather than adding that bit specifically simply preserve those
bits that we don't set here, since we typically get here with
a zeroed-out QoS header anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/wme.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 9eb0aee9105b..3e3d3014e9ab 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -236,26 +236,35 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	u8 tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
+	u8 flags;
 	u8 *p;
-	u8 ack_policy, tid;
 
 	if (!ieee80211_is_data_qos(hdr->frame_control))
 		return;
 
 	p = ieee80211_get_qos_ctl(hdr);
-	tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 
-	/* preserve EOSP bit */
-	ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
+	/* set up the first byte */
+
+	/*
+	 * preserve everything but the TID and ACK policy
+	 * (which we both write here)
+	 */
+	flags = *p & ~(IEEE80211_QOS_CTL_TID_MASK |
+		       IEEE80211_QOS_CTL_ACK_POLICY_MASK);
 
 	if (is_multicast_ether_addr(hdr->addr1) ||
 	    sdata->noack_map & BIT(tid)) {
-		ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
+		flags |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
 		info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	}
 
-	/* qos header is 2 bytes */
-	*p++ = ack_policy | tid;
+	*p = flags | tid;
+
+	/* set up the second byte */
+	p++;
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		/* preserve RSPI and Mesh PS Level bit */
 		*p &= ((IEEE80211_QOS_CTL_RSPI |
-- 
2.8.1
