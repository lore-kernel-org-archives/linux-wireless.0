Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34957 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaFDPiU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 11:38:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: make ethtool the driver's responsibility
Date: Wed,  4 Jun 2014 17:38:10 +0200
Message-Id: <1401896290-12942-1-git-send-email-johannes@sipsolutions.net> (sfid-20140604_173826_161486_D4BE3508)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, cfg80211 tries to implement ethtool, but that doesn't
really scale well, with all the different operations. Make the
lower-level driver responsible for it, which currently only has
an effect on mac80211. It will similarly not scale well at that
level though, since mac80211 also has many drivers.

To cleanly implement this in mac80211, introduce a new file and
move some code to appropriate places.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h     |  21 +--
 net/mac80211/Makefile      |   1 +
 net/mac80211/cfg.c         | 340 ---------------------------------------------
 net/mac80211/ethtool.c     | 244 ++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |   2 +
 net/mac80211/iface.c       |   2 +
 net/mac80211/sta_info.c    | 134 ++++++++++++++++++
 net/mac80211/sta_info.h    |   2 +
 net/wireless/core.c        |   3 -
 net/wireless/ethtool.c     |  86 +-----------
 net/wireless/ethtool.h     |   6 -
 net/wireless/rdev-ops.h    |  48 -------
 net/wireless/trace.h       |  49 -------
 13 files changed, 391 insertions(+), 547 deletions(-)
 create mode 100644 net/mac80211/ethtool.c
 delete mode 100644 net/wireless/ethtool.h

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 920ec8c1ce54..5c17b1f71dd4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2278,16 +2278,6 @@ struct cfg80211_qos_map {
  *
  * @set_noack_map: Set the NoAck Map for the TIDs.
  *
- * @get_et_sset_count:  Ethtool API to get string-set count.
- *	See @ethtool_ops.get_sset_count
- *
- * @get_et_stats:  Ethtool API to get a set of u64 stats.
- *	See @ethtool_ops.get_ethtool_stats
- *
- * @get_et_strings:  Ethtool API to get a set of strings to describe stats
- *	and perhaps other supported types of ethtool data-sets.
- *	See @ethtool_ops.get_strings
- *
  * @get_channel: Get the current operating channel for the virtual interface.
  *	For monitor interfaces, it should return %NULL unless there's a single
  *	current monitoring channel.
@@ -2529,13 +2519,6 @@ struct cfg80211_ops {
 				  struct net_device *dev,
 				  u16 noack_map);
 
-	int	(*get_et_sset_count)(struct wiphy *wiphy,
-				     struct net_device *dev, int sset);
-	void	(*get_et_stats)(struct wiphy *wiphy, struct net_device *dev,
-				struct ethtool_stats *stats, u64 *data);
-	void	(*get_et_strings)(struct wiphy *wiphy, struct net_device *dev,
-				  u32 sset, u8 *data);
-
 	int	(*get_channel)(struct wiphy *wiphy,
 			       struct wireless_dev *wdev,
 			       struct cfg80211_chan_def *chandef);
@@ -4831,6 +4814,10 @@ void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev,
  */
 void cfg80211_shutdown_all_interfaces(struct wiphy *wiphy);
 
+
+/* ethtool helper */
+void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 4409bf506594..7273d2796dd1 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -17,6 +17,7 @@ mac80211-y := \
 	aes_ccm.o \
 	aes_cmac.o \
 	cfg.o \
+	ethtool.o \
 	rx.o \
 	spectmgmt.o \
 	tx.o \
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f8d065480ba9..b6d73c14e1ae 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -468,326 +468,6 @@ void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 		rinfo->flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
 }
 
