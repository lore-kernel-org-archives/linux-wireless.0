Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53183 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab1CEBZh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 20:25:37 -0500
Received: by pwi15 with SMTP id 15so457395pwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 17:25:37 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/4 v2] mac80211: Accept mesh auth frames before a peer link has been established
Date: Fri,  4 Mar 2011 17:24:11 -0800
Message-Id: <1299288252-28314-4-git-send-email-thomas@cozybit.com>
In-Reply-To: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>


Signed-off-by: Javier Cardona <javier@cozybit.com>
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
1.7.1

