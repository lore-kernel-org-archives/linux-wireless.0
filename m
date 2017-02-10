Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34875 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdBJDuh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Feb 2017 22:50:37 -0500
Received: by mail-wr0-f196.google.com with SMTP id o16so13870802wra.2
        for <linux-wireless@vger.kernel.org>; Thu, 09 Feb 2017 19:50:36 -0800 (PST)
Received: from localhost.localdomain ([92.176.165.227])
        by smtp.gmail.com with ESMTPSA id o143sm1072087wmd.3.2017.02.09.19.50.34
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Feb 2017 19:50:34 -0800 (PST)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v5 3/3] wireless: Set NL80211_EXT_FEATURE_CQM_RSSI_LIST in multiple drivers
Date: Fri, 10 Feb 2017 04:50:23 +0100
Message-Id: <20170210035023.11471-3-andrew.zaborowski@intel.com> (sfid-20170210_045049_440020_1A693483)
In-Reply-To: <20170210035023.11471-1-andrew.zaborowski@intel.com>
References: <20170210035023.11471-1-andrew.zaborowski@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the NL80211_EXT_FEATURE_CQM_RSSI_LIST wiphy extended feature
wholesale in all mac80211-based drivers that do not set the
IEEE80211_VIF_BEACON_FILTER flags on their interfaces.  mac80211 will
be processing supplied RSSI values in ieee80211_rx_mgmt_beacon and
will detect when the thresholds set by
ieee80211_set_cqm_rssi_range_config are crossed.  Remaining (few)
drivers need code to enable the firmware to monitor the thresholds.
This is mostly only compile-tested.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 drivers/net/wireless/admtek/adm8211.c                          | 2 ++
 drivers/net/wireless/ath/ar5523/ar5523.c                       | 2 ++
 drivers/net/wireless/ath/ath10k/mac.c                          | 2 ++
 drivers/net/wireless/ath/ath5k/base.c                          | 2 ++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                  | 2 ++
 drivers/net/wireless/ath/ath9k/init.c                          | 2 ++
 drivers/net/wireless/ath/carl9170/main.c                       | 2 ++
 drivers/net/wireless/ath/wcn36xx/main.c                        | 3 +++
 drivers/net/wireless/atmel/at76c50x-usb.c                      | 2 ++
 drivers/net/wireless/broadcom/b43/main.c                       | 2 ++
 drivers/net/wireless/broadcom/b43legacy/main.c                 | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c | 2 ++
 drivers/net/wireless/intel/iwlegacy/3945-mac.c                 | 2 ++
 drivers/net/wireless/intel/iwlegacy/4965-mac.c                 | 2 ++
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c              | 2 ++
 drivers/net/wireless/mac80211_hwsim.c                          | 2 ++
 drivers/net/wireless/marvell/libertas_tf/main.c                | 2 ++
 drivers/net/wireless/marvell/mwl8k.c                           | 2 ++
 drivers/net/wireless/mediatek/mt7601u/init.c                   | 2 ++
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c                 | 3 +++
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c             | 2 ++
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c             | 2 ++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c          | 2 ++
 drivers/net/wireless/rsi/rsi_91x_mac80211.c                    | 2 ++
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c                   | 2 ++
 drivers/staging/vt6655/device_main.c                           | 2 ++
 drivers/staging/vt6656/main_usb.c                              | 2 ++
 27 files changed, 56 insertions(+)