-static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
-{
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct ieee80211_local *local = sdata->local;
-	struct rate_control_ref *ref = local->rate_ctrl;
-	struct timespec uptime;
-	u64 packets = 0;
-	u32 thr = 0;
-	int i, ac;
-
-	sinfo->generation = sdata->local->sta_generation;
-
-	sinfo->filled = STATION_INFO_INACTIVE_TIME |
-			STATION_INFO_RX_BYTES64 |
-			STATION_INFO_TX_BYTES64 |
-			STATION_INFO_RX_PACKETS |
-			STATION_INFO_TX_PACKETS |
-			STATION_INFO_TX_RETRIES |
-			STATION_INFO_TX_FAILED |
-			STATION_INFO_TX_BITRATE |
-			STATION_INFO_RX_BITRATE |
-			STATION_INFO_RX_DROP_MISC |
-			STATION_INFO_BSS_PARAM |
-			STATION_INFO_CONNECTED_TIME |
-			STATION_INFO_STA_FLAGS |
-			STATION_INFO_BEACON_LOSS_COUNT;
-
-	do_posix_clock_monotonic_gettime(&uptime);
-	sinfo->connected_time = uptime.tv_sec - sta->last_connected;
-
-	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
-	sinfo->tx_bytes = 0;
-	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		sinfo->tx_bytes += sta->tx_bytes[ac];
-		packets += sta->tx_packets[ac];
-	}
-	sinfo->tx_packets = packets;
-	sinfo->rx_bytes = sta->rx_bytes;
-	sinfo->rx_packets = sta->rx_packets;
-	sinfo->tx_retries = sta->tx_retry_count;
-	sinfo->tx_failed = sta->tx_retry_failed;
-	sinfo->rx_dropped_misc = sta->rx_dropped;
-	sinfo->beacon_loss_count = sta->beacon_loss_count;
-
-	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
-	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
-		sinfo->filled |= STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
-		if (!local->ops->get_rssi ||
-		    drv_get_rssi(local, sdata, &sta->sta, &sinfo->signal))
-			sinfo->signal = (s8)sta->last_signal;
-		sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);
-	}
-	if (sta->chains) {
-		sinfo->filled |= STATION_INFO_CHAIN_SIGNAL |
-				 STATION_INFO_CHAIN_SIGNAL_AVG;
-
-		sinfo->chains = sta->chains;
-		for (i = 0; i < ARRAY_SIZE(sinfo->chain_signal); i++) {
-			sinfo->chain_signal[i] = sta->chain_signal_last[i];
-			sinfo->chain_signal_avg[i] =
-				(s8) -ewma_read(&sta->chain_signal_avg[i]);
-		}
-	}
-
-	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &sinfo->txrate);
-	sta_set_rate_info_rx(sta, &sinfo->rxrate);
-
-	if (ieee80211_vif_is_mesh(&sdata->vif)) {
-#ifdef CONFIG_MAC80211_MESH
-		sinfo->filled |= STATION_INFO_LLID |
-				 STATION_INFO_PLID |
-				 STATION_INFO_PLINK_STATE |
-				 STATION_INFO_LOCAL_PM |
-				 STATION_INFO_PEER_PM |
-				 STATION_INFO_NONPEER_PM;
-
-		sinfo->llid = sta->llid;
-		sinfo->plid = sta->plid;
-		sinfo->plink_state = sta->plink_state;
-		if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
-			sinfo->filled |= STATION_INFO_T_OFFSET;
-			sinfo->t_offset = sta->t_offset;
-		}
-		sinfo->local_pm = sta->local_pm;
-		sinfo->peer_pm = sta->peer_pm;
-		sinfo->nonpeer_pm = sta->nonpeer_pm;
-#endif
-	}
-
-	sinfo->bss_param.flags = 0;
-	if (sdata->vif.bss_conf.use_cts_prot)
-		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
-	if (sdata->vif.bss_conf.use_short_preamble)
-		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_PREAMBLE;
-	if (sdata->vif.bss_conf.use_short_slot)
-		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
-	sinfo->bss_param.dtim_period = sdata->local->hw.conf.ps_dtim_period;
-	sinfo->bss_param.beacon_interval = sdata->vif.bss_conf.beacon_int;
-
-	sinfo->sta_flags.set = 0;
-	sinfo->sta_flags.mask = BIT(NL80211_STA_FLAG_AUTHORIZED) |
-				BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
-				BIT(NL80211_STA_FLAG_WME) |
-				BIT(NL80211_STA_FLAG_MFP) |
-				BIT(NL80211_STA_FLAG_AUTHENTICATED) |
-				BIT(NL80211_STA_FLAG_ASSOCIATED) |
-				BIT(NL80211_STA_FLAG_TDLS_PEER);
-	if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
-		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHORIZED);
-	if (test_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE))
-		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_SHORT_PREAMBLE);
-	if (test_sta_flag(sta, WLAN_STA_WME))
-		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_WME);
-	if (test_sta_flag(sta, WLAN_STA_MFP))
-		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_MFP);
-	if (test_sta_flag(sta, WLAN_STA_AUTH))
-		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHENTICATED);
-	if (test_sta_flag(sta, WLAN_STA_ASSOC))
-		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_ASSOCIATED);
-	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
-		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
-
-	/* check if the driver has a SW RC implementation */
-	if (ref && ref->ops->get_expected_throughput)
-		thr = ref->ops->get_expected_throughput(sta->rate_ctrl_priv);
-	else
-		thr = drv_get_expected_throughput(local, &sta->sta);
-
-	if (thr != 0) {
-		sinfo->filled |= STATION_INFO_EXPECTED_THROUGHPUT;
-		sinfo->expected_throughput = thr;
-	}
-}
-
-static const char ieee80211_gstrings_sta_stats[][ETH_GSTRING_LEN] = {
-	"rx_packets", "rx_bytes",
-	"rx_duplicates", "rx_fragments", "rx_dropped",
-	"tx_packets", "tx_bytes", "tx_fragments",
-	"tx_filtered", "tx_retry_failed", "tx_retries",
-	"beacon_loss", "sta_state", "txrate", "rxrate", "signal",
-	"channel", "noise", "ch_time", "ch_time_busy",
-	"ch_time_ext_busy", "ch_time_rx", "ch_time_tx"
-};
-#define STA_STATS_LEN	ARRAY_SIZE(ieee80211_gstrings_sta_stats)
-
-static int ieee80211_get_et_sset_count(struct wiphy *wiphy,
-				       struct net_device *dev,
-				       int sset)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	int rv = 0;
-
-	if (sset == ETH_SS_STATS)
-		rv += STA_STATS_LEN;
-
-	rv += drv_get_et_sset_count(sdata, sset);
-
-	if (rv == 0)
-		return -EOPNOTSUPP;
-	return rv;
-}
-
-static void ieee80211_get_et_stats(struct wiphy *wiphy,
-				   struct net_device *dev,
-				   struct ethtool_stats *stats,
-				   u64 *data)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_chanctx_conf *chanctx_conf;
-	struct ieee80211_channel *channel;
-	struct sta_info *sta;
-	struct ieee80211_local *local = sdata->local;
-	struct station_info sinfo;
-	struct survey_info survey;
-	int i, q;
-#define STA_STATS_SURVEY_LEN 7
-
-	memset(data, 0, sizeof(u64) * STA_STATS_LEN);
-
-#define ADD_STA_STATS(sta)				\
-	do {						\
-		data[i++] += sta->rx_packets;		\
-		data[i++] += sta->rx_bytes;		\
-		data[i++] += sta->num_duplicates;	\
-		data[i++] += sta->rx_fragments;		\
-		data[i++] += sta->rx_dropped;		\
-							\
-		data[i++] += sinfo.tx_packets;		\
-		data[i++] += sinfo.tx_bytes;		\
-		data[i++] += sta->tx_fragments;		\
-		data[i++] += sta->tx_filtered_count;	\
-		data[i++] += sta->tx_retry_failed;	\
-		data[i++] += sta->tx_retry_count;	\
-		data[i++] += sta->beacon_loss_count;	\
-	} while (0)
-
-	/* For Managed stations, find the single station based on BSSID
-	 * and use that.  For interface types, iterate through all available
-	 * stations and add stats for any station that is assigned to this
-	 * network device.
-	 */
-
-	mutex_lock(&local->sta_mtx);
-
-	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		sta = sta_info_get_bss(sdata, sdata->u.mgd.bssid);
-
-		if (!(sta && !WARN_ON(sta->sdata->dev != dev)))
-			goto do_survey;
-
-		sinfo.filled = 0;
-		sta_set_sinfo(sta, &sinfo);
-
-		i = 0;
-		ADD_STA_STATS(sta);
-
-		data[i++] = sta->sta_state;
-
-
-		if (sinfo.filled & STATION_INFO_TX_BITRATE)
-			data[i] = 100000 *
-				cfg80211_calculate_bitrate(&sinfo.txrate);
-		i++;
-		if (sinfo.filled & STATION_INFO_RX_BITRATE)
-			data[i] = 100000 *
-				cfg80211_calculate_bitrate(&sinfo.rxrate);
-		i++;
-
-		if (sinfo.filled & STATION_INFO_SIGNAL_AVG)
-			data[i] = (u8)sinfo.signal_avg;
-		i++;
-	} else {
-		list_for_each_entry(sta, &local->sta_list, list) {
-			/* Make sure this station belongs to the proper dev */
-			if (sta->sdata->dev != dev)
-				continue;
-
-			sinfo.filled = 0;
-			sta_set_sinfo(sta, &sinfo);
-			i = 0;
-			ADD_STA_STATS(sta);
-		}
-	}
-
-do_survey:
-	i = STA_STATS_LEN - STA_STATS_SURVEY_LEN;
-	/* Get survey stats for current channel */
-	survey.filled = 0;
-
-	rcu_read_lock();
-	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
-	if (chanctx_conf)
-		channel = chanctx_conf->def.chan;
-	else
-		channel = NULL;
-	rcu_read_unlock();
-
-	if (channel) {
-		q = 0;
-		do {
-			survey.filled = 0;
-			if (drv_get_survey(local, q, &survey) != 0) {
-				survey.filled = 0;
-				break;
-			}
-			q++;
-		} while (channel != survey.channel);
-	}
-
-	if (survey.filled)
-		data[i++] = survey.channel->center_freq;
-	else
-		data[i++] = 0;
-	if (survey.filled & SURVEY_INFO_NOISE_DBM)
-		data[i++] = (u8)survey.noise;
-	else
-		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME)
-		data[i++] = survey.channel_time;
-	else
-		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_BUSY)
-		data[i++] = survey.channel_time_busy;
-	else
-		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_EXT_BUSY)
-		data[i++] = survey.channel_time_ext_busy;
-	else
-		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_RX)
-		data[i++] = survey.channel_time_rx;
-	else
-		data[i++] = -1LL;
-	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_TX)
-		data[i++] = survey.channel_time_tx;
-	else
-		data[i++] = -1LL;
-
-	mutex_unlock(&local->sta_mtx);
-
-	if (WARN_ON(i != STA_STATS_LEN))
-		return;
-
-	drv_get_et_stats(sdata, stats, &(data[STA_STATS_LEN]));
-}
-
-static void ieee80211_get_et_strings(struct wiphy *wiphy,
-				     struct net_device *dev,
-				     u32 sset, u8 *data)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	int sz_sta_stats = 0;
-
-	if (sset == ETH_SS_STATS) {
-		sz_sta_stats = sizeof(ieee80211_gstrings_sta_stats);
-		memcpy(data, ieee80211_gstrings_sta_stats, sz_sta_stats);
-	}
-	drv_get_et_strings(sdata, sset, &(data[sz_sta_stats]));
-}
-
 static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 				  int idx, u8 *mac, struct station_info *sinfo)
 {
@@ -3597,21 +3277,6 @@ static int ieee80211_get_antenna(struct wiphy *wiphy, u32 *tx_ant, u32 *rx_ant)
 	return drv_get_antenna(local, tx_ant, rx_ant);
 }
 
