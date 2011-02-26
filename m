Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33291 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1BZBdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 20:33:22 -0500
Received: by mail-gy0-f174.google.com with SMTP id 20so933722gyh.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 17:33:21 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>
Subject: [PATCH 3/5] mac80211: Accept mesh auth frames before a peer link has been established
Date: Fri, 25 Feb 2011 17:32:38 -0800
Message-Id: <1298683960-20835-4-git-send-email-thomas@cozybit.com>
In-Reply-To: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
References: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

---
 net/mac80211/rx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 045b2fe..670e304 100644
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

