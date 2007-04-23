Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:23303 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161548AbXDWS6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 14:58:20 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 10/13] mac80211: set bssid to broadcast before scan
Date: Mon, 23 Apr 2007 14:48:14 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070423184814.7029.99423.stgit@magic.sourmilk.net>
In-Reply-To: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This patch sets the BSSID to broadcast before scanning to ensure that the
hardware filter does not filter probe responses.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c     |    6 +++++-
 net/mac80211/ieee80211_i.h   |    1 +
 net/mac80211/ieee80211_sta.c |   10 ++++++++++
 3 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index ddb8153..17c6fde 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2023,7 +2023,11 @@ static int __ieee80211_if_config(struct net_device *dev,
 	conf.type = sdata->type;
 	if (sdata->type == IEEE80211_IF_TYPE_STA ||
 	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
-		conf.bssid = sdata->u.sta.bssid;
+		if (local->sta_scanning &&
+		    local->scan_dev == dev)
+			conf.bssid = local->scan_bssid;
+		else
+			conf.bssid = sdata->u.sta.bssid;
 		conf.ssid = sdata->u.sta.ssid;
 		conf.ssid_len = sdata->u.sta.ssid_len;
 		conf.generic_elem = sdata->u.sta.extra_ie;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6b3e1c5..fe638a9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -502,6 +502,7 @@ struct ieee80211_local {
 	struct ieee80211_hw_mode *oper_hw_mode, *scan_hw_mode;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
 	size_t scan_ssid_len;
+	u8 scan_bssid[ETH_ALEN];
 	struct list_head sta_bss_list;
 	struct ieee80211_sta_bss *sta_bss_hash[STA_HASH_SIZE];
 	spinlock_t sta_bss_lock;
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 7cb2dd3..20bd77b 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2577,6 +2577,10 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 		printk(KERN_DEBUG "%s: failed to restore operational"
 		       "channel after scan\n", dev->name);
 
+	if (ieee80211_if_config(dev))
+		printk(KERN_DEBUG "%s: failed to restore operational"
+		       "BSSID after scan\n", dev->name);
+
 	memset(&wrqu, 0, sizeof(wrqu));
 	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
 
@@ -2730,12 +2734,18 @@ static int ieee80211_sta_start_scan(struct net_device *dev,
 		memcpy(local->scan_ssid, ssid, ssid_len);
 	} else
 		local->scan_ssid_len = 0;
+	memset(local->scan_bssid, ~0, ETH_ALEN);
 	local->scan_state = SCAN_SET_CHANNEL;
 	local->scan_hw_mode = list_entry(local->modes_list.next,
 					 struct ieee80211_hw_mode,
 					 list);
 	local->scan_channel_idx = 0;
 	local->scan_dev = dev;
+
+	if (ieee80211_if_config(dev))
+		printk(KERN_DEBUG "%s: failed to set BSSID for scan\n",
+		       dev->name);
+
 	/* TODO: start scan as soon as all nullfunc frames are ACKed */
 	queue_delayed_work(local->hw.workqueue, &local->scan_work,
 			   IEEE80211_CHANNEL_TIME);

