Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54002 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbbJUXxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 19:53:23 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath6kl@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] ath6k:  implement ethtool stats.
Date: Wed, 21 Oct 2015 16:53:17 -0700
Message-Id: <1445471597-26091-2-git-send-email-greearb@candelatech.com> (sfid-20151022_015326_390556_F5E6B51F)
In-Reply-To: <1445471597-26091-1-git-send-email-greearb@candelatech.com>
References: <1445471597-26091-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This supports a way to get target stats through normal
ethtool stats API.

For instance:
# ethtool -S wlan1
NIC statistics:
     tx_pkts_nic: 353
     tx_bytes_nic: 25142
     rx_pkts_nic: 6
     rx_bytes_nic: 996
     d_tx_ucast_pkts: 89
     d_tx_bcast_pkts: 264
     d_tx_ucast_bytes: 3020
     d_tx_bcast_bytes: 22122
...

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 123 +++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 6fcb39b..46b6f94 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3645,6 +3645,127 @@ void ath6kl_cfg80211_vif_cleanup(struct ath6kl_vif *vif)
 	ar->num_vif--;
 }
 
+static const char ath6k_gstrings_sta_stats[][ETH_GSTRING_LEN] = {
+	/* Common stats names used by many drivers. */
+	"tx_pkts_nic", "tx_bytes_nic", "rx_pkts_nic", "rx_bytes_nic",
+
+	/* TX stats. */
+	"d_tx_ucast_pkts", "d_tx_bcast_pkts",
+	"d_tx_ucast_bytes", "d_tx_bcast_bytes",
+	"d_tx_rts_ok", "d_tx_error", "d_tx_fail",
+	"d_tx_retry", "d_tx_multi_retry", "d_tx_rts_fail",
+	"d_tx_tkip_counter_measures",
+
+	/* RX Stats. */
+	"d_rx_ucast_pkts", "d_rx_ucast_rate", "d_rx_bcast_pkts",
+	"d_rx_ucast_bytes", "d_rx_bcast_bytes", "d_rx_frag_pkt",
+	"d_rx_error", "d_rx_crc_err", "d_rx_keycache_miss",
+	"d_rx_decrypt_crc_err", "d_rx_duplicate_frames",
+	"d_rx_mic_err", "d_rx_tkip_format_err", "d_rx_ccmp_format_err",
+	"d_rx_ccmp_replay_err",
+
+	/* Misc stats. */
+	"d_beacon_miss", "d_num_connects", "d_num_disconnects",
+	"d_beacon_avg_rssi", "d_arp_received", "d_arp_matched",
+	"d_arp_replied"
+};
+
+#define ATH6K_STATS_LEN	ARRAY_SIZE(ath6k_gstrings_sta_stats)
+
+static int ath6k_get_sset_count(struct net_device *dev, int sset)
+{
+	int rv = 0;
+
+	if (sset == ETH_SS_STATS)
+		rv += ATH6K_STATS_LEN;
+
+	if (rv == 0)
+		return -EOPNOTSUPP;
+	return rv;
+}
+
+static void ath6k_get_stats(struct net_device *dev,
+			    struct ethtool_stats *stats,
+			    u64 *data)
+{
+	struct ath6kl_vif *vif = netdev_priv(dev);
+	struct ath6kl *ar = vif->ar;
+	int i = 0;
+	struct target_stats *tgt_stats;
+
+	memset(data, 0, sizeof(u64) * ATH6K_STATS_LEN);
+
+	ath6k_read_tgt_stats(ar, vif);
+
+	tgt_stats = &vif->target_stats;
+
+	data[i++] = tgt_stats->tx_ucast_pkt + tgt_stats->tx_bcast_pkt;
+	data[i++] = tgt_stats->tx_ucast_byte + tgt_stats->tx_bcast_byte;
+	data[i++] = tgt_stats->rx_ucast_pkt + tgt_stats->rx_bcast_pkt;
+	data[i++] = tgt_stats->rx_ucast_byte + tgt_stats->rx_bcast_byte;
+
+	data[i++] = tgt_stats->tx_ucast_pkt;
+	data[i++] = tgt_stats->tx_bcast_pkt;
+	data[i++] = tgt_stats->tx_ucast_byte;
+	data[i++] = tgt_stats->tx_bcast_byte;
+	data[i++] = tgt_stats->tx_rts_success_cnt;
+	data[i++] = tgt_stats->tx_err;
+	data[i++] = tgt_stats->tx_fail_cnt;
+	data[i++] = tgt_stats->tx_retry_cnt;
+	data[i++] = tgt_stats->tx_mult_retry_cnt;
+	data[i++] = tgt_stats->tx_rts_fail_cnt;
+	data[i++] = tgt_stats->tkip_cnter_measures_invoked;
+
+	data[i++] = tgt_stats->rx_ucast_pkt;
+	data[i++] = tgt_stats->rx_ucast_rate;
+	data[i++] = tgt_stats->rx_bcast_pkt;
+	data[i++] = tgt_stats->rx_ucast_byte;
+	data[i++] = tgt_stats->rx_bcast_byte;
+	data[i++] = tgt_stats->rx_frgment_pkt;
+	data[i++] = tgt_stats->rx_err;
+	data[i++] = tgt_stats->rx_crc_err;
+	data[i++] = tgt_stats->rx_key_cache_miss;
+	data[i++] = tgt_stats->rx_decrypt_err;
+	data[i++] = tgt_stats->rx_dupl_frame;
+	data[i++] = tgt_stats->tkip_local_mic_fail;
+	data[i++] = tgt_stats->tkip_fmt_err;
+	data[i++] = tgt_stats->ccmp_fmt_err;
+	data[i++] = tgt_stats->ccmp_replays;
+
+	data[i++] = tgt_stats->cs_bmiss_cnt;
+	data[i++] = tgt_stats->cs_connect_cnt;
+	data[i++] = tgt_stats->cs_discon_cnt;
+	data[i++] = tgt_stats->cs_ave_beacon_rssi;
+	data[i++] = tgt_stats->arp_received;
+	data[i++] = tgt_stats->arp_matched;
+	data[i++] = tgt_stats->arp_replied;
+
+	if (i !=  ATH6K_STATS_LEN) {
+		WARN_ON_ONCE(1);
+		ath6kl_err("ethtool stats error, i: %d  STATS_LEN: %d\n",
+			   i, (int)ATH6K_STATS_LEN);
+	}
+}
+
+/* These stats are per NIC, not really per vdev, so we just ignore dev. */
+static void ath6k_get_strings(struct net_device *dev, u32 sset, u8 *data)
+{
+	int sz_sta_stats = 0;
+
+	if (sset == ETH_SS_STATS) {
+		sz_sta_stats = sizeof(ath6k_gstrings_sta_stats);
+		memcpy(data, ath6k_gstrings_sta_stats, sz_sta_stats);
+	}
+}
+
+const struct ethtool_ops ath6k_ethtool_ops = {
+	.get_drvinfo = cfg80211_get_drvinfo,
+	.get_link = ethtool_op_get_link,
+	.get_strings = ath6k_get_strings,
+	.get_ethtool_stats = ath6k_get_stats,
+	.get_sset_count = ath6k_get_sset_count,
+};
+
 struct wireless_dev *ath6kl_interface_add(struct ath6kl *ar, const char *name,
 					  unsigned char name_assign_type,
 					  enum nl80211_iftype type,
@@ -3690,6 +3811,8 @@ struct wireless_dev *ath6kl_interface_add(struct ath6kl *ar, const char *name,
 	if (ath6kl_cfg80211_vif_init(vif))
 		goto err;
 
+	netdev_set_default_ethtool_ops(ndev, &ath6k_ethtool_ops);
+
 	if (register_netdevice(ndev))
 		goto err;
 
-- 
2.4.3

