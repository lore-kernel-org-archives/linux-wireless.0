Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57706 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150AbZKEOaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 09:30:06 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1N63Ln-0002dU-0Q
	for linux-wireless@vger.kernel.org; Thu, 05 Nov 2009 09:30:11 -0500
Received: from linville-t400.local (linville-t400.local [127.0.0.1])
	by linville-t400.local (8.14.3/8.14.3) with ESMTP id nA5ENqLP002934
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2009 09:23:52 -0500
Received: (from linville@localhost)
	by linville-t400.local (8.14.3/8.14.3/Submit) id nA5ENqbY002933
	for linux-wireless@vger.kernel.org; Thu, 5 Nov 2009 09:23:52 -0500
Message-ID: <4AF2A3B0.4030100@gmail.com>
Date: Thu, 05 Nov 2009 11:06:40 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: Linux Netdev List <netdev@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH net-next-2.6] mac80211: Speedup ieee80211_remove_interfaces()
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Speedup ieee80211_remove_interfaces() by factorizing synchronize_rcu() calls

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/mac80211/iface.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 14f10eb..a445f50 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -852,22 +852,18 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 void ieee80211_remove_interfaces(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata, *tmp;
+	LIST_HEAD(unreg_list);
 
 	ASSERT_RTNL();
 
+	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
-		/*
-		 * we cannot hold the iflist_mtx across unregister_netdevice,
-		 * but we only need to hold it for list modifications to lock
-		 * out readers since we're under the RTNL here as all other
-		 * writers.
-		 */
-		mutex_lock(&local->iflist_mtx);
 		list_del(&sdata->list);
-		mutex_unlock(&local->iflist_mtx);
 
-		unregister_netdevice(sdata->dev);
+		unregister_netdevice_queue(sdata->dev, &unreg_list);
 	}
+	mutex_unlock(&local->iflist_mtx);
+	unregister_netdevice_many(&unreg_list);
 }
 
 static u32 ieee80211_idle_off(struct ieee80211_local *local,

