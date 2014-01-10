Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaAJMvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 07:51:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/13] mac80211_hwsim: shuffle code to prepare for dynamic radios
Date: Fri, 10 Jan 2014 13:51:06 +0100
Message-Id: <1389358270-20901-10-git-send-email-johannes@sipsolutions.net> (sfid-20140110_135128_411686_C0816383)
In-Reply-To: <1389358270-20901-1-git-send-email-johannes@sipsolutions.net>
References: <1389358270-20901-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This will make the next patch, adding support for netlink,
smaller and more readable. The code is not modified here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 832 +++++++++++++++++-----------------
 1 file changed, 416 insertions(+), 416 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ca156a5..1c51c33 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -215,10 +215,53 @@ static const struct ieee80211_rate hwsim_rates[] = {
 	{ .bitrate = 540 }
 };
 
+static const struct ieee80211_iface_limit hwsim_if_limits[] = {
+	{ .max = 1, .types = BIT(NL80211_IFTYPE_ADHOC) },
+	{ .max = 2048,  .types = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
+#ifdef CONFIG_MAC80211_MESH
+				 BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+				 BIT(NL80211_IFTYPE_AP) |
+				 BIT(NL80211_IFTYPE_P2P_GO) },
+	{ .max = 1, .types = BIT(NL80211_IFTYPE_P2P_DEVICE) },
+};
+
+static const struct ieee80211_iface_limit hwsim_if_dfs_limits[] = {
+	{ .max = 8, .types = BIT(NL80211_IFTYPE_AP) },
+};
+
+static const struct ieee80211_iface_combination hwsim_if_comb[] = {
+	{
+		.limits = hwsim_if_limits,
+		.n_limits = ARRAY_SIZE(hwsim_if_limits),
+		.max_interfaces = 2048,
+		.num_different_channels = 1,
+	},
+	{
+		.limits = hwsim_if_dfs_limits,
+		.n_limits = ARRAY_SIZE(hwsim_if_dfs_limits),
+		.max_interfaces = 8,
+		.num_different_channels = 1,
+		.radar_detect_widths = BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+				       BIT(NL80211_CHAN_WIDTH_20) |
+				       BIT(NL80211_CHAN_WIDTH_40) |
+				       BIT(NL80211_CHAN_WIDTH_80) |
+				       BIT(NL80211_CHAN_WIDTH_160),
+	}
+};
+
 static spinlock_t hwsim_radio_lock;
 static struct list_head hwsim_radios;
 static int hwsim_radio_idx;
 
+static struct platform_driver mac80211_hwsim_driver = {
+	.driver = {
+		.name = "mac80211_hwsim",
+		.owner = THIS_MODULE,
+	},
+};
+
 struct mac80211_hwsim_data {
 	struct list_head list;
 	struct ieee80211_hw *hw;
@@ -311,6 +354,161 @@ static struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_COOKIE] = { .type = NLA_U64 },
 };
 
