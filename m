Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2004 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab0CLEpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 23:45:46 -0500
From: Bob Copeland <me@bobcopeland.com>
To: jouni.malinen@atheros.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH/RFC 1/3] mac80211_hwsim: extract radio creation code
Date: Thu, 11 Mar 2010 23:43:17 -0500
Message-Id: <1268368999-12734-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1268368999-12734-1-git-send-email-me@bobcopeland.com>
References: <1268368999-12734-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move device creation into its own function so it can eventually
be called on-demand when manipulating a control device.  No actual
functionality changes yet.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/mac80211_hwsim.c |  490 +++++++++++++++++----------------
 1 files changed, 255 insertions(+), 235 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 6ea77e9..107f748 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -275,6 +275,7 @@ static const struct ieee80211_rate hwsim_rates[] = {
 
 static spinlock_t hwsim_radio_lock;
 static struct list_head hwsim_radios;
+static int radio_count = 0;
 
 struct mac80211_hwsim_data {
 	struct list_head list;
@@ -1167,255 +1168,281 @@ DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_group,
 			hwsim_fops_group_read, hwsim_fops_group_write,
 			"%llx\n");
 
-static int __init init_mac80211_hwsim(void)
+static struct mac80211_hwsim_data *mac80211_hwsim_create_radio(void)
 {
-	int i, err = 0;
-	u8 addr[ETH_ALEN];
+	u8 addr[ETH_ALEN] = {};
 	struct mac80211_hwsim_data *data;
 	struct ieee80211_hw *hw;
 	enum ieee80211_band band;
+	int err;
+	int radio;
+	unsigned long flags;
 
-	if (radios < 1 || radios > 100)
-		return -EINVAL;
-
-	if (fake_hw_scan)
-		mac80211_hwsim_ops.hw_scan = mac80211_hwsim_hw_scan;
-
-	spin_lock_init(&hwsim_radio_lock);
-	INIT_LIST_HEAD(&hwsim_radios);
-
-	hwsim_class = class_create(THIS_MODULE, "mac80211_hwsim");
-	if (IS_ERR(hwsim_class))
-		return PTR_ERR(hwsim_class);
-
-	memset(addr, 0, ETH_ALEN);
 	addr[0] = 0x02;
 
-	for (i = 0; i < radios; i++) {
-		printk(KERN_DEBUG "mac80211_hwsim: Initializing radio %d\n",
-		       i);
-		hw = ieee80211_alloc_hw(sizeof(*data), &mac80211_hwsim_ops);
-		if (!hw) {
-			printk(KERN_DEBUG "mac80211_hwsim: ieee80211_alloc_hw "
-			       "failed\n");
-			err = -ENOMEM;
-			goto failed;
+	radio = radio_count++;
+
+	printk(KERN_DEBUG "mac80211_hwsim: Initializing radio %d\n", radio);
+	hw = ieee80211_alloc_hw(sizeof(*data), &mac80211_hwsim_ops);
+	if (!hw) {
+		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_alloc_hw "
+		       "failed\n");
+		err = -ENOMEM;
+		goto failed;
+	}
+	data = hw->priv;
+	data->hw = hw;
+
+	data->dev = device_create(hwsim_class, NULL, 0, hw,
+				  "hwsim%d", radio);
+	if (IS_ERR(data->dev)) {
+		printk(KERN_DEBUG
+		       "mac80211_hwsim: device_create "
+		       "failed (%ld)\n", PTR_ERR(data->dev));
+		err = -ENOMEM;
+		goto failed_drvdata;
+	}
+	data->dev->driver = &mac80211_hwsim_driver;
+
+	SET_IEEE80211_DEV(hw, data->dev);
+	addr[3] = radio >> 8;
+	addr[4] = radio;
+	memcpy(data->addresses[0].addr, addr, ETH_ALEN);
+	memcpy(data->addresses[1].addr, addr, ETH_ALEN);
+	data->addresses[1].addr[0] |= 0x40;
+	hw->wiphy->n_addresses = 2;
+	hw->wiphy->addresses = data->addresses;
+
+	hw->channel_change_time = 1;
+	hw->queues = 4;
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_AP) |
+		BIT(NL80211_IFTYPE_MESH_POINT);
+
+	hw->flags = IEEE80211_HW_MFP_CAPABLE |
+		    IEEE80211_HW_SIGNAL_DBM |
+		    IEEE80211_HW_SUPPORTS_STATIC_SMPS |
+		    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS;
+
+	/* ask mac80211 to reserve space for magic */
+	hw->vif_data_size = sizeof(struct hwsim_vif_priv);
+	hw->sta_data_size = sizeof(struct hwsim_sta_priv);
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
+			sband->n_channels =
+				ARRAY_SIZE(hwsim_channels_2ghz);
+			sband->bitrates = data->rates;
+			sband->n_bitrates = ARRAY_SIZE(hwsim_rates);
+			break;
+		case IEEE80211_BAND_5GHZ:
+			sband->channels = data->channels_5ghz;
+			sband->n_channels =
+				ARRAY_SIZE(hwsim_channels_5ghz);
+			sband->bitrates = data->rates + 4;
+			sband->n_bitrates = ARRAY_SIZE(hwsim_rates) - 4;
+			break;
+		default:
+			break;
 		}
-		data = hw->priv;
-		data->hw = hw;
-
-		data->dev = device_create(hwsim_class, NULL, 0, hw,
-					  "hwsim%d", i);
-		if (IS_ERR(data->dev)) {
-			printk(KERN_DEBUG
-			       "mac80211_hwsim: device_create "
-			       "failed (%ld)\n", PTR_ERR(data->dev));
-			err = -ENOMEM;
-			goto failed_drvdata;
+
+		sband->ht_cap.ht_supported = true;
+		sband->ht_cap.cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+			IEEE80211_HT_CAP_GRN_FLD |
+			IEEE80211_HT_CAP_SGI_40 |
+			IEEE80211_HT_CAP_DSSSCCK40;
+		sband->ht_cap.ampdu_factor = 0x3;
+		sband->ht_cap.ampdu_density = 0x6;
+		memset(&sband->ht_cap.mcs, 0,
+		       sizeof(sband->ht_cap.mcs));
+		sband->ht_cap.mcs.rx_mask[0] = 0xff;
+		sband->ht_cap.mcs.rx_mask[1] = 0xff;
+		sband->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+
+		hw->wiphy->bands[band] = sband;
+	}
+	/* By default all radios are belonging to the first group */
+	data->group = 1;
+
+	/* Work to be done prior to ieee80211_register_hw() */
+	switch (regtest) {
+	case HWSIM_REGTEST_DISABLED:
+	case HWSIM_REGTEST_DRIVER_REG_FOLLOW:
+	case HWSIM_REGTEST_DRIVER_REG_ALL:
+	case HWSIM_REGTEST_DIFF_COUNTRY:
+		/*
+		 * Nothing to be done for driver regulatory domain
+		 * hints prior to ieee80211_register_hw()
+		 */
+		break;
+	case HWSIM_REGTEST_WORLD_ROAM:
+		if (radio == 0) {
+			hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+			wiphy_apply_custom_regulatory(hw->wiphy,
+				&hwsim_world_regdom_custom_01);
 		}
-		data->dev->driver = &mac80211_hwsim_driver;
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
-		hw->channel_change_time = 1;
-		hw->queues = 4;
-		hw->wiphy->interface_modes =
-			BIT(NL80211_IFTYPE_STATION) |
-			BIT(NL80211_IFTYPE_AP) |
-			BIT(NL80211_IFTYPE_MESH_POINT);
-
-		hw->flags = IEEE80211_HW_MFP_CAPABLE |
-			    IEEE80211_HW_SIGNAL_DBM |
-			    IEEE80211_HW_SUPPORTS_STATIC_SMPS |
-			    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS;
-
-		/* ask mac80211 to reserve space for magic */
-		hw->vif_data_size = sizeof(struct hwsim_vif_priv);
-		hw->sta_data_size = sizeof(struct hwsim_sta_priv);
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
-				break;
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
+		break;
+	case HWSIM_REGTEST_CUSTOM_WORLD:
+		hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+		wiphy_apply_custom_regulatory(hw->wiphy,
+			&hwsim_world_regdom_custom_01);
+		break;
+	case HWSIM_REGTEST_CUSTOM_WORLD_2:
+		if (radio == 0) {
+			hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+			wiphy_apply_custom_regulatory(hw->wiphy,
+				&hwsim_world_regdom_custom_01);
+		} else if (radio == 1) {
+			hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+			wiphy_apply_custom_regulatory(hw->wiphy,
+				&hwsim_world_regdom_custom_02);
 		}
-		/* By default all radios are belonging to the first group */
-		data->group = 1;
-
-		/* Work to be done prior to ieee80211_register_hw() */
-		switch (regtest) {
-		case HWSIM_REGTEST_DISABLED:
-		case HWSIM_REGTEST_DRIVER_REG_FOLLOW:
-		case HWSIM_REGTEST_DRIVER_REG_ALL:
-		case HWSIM_REGTEST_DIFF_COUNTRY:
-			/*
-			 * Nothing to be done for driver regulatory domain
-			 * hints prior to ieee80211_register_hw()
-			 */
-			break;
-		case HWSIM_REGTEST_WORLD_ROAM:
-			if (i == 0) {
-				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
-				wiphy_apply_custom_regulatory(hw->wiphy,
-					&hwsim_world_regdom_custom_01);
-			}
-			break;
-		case HWSIM_REGTEST_CUSTOM_WORLD:
+		break;
+	case HWSIM_REGTEST_STRICT_ALL:
+		hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
+		break;
+	case HWSIM_REGTEST_STRICT_FOLLOW:
+	case HWSIM_REGTEST_STRICT_AND_DRIVER_REG:
+		if (radio == 0)
+			hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
+		break;
+	case HWSIM_REGTEST_ALL:
+		if (radio == 0) {
 			hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
 			wiphy_apply_custom_regulatory(hw->wiphy,
 				&hwsim_world_regdom_custom_01);
-			break;
-		case HWSIM_REGTEST_CUSTOM_WORLD_2:
-			if (i == 0) {
-				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
-				wiphy_apply_custom_regulatory(hw->wiphy,
-					&hwsim_world_regdom_custom_01);
-			} else if (i == 1) {
-				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
-				wiphy_apply_custom_regulatory(hw->wiphy,
-					&hwsim_world_regdom_custom_02);
-			}
-			break;
-		case HWSIM_REGTEST_STRICT_ALL:
+		} else if (radio == 1) {
+			hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
+			wiphy_apply_custom_regulatory(hw->wiphy,
+				&hwsim_world_regdom_custom_02);
+		} else if (radio == 4)
 			hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
-			break;
-		case HWSIM_REGTEST_STRICT_FOLLOW:
-		case HWSIM_REGTEST_STRICT_AND_DRIVER_REG:
-			if (i == 0)
-				hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
-			break;
-		case HWSIM_REGTEST_ALL:
-			if (i == 0) {
-				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
-				wiphy_apply_custom_regulatory(hw->wiphy,
-					&hwsim_world_regdom_custom_01);
-			} else if (i == 1) {
-				hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
-				wiphy_apply_custom_regulatory(hw->wiphy,
-					&hwsim_world_regdom_custom_02);
-			} else if (i == 4)
-				hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY;
-			break;
-		default:
-			break;
-		}
+		break;
+	default:
+		break;
+	}
 
-		/* give the regulatory workqueue a chance to run */
-		if (regtest)
-			schedule_timeout_interruptible(1);
-		err = ieee80211_register_hw(hw);
-		if (err < 0) {
-			printk(KERN_DEBUG "mac80211_hwsim: "
-			       "ieee80211_register_hw failed (%d)\n", err);
-			goto failed_hw;
-		}
+	/* give the regulatory workqueue a chance to run */
+	if (regtest)
+		schedule_timeout_interruptible(1);
+	err = ieee80211_register_hw(hw);
+	if (err < 0) {
+		printk(KERN_DEBUG "mac80211_hwsim: "
+		       "ieee80211_register_hw failed (%d)\n", err);
+		goto failed_hw;
+	}
 
-		/* Work to be done after to ieee80211_register_hw() */
-		switch (regtest) {
-		case HWSIM_REGTEST_WORLD_ROAM:
-		case HWSIM_REGTEST_DISABLED:
-			break;
-		case HWSIM_REGTEST_DRIVER_REG_FOLLOW:
-			if (!i)
-				regulatory_hint(hw->wiphy, hwsim_alpha2s[0]);
-			break;
-		case HWSIM_REGTEST_DRIVER_REG_ALL:
-		case HWSIM_REGTEST_STRICT_ALL:
+	/* Work to be done after to ieee80211_register_hw() */
+	switch (regtest) {
+	case HWSIM_REGTEST_WORLD_ROAM:
+	case HWSIM_REGTEST_DISABLED:
+		break;
+	case HWSIM_REGTEST_DRIVER_REG_FOLLOW:
+		if (!radio)
 			regulatory_hint(hw->wiphy, hwsim_alpha2s[0]);
-			break;
-		case HWSIM_REGTEST_DIFF_COUNTRY:
-			if (i < ARRAY_SIZE(hwsim_alpha2s))
-				regulatory_hint(hw->wiphy, hwsim_alpha2s[i]);
-			break;
-		case HWSIM_REGTEST_CUSTOM_WORLD:
-		case HWSIM_REGTEST_CUSTOM_WORLD_2:
-			/*
-			 * Nothing to be done for custom world regulatory
-			 * domains after to ieee80211_register_hw
-			 */
-			break;
-		case HWSIM_REGTEST_STRICT_FOLLOW:
-			if (i == 0)
-				regulatory_hint(hw->wiphy, hwsim_alpha2s[0]);
-			break;
-		case HWSIM_REGTEST_STRICT_AND_DRIVER_REG:
-			if (i == 0)
-				regulatory_hint(hw->wiphy, hwsim_alpha2s[0]);
-			else if (i == 1)
-				regulatory_hint(hw->wiphy, hwsim_alpha2s[1]);
-			break;
-		case HWSIM_REGTEST_ALL:
-			if (i == 2)
-				regulatory_hint(hw->wiphy, hwsim_alpha2s[0]);
-			else if (i == 3)
-				regulatory_hint(hw->wiphy, hwsim_alpha2s[1]);
-			else if (i == 4)
-				regulatory_hint(hw->wiphy, hwsim_alpha2s[2]);
-			break;
-		default:
-			break;
-		}
+		break;
+	case HWSIM_REGTEST_DRIVER_REG_ALL:
+	case HWSIM_REGTEST_STRICT_ALL:
+		regulatory_hint(hw->wiphy, hwsim_alpha2s[0]);
+		break;
+	case HWSIM_REGTEST_DIFF_COUNTRY:
+		if (radio < ARRAY_SIZE(hwsim_alpha2s))
+			regulatory_hint(hw->wiphy, hwsim_alpha2s[
+				radio % ARRAY_SIZE(hwsim_alpha2s)]);
+		break;
+	case HWSIM_REGTEST_CUSTOM_WORLD:
+	case HWSIM_REGTEST_CUSTOM_WORLD_2:
+		/*
+		 * Nothing to be done for custom world regulatory
+		 * domains after to ieee80211_register_hw
+		 */
+		break;
+	case HWSIM_REGTEST_STRICT_FOLLOW:
+		if (radio == 0)
+			regulatory_hint(hw->wiphy, hwsim_alpha2s[0]);
+		break;
+	case HWSIM_REGTEST_STRICT_AND_DRIVER_REG:
+		if (radio == 0)
+			regulatory_hint(hw->wiphy, hwsim_alpha2s[0]);
+		else if (radio == 1)
+			regulatory_hint(hw->wiphy, hwsim_alpha2s[1]);
+		break;
+	case HWSIM_REGTEST_ALL:
+		if (radio == 2)
+			regulatory_hint(hw->wiphy, hwsim_alpha2s[0]);
+		else if (radio == 3)
+			regulatory_hint(hw->wiphy, hwsim_alpha2s[1]);
+		else if (radio == 4)
+			regulatory_hint(hw->wiphy, hwsim_alpha2s[2]);
+		break;
+	default:
+		break;
+	}
 
-		printk(KERN_DEBUG "%s: hwaddr %pM registered\n",
-		       wiphy_name(hw->wiphy),
-		       hw->wiphy->perm_addr);
+	printk(KERN_DEBUG "%s: hwaddr %pM registered\n",
+	       wiphy_name(hw->wiphy),
+	       hw->wiphy->perm_addr);
+
+	data->debugfs = debugfs_create_dir("hwsim",
+					   hw->wiphy->debugfsdir);
+	data->debugfs_ps = debugfs_create_file("ps", 0666,
+					       data->debugfs, data,
+					       &hwsim_fops_ps);
+	data->debugfs_group = debugfs_create_file("group", 0666,
+						data->debugfs, data,
+						&hwsim_fops_group);
 
-		data->debugfs = debugfs_create_dir("hwsim",
-						   hw->wiphy->debugfsdir);
-		data->debugfs_ps = debugfs_create_file("ps", 0666,
-						       data->debugfs, data,
-						       &hwsim_fops_ps);
-		data->debugfs_group = debugfs_create_file("group", 0666,
-							data->debugfs, data,
-							&hwsim_fops_group);
+	setup_timer(&data->beacon_timer, mac80211_hwsim_beacon,
+		    (unsigned long) hw);
 
-		setup_timer(&data->beacon_timer, mac80211_hwsim_beacon,
-			    (unsigned long) hw);
+	spin_lock_irqsave(&hwsim_radio_lock, flags);
+	list_add_tail(&data->list, &hwsim_radios);
+	spin_unlock_irqrestore(&hwsim_radio_lock, flags);
+	return data;
 
-		list_add_tail(&data->list, &hwsim_radios);
+failed_hw:
+	device_unregister(data->dev);
+failed_drvdata:
+	ieee80211_free_hw(hw);
+failed:
+	return ERR_PTR(err);
+}
+
+static int __init init_mac80211_hwsim(void)
+{
+	int i, err = 0;
+
+	if (radios < 1 || radios > 100)
+		return -EINVAL;
+
+	if (fake_hw_scan)
+		mac80211_hwsim_ops.hw_scan = mac80211_hwsim_hw_scan;
+
+	spin_lock_init(&hwsim_radio_lock);
+	INIT_LIST_HEAD(&hwsim_radios);
+
+	hwsim_class = class_create(THIS_MODULE, "mac80211_hwsim");
+	if (IS_ERR(hwsim_class))
+		return PTR_ERR(hwsim_class);
+
+	for (i = 0; i < radios; i++) {
+		struct mac80211_hwsim_data *data =
+			mac80211_hwsim_create_radio();
+
+		if (IS_ERR(data)) {
+			err = PTR_ERR(data);
+			goto failed;
+		}
 	}
 
 	hwsim_mon = alloc_netdev(0, "hwsim%d", hwsim_mon_setup);
@@ -1440,13 +1467,6 @@ static int __init init_mac80211_hwsim(void)
 failed_mon:
 	rtnl_unlock();
 	free_netdev(hwsim_mon);
-	mac80211_hwsim_free();
-	return err;
-
-failed_hw:
-	device_unregister(data->dev);
-failed_drvdata:
-	ieee80211_free_hw(hw);
 failed:
 	mac80211_hwsim_free();
 	return err;
-- 
1.6.3.3