diff --git a/drivers/net/wireless/admtek/adm8211.c b/drivers/net/wireless/admtek/adm8211.c
index 098c814..ed626f5 100644
--- a/drivers/net/wireless/admtek/adm8211.c
+++ b/drivers/net/wireless/admtek/adm8211.c
@@ -1917,6 +1917,8 @@ static int adm8211_probe(struct pci_dev *pdev,
 
 	dev->wiphy->bands[NL80211_BAND_2GHZ] = &priv->band;
 
+	wiphy_ext_feature_set(dev->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	err = ieee80211_register_hw(dev);
 	if (err) {
 		printk(KERN_ERR "%s (adm8211): Cannot register device\n",
diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 7a60d2e..f2f4ccf 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1689,6 +1689,8 @@ static int ar5523_probe(struct usb_interface *intf,
 	if (error)
 		goto out_cancel_rx_cmd;
 
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	usb_set_intfdata(intf, hw);
 
 	error = ieee80211_register_hw(hw);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d1b7edb..dab6270 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8189,6 +8189,8 @@ int ath10k_mac_register(struct ath10k *ar)
 	ar->hw->wiphy->cipher_suites = cipher_suites;
 	ar->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 
+	wiphy_ext_feature_set(ar->hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	ret = ieee80211_register_hw(ar->hw);
 	if (ret) {
 		ath10k_err(ar, "failed to register ieee80211: %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index d98fd42..92ece64 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2564,6 +2564,8 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 
 	hw->extra_tx_headroom = 2;
 
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	/*
 	 * Mark the device as detached to avoid processing
 	 * interrupts until setup is complete.
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index b65c1b6..defacc6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -780,6 +780,8 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 	}
 
 	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
+
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 }
 
 static int ath9k_init_firmware_version(struct ath9k_htc_priv *priv)
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 084ad1b..145770d 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -953,6 +953,8 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_cmn_reload_chainmask(ah);
 
 	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
+
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 }
 
 int ath9k_init_device(u16 devid, struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index ffb22a0..988c885 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1874,6 +1874,8 @@ void *carl9170_alloc(size_t priv_size)
 	for (i = 0; i < ARRAY_SIZE(ar->noise); i++)
 		ar->noise[i] = -95; /* ATH_DEFAULT_NOISE_FLOOR */
 
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	return ar;
 
 err_nomem:
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index e1d59da..1b6c173 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1046,6 +1046,9 @@ static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
 	wcn->hw->sta_data_size = sizeof(struct wcn36xx_sta);
 	wcn->hw->vif_data_size = sizeof(struct wcn36xx_vif);
 
+	wiphy_ext_feature_set(wcn->hw->wiphy,
+			      NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index 0e18067..09defbc 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -2377,6 +2377,8 @@ static int at76_init_new_device(struct at76_priv *priv,
 
 	wiphy->hw_version = priv->board_type;
 
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	ret = ieee80211_register_hw(priv->hw);
 	if (ret) {
 		printk(KERN_ERR "cannot register mac80211 hw (status %d)!\n",
diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 52f3541..d23aac7 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -5598,6 +5598,8 @@ static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	wl->hw_registred = false;
 	hw->max_rates = 2;
 	SET_IEEE80211_DEV(hw, dev->dev);
diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index e97ab2b..44781b8 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -3850,6 +3850,8 @@ static int b43legacy_wireless_init(struct ssb_device *dev)
 	else
 		SET_IEEE80211_PERM_ADDR(hw, sprom->il0mac);
 
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	/* Get and initialize struct b43legacy_wl */
 	wl = hw_to_b43legacy_wl(hw);
 	memset(wl, 0, sizeof(*wl));
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index 7c2a9a9..ddfdfe1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -1082,6 +1082,8 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 	 * hw->wiphy->flags |= WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
 	 */
 
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	hw->rate_control_algorithm = "minstrel_ht";
 
 	hw->sta_data_size = 0;
diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index e8e6511..38bf403 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3592,6 +3592,8 @@ il3945_setup_mac(struct il_priv *il)
 
 	il_leds_init(il);
 
+	wiphy_ext_feature_set(il->hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	ret = ieee80211_register_hw(il->hw);
 	if (ret) {
 		IL_ERR("Failed to register hw (error %d)\n", ret);
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index a91d170..54ecda5 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -5799,6 +5799,8 @@ il4965_mac_setup_register(struct il_priv *il, u32 max_probe_length)
 
 	il_leds_init(il);
 
+	wiphy_ext_feature_set(il->hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	ret = ieee80211_register_hw(il->hw);
 	if (ret) {
 		IL_ERR("Failed to register hw (error %d)\n", ret);
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 8c07194..2b23c3f 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -213,6 +213,8 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 
 	iwl_leds_init(priv);
 
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	ret = ieee80211_register_hw(priv->hw);
 	if (ret) {
 		IWL_ERR(priv, "Failed to register hw (error %d)\n", ret);
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 1620a5d..0150747 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2645,6 +2645,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	if (param->no_vif)
 		ieee80211_hw_set(hw, NO_AUTO_VIF);
 
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	err = ieee80211_register_hw(hw);
 	if (err < 0) {
 		printk(KERN_DEBUG "mac80211_hwsim: ieee80211_register_hw failed (%d)\n",
diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/net/wireless/marvell/libertas_tf/main.c
index 54e426c..d803331 100644
--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -641,6 +641,8 @@ struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev)
 		BIT(NL80211_IFTYPE_ADHOC);
 	skb_queue_head_init(&priv->bc_ps_buf);
 
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	SET_IEEE80211_DEV(hw, dmdev);
 
 	INIT_WORK(&priv->cmd_work, lbtf_cmd_work);
diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index b1b400b..c295a4c 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -6144,6 +6144,8 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 	if (priv->sta_macids_supported || priv->device_info->fw_image_sta)
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_STATION);
 
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	rc = ieee80211_register_hw(hw);
 	if (rc) {
 		wiphy_err(hw->wiphy, "Cannot register device\n");
diff --git a/drivers/net/wireless/mediatek/mt7601u/init.c b/drivers/net/wireless/mediatek/mt7601u/init.c
index a6e9017..d3b611a 100644
--- a/drivers/net/wireless/mediatek/mt7601u/init.c
+++ b/drivers/net/wireless/mediatek/mt7601u/init.c
@@ -615,6 +615,8 @@ int mt7601u_register_device(struct mt7601u_dev *dev)
 	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	ret = mt76_init_sband_2g(dev);
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 8fcbc8d..29c97a8 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -1384,6 +1384,9 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00dev->hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
+	wiphy_ext_feature_set(rt2x00dev->hw->wiphy,
+			      NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	/*
 	 * Initialize ieee80211 structure.
 	 */
diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index e895a84..e387dec 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -1877,6 +1877,8 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	else
 		ieee80211_hw_set(dev, SIGNAL_UNSPEC);
 
+	wiphy_ext_feature_set(dev->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	rtl8180_eeprom_read(priv);
 
 	switch (priv->rf_type) {
diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
index 231f84d..274ad6d 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -1609,6 +1609,8 @@ static int rtl8187_probe(struct usb_interface *intf,
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				      BIT(NL80211_IFTYPE_ADHOC) ;
 
+	wiphy_ext_feature_set(dev->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	if ((id->driver_info == DEVICE_RTL8187) && priv->is_rtl8187b)
 		printk(KERN_INFO "rtl8187: inconsistency between id with OEM"
 		       " info!\n");
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 3a86675..75fbb39 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6134,6 +6134,8 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	ieee80211_hw_set(hw, HAS_RATE_CONTROL);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	ret = ieee80211_register_hw(priv->hw);
 	if (ret) {
 		dev_err(&udev->dev, "%s: Failed to register: %i\n",
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index e321647..021e5ac 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1261,6 +1261,8 @@ int rsi_mac80211_attach(struct rsi_common *common)
 
 	wiphy->reg_notifier = rsi_reg_notify;
 
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	status = ieee80211_register_hw(hw);
 	if (status)
 		return status;
diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
index 3e37a04..fe6517a 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
@@ -1408,6 +1408,8 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_AP);
 
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	hw->max_signal = 100;
 	hw->queues = 1;
 	hw->extra_tx_headroom = sizeof(struct zd_ctrlset);
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index da0f711..7f18f70 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1661,6 +1661,8 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
 
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	ieee80211_hw_set(priv->hw, TIMING_BEACON_ONLY);
 	ieee80211_hw_set(priv->hw, SIGNAL_DBM);
 	ieee80211_hw_set(priv->hw, RX_INCLUDES_FCS);
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 50d02d9..80b5c73 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -986,6 +986,8 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC) | BIT(NL80211_IFTYPE_AP);
 
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	ieee80211_hw_set(priv->hw, TIMING_BEACON_ONLY);
 	ieee80211_hw_set(priv->hw, SIGNAL_DBM);
 	ieee80211_hw_set(priv->hw, RX_INCLUDES_FCS);
-- 
2.9.3
