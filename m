Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6855C5ACC6
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 21:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65CF42145D
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 21:23:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65CF42145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbeJQFQN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 01:16:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34073 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbeJQFQN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 01:16:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id l6-v6so26821136wrt.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 14:23:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FpXUoKrV0okqQOjo4hERTbR+IBZk4ZjcDI4+LL3k8mc=;
        b=pUpOjj8+oU22cRZYalZK1fKDbEViuMp4ZH8J6TMcn1B0LXNq9cuQt6gbhr3sIBV0D1
         ZClZltf2V27UO6Ym73pmgA4z/NP+VzYRMzZ9I/quQ200mtdg/BKmWe3UFTiHhZFvTs9u
         xY5NoWJrjyVYSbpVg5sC/yDzB/sP1xE4EkHuOXceO0CQ4w1p8YmIsJkdjym6KYeNCXJa
         fdxcZ4xFpZjbdlfVJVK1k49Y0XgSuPl2TsoMN7Pjb7dLL5zw1UsgyphwoEOBCMY5E13i
         ciljVCqkQldLyOevsTUN8k2Bza1x3gisn1Q3NpbMbmlVWyDDDbPem7+kc7g7F5VsQ1rY
         freg==
X-Gm-Message-State: ABuFfojBu16HyNz+xwfSEOFdMAomXEHQ+kMa43Xon9a12sun1IziAXK8
        2f/i0LL2a813j4X+bMnfVBsR5w==
X-Google-Smtp-Source: ACcGV63RYSmGoxH5OIh3vDcu3NRJzO6W6gcs0XCqJWmwz8qaldz+sjZSyNRdVMXUBQ4K0zJZTVcuJw==
X-Received: by 2002:a5d:4dd2:: with SMTP id f18-v6mr22087943wru.80.1539725033211;
        Tue, 16 Oct 2018 14:23:53 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id 193-v6sm14390046wmj.21.2018.10.16.14.23.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Oct 2018 14:23:52 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 1/9] mt76: move mt76x02_init_device in mt76x02-lib module
Date:   Tue, 16 Oct 2018 23:23:23 +0200
Message-Id: <58ef91675f4b3976f55f78838a8dc5c06cb9aadd.1539723134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539723134.git.lorenzo.bianconi@redhat.com>
References: <cover.1539723134.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_init_device routine in mt76x02_util.c in order to be
reused by mt76x0 driver and remove duplicated code. Move interface
combo definition supported by the driver in mt76x02_init_device routine

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |  2 -
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 36 +--------
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 81 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2/init.c  | 34 --------
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  1 -
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  | 41 +---------
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  5 +-
 8 files changed, 87 insertions(+), 114 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index ab4fd6e0f23a..275d77c90624 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -340,8 +340,6 @@ int mt76x0_eeprom_init(struct mt76x02_dev *dev)
 	mt76x0_set_freq_offset(dev);
 	mt76x0_set_temp_offset(dev);
 
