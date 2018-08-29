Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728317AbeH2PN1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 11:13:27 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v3 04/16] mt76: create new mt76x02-lib module for common  mt76x{0,2} code
Date: Wed, 29 Aug 2018 13:16:35 +0200
Message-Id: <1535541407-27149-5-git-send-email-sgruszka@redhat.com> (sfid-20180829_131706_200737_23614003)
In-Reply-To: <1535541407-27149-1-git-send-email-sgruszka@redhat.com>
References: <1535541407-27149-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move rxfilter and mutex to common structure. Create mt76x02-lib.ko
for mt76x0 and mt76x2 common functions and create new unified
mt76x02_configure_filter() function there.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Kconfig         |  6 ++
 drivers/net/wireless/mediatek/mt76/Makefile        |  3 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  1 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |  5 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  6 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 69 +++++-----------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  3 -
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 55 +++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h  | 25 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  5 --
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c | 42 ++-----------
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  5 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   | 37 ++++++------
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c  |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  | 25 ++++----
 16 files changed, 152 insertions(+), 141 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_util.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_util.h

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index b6c5f17dca30..6a270e759006 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -5,8 +5,13 @@ config MT76_USB
 	tristate
 	depends on MT76_CORE
 
+config MT76x02_LIB
+	tristate
+	depends on MT76_CORE
+
 config MT76x2_COMMON
 	tristate
+	select MT76x02_LIB
 	depends on MT76_CORE
 
 config MT76x0U
@@ -14,6 +19,7 @@ config MT76x0U
 	select MT76_CORE
 	depends on MAC80211
 	depends on USB
+	select MT76x02_LIB
 	help
 	  This adds support for MT7610U-based wireless USB dongles.
 
diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 158d10d2716c..7d95f141cd73 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_MT76_CORE) += mt76.o
 obj-$(CONFIG_MT76_USB) += mt76-usb.o
 obj-$(CONFIG_MT76x0U) += mt76x0/
+obj-$(CONFIG_MT76x02_LIB) += mt76x02-lib.o
 obj-$(CONFIG_MT76x2_COMMON) += mt76x2-common.o
 obj-$(CONFIG_MT76x2E) += mt76x2e.o
 obj-$(CONFIG_MT76x2U) += mt76x2u.o
@@ -13,6 +14,8 @@ mt76-usb-y := usb.o usb_trace.o usb_mcu.o
 CFLAGS_trace.o := -I$(src)
 CFLAGS_usb_trace.o := -I$(src)
 
+mt76x02-lib-y := mt76x02_util.o
+
 mt76x2-common-y := \
 	mt76x2_eeprom.o mt76x2_tx_common.o mt76x2_mac_common.o \
 	mt76x2_init_common.o mt76x2_common.o mt76x2_phy_common.o \
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 029d54bce9e8..df670d04f5a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -283,6 +283,7 @@ mt76_alloc_device(unsigned int size, const struct ieee80211_ops *ops)
 	spin_lock_init(&dev->rx_lock);
 	spin_lock_init(&dev->lock);
 	spin_lock_init(&dev->cc_lock);
+	mutex_init(&dev->mutex);
 	init_waitqueue_head(&dev->tx_wait);
 
 	return dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 2eab35879163..79017dbd364d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -317,6 +317,9 @@ struct mt76_dev {
 
 	spinlock_t lock;
 	spinlock_t cc_lock;
+
+	struct mutex mutex;
+
 	const struct mt76_bus_ops *bus;
 	const struct mt76_driver_ops *drv;
 	void __iomem *regs;
@@ -353,6 +356,8 @@ struct mt76_dev {
 	bool led_al;
 	u8 led_pin;
 
+	u32 rxfilter;
+
 	struct mt76_usb usb;
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index f23d1a04b35f..33924643946d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -290,14 +290,14 @@ int mt76x0_mac_start(struct mt76x0_dev *dev)
 		       MT_WPDMA_GLO_CFG_RX_DMA_BUSY, 0, 200000))
 		return -ETIMEDOUT;
 
