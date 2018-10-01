Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 078EFC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DE132089A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:19:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9DE132089A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbeJBE7f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 00:59:35 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:56243 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbeJBE7f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 00:59:35 -0400
Received: by mail-wm1-f44.google.com with SMTP id 206-v6so289856wmb.5
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 15:19:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J5D6Ors77DiXvdeX7d4xk3iTpLPSgqhthFtrqzkGRes=;
        b=gDafFQESv2mkjqARAo/GwgAzU2rvXxgqu3eirdZrhSg4x3hVUuwOPMtBAG5C5zJ6IQ
         n8bHZGF7D+fDM8EwVl7OxOPuuhoOsjhfh7h7gLZfytPRBwj2qQCv0plIqIcxSyNo5D9V
         jVmRzzHsjsKW33yfk+QGTFQQgtOmRUrwjYlh0QiUCuEyMAW6TuDX4yqwDpJ26H4GOoNa
         t+q/wZJcSW+REhcuiY5MXGj4KQHNVB41KwUsPCU89rO2MqUrVGspeHNFRo6ACWwWX1Ys
         sFztR8W3ljzhJLnrjSvhqhvG11yOrX6BMLDGGFtqpy/wpKi4pcbIigOyrpWYKlexdjX0
         kCkQ==
X-Gm-Message-State: ABuFfohhZZAzOauPjYJYfzuKoXMdKK1tj+Y9OWPn0qnYSYctJXH4d7S2
        zFwkJB1I3C/EbNTIaAEaGUrHDQ==
X-Google-Smtp-Source: ACcGV63I3nYRL/C9tkJv7Mn92yhLmrZeA28QOzCw6EdQ89n0uOq4rJss6N5KQKfhuC2kXotlFEn3Og==
X-Received: by 2002:a1c:ed4:: with SMTP id 203-v6mr19132wmo.96.1538432371778;
        Mon, 01 Oct 2018 15:19:31 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id t4-v6sm9203420wrb.45.2018.10.01.15.19.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 15:19:31 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 07/10] mt76x0: merge mt76x0_dev in mt76x02_dev
Date:   Tue,  2 Oct 2018 00:19:05 +0200
Message-Id: <20181001221908.16005-8-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Merge mt76x0_dev data structure in mt76x02_dev one and remove
duplicated code. Remove unused definition in mt76x0.h.
Moreover merge mt76x0_caldata and mt76x02_rx_freq_cal data structures.
This is a preliminary patch for rxwi unification.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   |   4 +-
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    |  28 ++---
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  18 +---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  34 +++---
 .../net/wireless/mediatek/mt76/mt76x0/mac.c   |  16 +--
 .../net/wireless/mediatek/mt76/mt76x0/mac.h   |   4 +-
 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  12 +--
 .../net/wireless/mediatek/mt76/mt76x0/mcu.h   |   8 +-
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    | 102 ++++--------------
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  16 +--
 .../wireless/mediatek/mt76/mt76x0/pci_mcu.c   |   4 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  74 +++++++------
 .../net/wireless/mediatek/mt76/mt76x0/tx.c    |   4 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  20 ++--
 .../wireless/mediatek/mt76/mt76x0/usb_mcu.c   |   6 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.h |  17 +++
 16 files changed, 157 insertions(+), 210 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
index ddc1af626b3b..3224e5b1a1e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
@@ -21,7 +21,7 @@
 static int
 mt76x0_ampdu_stat_read(struct seq_file *file, void *data)
 {
-	struct mt76x0_dev *dev = file->private;
+	struct mt76x02_dev *dev = file->private;
 	int i, j;
 
 #define stat_printf(grp, off, name)					\
@@ -75,7 +75,7 @@ static const struct file_operations fops_ampdu_stat = {
 	.release = single_release,
 };
 
-void mt76x0_init_debugfs(struct mt76x0_dev *dev)
+void mt76x0_init_debugfs(struct mt76x02_dev *dev)
 {
 	struct dentry *dir;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 166a1fd8644e..5735038c0e2d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -25,7 +25,7 @@
 
 #define MT_MAP_READS	DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16)
 static int
-mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
+mt76x0_efuse_physical_size_check(struct mt76x02_dev *dev)
 {
 	u8 data[MT_MAP_READS * 16];
 	int ret, i;
@@ -53,7 +53,7 @@ mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
 	return 0;
 }
 
-static void mt76x0_set_chip_cap(struct mt76x0_dev *dev)
+static void mt76x0_set_chip_cap(struct mt76x02_dev *dev)
 {
 	u16 nic_conf0 = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_0);
 	u16 nic_conf1 = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_1);
@@ -82,20 +82,20 @@ static void mt76x0_set_chip_cap(struct mt76x0_dev *dev)
 		dev_err(dev->mt76.dev, "invalid tx-rx stream\n");
 }
 
-static void mt76x0_set_temp_offset(struct mt76x0_dev *dev)
+static void mt76x0_set_temp_offset(struct mt76x02_dev *dev)
 {
 	u8 val;
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_2G_TARGET_POWER) >> 8;
 	if (mt76x02_field_valid(val))
-		dev->caldata.temp_offset = mt76x02_sign_extend(val, 8);
+		dev->cal.rx.temp_offset = mt76x02_sign_extend(val, 8);
 	else
-		dev->caldata.temp_offset = -10;
+		dev->cal.rx.temp_offset = -10;
 }
 
-static void mt76x0_set_freq_offset(struct mt76x0_dev *dev)
+static void mt76x0_set_freq_offset(struct mt76x02_dev *dev)
 {
-	struct mt76x0_caldata *caldata = &dev->caldata;
+	struct mt76x02_rx_freq_cal *caldata = &dev->cal.rx;
 	u8 val;
 
 	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_FREQ_OFFSET);
@@ -110,10 +110,10 @@ static void mt76x0_set_freq_offset(struct mt76x0_dev *dev)
 	caldata->freq_offset -= mt76x02_sign_extend(val, 8);
 }
 
-void mt76x0_read_rx_gain(struct mt76x0_dev *dev)
+void mt76x0_read_rx_gain(struct mt76x02_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
-	struct mt76x0_caldata *caldata = &dev->caldata;
+	struct mt76x02_rx_freq_cal *caldata = &dev->cal.rx;
 	s8 val, lna_5g[3], lna_2g;
 	u16 rssi_offset;
 	int i;
@@ -157,7 +157,7 @@ static s8 mt76x0_get_delta(struct mt76_dev *dev)
 	return mt76x02_rate_power_val(val);
 }
 