-static int ieee80211_set_ringparam(struct wiphy *wiphy, u32 tx, u32 rx)
-{
-	struct ieee80211_local *local = wiphy_priv(wiphy);
-
-	return drv_set_ringparam(local, tx, rx);
-}
-
-static void ieee80211_get_ringparam(struct wiphy *wiphy,
-				    u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max)
-{
-	struct ieee80211_local *local = wiphy_priv(wiphy);
-
-	drv_get_ringparam(local, tx, tx_max, rx, rx_max);
-}
-
 static int ieee80211_set_rekey_data(struct wiphy *wiphy,
 				    struct net_device *dev,
 				    struct cfg80211_gtk_rekey_data *data)
@@ -3843,8 +3508,6 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.mgmt_frame_register = ieee80211_mgmt_frame_register,
 	.set_antenna = ieee80211_set_antenna,
 	.get_antenna = ieee80211_get_antenna,
-	.set_ringparam = ieee80211_set_ringparam,
-	.get_ringparam = ieee80211_get_ringparam,
 	.set_rekey_data = ieee80211_set_rekey_data,
 	.tdls_oper = ieee80211_tdls_oper,
 	.tdls_mgmt = ieee80211_tdls_mgmt,
@@ -3853,9 +3516,6 @@ const struct cfg80211_ops mac80211_config_ops = {
 #ifdef CONFIG_PM
 	.set_wakeup = ieee80211_set_wakeup,
 #endif
-	.get_et_sset_count = ieee80211_get_et_sset_count,
-	.get_et_stats = ieee80211_get_et_stats,
-	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
 	.channel_switch = ieee80211_channel_switch,
diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
new file mode 100644
index 000000000000..ebfc8091557b
--- /dev/null
+++ b/net/mac80211/ethtool.c
@@ -0,0 +1,244 @@
+/*
+ * mac80211 ethtool hooks for cfg80211
+ *
+ * Copied from cfg.c - originally
+ * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2014	Intel Corporation (Author: Johannes Berg)
+ *
+ * This file is GPLv2 as found in COPYING.
+ */
+#include <linux/types.h>
+#include <net/cfg80211.h>
+#include "ieee80211_i.h"
+#include "sta_info.h"
+#include "driver-ops.h"
+
+static int ieee80211_set_ringparam(struct net_device *dev,
+				   struct ethtool_ringparam *rp)
+{
+	struct ieee80211_local *local = wiphy_priv(dev->ieee80211_ptr->wiphy);
+
+	if (rp->rx_mini_pending != 0 || rp->rx_jumbo_pending != 0)
+		return -EINVAL;
+
+	return drv_set_ringparam(local, rp->tx_pending, rp->rx_pending);
+}
+
+static void ieee80211_get_ringparam(struct net_device *dev,
+				    struct ethtool_ringparam *rp)
+{
+	struct ieee80211_local *local = wiphy_priv(dev->ieee80211_ptr->wiphy);
+
+	memset(rp, 0, sizeof(*rp));
+
+	drv_get_ringparam(local, &rp->tx_pending, &rp->tx_max_pending,
+			  &rp->rx_pending, &rp->rx_max_pending);
+}
+
+static const char ieee80211_gstrings_sta_stats[][ETH_GSTRING_LEN] = {
+	"rx_packets", "rx_bytes",
+	"rx_duplicates", "rx_fragments", "rx_dropped",
+	"tx_packets", "tx_bytes", "tx_fragments",
+	"tx_filtered", "tx_retry_failed", "tx_retries",
+	"beacon_loss", "sta_state", "txrate", "rxrate", "signal",
+	"channel", "noise", "ch_time", "ch_time_busy",
+	"ch_time_ext_busy", "ch_time_rx", "ch_time_tx"
+};
+#define STA_STATS_LEN	ARRAY_SIZE(ieee80211_gstrings_sta_stats)
+
+static int ieee80211_get_sset_count(struct net_device *dev, int sset)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	int rv = 0;
+
+	if (sset == ETH_SS_STATS)
+		rv += STA_STATS_LEN;
+
+	rv += drv_get_et_sset_count(sdata, sset);
+
+	if (rv == 0)
+		return -EOPNOTSUPP;
+	return rv;
+}
+
+static void ieee80211_get_stats(struct net_device *dev,
+				struct ethtool_stats *stats,
+				u64 *data)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *channel;
+	struct sta_info *sta;
+	struct ieee80211_local *local = sdata->local;
+	struct station_info sinfo;
+	struct survey_info survey;
+	int i, q;
+#define STA_STATS_SURVEY_LEN 7
+
+	memset(data, 0, sizeof(u64) * STA_STATS_LEN);
+
+#define ADD_STA_STATS(sta)				\
+	do {						\
+		data[i++] += sta->rx_packets;		\
+		data[i++] += sta->rx_bytes;		\
+		data[i++] += sta->num_duplicates;	\
+		data[i++] += sta->rx_fragments;		\
+		data[i++] += sta->rx_dropped;		\
+							\
+		data[i++] += sinfo.tx_packets;		\
+		data[i++] += sinfo.tx_bytes;		\
+		data[i++] += sta->tx_fragments;		\
+		data[i++] += sta->tx_filtered_count;	\
+		data[i++] += sta->tx_retry_failed;	\
+		data[i++] += sta->tx_retry_count;	\
+		data[i++] += sta->beacon_loss_count;	\
+	} while (0)
+
+	/* For Managed stations, find the single station based on BSSID
+	 * and use that.  For interface types, iterate through all available
+	 * stations and add stats for any station that is assigned to this
+	 * network device.
+	 */
+
+	mutex_lock(&local->sta_mtx);
+
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		sta = sta_info_get_bss(sdata, sdata->u.mgd.bssid);
+
+		if (!(sta && !WARN_ON(sta->sdata->dev != dev)))
+			goto do_survey;
+
+		sinfo.filled = 0;
+		sta_set_sinfo(sta, &sinfo);
+
+		i = 0;
+		ADD_STA_STATS(sta);
+
+		data[i++] = sta->sta_state;
+
+
+		if (sinfo.filled & STATION_INFO_TX_BITRATE)
+			data[i] = 100000 *
+				cfg80211_calculate_bitrate(&sinfo.txrate);
+		i++;
+		if (sinfo.filled & STATION_INFO_RX_BITRATE)
+			data[i] = 100000 *
+				cfg80211_calculate_bitrate(&sinfo.rxrate);
+		i++;
+
+		if (sinfo.filled & STATION_INFO_SIGNAL_AVG)
+			data[i] = (u8)sinfo.signal_avg;
+		i++;
+	} else {
+		list_for_each_entry(sta, &local->sta_list, list) {
+			/* Make sure this station belongs to the proper dev */
+			if (sta->sdata->dev != dev)
+				continue;
+
+			sinfo.filled = 0;
+			sta_set_sinfo(sta, &sinfo);
+			i = 0;
+			ADD_STA_STATS(sta);
+		}
+	}
+
+do_survey:
+	i = STA_STATS_LEN - STA_STATS_SURVEY_LEN;
+	/* Get survey stats for current channel */
+	survey.filled = 0;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (chanctx_conf)
+		channel = chanctx_conf->def.chan;
+	else
+		channel = NULL;
+	rcu_read_unlock();
+
+	if (channel) {
+		q = 0;
+		do {
+			survey.filled = 0;
+			if (drv_get_survey(local, q, &survey) != 0) {
+				survey.filled = 0;
+				break;
+			}
+			q++;
+		} while (channel != survey.channel);
+	}
+
+	if (survey.filled)
+		data[i++] = survey.channel->center_freq;
+	else
+		data[i++] = 0;
+	if (survey.filled & SURVEY_INFO_NOISE_DBM)
+		data[i++] = (u8)survey.noise;
+	else
+		data[i++] = -1LL;
+	if (survey.filled & SURVEY_INFO_CHANNEL_TIME)
+		data[i++] = survey.channel_time;
+	else
+		data[i++] = -1LL;
+	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_BUSY)
+		data[i++] = survey.channel_time_busy;
+	else
+		data[i++] = -1LL;
+	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_EXT_BUSY)
+		data[i++] = survey.channel_time_ext_busy;
+	else
+		data[i++] = -1LL;
+	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_RX)
+		data[i++] = survey.channel_time_rx;
+	else
+		data[i++] = -1LL;
+	if (survey.filled & SURVEY_INFO_CHANNEL_TIME_TX)
+		data[i++] = survey.channel_time_tx;
+	else
+		data[i++] = -1LL;
+
+	mutex_unlock(&local->sta_mtx);
+
+	if (WARN_ON(i != STA_STATS_LEN))
+		return;
+
+	drv_get_et_stats(sdata, stats, &(data[STA_STATS_LEN]));
+}
+
+static void ieee80211_get_strings(struct net_device *dev, u32 sset, u8 *data)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	int sz_sta_stats = 0;
+
+	if (sset == ETH_SS_STATS) {
+		sz_sta_stats = sizeof(ieee80211_gstrings_sta_stats);
+		memcpy(data, ieee80211_gstrings_sta_stats, sz_sta_stats);
+	}
+	drv_get_et_strings(sdata, sset, &(data[sz_sta_stats]));
+}
+
+static int ieee80211_get_regs_len(struct net_device *dev)
+{
+	return 0;
+}
+
+static void ieee80211_get_regs(struct net_device *dev,
+			       struct ethtool_regs *regs,
+			       void *data)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	regs->version = wdev->wiphy->hw_version;
+	regs->len = 0;
+}
+
+const struct ethtool_ops ieee80211_ethtool_ops = {
+	.get_drvinfo = cfg80211_get_drvinfo,
+	.get_regs_len = ieee80211_get_regs_len,
+	.get_regs = ieee80211_get_regs,
+	.get_link = ethtool_op_get_link,
+	.get_ringparam = ieee80211_get_ringparam,
+	.set_ringparam = ieee80211_set_ringparam,
+	.get_strings = ieee80211_get_strings,
+	.get_ethtool_stats = ieee80211_get_stats,
+	.get_sset_count = ieee80211_get_sset_count,
+};
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ed2b817d5ece..4ca6af06013a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1846,6 +1846,8 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, enum nl80211_tdls_operation oper);
 
 
+extern const struct ethtool_ops ieee80211_ethtool_ops;
+
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
 #else
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 81a8e2a0b6aa..00762a1cde5c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1705,6 +1705,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		ndev->features |= local->hw.netdev_features;
 
