Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:41959 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934653AbeEIMNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 08:13:49 -0400
Subject: [PATCH 3/3] net: Dynamically allocate struct station_info
From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Date: Wed, 09 May 2018 14:13:45 +0200
Message-ID: <152586802515.18089.12700714478750075562.stgit@alrua-kau> (sfid-20180509_141355_857728_4EC9B802)
In-Reply-To: <152586802501.18089.2502272945272741154.stgit@alrua-kau>
References: <152586802501.18089.2502272945272741154.stgit@alrua-kau>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the addition of the TXQ stats to cfg80211, the station_info struct
has grown to be quite large, which results in warnings when allocated on
the stack. Fix the affected places to do dynamic allocations instead.
WARN_ON is used where the function has no way to signal errors to the
caller.

This patch applies the fix to batman-adv and wext-compat, while a
separate patch fixes up the drivers.

Fixes: 52539ca89f36 cfg80211: Expose TXQ stats and parameters to userspace
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 net/batman-adv/bat_v_elp.c |   21 +++++++++++++++------
 net/wireless/wext-compat.c |   29 +++++++++++++++++------------
 2 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 28687493599f..d2393ebc6af4 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -79,8 +79,9 @@ static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
 	struct batadv_hard_iface *hard_iface = neigh->if_incoming;
 	struct ethtool_link_ksettings link_settings;
 	struct net_device *real_netdev;
-	struct station_info sinfo;
+	struct station_info *sinfo;
 	u32 throughput;
+	bool filled;
 	int ret;
 
 	/* if the user specified a customised value for this interface, then
@@ -102,7 +103,17 @@ static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
 		if (!real_netdev)
 			goto default_throughput;
 
-		ret = cfg80211_get_station(real_netdev, neigh->addr, &sinfo);
+		sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
+		if (!sinfo)
+			goto default_throughput;
+
+		ret = cfg80211_get_station(real_netdev, neigh->addr, sinfo);
+
+		/* just save these here instead of having complex free logic below */
+		throughput = sinfo.expected_throughput / 100;
+		filled = !!(sinfo.filled & BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT));
+
+		kfree(sinfo);
 
 		dev_put(real_netdev);
 		if (ret == -ENOENT) {
@@ -112,12 +123,10 @@ static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
 			 */
 			return 0;
 		}
-		if (ret)
-			goto default_throughput;
-		if (!(sinfo.filled & BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
+		if (ret || !filled)
 			goto default_throughput;
 
-		return sinfo.expected_throughput / 100;
+		return throughput;
 	}
 
 	/* if not a wifi interface, check if this device provides data via
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 9e002df0f8d8..2038e3fb25fa 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1300,7 +1300,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	/* we are under RTNL - globally locked - so can use static structs */
 	static struct iw_statistics wstats;
-	static struct station_info sinfo;
+	static struct station_info *sinfo;
 	u8 bssid[ETH_ALEN];
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION)
@@ -1318,17 +1318,21 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 	memcpy(bssid, wdev->current_bss->pub.bssid, ETH_ALEN);
 	wdev_unlock(wdev);
 
-	memset(&sinfo, 0, sizeof(sinfo));
+	sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
+	if (!sinfo)
+		return NULL;
 
-	if (rdev_get_station(rdev, dev, bssid, &sinfo))
+	if (rdev_get_station(rdev, dev, bssid, sinfo)) {
+		kfree(sinfo);
 		return NULL;
+	}
 
 	memset(&wstats, 0, sizeof(wstats));
 
 	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:
-		if (sinfo.filled & BIT(NL80211_STA_INFO_SIGNAL)) {
-			int sig = sinfo.signal;
+		if (sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL)) {
+			int sig = sinfo->signal;
 			wstats.qual.updated |= IW_QUAL_LEVEL_UPDATED;
 			wstats.qual.updated |= IW_QUAL_QUAL_UPDATED;
 			wstats.qual.updated |= IW_QUAL_DBM;
@@ -1341,11 +1345,11 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 			break;
 		}
 	case CFG80211_SIGNAL_TYPE_UNSPEC:
-		if (sinfo.filled & BIT(NL80211_STA_INFO_SIGNAL)) {
+		if (sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL)) {
 			wstats.qual.updated |= IW_QUAL_LEVEL_UPDATED;
 			wstats.qual.updated |= IW_QUAL_QUAL_UPDATED;
-			wstats.qual.level = sinfo.signal;
-			wstats.qual.qual = sinfo.signal;
+			wstats.qual.level = sinfo->signal;
+			wstats.qual.qual = sinfo->signal;
 			break;
 		}
 	default:
@@ -1354,11 +1358,12 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 	}
 
 	wstats.qual.updated |= IW_QUAL_NOISE_INVALID;
-	if (sinfo.filled & BIT(NL80211_STA_INFO_RX_DROP_MISC))
-		wstats.discard.misc = sinfo.rx_dropped_misc;
-	if (sinfo.filled & BIT(NL80211_STA_INFO_TX_FAILED))
-		wstats.discard.retries = sinfo.tx_failed;
+	if (sinfo->filled & BIT(NL80211_STA_INFO_RX_DROP_MISC))
+		wstats.discard.misc = sinfo->rx_dropped_misc;
+	if (sinfo->filled & BIT(NL80211_STA_INFO_TX_FAILED))
+		wstats.discard.retries = sinfo->tx_failed;
 
+	kfree(sinfo);
 	return &wstats;
 }
 
