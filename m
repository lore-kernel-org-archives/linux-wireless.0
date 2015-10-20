Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44829 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbbJTIPF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 04:15:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: move beacon_loss_count into ifmgd
Date: Tue, 20 Oct 2015 10:14:57 +0200
Message-Id: <1445328898-26849-2-git-send-email-johannes@sipsolutions.net> (sfid-20151020_101547_993805_5F76E3A4)
In-Reply-To: <1445328898-26849-1-git-send-email-johannes@sipsolutions.net>
References: <1445328898-26849-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's little point in keeping (and even sending to userspace)
the beacon_loss_count value per station, since it can only apply
to the AP on a managed-mode connection. Move the value to ifmgd,
advertise it only in managed mode, and remove it from ethtool as
it's available through better interfaces.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ethtool.c     |  3 +--
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/mlme.c        | 10 ++--------
 net/mac80211/sta_info.c    |  9 ++++++---
 net/mac80211/sta_info.h    |  1 -
 5 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
index 188faab11c24..3fbf9c308ec5 100644
--- a/net/mac80211/ethtool.c
+++ b/net/mac80211/ethtool.c
@@ -40,7 +40,7 @@ static const char ieee80211_gstrings_sta_stats[][ETH_GSTRING_LEN] = {
 	"rx_duplicates", "rx_fragments", "rx_dropped",
 	"tx_packets", "tx_bytes",
 	"tx_filtered", "tx_retry_failed", "tx_retries",
-	"beacon_loss", "sta_state", "txrate", "rxrate", "signal",
+	"sta_state", "txrate", "rxrate", "signal",
 	"channel", "noise", "ch_time", "ch_time_busy",
 	"ch_time_ext_busy", "ch_time_rx", "ch_time_tx"
 };
@@ -90,7 +90,6 @@ static void ieee80211_get_stats(struct net_device *dev,
 		data[i++] += sta->tx_filtered_count;	\
 		data[i++] += sta->tx_retry_failed;	\
 		data[i++] += sta->tx_retry_count;	\
-		data[i++] += sta->beacon_loss_count;	\
 	} while (0)
 
 	/* For Managed stations, find the single station based on BSSID
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 056d3721148c..62f2a97cd2a6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -503,6 +503,9 @@ struct ieee80211_if_managed {
 	 */
 	unsigned int count_beacon_signal;
 
+	/* Number of times beacon loss was invoked. */
+	unsigned int beacon_loss_count;
+
 	/*
 	 * Last Beacon frame signal strength average (ave_beacon_signal / 16)
 	 * that triggered a cqm event. 0 indicates that no event has been
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6158db06a5b5..ded4b976bb48 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2420,15 +2420,9 @@ static void ieee80211_beacon_connection_loss_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.beacon_connection_loss_work);
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct sta_info *sta;
 
-	if (ifmgd->associated) {
-		rcu_read_lock();
-		sta = sta_info_get(sdata, ifmgd->bssid);
-		if (sta)
-			sta->beacon_loss_count++;
-		rcu_read_unlock();
-	}
+	if (ifmgd->associated)
+		ifmgd->beacon_loss_count++;
 
 	if (ifmgd->connection_loss) {
 		sdata_info(sdata, "Connection to AP %pM lost\n",
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 7f2c4f2acadf..0b8dd1cca6d8 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1871,8 +1871,12 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 			 BIT(NL80211_STA_INFO_STA_FLAGS) |
 			 BIT(NL80211_STA_INFO_BSS_PARAM) |
 			 BIT(NL80211_STA_INFO_CONNECTED_TIME) |
-			 BIT(NL80211_STA_INFO_RX_DROP_MISC) |
-			 BIT(NL80211_STA_INFO_BEACON_LOSS);
+			 BIT(NL80211_STA_INFO_RX_DROP_MISC);
+
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		sinfo->beacon_loss_count = sdata->u.mgd.beacon_loss_count;
+		sinfo->filled |= BIT(NL80211_STA_INFO_BEACON_LOSS);
+	}
 
 	sinfo->connected_time = ktime_get_seconds() - sta->last_connected;
 	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
@@ -1914,7 +1918,6 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	}
 
 	sinfo->rx_dropped_misc = sta->rx_dropped;
-	sinfo->beacon_loss_count = sta->beacon_loss_count;
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    !(sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER)) {
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 7bb5781b4ce2..3a401d40c329 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -508,7 +508,6 @@ struct sta_info {
 	enum ieee80211_sta_rx_bandwidth cur_max_bandwidth;
 
 	unsigned int lost_packets;
-	unsigned int beacon_loss_count;
 
 	enum ieee80211_smps_mode known_smps_mode;
 	const struct ieee80211_cipher_scheme *cipher_scheme;
-- 
2.5.1

