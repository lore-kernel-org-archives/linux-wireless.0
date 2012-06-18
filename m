Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46897 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914Ab2FRK6H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 06:58:07 -0400
From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <lukasz.kucharczyk@tieto.com>
Subject: [RFC 4/5] mac80211: move multicast list to subif.
Date: Mon, 18 Jun 2012 12:57:14 +0200
Message-ID: <1340017035-7657-5-git-send-email-lukasz.kucharczyk@tieto.com> (sfid-20120618_125815_912411_45395F52)
In-Reply-To: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com>
References: <1340017035-7657-1-git-send-email-lukasz.kucharczyk@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Multicast address list is now kept in ieee80211_sub_if_data.

Signed-off-by: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
---
 net/mac80211/ieee80211_i.h |    6 +++---
 net/mac80211/iface.c       |    6 ++++--
 net/mac80211/main.c        |    4 +---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2dc7aa2..54cec8f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -732,6 +732,9 @@ struct ieee80211_sub_if_data {
 
 	unsigned int filter_flags, req_filt_flags; /* FIF_* */
 
+	/* aggregated multicast list */
+	struct netdev_hw_addr_list mc_list;
+
 	/* must be last, dynamically sized area in this! */
 	struct ieee80211_vif vif;
 };
@@ -849,9 +852,6 @@ struct ieee80211_local {
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
 
-	/* aggregated multicast list */
-	struct netdev_hw_addr_list mc_list;
-
 	bool tim_in_locked_section; /* see ieee80211_beacon_get() */
 
 	/*
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8e6eebd..f452c41 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -535,7 +535,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	netif_addr_lock_bh(sdata->dev);
 	spin_lock_bh(&sdata->filter_lock);
-	__hw_addr_unsync(&local->mc_list, &sdata->dev->mc,
+	__hw_addr_unsync(&sdata->mc_list, &sdata->dev->mc,
 			 sdata->dev->addr_len);
 	spin_unlock_bh(&sdata->filter_lock);
 	netif_addr_unlock_bh(sdata->dev);
@@ -701,7 +701,7 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
 		sdata->flags ^= IEEE80211_SDATA_PROMISC;
 
 	spin_lock_bh(&sdata->filter_lock);
-	__hw_addr_sync(&local->mc_list, &dev->mc, dev->addr_len);
+	__hw_addr_sync(&sdata->mc_list, &dev->mc, dev->addr_len);
 	spin_unlock_bh(&sdata->filter_lock);
 	ieee80211_queue_work(&local->hw, &sdata->reconfig_filter);
 }
@@ -957,6 +957,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	INIT_WORK(&sdata->work, ieee80211_iface_work);
 	INIT_WORK(&sdata->reconfig_filter, ieee80211_reconfig_filter);
 
+	__hw_addr_init(&sdata->mc_list);
+
 	switch (type) {
 	case NL80211_IFTYPE_P2P_GO:
 		type = NL80211_IFTYPE_AP;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 057e098..b00eb59 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -67,7 +67,7 @@ void ieee80211_configure_filter(struct ieee80211_sub_if_data *sdata)
 	spin_lock_bh(&sdata->filter_lock);
 	changed_flags = sdata->filter_flags ^ new_flags;
 
-	mc = drv_prepare_multicast(local, &local->mc_list);
+	mc = drv_prepare_multicast(local, &sdata->mc_list);
 	spin_unlock_bh(&sdata->filter_lock);
 
 	/* be a bit nasty */
@@ -591,8 +591,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	INIT_LIST_HEAD(&local->interfaces);
 
-	__hw_addr_init(&local->mc_list);
-
 	mutex_init(&local->iflist_mtx);
 	mutex_init(&local->mtx);
 
-- 
1.7.0.4

