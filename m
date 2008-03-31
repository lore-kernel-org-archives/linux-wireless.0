Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:10814 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYDABCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 21:02:40 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1845560wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 18:02:39 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Cc: johannes@sipsolutions.net
Date: Mon, 31 Mar 2008 15:33:39 -0700
Subject: [PATCH] mac80211: use recent multicast table for all mesh multicast frames, not only broadcast
Message-ID: <47f189af.09038e0a.2eb1.ffffb304@mx.google.com> (sfid-20080401_020245_671873_3F8ED82F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d9c6ed5..0ac6db5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -433,7 +433,7 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 		}
 
 	 } else if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
-		    is_broadcast_ether_addr(hdr->addr1) &&
+		    is_multicast_ether_addr(hdr->addr1) &&
 		    mesh_rmc_check(hdr->addr4, msh_h_get(hdr, hdrlen), rx->dev))
 		return RX_DROP_MONITOR;
 #undef msh_h_get
-- 
1.5.4.3



