Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60860 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaDUEzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 00:55:22 -0400
Received: by mail-pa0-f43.google.com with SMTP id bj1so3348359pad.2
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 21:55:22 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 10/12] mac80211: change return value of notifier function
Date: Mon, 21 Apr 2014 12:53:05 +0800
Message-Id: <7336424bc39404833509efc7fc9bf0ba0af450f1.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065550_240165_106A1923)
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return NOTIFY_DONE if we don't care this time's notification, return
NOTIFY_OK if we successfully handled this time's notification. That's
the formal way to do it.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/iface.c | 11 +++++------
 net/mac80211/main.c  |  4 ++--
 net/mac80211/mlme.c  |  2 +-
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 90b6063..4da6c71 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1785,20 +1785,19 @@ static int netdev_notify(struct notifier_block *nb,
 	struct ieee80211_sub_if_data *sdata;
 
 	if (state != NETDEV_CHANGENAME)
-		return 0;
+		return NOTIFY_DONE;
 
 	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy)
-		return 0;
+		return NOTIFY_DONE;
 
 	if (dev->ieee80211_ptr->wiphy->privid != mac80211_wiphy_privid)
-		return 0;
+		return NOTIFY_DONE;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
 	memcpy(sdata->name, dev->name, IFNAMSIZ);
-
 	ieee80211_debugfs_rename_netdev(sdata);
-	return 0;
+
+	return NOTIFY_OK;
 }
 
 static struct notifier_block mac80211_netdev_notifier = {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b83a913..4762711 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -338,7 +338,7 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 
 	sdata_unlock(sdata);
 
-	return NOTIFY_DONE;
+	return NOTIFY_OK;
 }
 #endif
 
@@ -369,7 +369,7 @@ static int ieee80211_ifa6_changed(struct notifier_block *nb,
 
 	drv_ipv6_addr_change(local, sdata, idev);
 
-	return NOTIFY_DONE;
+	return NOTIFY_OK;
 }
 #endif
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1e1bdd2..66047cd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3701,7 +3701,7 @@ int ieee80211_max_network_latency(struct notifier_block *nb,
 	ieee80211_recalc_ps(local, latency_usec);
 	mutex_unlock(&local->iflist_mtx);
 
-	return 0;
+	return NOTIFY_OK;
 }
 
 static u8 ieee80211_ht_vht_rx_chains(struct ieee80211_sub_if_data *sdata,
-- 
1.9.0

