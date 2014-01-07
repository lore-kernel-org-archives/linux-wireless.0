Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbaAGXPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 18:15:22 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 04/12] mac80211_hwsim: refactor radio registration
Date: Wed,  8 Jan 2014 00:15:09 +0100
Message-Id: <1389136517-21216-5-git-send-email-johannes@sipsolutions.net> (sfid-20140108_001530_828423_610D8178)
In-Reply-To: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
References: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to support dynamic radio registration in the future,
refactor the actual registration into a new function with only
minor cleanups. Since it had to change anyway, also clean up
the init error paths.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 455 +++++++++++++++++-----------------
 1 file changed, 225 insertions(+), 230 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 55cdfd6..23fa6ee 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2122,14 +2122,219 @@ static const struct ieee80211_iface_combination hwsim_if_comb[] = {
 	}
 };
 
-static int __init init_mac80211_hwsim(void)
+static int __init mac80211_hwsim_create_radio(int idx)
 {
-	int i, err = 0;
+	int err;
 	u8 addr[ETH_ALEN];
 	struct mac80211_hwsim_data *data;
 	struct ieee80211_hw *hw;
 	enum ieee80211_band band;
-	const struct ieee80211_ops *ops;
+	const struct ieee80211_ops *ops = &mac80211_hwsim_ops;
+
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
+
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
+
+	skb_queue_head_init(&data->pending);
+
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
+
+	data->channels = channels;
+
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
+
+	INIT_DELAYED_WORK(&data->roc_done, hw_roc_done);
+	INIT_DELAYED_WORK(&data->hw_scan, hw_scan_work);
+
+	hw->queues = 5;
+	hw->offchannel_tx_hw_queue = 4;
+	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				     BIT(NL80211_IFTYPE_AP) |
+				     BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				     BIT(NL80211_IFTYPE_P2P_GO) |
+				     BIT(NL80211_IFTYPE_ADHOC) |
+				     BIT(NL80211_IFTYPE_MESH_POINT) |
+				     BIT(NL80211_IFTYPE_P2P_DEVICE);
+
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
+
+	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
+			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
+			    WIPHY_FLAG_AP_UAPSD;
+	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
+
+	/* ask mac80211 to reserve space for magic */
+	hw->vif_data_size = sizeof(struct hwsim_vif_priv);
+	hw->sta_data_size = sizeof(struct hwsim_sta_priv);
+	hw->chanctx_data_size = sizeof(struct hwsim_chanctx_priv);
+
+	memcpy(data->channels_2ghz, hwsim_channels_2ghz,
+		sizeof(hwsim_channels_2ghz));
+	memcpy(data->channels_5ghz, hwsim_channels_5ghz,
+		sizeof(hwsim_channels_5ghz));
+	memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));
+
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
+
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
+
+		hw->wiphy->bands[band] = sband;
+
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
+
+	/* By default all radios belong to the first group */
+	data->group = 1;
+	mutex_init(&data->mutex);
+
+	/* Enable frame retransmissions for lossy channels */
+	hw->max_rates = 4;
+	hw->max_rate_tries = 11;
+
+	err = ieee80211_register_hw(hw);
+	if (err < 0) {
+		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_register_hw failed (%d)\n",
+		       err);
+		goto failed_hw;
+	}
+
+	wiphy_debug(hw->wiphy, "hwaddr %pM registered\n", hw->wiphy->perm_addr);
+
+	data->debugfs = debugfs_create_dir("hwsim", hw->wiphy->debugfsdir);
+	debugfs_create_file("ps", 0666, data->debugfs, data, &hwsim_fops_ps);
+	debugfs_create_file("group", 0666, data->debugfs, data,
+			    &hwsim_fops_group);
+	if (data->channels == 1)
+		debugfs_create_file("dfs_simulate_radar", 0222,
+				    data->debugfs,
+				    data, &hwsim_simulate_radar);
+
+	tasklet_hrtimer_init(&data->beacon_timer,
+			     mac80211_hwsim_beacon,
+			     CLOCK_MONOTONIC_RAW, HRTIMER_MODE_ABS);
+
+	spin_lock_bh(&hwsim_radio_lock);
+	list_add_tail(&data->list, &hwsim_radios);
+	spin_unlock_bh(&hwsim_radio_lock);
+
+	return 0;
+
+failed_hw:
+	device_unregister(data->dev);
+failed_drvdata:
+	ieee80211_free_hw(hw);
+failed:
+	return err;
+}
+
+static int __init init_mac80211_hwsim(void)
+{
+	int i, err;
 
 	if (radios < 1 || radios > 100)
 		return -EINVAL;
@@ -2162,256 +2367,46 @@ static int __init init_mac80211_hwsim(void)
 	hwsim_class = class_create(THIS_MODULE, "mac80211_hwsim");
 	if (IS_ERR(hwsim_class)) {
 		err = PTR_ERR(hwsim_class);
-		goto failed_unregister_driver;
+		goto out_unregister_driver;
 	}
 
-	memset(addr, 0, ETH_ALEN);
-	addr[0] = 0x02;
-
 	for (i = 0; i < radios; i++) {
-		printk(KERN_DEBUG "mac80211_hwsim: Initializing radio %d\n",
-		       i);
-		ops = &mac80211_hwsim_ops;
-		if (channels > 1)
-			ops = &mac80211_hwsim_mchan_ops;
-		hw = ieee80211_alloc_hw(sizeof(*data), ops);
-		if (!hw) {
-			printk(KERN_DEBUG "mac80211_hwsim: ieee80211_alloc_hw "
-			       "failed\n");
-			err = -ENOMEM;
-			goto failed;
-		}
-		data = hw->priv;
-		data->hw = hw;
-
-		data->dev = device_create(hwsim_class, NULL, 0, hw,
-					  "hwsim%d", i);
-		if (IS_ERR(data->dev)) {
-			printk(KERN_DEBUG
-			       "mac80211_hwsim: device_create failed (%ld)\n",
-			       PTR_ERR(data->dev));
-			err = -ENOMEM;
-			goto failed_drvdata;
-		}
-		data->dev->driver = &mac80211_hwsim_driver.driver;
-		err = device_bind_driver(data->dev);
-		if (err != 0) {
-			printk(KERN_DEBUG
-			       "mac80211_hwsim: device_bind_driver failed (%d)\n",
-			       err);
-			goto failed_hw;
-		}
-
-		skb_queue_head_init(&data->pending);
-
-		SET_IEEE80211_DEV(hw, data->dev);
-		addr[3] = i >> 8;
-		addr[4] = i;
-		memcpy(data->addresses[0].addr, addr, ETH_ALEN);
-		memcpy(data->addresses[1].addr, addr, ETH_ALEN);
-		data->addresses[1].addr[0] |= 0x40;
-		hw->wiphy->n_addresses = 2;
-		hw->wiphy->addresses = data->addresses;
-
-		data->channels = channels;
-
-		if (data->channels > 1) {
-			hw->wiphy->max_scan_ssids = 255;
-			hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
-			hw->wiphy->max_remain_on_channel_duration = 1000;
-			/* For channels > 1 DFS is not allowed */
-			hw->wiphy->n_iface_combinations = 1;
-			hw->wiphy->iface_combinations = &data->if_combination;
-			data->if_combination = hwsim_if_comb[0];
-			data->if_combination.num_different_channels =
-				data->channels;
-		} else {
-			hw->wiphy->iface_combinations = hwsim_if_comb;
-			hw->wiphy->n_iface_combinations =
-				ARRAY_SIZE(hwsim_if_comb);
-		}
-
-		INIT_DELAYED_WORK(&data->roc_done, hw_roc_done);
-		INIT_DELAYED_WORK(&data->hw_scan, hw_scan_work);
-
-		hw->queues = 5;
-		hw->offchannel_tx_hw_queue = 4;
-		hw->wiphy->interface_modes =
-			BIT(NL80211_IFTYPE_STATION) |
-			BIT(NL80211_IFTYPE_AP) |
-			BIT(NL80211_IFTYPE_P2P_CLIENT) |
-			BIT(NL80211_IFTYPE_P2P_GO) |
-			BIT(NL80211_IFTYPE_ADHOC) |
-			BIT(NL80211_IFTYPE_MESH_POINT) |
-			BIT(NL80211_IFTYPE_P2P_DEVICE);
-
-		hw->flags = IEEE80211_HW_MFP_CAPABLE |
-			    IEEE80211_HW_SIGNAL_DBM |
-			    IEEE80211_HW_SUPPORTS_STATIC_SMPS |
-			    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
-			    IEEE80211_HW_AMPDU_AGGREGATION |
-			    IEEE80211_HW_WANT_MONITOR_VIF |
-			    IEEE80211_HW_QUEUE_CONTROL |
-			    IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
-		if (rctbl)
-			hw->flags |= IEEE80211_HW_SUPPORTS_RC_TABLE;
-
-		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
-				    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-				    WIPHY_FLAG_AP_UAPSD;
-		hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
-
-		/* ask mac80211 to reserve space for magic */
-		hw->vif_data_size = sizeof(struct hwsim_vif_priv);
-		hw->sta_data_size = sizeof(struct hwsim_sta_priv);
-		hw->chanctx_data_size = sizeof(struct hwsim_chanctx_priv);
-
-		memcpy(data->channels_2ghz, hwsim_channels_2ghz,
-			sizeof(hwsim_channels_2ghz));
-		memcpy(data->channels_5ghz, hwsim_channels_5ghz,
-			sizeof(hwsim_channels_5ghz));
-		memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));
-
-		for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
-			struct ieee80211_supported_band *sband = &data->bands[band];
-			switch (band) {
-			case IEEE80211_BAND_2GHZ:
-				sband->channels = data->channels_2ghz;
-				sband->n_channels =
-					ARRAY_SIZE(hwsim_channels_2ghz);
-				sband->bitrates = data->rates;
-				sband->n_bitrates = ARRAY_SIZE(hwsim_rates);
-				break;
-			case IEEE80211_BAND_5GHZ:
-				sband->channels = data->channels_5ghz;
-				sband->n_channels =
-					ARRAY_SIZE(hwsim_channels_5ghz);
-				sband->bitrates = data->rates + 4;
-				sband->n_bitrates = ARRAY_SIZE(hwsim_rates) - 4;
-				break;
-			default:
-				continue;
-			}
-
-			sband->ht_cap.ht_supported = true;
-			sband->ht_cap.cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
-				IEEE80211_HT_CAP_GRN_FLD |
-				IEEE80211_HT_CAP_SGI_40 |
-				IEEE80211_HT_CAP_DSSSCCK40;
-			sband->ht_cap.ampdu_factor = 0x3;
-			sband->ht_cap.ampdu_density = 0x6;
-			memset(&sband->ht_cap.mcs, 0,
-			       sizeof(sband->ht_cap.mcs));
-			sband->ht_cap.mcs.rx_mask[0] = 0xff;
-			sband->ht_cap.mcs.rx_mask[1] = 0xff;
-			sband->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
-
-			hw->wiphy->bands[band] = sband;
-
-			sband->vht_cap.vht_supported = true;
-			sband->vht_cap.cap =
-				IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
-				IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ |
-				IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ |
-				IEEE80211_VHT_CAP_RXLDPC |
-				IEEE80211_VHT_CAP_SHORT_GI_80 |
-				IEEE80211_VHT_CAP_SHORT_GI_160 |
-				IEEE80211_VHT_CAP_TXSTBC |
-				IEEE80211_VHT_CAP_RXSTBC_1 |
-				IEEE80211_VHT_CAP_RXSTBC_2 |
-				IEEE80211_VHT_CAP_RXSTBC_3 |
-				IEEE80211_VHT_CAP_RXSTBC_4 |
-				IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK;
-			sband->vht_cap.vht_mcs.rx_mcs_map =
-				cpu_to_le16(IEEE80211_VHT_MCS_SUPPORT_0_8 << 0 |
-					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 2 |
-					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 4 |
-					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 6 |
-					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 8 |
-					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 10 |
-					    IEEE80211_VHT_MCS_SUPPORT_0_9 << 12 |
-					    IEEE80211_VHT_MCS_SUPPORT_0_8 << 14);
-			sband->vht_cap.vht_mcs.tx_mcs_map =
-				sband->vht_cap.vht_mcs.rx_mcs_map;
-		}
-		/* By default all radios are belonging to the first group */
-		data->group = 1;
-		mutex_init(&data->mutex);
-
-		/* Enable frame retransmissions for lossy channels */
-		hw->max_rates = 4;
-		hw->max_rate_tries = 11;
-
-		err = ieee80211_register_hw(hw);
-		if (err < 0) {
-			printk(KERN_DEBUG "mac80211_hwsim: "
-			       "ieee80211_register_hw failed (%d)\n", err);
-			goto failed_hw;
-		}
-
-		wiphy_debug(hw->wiphy, "hwaddr %pm registered\n",
-			    hw->wiphy->perm_addr);
-
-		data->debugfs = debugfs_create_dir("hwsim",
-						   hw->wiphy->debugfsdir);
-		debugfs_create_file("ps", 0666, data->debugfs, data,
-				    &hwsim_fops_ps);
-		debugfs_create_file("group", 0666, data->debugfs, data,
-				    &hwsim_fops_group);
-		if (channels == 1)
-			debugfs_create_file("dfs_simulate_radar", 0222,
-					    data->debugfs,
-					    data, &hwsim_simulate_radar);
-
-		tasklet_hrtimer_init(&data->beacon_timer,
-				     mac80211_hwsim_beacon,
-				     CLOCK_MONOTONIC_RAW, HRTIMER_MODE_ABS);
-
-		list_add_tail(&data->list, &hwsim_radios);
+		err = mac80211_hwsim_create_radio(i);
+		if (err)
+			goto out_free_radios;
 	}
 
 	hwsim_mon = alloc_netdev(0, "hwsim%d", hwsim_mon_setup);
 	if (hwsim_mon == NULL) {
 		err = -ENOMEM;
-		goto failed;
+		goto out_free_radios;
 	}
 
 	rtnl_lock();