+static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
+				    struct sk_buff *skb,
+				    struct ieee80211_channel *chan);
+
+/* sysfs attributes */
+static void hwsim_send_ps_poll(void *dat, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct mac80211_hwsim_data *data = dat;
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+	struct sk_buff *skb;
+	struct ieee80211_pspoll *pspoll;
+
+	if (!vp->assoc)
+		return;
+
+	wiphy_debug(data->hw->wiphy,
+		    "%s: send PS-Poll to %pM for aid %d\n",
+		    __func__, vp->bssid, vp->aid);
+
+	skb = dev_alloc_skb(sizeof(*pspoll));
+	if (!skb)
+		return;
+	pspoll = (void *) skb_put(skb, sizeof(*pspoll));
+	pspoll->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
+					    IEEE80211_STYPE_PSPOLL |
+					    IEEE80211_FCTL_PM);
+	pspoll->aid = cpu_to_le16(0xc000 | vp->aid);
+	memcpy(pspoll->bssid, vp->bssid, ETH_ALEN);
+	memcpy(pspoll->ta, mac, ETH_ALEN);
+
+	rcu_read_lock();
+	mac80211_hwsim_tx_frame(data->hw, skb,
+				rcu_dereference(vif->chanctx_conf)->def.chan);
+	rcu_read_unlock();
+}
+
+static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
+				struct ieee80211_vif *vif, int ps)
+{
+	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
+	struct sk_buff *skb;
+	struct ieee80211_hdr *hdr;
+
+	if (!vp->assoc)
+		return;
+
+	wiphy_debug(data->hw->wiphy,
+		    "%s: send data::nullfunc to %pM ps=%d\n",
+		    __func__, vp->bssid, ps);
+
+	skb = dev_alloc_skb(sizeof(*hdr));
+	if (!skb)
+		return;
+	hdr = (void *) skb_put(skb, sizeof(*hdr) - ETH_ALEN);
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
+					 IEEE80211_STYPE_NULLFUNC |
+					 (ps ? IEEE80211_FCTL_PM : 0));
+	hdr->duration_id = cpu_to_le16(0);
+	memcpy(hdr->addr1, vp->bssid, ETH_ALEN);
+	memcpy(hdr->addr2, mac, ETH_ALEN);
+	memcpy(hdr->addr3, vp->bssid, ETH_ALEN);
+
+	rcu_read_lock();
+	mac80211_hwsim_tx_frame(data->hw, skb,
+				rcu_dereference(vif->chanctx_conf)->def.chan);
+	rcu_read_unlock();
+}
+
+
+static void hwsim_send_nullfunc_ps(void *dat, u8 *mac,
+				   struct ieee80211_vif *vif)
+{
+	struct mac80211_hwsim_data *data = dat;
+	hwsim_send_nullfunc(data, mac, vif, 1);
+}
+
+static void hwsim_send_nullfunc_no_ps(void *dat, u8 *mac,
+				      struct ieee80211_vif *vif)
+{
+	struct mac80211_hwsim_data *data = dat;
+	hwsim_send_nullfunc(data, mac, vif, 0);
+}
+
+static int hwsim_fops_ps_read(void *dat, u64 *val)
+{
+	struct mac80211_hwsim_data *data = dat;
+	*val = data->ps;
+	return 0;
+}
+
+static int hwsim_fops_ps_write(void *dat, u64 val)
+{
+	struct mac80211_hwsim_data *data = dat;
+	enum ps_mode old_ps;
+
+	if (val != PS_DISABLED && val != PS_ENABLED && val != PS_AUTO_POLL &&
+	    val != PS_MANUAL_POLL)
+		return -EINVAL;
+
+	old_ps = data->ps;
+	data->ps = val;
+
+	if (val == PS_MANUAL_POLL) {
+		ieee80211_iterate_active_interfaces(data->hw,
+						    IEEE80211_IFACE_ITER_NORMAL,
+						    hwsim_send_ps_poll, data);
+		data->ps_poll_pending = true;
+	} else if (old_ps == PS_DISABLED && val != PS_DISABLED) {
+		ieee80211_iterate_active_interfaces(data->hw,
+						    IEEE80211_IFACE_ITER_NORMAL,
+						    hwsim_send_nullfunc_ps,
+						    data);
+	} else if (old_ps != PS_DISABLED && val == PS_DISABLED) {
+		ieee80211_iterate_active_interfaces(data->hw,
+						    IEEE80211_IFACE_ITER_NORMAL,
+						    hwsim_send_nullfunc_no_ps,
+						    data);
+	}
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_ps, hwsim_fops_ps_read, hwsim_fops_ps_write,
+			"%llu\n");
+
+static int hwsim_write_simulate_radar(void *dat, u64 val)
+{
+	struct mac80211_hwsim_data *data = dat;
+
+	ieee80211_radar_detected(data->hw);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(hwsim_simulate_radar, NULL,
+			hwsim_write_simulate_radar, "%llu\n");
+
+static int hwsim_fops_group_read(void *dat, u64 *val)
+{
+	struct mac80211_hwsim_data *data = dat;
+	*val = data->group;
+	return 0;
+}
+
+static int hwsim_fops_group_write(void *dat, u64 val)
+{
+	struct mac80211_hwsim_data *data = dat;
+	data->group = val;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_group,
+			hwsim_fops_group_read, hwsim_fops_group_write,
+			"%llx\n");
+
 static netdev_tx_t hwsim_mon_xmit(struct sk_buff *skb,
 					struct net_device *dev)
 {
@@ -1283,8 +1481,6 @@ static const struct nla_policy hwsim_testmode_policy[HWSIM_TM_ATTR_MAX + 1] = {
 	[HWSIM_TM_ATTR_PS] = { .type = NLA_U32 },
 };
 
-static int hwsim_fops_ps_write(void *dat, u64 val);
-
 static int mac80211_hwsim_testmode_cmd(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       void *data, int len)
@@ -1622,210 +1818,265 @@ static const struct ieee80211_ops mac80211_hwsim_ops = {
 
 static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 
-static void mac80211_hwsim_destroy_radio(struct mac80211_hwsim_data *data)
-{
-	debugfs_remove_recursive(data->debugfs);
-	ieee80211_unregister_hw(data->hw);
-	device_release_driver(data->dev);
-	device_unregister(data->dev);
-	ieee80211_free_hw(data->hw);
-}
-
-static void mac80211_hwsim_free(void)
+static int __init mac80211_hwsim_create_radio(void)
 {
+	int err;
+	u8 addr[ETH_ALEN];
 	struct mac80211_hwsim_data *data;
+	struct ieee80211_hw *hw;
+	enum ieee80211_band band;
+	const struct ieee80211_ops *ops = &mac80211_hwsim_ops;
+	int idx;
 
 	spin_lock_bh(&hwsim_radio_lock);
-	while ((data = list_first_entry_or_null(&hwsim_radios,
-						struct mac80211_hwsim_data,
-						list))) {
-		list_del(&data->list);
-		spin_unlock_bh(&hwsim_radio_lock);
-		mac80211_hwsim_destroy_radio(data);
-		spin_lock_bh(&hwsim_radio_lock);
-	}
+	idx = hwsim_radio_idx++;
 	spin_unlock_bh(&hwsim_radio_lock);
-	class_destroy(hwsim_class);
-}
-
-static struct platform_driver mac80211_hwsim_driver = {
-	.driver = {
-		.name = "mac80211_hwsim",
-		.owner = THIS_MODULE,
-	},
-};
 
-static const struct net_device_ops hwsim_netdev_ops = {
-	.ndo_start_xmit 	= hwsim_mon_xmit,
-	.ndo_change_mtu		= eth_change_mtu,
-	.ndo_set_mac_address 	= eth_mac_addr,
-	.ndo_validate_addr	= eth_validate_addr,
-};
+	if (channels > 1)
+		ops = &mac80211_hwsim_mchan_ops;
+	hw = ieee80211_alloc_hw(sizeof(*data), ops);
+	if (!hw) {
+		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_alloc_hw failed\n");
+		err = -ENOMEM;
+		goto failed;
+	}
+	data = hw->priv;
+	data->hw = hw;
 
-static void hwsim_mon_setup(struct net_device *dev)
-{
-	dev->netdev_ops = &hwsim_netdev_ops;
-	dev->destructor = free_netdev;
-	ether_setup(dev);
-	dev->tx_queue_len = 0;
-	dev->type = ARPHRD_IEEE80211_RADIOTAP;
-	memset(dev->dev_addr, 0, ETH_ALEN);
-	dev->dev_addr[0] = 0x12;
-}
+	data->dev = device_create(hwsim_class, NULL, 0, hw, "hwsim%d", idx);
+	if (IS_ERR(data->dev)) {
+		printk(KERN_DEBUG
+		       "mac80211_hwsim: device_create failed (%ld)\n",
+		       PTR_ERR(data->dev));
+		err = -ENOMEM;
+		goto failed_drvdata;
+	}
+	data->dev->driver = &mac80211_hwsim_driver.driver;
+	err = device_bind_driver(data->dev);
+	if (err != 0) {
+		printk(KERN_DEBUG "mac80211_hwsim: device_bind_driver failed (%d)\n",
+		       err);
+		goto failed_hw;
+	}
 
+	skb_queue_head_init(&data->pending);
 
-static void hwsim_send_ps_poll(void *dat, u8 *mac, struct ieee80211_vif *vif)
-{
-	struct mac80211_hwsim_data *data = dat;
-	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
-	struct sk_buff *skb;
-	struct ieee80211_pspoll *pspoll;
+	SET_IEEE80211_DEV(hw, data->dev);
+	memset(addr, 0, ETH_ALEN);
+	addr[0] = 0x02;
+	addr[3] = idx >> 8;
+	addr[4] = idx;
+	memcpy(data->addresses[0].addr, addr, ETH_ALEN);
+	memcpy(data->addresses[1].addr, addr, ETH_ALEN);
+	data->addresses[1].addr[0] |= 0x40;
+	hw->wiphy->n_addresses = 2;
+	hw->wiphy->addresses = data->addresses;
 
-	if (!vp->assoc)
-		return;
+	data->channels = channels;
 
-	wiphy_debug(data->hw->wiphy,
-		    "%s: send PS-Poll to %pM for aid %d\n",
-		    __func__, vp->bssid, vp->aid);
+	if (data->channels > 1) {
+		hw->wiphy->max_scan_ssids = 255;
+		hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
+		hw->wiphy->max_remain_on_channel_duration = 1000;
+		/* For channels > 1 DFS is not allowed */
+		hw->wiphy->n_iface_combinations = 1;
+		hw->wiphy->iface_combinations = &data->if_combination;
+		data->if_combination = hwsim_if_comb[0];
+		data->if_combination.num_different_channels = data->channels;
+	} else {
+		hw->wiphy->iface_combinations = hwsim_if_comb;
+		hw->wiphy->n_iface_combinations = ARRAY_SIZE(hwsim_if_comb);
+	}
 
-	skb = dev_alloc_skb(sizeof(*pspoll));
-	if (!skb)
-		return;
-	pspoll = (void *) skb_put(skb, sizeof(*pspoll));
-	pspoll->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
-					    IEEE80211_STYPE_PSPOLL |
-					    IEEE80211_FCTL_PM);
-	pspoll->aid = cpu_to_le16(0xc000 | vp->aid);
-	memcpy(pspoll->bssid, vp->bssid, ETH_ALEN);
-	memcpy(pspoll->ta, mac, ETH_ALEN);
+	INIT_DELAYED_WORK(&data->roc_done, hw_roc_done);
+	INIT_DELAYED_WORK(&data->hw_scan, hw_scan_work);
 
-	rcu_read_lock();
-	mac80211_hwsim_tx_frame(data->hw, skb,
-				rcu_dereference(vif->chanctx_conf)->def.chan);
-	rcu_read_unlock();
-}
+	hw->queues = 5;
+	hw->offchannel_tx_hw_queue = 4;
+	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				     BIT(NL80211_IFTYPE_AP) |
+				     BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				     BIT(NL80211_IFTYPE_P2P_GO) |
+				     BIT(NL80211_IFTYPE_ADHOC) |
+				     BIT(NL80211_IFTYPE_MESH_POINT) |
+				     BIT(NL80211_IFTYPE_P2P_DEVICE);
 
-static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
-				struct ieee80211_vif *vif, int ps)
-{
-	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
-	struct sk_buff *skb;
-	struct ieee80211_hdr *hdr;
+	hw->flags = IEEE80211_HW_MFP_CAPABLE |
+		    IEEE80211_HW_SIGNAL_DBM |
+		    IEEE80211_HW_SUPPORTS_STATIC_SMPS |
+		    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
+		    IEEE80211_HW_AMPDU_AGGREGATION |
+		    IEEE80211_HW_WANT_MONITOR_VIF |
+		    IEEE80211_HW_QUEUE_CONTROL |
+		    IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
+	if (rctbl)
+		hw->flags |= IEEE80211_HW_SUPPORTS_RC_TABLE;
 
-	if (!vp->assoc)
-		return;
+	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
+			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
+			    WIPHY_FLAG_AP_UAPSD;
+	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
 
-	wiphy_debug(data->hw->wiphy,
-		    "%s: send data::nullfunc to %pM ps=%d\n",
-		    __func__, vp->bssid, ps);
+	/* ask mac80211 to reserve space for magic */
+	hw->vif_data_size = sizeof(struct hwsim_vif_priv);
+	hw->sta_data_size = sizeof(struct hwsim_sta_priv);
+	hw->chanctx_data_size = sizeof(struct hwsim_chanctx_priv);
 
-	skb = dev_alloc_skb(sizeof(*hdr));
-	if (!skb)
-		return;
-	hdr = (void *) skb_put(skb, sizeof(*hdr) - ETH_ALEN);
-	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
-					 IEEE80211_STYPE_NULLFUNC |
-					 (ps ? IEEE80211_FCTL_PM : 0));
-	hdr->duration_id = cpu_to_le16(0);
-	memcpy(hdr->addr1, vp->bssid, ETH_ALEN);
-	memcpy(hdr->addr2, mac, ETH_ALEN);
-	memcpy(hdr->addr3, vp->bssid, ETH_ALEN);
+	memcpy(data->channels_2ghz, hwsim_channels_2ghz,
+		sizeof(hwsim_channels_2ghz));
+	memcpy(data->channels_5ghz, hwsim_channels_5ghz,
+		sizeof(hwsim_channels_5ghz));
+	memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));
 
