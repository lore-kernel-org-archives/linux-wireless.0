Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48995 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934194AbXCWUnc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:32 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/19] mac80211: Set carrier status for STA interfaces
Message-Id: <20070323204448.7F593484C4@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:44:48 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This makes STA interfaces set the carrier status based on the current
association status.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/ieee80211.c     |    4 ++++
 net/mac80211/ieee80211_sta.c |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

22abe7f30c0e34ac94eda86e6aad66f74e582317
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 18caa2b..30330b9 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2368,6 +2368,10 @@ static int ieee80211_open(struct net_dev
 	else
 		ieee80211_if_config(dev);
 
+	if (sdata->type == IEEE80211_IF_TYPE_STA &&
+	    !local->user_space_mlme)
+		netif_carrier_off(dev);
+
 	netif_start_queue(dev);
 	return 0;
 }
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index a264008..9d08a37 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -375,11 +375,13 @@ static void ieee80211_set_associated(str
 		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 		if (sdata->type != IEEE80211_IF_TYPE_STA)
 			return;
+		netif_carrier_on(dev);
 		ifsta->prev_bssid_set = 1;
 		memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
 		memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
 		ieee80211_sta_send_associnfo(dev, ifsta);
 	} else {
+		netif_carrier_off(dev);
 		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
 	}
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
@@ -2007,6 +2009,7 @@ static void ieee80211_sta_reset_auth(str
 	       ifsta->auth_alg);
 	ifsta->auth_transaction = -1;
 	ifsta->associated = ifsta->auth_tries = ifsta->assoc_tries = 0;
+	netif_carrier_off(dev);
 }
 
 
-- 
1.3.0