-	dev->mt76.chainmask = 0x0101;
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index d49357c7f104..0c4999342e01 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -339,46 +339,16 @@ EXPORT_SYMBOL_GPL(mt76x0_alloc_device);
 
 int mt76x0_register_device(struct mt76x02_dev *dev)
 {
-	struct mt76_dev *mdev = &dev->mt76;
-	struct ieee80211_hw *hw = mdev->hw;
-	struct wiphy *wiphy = hw->wiphy;
 	int ret;
 
-	/* Reserve WCID 0 for mcast - thanks to this APs WCID will go to
-	 * entry no. 1 like it does in the vendor driver.
-	 */
-	mdev->wcid_mask[0] |= 1;
-
-	/* init fake wcid for monitor interfaces */
-	mdev->global_wcid.idx = 0xff;
-	mdev->global_wcid.hw_key_idx = -1;
-
-	/* init antenna configuration */
-	mdev->antenna_mask = 1;
-
-	hw->queues = 4;
-	hw->max_rates = 1;
-	hw->max_report_rates = 7;
-	hw->max_rate_tries = 1;
-	hw->extra_tx_headroom = 2;
-	if (mt76_is_usb(dev))
-		hw->extra_tx_headroom += sizeof(struct mt76x02_txwi) +
-					 MT_DMA_HDR_LEN;
-
-	hw->sta_data_size = sizeof(struct mt76x02_sta);
-	hw->vif_data_size = sizeof(struct mt76x02_vif);
-
-	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
-
-	INIT_DELAYED_WORK(&dev->mac_work, mt76x02_mac_work);
-
-	ret = mt76_register_device(mdev, true, mt76x02_rates,
+	mt76x02_init_device(dev);
+	ret = mt76_register_device(&dev->mt76, true, mt76x02_rates,
 				   ARRAY_SIZE(mt76x02_rates));
 	if (ret)
 		return ret;
 
 	/* overwrite unsupported features */
-	if (mdev->cap.has_5ghz)
+	if (dev->mt76.cap.has_5ghz)
 		mt76x0_vht_cap_mask(&dev->mt76.sband_5g.sband);
 
 	mt76x02_init_debugfs(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index bdbe4bbf7a59..1cd0f758587d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -102,6 +102,7 @@ struct mt76x02_dev {
 
 extern struct ieee80211_rate mt76x02_rates[12];
 
+void mt76x02_init_device(struct mt76x02_dev *dev);
 void mt76x02_configure_filter(struct ieee80211_hw *hw,
 			     unsigned int changed_flags,
 			     unsigned int *total_flags, u64 multicast);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index ca05332f81fc..208c76d40afa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -47,6 +47,87 @@ struct ieee80211_rate mt76x02_rates[] = {
 };
 EXPORT_SYMBOL_GPL(mt76x02_rates);
 
+static const struct ieee80211_iface_limit mt76x02_if_limits[] = {
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_ADHOC)
+	}, {
+		.max = 8,
+		.types = BIT(NL80211_IFTYPE_STATION) |
+#ifdef CONFIG_MAC80211_MESH
+			 BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+			 BIT(NL80211_IFTYPE_AP)
+	 },
+};
+
+static const struct ieee80211_iface_combination mt76x02_if_comb[] = {
+	{
+		.limits = mt76x02_if_limits,
+		.n_limits = ARRAY_SIZE(mt76x02_if_limits),
+		.max_interfaces = 8,
+		.num_different_channels = 1,
+		.beacon_int_infra_match = true,
+		.radar_detect_widths = BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+				       BIT(NL80211_CHAN_WIDTH_20) |
+				       BIT(NL80211_CHAN_WIDTH_40) |
+				       BIT(NL80211_CHAN_WIDTH_80),
+	}
+};
+
+void mt76x02_init_device(struct mt76x02_dev *dev)
+{
+	struct ieee80211_hw *hw = mt76_hw(dev);
+	struct wiphy *wiphy = hw->wiphy;
+
+	INIT_DELAYED_WORK(&dev->mac_work, mt76x02_mac_work);
+
+	hw->queues = 4;
+	hw->max_rates = 1;
+	hw->max_report_rates = 7;
+	hw->max_rate_tries = 1;
+	hw->extra_tx_headroom = 2;
+
+	if (mt76_is_usb(dev)) {
+		hw->extra_tx_headroom += sizeof(struct mt76x02_txwi) +
+					 MT_DMA_HDR_LEN;
+		wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	} else {
+		wiphy->iface_combinations = mt76x02_if_comb;
+		wiphy->n_iface_combinations = ARRAY_SIZE(mt76x02_if_comb);
+		wiphy->interface_modes =
+			BIT(NL80211_IFTYPE_STATION) |
+			BIT(NL80211_IFTYPE_AP) |
+#ifdef CONFIG_MAC80211_MESH
+			BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+			BIT(NL80211_IFTYPE_ADHOC);
+	}
+
+	hw->sta_data_size = sizeof(struct mt76x02_sta);
+	hw->vif_data_size = sizeof(struct mt76x02_vif);
+
+	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
+	ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
+
+	dev->mt76.global_wcid.idx = 255;
+	dev->mt76.global_wcid.hw_key_idx = -1;
+	dev->slottime = 9;
+
+	if (is_mt76x2(dev)) {
+		dev->mt76.sband_2g.sband.ht_cap.cap |=
+				IEEE80211_HT_CAP_LDPC_CODING;
+		dev->mt76.sband_5g.sband.ht_cap.cap |=
+				IEEE80211_HT_CAP_LDPC_CODING;
+		dev->mt76.chainmask = 0x202;
+		dev->mt76.antenna_mask = 3;
+	} else {
+		dev->mt76.chainmask = 0x101;
+		dev->mt76.antenna_mask = 1;
+	}
+}
+EXPORT_SYMBOL_GPL(mt76x02_init_device);
+
 void mt76x02_configure_filter(struct ieee80211_hw *hw,
 			      unsigned int changed_flags,
 			      unsigned int *total_flags, u64 multicast)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
index 04790f84d7d4..54a9b5fac787 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
@@ -158,40 +158,6 @@ void mt76_write_mac_initvals(struct mt76x02_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76_write_mac_initvals);
 
-void mt76x2_init_device(struct mt76x02_dev *dev)
-{
-	struct ieee80211_hw *hw = mt76_hw(dev);
-
-	INIT_DELAYED_WORK(&dev->mac_work, mt76x02_mac_work);
-
-	hw->queues = 4;
-	hw->max_rates = 1;
-	hw->max_report_rates = 7;
-	hw->max_rate_tries = 1;
-	hw->extra_tx_headroom = 2;
-	if (mt76_is_usb(dev))
-		hw->extra_tx_headroom += sizeof(struct mt76x02_txwi) +
-					 MT_DMA_HDR_LEN;
-
-	hw->sta_data_size = sizeof(struct mt76x02_sta);
-	hw->vif_data_size = sizeof(struct mt76x02_vif);
-
-	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
-	ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
-
-	dev->mt76.sband_2g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
-	dev->mt76.sband_5g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
-
-	dev->mt76.chainmask = 0x202;
-	dev->mt76.global_wcid.idx = 255;
-	dev->mt76.global_wcid.hw_key_idx = -1;
-	dev->slottime = 9;
-
-	/* init antenna configuration */
-	dev->mt76.antenna_mask = 3;
-}
-EXPORT_SYMBOL_GPL(mt76x2_init_device);
-
 void mt76x2_init_txpower(struct mt76x02_dev *dev,
 			 struct ieee80211_supported_band *sband)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 7408db788409..eaa44de14826 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -52,7 +52,6 @@ extern const struct ieee80211_ops mt76x2_ops;
 
 struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev);
 int mt76x2_register_device(struct mt76x02_dev *dev);
-void mt76x2_init_device(struct mt76x02_dev *dev);
 
 void mt76x2_phy_power_on(struct mt76x02_dev *dev);
 int mt76x2_init_hardware(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index b15c97e1dfb3..d0dbf6936c92 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -384,34 +384,6 @@ static void mt76x2_regd_notifier(struct wiphy *wiphy,
 	mt76x2_dfs_set_domain(dev, request->dfs_region);
 }
 
-static const struct ieee80211_iface_limit if_limits[] = {
-	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_ADHOC)
-	}, {
-		.max = 8,
-		.types = BIT(NL80211_IFTYPE_STATION) |
-#ifdef CONFIG_MAC80211_MESH
-			 BIT(NL80211_IFTYPE_MESH_POINT) |
-#endif
-			 BIT(NL80211_IFTYPE_AP)
-	 },
-};
-
-static const struct ieee80211_iface_combination if_comb[] = {
-	{
-		.limits = if_limits,
-		.n_limits = ARRAY_SIZE(if_limits),
-		.max_interfaces = 8,
-		.num_different_channels = 1,
-		.beacon_int_infra_match = true,
-		.radar_detect_widths = BIT(NL80211_CHAN_WIDTH_20_NOHT) |
-				       BIT(NL80211_CHAN_WIDTH_20) |
-				       BIT(NL80211_CHAN_WIDTH_40) |
-				       BIT(NL80211_CHAN_WIDTH_80),
-	}
-};
-
 static void mt76x2_led_set_config(struct mt76_dev *mt76, u8 delay_on,
 				  u8 delay_off)
 {
@@ -468,7 +440,7 @@ int mt76x2_register_device(struct mt76x02_dev *dev)
 
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x2_phy_calibrate);
 