-void mt76x0_get_tx_power_per_rate(struct mt76x0_dev *dev)
+void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	bool is_2ghz = chan->band == NL80211_BAND_2GHZ;
@@ -216,7 +216,7 @@ void mt76x0_get_tx_power_per_rate(struct mt76x0_dev *dev)
 	mt76x02_add_rate_power_offset(t, delta);
 }
 
-void mt76x0_get_power_info(struct mt76x0_dev *dev, u8 *info)
+void mt76x0_get_power_info(struct mt76x02_dev *dev, u8 *info)
 {
 	struct mt76x0_chan_map {
 		u8 chan;
@@ -277,7 +277,7 @@ void mt76x0_get_power_info(struct mt76x0_dev *dev, u8 *info)
 		info[1] = 5;
 }
 
-static int mt76x0_check_eeprom(struct mt76x0_dev *dev)
+static int mt76x0_check_eeprom(struct mt76x02_dev *dev)
 {
 	u16 val;
 
@@ -297,7 +297,7 @@ static int mt76x0_check_eeprom(struct mt76x0_dev *dev)
 	}
 }
 
-static int mt76x0_load_eeprom(struct mt76x0_dev *dev)
+static int mt76x0_load_eeprom(struct mt76x02_dev *dev)
 {
 	int found;
 
@@ -316,7 +316,7 @@ static int mt76x0_load_eeprom(struct mt76x0_dev *dev)
 				      MT76X0_EEPROM_SIZE, MT_EE_READ);
 }
 
-int mt76x0_eeprom_init(struct mt76x0_dev *dev)
+int mt76x0_eeprom_init(struct mt76x02_dev *dev)
 {
 	u8 version, fae;
 	u16 data;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index 4e1fafa5b8c3..40fd4e61769b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -18,23 +18,15 @@
 
 #include "../mt76x02_eeprom.h"
 
-struct mt76x0_dev;
+struct mt76x02_dev;
 
 #define MT76X0U_EE_MAX_VER		0x0c
 #define MT76X0_EEPROM_SIZE		512
 
-struct mt76x0_caldata {
-	s8 rssi_offset[2];
-	s8 lna_gain;
-
-	s16 temp_offset;
-	u8 freq_offset;
-};
-
-int mt76x0_eeprom_init(struct mt76x0_dev *dev);
-void mt76x0_read_rx_gain(struct mt76x0_dev *dev);
-void mt76x0_get_tx_power_per_rate(struct mt76x0_dev *dev);
-void mt76x0_get_power_info(struct mt76x0_dev *dev, u8 *info);
+int mt76x0_eeprom_init(struct mt76x02_dev *dev);
+void mt76x0_read_rx_gain(struct mt76x02_dev *dev);
+void mt76x0_get_tx_power_per_rate(struct mt76x02_dev *dev);
+void mt76x0_get_power_info(struct mt76x02_dev *dev, u8 *info);
 
 static inline s8 s6_to_s8(u32 val)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index eb41e247a801..d0f2ee6d7040 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -42,7 +42,7 @@ static void mt76x0_vht_cap_mask(struct ieee80211_supported_band *sband)
 }
 
 static void
-mt76x0_set_wlan_state(struct mt76x0_dev *dev, u32 val, bool enable)
+mt76x0_set_wlan_state(struct mt76x02_dev *dev, u32 val, bool enable)
 {
 	u32 mask = MT_CMB_CTRL_XTAL_RDY | MT_CMB_CTRL_PLL_LD;
 
@@ -69,7 +69,7 @@ mt76x0_set_wlan_state(struct mt76x0_dev *dev, u32 val, bool enable)
 		dev_err(dev->mt76.dev, "PLL and XTAL check failed\n");
 }
 
-void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset)
+void mt76x0_chip_onoff(struct mt76x02_dev *dev, bool enable, bool reset)
 {
 	u32 val;
 
@@ -97,7 +97,7 @@ void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset)
 }
 EXPORT_SYMBOL_GPL(mt76x0_chip_onoff);
 
