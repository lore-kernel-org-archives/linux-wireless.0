Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55046 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762292Ab3ECCga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 22:36:30 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz10so676241pad.2
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 19:36:30 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>
Subject: [RFC 09/12] mac80211: add shared-mbss transmit path
Date: Thu,  2 May 2013 19:33:59 -0700
Message-Id: <1367548442-8229-10-git-send-email-thomas@cozybit.com> (sfid-20130503_043633_295611_68429A4A)
In-Reply-To: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

Transmit locally-originated group data frames on every interface
so that members of the mesh on every channel will see the frame.

For individually-addressed frames, when we resolve the next
hop, the outgoing interface might be different than the
originator if the best path is on a different channel.
Requeue such frames on the correct interface's pending queue.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/mesh_hwmp.c |   12 +++++++++++-
 net/mac80211/tx.c        |    3 +++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index d8eaccc..6ba483e 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1115,6 +1115,7 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 			 struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_sub_if_data *dest_sdata;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct mesh_local_bss *mbss = mbss(sdata);
 	struct mesh_path *mpath;
@@ -1128,8 +1129,17 @@ int mesh_nexthop_resolve(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_lock();
 	err = mesh_nexthop_lookup(mbss, skb);
-	if (!err)
+	if (!err) {
+		dest_sdata = vif_to_sdata(info->control.vif);
+		/* requeue if mesh path uses a different interface */
+		if (dest_sdata != sdata) {
+			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
+			ieee80211_set_qos_hdr(dest_sdata, skb);
+			ieee80211_add_pending_skb(dest_sdata->local, skb);
+			err = -EAGAIN;
+		}
 		goto endlookup;
+	}
 
 	/* no nexthop found, start resolving */
 	mpath = mesh_path_lookup(mbss, target_addr);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c132c76..4b28680 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1452,6 +1452,9 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 		} else {
 			ieee80211_mps_set_frame_flags(sdata, NULL, hdr);
 		}
+		if (is_multicast_ether_addr(hdr->addr1) &&
+		    ieee80211_is_data(hdr->frame_control))
+			mesh_bss_forward_tx(sdata, skb);
 	}
 
 	ieee80211_set_qos_hdr(sdata, skb);
-- 
1.7.10.4