+		netdev_set_default_ethtool_ops(ndev, &ieee80211_ethtool_ops);
+
 		ret = register_netdevice(ndev);
 		if (ret) {
 			free_netdev(ndev);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c682e3c95f94..3e28861ce8c0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1718,3 +1718,137 @@ u8 sta_info_tx_streams(struct sta_info *sta)
 	return ((ht_cap->mcs.tx_params & IEEE80211_HT_MCS_TX_MAX_STREAMS_MASK)
 			>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT) + 1;
 }
+
+void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+	struct rate_control_ref *ref = local->rate_ctrl;
+	struct timespec uptime;
+	u64 packets = 0;
+	u32 thr = 0;
+	int i, ac;
+
+	sinfo->generation = sdata->local->sta_generation;
+
+	sinfo->filled = STATION_INFO_INACTIVE_TIME |
+			STATION_INFO_RX_BYTES64 |
+			STATION_INFO_TX_BYTES64 |
+			STATION_INFO_RX_PACKETS |
+			STATION_INFO_TX_PACKETS |
+			STATION_INFO_TX_RETRIES |
+			STATION_INFO_TX_FAILED |
+			STATION_INFO_TX_BITRATE |
+			STATION_INFO_RX_BITRATE |
+			STATION_INFO_RX_DROP_MISC |
+			STATION_INFO_BSS_PARAM |
+			STATION_INFO_CONNECTED_TIME |
+			STATION_INFO_STA_FLAGS |
+			STATION_INFO_BEACON_LOSS_COUNT;
+
+	do_posix_clock_monotonic_gettime(&uptime);
+	sinfo->connected_time = uptime.tv_sec - sta->last_connected;
+
+	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
+	sinfo->tx_bytes = 0;
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		sinfo->tx_bytes += sta->tx_bytes[ac];
+		packets += sta->tx_packets[ac];
+	}
+	sinfo->tx_packets = packets;
+	sinfo->rx_bytes = sta->rx_bytes;
+	sinfo->rx_packets = sta->rx_packets;
+	sinfo->tx_retries = sta->tx_retry_count;
+	sinfo->tx_failed = sta->tx_retry_failed;
+	sinfo->rx_dropped_misc = sta->rx_dropped;
+	sinfo->beacon_loss_count = sta->beacon_loss_count;
+
+	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
+	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
+		sinfo->filled |= STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
+		if (!local->ops->get_rssi ||
+		    drv_get_rssi(local, sdata, &sta->sta, &sinfo->signal))
+			sinfo->signal = (s8)sta->last_signal;
+		sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);
+	}
+	if (sta->chains) {
+		sinfo->filled |= STATION_INFO_CHAIN_SIGNAL |
+				 STATION_INFO_CHAIN_SIGNAL_AVG;
+
+		sinfo->chains = sta->chains;
+		for (i = 0; i < ARRAY_SIZE(sinfo->chain_signal); i++) {
+			sinfo->chain_signal[i] = sta->chain_signal_last[i];
+			sinfo->chain_signal_avg[i] =
+				(s8) -ewma_read(&sta->chain_signal_avg[i]);
+		}
+	}
+
+	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &sinfo->txrate);
+	sta_set_rate_info_rx(sta, &sinfo->rxrate);
+
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+#ifdef CONFIG_MAC80211_MESH
+		sinfo->filled |= STATION_INFO_LLID |
+				 STATION_INFO_PLID |
+				 STATION_INFO_PLINK_STATE |
+				 STATION_INFO_LOCAL_PM |
+				 STATION_INFO_PEER_PM |
+				 STATION_INFO_NONPEER_PM;
+
+		sinfo->llid = sta->llid;
+		sinfo->plid = sta->plid;
+		sinfo->plink_state = sta->plink_state;
+		if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
+			sinfo->filled |= STATION_INFO_T_OFFSET;
+			sinfo->t_offset = sta->t_offset;
+		}
+		sinfo->local_pm = sta->local_pm;
+		sinfo->peer_pm = sta->peer_pm;
+		sinfo->nonpeer_pm = sta->nonpeer_pm;
+#endif
+	}
+
+	sinfo->bss_param.flags = 0;
+	if (sdata->vif.bss_conf.use_cts_prot)
+		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
+	if (sdata->vif.bss_conf.use_short_preamble)
+		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_PREAMBLE;
+	if (sdata->vif.bss_conf.use_short_slot)
+		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
+	sinfo->bss_param.dtim_period = sdata->local->hw.conf.ps_dtim_period;
+	sinfo->bss_param.beacon_interval = sdata->vif.bss_conf.beacon_int;
+
+	sinfo->sta_flags.set = 0;
+	sinfo->sta_flags.mask = BIT(NL80211_STA_FLAG_AUTHORIZED) |
+				BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
+				BIT(NL80211_STA_FLAG_WME) |
+				BIT(NL80211_STA_FLAG_MFP) |
+				BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+				BIT(NL80211_STA_FLAG_ASSOCIATED) |
+				BIT(NL80211_STA_FLAG_TDLS_PEER);
+	if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHORIZED);
+	if (test_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_SHORT_PREAMBLE);
+	if (test_sta_flag(sta, WLAN_STA_WME))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_WME);
+	if (test_sta_flag(sta, WLAN_STA_MFP))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_MFP);
+	if (test_sta_flag(sta, WLAN_STA_AUTH))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHENTICATED);
+	if (test_sta_flag(sta, WLAN_STA_ASSOC))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_ASSOCIATED);
+	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
+
+	/* check if the driver has a SW RC implementation */
+	if (ref && ref->ops->get_expected_throughput)
+		thr = ref->ops->get_expected_throughput(sta->rate_ctrl_priv);
+	else
+		thr = drv_get_expected_throughput(local, &sta->sta);
+
+	if (thr != 0) {
+		sinfo->filled |= STATION_INFO_EXPECTED_THROUGHPUT;
+		sinfo->expected_throughput = thr;
+	}
+}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index fa7ce6f8593b..2a04361b2162 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -627,6 +627,8 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 			  struct rate_info *rinfo);
 void sta_set_rate_info_rx(struct sta_info *sta,
 			  struct rate_info *rinfo);