-	rcu_read_lock();
-	mac80211_hwsim_tx_frame(data->hw, skb,
-				rcu_dereference(vif->chanctx_conf)->def.chan);
-	rcu_read_unlock();
-}
+	for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
+		struct ieee80211_supported_band *sband = &data->bands[band];
+		switch (band) {
+		case IEEE80211_BAND_2GHZ:
+			sband->channels = data->channels_2ghz;
+			sband->n_channels = ARRAY_SIZE(hwsim_channels_2ghz);
+			sband->bitrates = data->rates;
+			sband->n_bitrates = ARRAY_SIZE(hwsim_rates);
+			break;
+		case IEEE80211_BAND_5GHZ:
+			sband->channels = data->channels_5ghz;
+			sband->n_channels = ARRAY_SIZE(hwsim_channels_5ghz);
+			sband->bitrates = data->rates + 4;
+			sband->n_bitrates = ARRAY_SIZE(hwsim_rates) - 4;
+			break;
+		default:
+			continue;
+		}
 
+		sband->ht_cap.ht_supported = true;
+		sband->ht_cap.cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+				    IEEE80211_HT_CAP_GRN_FLD |
+				    IEEE80211_HT_CAP_SGI_40 |
+				    IEEE80211_HT_CAP_DSSSCCK40;
+		sband->ht_cap.ampdu_factor = 0x3;
+		sband->ht_cap.ampdu_density = 0x6;
+		memset(&sband->ht_cap.mcs, 0,
+		       sizeof(sband->ht_cap.mcs));
+		sband->ht_cap.mcs.rx_mask[0] = 0xff;
+		sband->ht_cap.mcs.rx_mask[1] = 0xff;
+		sband->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 
-static void hwsim_send_nullfunc_ps(void *dat, u8 *mac,
-				   struct ieee80211_vif *vif)
-{
-	struct mac80211_hwsim_data *data = dat;
-	hwsim_send_nullfunc(data, mac, vif, 1);
-}
+		hw->wiphy->bands[band] = sband;
 
