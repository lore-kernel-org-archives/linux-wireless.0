Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rousseau.luceor.com ([91.121.31.107]:38712 "EHLO sro-lap"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260Ab2ITIDj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 04:03:39 -0400
From: yes@test.org
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
Subject: [PATCH] mac80211 : Fix Ibss debug message Tx authentication
Date: Thu, 20 Sep 2012 10:03:29 +0200
Message-Id: <1348128209-2625-1-git-send-email-yes> (sfid-20120920_100430_413851_1FAC97E7)
In-Reply-To: <yesy>
References: <yesy>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>

In ibss debug message Tx authentication BSSID and DA address Were reversed

Signed-off-by: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
---
 net/mac80211/ibss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index a9d9328..a4f7d37 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -278,7 +278,7 @@ static struct sta_info *ieee80211_ibss_finish_sta(struct sta_info *sta,
 	if (auth && !sdata->u.ibss.auth_frame_registrations) {
 		ibss_dbg(sdata,
 			 "TX Auth SA=%pM DA=%pM BSSID=%pM (auth_transaction=1)\n",
-			 sdata->vif.addr, sdata->u.ibss.bssid, addr);
+			 sdata->vif.addr, addr, sdata->u.ibss.bssid);
 		ieee80211_send_auth(sdata, 1, WLAN_AUTH_OPEN, NULL, 0,
 				    addr, sdata->u.ibss.bssid, NULL, 0, 0);
 	}
-- 
1.7.9.5

