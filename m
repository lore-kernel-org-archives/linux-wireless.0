Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54736 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965128AbXBSWj2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 17:39:28 -0500
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070219233919.221549000.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/12] d80211: more wiphy API fixes
Message-Id: <20070219223957.3E845484B2@silver.suse.cz>
Date: Mon, 19 Feb 2007 23:39:57 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After resolving the conflict with John's tree, several things were still
broken. This patch fixes that, together with fixing one related GCC warning.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/d80211/ieee80211_cfg.c   |    2 +-
 net/d80211/ieee80211_ioctl.c |    6 +++---
 net/d80211/ieee80211_sta.c   |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

cec21de5adc61353fe43e6b931674a5f3f85206c
diff --git a/net/d80211/ieee80211_cfg.c b/net/d80211/ieee80211_cfg.c
index 82082ba..d6b2dff 100644
--- a/net/d80211/ieee80211_cfg.c
+++ b/net/d80211/ieee80211_cfg.c
@@ -15,7 +15,7 @@ static int ieee80211_list_interfaces(str
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *subif;
-	int err;
+	int err = 0;
 
 	spin_lock_bh(&local->sub_if_lock);
 	list_for_each_entry(subif, &local->sub_if_list, list) {
diff --git a/net/d80211/ieee80211_ioctl.c b/net/d80211/ieee80211_ioctl.c
index c9b116e..3a62495 100644
--- a/net/d80211/ieee80211_ioctl.c
+++ b/net/d80211/ieee80211_ioctl.c
@@ -1578,7 +1578,7 @@ static int ieee80211_ioctl_giwrange(stru
 				 struct iw_request_info *info,
 				 struct iw_point *data, char *extra)
 {
-	struct ieee80211_local *local = dev->ieee80211_ptr;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct iw_range *range = (struct iw_range *) extra;
 
 	data->length = sizeof(struct iw_range);
@@ -1839,7 +1839,7 @@ static int ieee80211_ioctl_siwfreq(struc
 				   struct iw_request_info *info,
 				   struct iw_freq *freq, char *extra)
 {
-	struct ieee80211_local *local = dev->ieee80211_ptr;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->type == IEEE80211_IF_TYPE_STA)
@@ -3055,7 +3055,7 @@ static int ieee80211_ioctl_siwauth(struc
 /* Get wireless statistics.  Called by /proc/net/wireless and by SIOCGIWSTATS */
 static struct iw_statistics *ieee80211_get_wireless_stats(struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(net_dev->ieee80211_ptr);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct iw_statistics *wstats = &local->wstats;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta = NULL;
diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
index 3d3d3f3..a6f461a 100644
--- a/net/d80211/ieee80211_sta.c
+++ b/net/d80211/ieee80211_sta.c
@@ -1903,7 +1903,7 @@ void ieee80211_sta_work(struct work_stru
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data, u.sta.work);
 	struct net_device *dev = sdata->dev;
-	struct ieee80211_local *local = dev->ieee80211_ptr;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_if_sta *ifsta;
 	struct sk_buff *skb;
 
@@ -2051,7 +2051,7 @@ static int ieee80211_sta_match_ssid(stru
 static int ieee80211_sta_config_auth(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta)
 {
-	struct ieee80211_local *local = dev->ieee80211_ptr;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_sta_bss *bss, *selected = NULL;
 	int top_rssi = 0, freq;
@@ -2690,7 +2690,7 @@ int ieee80211_sta_req_scan(struct net_de
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	struct ieee80211_local *local = dev->ieee80211_ptr;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
 	if (sdata->type != IEEE80211_IF_TYPE_STA)
 		return ieee80211_sta_start_scan(dev, ssid, ssid_len);
-- 
1.3.0