+		sband->vht_cap.vht_supported = true;
+		sband->vht_cap.cap =
+			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
+			IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ |
+			IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ |
+			IEEE80211_VHT_CAP_RXLDPC |
+			IEEE80211_VHT_CAP_SHORT_GI_80 |
+			IEEE80211_VHT_CAP_SHORT_GI_160 |
+			IEEE80211_VHT_CAP_TXSTBC |
+			IEEE80211_VHT_CAP_RXSTBC_1 |
+			IEEE80211_VHT_CAP_RXSTBC_2 |
+			IEEE80211_VHT_CAP_RXSTBC_3 |
+			IEEE80211_VHT_CAP_RXSTBC_4 |
+			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
+		sband->vht_cap.vht_mcs.rx_mcs_map =
+			cpu_to_le16(IEEE80211_VHT_MCS_SUPPORT_0_8 << 0 |
+				    IEEE80211_VHT_MCS_SUPPORT_0_8 << 2 |
+				    IEEE80211_VHT_MCS_SUPPORT_0_9 << 4 |
+				    IEEE80211_VHT_MCS_SUPPORT_0_8 << 6 |
+				    IEEE80211_VHT_MCS_SUPPORT_0_8 << 8 |
+				    IEEE80211_VHT_MCS_SUPPORT_0_9 << 10 |
+				    IEEE80211_VHT_MCS_SUPPORT_0_9 << 12 |
+				    IEEE80211_VHT_MCS_SUPPORT_0_8 << 14);
+		sband->vht_cap.vht_mcs.tx_mcs_map =
+			sband->vht_cap.vht_mcs.rx_mcs_map;
+	}
 
