Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60533 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1JTSaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 14:30:15 -0400
Received: by mail-pz0-f42.google.com with SMTP id 36so7654640pzk.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 11:30:15 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v2 2/2] mac80211: select queue for fwded mesh frames
Date: Thu, 20 Oct 2011 11:30:07 -0700
Message-Id: <1319135408-6370-2-git-send-email-thomas@cozybit.com> (sfid-20111020_203022_489327_11D7CF56)
In-Reply-To: <1319135408-6370-1-git-send-email-thomas@cozybit.com>
References: <1319135408-6370-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set proper queue mapping and timestamp for forwarded mesh frames.

Thanks to Luis Rodriguez for investigating and fixing this.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

---
v2:
	We were already doing this for mcast frames, so don't duplicate
	the code.

 net/mac80211/rx.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b867bd5..1408472 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1952,13 +1952,15 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 			info = IEEE80211_SKB_CB(fwd_skb);
 			memset(info, 0, sizeof(*info));
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
+			info->control.jiffies = jiffies;
 			info->control.vif = &rx->sdata->vif;
+			skb_set_queue_mapping(fwd_skb,
+				ieee80211_select_queue(sdata, fwd_skb));
+			ieee80211_set_qos_hdr(sdata, fwd_skb);
+
 			if (is_multicast_ether_addr(fwd_hdr->addr1)) {
 				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
 								fwded_mcast);
-				skb_set_queue_mapping(fwd_skb,
-					ieee80211_select_queue(sdata, fwd_skb));
-				ieee80211_set_qos_hdr(sdata, fwd_skb);
 			} else {
 				int err;
 				/*
-- 
1.7.5.4

