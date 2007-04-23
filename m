Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:9493 "EHLO annwn14.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161542AbXDWS6T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 14:58:19 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 07/13] mac80211: fix configuration concurrency issues in ieee80211_sta.c
Date: Mon, 23 Apr 2007 14:48:13 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070423184813.7029.81396.stgit@magic.sourmilk.net>
In-Reply-To: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This prevents userspace and the in-kernel MLME from configuring
channel/BSSID/SSID at the same time when the in-kernel MLME is in the midst
of automatic AP selection. This is done by holding the RTNL lock.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211_sta.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 0e9e4f9..04a63a7 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2068,9 +2068,12 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 	struct ieee80211_sta_bss *bss, *selected = NULL;
 	int top_rssi = 0, freq;
 
+	rtnl_lock();
+
 	if (!ifsta->auto_channel_sel && !ifsta->auto_bssid_sel &&
 	    !ifsta->auto_ssid_sel) {
 		ifsta->state = IEEE80211_AUTHENTICATE;
+		rtnl_unlock();
 		ieee80211_sta_reset_auth(dev, ifsta);
 		return 0;
 	}
@@ -2113,6 +2116,7 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 		ieee80211_sta_set_bssid(dev, selected->bssid);
 		ieee80211_rx_bss_put(dev, selected);
 		ifsta->state = IEEE80211_AUTHENTICATE;
+		rtnl_unlock();
 		ieee80211_sta_reset_auth(dev, ifsta);
 		return 0;
 	} else {
@@ -2123,6 +2127,7 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 		} else
 			ifsta->state = IEEE80211_DISABLED;
 	}
+	rtnl_unlock();
 	return -1;
 }
 

