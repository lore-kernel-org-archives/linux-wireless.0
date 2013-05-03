Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:61092 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762292Ab3ECCg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 22:36:27 -0400
Received: by mail-pa0-f41.google.com with SMTP id rl6so682088pac.28
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 19:36:27 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>
Subject: [RFC 08/12] mac80211: forward group frames on mbss-shared interfaces
Date: Thu,  2 May 2013 19:33:58 -0700
Message-Id: <1367548442-8229-9-git-send-email-thomas@cozybit.com> (sfid-20130503_043630_611503_ADD7361D)
In-Reply-To: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

When multiple local interfaces are in the same MBSS, we should
forward group-directed data frames received on one interface
for transmit on the other interfaces, so that the frames may be
seen on other channels.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/rx.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0c5f870..850bfe3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2142,6 +2142,8 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 
 	IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_frames);
 	ieee80211_add_pending_skb(local, fwd_skb);
+	if (is_multicast_ether_addr(fwd_hdr->addr1))
+		mesh_bss_forward_tx(sdata, fwd_skb);
  out:
 	if (is_multicast_ether_addr(hdr->addr1) ||
 	    sdata->dev->flags & IFF_PROMISC)
-- 
1.7.10.4