-	dev->rxfilter = MT_RX_FILTR_CFG_CRC_ERR |
+	dev->mt76.rxfilter = MT_RX_FILTR_CFG_CRC_ERR |
 		MT_RX_FILTR_CFG_PHY_ERR | MT_RX_FILTR_CFG_PROMISC |
 		MT_RX_FILTR_CFG_VER_ERR | MT_RX_FILTR_CFG_DUP |
 		MT_RX_FILTR_CFG_CFACK | MT_RX_FILTR_CFG_CFEND |
 		MT_RX_FILTR_CFG_ACK | MT_RX_FILTR_CFG_CTS |
 		MT_RX_FILTR_CFG_RTS | MT_RX_FILTR_CFG_PSPOLL |
 		MT_RX_FILTR_CFG_BA | MT_RX_FILTR_CFG_CTRL_RSV;
-	mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+	mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
 
 	mt76_wr(dev, MT_MAC_SYS_CTRL,
 		   MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
@@ -495,7 +495,7 @@ struct mt76x0_dev *mt76x0_alloc_device(struct device *pdev)
 	mutex_init(&dev->usb_ctrl_mtx);
 	mutex_init(&dev->reg_atomic_mutex);
 	mutex_init(&dev->hw_atomic_mutex);
-	mutex_init(&dev->mutex);
+	mutex_init(&dev->mt76.mutex);
 	spin_lock_init(&dev->tx_lock);
 	spin_lock_init(&dev->rx_lock);
 	spin_lock_init(&dev->mt76.lock);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 46e458835e58..8fc270b94819 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -15,6 +15,7 @@
 
 #include "mt76x0.h"
 #include "mac.h"
+#include "../mt76x02_util.h"
 #include <linux/etherdevice.h>
 
 static int mt76x0_start(struct ieee80211_hw *hw)
@@ -22,7 +23,7 @@ static int mt76x0_start(struct ieee80211_hw *hw)
 	struct mt76x0_dev *dev = hw->priv;
 	int ret;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 
 	ret = mt76x0_mac_start(dev);
 	if (ret)
@@ -33,7 +34,7 @@ static int mt76x0_start(struct ieee80211_hw *hw)
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
 out:
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 	return ret;
 }
 
@@ -41,13 +42,13 @@ static void mt76x0_stop(struct ieee80211_hw *hw)
 {
 	struct mt76x0_dev *dev = hw->priv;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 
 	cancel_delayed_work_sync(&dev->cal_work);
 	cancel_delayed_work_sync(&dev->mac_work);
 	mt76x0_mac_stop(dev);
 
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 
@@ -87,16 +88,7 @@ static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 	struct mt76x0_dev *dev = hw->priv;
 	int ret = 0;
 
-	mutex_lock(&dev->mutex);
-
-	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
-		if (!(hw->conf.flags & IEEE80211_CONF_MONITOR))
-			dev->rxfilter |= MT_RX_FILTR_CFG_PROMISC;
-		else
-			dev->rxfilter &= ~MT_RX_FILTR_CFG_PROMISC;
-
-		mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
-	}
+	mutex_lock(&dev->mt76.mutex);
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		ieee80211_stop_queues(hw);
@@ -104,51 +96,18 @@ static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 		ieee80211_wake_queues(hw);
 	}
 
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return ret;
 }
 
 static void
