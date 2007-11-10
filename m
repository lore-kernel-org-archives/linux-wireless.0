Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:39392 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750847AbXKJFQz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2007 00:16:55 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] mac80211: Drop out of associated state if link is lost
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Stefano Brivio <stefano.brivio@polimi.it>
Date: Sat, 10 Nov 2007 00:15:25 -0500
Message-ID: <20071110051525.5451.82213.stgit@tetra.sourmilk.net> (sfid-20071110_051659_883004_3581E5E7)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no point in staying in IEEE80211_ASSOCIATED if there is no
sta_info entry to receive frames with.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211_sta.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 2079e98..271a56a 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -808,12 +808,8 @@ static void ieee80211_associated(struct net_device *dev,
 		sta_info_put(sta);
 	}
 	if (disassoc) {
-		union iwreq_data wrqu;
-		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
-		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-		wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
-		mod_timer(&ifsta->timer, jiffies +
-				      IEEE80211_MONITORING_INTERVAL + 30 * HZ);
+		ifsta->state = IEEE80211_DISABLED;
+		ieee80211_set_associated(dev, ifsta, 0);
 	} else {
 		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_MONITORING_INTERVAL);


