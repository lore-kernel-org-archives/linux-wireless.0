Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45442 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbbC3HwU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 03:52:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Louis Langholtz <lou_langholtz@me.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: send AP probe as unicast again
Date: Mon, 30 Mar 2015 09:52:17 +0200
Message-Id: <1427701937-27922-1-git-send-email-johannes@sipsolutions.net> (sfid-20150330_095223_721833_FE28C0B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Louis reported that a static checker was complaining that
the 'dst' variable was set (multiple times) but not used.
This is due to a previous commit having removed the usage
(apparently erroneously), so add it back.

Fixes: a344d6778a98 ("mac80211: allow drivers to support NL80211_SCAN_FLAG_RANDOM_ADDR")
Reported-by: Louis Langholtz <lou_langholtz@me.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1999bc08fdcc..c22e7520d9b9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2233,7 +2233,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 		else
 			ssid_len = ssid[1];
 
-		ieee80211_send_probe_req(sdata, sdata->vif.addr, NULL,
+		ieee80211_send_probe_req(sdata, sdata->vif.addr, dst,
 					 ssid + 2, ssid_len, NULL,
 					 0, (u32) -1, true, 0,
 					 ifmgd->associated->channel, false);
-- 
2.1.4

