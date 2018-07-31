Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46682 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730595AbeGaJsp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:48:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id h14-v6so15606972wrw.13
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 01:09:35 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH v2 11/19] mt76: introduce mt76x2-common module
Date: Tue, 31 Jul 2018 10:09:12 +0200
Message-Id: <a5a04bcf27d6df2c6af4a667005e2aff3d8405d8.1533023328.git.lorenzo.bianconi@redhat.com> (sfid-20180731_100957_359119_3A648599)
In-Reply-To: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
References: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to remove usb dependency from pcie code, add mt76x2-common as
a container of shared code between mt76x2 and mt76x2u. Add eeprom code
to mt76x2-common module

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Kconfig         |  5 +++++
 drivers/net/wireless/mediatek/mt76/Makefile        |  6 +++++-
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c | 13 +++++++++++--
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h |  1 +
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index fc05d79c80d0..1e5c6af6afa2 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -1,9 +1,14 @@
 config MT76_CORE
 	tristate
 
+config MT76x2_COMMON
+	tristate
+	depends on MT76_CORE
+
 config MT76x2E
 	tristate "MediaTek MT76x2E (PCIe) support"
 	select MT76_CORE
+	select MT76x2_COMMON
 	depends on MAC80211
 	depends on PCI
 	---help---
diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index a0156bc01dea..57feda501a51 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_MT76_CORE) += mt76.o
+obj-$(CONFIG_MT76x2_COMMON) += mt76x2-common.o
 obj-$(CONFIG_MT76x2E) += mt76x2e.o
 
 mt76-y := \
@@ -6,10 +7,13 @@ mt76-y := \
 
 CFLAGS_trace.o := -I$(src)
 
+mt76x2-common-y := \
+	mt76x2_eeprom.o
+
 mt76x2e-y := \
 	mt76x2_pci.o mt76x2_dma.o \
 	mt76x2_main.o mt76x2_init.o mt76x2_debugfs.o mt76x2_tx.o \
-	mt76x2_core.o mt76x2_mac.o mt76x2_eeprom.o mt76x2_mcu.o mt76x2_phy.o \
+	mt76x2_core.o mt76x2_mac.o mt76x2_mcu.o mt76x2_phy.o \
 	mt76x2_dfs.o mt76x2_trace.o
 
 CFLAGS_mt76x2_trace.o := -I$(src)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index 95d5f7d888f0..1753bcb36356 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -40,8 +40,7 @@ mt76x2_eeprom_get_macaddr(struct mt76x2_dev *dev)
 	return 0;
 }
 
-static void
-mt76x2_eeprom_parse_hw_cap(struct mt76x2_dev *dev)
+void mt76x2_eeprom_parse_hw_cap(struct mt76x2_dev *dev)
 {
 	u16 val = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_0);
 
@@ -58,6 +57,7 @@ mt76x2_eeprom_parse_hw_cap(struct mt76x2_dev *dev)
 		break;
 	}
 }
+EXPORT_SYMBOL_GPL(mt76x2_eeprom_parse_hw_cap);
 
 static int
 mt76x2_efuse_read(struct mt76x2_dev *dev, u16 addr, u8 *data)
@@ -415,6 +415,7 @@ void mt76x2_read_rx_gain(struct mt76x2_dev *dev)
 
 	dev->cal.rx.lna_gain = mt76x2_sign_extend(lna, 8);
 }
+EXPORT_SYMBOL_GPL(mt76x2_read_rx_gain);
 
 static s8
 mt76x2_rate_power_val(u8 val)
@@ -482,6 +483,7 @@ void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 		val >>= 8;
 	t->vht[8] = t->vht[9] = mt76x2_rate_power_val(val >> 8);
 }
+EXPORT_SYMBOL_GPL(mt76x2_get_rate_power);
 
 int mt76x2_get_max_rate_power(struct mt76_rate_power *r)
 {
@@ -493,6 +495,7 @@ int mt76x2_get_max_rate_power(struct mt76_rate_power *r)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(mt76x2_get_max_rate_power);
 
 static void
 mt76x2_get_power_info_2g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
@@ -600,6 +603,7 @@ void mt76x2_get_power_info(struct mt76x2_dev *dev,
 	t->delta_bw40 = mt76x2_rate_power_val(bw40);
 	t->delta_bw80 = mt76x2_rate_power_val(bw80);
 }
+EXPORT_SYMBOL_GPL(mt76x2_get_power_info);
 
 int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t)
 {
@@ -632,6 +636,7 @@ int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mt76x2_get_temp_comp);
 
 bool mt76x2_ext_pa_enabled(struct mt76x2_dev *dev, enum nl80211_band band)
 {
@@ -642,6 +647,7 @@ bool mt76x2_ext_pa_enabled(struct mt76x2_dev *dev, enum nl80211_band band)
 	else
 		return !(conf0 & MT_EE_NIC_CONF_0_PA_INT_2G);
 }
+EXPORT_SYMBOL_GPL(mt76x2_ext_pa_enabled);
 
 int mt76x2_eeprom_init(struct mt76x2_dev *dev)
 {
@@ -658,3 +664,6 @@ int mt76x2_eeprom_init(struct mt76x2_dev *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mt76x2_eeprom_init);
+
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
index aa0b0c040375..0f3e4d2f4fee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
@@ -155,6 +155,7 @@ void mt76x2_get_power_info(struct mt76x2_dev *dev,
 int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t);
 bool mt76x2_ext_pa_enabled(struct mt76x2_dev *dev, enum nl80211_band band);
 void mt76x2_read_rx_gain(struct mt76x2_dev *dev);
+void mt76x2_eeprom_parse_hw_cap(struct mt76x2_dev *dev);
 
 static inline bool
 mt76x2_temp_tx_alc_enabled(struct mt76x2_dev *dev)
-- 
2.17.1
