Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55344 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZCMKUU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 06:20:20 -0400
Subject: [PATCH] mac80211: fix warnings in ieee80211_if_config
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 11:19:45 +0100
Message-Id: <1236939585.5235.2.camel@johannes.local> (sfid-20090313_112023_202648_DEE8F491)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The last warning can never trigger, and the explicit AP_VLAN
check is pointless if we move the config_interface check down,
in practice config_interface is required anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- wireless-testing.orig/net/mac80211/main.c	2009-03-13 10:44:41.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-03-13 10:45:22.000000000 +0100
@@ -161,12 +161,6 @@ int ieee80211_if_config(struct ieee80211
 	if (WARN_ON(!netif_running(sdata->dev)))
 		return 0;
 
-	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN))
-		return -EINVAL;
-
-	if (!local->ops->config_interface)
-		return 0;
-
 	memset(&conf, 0, sizeof(conf));
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
@@ -183,6 +177,9 @@ int ieee80211_if_config(struct ieee80211
 		return -EINVAL;
 	}
 
+	if (!local->ops->config_interface)
+		return 0;
+
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_ADHOC:
@@ -224,9 +221,6 @@ int ieee80211_if_config(struct ieee80211
 		}
 	}
 
-	if (WARN_ON(!conf.bssid && (changed & IEEE80211_IFCC_BSSID)))
-		return -EINVAL;
-
 	conf.changed = changed;
 
 	return local->ops->config_interface(local_to_hw(local),


