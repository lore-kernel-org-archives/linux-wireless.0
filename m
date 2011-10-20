Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59986 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab1JTAXe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 20:23:34 -0400
Received: by ggnb1 with SMTP id b1so2230765ggn.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 17:23:33 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 3/3] mac80211: select queue for fwded mesh frames
Date: Wed, 19 Oct 2011 17:23:23 -0700
Message-Id: <1319070203-22097-3-git-send-email-thomas@cozybit.com> (sfid-20111020_022337_344901_EBB0C761)
In-Reply-To: <1319070203-22097-1-git-send-email-thomas@cozybit.com>
References: <1319070203-22097-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set proper queue mapping and timestamp for forwarded mesh frames. 

Thanks to Luis Rodriguez for investigating and fixing this.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/rx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b867bd5..8c03d6e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1952,6 +1952,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 			info = IEEE80211_SKB_CB(fwd_skb);
 			memset(info, 0, sizeof(*info));
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
+			info->control.jiffies = jiffies;
 			info->control.vif = &rx->sdata->vif;
 			if (is_multicast_ether_addr(fwd_hdr->addr1)) {
 				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
@@ -1974,6 +1975,10 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 				if (err)
 					return RX_DROP_MONITOR;
 
+				skb_set_queue_mapping(fwd_skb,
+					ieee80211_select_queue(sdata, fwd_skb));
+				ieee80211_set_qos_hdr(sdata, fwd_skb);
+
 				IEEE80211_IFSTA_MESH_CTR_INC(&sdata->u.mesh,
 								fwded_unicast);
 			}
-- 
1.7.5.4

