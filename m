Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21588 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935906AbYEUPRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 11:17:36 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: fix ieee80211_rx_bss_put/get imbalance
Date: Wed, 21 May 2008 18:17:05 +0300
Message-Id: <1211383025-1004-1-git-send-email-tomas.winkler@intel.com> (sfid-20080521_171742_743335_A51F775B)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes iee80211_rx_bss_put/get imbalance
introduced by 'mac80211: enable IBSS merging' patch.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7cfd12e..0ef5993 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2479,8 +2479,6 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
 	ifsta->state = IEEE80211_IBSS_JOINED;
 	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
 
-	ieee80211_rx_bss_put(dev, bss);
-
 	return res;
 }
 
@@ -3523,6 +3521,7 @@ static int ieee80211_sta_create_ibss(struct net_device *dev,
 	struct ieee80211_supported_band *sband;
 	u8 bssid[ETH_ALEN], *pos;
 	int i;
+	int ret;
 	DECLARE_MAC_BUF(mac);
 
 #if 0
@@ -3567,7 +3566,9 @@ static int ieee80211_sta_create_ibss(struct net_device *dev,
 		*pos++ = (u8) (rate / 5);
 	}
 
-	return ieee80211_sta_join_ibss(dev, ifsta, bss);
+	ret = ieee80211_sta_join_ibss(dev, ifsta, bss);
+	ieee80211_rx_bss_put(dev, bss);
+	return ret;
 }
 
 
@@ -3615,10 +3616,13 @@ static int ieee80211_sta_find_ibss(struct net_device *dev,
 	    (bss = ieee80211_rx_bss_get(dev, bssid,
 					local->hw.conf.channel->center_freq,
 					ifsta->ssid, ifsta->ssid_len))) {
+		int ret;
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID %s"
 		       " based on configured SSID\n",
 		       dev->name, print_mac(mac, bssid));
-		return ieee80211_sta_join_ibss(dev, ifsta, bss);
+		ret = ieee80211_sta_join_ibss(dev, ifsta, bss);
+		ieee80211_rx_bss_put(dev, bss);
+		return ret;
 	}
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "   did not try to join ibss\n");
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