-static void hwsim_send_nullfunc_no_ps(void *dat, u8 *mac,
-				      struct ieee80211_vif *vif)
-{
-	struct mac80211_hwsim_data *data = dat;
-	hwsim_send_nullfunc(data, mac, vif, 0);
-}
+	/* By default all radios belong to the first group */
+	data->group = 1;
+	mutex_init(&data->mutex);
 
+	/* Enable frame retransmissions for lossy channels */
+	hw->max_rates = 4;
+	hw->max_rate_tries = 11;
 
-static int hwsim_fops_ps_read(void *dat, u64 *val)
-{
-	struct mac80211_hwsim_data *data = dat;
-	*val = data->ps;
-	return 0;
-}
+	err = ieee80211_register_hw(hw);
+	if (err < 0) {
+		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_register_hw failed (%d)\n",
+		       err);
+		goto failed_hw;
+	}
 
-static int hwsim_fops_ps_write(void *dat, u64 val)
-{
-	struct mac80211_hwsim_data *data = dat;
-	enum ps_mode old_ps;
+	wiphy_debug(hw->wiphy, "hwaddr %pM registered\n", hw->wiphy->perm_addr);
 
-	if (val != PS_DISABLED && val != PS_ENABLED && val != PS_AUTO_POLL &&
-	    val != PS_MANUAL_POLL)
-		return -EINVAL;
+	data->debugfs = debugfs_create_dir("hwsim", hw->wiphy->debugfsdir);
+	debugfs_create_file("ps", 0666, data->debugfs, data, &hwsim_fops_ps);
+	debugfs_create_file("group", 0666, data->debugfs, data,
+			    &hwsim_fops_group);
+	if (data->channels == 1)
+		debugfs_create_file("dfs_simulate_radar", 0222,
+				    data->debugfs,
+				    data, &hwsim_simulate_radar);
 
-	old_ps = data->ps;
-	data->ps = val;
+	tasklet_hrtimer_init(&data->beacon_timer,
+			     mac80211_hwsim_beacon,
+			     CLOCK_MONOTONIC_RAW, HRTIMER_MODE_ABS);
 
-	if (val == PS_MANUAL_POLL) {
-		ieee80211_iterate_active_interfaces(data->hw,
-						    IEEE80211_IFACE_ITER_NORMAL,
-						    hwsim_send_ps_poll, data);
-		data->ps_poll_pending = true;
-	} else if (old_ps == PS_DISABLED && val != PS_DISABLED) {
-		ieee80211_iterate_active_interfaces(data->hw,
-						    IEEE80211_IFACE_ITER_NORMAL,
-						    hwsim_send_nullfunc_ps,
-						    data);
-	} else if (old_ps != PS_DISABLED && val == PS_DISABLED) {
-		ieee80211_iterate_active_interfaces(data->hw,
-						    IEEE80211_IFACE_ITER_NORMAL,
-						    hwsim_send_nullfunc_no_ps,
-						    data);
-	}
+	spin_lock_bh(&hwsim_radio_lock);
+	list_add_tail(&data->list, &hwsim_radios);
+	spin_unlock_bh(&hwsim_radio_lock);
 
 	return 0;
-}
 
-DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_ps, hwsim_fops_ps_read, hwsim_fops_ps_write,
-			"%llu\n");
+failed_hw:
+	device_unregister(data->dev);
+failed_drvdata:
+	ieee80211_free_hw(hw);
+failed:
+	return err;
+}
 
-static int hwsim_write_simulate_radar(void *dat, u64 val)
+static void mac80211_hwsim_destroy_radio(struct mac80211_hwsim_data *data)
 {
-	struct mac80211_hwsim_data *data = dat;
-
-	ieee80211_radar_detected(data->hw);
-
-	return 0;
+	debugfs_remove_recursive(data->debugfs);
+	ieee80211_unregister_hw(data->hw);
+	device_release_driver(data->dev);
+	device_unregister(data->dev);
+	ieee80211_free_hw(data->hw);
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(hwsim_simulate_radar, NULL,
-			hwsim_write_simulate_radar, "%llu\n");
-
-static int hwsim_fops_group_read(void *dat, u64 *val)
+static void mac80211_hwsim_free(void)
 {
-	struct mac80211_hwsim_data *data = dat;
-	*val = data->group;
-	return 0;
+	struct mac80211_hwsim_data *data;
+
+	spin_lock_bh(&hwsim_radio_lock);
+	while ((data = list_first_entry_or_null(&hwsim_radios,
+						struct mac80211_hwsim_data,
+						list))) {
+		list_del(&data->list);
+		spin_unlock_bh(&hwsim_radio_lock);
+		mac80211_hwsim_destroy_radio(data);
+		spin_lock_bh(&hwsim_radio_lock);
+	}
+	spin_unlock_bh(&hwsim_radio_lock);
+	class_destroy(hwsim_class);
 }
 
-static int hwsim_fops_group_write(void *dat, u64 val)
+static const struct net_device_ops hwsim_netdev_ops = {
+	.ndo_start_xmit 	= hwsim_mon_xmit,
+	.ndo_change_mtu		= eth_change_mtu,
+	.ndo_set_mac_address 	= eth_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+};
+
+static void hwsim_mon_setup(struct net_device *dev)
 {
-	struct mac80211_hwsim_data *data = dat;
-	data->group = val;
-	return 0;
+	dev->netdev_ops = &hwsim_netdev_ops;
+	dev->destructor = free_netdev;
+	ether_setup(dev);
+	dev->tx_queue_len = 0;
+	dev->type = ARPHRD_IEEE80211_RADIOTAP;
+	memset(dev->dev_addr, 0, ETH_ALEN);
+	dev->dev_addr[0] = 0x12;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_group,
-			hwsim_fops_group_read, hwsim_fops_group_write,
-			"%llx\n");
-
 static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
 {
 	struct mac80211_hwsim_data *data;
@@ -2073,257 +2324,6 @@ static void hwsim_exit_netlink(void)
 	genl_unregister_family(&hwsim_genl_family);
 }
 
-static const struct ieee80211_iface_limit hwsim_if_limits[] = {
-	{ .max = 1, .types = BIT(NL80211_IFTYPE_ADHOC) },
-	{ .max = 2048,  .types = BIT(NL80211_IFTYPE_STATION) |
-				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
-#ifdef CONFIG_MAC80211_MESH
-				 BIT(NL80211_IFTYPE_MESH_POINT) |
-#endif
-				 BIT(NL80211_IFTYPE_AP) |
-				 BIT(NL80211_IFTYPE_P2P_GO) },
-	{ .max = 1, .types = BIT(NL80211_IFTYPE_P2P_DEVICE) },
-};
-
-static const struct ieee80211_iface_limit hwsim_if_dfs_limits[] = {
-	{ .max = 8, .types = BIT(NL80211_IFTYPE_AP) },
-};
-
-static const struct ieee80211_iface_combination hwsim_if_comb[] = {
-	{
-		.limits = hwsim_if_limits,
-		.n_limits = ARRAY_SIZE(hwsim_if_limits),
-		.max_interfaces = 2048,
-		.num_different_channels = 1,
-	},
-	{
-		.limits = hwsim_if_dfs_limits,
-		.n_limits = ARRAY_SIZE(hwsim_if_dfs_limits),
-		.max_interfaces = 8,
-		.num_different_channels = 1,
-		.radar_detect_widths = BIT(NL80211_CHAN_WIDTH_20_NOHT) |
-				       BIT(NL80211_CHAN_WIDTH_20) |
-				       BIT(NL80211_CHAN_WIDTH_40) |
-				       BIT(NL80211_CHAN_WIDTH_80) |
-				       BIT(NL80211_CHAN_WIDTH_160),
-	}
-};
-
-static int __init mac80211_hwsim_create_radio(void)
-{
-	int err;
-	u8 addr[ETH_ALEN];
-	struct mac80211_hwsim_data *data;
-	struct ieee80211_hw *hw;
-	enum ieee80211_band band;
-	const struct ieee80211_ops *ops = &mac80211_hwsim_ops;
-	int idx;
-
-	spin_lock_bh(&hwsim_radio_lock);
-	idx = hwsim_radio_idx++;
-	spin_unlock_bh(&hwsim_radio_lock);
-
-	if (channels > 1)
-		ops = &mac80211_hwsim_mchan_ops;
-	hw = ieee80211_alloc_hw(sizeof(*data), ops);
-	if (!hw) {
-		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_alloc_hw failed\n");
-		err = -ENOMEM;
-		goto failed;
-	}
-	data = hw->priv;
-	data->hw = hw;
-
-	data->dev = device_create(hwsim_class, NULL, 0, hw, "hwsim%d", idx);
-	if (IS_ERR(data->dev)) {
-		printk(KERN_DEBUG
-		       "mac80211_hwsim: device_create failed (%ld)\n",
-		       PTR_ERR(data->dev));
-		err = -ENOMEM;
-		goto failed_drvdata;
-	}
-	data->dev->driver = &mac80211_hwsim_driver.driver;
-	err = device_bind_driver(data->dev);
-	if (err != 0) {
-		printk(KERN_DEBUG "mac80211_hwsim: device_bind_driver failed (%d)\n",
-		       err);
-		goto failed_hw;
-	}
-
-	skb_queue_head_init(&data->pending);
-
-	SET_IEEE80211_DEV(hw, data->dev);
-	memset(addr, 0, ETH_ALEN);
-	addr[0] = 0x02;
-	addr[3] = idx >> 8;
-	addr[4] = idx;
-	memcpy(data->addresses[0].addr, addr, ETH_ALEN);
-	memcpy(data->addresses[1].addr, addr, ETH_ALEN);
-	data->addresses[1].addr[0] |= 0x40;
-	hw->wiphy->n_addresses = 2;
-	hw->wiphy->addresses = data->addresses;
-
-	data->channels = channels;
-
-	if (data->channels > 1) {
-		hw->wiphy->max_scan_ssids = 255;
-		hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
-		hw->wiphy->max_remain_on_channel_duration = 1000;
-		/* For channels > 1 DFS is not allowed */
-		hw->wiphy->n_iface_combinations = 1;
-		hw->wiphy->iface_combinations = &data->if_combination;
-		data->if_combination = hwsim_if_comb[0];
-		data->if_combination.num_different_channels = data->channels;
-	} else {
-		hw->wiphy->iface_combinations = hwsim_if_comb;
-		hw->wiphy->n_iface_combinations = ARRAY_SIZE(hwsim_if_comb);
-	}
-
-	INIT_DELAYED_WORK(&data->roc_done, hw_roc_done);
-	INIT_DELAYED_WORK(&data->hw_scan, hw_scan_work);
-
-	hw->queues = 5;
-	hw->offchannel_tx_hw_queue = 4;
-	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-				     BIT(NL80211_IFTYPE_AP) |
-				     BIT(NL80211_IFTYPE_P2P_CLIENT) |
-				     BIT(NL80211_IFTYPE_P2P_GO) |
-				     BIT(NL80211_IFTYPE_ADHOC) |
-				     BIT(NL80211_IFTYPE_MESH_POINT) |
-				     BIT(NL80211_IFTYPE_P2P_DEVICE);
-
-	hw->flags = IEEE80211_HW_MFP_CAPABLE |
-		    IEEE80211_HW_SIGNAL_DBM |
-		    IEEE80211_HW_SUPPORTS_STATIC_SMPS |
-		    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
-		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    IEEE80211_HW_WANT_MONITOR_VIF |
-		    IEEE80211_HW_QUEUE_CONTROL |
-		    IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
-	if (rctbl)
-		hw->flags |= IEEE80211_HW_SUPPORTS_RC_TABLE;
-
-	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
-			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-			    WIPHY_FLAG_AP_UAPSD;
-	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
-
-	/* ask mac80211 to reserve space for magic */
-	hw->vif_data_size = sizeof(struct hwsim_vif_priv);
-	hw->sta_data_size = sizeof(struct hwsim_sta_priv);
-	hw->chanctx_data_size = sizeof(struct hwsim_chanctx_priv);
-
-	memcpy(data->channels_2ghz, hwsim_channels_2ghz,
-		sizeof(hwsim_channels_2ghz));
-	memcpy(data->channels_5ghz, hwsim_channels_5ghz,
-		sizeof(hwsim_channels_5ghz));
-	memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));
-
-	for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
-		struct ieee80211_supported_band *sband = &data->bands[band];
-		switch (band) {
-		case IEEE80211_BAND_2GHZ:
-			sband->channels = data->channels_2ghz;
-			sband->n_channels = ARRAY_SIZE(hwsim_channels_2ghz);
-			sband->bitrates = data->rates;
-			sband->n_bitrates = ARRAY_SIZE(hwsim_rates);
-			break;
-		case IEEE80211_BAND_5GHZ:
-			sband->channels = data->channels_5ghz;
-			sband->n_channels = ARRAY_SIZE(hwsim_channels_5ghz);
-			sband->bitrates = data->rates + 4;
-			sband->n_bitrates = ARRAY_SIZE(hwsim_rates) - 4;
-			break;
-		default:
-			continue;
-		}
-
-		sband->ht_cap.ht_supported = true;
-		sband->ht_cap.cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
-				    IEEE80211_HT_CAP_GRN_FLD |
-				    IEEE80211_HT_CAP_SGI_40 |
-				    IEEE80211_HT_CAP_DSSSCCK40;
-		sband->ht_cap.ampdu_factor = 0x3;
-		sband->ht_cap.ampdu_density = 0x6;
-		memset(&sband->ht_cap.mcs, 0,
-		       sizeof(sband->ht_cap.mcs));
-		sband->ht_cap.mcs.rx_mask[0] = 0xff;
-		sband->ht_cap.mcs.rx_mask[1] = 0xff;
-		sband->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
-
-		hw->wiphy->bands[band] = sband;
-
-		sband->vht_cap.vht_supported = true;
-		sband->vht_cap.cap =
-			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
-			IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ |
-			IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ |
-			IEEE80211_VHT_CAP_RXLDPC |
-			IEEE80211_VHT_CAP_SHORT_GI_80 |
-			IEEE80211_VHT_CAP_SHORT_GI_160 |
-			IEEE80211_VHT_CAP_TXSTBC |
-			IEEE80211_VHT_CAP_RXSTBC_1 |
-			IEEE80211_VHT_CAP_RXSTBC_2 |
-			IEEE80211_VHT_CAP_RXSTBC_3 |
-			IEEE80211_VHT_CAP_RXSTBC_4 |
-			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
-		sband->vht_cap.vht_mcs.rx_mcs_map =
-			cpu_to_le16(IEEE80211_VHT_MCS_SUPPORT_0_8 << 0 |
-				    IEEE80211_VHT_MCS_SUPPORT_0_8 << 2 |
-				    IEEE80211_VHT_MCS_SUPPORT_0_9 << 4 |
-				    IEEE80211_VHT_MCS_SUPPORT_0_8 << 6 |
-				    IEEE80211_VHT_MCS_SUPPORT_0_8 << 8 |
-				    IEEE80211_VHT_MCS_SUPPORT_0_9 << 10 |
-				    IEEE80211_VHT_MCS_SUPPORT_0_9 << 12 |
-				    IEEE80211_VHT_MCS_SUPPORT_0_8 << 14);
-		sband->vht_cap.vht_mcs.tx_mcs_map =
-			sband->vht_cap.vht_mcs.rx_mcs_map;
-	}
-
-	/* By default all radios belong to the first group */
-	data->group = 1;
-	mutex_init(&data->mutex);
-
-	/* Enable frame retransmissions for lossy channels */
-	hw->max_rates = 4;
-	hw->max_rate_tries = 11;
-
-	err = ieee80211_register_hw(hw);
-	if (err < 0) {
-		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_register_hw failed (%d)\n",
-		       err);
-		goto failed_hw;
-	}
-
-	wiphy_debug(hw->wiphy, "hwaddr %pM registered\n", hw->wiphy->perm_addr);
-
-	data->debugfs = debugfs_create_dir("hwsim", hw->wiphy->debugfsdir);
-	debugfs_create_file("ps", 0666, data->debugfs, data, &hwsim_fops_ps);
-	debugfs_create_file("group", 0666, data->debugfs, data,
-			    &hwsim_fops_group);
-	if (data->channels == 1)
-		debugfs_create_file("dfs_simulate_radar", 0222,
-				    data->debugfs,
-				    data, &hwsim_simulate_radar);
-
-	tasklet_hrtimer_init(&data->beacon_timer,
-			     mac80211_hwsim_beacon,
-			     CLOCK_MONOTONIC_RAW, HRTIMER_MODE_ABS);
-
-	spin_lock_bh(&hwsim_radio_lock);
-	list_add_tail(&data->list, &hwsim_radios);
-	spin_unlock_bh(&hwsim_radio_lock);
-
-	return 0;
-
-failed_hw:
-	device_unregister(data->dev);
-failed_drvdata:
-	ieee80211_free_hw(hw);
-failed:
-	return err;
-}
-
 static int __init init_mac80211_hwsim(void)
 {
 	int i, err;
-- 
1.8.5.1

