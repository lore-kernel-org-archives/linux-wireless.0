Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34457 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935433Ab2JXTnj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 15:43:39 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so1439666pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 12:43:39 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linville@tuxdriver.com
Cc: Javier Cardona <javier@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	johannes@sipsolutions.net
Subject: [PATCH 1/2] mac80211: Only process mesh config header on frames that RA_MATCH
Date: Wed, 24 Oct 2012 12:43:30 -0700
Message-Id: <1351107811-6661-1-git-send-email-javier@cozybit.com> (sfid-20121024_214450_273660_0073FC15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Doing otherwise is wrong, and may wreak havoc on the mpp tables,
specially if the frame is encrypted.

Reported-by: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/rx.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 61c621e..1222127 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1897,7 +1897,8 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	    mesh_rmc_check(hdr->addr3, mesh_hdr, rx->sdata))
 		return RX_DROP_MONITOR;
 
-	if (!ieee80211_is_data(hdr->frame_control))
+	if (!ieee80211_is_data(hdr->frame_control) ||
+	    !(status->rx_flags & IEEE80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
 	if (!mesh_hdr->ttl)
@@ -1941,9 +1942,6 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	}
 	skb_set_queue_mapping(skb, q);
 
-	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
-		goto out;
-
 	if (!--mesh_hdr->ttl) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_ttl);
 		return RX_DROP_MONITOR;
-- 
1.7.5.4