-	mt76x2_init_device(dev);
+	mt76x02_init_device(dev);
 
 	ret = mt76x2_init_hardware(dev);
 	if (ret)
@@ -488,19 +460,8 @@ int mt76x2_register_device(struct mt76x02_dev *dev)
 	wiphy->addresses = dev->macaddr_list;
 	wiphy->n_addresses = ARRAY_SIZE(dev->macaddr_list);
 
-	wiphy->iface_combinations = if_comb;
-	wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
-
 	wiphy->reg_notifier = mt76x2_regd_notifier;
 
-	wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_AP) |
-#ifdef CONFIG_MAC80211_MESH
-		BIT(NL80211_IFTYPE_MESH_POINT) |
-#endif
-		BIT(NL80211_IFTYPE_ADHOC);
-
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
 
 	mt76x2_dfs_init_detector(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index b2388f506505..a7d591610f16 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -245,11 +245,10 @@ int mt76x2u_init_hardware(struct mt76x02_dev *dev)
 int mt76x2u_register_device(struct mt76x02_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
-	struct wiphy *wiphy = hw->wiphy;
 	int err;
 
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x2u_phy_calibrate);
-	mt76x2_init_device(dev);
+	mt76x02_init_device(dev);
 
 	err = mt76x2u_init_eeprom(dev);
 	if (err < 0)
@@ -267,8 +266,6 @@ int mt76x2u_register_device(struct mt76x02_dev *dev)
 	if (err < 0)
 		goto fail;
 
-	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
-
 	err = mt76_register_device(&dev->mt76, true, mt76x02_rates,
 				   ARRAY_SIZE(mt76x02_rates));
 	if (err)
-- 
2.19.0

