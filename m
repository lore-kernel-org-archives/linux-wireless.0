Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39112 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297AbZJSVze (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 17:55:34 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] mac80211: fix ibss joining
Date: Mon, 19 Oct 2009 14:55:37 -0700
Message-Id: <1255989337-25473-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Recent commit "mac80211: fix logic error ibss merge bssid check" fixed
joining of ibss cell when static bssid is provided. In this case
ifibss->bssid is set before the cell is joined and comparing that address
to a bss should thus always succeed. Unfortunately this change broke the
other case of joining a ibss cell without providing a static bssid where
the value of ifibss->bssid is not set before the cell is joined.

Since ifibss->bssid may be set before or after joining the cell we do not
learn anything by comparing it to a known bss. Remove this check.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
I tested this change with static bssid and without.

The symptom without this patch is that it is not possible to join an ad-hoc
cell unless you provide a bssid. When you want to join an existing cell a
new cell will be created.

 net/mac80211/ibss.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 6eaf698..ca8ecce 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -538,13 +538,12 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 				       WLAN_CAPABILITY_PRIVACY,
 				       capability);
 
+	if (bss) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
-	if (bss)
 		printk(KERN_DEBUG "   sta_find_ibss: selected %pM current "
 		       "%pM\n", bss->cbss.bssid, ifibss->bssid);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 
-	if (bss && !memcmp(ifibss->bssid, bss->cbss.bssid, ETH_ALEN)) {
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID %pM"
 		       " based on configured SSID\n",
 		       sdata->dev->name, bss->cbss.bssid);
@@ -552,8 +551,7 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 		ieee80211_sta_join_ibss(sdata, bss);
 		ieee80211_rx_bss_put(local, bss);
 		return;
-	} else if (bss)
-		ieee80211_rx_bss_put(local, bss);
+	}
 
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "   did not try to join ibss\n");
-- 
1.5.6.3