-static void mt76x0_reset_csr_bbp(struct mt76x0_dev *dev)
+static void mt76x0_reset_csr_bbp(struct mt76x02_dev *dev)
 {
 	mt76_wr(dev, MT_MAC_SYS_CTRL,
 		MT_MAC_SYS_CTRL_RESET_CSR |
@@ -112,7 +112,7 @@ static void mt76x0_reset_csr_bbp(struct mt76x0_dev *dev)
 	mt76_wr_rp(dev, MT_MCU_MEMMAP_WLAN,	\
 		   tab, ARRAY_SIZE(tab))
 
-static int mt76x0_init_bbp(struct mt76x0_dev *dev)
+static int mt76x0_init_bbp(struct mt76x02_dev *dev)
 {
 	int ret, i;
 
@@ -135,7 +135,7 @@ static int mt76x0_init_bbp(struct mt76x0_dev *dev)
 	return 0;
 }
 
-static void mt76x0_init_mac_registers(struct mt76x0_dev *dev)
+static void mt76x0_init_mac_registers(struct mt76x02_dev *dev)
 {
 	u32 reg;
 
@@ -170,7 +170,7 @@ static void mt76x0_init_mac_registers(struct mt76x0_dev *dev)
 	mt76_wr(dev, MT_WMM_CTRL, reg);
 }
 
-static int mt76x0_init_wcid_mem(struct mt76x0_dev *dev)
+static int mt76x0_init_wcid_mem(struct mt76x02_dev *dev)
 {
 	u32 *vals;
 	int i;
@@ -189,14 +189,14 @@ static int mt76x0_init_wcid_mem(struct mt76x0_dev *dev)
 	return 0;
 }
 
-static void mt76x0_init_key_mem(struct mt76x0_dev *dev)
+static void mt76x0_init_key_mem(struct mt76x02_dev *dev)
 {
 	u32 vals[4] = {};
 
 	mt76_wr_copy(dev, MT_SKEY_MODE_BASE_0, vals, ARRAY_SIZE(vals));
 }
 
-static int mt76x0_init_wcid_attr_mem(struct mt76x0_dev *dev)
+static int mt76x0_init_wcid_attr_mem(struct mt76x02_dev *dev)
 {
 	u32 *vals;
 	int i;
@@ -213,7 +213,7 @@ static int mt76x0_init_wcid_attr_mem(struct mt76x0_dev *dev)
 	return 0;
 }
 
-static void mt76x0_reset_counters(struct mt76x0_dev *dev)
+static void mt76x0_reset_counters(struct mt76x02_dev *dev)
 {
 	mt76_rr(dev, MT_RX_STAT_0);
 	mt76_rr(dev, MT_RX_STAT_1);
@@ -223,7 +223,7 @@ static void mt76x0_reset_counters(struct mt76x0_dev *dev)
 	mt76_rr(dev, MT_TX_STA_2);
 }
 
-int mt76x0_mac_start(struct mt76x0_dev *dev)
+int mt76x0_mac_start(struct mt76x02_dev *dev)
 {
 	mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
 
@@ -238,7 +238,7 @@ int mt76x0_mac_start(struct mt76x0_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x0_mac_start);
 
-void mt76x0_mac_stop(struct mt76x0_dev *dev)
+void mt76x0_mac_stop(struct mt76x02_dev *dev)
 {
 	int i = 200, ok = 0;
 
@@ -271,7 +271,7 @@ void mt76x0_mac_stop(struct mt76x0_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x0_mac_stop);
 
-int mt76x0_init_hardware(struct mt76x0_dev *dev)
+int mt76x0_init_hardware(struct mt76x02_dev *dev)
 {
 	int ret;
 
@@ -325,12 +325,12 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x0_init_hardware);
 
-struct mt76x0_dev *
+struct mt76x02_dev *
 mt76x0_alloc_device(struct device *pdev,
 		    const struct mt76_driver_ops *drv_ops,
 		    const struct ieee80211_ops *ops)
 {
-	struct mt76x0_dev *dev;
+	struct mt76x02_dev *dev;
 	struct mt76_dev *mdev;
 
 	mdev = mt76_alloc_device(sizeof(*dev), ops);
@@ -340,15 +340,15 @@ mt76x0_alloc_device(struct device *pdev,
 	mdev->dev = pdev;
 	mdev->drv = drv_ops;
 
-	dev = container_of(mdev, struct mt76x0_dev, mt76);
-	mutex_init(&dev->reg_atomic_mutex);
+	dev = container_of(mdev, struct mt76x02_dev, mt76);
+	mutex_init(&dev->phy_mutex);
 	atomic_set(&dev->avg_ampdu_len, 1);
 
 	return dev;
 }
 EXPORT_SYMBOL_GPL(mt76x0_alloc_device);
 
-int mt76x0_register_device(struct mt76x0_dev *dev)
+int mt76x0_register_device(struct mt76x02_dev *dev)
 {
 	struct mt76_dev *mdev = &dev->mt76;
 	struct ieee80211_hw *hw = mdev->hw;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index eccb9451273f..5fe035323762 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -18,8 +18,8 @@
 #include "../mt76x02_util.h"
 #include <linux/etherdevice.h>
 
-void mt76x0_mac_set_protection(struct mt76x0_dev *dev, bool legacy_prot,
-				int ht_mode)
+void mt76x0_mac_set_protection(struct mt76x02_dev *dev, bool legacy_prot,
+			       int ht_mode)
 {
 	int mode = ht_mode & IEEE80211_HT_OP_MODE_PROTECTION;
 	bool non_gf = !!(ht_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
@@ -77,7 +77,7 @@ void mt76x0_mac_set_protection(struct mt76x0_dev *dev, bool legacy_prot,
 		mt76_wr(dev, MT_CCK_PROT_CFG + i * 4, prot[i]);
 }
 
-void mt76x0_mac_set_short_preamble(struct mt76x0_dev *dev, bool short_preamb)
+void mt76x0_mac_set_short_preamble(struct mt76x02_dev *dev, bool short_preamb)
 {
 	if (short_preamb)
 		mt76_set(dev, MT_AUTO_RSP_CFG, MT_AUTO_RSP_PREAMB_SHORT);
@@ -85,7 +85,7 @@ void mt76x0_mac_set_short_preamble(struct mt76x0_dev *dev, bool short_preamb)
 		mt76_clear(dev, MT_AUTO_RSP_CFG, MT_AUTO_RSP_PREAMB_SHORT);
 }
 
-void mt76x0_mac_config_tsf(struct mt76x0_dev *dev, bool enable, int interval)
+void mt76x0_mac_config_tsf(struct mt76x02_dev *dev, bool enable, int interval)
 {
 	u32 val = mt76_rr(dev, MT_BEACON_TIME_CFG);
 
@@ -105,7 +105,7 @@ void mt76x0_mac_config_tsf(struct mt76x0_dev *dev, bool enable, int interval)
 		MT_BEACON_TIME_CFG_TBTT_EN;
 }
 
-static void mt76x0_check_mac_err(struct mt76x0_dev *dev)
+static void mt76x0_check_mac_err(struct mt76x02_dev *dev)
 {
 	u32 val = mt76_rr(dev, 0x10f4);
 
@@ -120,7 +120,7 @@ static void mt76x0_check_mac_err(struct mt76x0_dev *dev)
 }
 void mt76x0_mac_work(struct work_struct *work)
 {
-	struct mt76x0_dev *dev = container_of(work, struct mt76x0_dev,
+	struct mt76x02_dev *dev = container_of(work, struct mt76x02_dev,
 					       mac_work.work);
 	struct {
 		u32 addr_base;
@@ -171,7 +171,7 @@ void mt76x0_mac_work(struct work_struct *work)
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work, 10 * HZ);
 }
 
-void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev)
+void mt76x0_mac_set_ampdu_factor(struct mt76x02_dev *dev)
 {
 	struct ieee80211_sta *sta;
 	struct mt76_wcid *wcid;
@@ -196,7 +196,7 @@ void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev)
 		   FIELD_PREP(MT_MAX_LEN_CFG_AMPDU, min_factor));
 }
 
-u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
+u32 mt76x0_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 			  void *rxi)
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
index b887693a56b6..c02228413e13 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
@@ -15,6 +15,6 @@
 #ifndef __MT76_MAC_H
 #define __MT76_MAC_H
 
-u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
-			void *rxi);
+u32 mt76x0_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
+			  void *rxi);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index ca6cde7a2f90..1f89570bb08b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -20,7 +20,7 @@
 
 int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 {
-	struct mt76x0_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 	int ret = 0;
 
 	mutex_lock(&dev->mt76.mutex);
@@ -54,7 +54,7 @@ int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 EXPORT_SYMBOL_GPL(mt76x0_config);
 
 static void
-mt76x0_addr_wr(struct mt76x0_dev *dev, const u32 offset, const u8 *addr)
+mt76x0_addr_wr(struct mt76x02_dev *dev, const u32 offset, const u8 *addr)
 {
 	mt76_wr(dev, offset, get_unaligned_le32(addr));
 	mt76_wr(dev, offset + 4, addr[4] | addr[5] << 8);
@@ -64,7 +64,7 @@ void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_bss_conf *info, u32 changed)
 {
-	struct mt76x0_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	mutex_lock(&dev->mt76.mutex);
 
@@ -114,7 +114,7 @@ EXPORT_SYMBOL_GPL(mt76x0_bss_info_changed);
 void mt76x0_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		    const u8 *mac_addr)
 {
-	struct mt76x0_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	cancel_delayed_work_sync(&dev->cal_work);
 	mt76x0_agc_save(dev);
@@ -125,7 +125,7 @@ EXPORT_SYMBOL_GPL(mt76x0_sw_scan);
 void mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif)
 {
-	struct mt76x0_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	mt76x0_agc_restore(dev);
 	clear_bit(MT76_SCANNING, &dev->mt76.state);
@@ -137,7 +137,7 @@ EXPORT_SYMBOL_GPL(mt76x0_sw_scan_complete);
 
 int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
-	struct mt76x0_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	mt76_rmw_field(dev, MT_TX_RTS_CFG, MT_TX_RTS_CFG_THRESH, value);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
index 297bf6b94d8c..b66e70f6cd89 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
@@ -17,7 +17,7 @@
 
 #include "../mt76x02_mcu.h"
 
-struct mt76x0_dev;
+struct mt76x02_dev;
 
 #define MT_MCU_IVB_SIZE			0x40
 #define MT_MCU_DLM_OFFSET		0x80000
@@ -41,9 +41,9 @@ enum mcu_calibrate {
 	MCU_CAL_TX_GROUP_DELAY,
 };
 
-int mt76x0e_mcu_init(struct mt76x0_dev *dev);
-int mt76x0u_mcu_init(struct mt76x0_dev *dev);
-static inline int mt76x0_firmware_running(struct mt76x0_dev *dev)
+int mt76x0e_mcu_init(struct mt76x02_dev *dev);
+int mt76x0u_mcu_init(struct mt76x02_dev *dev);
+static inline int mt76x0_firmware_running(struct mt76x02_dev *dev)
 {
 	return mt76_rr(dev, MT_MCU_COM_REG0) == 1;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 66b5986d78d3..418a3cc76b43 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -28,93 +28,33 @@
 #include "../mt76.h"
 #include "../mt76x02_regs.h"
 #include "../mt76x02_mac.h"
+#include "../mt76x02_util.h"
 #include "eeprom.h"
 
 #define MT_CALIBRATE_INTERVAL		(4 * HZ)
 
-#define MT_FREQ_CAL_INIT_DELAY		(30 * HZ)
-#define MT_FREQ_CAL_CHECK_INTERVAL	(10 * HZ)
-#define MT_FREQ_CAL_ADJ_INTERVAL	(HZ / 2)
-
-#define MT_BBP_REG_VERSION		0x00
-
 #define MT_USB_AGGR_SIZE_LIMIT		21 /* * 1024B */
 #define MT_USB_AGGR_TIMEOUT		0x80 /* * 33ns */
 
-struct mac_stats {
-	u64 rx_stat[6];
-	u64 tx_stat[6];
-	u64 aggr_stat[2];
-	u64 aggr_n[32];
-	u64 zero_len_del[2];
-};
-
-struct mt76x0_eeprom_params;
-
-#define MT_EE_TEMPERATURE_SLOPE		39
-#define MT_FREQ_OFFSET_INVALID		-128
-
-/* addr req mask */
-#define MT_VEND_TYPE_EEPROM	BIT(31)
-#define MT_VEND_TYPE_CFG	BIT(30)
-#define MT_VEND_TYPE_MASK	(MT_VEND_TYPE_EEPROM | MT_VEND_TYPE_CFG)
-
-#define MT_VEND_ADDR(type, n)	(MT_VEND_TYPE_##type | (n))
-
-enum mt_bw {
-	MT_BW_20,
-	MT_BW_40,
-};
-
-/**
- * struct mt76x0_dev - adapter structure
- * @lock:		protects @wcid->tx_rate.
- * @mutex:		ensures exclusive access from mac80211 callbacks.
- * @reg_atomic_mutex:	ensures atomicity of indirect register accesses
- *			(accesses to RF and BBP).
- */
-struct mt76x0_dev {
-	struct mt76_dev mt76; /* must be first */
-
-	struct delayed_work cal_work;
-	struct delayed_work mac_work;
-
-	struct mt76x0_caldata caldata;
-
-	struct mutex reg_atomic_mutex;
-
-	atomic_t avg_ampdu_len;
-
-	u8 agc_save;
-
-	bool no_2ghz;
-
-	struct mac_stats stats;
-};
-
-static inline bool is_mt7610e(struct mt76x0_dev *dev)
+static inline bool is_mt7610e(struct mt76x02_dev *dev)
 {
 	/* TODO */
 	return false;
 }
 
-void mt76x0_init_debugfs(struct mt76x0_dev *dev);
-
-/* Compatibility with mt76 */
-#define mt76_rmw_field(_dev, _reg, _field, _val)	\
-	mt76_rmw(_dev, _reg, _field, FIELD_PREP(_field, _val))
+void mt76x0_init_debugfs(struct mt76x02_dev *dev);
 
 /* Init */
-struct mt76x0_dev *
+struct mt76x02_dev *
 mt76x0_alloc_device(struct device *pdev,
 		    const struct mt76_driver_ops *drv_ops,
 		    const struct ieee80211_ops *ops);
-int mt76x0_init_hardware(struct mt76x0_dev *dev);
-int mt76x0_register_device(struct mt76x0_dev *dev);
-void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset);
+int mt76x0_init_hardware(struct mt76x02_dev *dev);
+int mt76x0_register_device(struct mt76x02_dev *dev);
+void mt76x0_chip_onoff(struct mt76x02_dev *dev, bool enable, bool reset);
 
-int mt76x0_mac_start(struct mt76x0_dev *dev);
-void mt76x0_mac_stop(struct mt76x0_dev *dev);
+int mt76x0_mac_start(struct mt76x02_dev *dev);
+void mt76x0_mac_stop(struct mt76x02_dev *dev);
 
 int mt76x0_config(struct ieee80211_hw *hw, u32 changed);
 void mt76x0_bss_info_changed(struct ieee80211_hw *hw,
@@ -127,23 +67,23 @@ void mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
 int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
 
 /* PHY */
-void mt76x0_phy_init(struct mt76x0_dev *dev);
-int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev);
-void mt76x0_agc_save(struct mt76x0_dev *dev);
-void mt76x0_agc_restore(struct mt76x0_dev *dev);
-int mt76x0_phy_set_channel(struct mt76x0_dev *dev,
+void mt76x0_phy_init(struct mt76x02_dev *dev);
+int mt76x0_wait_bbp_ready(struct mt76x02_dev *dev);
+void mt76x0_agc_save(struct mt76x02_dev *dev);
+void mt76x0_agc_restore(struct mt76x02_dev *dev);
+int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 			    struct cfg80211_chan_def *chandef);
-void mt76x0_phy_recalibrate_after_assoc(struct mt76x0_dev *dev);
-int mt76x0_phy_get_rssi(struct mt76x0_dev *dev, struct mt76x02_rxwi *rxwi);
-void mt76x0_phy_set_txpower(struct mt76x0_dev *dev);
+void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev);
+int mt76x0_phy_get_rssi(struct mt76x02_dev *dev, struct mt76x02_rxwi *rxwi);
+void mt76x0_phy_set_txpower(struct mt76x02_dev *dev);
 
 /* MAC */
 void mt76x0_mac_work(struct work_struct *work);
-void mt76x0_mac_set_protection(struct mt76x0_dev *dev, bool legacy_prot,
+void mt76x0_mac_set_protection(struct mt76x02_dev *dev, bool legacy_prot,
 				int ht_mode);
-void mt76x0_mac_set_short_preamble(struct mt76x0_dev *dev, bool short_preamb);
-void mt76x0_mac_config_tsf(struct mt76x0_dev *dev, bool enable, int interval);
-void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev);
+void mt76x0_mac_set_short_preamble(struct mt76x02_dev *dev, bool short_preamb);
+void mt76x0_mac_config_tsf(struct mt76x02_dev *dev, bool enable, int interval);
+void mt76x0_mac_set_ampdu_factor(struct mt76x02_dev *dev);
 
 /* TX */
 void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 97bf8634b06d..f6f54cac0326 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -25,7 +25,7 @@
 
 static int mt76x0e_start(struct ieee80211_hw *hw)
 {
-	struct mt76x0_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	mutex_lock(&dev->mt76.mutex);
 
@@ -41,7 +41,7 @@ static int mt76x0e_start(struct ieee80211_hw *hw)
 	return 0;
 }
 
-static void mt76x0e_stop_hw(struct mt76x0_dev *dev)
+static void mt76x0e_stop_hw(struct mt76x02_dev *dev)
 {
 	cancel_delayed_work_sync(&dev->cal_work);
 	cancel_delayed_work_sync(&dev->mac_work);
@@ -61,7 +61,7 @@ static void mt76x0e_stop_hw(struct mt76x0_dev *dev)
 
 static void mt76x0e_stop(struct ieee80211_hw *hw)
 {
-	struct mt76x0_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	mutex_lock(&dev->mt76.mutex);
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
@@ -79,7 +79,7 @@ static const struct ieee80211_ops mt76x0e_ops = {
 	.configure_filter = mt76x02_configure_filter,
 };
 
-static int mt76x0e_register_device(struct mt76x0_dev *dev)
+static int mt76x0e_register_device(struct mt76x02_dev *dev)
 {
 	int err;
 
@@ -126,8 +126,8 @@ static int mt76x0e_register_device(struct mt76x0_dev *dev)
 static int
 mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct mt76x0_dev *dev;
-	int ret = -ENODEV;
+	struct mt76x02_dev *dev;
+	int ret;
 
 	ret = pcim_enable_device(pdev);
 	if (ret)
@@ -163,7 +163,7 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
-static void mt76x0e_cleanup(struct mt76x0_dev *dev)
+static void mt76x0e_cleanup(struct mt76x02_dev *dev)
 {
 	clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
 	mt76x0_chip_onoff(dev, false, false);
@@ -176,7 +176,7 @@ static void
 mt76x0e_remove(struct pci_dev *pdev)
 {
 	struct mt76_dev *mdev = pci_get_drvdata(pdev);
-	struct mt76x0_dev *dev = container_of(mdev, struct mt76x0_dev, mt76);
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 
 	mt76_unregister_device(mdev);
 	mt76x0e_cleanup(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
index e3cf049314bb..6c66656c21f4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
@@ -24,7 +24,7 @@
 
 #define MT_MCU_IVB_ADDR		(MT_MCU_ILM_ADDR + 0x54000 - MT_MCU_IVB_SIZE)
 
-static int mt76x0e_load_firmware(struct mt76x0_dev *dev)
+static int mt76x0e_load_firmware(struct mt76x02_dev *dev)
 {
 	bool is_combo_chip = mt76_chip(&dev->mt76) != 0x7610;
 	u32 val, ilm_len, dlm_len, offset = 0;
@@ -126,7 +126,7 @@ static int mt76x0e_load_firmware(struct mt76x0_dev *dev)
 	return err;
 }
 
-int mt76x0e_mcu_init(struct mt76x0_dev *dev)
+int mt76x0e_mcu_init(struct mt76x02_dev *dev)
 {
 	static const struct mt76_mcu_ops mt76x0e_mcu_ops = {
 		.mcu_msg_alloc = mt76x02_mcu_msg_alloc,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 661333243052..9296ccd53ce6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -26,7 +26,7 @@
 #include <linux/etherdevice.h>
 
 static int
-mt76x0_rf_csr_wr(struct mt76x0_dev *dev, u32 offset, u8 value)
+mt76x0_rf_csr_wr(struct mt76x02_dev *dev, u32 offset, u8 value)
 {
 	int ret = 0;
 	u8 bank, reg;
@@ -40,7 +40,7 @@ mt76x0_rf_csr_wr(struct mt76x0_dev *dev, u32 offset, u8 value)
 	if (WARN_ON_ONCE(reg > 64) || WARN_ON_ONCE(bank) > 8)
 		return -EINVAL;
 
-	mutex_lock(&dev->reg_atomic_mutex);
+	mutex_lock(&dev->phy_mutex);
 
 	if (!mt76_poll(dev, MT_RF_CSR_CFG, MT_RF_CSR_CFG_KICK, 0, 100)) {
 		ret = -ETIMEDOUT;
@@ -55,7 +55,7 @@ mt76x0_rf_csr_wr(struct mt76x0_dev *dev, u32 offset, u8 value)
 		   MT_RF_CSR_CFG_KICK);
 	trace_mt76x0_rf_write(&dev->mt76, bank, offset, value);
 out:
-	mutex_unlock(&dev->reg_atomic_mutex);
+	mutex_unlock(&dev->phy_mutex);
 
 	if (ret < 0)
 		dev_err(dev->mt76.dev, "Error: RF write %d:%d failed:%d!!\n",
@@ -64,8 +64,7 @@ mt76x0_rf_csr_wr(struct mt76x0_dev *dev, u32 offset, u8 value)
 	return ret;
 }
 
-static int
-mt76x0_rf_csr_rr(struct mt76x0_dev *dev, u32 offset)
+static int mt76x0_rf_csr_rr(struct mt76x02_dev *dev, u32 offset)
 {
 	int ret = -ETIMEDOUT;
 	u32 val;
@@ -80,7 +79,7 @@ mt76x0_rf_csr_rr(struct mt76x0_dev *dev, u32 offset)
 	if (WARN_ON_ONCE(reg > 64) || WARN_ON_ONCE(bank) > 8)
 		return -EINVAL;
 
-	mutex_lock(&dev->reg_atomic_mutex);
+	mutex_lock(&dev->phy_mutex);
 
 	if (!mt76_poll(dev, MT_RF_CSR_CFG, MT_RF_CSR_CFG_KICK, 0, 100))
 		goto out;
@@ -100,7 +99,7 @@ mt76x0_rf_csr_rr(struct mt76x0_dev *dev, u32 offset)
 		trace_mt76x0_rf_read(&dev->mt76, bank, offset, ret);
 	}
 out:
-	mutex_unlock(&dev->reg_atomic_mutex);
+	mutex_unlock(&dev->phy_mutex);
 
 	if (ret < 0)
 		dev_err(dev->mt76.dev, "Error: RF read %d:%d failed:%d!!\n",
@@ -110,7 +109,7 @@ mt76x0_rf_csr_rr(struct mt76x0_dev *dev, u32 offset)
 }
 
 static int
-rf_wr(struct mt76x0_dev *dev, u32 offset, u8 val)
+rf_wr(struct mt76x02_dev *dev, u32 offset, u8 val)
 {
 	if (test_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state)) {
 		struct mt76_reg_pair pair = {
@@ -126,7 +125,7 @@ rf_wr(struct mt76x0_dev *dev, u32 offset, u8 val)
 }
 
 static int
-rf_rr(struct mt76x0_dev *dev, u32 offset)
+rf_rr(struct mt76x02_dev *dev, u32 offset)
 {
 	int ret;
 	u32 val;
@@ -147,7 +146,7 @@ rf_rr(struct mt76x0_dev *dev, u32 offset)
 }
 
 static int
-rf_rmw(struct mt76x0_dev *dev, u32 offset, u8 mask, u8 val)
+rf_rmw(struct mt76x02_dev *dev, u32 offset, u8 mask, u8 val)
 {
 	int ret;
 
@@ -163,14 +162,14 @@ rf_rmw(struct mt76x0_dev *dev, u32 offset, u8 mask, u8 val)
 }
 
 static int
-rf_set(struct mt76x0_dev *dev, u32 offset, u8 val)
+rf_set(struct mt76x02_dev *dev, u32 offset, u8 val)
 {
 	return rf_rmw(dev, offset, 0, val);
 }
 
 #if 0
 static int
-rf_clear(struct mt76x0_dev *dev, u32 offset, u8 mask)
+rf_clear(struct mt76x02_dev *dev, u32 offset, u8 mask)
 {
 	return rf_rmw(dev, offset, mask, 0);
 }
@@ -180,7 +179,7 @@ rf_clear(struct mt76x0_dev *dev, u32 offset, u8 mask)
 	mt76_wr_rp(dev, MT_MCU_MEMMAP_RF,	\
 		   tab, ARRAY_SIZE(tab))
 
-int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev)
+int mt76x0_wait_bbp_ready(struct mt76x02_dev *dev)
 {
 	int i = 20;
 	u32 val;
@@ -201,7 +200,7 @@ int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev)
 }
 
 static void
-mt76x0_bbp_set_ctrlch(struct mt76x0_dev *dev, enum nl80211_chan_width width,
+mt76x0_bbp_set_ctrlch(struct mt76x02_dev *dev, enum nl80211_chan_width width,
 		      u8 ctrl)
 {
 	int core_val, agc_val;
@@ -227,14 +226,14 @@ mt76x0_bbp_set_ctrlch(struct mt76x0_dev *dev, enum nl80211_chan_width width,
 	mt76_rmw_field(dev, MT_BBP(TXBE, 0), MT_BBP_TXBE_R0_CTRL_CHAN, ctrl);
 }
 
-int mt76x0_phy_get_rssi(struct mt76x0_dev *dev, struct mt76x02_rxwi *rxwi)
+int mt76x0_phy_get_rssi(struct mt76x02_dev *dev, struct mt76x02_rxwi *rxwi)
 {
-	struct mt76x0_caldata *caldata = &dev->caldata;
+	struct mt76x02_rx_freq_cal *caldata = &dev->cal.rx;
 
 	return rxwi->rssi[0] + caldata->rssi_offset[0] - caldata->lna_gain;
 }
 
-static void mt76x0_vco_cal(struct mt76x0_dev *dev, u8 channel)
+static void mt76x0_vco_cal(struct mt76x02_dev *dev, u8 channel)
 {
 	u8 val;
 
@@ -291,14 +290,14 @@ static void mt76x0_vco_cal(struct mt76x0_dev *dev, u8 channel)
 }
 
 static void
-mt76x0_mac_set_ctrlch(struct mt76x0_dev *dev, bool primary_upper)
+mt76x0_mac_set_ctrlch(struct mt76x02_dev *dev, bool primary_upper)
 {
 	mt76_rmw_field(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_UPPER_40M,
 		       primary_upper);
 }
 
 static void
-mt76x0_phy_set_band(struct mt76x0_dev *dev, enum nl80211_band band)
+mt76x0_phy_set_band(struct mt76x02_dev *dev, enum nl80211_band band)
 {
 	switch (band) {
 	case NL80211_BAND_2GHZ:
@@ -331,7 +330,7 @@ mt76x0_phy_set_band(struct mt76x0_dev *dev, enum nl80211_band band)
 }
 
 static void
-mt76x0_phy_set_chan_rf_params(struct mt76x0_dev *dev, u8 channel, u16 rf_bw_band)
+mt76x0_phy_set_chan_rf_params(struct mt76x02_dev *dev, u8 channel, u16 rf_bw_band)
 {
 	u16 rf_band = rf_bw_band & 0xff00;
 	u16 rf_bw = rf_bw_band & 0x00ff;
@@ -522,7 +521,7 @@ mt76x0_phy_set_chan_rf_params(struct mt76x0_dev *dev, u8 channel, u16 rf_bw_band
 }
 
 static void
-mt76x0_phy_set_chan_bbp_params(struct mt76x0_dev *dev, u8 channel, u16 rf_bw_band)
+mt76x0_phy_set_chan_bbp_params(struct mt76x02_dev *dev, u8 channel, u16 rf_bw_band)
 {
 	int i;
 
@@ -538,7 +537,7 @@ mt76x0_phy_set_chan_bbp_params(struct mt76x0_dev *dev, u8 channel, u16 rf_bw_ban
 			u8 gain;
 
 			gain = FIELD_GET(MT_BBP_AGC_GAIN, val);
-			gain -= dev->caldata.lna_gain * 2;
+			gain -= dev->cal.rx.lna_gain * 2;
 			val &= ~MT_BBP_AGC_GAIN;
 			val |= FIELD_PREP(MT_BBP_AGC_GAIN, gain);
 			mt76_wr(dev, pair->reg, val);
@@ -548,7 +547,7 @@ mt76x0_phy_set_chan_bbp_params(struct mt76x0_dev *dev, u8 channel, u16 rf_bw_ban
 	}
 }
 
-static void mt76x0_ant_select(struct mt76x0_dev *dev)
+static void mt76x0_ant_select(struct mt76x02_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 
@@ -568,7 +567,7 @@ static void mt76x0_ant_select(struct mt76x0_dev *dev)
 }
 
 static void
-mt76x0_bbp_set_bw(struct mt76x0_dev *dev, enum nl80211_chan_width width)
+mt76x0_bbp_set_bw(struct mt76x02_dev *dev, enum nl80211_chan_width width)
 {
 	enum { BW_20 = 0, BW_40 = 1, BW_80 = 2, BW_10 = 4};
 	int bw;
@@ -598,7 +597,7 @@ mt76x0_bbp_set_bw(struct mt76x0_dev *dev, enum nl80211_chan_width width)
 	mt76x02_mcu_function_select(&dev->mt76, BW_SETTING, bw, false);
 }
 
-void mt76x0_phy_set_txpower(struct mt76x0_dev *dev)
+void mt76x0_phy_set_txpower(struct mt76x02_dev *dev)
 {
 	struct mt76_rate_power *t = &dev->mt76.rate_power;
 	u8 info[2];
@@ -614,7 +613,7 @@ void mt76x0_phy_set_txpower(struct mt76x0_dev *dev)
 	mt76x02_phy_set_txpower(&dev->mt76, info[0], info[1]);
 }
 
-int mt76x0_phy_set_channel(struct mt76x0_dev *dev,
+int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 			   struct cfg80211_chan_def *chandef)
 {
 	u32 ext_cca_chan[4] = {
@@ -712,7 +711,7 @@ int mt76x0_phy_set_channel(struct mt76x0_dev *dev,
 	return 0;
 }
 
-void mt76x0_phy_recalibrate_after_assoc(struct mt76x0_dev *dev)
+void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
 {
 	u32 tx_alc, reg_val;
 	u8 channel = dev->mt76.chandef.chan->hw_value;
@@ -748,18 +747,18 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x0_dev *dev)
 	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_RXDCOC, 1, false);
 }
 
-void mt76x0_agc_save(struct mt76x0_dev *dev)
+void mt76x0_agc_save(struct mt76x02_dev *dev)
 {
 	/* Only one RX path */
 	dev->agc_save = FIELD_GET(MT_BBP_AGC_GAIN, mt76_rr(dev, MT_BBP(AGC, 8)));
 }
 
-void mt76x0_agc_restore(struct mt76x0_dev *dev)
+void mt76x0_agc_restore(struct mt76x02_dev *dev)
 {
 	mt76_rmw_field(dev, MT_BBP(AGC, 8), MT_BBP_AGC_GAIN, dev->agc_save);
 }
 
-static void mt76x0_temp_sensor(struct mt76x0_dev *dev)
+static void mt76x0_temp_sensor(struct mt76x02_dev *dev)
 {
 	u8 rf_b7_73, rf_b0_66, rf_b0_67;
 	int cycle, temp;
@@ -795,7 +794,7 @@ static void mt76x0_temp_sensor(struct mt76x0_dev *dev)
 	else
 		sval |= 0xffffff00; /* Negative */
 
-	temp = (35 * (sval - dev->caldata.temp_offset)) / 10 + 25;
+	temp = (35 * (sval - dev->cal.rx.temp_offset)) / 10 + 25;
 
 done:
 	rf_wr(dev, MT_RF(7, 73), rf_b7_73);
@@ -803,7 +802,7 @@ static void mt76x0_temp_sensor(struct mt76x0_dev *dev)
 	rf_wr(dev, MT_RF(0, 73), rf_b0_67);
 }
 
-static void mt76x0_dynamic_vga_tuning(struct mt76x0_dev *dev)
+static void mt76x0_dynamic_vga_tuning(struct mt76x02_dev *dev)
 {
 	struct cfg80211_chan_def *chandef = &dev->mt76.chandef;
 	u32 val, init_vga;
@@ -824,8 +823,8 @@ static void mt76x0_dynamic_vga_tuning(struct mt76x0_dev *dev)
 
 static void mt76x0_phy_calibrate(struct work_struct *work)
 {
-	struct mt76x0_dev *dev = container_of(work, struct mt76x0_dev,
-					    cal_work.work);
+	struct mt76x02_dev *dev = container_of(work, struct mt76x02_dev,
+					       cal_work.work);
 
 	mt76x0_dynamic_vga_tuning(dev);
 	mt76x0_temp_sensor(dev);
@@ -834,8 +833,7 @@ static void mt76x0_phy_calibrate(struct work_struct *work)
 				     MT_CALIBRATE_INTERVAL);
 }
 
-static void
-mt76x0_rf_init(struct mt76x0_dev *dev)
+static void mt76x0_rf_init(struct mt76x02_dev *dev)
 {
 	int i;
 	u8 val;
@@ -868,7 +866,7 @@ mt76x0_rf_init(struct mt76x0_dev *dev)
 	   E2: B0.R21<0>: xo_cxo<0>, B0.R22<7:0>: xo_cxo<8:1>
 	 */
 	rf_wr(dev, MT_RF(0, 22),
-	      min_t(u8, dev->caldata.freq_offset, 0xbf));
+	      min_t(u8, dev->cal.rx.freq_offset, 0xbf));
 	val = rf_rr(dev, MT_RF(0, 22));
 
 	/*
@@ -888,7 +886,7 @@ mt76x0_rf_init(struct mt76x0_dev *dev)
 	rf_set(dev, MT_RF(0, 4), 0x80);
 }
 
-void mt76x0_phy_init(struct mt76x0_dev *dev)
+void mt76x0_phy_init(struct mt76x02_dev *dev)
 {
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x0_phy_calibrate);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 472a330821dc..dd630fcfaa08 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -21,7 +21,7 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	       struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct mt76x0_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 	struct ieee80211_vif *vif = info->control.vif;
 	struct mt76_wcid *wcid = &dev->mt76.global_wcid;
 
@@ -49,7 +49,7 @@ EXPORT_SYMBOL_GPL(mt76x0_tx);
 void mt76x0_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			 struct sk_buff *skb)
 {
-	struct mt76x0_dev *dev = container_of(mdev, struct mt76x0_dev, mt76);
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	void *rxwi = skb->data;
 
 	skb_pull(skb, sizeof(struct mt76x02_rxwi));
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 42c996067d9e..f9468bb4cba0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -49,7 +49,7 @@ static struct usb_device_id mt76x0_device_table[] = {
 	{ 0, }
 };
 
-static void mt76x0_init_usb_dma(struct mt76x0_dev *dev)
+static void mt76x0_init_usb_dma(struct mt76x02_dev *dev)
 {
 	u32 val;
 
@@ -76,7 +76,7 @@ static void mt76x0_init_usb_dma(struct mt76x0_dev *dev)
 	mt76_wr(dev, MT_USB_DMA_CFG, val);
 }
 
-static void mt76x0u_cleanup(struct mt76x0_dev *dev)
+static void mt76x0u_cleanup(struct mt76x02_dev *dev)
 {
 	clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
 	mt76x0_chip_onoff(dev, false, false);
@@ -84,7 +84,7 @@ static void mt76x0u_cleanup(struct mt76x0_dev *dev)
 	mt76u_mcu_deinit(&dev->mt76);
 }
 
-static void mt76x0u_mac_stop(struct mt76x0_dev *dev)
+static void mt76x0u_mac_stop(struct mt76x02_dev *dev)
 {
 	if (test_bit(MT76_REMOVED, &dev->mt76.state))
 		return;
@@ -109,7 +109,7 @@ static void mt76x0u_mac_stop(struct mt76x0_dev *dev)
 
 static int mt76x0u_start(struct ieee80211_hw *hw)
 {
-	struct mt76x0_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 	int ret;
 
 	mutex_lock(&dev->mt76.mutex);
@@ -131,7 +131,7 @@ static int mt76x0u_start(struct ieee80211_hw *hw)
 
 static void mt76x0u_stop(struct ieee80211_hw *hw)
 {
-	struct mt76x0_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	mutex_lock(&dev->mt76.mutex);
 	mt76x0u_mac_stop(dev);
@@ -159,7 +159,7 @@ static const struct ieee80211_ops mt76x0u_ops = {
 	.wake_tx_queue = mt76_wake_tx_queue,
 };
 
-static int mt76x0u_register_device(struct mt76x0_dev *dev)
+static int mt76x0u_register_device(struct mt76x02_dev *dev)
 {
 	struct ieee80211_hw *hw = dev->mt76.hw;
 	int err;
@@ -221,7 +221,7 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 		.rx_skb = mt76x0_queue_rx_skb,
 	};
 	struct usb_device *usb_dev = interface_to_usbdev(usb_intf);
-	struct mt76x0_dev *dev;
+	struct mt76x02_dev *dev;
 	u32 asic_rev, mac_rev;
 	int ret;
 
@@ -277,7 +277,7 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 
 static void mt76x0_disconnect(struct usb_interface *usb_intf)
 {
-	struct mt76x0_dev *dev = usb_get_intfdata(usb_intf);
+	struct mt76x02_dev *dev = usb_get_intfdata(usb_intf);
 	bool initalized = test_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
 
 	if (!initalized)
@@ -295,7 +295,7 @@ static void mt76x0_disconnect(struct usb_interface *usb_intf)
 static int __maybe_unused mt76x0_suspend(struct usb_interface *usb_intf,
 					 pm_message_t state)
 {
-	struct mt76x0_dev *dev = usb_get_intfdata(usb_intf);
+	struct mt76x02_dev *dev = usb_get_intfdata(usb_intf);
 	struct mt76_usb *usb = &dev->mt76.usb;
 
 	mt76u_stop_queues(&dev->mt76);
@@ -307,7 +307,7 @@ static int __maybe_unused mt76x0_suspend(struct usb_interface *usb_intf,
 
 static int __maybe_unused mt76x0_resume(struct usb_interface *usb_intf)
 {
-	struct mt76x0_dev *dev = usb_get_intfdata(usb_intf);
+	struct mt76x02_dev *dev = usb_get_intfdata(usb_intf);
 	struct mt76_usb *usb = &dev->mt76.usb;
 	int ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
index 4c5b7a6f15ce..fb6fa1fa5548 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
@@ -25,7 +25,7 @@
 #define MT7610U_FIRMWARE		"mediatek/mt7610u.bin"
 
 static int
-mt76x0u_upload_firmware(struct mt76x0_dev *dev,
+mt76x0u_upload_firmware(struct mt76x02_dev *dev,
 			const struct mt76x02_fw_header *hdr)
 {
 	u8 *fw_payload = (u8 *)(hdr + 1);
@@ -76,7 +76,7 @@ mt76x0u_upload_firmware(struct mt76x0_dev *dev,
 	return err;
 }
 
-static int mt76x0u_load_firmware(struct mt76x0_dev *dev)
+static int mt76x0u_load_firmware(struct mt76x02_dev *dev)
 {
 	const struct firmware *fw;
 	const struct mt76x02_fw_header *hdr;
@@ -160,7 +160,7 @@ static int mt76x0u_load_firmware(struct mt76x0_dev *dev)
 	return -ENOENT;
 }
 
-int mt76x0u_mcu_init(struct mt76x0_dev *dev)
+int mt76x0u_mcu_init(struct mt76x02_dev *dev)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index b628e9a50d87..cfae0497fde0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -23,12 +23,22 @@
 #include "mt76x02_mac.h"
 #include "mt76x02_dfs.h"
 
+struct mt76x02_mac_stats {
+	u64 rx_stat[6];
+	u64 tx_stat[6];
+	u64 aggr_stat[2];
+	u64 aggr_n[32];
+	u64 zero_len_del[2];
+};
+
 #define MT_MAX_CHAINS		2
 struct mt76x02_rx_freq_cal {
 	s8 high_gain[MT_MAX_CHAINS];
 	s8 rssi_offset[MT_MAX_CHAINS];
 	s8 lna_gain;
 	u32 mcu_gain;
+	s16 temp_offset;
+	u8 freq_offset;
 };
 
 struct mt76x02_calibration {
@@ -56,6 +66,7 @@ struct mt76x02_dev {
 
 	struct mac_address macaddr_list[8];
 
+	struct mutex phy_mutex;
 	struct mutex mutex;
 
 	u8 txdone_seq;
@@ -68,6 +79,8 @@ struct mt76x02_dev {
 	struct delayed_work cal_work;
 	struct delayed_work mac_work;
 
+	struct mt76x02_mac_stats stats;
+	atomic_t avg_ampdu_len;
 	u32 aggr_stats[32];
 
 	struct sk_buff *beacons[8];
@@ -83,6 +96,10 @@ struct mt76x02_dev {
 	s8 target_power_delta[2];
 	bool enable_tpc;
 
+	bool no_2ghz;
+
+	u8 agc_save;
+
 	u8 coverage_class;
 	u8 slottime;
 
-- 
2.19.0

