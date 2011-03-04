Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43513 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526Ab1CDDLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 22:11:55 -0500
Received: by yxs7 with SMTP id 7so614063yxs.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 19:11:54 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: devel@lists.open80211s.org, Javier Cardona <javier@cozybit.com>
Subject: [PATCH 4/7] mac80211: Accept mesh auth frames before a peer link has been established
Date: Thu,  3 Mar 2011 19:11:44 -0800
Message-Id: <1299208307-9428-5-git-send-email-thomas@cozybit.com>
In-Reply-To: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Signed-off-by: Javier Cardona <javier@cozybit.com>
Tested-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/rx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5c1930b..fe0f1e3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -502,7 +502,8 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
 
 		if (ieee80211_is_probe_req(hdr->frame_control) ||
 		    ieee80211_is_probe_resp(hdr->frame_control) ||
-		    ieee80211_is_beacon(hdr->frame_control))
+		    ieee80211_is_beacon(hdr->frame_control) ||
+		    ieee80211_is_auth(hdr->frame_control))
 			return RX_CONTINUE;
 
 		return RX_DROP_MONITOR;
-- 
1.7.0.4

