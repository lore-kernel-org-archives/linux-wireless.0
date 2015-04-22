Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54710 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480AbbDVNZl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 09:25:41 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211: OCB: remove pointless check for broadcast BSSID
Date: Wed, 22 Apr 2015 15:25:22 +0200
Message-Id: <1429709122-13734-4-git-send-email-johannes@sipsolutions.net> (sfid-20150422_152549_426862_1EAE0A42)
In-Reply-To: <1429709122-13734-1-git-send-email-johannes@sipsolutions.net>
References: <1429709122-13734-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The OCB input path already checked that the BSSID is the broadcast
address, so the later check can never fail.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5fea34b158fe..11dbbc576491 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1362,11 +1362,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 			}
 		}
 	} else if (rx->sdata->vif.type == NL80211_IFTYPE_OCB) {
-		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len,
-						NL80211_IFTYPE_OCB);
-		/* OCB uses wild-card BSSID */
-		if (is_broadcast_ether_addr(bssid))
-			sta->last_rx = jiffies;
+		sta->last_rx = jiffies;
 	} else if (!is_multicast_ether_addr(hdr->addr1)) {
 		/*
 		 * Mesh beacons will update last_rx when if they are found to
-- 
2.1.4

