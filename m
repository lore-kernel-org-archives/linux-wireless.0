Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47638 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932758AbbDQPQN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 11:16:13 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/11] mac80211: allow drivers to support S/G
Date: Fri, 17 Apr 2015 17:15:50 +0200
Message-Id: <1429283751-5104-10-git-send-email-johannes@sipsolutions.net> (sfid-20150417_171622_277235_64F5C2F7)
In-Reply-To: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
References: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If drivers want to support S/G (really just gather DMA on TX) then
we can now easily support this on the fast-xmit path since it just
needs to write to the ethernet header (and already has a check for
that being possible.)

However, disallow this on the regular TX path (which has to handle
fragmentation, software crypto, etc.) by calling skb_linearize().

Also allow the related HIGHDMA since that's not interesting to the
code in mac80211 at all anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 3 ++-
 net/mac80211/tx.c          | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3f837fea05ae..25a456c48043 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -86,7 +86,8 @@ struct ieee80211_local;
 /* Only these features can be passed through mac80211 */
 #define IEEE80211_SUPPORTED_NETDEV_FEATURES	\
 	(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |	\
-	 NETIF_F_HW_CSUM | NETIF_F_RXCSUM)
+	 NETIF_F_HW_CSUM | NETIF_F_RXCSUM |	\
+	 NETIF_F_SG | NETIF_F_HIGHDMA)
 
 struct ieee80211_fragment_entry {
 	unsigned long first_frag_time;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e76f3e96eb84..53a16257dfc1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2848,6 +2848,12 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 			goto out;
 	}
 
+	/* we cannot process non-linear frames on this path */
+	if (skb_linearize(skb)) {
+		kfree_skb(skb);
+		goto out;
+	}
+
 	/* the frame could be fragmented, software-encrypted, and other things
 	 * so we cannot really handle checksum offload with it - fix it up in
 	 * software before we handle anything else.
-- 
2.1.4

