Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:14441 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751926AbXB1U6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 15:58:41 -0500
Received: from localhost (localhost.rutgers.edu [127.0.0.1])
	by annwn13.rutgers.edu (Postfix) with ESMTP id 7801B32405D
	for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 15:58:40 -0500 (EST)
Received: from annwn13.rutgers.edu ([127.0.0.1])
	by localhost (annwn13.rutgers.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 25664-08 for <linux-wireless@vger.kernel.org>;
	Wed, 28 Feb 2007 15:58:40 -0500 (EST)
Received: from [192.168.1.103] (resnet-172.23.52.117.resnet.rutgers.edu [172.23.52.117])
	by annwn13.rutgers.edu (Postfix) with ESMTP id 61CEA32403F
	for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 15:58:40 -0500 (EST)
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 3/5] d80211: Set carrier status for STA interfaces
Date: Wed, 28 Feb 2007 15:39:43 -0500
To: linux-wireless@vger.kernel.org
Message-Id: <20070228203943.11473.36193.stgit@magic.sourmilk.net>
In-Reply-To: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This makes STA interfaces set the carrier status based on the current
association status.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c     |    4 ++++
 net/mac80211/ieee80211_sta.c |    3 +++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 15344c7..a0879ba 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2377,6 +2377,10 @@ static int ieee80211_open(struct net_dev
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
 
 