+void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo);
+
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
 u8 sta_info_tx_streams(struct sta_info *sta);
diff --git a/net/wireless/core.c b/net/wireless/core.c
index a1c40654dd9b..afee5e0455ea 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -25,7 +25,6 @@
 #include "sysfs.h"
 #include "debugfs.h"
 #include "wext-compat.h"
-#include "ethtool.h"
 #include "rdev-ops.h"
 
 /* name for sysfs, %d is appended */
@@ -927,8 +926,6 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		/* allow mac80211 to determine the timeout */
 		wdev->ps_timeout = -1;
 
-		netdev_set_default_ethtool_ops(dev, &cfg80211_ethtool_ops);
-
 		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
 		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT ||
 		     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
diff --git a/net/wireless/ethtool.c b/net/wireless/ethtool.c
index d4860bfc020e..e9e91298c70d 100644
--- a/net/wireless/ethtool.c
+++ b/net/wireless/ethtool.c
@@ -1,11 +1,9 @@
 #include <linux/utsname.h>
 #include <net/cfg80211.h>
 #include "core.h"
-#include "ethtool.h"
 #include "rdev-ops.h"
 
-static void cfg80211_get_drvinfo(struct net_device *dev,
-					struct ethtool_drvinfo *info)
+void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -23,84 +21,4 @@ static void cfg80211_get_drvinfo(struct net_device *dev,
 	strlcpy(info->bus_info, dev_name(wiphy_dev(wdev->wiphy)),
 		sizeof(info->bus_info));
 }
