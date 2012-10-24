Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48279 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935311Ab2JXTnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 15:43:41 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so592058pad.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 12:43:41 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linville@tuxdriver.com
Cc: Javier Cardona <javier@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	johannes@sipsolutions.net
Subject: [PATCH 2/2] mac80211: Don't drop frames received with mesh ttl == 1
Date: Wed, 24 Oct 2012 12:43:31 -0700
Message-Id: <1351107811-6661-2-git-send-email-javier@cozybit.com> (sfid-20121024_214446_072197_3DEAD80F)
In-Reply-To: <1351107811-6661-1-git-send-email-javier@cozybit.com>
References: <1351107811-6661-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prior this fix, those frames were not received, nor forwarded.  Fix
this to receive and not forward.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1222127..f73e0dd 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1944,7 +1944,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 
 	if (!--mesh_hdr->ttl) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_ttl);
-		return RX_DROP_MONITOR;
+		goto out;
 	}
 
 	if (!ifmsh->mshcfg.dot11MeshForwarding)
-- 
1.7.5.4