-
 	err = dev_alloc_name(hwsim_mon, hwsim_mon->name);
-	if (err < 0)
-		goto failed_mon;
-
+	if (err < 0) {
+		rtnl_unlock();
+		goto out_free_radios;
+	}
 
 	err = register_netdevice(hwsim_mon);
-	if (err < 0)
-		goto failed_mon;
-
+	if (err < 0) {
+		rtnl_unlock();
+		goto out_free_mon;
+	}
 	rtnl_unlock();
 
 	err = hwsim_init_netlink();
 	if (err < 0)
-		goto failed_nl;
+		goto out_free_mon;
 
 	return 0;
 
-failed_nl:
-	printk(KERN_DEBUG "mac80211_hwsim: failed initializing netlink\n");
-	return err;
-
-failed_mon:
-	rtnl_unlock();
+out_free_mon:
 	free_netdev(hwsim_mon);
+out_free_radios:
 	mac80211_hwsim_free();
-	return err;
-
-failed_hw:
-	device_unregister(data->dev);
-failed_drvdata:
-	ieee80211_free_hw(hw);
-failed:
-	mac80211_hwsim_free();
-failed_unregister_driver:
+out_unregister_driver:
 	platform_driver_unregister(&mac80211_hwsim_driver);
 	return err;
 }
-- 
1.8.5.1