-
-static int cfg80211_get_regs_len(struct net_device *dev)
-{
-	/* For now, return 0... */
-	return 0;
-}
-
-static void cfg80211_get_regs(struct net_device *dev, struct ethtool_regs *regs,
-			void *data)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-
-	regs->version = wdev->wiphy->hw_version;
-	regs->len = 0;
-}
-
-static void cfg80211_get_ringparam(struct net_device *dev,
-				   struct ethtool_ringparam *rp)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
-
-	memset(rp, 0, sizeof(*rp));
-
-	if (rdev->ops->get_ringparam)
-		rdev_get_ringparam(rdev, &rp->tx_pending, &rp->tx_max_pending,
-				   &rp->rx_pending, &rp->rx_max_pending);
-}
-
-static int cfg80211_set_ringparam(struct net_device *dev,
-				  struct ethtool_ringparam *rp)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
-
-	if (rp->rx_mini_pending != 0 || rp->rx_jumbo_pending != 0)
-		return -EINVAL;
-
-	if (rdev->ops->set_ringparam)
-		return rdev_set_ringparam(rdev, rp->tx_pending, rp->rx_pending);
-
-	return -ENOTSUPP;
-}
-
-static int cfg80211_get_sset_count(struct net_device *dev, int sset)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
-	if (rdev->ops->get_et_sset_count)
-		return rdev_get_et_sset_count(rdev, dev, sset);
-	return -EOPNOTSUPP;
-}
-
-static void cfg80211_get_stats(struct net_device *dev,
-			       struct ethtool_stats *stats, u64 *data)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
-	if (rdev->ops->get_et_stats)
-		rdev_get_et_stats(rdev, dev, stats, data);
-}
-
-static void cfg80211_get_strings(struct net_device *dev, u32 sset, u8 *data)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
-	if (rdev->ops->get_et_strings)
-		rdev_get_et_strings(rdev, dev, sset, data);
-}
-
-const struct ethtool_ops cfg80211_ethtool_ops = {
-	.get_drvinfo = cfg80211_get_drvinfo,
-	.get_regs_len = cfg80211_get_regs_len,
-	.get_regs = cfg80211_get_regs,
-	.get_link = ethtool_op_get_link,
-	.get_ringparam = cfg80211_get_ringparam,
-	.set_ringparam = cfg80211_set_ringparam,
-	.get_strings = cfg80211_get_strings,
-	.get_ethtool_stats = cfg80211_get_stats,
-	.get_sset_count = cfg80211_get_sset_count,
-};
+EXPORT_SYMBOL(cfg80211_get_drvinfo);
diff --git a/net/wireless/ethtool.h b/net/wireless/ethtool.h
deleted file mode 100644
index 695ecad20bd6..000000000000
--- a/net/wireless/ethtool.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __CFG80211_ETHTOOL__
-#define __CFG80211_ETHTOOL__
-
-extern const struct ethtool_ops cfg80211_ethtool_ops;
-
-#endif /* __CFG80211_ETHTOOL__ */
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index d95bbe348138..f552b0abbd70 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -714,25 +714,6 @@ static inline int rdev_get_antenna(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
-static inline int rdev_set_ringparam(struct cfg80211_registered_device *rdev,
-				     u32 tx, u32 rx)
-{
-	int ret;
-	trace_rdev_set_ringparam(&rdev->wiphy, tx, rx);
-	ret = rdev->ops->set_ringparam(&rdev->wiphy, tx, rx);
-	trace_rdev_return_int(&rdev->wiphy, ret);
-	return ret;
-}
-
-static inline void rdev_get_ringparam(struct cfg80211_registered_device *rdev,
-				      u32 *tx, u32 *tx_max, u32 *rx,
-				      u32 *rx_max)
-{
-	trace_rdev_get_ringparam(&rdev->wiphy);
-	rdev->ops->get_ringparam(&rdev->wiphy, tx, tx_max, rx, rx_max);
-	trace_rdev_return_void_tx_rx(&rdev->wiphy, *tx, *tx_max, *rx, *rx_max);
-}
-
 static inline int
 rdev_sched_scan_start(struct cfg80211_registered_device *rdev,
 		      struct net_device *dev,
@@ -816,35 +797,6 @@ static inline int rdev_set_noack_map(struct cfg80211_registered_device *rdev,
 }
 
 static inline int
-rdev_get_et_sset_count(struct cfg80211_registered_device *rdev,
-		       struct net_device *dev, int sset)
-{
-	int ret;
-	trace_rdev_get_et_sset_count(&rdev->wiphy, dev, sset);
-	ret = rdev->ops->get_et_sset_count(&rdev->wiphy, dev, sset);
-	trace_rdev_return_int(&rdev->wiphy, ret);
-	return ret;
-}
-
-static inline void rdev_get_et_stats(struct cfg80211_registered_device *rdev,
-				     struct net_device *dev,
-				     struct ethtool_stats *stats, u64 *data)
-{
-	trace_rdev_get_et_stats(&rdev->wiphy, dev);
-	rdev->ops->get_et_stats(&rdev->wiphy, dev, stats, data);
-	trace_rdev_return_void(&rdev->wiphy);
-}
-
-static inline void rdev_get_et_strings(struct cfg80211_registered_device *rdev,
-				       struct net_device *dev, u32 sset,
-				       u8 *data)
-{
-	trace_rdev_get_et_strings(&rdev->wiphy, dev, sset);
-	rdev->ops->get_et_strings(&rdev->wiphy, dev, sset, data);
-	trace_rdev_return_void(&rdev->wiphy);
-}
-
-static inline int
 rdev_get_channel(struct cfg80211_registered_device *rdev,
 		 struct wireless_dev *wdev,
 		 struct cfg80211_chan_def *chandef)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 560ed77084e9..174559aade57 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -298,11 +298,6 @@ DEFINE_EVENT(wiphy_only_evt, rdev_return_void,
 	TP_ARGS(wiphy)
 );
 
-DEFINE_EVENT(wiphy_only_evt, rdev_get_ringparam,
-	TP_PROTO(struct wiphy *wiphy),
-	TP_ARGS(wiphy)
-);
-
 DEFINE_EVENT(wiphy_only_evt, rdev_get_antenna,
 	TP_PROTO(struct wiphy *wiphy),
 	TP_ARGS(wiphy)
@@ -580,11 +575,6 @@ DEFINE_EVENT(wiphy_netdev_evt, rdev_stop_ap,
 	TP_ARGS(wiphy, netdev)
 );
 
-DEFINE_EVENT(wiphy_netdev_evt, rdev_get_et_stats,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
-	TP_ARGS(wiphy, netdev)
-);
-
 DEFINE_EVENT(wiphy_netdev_evt, rdev_sched_scan_stop,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
 	TP_ARGS(wiphy, netdev)
@@ -1439,11 +1429,6 @@ DECLARE_EVENT_CLASS(tx_rx_evt,
 		  WIPHY_PR_ARG, __entry->tx, __entry->rx)
 );
 
-DEFINE_EVENT(tx_rx_evt, rdev_set_ringparam,
-	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
-	TP_ARGS(wiphy, rx, tx)
-);
-
 DEFINE_EVENT(tx_rx_evt, rdev_set_antenna,
 	TP_PROTO(struct wiphy *wiphy, u32 tx, u32 rx),
 	TP_ARGS(wiphy, rx, tx)
@@ -1725,40 +1710,6 @@ TRACE_EVENT(rdev_set_noack_map,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->noack_map)
 );
 
-TRACE_EVENT(rdev_get_et_sset_count,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, int sset),
-	TP_ARGS(wiphy, netdev, sset),
-	TP_STRUCT__entry(
-		WIPHY_ENTRY
-		NETDEV_ENTRY
-		__field(int, sset)
-	),
-	TP_fast_assign(
-		WIPHY_ASSIGN;
-		NETDEV_ASSIGN;
-		__entry->sset = sset;
-	),
-	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", sset: %d",
-		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->sset)
-);
-
-TRACE_EVENT(rdev_get_et_strings,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u32 sset),
-	TP_ARGS(wiphy, netdev, sset),
-	TP_STRUCT__entry(
-		WIPHY_ENTRY
-		NETDEV_ENTRY
-		__field(u32, sset)
-	),
-	TP_fast_assign(
-		WIPHY_ASSIGN;
-		NETDEV_ASSIGN;
-		__entry->sset = sset;
-	),
-	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", sset: %u",
-		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->sset)
-);
-
 DEFINE_EVENT(wiphy_wdev_evt, rdev_get_channel,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
 	TP_ARGS(wiphy, wdev)
-- 
2.0.0.rc0

