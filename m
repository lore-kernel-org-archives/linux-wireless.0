Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23889 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbYAIRPe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 12:15:34 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, j@w1.fi
Cc: reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
	Guy Cohen <guy.cohen@intel.com>
Subject: [RFC][PATCH] mac80211: Assign correct TID for local bridged packets
Date: Wed,  9 Jan 2008 19:12:48 +0200
Message-Id: <11998987683864-git-send-email-tomas.winkler@intel.com> (sfid-20080109_171537_663652_CCF8C6E5)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

This patch assigns correct TID to frames transmitted between
two stations in the same BSS in AP mode.
The problem is that skb->protocol is not set to ETH_P_IP and it is wrong
to use that field at this stage.
The fix compares the LLC/Protocol headers explicitly to check if the
encapsulated frame is IP frame

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
---
 net/mac80211/wme.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 5b8a157..451929e 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -28,6 +28,7 @@ struct ieee80211_sched_data
 	struct sk_buff_head requeued[TC_80211_MAX_QUEUES];
 };
 
+static const char llc_ip_hdr[8] = {0xAA, 0xAA, 0x3, 0, 0, 0, 0x08, 0};
 
 /* given a data frame determine the 802.1p/1d tag to use */
 static inline unsigned classify_1d(struct sk_buff *skb, struct Qdisc *qd)
@@ -54,12 +55,12 @@ static inline unsigned classify_1d(struct sk_buff *skb, struct Qdisc *qd)
 		return skb->priority - 256;
 
 	/* check there is a valid IP header present */
-	offset = ieee80211_get_hdrlen_from_skb(skb) + 8 /* LLC + proto */;
-	if (skb->protocol != __constant_htons(ETH_P_IP) ||
-	    skb->len < offset + sizeof(*ip))
+	offset = ieee80211_get_hdrlen_from_skb(skb);
+	if (skb->len < offset + sizeof(llc_ip_hdr) + sizeof(*ip) ||
+	    memcmp(skb->data + offset, llc_ip_hdr, sizeof(llc_ip_hdr)))
 		return 0;
 
-	ip = (struct iphdr *) (skb->data + offset);
+	ip = (struct iphdr *) (skb->data + offset + sizeof(llc_ip_hdr));
 
 	dscp = ip->tos & 0xfc;
 	if (dscp & 0x1c)
-- 
1.5.2.2

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

