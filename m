Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64504 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab1BLNSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 08:18:50 -0500
Received: by bwz15 with SMTP id 15so4072880bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 Feb 2011 05:18:49 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John W Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Remove superfluous if clause
Date: Sat, 12 Feb 2011 14:17:15 +0100
Message-Id: <1297516635-6892-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_rx_h_check returned RX_DROP_MONITOR in case the if statement
in question was true but the same return value is also used directly
after the if clause. Hence, we can just drop the whole if clause and as
such simplify the code.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/rx.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 045b2fe..f502634 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -832,18 +832,8 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 		      ieee80211_is_pspoll(hdr->frame_control)) &&
 		     rx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
 		     rx->sdata->vif.type != NL80211_IFTYPE_WDS &&
-		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC)))) {
-		if ((!ieee80211_has_fromds(hdr->frame_control) &&
-		     !ieee80211_has_tods(hdr->frame_control) &&
-		     ieee80211_is_data(hdr->frame_control)) ||
-		    !(status->rx_flags & IEEE80211_RX_RA_MATCH)) {
-			/* Drop IBSS frames and frames for other hosts
-			 * silently. */
-			return RX_DROP_MONITOR;
-		}
-
+		     (!rx->sta || !test_sta_flags(rx->sta, WLAN_STA_ASSOC))))
 		return RX_DROP_MONITOR;
-	}
 
 	return RX_CONTINUE;
 }
-- 
1.7.1

