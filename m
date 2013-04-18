Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936446Ab3DRVq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 17:46:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: david.spinadel@intel.com, arend@broadcom.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix P2P-Device management frame RX
Date: Thu, 18 Apr 2013 23:46:46 +0200
Message-Id: <1366321606-10967-1-git-send-email-johannes@sipsolutions.net> (sfid-20130418_234701_386587_D5A8A956)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's an issue in receiving broadcast management frames
on P2P Device virtual interfaces, such frames have the RX
flag IEEE80211_RX_RA_MATCH cleared and are thus dropped
in ieee80211_rx_h_mgmt_check(). They should be let through
to make it to ieee80211_rx_h_userspace_mgmt() and then to
userspace.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 643fcf7..14b32a4 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3043,7 +3043,8 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 		    !ieee80211_is_probe_resp(hdr->frame_control) &&
 		    !ieee80211_is_beacon(hdr->frame_control))
 			return 0;
-		if (!ether_addr_equal(sdata->vif.addr, hdr->addr1))
+		if (!ether_addr_equal(sdata->vif.addr, hdr->addr1) &&
+		    !multicast)
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		break;
 	default:
-- 
1.8.0

