Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42326 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751560AbdHEIp1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 04:45:27 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Beni Lev <beni.lev@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 11:44:37 +0300
Message-Id: <20170805084438.12550-10-luca@coelho.fi> (sfid-20170805_104532_321386_9003C093)
In-Reply-To: <20170805084438.12550-1-luca@coelho.fi>
References: <20170805084438.12550-1-luca@coelho.fi>
Subject: [PATCH 09/10] mac80211_hwsim: Add command to control rx status RSSI
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Beni Lev <beni.lev@intel.com>

Set the base RSSI of a TX frame. The final RSSI of the frame will be
the base RSSI + the radio's TX power

Signed-off-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 36 +++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 6467ffac9811..7c3811f0c730 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -368,6 +368,8 @@ static const struct ieee80211_rate hwsim_rates[] = {
 	{ .bitrate = 540 }
 };
 
+#define DEFAULT_RX_RSSI -50
+
 #define OUI_QCA 0x001374
 #define QCA_NL80211_SUBCMD_TEST 1
 enum qca_nl80211_vendor_subcmds {
@@ -571,6 +573,9 @@ struct mac80211_hwsim_data {
 	u64 rx_bytes;
 	u64 tx_dropped;
 	u64 tx_failed;
+
+	/* RSSI in rx status of the receiver */
+	int rx_rssi;
 };
 
 
@@ -783,6 +788,29 @@ DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_group,
 			hwsim_fops_group_read, hwsim_fops_group_write,
 			"%llx\n");
 
+static int hwsim_fops_rx_rssi_read(void *dat, u64 *val)
+{
+	struct mac80211_hwsim_data *data = dat;
+	*val = data->rx_rssi;
+	return 0;
+}
+
+static int hwsim_fops_rx_rssi_write(void *dat, u64 val)
+{
+	struct mac80211_hwsim_data *data = dat;
+	int rssi = (int)val;
+
+	if (rssi >= 0 || rssi < -100)
+		return -EINVAL;
+
+	data->rx_rssi = rssi;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_rx_rssi,
+			hwsim_fops_rx_rssi_read, hwsim_fops_rx_rssi_write,
+			"%lld\n");
+
 static netdev_tx_t hwsim_mon_xmit(struct sk_buff *skb,
 					struct net_device *dev)
 {
@@ -1210,8 +1238,8 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 		rx_status.bw = RATE_INFO_BW_20;
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
 		rx_status.enc_flags |= RX_ENC_FLAG_SHORT_GI;
-	/* TODO: simulate real signal strength (and optional packet loss) */
-	rx_status.signal = -50;
+	/* TODO: simulate optional packet loss */
+	rx_status.signal = data->rx_rssi;
 	if (info->control.vif)
 		rx_status.signal += info->control.vif->bss_conf.txpower;
 
@@ -2554,6 +2582,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		hw->wiphy->n_iface_combinations = ARRAY_SIZE(hwsim_if_comb);
 	}
 
+	data->rx_rssi = DEFAULT_RX_RSSI;
+
 	INIT_DELAYED_WORK(&data->roc_start, hw_roc_start);
 	INIT_DELAYED_WORK(&data->roc_done, hw_roc_done);
 	INIT_DELAYED_WORK(&data->hw_scan, hw_scan_work);
@@ -2715,6 +2745,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	debugfs_create_file("ps", 0666, data->debugfs, data, &hwsim_fops_ps);
 	debugfs_create_file("group", 0666, data->debugfs, data,
 			    &hwsim_fops_group);
+	debugfs_create_file("rx_rssi", 0666, data->debugfs, data,
+			    &hwsim_fops_rx_rssi);
 	if (!data->use_chanctx)
 		debugfs_create_file("dfs_simulate_radar", 0222,
 				    data->debugfs,
-- 
2.13.2
