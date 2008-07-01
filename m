Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:40841 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759AbYGAOsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 10:48:54 -0400
Message-ID: <486A43D0.8020507@work.ksp.sk> (sfid-20080701_164900_989726_4F4EC116)
Date: Tue, 01 Jul 2008 16:48:48 +0200
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	bruno randolf <bruno@thinktube.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] mac80211: fix alternating-BSSID issue in IBSS
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to the fact that we (still) keep old BSS information, we can end
up switching between 2 or more BSSIDs when in IBSS (these are the
BSSIDs of networks with the same name we've seen before, even if they
are not around anymore). This switching happens in 30sec intervals
(IBSS merge attempt when no active STAs are around).

This patch expires old BSS entries after IEEE80211_SCAN_RESULT_EXPIRE
seconds (the same time after it will not be reported in scan results)
when trying to merge.

Signed-off-by: Vladimir Koutny <vlado@ksp.sk>

---

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2b49852..b9ec4f6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3276,12 +3276,32 @@ static void ieee80211_sta_expire(struct net_device *dev, unsigned long exp_time)
 }


+static void ieee80211_bss_expire(struct net_device *dev, unsigned long exp_time)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sta_bss *bss, *tmp;
+	DECLARE_MAC_BUF(mac);
+
+	spin_lock_bh(&local->sta_bss_lock);
+	list_for_each_entry_safe(bss, tmp, &local->sta_bss_list, list) {
+		if (time_after(jiffies, bss->last_update + exp_time)) {
+#ifdef CONFIG_MAC80211_IBSS_DEBUG
+			printk(KERN_DEBUG "%s: expiring inactive BSS %s\n",
+				dev->name, print_mac(mac, bss->bssid));
+#endif /* CONFIG_MAC80211_IBSS_DEBUG */
+			ieee80211_rx_bss_put(dev, bss);
+		}
+	}
+	spin_unlock_bh(&local->sta_bss_lock);
+}
+
 static void ieee80211_sta_merge_ibss(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta)
 {
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);

 	ieee80211_sta_expire(dev, IEEE80211_IBSS_INACTIVITY_LIMIT);
+	ieee80211_bss_expire(dev, IEEE80211_SCAN_RESULT_EXPIRE);
 	if (ieee80211_sta_active_ibss(dev))
 		return;

@@ -3662,8 +3662,10 @@ static int ieee80211_sta_find_ibss(struct net_device *dev,
 	spin_unlock_bh(&local->sta_bss_lock);

 #ifdef CONFIG_MAC80211_IBSS_DEBUG
-	printk(KERN_DEBUG "   sta_find_ibss: selected %s current "
-	       "%s\n", print_mac(mac, bssid), print_mac(mac2, ifsta->bssid));
+	if (found)
+		printk(KERN_DEBUG "   sta_find_ibss: selected %s current "
+		       "%s\n", print_mac(mac, bssid),
+		       print_mac(mac2, ifsta->bssid));
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0 &&
 	    (bss = ieee80211_rx_bss_get(dev, bssid,