-mt76_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
-		      unsigned int *total_flags, u64 multicast)
-{
-	struct mt76x0_dev *dev = hw->priv;
-	u32 flags = 0;
-
-#define MT76_FILTER(_flag, _hw) do { \
-		flags |= *total_flags & FIF_##_flag;			\
-		dev->rxfilter &= ~(_hw);				\
-		dev->rxfilter |= !(flags & FIF_##_flag) * (_hw);	\
-	} while (0)
-
-	mutex_lock(&dev->mutex);
-
-	dev->rxfilter &= ~MT_RX_FILTR_CFG_OTHER_BSS;
-
-	MT76_FILTER(FCSFAIL, MT_RX_FILTR_CFG_CRC_ERR);
-	MT76_FILTER(PLCPFAIL, MT_RX_FILTR_CFG_PHY_ERR);
-	MT76_FILTER(CONTROL, MT_RX_FILTR_CFG_ACK |
-			     MT_RX_FILTR_CFG_CTS |
-			     MT_RX_FILTR_CFG_CFEND |
-			     MT_RX_FILTR_CFG_CFACK |
-			     MT_RX_FILTR_CFG_BA |
-			     MT_RX_FILTR_CFG_CTRL_RSV);
-	MT76_FILTER(PSPOLL, MT_RX_FILTR_CFG_PSPOLL);
-
-	*total_flags = flags;
-	mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
-
-	mutex_unlock(&dev->mutex);
-}
-
-static void
 mt76x0_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 struct ieee80211_bss_conf *info, u32 changed)
 {
 	struct mt76x0_dev *dev = hw->priv;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 
 	if (changed & BSS_CHANGED_ASSOC)
 		mt76x0_phy_con_cal_onoff(dev, info);
@@ -192,7 +151,7 @@ mt76x0_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (changed & BSS_CHANGED_ASSOC)
 		mt76x0_phy_recalibrate_after_assoc(dev);
 
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 static int
@@ -205,7 +164,7 @@ mt76x0_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	int ret = 0;
 	int idx = 0;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 
 	idx = mt76_wcid_alloc(dev->wcid_mask, ARRAY_SIZE(dev->wcid));
 	if (idx < 0) {
@@ -221,7 +180,7 @@ mt76x0_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mt76x0_mac_set_ampdu_factor(dev);
 
 out:
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return ret;
 }
@@ -234,13 +193,13 @@ mt76x0_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct mt76_sta *msta = (struct mt76_sta *) sta->drv_priv;
 	int idx = msta->wcid.idx;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 	rcu_assign_pointer(dev->wcid[idx], NULL);
 	mt76_set(dev, MT_WCID_DROP(idx), MT_WCID_DROP_MASK(idx));
 	dev->wcid_mask[idx / BITS_PER_LONG] &= ~BIT(idx % BITS_PER_LONG);
 	mt76x0_mac_wcid_setup(dev, idx, 0, NULL);
 	mt76x0_mac_set_ampdu_factor(dev);
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
@@ -388,7 +347,7 @@ const struct ieee80211_ops mt76x0_ops = {
 	.add_interface = mt76x0_add_interface,
 	.remove_interface = mt76x0_remove_interface,
 	.config = mt76x0_config,
-	.configure_filter = mt76_configure_filter,
+	.configure_filter = mt76x02_configure_filter,
 	.bss_info_changed = mt76x0_bss_info_changed,
 	.sta_add = mt76x0_sta_add,
 	.sta_remove = mt76x0_sta_remove,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 6c52f73c1b94..967b262495e7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -147,8 +147,6 @@ enum mt_bw {
 struct mt76x0_dev {
 	struct mt76_dev mt76; /* must be first */
 
-	struct mutex mutex;
-
 	struct mutex usb_ctrl_mtx;
 	u8 data[32];
 
@@ -184,7 +182,6 @@ struct mt76x0_dev {
 	struct mutex reg_atomic_mutex;
 	struct mutex hw_atomic_mutex;
 
-	u32 rxfilter;
 	u32 debugfs_reg;
 
 	/* TX */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
new file mode 100644
index 000000000000..971e2d9f9ca3
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -0,0 +1,55 @@
+/*
+ * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "mt76.h"
+#include "mt76x02_regs.h"
+
+void mt76x02_configure_filter(struct ieee80211_hw *hw,
+			     unsigned int changed_flags,
+			     unsigned int *total_flags, u64 multicast)
+{
+	struct mt76_dev *dev = hw->priv;
+	u32 flags = 0;
+
+#define MT76_FILTER(_flag, _hw) do { \
+		flags |= *total_flags & FIF_##_flag;			\
+		dev->rxfilter &= ~(_hw);				\
+		dev->rxfilter |= !(flags & FIF_##_flag) * (_hw);	\
+	} while (0)
+
+	mutex_lock(&dev->mutex);
+
+	dev->rxfilter &= ~MT_RX_FILTR_CFG_OTHER_BSS;
+
+	MT76_FILTER(FCSFAIL, MT_RX_FILTR_CFG_CRC_ERR);
+	MT76_FILTER(PLCPFAIL, MT_RX_FILTR_CFG_PHY_ERR);
+	MT76_FILTER(CONTROL, MT_RX_FILTR_CFG_ACK |
+			     MT_RX_FILTR_CFG_CTS |
+			     MT_RX_FILTR_CFG_CFEND |
+			     MT_RX_FILTR_CFG_CFACK |
+			     MT_RX_FILTR_CFG_BA |
+			     MT_RX_FILTR_CFG_CTRL_RSV);
+	MT76_FILTER(PSPOLL, MT_RX_FILTR_CFG_PSPOLL);
+
+	*total_flags = flags;
+	dev->bus->wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+
+	mutex_unlock(&dev->mutex);
+}
+EXPORT_SYMBOL_GPL(mt76x02_configure_filter);
+
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
new file mode 100644
index 000000000000..7ff3d473bc75
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __MT76X02_UTIL_H
+#define __MT76X02_UTIL_H
+
+void mt76x02_configure_filter(struct ieee80211_hw *hw,
+			     unsigned int changed_flags,
+			     unsigned int *total_flags, u64 multicast);
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 8b5c3de9ea32..e9b57fce9685 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -131,8 +131,6 @@ struct mt76x2_dev {
 
 	u16 chainmask;
 
-	u32 rxfilter;
-
 	struct mt76x2_calibration cal;
 
 	s8 target_power;
@@ -293,9 +291,6 @@ int mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		   struct ieee80211_key_conf *key);
 int mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   u16 queue, const struct ieee80211_tx_queue_params *params);
-void mt76x2_configure_filter(struct ieee80211_hw *hw,
-			     unsigned int changed_flags,
-			     unsigned int *total_flags, u64 multicast);
 void mt76x2_txq_init(struct mt76x2_dev *dev, struct ieee80211_txq *txq);
 void mt76x2_sta_rate_tbl_update(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index a2338ba139b4..fe0b394fd9ea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -102,7 +102,7 @@ int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	int idx = 0;
 	int i;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 
 	idx = mt76_wcid_alloc(dev->wcid_mask, ARRAY_SIZE(dev->wcid));
 	if (idx < 0) {
@@ -127,7 +127,7 @@ int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	rcu_assign_pointer(dev->wcid[idx], &msta->wcid);
 
 out:
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return ret;
 }
@@ -141,14 +141,14 @@ int mt76x2_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	int idx = msta->wcid.idx;
 	int i;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 	rcu_assign_pointer(dev->wcid[idx], NULL);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		mt76_txq_remove(&dev->mt76, sta->txq[i]);
 	mt76x2_mac_wcid_set_drop(dev, idx, true);
 	mt76_wcid_free(dev->wcid_mask, idx);
 	mt76x2_mac_wcid_setup(dev, idx, 0, NULL);
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
@@ -274,40 +274,6 @@ int mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x2_conf_tx);
 
-void mt76x2_configure_filter(struct ieee80211_hw *hw,
-			     unsigned int changed_flags,
-			     unsigned int *total_flags, u64 multicast)
-{
-	struct mt76x2_dev *dev = hw->priv;
-	u32 flags = 0;
-
-#define MT76_FILTER(_flag, _hw) do { \
-		flags |= *total_flags & FIF_##_flag;			\
-		dev->rxfilter &= ~(_hw);				\
-		dev->rxfilter |= !(flags & FIF_##_flag) * (_hw);	\
-	} while (0)
-
-	mutex_lock(&dev->mutex);
-
-	dev->rxfilter &= ~MT_RX_FILTR_CFG_OTHER_BSS;
-
-	MT76_FILTER(FCSFAIL, MT_RX_FILTR_CFG_CRC_ERR);
-	MT76_FILTER(PLCPFAIL, MT_RX_FILTR_CFG_PHY_ERR);
-	MT76_FILTER(CONTROL, MT_RX_FILTR_CFG_ACK |
-			     MT_RX_FILTR_CFG_CTS |
-			     MT_RX_FILTR_CFG_CFEND |
-			     MT_RX_FILTR_CFG_CFACK |
-			     MT_RX_FILTR_CFG_BA |
-			     MT_RX_FILTR_CFG_CTRL_RSV);
-	MT76_FILTER(PSPOLL, MT_RX_FILTR_CFG_PSPOLL);
-
-	*total_flags = flags;
-	mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
-
-	mutex_unlock(&dev->mutex);
-}
-EXPORT_SYMBOL_GPL(mt76x2_configure_filter);
-
 void mt76x2_sta_rate_tbl_update(struct ieee80211_hw *hw,
 				struct ieee80211_vif *vif,
 				struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 75a4e171da6d..07ef0a368f1e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -214,7 +214,7 @@ int mt76x2_mac_start(struct mt76x2_dev *dev)
 
 	mt76_clear(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE);
 
-	mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+	mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
 
 	mt76_wr(dev, MT_MAC_SYS_CTRL,
 		MT_MAC_SYS_CTRL_ENABLE_TX |
@@ -377,7 +377,7 @@ int mt76x2_init_hardware(struct mt76x2_dev *dev)
 	if (ret)
 		return ret;
 
-	dev->rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
+	dev->mt76.rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
 
 	ret = mt76x2_dma_init(dev);
 	if (ret)
@@ -435,7 +435,6 @@ struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
 	dev = container_of(mdev, struct mt76x2_dev, mt76);
 	mdev->dev = pdev;
 	mdev->drv = &drv_ops;
-	mutex_init(&dev->mutex);
 	spin_lock_init(&dev->irq_lock);
 
 	return dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 680a89f8aa87..577c6ee39fb8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -15,6 +15,7 @@
  */
 
 #include "mt76x2.h"
+#include "mt76x02_util.h"
 
 static int
 mt76x2_start(struct ieee80211_hw *hw)
@@ -22,7 +23,7 @@ mt76x2_start(struct ieee80211_hw *hw)
 	struct mt76x2_dev *dev = hw->priv;
 	int ret;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 
 	ret = mt76x2_mac_start(dev);
 	if (ret)
@@ -38,7 +39,7 @@ mt76x2_start(struct ieee80211_hw *hw)
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 
 out:
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 	return ret;
 }
 
@@ -47,10 +48,10 @@ mt76x2_stop(struct ieee80211_hw *hw)
 {
 	struct mt76x2_dev *dev = hw->priv;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 	mt76x2_stop_hardware(dev);
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 static int
@@ -127,15 +128,15 @@ mt76x2_config(struct ieee80211_hw *hw, u32 changed)
 	struct mt76x2_dev *dev = hw->priv;
 	int ret = 0;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
 		if (!(hw->conf.flags & IEEE80211_CONF_MONITOR))
-			dev->rxfilter |= MT_RX_FILTR_CFG_PROMISC;
+			dev->mt76.rxfilter |= MT_RX_FILTR_CFG_PROMISC;
 		else
-			dev->rxfilter &= ~MT_RX_FILTR_CFG_PROMISC;
+			dev->mt76.rxfilter &= ~MT_RX_FILTR_CFG_PROMISC;
 
-		mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+		mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
@@ -156,7 +157,7 @@ mt76x2_config(struct ieee80211_hw *hw, u32 changed)
 		ieee80211_wake_queues(hw);
 	}
 
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return ret;
 }
@@ -168,7 +169,7 @@ mt76x2_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct mt76x2_dev *dev = hw->priv;
 	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 
 	if (changed & BSS_CHANGED_BSSID)
 		mt76x2_mac_set_bssid(dev, mvif->idx, info->bssid);
@@ -195,7 +196,7 @@ mt76x2_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		mt76x2_set_tx_ackto(dev);
 	}
 
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 void
@@ -252,10 +253,10 @@ static void mt76x2_set_coverage_class(struct ieee80211_hw *hw,
 {
 	struct mt76x2_dev *dev = hw->priv;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 	dev->coverage_class = coverage_class;
 	mt76x2_set_tx_ackto(dev);
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 static int
@@ -272,7 +273,7 @@ static int mt76x2_set_antenna(struct ieee80211_hw *hw, u32 tx_ant,
 	if (!tx_ant || tx_ant > 3 || tx_ant != rx_ant)
 		return -EINVAL;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 
 	dev->chainmask = (tx_ant == 3) ? 0x202 : 0x101;
 	dev->mt76.antenna_mask = tx_ant;
@@ -280,7 +281,7 @@ static int mt76x2_set_antenna(struct ieee80211_hw *hw, u32 tx_ant,
 	mt76_set_stream_caps(&dev->mt76, true);
 	mt76x2_phy_set_antenna(dev);
 
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
@@ -290,10 +291,10 @@ static int mt76x2_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant,
 {
 	struct mt76x2_dev *dev = hw->priv;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 	*tx_ant = dev->mt76.antenna_mask;
 	*rx_ant = dev->mt76.antenna_mask;
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
@@ -320,7 +321,7 @@ const struct ieee80211_ops mt76x2_ops = {
 	.add_interface = mt76x2_add_interface,
 	.remove_interface = mt76x2_remove_interface,
 	.config = mt76x2_config,
-	.configure_filter = mt76x2_configure_filter,
+	.configure_filter = mt76x02_configure_filter,
 	.bss_info_changed = mt76x2_bss_info_changed,
 	.sta_add = mt76x2_sta_add,
 	.sta_remove = mt76x2_sta_remove,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
index 276e30608cea..709e37de3b3f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
@@ -151,8 +151,6 @@ struct mt76x2_dev *mt76x2u_alloc_device(struct device *pdev)
 	mdev->dev = pdev;
 	mdev->drv = &drv_ops;
 
-	mutex_init(&dev->mutex);
-
 	return dev;
 }
 
@@ -214,7 +212,7 @@ int mt76x2u_init_hardware(struct mt76x2_dev *dev)
 		return err;
 
 	mt76x2u_mac_setaddr(dev, dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
-	dev->rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
+	dev->mt76.rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
 
 	mt76x2u_init_beacon_offsets(dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
index eab7ab297aa6..9604c6a809be 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
@@ -122,7 +122,7 @@ int mt76x2u_mac_start(struct mt76x2_dev *dev)
 	wait_for_wpdma(dev);
 	usleep_range(50, 100);
 
-	mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+	mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
 
 	mt76_wr(dev, MT_MAC_SYS_CTRL,
 		MT_MAC_SYS_CTRL_ENABLE_TX |
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
index 7367ba111119..9180debc0946 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
@@ -15,13 +15,14 @@
  */
 
 #include "mt76x2u.h"
+#include "mt76x02_util.h"
 
 static int mt76x2u_start(struct ieee80211_hw *hw)
 {
 	struct mt76x2_dev *dev = hw->priv;
 	int ret;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 
 	ret = mt76x2u_mac_start(dev);
 	if (ret)
@@ -30,7 +31,7 @@ static int mt76x2u_start(struct ieee80211_hw *hw)
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 
 out:
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 	return ret;
 }
 
@@ -38,10 +39,10 @@ static void mt76x2u_stop(struct ieee80211_hw *hw)
 {
 	struct mt76x2_dev *dev = hw->priv;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 	mt76x2u_stop_hw(dev);
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 static int mt76x2u_add_interface(struct ieee80211_hw *hw,
@@ -93,7 +94,7 @@ mt76x2u_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct mt76x2_dev *dev = hw->priv;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 
 	if (changed & BSS_CHANGED_ASSOC) {
 		mt76x2u_phy_channel_calibrate(dev);
@@ -107,7 +108,7 @@ mt76x2u_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			get_unaligned_le16(info->bssid + 4));
 	}
 
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 static int
@@ -116,14 +117,14 @@ mt76x2u_config(struct ieee80211_hw *hw, u32 changed)
 	struct mt76x2_dev *dev = hw->priv;
 	int err = 0;
 
-	mutex_lock(&dev->mutex);
+	mutex_lock(&dev->mt76.mutex);
 
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
 		if (!(hw->conf.flags & IEEE80211_CONF_MONITOR))
-			dev->rxfilter |= MT_RX_FILTR_CFG_PROMISC;
+			dev->mt76.rxfilter |= MT_RX_FILTR_CFG_PROMISC;
 		else
-			dev->rxfilter &= ~MT_RX_FILTR_CFG_PROMISC;
-		mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+			dev->mt76.rxfilter &= ~MT_RX_FILTR_CFG_PROMISC;
+		mt76_wr(dev, MT_RX_FILTR_CFG, dev->mt76.rxfilter);
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
@@ -142,7 +143,7 @@ mt76x2u_config(struct ieee80211_hw *hw, u32 changed)
 			mt76x2_phy_set_txpower(dev);
 	}
 
-	mutex_unlock(&dev->mutex);
+	mutex_unlock(&dev->mt76.mutex);
 
 	return err;
 }
@@ -177,7 +178,7 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.config = mt76x2u_config,
 	.wake_tx_queue = mt76_wake_tx_queue,
 	.bss_info_changed = mt76x2u_bss_info_changed,
-	.configure_filter = mt76x2_configure_filter,
+	.configure_filter = mt76x02_configure_filter,
 	.conf_tx = mt76x2_conf_tx,
 	.sw_scan_start = mt76x2u_sw_scan,
 	.sw_scan_complete = mt76x2u_sw_scan_complete,
-- 
2.7.5
