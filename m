Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57524 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932286AbcIEJvc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2016 05:51:32 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH v3 3/3] mt76: add driver code for MT76x2e
Date: Mon,  5 Sep 2016 11:51:28 +0200
Message-Id: <20160905095128.80560-4-nbd@nbd.name> (sfid-20160905_115141_432052_CC4A71A0)
In-Reply-To: <20160905095128.80560-1-nbd@nbd.name>
References: <20160905095128.80560-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

This is a 2x2 PCIe 802.11ac chipset by MediaTek

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/Kconfig              |   1 +
 drivers/net/wireless/mediatek/Makefile             |   1 +
 drivers/net/wireless/mediatek/mt76/Kconfig         |  10 +
 drivers/net/wireless/mediatek/mt76/Makefile        |  15 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h        | 220 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_core.c   |  83 +++
 .../net/wireless/mediatek/mt76/mt76x2_debugfs.c    | 101 +++
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c    | 184 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.h    |  68 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c | 644 +++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h | 181 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   | 765 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    | 738 ++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    | 189 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   | 532 ++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c    | 452 ++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h    | 136 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c    | 109 +++
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c    | 688 ++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h   | 564 +++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_trace.c  |  23 +
 drivers/net/wireless/mediatek/mt76/mt76x2_trace.h  | 144 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     | 262 +++++++
 23 files changed, 6110 insertions(+)
 create mode 100644 drivers/net/wireless/mediatek/mt76/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_core.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_dma.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_trace.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c

diff --git a/drivers/net/wireless/mediatek/Kconfig b/drivers/net/wireless/mediatek/Kconfig
index 28843fe..92ce406 100644
--- a/drivers/net/wireless/mediatek/Kconfig
+++ b/drivers/net/wireless/mediatek/Kconfig
@@ -11,4 +11,5 @@ config WLAN_VENDOR_MEDIATEK
 
 if WLAN_VENDOR_MEDIATEK
 source "drivers/net/wireless/mediatek/mt7601u/Kconfig"
+source "drivers/net/wireless/mediatek/mt76/Kconfig"
 endif # WLAN_VENDOR_MEDIATEK
diff --git a/drivers/net/wireless/mediatek/Makefile b/drivers/net/wireless/mediatek/Makefile
index 9d5f182..00f945f 100644
--- a/drivers/net/wireless/mediatek/Makefile
+++ b/drivers/net/wireless/mediatek/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_MT7601U)	+= mt7601u/
+obj-$(CONFIG_MT76_CORE)	+= mt76/
diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
new file mode 100644
index 0000000..fc05d79
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -0,0 +1,10 @@
+config MT76_CORE
+	tristate
+
+config MT76x2E
+	tristate "MediaTek MT76x2E (PCIe) support"
+	select MT76_CORE
+	depends on MAC80211
+	depends on PCI
+	---help---
+	  This adds support for MT7612/MT7602/MT7662-based wireless PCIe devices.
diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
new file mode 100644
index 0000000..2d1fad1
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -0,0 +1,15 @@
+obj-$(CONFIG_MT76_CORE) += mt76.o
+obj-$(CONFIG_MT76x2E) += mt76x2e.o
+
+mt76-y := \
+	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o tx.o
+
+CFLAGS_trace.o := -I$(src)
+
+mt76x2e-y := \
+	mt76x2_pci.o mt76x2_dma.o \
+	mt76x2_main.o mt76x2_init.o mt76x2_debugfs.o mt76x2_tx.o \
+	mt76x2_core.o mt76x2_mac.o mt76x2_eeprom.o mt76x2_mcu.o mt76x2_phy.o \
+	mt76x2_trace.o
+
+CFLAGS_mt76x2_trace.o := -I$(src)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
new file mode 100644
index 0000000..9440599
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -0,0 +1,220 @@
+/*
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
+#ifndef __MT76x2_H
+#define __MT76x2_H
+
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/mutex.h>
+#include <linux/bitops.h>
+#include <linux/kfifo.h>
+
+#define MT7662_FIRMWARE		"mt7662.bin"
+#define MT7662_ROM_PATCH	"mt7662_rom_patch.bin"
+#define MT7662_EEPROM_SIZE	512
+
+#define MT_RX_HEADROOM		32
+
+#define MT_MAX_CHAINS		2
+
+#define MT_CALIBRATE_INTERVAL	HZ
+
+#include "mt76.h"
+#include "mt76x2_regs.h"
+#include "mt76x2_mac.h"
+
+struct mt76x2_mcu {
+	struct mutex mutex;
+
+	wait_queue_head_t wait;
+	struct sk_buff_head res_q;
+
+	u32 msg_seq;
+};
+
+struct mt76x2_rx_freq_cal {
+	s8 high_gain[MT_MAX_CHAINS];
+	s8 rssi_offset[MT_MAX_CHAINS];
+	s8 lna_gain;
+	u32 mcu_gain;
+};
+
+struct mt76x2_calibration {
+	struct mt76x2_rx_freq_cal rx;
+
+	u8 agc_gain_init[MT_MAX_CHAINS];
+	int avg_rssi[MT_MAX_CHAINS];
+	int avg_rssi_all;
+
+	s8 low_gain;
+
+	u8 temp;
+
+	bool init_cal_done;
+	bool tssi_cal_done;
+	bool tssi_comp_pending;
+	bool dpd_cal_done;
+	bool channel_cal_done;
+};
+
+struct mt76x2_dev {
+	struct mt76_dev mt76; /* must be first */
+
+	struct mac_address macaddr_list[8];
+
+	struct mutex mutex;
+
+	const u16 *beacon_offsets;
+	unsigned long wcid_mask[256 / BITS_PER_LONG];
+
+	int txpower_conf;
+	int txpower_cur;
+
+	u8 txdone_seq;
+	DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x2_tx_status);
+
+	struct mt76x2_mcu mcu;
+	struct sk_buff *rx_head;
+
+	struct tasklet_struct tx_tasklet;
+	struct tasklet_struct pre_tbtt_tasklet;
+	struct delayed_work cal_work;
+	struct delayed_work mac_work;
+
+	u32 aggr_stats[32];
+
+	struct mt76_wcid global_wcid;
+	struct mt76_wcid __rcu *wcid[254 - 8];
+
+	spinlock_t irq_lock;
+	u32 irqmask;
+
+	struct sk_buff *beacons[8];
+	u8 beacon_mask;
+	u8 beacon_data_mask;
+
+	u32 rev;
+	u32 rxfilter;
+
+	u16 chainmask;
+
+	struct mt76x2_calibration cal;
+
+	s8 target_power;
+	s8 target_power_delta[2];
+	struct mt76_rate_power rate_power;
+	bool enable_tpc;
+
+	u8 coverage_class;
+	u8 slottime;
+};
+
+struct mt76x2_vif {
+	u8 idx;
+
+	struct mt76_wcid group_wcid;
+};
+
+struct mt76x2_sta {
+	struct mt76_wcid wcid; /* must be first */
+
+	struct mt76x2_tx_status status;
+	int n_frames;
+};
+
+static inline bool is_mt7612(struct mt76x2_dev *dev)
+{
+	return (dev->rev >> 16) == 0x7612;
+}
+
+void mt76x2_set_irq_mask(struct mt76x2_dev *dev, u32 clear, u32 set);
+
+static inline void mt76x2_irq_enable(struct mt76x2_dev *dev, u32 mask)
+{
+	mt76x2_set_irq_mask(dev, 0, mask);
+}
+
+static inline void mt76x2_irq_disable(struct mt76x2_dev *dev, u32 mask)
+{
+	mt76x2_set_irq_mask(dev, mask, 0);
+}
+
+extern const struct ieee80211_ops mt76x2_ops;
+
+struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev);
+int mt76x2_register_device(struct mt76x2_dev *dev);
+void mt76x2_init_debugfs(struct mt76x2_dev *dev);
+
+irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance);
+void mt76x2_phy_power_on(struct mt76x2_dev *dev);
+int mt76x2_init_hardware(struct mt76x2_dev *dev);
+void mt76x2_stop_hardware(struct mt76x2_dev *dev);
+int mt76x2_eeprom_init(struct mt76x2_dev *dev);
+int mt76x2_apply_calibration_data(struct mt76x2_dev *dev, int channel);
+void mt76x2_set_tx_ackto(struct mt76x2_dev *dev);
+
+int mt76x2_phy_start(struct mt76x2_dev *dev);
+int mt76x2_phy_set_channel(struct mt76x2_dev *dev,
+			 struct cfg80211_chan_def *chandef);
+int mt76x2_phy_get_rssi(struct mt76x2_dev *dev, s8 rssi, int chain);
+void mt76x2_phy_calibrate(struct work_struct *work);
+void mt76x2_phy_set_txpower(struct mt76x2_dev *dev);
+
+int mt76x2_mcu_init(struct mt76x2_dev *dev);
+int mt76x2_mcu_set_channel(struct mt76x2_dev *dev, u8 channel, u8 bw,
+			   u8 bw_index, bool scan);
+int mt76x2_mcu_set_radio_state(struct mt76x2_dev *dev, bool on);
+int mt76x2_mcu_load_cr(struct mt76x2_dev *dev, u8 type, u8 temp_level,
+		       u8 channel);
+int mt76x2_mcu_cleanup(struct mt76x2_dev *dev);
+
+int mt76x2_dma_init(struct mt76x2_dev *dev);
+void mt76x2_dma_cleanup(struct mt76x2_dev *dev);
+
+void mt76x2_cleanup(struct mt76x2_dev *dev);
+
+int mt76x2_tx_queue_mcu(struct mt76x2_dev *dev, enum mt76_txq_id qid,
+			struct sk_buff *skb, int cmd, int seq);
+void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
+	       struct sk_buff *skb);
+void mt76x2_tx_complete(struct mt76x2_dev *dev, struct sk_buff *skb);
+int mt76x2_tx_prepare_skb(struct mt76_dev *dev, void *txwi_ptr,
+			  struct sk_buff *skb, struct mt76_queue *q,
+			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			  u32 *tx_info);
+void mt76x2_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
+			    struct mt76_queue_entry *e, bool flush);
+
+void mt76x2_pre_tbtt_tasklet(unsigned long data);
+
+void mt76x2_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q);
+void mt76x2_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
+			 struct sk_buff *skb);
+
+void mt76x2_update_channel(struct mt76_dev *dev);
+
+s8 mt76x2_tx_get_max_txpwr_adj(struct mt76x2_dev *dev,
+			       const struct ieee80211_tx_rate *rate);
+s8 mt76x2_tx_get_txpwr_adj(struct mt76x2_dev *dev, s8 txpwr, s8 max_txpwr_adj);
+void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr);
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2_core.c
new file mode 100644
index 0000000..3449e16
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_core.c
@@ -0,0 +1,83 @@
+/*
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
+#include <linux/delay.h>
+#include "mt76x2.h"
+#include "mt76x2_trace.h"
+
+void mt76x2_set_irq_mask(struct mt76x2_dev *dev, u32 clear, u32 set)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->irq_lock, flags);
+	dev->irqmask &= ~clear;
+	dev->irqmask |= set;
+	mt76_wr(dev, MT_INT_MASK_CSR, dev->irqmask);
+	spin_unlock_irqrestore(&dev->irq_lock, flags);
+}
+
+void mt76x2_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
+{
+	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+
+	mt76x2_irq_enable(dev, MT_INT_RX_DONE(q));
+}
+
+irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance)
+{
+	struct mt76x2_dev *dev = dev_instance;
+	u32 intr;
+
+	intr = mt76_rr(dev, MT_INT_SOURCE_CSR);
+	mt76_wr(dev, MT_INT_SOURCE_CSR, intr);
+
+	if (!test_bit(MT76_STATE_INITIALIZED, &dev->mt76.state))
+		return IRQ_NONE;
+
+	trace_dev_irq(dev, intr, dev->irqmask);
+
+	intr &= dev->irqmask;
+
+	if (intr & MT_INT_TX_DONE_ALL) {
+		mt76x2_irq_disable(dev, MT_INT_TX_DONE_ALL);
+		tasklet_schedule(&dev->tx_tasklet);
+	}
+
+	if (intr & MT_INT_RX_DONE(0)) {
+		mt76x2_irq_disable(dev, MT_INT_RX_DONE(0));
+		napi_schedule(&dev->mt76.napi[0]);
+	}
+
+	if (intr & MT_INT_RX_DONE(1)) {
+		mt76x2_irq_disable(dev, MT_INT_RX_DONE(1));
+		napi_schedule(&dev->mt76.napi[1]);
+	}
+
+	if (intr & MT_INT_PRE_TBTT)
+		tasklet_schedule(&dev->pre_tbtt_tasklet);
+
+	/* send buffered multicast frames now */
+	if (intr & MT_INT_TBTT)
+		mt76_queue_kick(dev, &dev->mt76.q_tx[MT_TXQ_PSD]);
+
+	if (intr & MT_INT_TX_STAT) {
+		mt76x2_mac_poll_tx_status(dev, true);
+		tasklet_schedule(&dev->tx_tasklet);
+	}
+
+	return IRQ_HANDLED;
+}
+
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
new file mode 100644
index 0000000..0239636
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
@@ -0,0 +1,101 @@
+/*
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
+#include <linux/debugfs.h>
+#include "mt76x2.h"
+
+static int
+mt76x2_ampdu_stat_read(struct seq_file *file, void *data)
+{
+	struct mt76x2_dev *dev = file->private;
+	int i, j;
+
+	for (i = 0; i < 4; i++) {
+		seq_puts(file, "Length: ");
+		for (j = 0; j < 8; j++)
+			seq_printf(file, "%8d | ", i * 8 + j + 1);
+		seq_puts(file, "\n");
+		seq_puts(file, "Count:  ");
+		for (j = 0; j < 8; j++)
+			seq_printf(file, "%8d | ", dev->aggr_stats[i * 8 + j]);
+		seq_puts(file, "\n");
+		seq_puts(file, "--------");
+		for (j = 0; j < 8; j++)
+			seq_puts(file, "-----------");
+		seq_puts(file, "\n");
+	}
+
+	return 0;
+}
+
+static int
+mt76x2_ampdu_stat_open(struct inode *inode, struct file *f)
+{
+	return single_open(f, mt76x2_ampdu_stat_read, inode->i_private);
+}
+
+static void
+seq_puts_array(struct seq_file *file, const char *str, s8 *val, int len)
+{
+	int i;
+
+	seq_printf(file, "%10s:", str);
+	for (i = 0; i < len; i++)
+		seq_printf(file, " %2d", val[i]);
+	seq_puts(file, "\n");
+}
+
+static int read_txpower(struct seq_file *file, void *data)
+{
+	struct mt76x2_dev *dev = dev_get_drvdata(file->private);
+
+	seq_printf(file, "Target power: %d\n", dev->target_power);
+
+	seq_puts_array(file, "Delta", dev->target_power_delta,
+		       ARRAY_SIZE(dev->target_power_delta));
+	seq_puts_array(file, "CCK", dev->rate_power.cck,
+		       ARRAY_SIZE(dev->rate_power.cck));
+	seq_puts_array(file, "OFDM", dev->rate_power.ofdm,
+		       ARRAY_SIZE(dev->rate_power.ofdm));
+	seq_puts_array(file, "HT", dev->rate_power.ht,
+		       ARRAY_SIZE(dev->rate_power.ht));
+	seq_puts_array(file, "VHT", dev->rate_power.vht,
+		       ARRAY_SIZE(dev->rate_power.vht));
+	return 0;
+}
+
+static const struct file_operations fops_ampdu_stat = {
+	.open = mt76x2_ampdu_stat_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+void mt76x2_init_debugfs(struct mt76x2_dev *dev)
+{
+	struct dentry *dir;
+
+	dir = mt76_register_debugfs(&dev->mt76);
+	if (!dir)
+		return;
+
+	debugfs_create_u8("temperature", S_IRUSR, dir, &dev->cal.temp);
+	debugfs_create_bool("tpc", S_IRUSR | S_IWUSR, dir, &dev->enable_tpc);
+
+	debugfs_create_file("ampdu_stat", S_IRUSR, dir, dev, &fops_ampdu_stat);
+	debugfs_create_devm_seqfile(dev->mt76.dev, "txpower", dir,
+				    read_txpower);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
new file mode 100644
index 0000000..06e027a
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
@@ -0,0 +1,184 @@
+/*
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
+#include "mt76x2.h"
+#include "mt76x2_dma.h"
+
+int
+mt76x2_tx_queue_mcu(struct mt76x2_dev *dev, enum mt76_txq_id qid,
+		    struct sk_buff *skb, int cmd, int seq)
+{
+	struct mt76_queue *q = &dev->mt76.q_tx[qid];
+	struct mt76_queue_buf buf;
+	dma_addr_t addr;
+	u32 tx_info;
+	int idx;
+
+	tx_info = MT_MCU_MSG_TYPE_CMD |
+		  FIELD_PREP(MT_MCU_MSG_CMD_TYPE, cmd) |
+		  FIELD_PREP(MT_MCU_MSG_CMD_SEQ, seq) |
+		  FIELD_PREP(MT_MCU_MSG_PORT, CPU_TX_PORT) |
+		  FIELD_PREP(MT_MCU_MSG_LEN, skb->len);
+
+	addr = dma_map_single(dev->mt76.dev, skb->data, skb->len,
+			      DMA_TO_DEVICE);
+	if (dma_mapping_error(dev->mt76.dev, addr))
+		return -ENOMEM;
+
+	buf.addr = addr;
+	buf.len = skb->len;
+	spin_lock_bh(&q->lock);
+	idx = mt76_queue_add_buf(dev, q, &buf, 1, tx_info, skb, NULL);
+	mt76_queue_kick(dev, q);
+	spin_unlock_bh(&q->lock);
+
+	return 0;
+}
+
+static int
+mt76x2_init_tx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
+		     int idx, int n_desc)
+{
+	int ret;
+
+	q->regs = dev->mt76.regs + MT_TX_RING_BASE + idx * MT_RING_SIZE;
+	q->ndesc = n_desc;
+
+	ret = mt76_queue_alloc(dev, q);
+	if (ret)
+		return ret;
+
+	mt76x2_irq_enable(dev, MT_INT_TX_DONE(idx));
+
+	return 0;
+}
+
+void mt76x2_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
+			 struct sk_buff *skb)
+{
+	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+	void *rxwi = skb->data;
+
+	if (q == MT_RXQ_MCU) {
+		skb_queue_tail(&dev->mcu.res_q, skb);
+		wake_up(&dev->mcu.wait);
+		return;
+	}
+
+	skb_pull(skb, sizeof(struct mt76x2_rxwi));
+	if (mt76x2_mac_process_rx(dev, skb, rxwi)) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
+	mt76_rx(&dev->mt76, q, skb);
+}
+
+static int
+mt76x2_init_rx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
+		     int idx, int n_desc, int bufsize)
+{
+	int ret;
+
+	q->regs = dev->mt76.regs + MT_RX_RING_BASE + idx * MT_RING_SIZE;
+	q->ndesc = n_desc;
+	q->buf_size = bufsize;
+
+	ret = mt76_queue_alloc(dev, q);
+	if (ret)
+		return ret;
+
+	mt76x2_irq_enable(dev, MT_INT_RX_DONE(idx));
+
+	return 0;
+}
+
+static void
+mt76x2_tx_tasklet(unsigned long data)
+{
+	struct mt76x2_dev *dev = (struct mt76x2_dev *) data;
+	int i;
+
+	mt76x2_mac_process_tx_status_fifo(dev);
+
+	for (i = MT_TXQ_MCU; i >= 0; i--)
+		mt76_queue_tx_cleanup(dev, i, false);
+
+	mt76x2_mac_poll_tx_status(dev, false);
+	mt76x2_irq_enable(dev, MT_INT_TX_DONE_ALL);
+}
+
+int mt76x2_dma_init(struct mt76x2_dev *dev)
+{
+	static const u8 wmm_queue_map[] = {
+		[IEEE80211_AC_BE] = 0,
+		[IEEE80211_AC_BK] = 1,
+		[IEEE80211_AC_VI] = 2,
+		[IEEE80211_AC_VO] = 3,
+	};
+	int ret;
+	int i;
+	struct mt76_txwi_cache __maybe_unused *t;
+	struct mt76_queue *q;
+
+	BUILD_BUG_ON(sizeof(t->txwi) < sizeof(struct mt76x2_txwi));
+	BUILD_BUG_ON(sizeof(struct mt76x2_rxwi) > MT_RX_HEADROOM);
+
+	mt76_dma_attach(&dev->mt76);
+
+	init_waitqueue_head(&dev->mcu.wait);
+	skb_queue_head_init(&dev->mcu.res_q);
+
+	tasklet_init(&dev->tx_tasklet, mt76x2_tx_tasklet, (unsigned long) dev);
+
+	mt76_wr(dev, MT_WPDMA_RST_IDX, ~0);
+
+	for (i = 0; i < ARRAY_SIZE(wmm_queue_map); i++) {
+		ret = mt76x2_init_tx_queue(dev, &dev->mt76.q_tx[i],
+					   wmm_queue_map[i], MT_TX_RING_SIZE);
+		if (ret)
+			return ret;
+	}
+
+	ret = mt76x2_init_tx_queue(dev, &dev->mt76.q_tx[MT_TXQ_PSD],
+				   MT_TX_HW_QUEUE_MGMT, MT_TX_RING_SIZE);
+	if (ret)
+		return ret;
+
+	ret = mt76x2_init_tx_queue(dev, &dev->mt76.q_tx[MT_TXQ_MCU],
+				   MT_TX_HW_QUEUE_MCU, MT_MCU_RING_SIZE);
+	if (ret)
+		return ret;
+
+	ret = mt76x2_init_rx_queue(dev, &dev->mt76.q_rx[MT_RXQ_MCU], 1,
+				   MT_MCU_RING_SIZE, MT_RX_BUF_SIZE);
+	if (ret)
+		return ret;
+
+	q = &dev->mt76.q_rx[MT_RXQ_MAIN];
+	q->buf_offset = MT_RX_HEADROOM - sizeof(struct mt76x2_rxwi);
+	ret = mt76x2_init_rx_queue(dev, q, 0, MT_RX_RING_SIZE, MT_RX_BUF_SIZE);
+	if (ret)
+		return ret;
+
+	return mt76_init_queues(dev);
+}
+
+void mt76x2_dma_cleanup(struct mt76x2_dev *dev)
+{
+	tasklet_kill(&dev->tx_tasklet);
+	mt76_dma_cleanup(&dev->mt76);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.h b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.h
new file mode 100644
index 0000000..47f79d8
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.h
@@ -0,0 +1,68 @@
+/*
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
+#ifndef __MT76x2_DMA_H
+#define __MT76x2_DMA_H
+
+#include "dma.h"
+
+#define MT_TXD_INFO_LEN			GENMASK(13, 0)
+#define MT_TXD_INFO_NEXT_VLD		BIT(16)
+#define MT_TXD_INFO_TX_BURST		BIT(17)
+#define MT_TXD_INFO_80211		BIT(19)
+#define MT_TXD_INFO_TSO			BIT(20)
+#define MT_TXD_INFO_CSO			BIT(21)
+#define MT_TXD_INFO_WIV			BIT(24)
+#define MT_TXD_INFO_QSEL		GENMASK(26, 25)
+#define MT_TXD_INFO_TCO			BIT(29)
+#define MT_TXD_INFO_UCO			BIT(30)
+#define MT_TXD_INFO_ICO			BIT(31)
+
+#define MT_RX_FCE_INFO_LEN		GENMASK(13, 0)
+#define MT_RX_FCE_INFO_SELF_GEN		BIT(15)
+#define MT_RX_FCE_INFO_CMD_SEQ		GENMASK(19, 16)
+#define MT_RX_FCE_INFO_EVT_TYPE		GENMASK(23, 20)
+#define MT_RX_FCE_INFO_PCIE_INTR	BIT(24)
+#define MT_RX_FCE_INFO_QSEL		GENMASK(26, 25)
+#define MT_RX_FCE_INFO_D_PORT		GENMASK(29, 27)
+#define MT_RX_FCE_INFO_TYPE		GENMASK(31, 30)
+
+/* MCU request message header  */
+#define MT_MCU_MSG_LEN			GENMASK(15, 0)
+#define MT_MCU_MSG_CMD_SEQ		GENMASK(19, 16)
+#define MT_MCU_MSG_CMD_TYPE		GENMASK(26, 20)
+#define MT_MCU_MSG_PORT			GENMASK(29, 27)
+#define MT_MCU_MSG_TYPE			GENMASK(31, 30)
+#define MT_MCU_MSG_TYPE_CMD		BIT(30)
+
+enum mt76x2_qsel {
+	MT_QSEL_MGMT,
+	MT_QSEL_HCCA,
+	MT_QSEL_EDCA,
+	MT_QSEL_EDCA_2,
+};
+
+enum dma_msg_port {
+	WLAN_PORT,
+	CPU_RX_PORT,
+	CPU_TX_PORT,
+	HOST_PORT,
+	VIRTUAL_CPU_RX_PORT,
+	VIRTUAL_CPU_TX_PORT,
+	DISCARD,
+};
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
new file mode 100644
index 0000000..925fe6a
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -0,0 +1,644 @@
+/*
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
+#include <asm/unaligned.h>
+#include "mt76x2.h"
+#include "mt76x2_eeprom.h"
+
+#define EE_FIELD(_name, _value) [MT_EE_##_name] = (_value) | 1
+
+static int
+mt76x2_eeprom_copy(struct mt76x2_dev *dev, enum mt76x2_eeprom_field field,
+		   void *dest, int len)
+{
+	if (field + len > dev->mt76.eeprom.size)
+		return -1;
+
+	memcpy(dest, dev->mt76.eeprom.data + field, len);
+	return 0;
+}
+
+static int
+mt76x2_eeprom_get_macaddr(struct mt76x2_dev *dev)
+{
+	void *src = dev->mt76.eeprom.data + MT_EE_MAC_ADDR;
+
+	memcpy(dev->mt76.macaddr, src, ETH_ALEN);
+	return 0;
+}
+
+static void
+mt76x2_eeprom_parse_hw_cap(struct mt76x2_dev *dev)
+{
+	u16 val = MT_EE_NIC_CONF_0;
+
+	switch (FIELD_GET(MT_EE_NIC_CONF_0_BOARD_TYPE, val)) {
+	case BOARD_TYPE_5GHZ:
+		dev->mt76.cap.has_5ghz = true;
+		break;
+	case BOARD_TYPE_2GHZ:
+		dev->mt76.cap.has_2ghz = true;
+		break;
+	default:
+		dev->mt76.cap.has_2ghz = true;
+		dev->mt76.cap.has_5ghz = true;
+		break;
+	}
+}
+
+static int
+mt76x2_efuse_read(struct mt76x2_dev *dev, u16 addr, u8 *data)
+{
+	u32 val;
+	int i;
+
+	val = mt76_rr(dev, MT_EFUSE_CTRL);
+	val &= ~(MT_EFUSE_CTRL_AIN |
+		 MT_EFUSE_CTRL_MODE);
+	val |= FIELD_PREP(MT_EFUSE_CTRL_AIN, addr & ~0xf);
+	val |= MT_EFUSE_CTRL_KICK;
+	mt76_wr(dev, MT_EFUSE_CTRL, val);
+
+	if (!mt76_poll(dev, MT_EFUSE_CTRL, MT_EFUSE_CTRL_KICK, 0, 1000))
+		return -ETIMEDOUT;
+
+	udelay(2);
+
+	val = mt76_rr(dev, MT_EFUSE_CTRL);
+	if ((val & MT_EFUSE_CTRL_AOUT) == MT_EFUSE_CTRL_AOUT) {
+		memset(data, 0xff, 16);
+		return 0;
+	}
+
+	for (i = 0; i < 4; i++) {
+		val = mt76_rr(dev, MT_EFUSE_DATA(i));
+		put_unaligned_le32(val, data + 4 * i);
+	}
+
+	return 0;
+}
+
+static int
+mt76x2_get_efuse_data(struct mt76x2_dev *dev, void *buf, int len)
+{
+	int ret, i;
+
+	for (i = 0; i + 16 <= len; i += 16) {
+		ret = mt76x2_efuse_read(dev, i, buf + i);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static bool
+mt76x2_has_cal_free_data(struct mt76x2_dev *dev, u8 *efuse)
+{
+	u16 *efuse_w = (u16 *) efuse;
+
+	if (efuse_w[MT_EE_NIC_CONF_0] != 0)
+		return false;
+
+	if (efuse_w[MT_EE_XTAL_TRIM_1] == 0xffff)
+		return false;
+
+	if (efuse_w[MT_EE_TX_POWER_DELTA_BW40] != 0)
+		return false;
+
+	if (efuse_w[MT_EE_TX_POWER_0_START_2G] == 0xffff)
+		return false;
+
+	if (efuse_w[MT_EE_TX_POWER_0_GRP3_TX_POWER_DELTA] != 0)
+		return false;
+
+	if (efuse_w[MT_EE_TX_POWER_0_GRP4_TSSI_SLOPE] == 0xffff)
+		return false;
+
+	return true;
+}
+
+static void
+mt76x2_apply_cal_free_data(struct mt76x2_dev *dev, u8 *efuse)
+{
+#define GROUP_5G(_id)							   \
+	MT_EE_TX_POWER_0_START_5G + MT_TX_POWER_GROUP_SIZE_5G * (_id),	   \
+	MT_EE_TX_POWER_0_START_5G + MT_TX_POWER_GROUP_SIZE_5G * (_id) + 1, \
+	MT_EE_TX_POWER_1_START_5G + MT_TX_POWER_GROUP_SIZE_5G * (_id),	   \
+	MT_EE_TX_POWER_1_START_5G + MT_TX_POWER_GROUP_SIZE_5G * (_id) + 1
+
+	static const u8 cal_free_bytes[] = {
+		MT_EE_XTAL_TRIM_1,
+		MT_EE_TX_POWER_EXT_PA_5G + 1,
+		MT_EE_TX_POWER_0_START_2G,
+		MT_EE_TX_POWER_0_START_2G + 1,
+		MT_EE_TX_POWER_1_START_2G,
+		MT_EE_TX_POWER_1_START_2G + 1,
+		GROUP_5G(0),
+		GROUP_5G(1),
+		GROUP_5G(2),
+		GROUP_5G(3),
+		GROUP_5G(4),
+		GROUP_5G(5),
+		MT_EE_RF_2G_TSSI_OFF_TXPOWER,
+		MT_EE_RF_2G_RX_HIGH_GAIN + 1,
+		MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN,
+		MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN + 1,
+		MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN,
+		MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN + 1,
+		MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN,
+		MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN + 1,
+	};
+	u8 *eeprom = dev->mt76.eeprom.data;
+	u8 prev_grp0[4] = {
+		eeprom[MT_EE_TX_POWER_0_START_5G],
+		eeprom[MT_EE_TX_POWER_0_START_5G + 1],
+		eeprom[MT_EE_TX_POWER_1_START_5G],
+		eeprom[MT_EE_TX_POWER_1_START_5G + 1]
+	};
+	u16 val;
+	int i;
+
+	if (!mt76x2_has_cal_free_data(dev, efuse))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(cal_free_bytes); i++) {
+		int offset = cal_free_bytes[i];
+
+		eeprom[offset] = efuse[offset];
+	}
+
+	if (!(efuse[MT_EE_TX_POWER_0_START_5G] |
+	      efuse[MT_EE_TX_POWER_0_START_5G + 1]))
+		memcpy(eeprom + MT_EE_TX_POWER_0_START_5G, prev_grp0, 2);
+	if (!(efuse[MT_EE_TX_POWER_1_START_5G] |
+	      efuse[MT_EE_TX_POWER_1_START_5G + 1]))
+		memcpy(eeprom + MT_EE_TX_POWER_1_START_5G, prev_grp0 + 2, 2);
+
+	val = get_unaligned_le16(efuse + MT_EE_BT_RCAL_RESULT);
+	if (val != 0xffff)
+		eeprom[MT_EE_BT_RCAL_RESULT] = val & 0xff;
+
+	val = get_unaligned_le16(efuse + MT_EE_BT_VCDL_CALIBRATION);
+	if (val != 0xffff)
+		eeprom[MT_EE_BT_VCDL_CALIBRATION + 1] = val >> 8;
+
+	val = get_unaligned_le16(efuse + MT_EE_BT_PMUCFG);
+	if (val != 0xffff)
+		eeprom[MT_EE_BT_PMUCFG] = val & 0xff;
+}
+
+static int mt76x2_check_eeprom(struct mt76x2_dev *dev)
+{
+	u16 val = get_unaligned_le16(dev->mt76.eeprom.data);
+
+	switch (val) {
+	case 0x7662:
+	case 0x7612:
+		return 0;
+	default:
+		dev_err(dev->mt76.dev, "EEPROM data check failed: %04x\n", val);
+		return -EINVAL;
+	}
+}
+
+static int
+mt76x2_eeprom_load(struct mt76x2_dev *dev)
+{
+	void *efuse;
+	int len = MT7662_EEPROM_SIZE;
+	bool found;
+	int ret;
+
+	ret = mt76_eeprom_init(&dev->mt76, len);
+	if (ret < 0)
+		return ret;
+
+	found = ret;
+	if (found)
+		found = !mt76x2_check_eeprom(dev);
+
+	dev->mt76.otp.data = devm_kzalloc(dev->mt76.dev, len, GFP_KERNEL);
+	dev->mt76.otp.size = len;
+	if (!dev->mt76.otp.data)
+		return -ENOMEM;
+
+	efuse = dev->mt76.otp.data;
+
+	if (mt76x2_get_efuse_data(dev, efuse, len))
+		goto out;
+
+	if (found) {
+		mt76x2_apply_cal_free_data(dev, efuse);
+	} else {
+		/* FIXME: check if efuse data is complete */
+		found = true;
+		memcpy(dev->mt76.eeprom.data, efuse, len);
+	}
+
+out:
+	if (!found)
+		return -ENOENT;
+
+	return 0;
+}
+
+static inline int
+mt76x2_sign_extend(u32 val, unsigned int size)
+{
+	bool sign = val & BIT(size - 1);
+
+	val &= BIT(size - 1) - 1;
+
+	return sign ? val : -val;
+}
+
+static inline int
+mt76x2_sign_extend_optional(u32 val, unsigned int size)
+{
+	bool enable = val & BIT(size);
+
+	return enable ? mt76x2_sign_extend(val, size) : 0;
+}
+
+static bool
+field_valid(u8 val)
+{
+	return val != 0 && val != 0xff;
+}
+
+static void
+mt76x2_set_rx_gain_group(struct mt76x2_dev *dev, u8 val)
+{
+	s8 *dest = dev->cal.rx.high_gain;
+
+	if (!field_valid(val)) {
+		dest[0] = 0;
+		dest[1] = 0;
+		return;
+	}
+
+	dest[0] = mt76x2_sign_extend(val, 4);
+	dest[1] = mt76x2_sign_extend(val >> 4, 4);
+}
+
+static void
+mt76x2_set_rssi_offset(struct mt76x2_dev *dev, int chain, u8 val)
+{
+	s8 *dest = dev->cal.rx.rssi_offset;
+
+	if (!field_valid(val)) {
+		dest[chain] = 0;
+		return;
+	}
+
+	dest[chain] = mt76x2_sign_extend(val, 6);
+}
+
+static enum mt76x2_cal_channel_group
+mt76x2_get_cal_channel_group(int channel)
+{
+	if (channel >= 184 && channel <= 196)
+		return MT_CH_5G_JAPAN;
+	if (channel <= 48)
+		return MT_CH_5G_UNII_1;
+	if (channel <= 64)
+		return MT_CH_5G_UNII_2;
+	if (channel <= 114)
+		return MT_CH_5G_UNII_2E_1;
+	if (channel <= 144)
+		return MT_CH_5G_UNII_2E_2;
+	return MT_CH_5G_UNII_3;
+}
+
+static u8
+mt76x2_get_5g_rx_gain(struct mt76x2_dev *dev, u8 channel)
+{
+	enum mt76x2_cal_channel_group group;
+
+	group = mt76x2_get_cal_channel_group(channel);
+	switch (group) {
+	case MT_CH_5G_JAPAN:
+		return mt76x2_eeprom_get(dev, MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN);
+	case MT_CH_5G_UNII_1:
+		return mt76x2_eeprom_get(dev, MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN) >> 8;
+	case MT_CH_5G_UNII_2:
+		return mt76x2_eeprom_get(dev, MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN);
+	case MT_CH_5G_UNII_2E_1:
+		return mt76x2_eeprom_get(dev, MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN) >> 8;
+	case MT_CH_5G_UNII_2E_2:
+		return mt76x2_eeprom_get(dev, MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN);
+	default:
+		return mt76x2_eeprom_get(dev, MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN) >> 8;
+	}
+}
+
+void mt76x2_read_rx_gain(struct mt76x2_dev *dev)
+{
+	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+	int channel = chan->hw_value;
+	s8 lna_5g[3], lna_2g;
+	u8 lna;
+	u16 val;
+
+	if (chan->band == NL80211_BAND_2GHZ)
+		val = mt76x2_eeprom_get(dev, MT_EE_RF_2G_RX_HIGH_GAIN) >> 8;
+	else
+		val = mt76x2_get_5g_rx_gain(dev, channel);
+
+	mt76x2_set_rx_gain_group(dev, val);
+
+	if (chan->band == NL80211_BAND_2GHZ) {
+		val = mt76x2_eeprom_get(dev, MT_EE_RSSI_OFFSET_2G_0);
+		mt76x2_set_rssi_offset(dev, 0, val);
+		mt76x2_set_rssi_offset(dev, 1, val >> 8);
+	} else {
+		val = mt76x2_eeprom_get(dev, MT_EE_RSSI_OFFSET_5G_0);
+		mt76x2_set_rssi_offset(dev, 0, val);
+		mt76x2_set_rssi_offset(dev, 1, val >> 8);
+	}
+
+	val = mt76x2_eeprom_get(dev, MT_EE_LNA_GAIN);
+	lna_2g = val & 0xff;
+	lna_5g[0] = val >> 8;
+
+	val = mt76x2_eeprom_get(dev, MT_EE_RSSI_OFFSET_2G_1);
+	lna_5g[1] = val >> 8;
+
+	val = mt76x2_eeprom_get(dev, MT_EE_RSSI_OFFSET_5G_1);
+	lna_5g[2] = val >> 8;
+
+	if (!field_valid(lna_5g[1]))
+		lna_5g[1] = lna_5g[0];
+
+	if (!field_valid(lna_5g[2]))
+		lna_5g[2] = lna_5g[0];
+
+	dev->cal.rx.mcu_gain =  (lna_2g & 0xff);
+	dev->cal.rx.mcu_gain |= (lna_5g[0] & 0xff) << 8;
+	dev->cal.rx.mcu_gain |= (lna_5g[1] & 0xff) << 16;
+	dev->cal.rx.mcu_gain |= (lna_5g[2] & 0xff) << 24;
+
+	val = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_1);
+	if (val & MT_EE_NIC_CONF_1_LNA_EXT_2G)
+		lna_2g = 0;
+	if (val & MT_EE_NIC_CONF_1_LNA_EXT_5G)
+		memset(lna_5g, 0, sizeof(lna_5g));
+
+	if (chan->band == NL80211_BAND_2GHZ)
+		lna = lna_2g;
+	else if (channel <= 64)
+		lna = lna_5g[0];
+	else if (channel <= 128)
+		lna = lna_5g[1];
+	else
+		lna = lna_5g[2];
+
+	if (lna == 0xff)
+		lna = 0;
+
+	dev->cal.rx.lna_gain = mt76x2_sign_extend(lna, 8);
+}
+
+static s8
+mt76x2_rate_power_val(u8 val)
+{
+	if (!field_valid(val))
+		return 0;
+
+	return mt76x2_sign_extend_optional(val, 7);
+}
+
+void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t)
+{
+	bool is_5ghz = false;
+	u16 val;
+
+	is_5ghz = dev->mt76.chandef.chan->band == NL80211_BAND_5GHZ;
+
+	memset(t, 0, sizeof(*t));
+
+	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_CCK);
+	t->cck[0] = t->cck[1] = mt76x2_rate_power_val(val);
+	t->cck[2] = t->cck[3] = mt76x2_rate_power_val(val >> 8);
+
+	if (is_5ghz)
+		val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_OFDM_5G_6M);
+	else
+		val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_OFDM_2G_6M);
+	t->ofdm[0] = t->ofdm[1] = mt76x2_rate_power_val(val);
+	t->ofdm[2] = t->ofdm[3] = mt76x2_rate_power_val(val >> 8);
+
+	if (is_5ghz)
+		val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_OFDM_5G_24M);
+	else
+		val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_OFDM_2G_24M);
+	t->ofdm[4] = t->ofdm[5] = mt76x2_rate_power_val(val);
+	t->ofdm[6] = t->ofdm[7] = mt76x2_rate_power_val(val >> 8);
+
+	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_HT_MCS0);
+	t->ht[0] = t->ht[1] = mt76x2_rate_power_val(val);
+	t->ht[2] = t->ht[3] = mt76x2_rate_power_val(val >> 8);
+
+	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_HT_MCS4);
+	t->ht[4] = t->ht[5] = mt76x2_rate_power_val(val);
+	t->ht[6] = t->ht[7] = mt76x2_rate_power_val(val >> 8);
+
+	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_HT_MCS8);
+	t->ht[8] = t->ht[9] = mt76x2_rate_power_val(val);
+	t->ht[10] = t->ht[11] = mt76x2_rate_power_val(val >> 8);
+
+	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_HT_MCS12);
+	t->ht[12] = t->ht[13] = mt76x2_rate_power_val(val);
+	t->ht[14] = t->ht[15] = mt76x2_rate_power_val(val >> 8);
+
+	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_VHT_MCS0);
+	t->vht[0] = t->vht[1] = mt76x2_rate_power_val(val);
+	t->vht[2] = t->vht[3] = mt76x2_rate_power_val(val >> 8);
+
+	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_VHT_MCS4);
+	t->vht[4] = t->vht[5] = mt76x2_rate_power_val(val);
+	t->vht[6] = t->vht[7] = mt76x2_rate_power_val(val >> 8);
+
+	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_VHT_MCS8);
+	if (!is_5ghz)
+		val >>= 8;
+	t->vht[8] = t->vht[9] = mt76x2_rate_power_val(val >> 8);
+}
+
+static void
+mt76x2_get_power_info_2g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
+		       int chain, int offset)
+{
+	int channel = dev->mt76.chandef.chan->hw_value;
+	int delta_idx;
+	u8 data[6];
+	u16 val;
+
+	if (channel < 6)
+		delta_idx = 3;
+	else if (channel < 11)
+		delta_idx = 4;
+	else
+		delta_idx = 5;
+
+	mt76x2_eeprom_copy(dev, offset, data, sizeof(data));
+
+	t->chain[chain].tssi_slope = data[0];
+	t->chain[chain].tssi_offset = data[1];
+	t->chain[chain].target_power = data[2];
+	t->chain[chain].delta = mt76x2_sign_extend_optional(data[delta_idx], 7);
+
+	val = mt76x2_eeprom_get(dev, MT_EE_RF_2G_TSSI_OFF_TXPOWER);
+	t->target_power = val >> 8;
+}
+
+static void
+mt76x2_get_power_info_5g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
+		       int chain, int offset)
+{
+	int channel = dev->mt76.chandef.chan->hw_value;
+	enum mt76x2_cal_channel_group group;
+	int delta_idx;
+	u16 val;
+	u8 data[5];
+
+	group = mt76x2_get_cal_channel_group(channel);
+	offset += group * MT_TX_POWER_GROUP_SIZE_5G;
+
+	if (channel >= 192)
+		delta_idx = 4;
+	else if (channel >= 484)
+		delta_idx = 3;
+	else if (channel < 44)
+		delta_idx = 3;
+	else if (channel < 52)
+		delta_idx = 4;
+	else if (channel < 58)
+		delta_idx = 3;
+	else if (channel < 98)
+		delta_idx = 4;
+	else if (channel < 106)
+		delta_idx = 3;
+	else if (channel < 116)
+		delta_idx = 4;
+	else if (channel < 130)
+		delta_idx = 3;
+	else if (channel < 149)
+		delta_idx = 4;
+	else if (channel < 157)
+		delta_idx = 3;
+	else
+		delta_idx = 4;
+
+	mt76x2_eeprom_copy(dev, offset, data, sizeof(data));
+
+	t->chain[chain].tssi_slope = data[0];
+	t->chain[chain].tssi_offset = data[1];
+	t->chain[chain].target_power = data[2];
+	t->chain[chain].delta = mt76x2_sign_extend_optional(data[delta_idx], 7);
+
+	val = mt76x2_eeprom_get(dev, MT_EE_RF_2G_RX_HIGH_GAIN);
+	t->target_power = val & 0xff;
+}
+
+void mt76x2_get_power_info(struct mt76x2_dev *dev,
+			   struct mt76x2_tx_power_info *t)
+{
+	u16 bw40, bw80;
+
+	memset(t, 0, sizeof(*t));
+
+	bw40 = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_DELTA_BW40);
+	bw80 = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_DELTA_BW80);
+
+	if (dev->mt76.chandef.chan->band == NL80211_BAND_5GHZ) {
+		bw40 >>= 8;
+		mt76x2_get_power_info_5g(dev, t, 0, MT_EE_TX_POWER_0_START_5G);
+		mt76x2_get_power_info_5g(dev, t, 1, MT_EE_TX_POWER_1_START_5G);
+	} else {
+		mt76x2_get_power_info_2g(dev, t, 0, MT_EE_TX_POWER_0_START_2G);
+		mt76x2_get_power_info_2g(dev, t, 1, MT_EE_TX_POWER_1_START_2G);
+	}
+
+	if (mt76x2_tssi_enabled(dev) || !field_valid(t->target_power))
+		t->target_power = t->chain[0].target_power;
+
+	t->delta_bw40 = mt76x2_rate_power_val(bw40);
+	t->delta_bw80 = mt76x2_rate_power_val(bw80);
+}
+
+int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t)
+{
+	enum nl80211_band band = dev->mt76.chandef.chan->band;
+	u16 val, slope;
+	u8 bounds;
+
+	memset(t, 0, sizeof(*t));
+
+	val = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_1);
+	if (!(val & MT_EE_NIC_CONF_1_TEMP_TX_ALC))
+		return -EINVAL;
+
+	if (!mt76x2_ext_pa_enabled(dev, band))
+		return -EINVAL;
+
+	val = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_EXT_PA_5G) >> 8;
+	if (!(val & BIT(7)))
+		return -EINVAL;
+
+	t->temp_25_ref = val & 0x7f;
+	if (band == NL80211_BAND_5GHZ) {
+		slope = mt76x2_eeprom_get(dev, MT_EE_RF_TEMP_COMP_SLOPE_5G);
+		bounds = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_EXT_PA_5G);
+	} else {
+		slope = mt76x2_eeprom_get(dev, MT_EE_RF_TEMP_COMP_SLOPE_2G);
+		bounds = mt76x2_eeprom_get(dev, MT_EE_TX_POWER_DELTA_BW80) >> 8;
+	}
+
+	t->high_slope = slope & 0xff;
+	t->low_slope = slope >> 8;
+	t->lower_bound = 0 - (bounds & 0xf);
+	t->upper_bound = (bounds >> 4) & 0xf;
+
+	return 0;
+}
+
+bool mt76x2_ext_pa_enabled(struct mt76x2_dev *dev, enum nl80211_band band)
+{
+	u16 conf1 = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_0);
+
+	if (band == NL80211_BAND_5GHZ)
+		return !(conf1 & MT_EE_NIC_CONF_0_PA_INT_5G);
+	else
+		return !(conf1 & MT_EE_NIC_CONF_0_PA_INT_2G);
+}
+
+int mt76x2_eeprom_init(struct mt76x2_dev *dev)
+{
+	int ret;
+
+	ret = mt76x2_eeprom_load(dev);
+	if (ret)
+		return ret;
+
+	mt76x2_eeprom_parse_hw_cap(dev);
+	mt76x2_eeprom_get_macaddr(dev);
+	mt76_eeprom_override(&dev->mt76);
+	dev->mt76.macaddr[0] &= ~BIT(1);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
new file mode 100644
index 0000000..bbd7a5b
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
@@ -0,0 +1,181 @@
+/*
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
+#ifndef __MT76x2_EEPROM_H
+#define __MT76x2_EEPROM_H
+
+#include "mt76x2.h"
+
+enum mt76x2_eeprom_field {
+	MT_EE_CHIP_ID =				0x000,
+	MT_EE_VERSION =				0x002,
+	MT_EE_MAC_ADDR =			0x004,
+	MT_EE_NIC_CONF_0 =			0x034,
+	MT_EE_NIC_CONF_1 =			0x036,
+	MT_EE_NIC_CONF_2 =			0x042,
+
+	MT_EE_XTAL_TRIM_1 =			0x03a,
+	MT_EE_XTAL_TRIM_2 =			0x09e,
+
+	MT_EE_LNA_GAIN =			0x044,
+	MT_EE_RSSI_OFFSET_2G_0 =		0x046,
+	MT_EE_RSSI_OFFSET_2G_1 =		0x048,
+	MT_EE_RSSI_OFFSET_5G_0 =		0x04a,
+	MT_EE_RSSI_OFFSET_5G_1 =		0x04c,
+
+	MT_EE_TX_POWER_DELTA_BW40 =		0x050,
+	MT_EE_TX_POWER_DELTA_BW80 =		0x052,
+
+	MT_EE_TX_POWER_EXT_PA_5G =		0x054,
+
+	MT_EE_TX_POWER_0_START_2G =		0x056,
+	MT_EE_TX_POWER_1_START_2G =		0x05c,
+
+	/* used as byte arrays */
+#define MT_TX_POWER_GROUP_SIZE_5G		5
+#define MT_TX_POWER_GROUPS_5G			6
+	MT_EE_TX_POWER_0_START_5G =		0x062,
+
+	MT_EE_TX_POWER_0_GRP3_TX_POWER_DELTA =	0x074,
+	MT_EE_TX_POWER_0_GRP4_TSSI_SLOPE =	0x076,
+
+	MT_EE_TX_POWER_1_START_5G =		0x080,
+
+	MT_EE_TX_POWER_CCK =			0x0a0,
+	MT_EE_TX_POWER_OFDM_2G_6M =		0x0a2,
+	MT_EE_TX_POWER_OFDM_2G_24M =		0x0a4,
+	MT_EE_TX_POWER_OFDM_5G_6M =		0x0b2,
+	MT_EE_TX_POWER_OFDM_5G_24M =		0x0b4,
+	MT_EE_TX_POWER_HT_MCS0 =		0x0a6,
+	MT_EE_TX_POWER_HT_MCS4 =		0x0a8,
+	MT_EE_TX_POWER_HT_MCS8 =		0x0aa,
+	MT_EE_TX_POWER_HT_MCS12 =		0x0ac,
+	MT_EE_TX_POWER_VHT_MCS0 =		0x0ba,
+	MT_EE_TX_POWER_VHT_MCS4 =		0x0bc,
+	MT_EE_TX_POWER_VHT_MCS8 =		0x0be,
+
+	MT_EE_RF_TEMP_COMP_SLOPE_5G =		0x0f2,
+	MT_EE_RF_TEMP_COMP_SLOPE_2G =		0x0f4,
+
+	MT_EE_RF_2G_TSSI_OFF_TXPOWER =		0x0f6,
+	MT_EE_RF_2G_RX_HIGH_GAIN =		0x0f8,
+	MT_EE_RF_5G_GRP0_1_RX_HIGH_GAIN =	0x0fa,
+	MT_EE_RF_5G_GRP2_3_RX_HIGH_GAIN =	0x0fc,
+	MT_EE_RF_5G_GRP4_5_RX_HIGH_GAIN =	0x0fe,
+
+	MT_EE_BT_RCAL_RESULT =			0x138,
+	MT_EE_BT_VCDL_CALIBRATION =		0x13c,
+	MT_EE_BT_PMUCFG =			0x13e,
+
+	__MT_EE_MAX
+};
+
+#define MT_EE_NIC_CONF_0_PA_INT_2G		BIT(8)
+#define MT_EE_NIC_CONF_0_PA_INT_5G		BIT(9)
+#define MT_EE_NIC_CONF_0_BOARD_TYPE		GENMASK(13, 12)
+
+#define MT_EE_NIC_CONF_1_TEMP_TX_ALC		BIT(1)
+#define MT_EE_NIC_CONF_1_LNA_EXT_2G		BIT(2)
+#define MT_EE_NIC_CONF_1_LNA_EXT_5G		BIT(3)
+#define MT_EE_NIC_CONF_1_TX_ALC_EN		BIT(13)
+
+#define MT_EE_NIC_CONF_2_RX_STREAM		GENMASK(3, 0)
+#define MT_EE_NIC_CONF_2_TX_STREAM		GENMASK(7, 4)
+#define MT_EE_NIC_CONF_2_HW_ANTDIV		BIT(8)
+#define MT_EE_NIC_CONF_2_XTAL_OPTION		GENMASK(10, 9)
+#define MT_EE_NIC_CONF_2_TEMP_DISABLE		BIT(11)
+#define MT_EE_NIC_CONF_2_COEX_METHOD		GENMASK(15, 13)
+
+enum mt76x2_board_type {
+	BOARD_TYPE_2GHZ = 1,
+	BOARD_TYPE_5GHZ = 2,
+};
+
+enum mt76x2_cal_channel_group {
+	MT_CH_5G_JAPAN,
+	MT_CH_5G_UNII_1,
+	MT_CH_5G_UNII_2,
+	MT_CH_5G_UNII_2E_1,
+	MT_CH_5G_UNII_2E_2,
+	MT_CH_5G_UNII_3,
+	__MT_CH_MAX
+};
+
+struct mt76x2_tx_power_info {
+	u8 target_power;
+
+	s8 delta_bw40;
+	s8 delta_bw80;
+
+	struct {
+		s8 tssi_slope;
+		s8 tssi_offset;
+		s8 target_power;
+		s8 delta;
+	} chain[MT_MAX_CHAINS];
+};
+
+struct mt76x2_temp_comp {
+	u8 temp_25_ref;
+	int lower_bound; /* J */
+	int upper_bound; /* J */
+	unsigned int high_slope; /* J / dB */
+	unsigned int low_slope; /* J / dB */
+};
+
+static inline int
+mt76x2_eeprom_get(struct mt76x2_dev *dev, enum mt76x2_eeprom_field field)
+{
+	if ((field & 1) || field >= __MT_EE_MAX)
+		return -1;
+
+	return get_unaligned_le16(dev->mt76.eeprom.data + field);
+}
+
+void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t);
+void mt76x2_get_power_info(struct mt76x2_dev *dev,
+			   struct mt76x2_tx_power_info *t);
+int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t);
+bool mt76x2_ext_pa_enabled(struct mt76x2_dev *dev, enum nl80211_band band);
+void mt76x2_read_rx_gain(struct mt76x2_dev *dev);
+
+static inline bool
+mt76x2_temp_tx_alc_enabled(struct mt76x2_dev *dev)
+{
+	return mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_1) &
+	       MT_EE_NIC_CONF_1_TEMP_TX_ALC;
+}
+
+static inline bool
+mt76x2_tssi_enabled(struct mt76x2_dev *dev)
+{
+	return !mt76x2_temp_tx_alc_enabled(dev) &&
+	       (mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_1) &
+		MT_EE_NIC_CONF_1_TX_ALC_EN);
+}
+
+static inline bool
+mt76x2_has_ext_lna(struct mt76x2_dev *dev)
+{
+	u32 val = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_1);
+
+	if (dev->mt76.chandef.chan->band == NL80211_BAND_2GHZ)
+		return val & MT_EE_NIC_CONF_1_LNA_EXT_2G;
+	else
+		return val & MT_EE_NIC_CONF_1_LNA_EXT_5G;
+}
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
new file mode 100644
index 0000000..1fbd842
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -0,0 +1,765 @@
+/*
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
+#include <linux/delay.h>
+#include "mt76x2.h"
+#include "mt76x2_eeprom.h"
+#include "mt76x2_mcu.h"
+
+struct mt76x2_reg_pair {
+	u32 reg;
+	u32 value;
+};
+
+static bool
+mt76x2_wait_for_mac(struct mt76x2_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < 500; i++) {
+		switch (mt76_rr(dev, MT_MAC_CSR0)) {
+		case 0:
+		case ~0:
+			break;
+		default:
+			return true;
+		}
+		usleep_range(5000, 10000);
+	}
+
+	return false;
+}
+
+static bool
+wait_for_wpdma(struct mt76x2_dev *dev)
+{
+	return mt76_poll(dev, MT_WPDMA_GLO_CFG,
+			 MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
+			 MT_WPDMA_GLO_CFG_RX_DMA_BUSY,
+			 0, 1000);
+}
+
+static void
+mt76x2_mac_pbf_init(struct mt76x2_dev *dev)
+{
+	u32 val;
+
+	val = MT_PBF_SYS_CTRL_MCU_RESET |
+	      MT_PBF_SYS_CTRL_DMA_RESET |
+	      MT_PBF_SYS_CTRL_MAC_RESET |
+	      MT_PBF_SYS_CTRL_PBF_RESET |
+	      MT_PBF_SYS_CTRL_ASY_RESET;
+
+	mt76_set(dev, MT_PBF_SYS_CTRL, val);
+	mt76_clear(dev, MT_PBF_SYS_CTRL, val);
+
+	mt76_wr(dev, MT_PBF_TX_MAX_PCNT, 0xefef3f1f);
+	mt76_wr(dev, MT_PBF_RX_MAX_PCNT, 0xfebf);
+}
+
+static void
+mt76x2_write_reg_pairs(struct mt76x2_dev *dev,
+		       const struct mt76x2_reg_pair *data, int len)
+{
+	while (len > 0) {
+		mt76_wr(dev, data->reg, data->value);
+		len--;
+		data++;
+	}
+}
+
+static void
+mt76_write_mac_initvals(struct mt76x2_dev *dev)
+{
+#define DEFAULT_PROT_CFG				\
+	(FIELD_PREP(MT_PROT_CFG_RATE, 0x2004) |		\
+	 FIELD_PREP(MT_PROT_CFG_NAV, 1) |			\
+	 FIELD_PREP(MT_PROT_CFG_TXOP_ALLOW, 0x3f) |	\
+	 MT_PROT_CFG_RTS_THRESH)
+
+#define DEFAULT_PROT_CFG_20				\
+	(FIELD_PREP(MT_PROT_CFG_RATE, 0x2004) |		\
+	 FIELD_PREP(MT_PROT_CFG_CTRL, 1) |		\
+	 FIELD_PREP(MT_PROT_CFG_NAV, 1) |			\
+	 FIELD_PREP(MT_PROT_CFG_TXOP_ALLOW, 0x17))
+
+#define DEFAULT_PROT_CFG_40				\
+	(FIELD_PREP(MT_PROT_CFG_RATE, 0x2084) |		\
+	 FIELD_PREP(MT_PROT_CFG_CTRL, 1) |		\
+	 FIELD_PREP(MT_PROT_CFG_NAV, 1) |			\
+	 FIELD_PREP(MT_PROT_CFG_TXOP_ALLOW, 0x3f))
+
+	static const struct mt76x2_reg_pair vals[] = {
+		/* Copied from MediaTek reference source */
+		{ MT_PBF_SYS_CTRL,		0x00080c00 },
+		{ MT_PBF_CFG,			0x1efebcff },
+		{ MT_FCE_PSE_CTRL,		0x00000001 },
+		{ MT_MAC_SYS_CTRL,		0x0000000c },
+		{ MT_MAX_LEN_CFG,		0x003e3f00 },
+		{ MT_AMPDU_MAX_LEN_20M1S,	0xaaa99887 },
+		{ MT_AMPDU_MAX_LEN_20M2S,	0x000000aa },
+		{ MT_XIFS_TIME_CFG,		0x33a40d0a },
+		{ MT_BKOFF_SLOT_CFG,		0x00000209 },
+		{ MT_TBTT_SYNC_CFG,		0x00422010 },
+		{ MT_PWR_PIN_CFG,		0x00000000 },
+		{ 0x1238,			0x001700c8 },
+		{ MT_TX_SW_CFG0,		0x00101001 },
+		{ MT_TX_SW_CFG1,		0x00010000 },
+		{ MT_TX_SW_CFG2,		0x00000000 },
+		{ MT_TXOP_CTRL_CFG,		0x0400583f },
+		{ MT_TX_RTS_CFG,		0x00100020 },
+		{ MT_TX_TIMEOUT_CFG,		0x000a2290 },
+		{ MT_TX_RETRY_CFG,		0x47f01f0f },
+		{ MT_EXP_ACK_TIME,		0x002c00dc },
+		{ MT_TX_PROT_CFG6,		0xe3f42004 },
+		{ MT_TX_PROT_CFG7,		0xe3f42084 },
+		{ MT_TX_PROT_CFG8,		0xe3f42104 },
+		{ MT_PIFS_TX_CFG,		0x00060fff },
+		{ MT_RX_FILTR_CFG,		0x00015f97 },
+		{ MT_LEGACY_BASIC_RATE,		0x0000017f },
+		{ MT_HT_BASIC_RATE,		0x00004003 },
+		{ MT_PN_PAD_MODE,		0x00000002 },
+		{ MT_TXOP_HLDR_ET,		0x00000002 },
+		{ 0xa44,			0x00000000 },
+		{ MT_HEADER_TRANS_CTRL_REG,	0x00000000 },
+		{ MT_TSO_CTRL,			0x00000000 },
+		{ MT_AUX_CLK_CFG,		0x00000000 },
+		{ MT_DACCLK_EN_DLY_CFG,		0x00000000 },
+		{ MT_TX_ALC_CFG_4,		0x00000000 },
+		{ MT_TX_ALC_VGA3,		0x00000000 },
+		{ MT_TX_PWR_CFG_0,		0x3a3a3a3a },
+		{ MT_TX_PWR_CFG_1,		0x3a3a3a3a },
+		{ MT_TX_PWR_CFG_2,		0x3a3a3a3a },
+		{ MT_TX_PWR_CFG_3,		0x3a3a3a3a },
+		{ MT_TX_PWR_CFG_4,		0x3a3a3a3a },
+		{ MT_TX_PWR_CFG_7,		0x3a3a3a3a },
+		{ MT_TX_PWR_CFG_8,		0x0000003a },
+		{ MT_TX_PWR_CFG_9,		0x0000003a },
+		{ MT_EFUSE_CTRL,		0x0000d000 },
+		{ MT_PAUSE_ENABLE_CONTROL1,	0x0000000a },
+		{ MT_FCE_WLAN_FLOW_CONTROL1,	0x60401c18 },
+		{ MT_WPDMA_DELAY_INT_CFG,	0x94ff0000 },
+		{ MT_TX_SW_CFG3,		0x00000004 },
+		{ MT_HT_FBK_TO_LEGACY,		0x00001818 },
+		{ MT_VHT_HT_FBK_CFG1,		0xedcba980 },
+		{ MT_PROT_AUTO_TX_CFG,		0x00830083 },
+		{ MT_HT_CTRL_CFG,		0x000001ff },
+	};
+	struct mt76x2_reg_pair prot_vals[] = {
+		{ MT_CCK_PROT_CFG,		DEFAULT_PROT_CFG },
+		{ MT_OFDM_PROT_CFG,		DEFAULT_PROT_CFG },
+		{ MT_MM20_PROT_CFG,		DEFAULT_PROT_CFG_20 },
+		{ MT_MM40_PROT_CFG,		DEFAULT_PROT_CFG_40 },
+		{ MT_GF20_PROT_CFG,		DEFAULT_PROT_CFG_20 },
+		{ MT_GF40_PROT_CFG,		DEFAULT_PROT_CFG_40 },
+	};
+
+	mt76x2_write_reg_pairs(dev, vals, ARRAY_SIZE(vals));
+	mt76x2_write_reg_pairs(dev, prot_vals, ARRAY_SIZE(prot_vals));
+}
+
+static void
+mt76x2_fixup_xtal(struct mt76x2_dev *dev)
+{
+	u16 eep_val;
+	s8 offset = 0;
+
+	eep_val = mt76x2_eeprom_get(dev, MT_EE_XTAL_TRIM_2);
+
+	offset = eep_val & 0x7f;
+	if ((eep_val & 0xff) == 0xff)
+		offset = 0;
+	else if (eep_val & 0x80)
+		offset = 0 - offset;
+
+	eep_val >>= 8;
+	if (eep_val == 0x00 || eep_val == 0xff) {
+		eep_val = mt76x2_eeprom_get(dev, MT_EE_XTAL_TRIM_1);
+		eep_val &= 0xff;
+
+		if (eep_val == 0x00 || eep_val == 0xff)
+			eep_val = 0x14;
+	}
+
+	eep_val &= 0x7f;
+	mt76_rmw_field(dev, MT_XO_CTRL5, MT_XO_CTRL5_C2_VAL, eep_val + offset);
+	mt76_set(dev, MT_XO_CTRL6, MT_XO_CTRL6_C2_CTRL);
+
+	eep_val = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_2);
+	switch (FIELD_GET(MT_EE_NIC_CONF_2_XTAL_OPTION, eep_val)) {
+	case 0:
+		mt76_wr(dev, MT_XO_CTRL7, 0x5c1fee80);
+		break;
+	case 1:
+		mt76_wr(dev, MT_XO_CTRL7, 0x5c1feed0);
+		break;
+	default:
+		break;
+	}
+}
+
+static void
+mt76x2_init_beacon_offsets(struct mt76x2_dev *dev)
+{
+	u16 base = MT_BEACON_BASE;
+	u32 regs[4] = {};
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		u16 addr = dev->beacon_offsets[i];
+
+		regs[i / 4] |= ((addr - base) / 64) << (8 * (i % 4));
+	}
+
+	for (i = 0; i < 4; i++)
+		mt76_wr(dev, MT_BCN_OFFSET(i), regs[i]);
+}
+
+int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
+{
+	static const u8 null_addr[ETH_ALEN] = {};
+	const u8 *macaddr = dev->mt76.macaddr;
+	u32 val;
+	int i, k;
+
+	if (!mt76x2_wait_for_mac(dev))
+		return -ETIMEDOUT;
+
+	val = mt76_rr(dev, MT_WPDMA_GLO_CFG);
+
+	val &= ~(MT_WPDMA_GLO_CFG_TX_DMA_EN |
+		 MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
+		 MT_WPDMA_GLO_CFG_RX_DMA_EN |
+		 MT_WPDMA_GLO_CFG_RX_DMA_BUSY |
+		 MT_WPDMA_GLO_CFG_DMA_BURST_SIZE);
+	val |= FIELD_PREP(MT_WPDMA_GLO_CFG_DMA_BURST_SIZE, 3);
+
+	mt76_wr(dev, MT_WPDMA_GLO_CFG, val);
+
+	mt76x2_mac_pbf_init(dev);
+	mt76_write_mac_initvals(dev);
+	mt76x2_fixup_xtal(dev);
+
+	mt76_clear(dev, MT_MAC_SYS_CTRL,
+		   MT_MAC_SYS_CTRL_RESET_CSR |
+		   MT_MAC_SYS_CTRL_RESET_BBP);
+
+	if (is_mt7612(dev))
+		mt76_clear(dev, MT_COEXCFG0, MT_COEXCFG0_COEX_EN);
+
+	mt76_set(dev, MT_EXT_CCA_CFG, 0x0000f000);
+	mt76_clear(dev, MT_TX_ALC_CFG_4, BIT(31));
+
+	mt76_wr(dev, MT_RF_BYPASS_0, 0x06000000);
+	mt76_wr(dev, MT_RF_SETTING_0, 0x08800000);
+	usleep_range(5000, 10000);
+	mt76_wr(dev, MT_RF_BYPASS_0, 0x00000000);
+
+	mt76_wr(dev, MT_MCU_CLOCK_CTL, 0x1401);
+	mt76_clear(dev, MT_FCE_L2_STUFF, MT_FCE_L2_STUFF_WR_MPDU_LEN_EN);
+
+	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(macaddr));
+	mt76_wr(dev, MT_MAC_ADDR_DW1, get_unaligned_le16(macaddr + 4));
+
+	mt76_wr(dev, MT_MAC_BSSID_DW0, get_unaligned_le32(macaddr));
+	mt76_wr(dev, MT_MAC_BSSID_DW1, get_unaligned_le16(macaddr + 4) |
+		FIELD_PREP(MT_MAC_BSSID_DW1_MBSS_MODE, 3) | /* 8 beacons */
+		MT_MAC_BSSID_DW1_MBSS_LOCAL_BIT);
+
+	/* Fire a pre-TBTT interrupt 8 ms before TBTT */
+	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
+		       8 << 4);
+	mt76_wr(dev, MT_INT_TIMER_EN, 0);
+
+	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xffff);
+	if (!hard)
+		return 0;
+
+	for (i = 0; i < 256; i++)
+		mt76x2_mac_wcid_setup(dev, i, 0, NULL);
+
+	for (i = 0; i < 16; i++)
+		for (k = 0; k < 4; k++)
+			mt76x2_mac_shared_key_setup(dev, i, k, NULL);
+
+	for (i = 0; i < 8; i++) {
+		mt76x2_mac_set_bssid(dev, i, null_addr);
+		mt76x2_mac_set_beacon(dev, i, NULL);
+	}
+
+	for (i = 0; i < 16; i++)
+		mt76_rr(dev, MT_TX_STAT_FIFO);
+
+	mt76_set(dev, MT_MAC_APC_BSSID_H(0), MT_MAC_APC_BSSID0_H_EN);
+
+	mt76_wr(dev, MT_CH_TIME_CFG,
+		MT_CH_TIME_CFG_TIMER_EN |
+		MT_CH_TIME_CFG_TX_AS_BUSY |
+		MT_CH_TIME_CFG_RX_AS_BUSY |
+		MT_CH_TIME_CFG_NAV_AS_BUSY |
+		MT_CH_TIME_CFG_EIFS_AS_BUSY |
+		FIELD_PREP(MT_CH_TIME_CFG_CH_TIMER_CLR, 1));
+
+	mt76x2_init_beacon_offsets(dev);
+
+	mt76x2_set_tx_ackto(dev);
+
+	return 0;
+}
+
+int mt76x2_mac_start(struct mt76x2_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < 16; i++)
+		mt76_rr(dev, MT_TX_AGG_CNT(i));
+
+	for (i = 0; i < 16; i++)
+		mt76_rr(dev, MT_TX_STAT_FIFO);
+
+	memset(dev->aggr_stats, 0, sizeof(dev->aggr_stats));
+
+	mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
+	wait_for_wpdma(dev);
+	usleep_range(50, 100);
+
+	mt76_set(dev, MT_WPDMA_GLO_CFG,
+		 MT_WPDMA_GLO_CFG_TX_DMA_EN |
+		 MT_WPDMA_GLO_CFG_RX_DMA_EN);
+
+	mt76_clear(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE);
+
+	mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+
+	mt76_wr(dev, MT_MAC_SYS_CTRL,
+		MT_MAC_SYS_CTRL_ENABLE_TX |
+		MT_MAC_SYS_CTRL_ENABLE_RX);
+
+	mt76x2_irq_enable(dev, MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
+			       MT_INT_TX_STAT);
+
+	return 0;
+}
+
+void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force)
+{
+	bool stopped = false;
+	u32 rts_cfg;
+	int i;
+
+	mt76_wr(dev, MT_MAC_SYS_CTRL, 0);
+
+	rts_cfg = mt76_rr(dev, MT_TX_RTS_CFG);
+	mt76_wr(dev, MT_TX_RTS_CFG, rts_cfg & ~MT_TX_RTS_CFG_RETRY_LIMIT);
+
+	/* Wait for MAC to become idle */
+	for (i = 0; i < 300; i++) {
+		if (mt76_rr(dev, MT_MAC_STATUS) &
+		    (MT_MAC_STATUS_RX | MT_MAC_STATUS_TX))
+			continue;
+
+		if (mt76_rr(dev, MT_BBP(IBI, 12)))
+			continue;
+
+		stopped = true;
+		break;
+	}
+
+	if (force && !stopped) {
+		mt76_set(dev, MT_BBP(CORE, 4), BIT(1));
+		mt76_clear(dev, MT_BBP(CORE, 4), BIT(1));
+
+		mt76_set(dev, MT_BBP(CORE, 4), BIT(0));
+		mt76_clear(dev, MT_BBP(CORE, 4), BIT(0));
+	}
+
+	mt76_wr(dev, MT_TX_RTS_CFG, rts_cfg);
+}
+
+void mt76x2_mac_resume(struct mt76x2_dev *dev)
+{
+	mt76_wr(dev, MT_MAC_SYS_CTRL,
+		MT_MAC_SYS_CTRL_ENABLE_TX |
+		MT_MAC_SYS_CTRL_ENABLE_RX);
+}
+
+static void
+mt76x2_power_on_rf_patch(struct mt76x2_dev *dev)
+{
+	mt76_set(dev, 0x10130, BIT(0) | BIT(16));
+	udelay(1);
+
+	mt76_clear(dev, 0x1001c, 0xff);
+	mt76_set(dev, 0x1001c, 0x30);
+
+	mt76_wr(dev, 0x10014, 0x484f);
+	udelay(1);
+
+	mt76_set(dev, 0x10130, BIT(17));
+	udelay(125);
+
+	mt76_clear(dev, 0x10130, BIT(16));
+	udelay(50);
+
+	mt76_set(dev, 0x1014c, BIT(19) | BIT(20));
+}
+
+static void
+mt76x2_power_on_rf(struct mt76x2_dev *dev, int unit)
+{
+	int shift = unit ? 8 : 0;
+
+	/* Enable RF BG */
+	mt76_set(dev, 0x10130, BIT(0) << shift);
+	udelay(10);
+
+	/* Enable RFDIG LDO/AFE/ABB/ADDA */
+	mt76_set(dev, 0x10130, (BIT(1) | BIT(3) | BIT(4) | BIT(5)) << shift);
+	udelay(10);
+
+	/* Switch RFDIG power to internal LDO */
+	mt76_clear(dev, 0x10130, BIT(2) << shift);
+	udelay(10);
+
+	mt76x2_power_on_rf_patch(dev);
+
+	mt76_set(dev, 0x530, 0xf);
+}
+
+static void
+mt76x2_power_on(struct mt76x2_dev *dev)
+{
+	u32 val;
+
+	/* Turn on WL MTCMOS */
+	mt76_set(dev, MT_WLAN_MTC_CTRL, MT_WLAN_MTC_CTRL_MTCMOS_PWR_UP);
+
+	val = MT_WLAN_MTC_CTRL_STATE_UP |
+	      MT_WLAN_MTC_CTRL_PWR_ACK |
+	      MT_WLAN_MTC_CTRL_PWR_ACK_S;
+
+	mt76_poll(dev, MT_WLAN_MTC_CTRL, val, val, 1000);
+
+	mt76_clear(dev, MT_WLAN_MTC_CTRL, 0x7f << 16);
+	udelay(10);
+
+	mt76_clear(dev, MT_WLAN_MTC_CTRL, 0xf << 24);
+	udelay(10);
+
+	mt76_set(dev, MT_WLAN_MTC_CTRL, 0xf << 24);
+	mt76_clear(dev, MT_WLAN_MTC_CTRL, 0xfff);
+
+	/* Turn on AD/DA power down */
+	mt76_clear(dev, 0x11204, BIT(3));
+
+	/* WLAN function enable */
+	mt76_set(dev, 0x10080, BIT(0));
+
+	/* Release BBP software reset */
+	mt76_clear(dev, 0x10064, BIT(18));
+
+	mt76x2_power_on_rf(dev, 0);
+	mt76x2_power_on_rf(dev, 1);
+}
+
+void mt76x2_set_tx_ackto(struct mt76x2_dev *dev)
+{
+	u8 ackto, sifs, slottime = dev->slottime;
+
+	slottime += 3 * dev->coverage_class;
+
+	sifs = mt76_get_field(dev, MT_XIFS_TIME_CFG,
+			      MT_XIFS_TIME_CFG_OFDM_SIFS);
+
+	ackto = slottime + sifs;
+	mt76_rmw_field(dev, MT_TX_TIMEOUT_CFG,
+		       MT_TX_TIMEOUT_CFG_ACKTO, ackto);
+}
+
+static void
+mt76x2_set_wlan_state(struct mt76x2_dev *dev, bool enable)
+{
+	u32 val = mt76_rr(dev, MT_WLAN_FUN_CTRL);
+
+	if (enable)
+		val |= (MT_WLAN_FUN_CTRL_WLAN_EN |
+			MT_WLAN_FUN_CTRL_WLAN_CLK_EN);
+	else
+		val &= ~(MT_WLAN_FUN_CTRL_WLAN_EN |
+			 MT_WLAN_FUN_CTRL_WLAN_CLK_EN);
+
+	mt76_wr(dev, MT_WLAN_FUN_CTRL, val);
+	udelay(20);
+}
+
+static void
+mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable)
+{
+	u32 val;
+
+	val = mt76_rr(dev, MT_WLAN_FUN_CTRL);
+
+	val &= ~MT_WLAN_FUN_CTRL_FRC_WL_ANT_SEL;
+
+	if (val & MT_WLAN_FUN_CTRL_WLAN_EN) {
+		val |= MT_WLAN_FUN_CTRL_WLAN_RESET_RF;
+		mt76_wr(dev, MT_WLAN_FUN_CTRL, val);
+		udelay(20);
+
+		val &= ~MT_WLAN_FUN_CTRL_WLAN_RESET_RF;
+	}
+
+	mt76_wr(dev, MT_WLAN_FUN_CTRL, val);
+	udelay(20);
+
+	mt76x2_set_wlan_state(dev, enable);
+}
+
+int mt76x2_init_hardware(struct mt76x2_dev *dev)
+{
+	static const u16 beacon_offsets[16] = {
+		/* 1024 byte per beacon */
+		0xc000,
+		0xc400,
+		0xc800,
+		0xcc00,
+		0xd000,
+		0xd400,
+		0xd800,
+		0xdc00,
+
+		/* BSS idx 8-15 not used for beacons */
+		0xc000,
+		0xc000,
+		0xc000,
+		0xc000,
+		0xc000,
+		0xc000,
+		0xc000,
+		0xc000,
+	};
+	u32 val;
+	int ret;
+
+	dev->beacon_offsets = beacon_offsets;
+	tasklet_init(&dev->pre_tbtt_tasklet, mt76x2_pre_tbtt_tasklet,
+		     (unsigned long) dev);
+
+	dev->chainmask = 0x202;
+	dev->global_wcid.idx = 255;
+	dev->global_wcid.hw_key_idx = -1;
+	dev->slottime = 9;
+
+	val = mt76_rr(dev, MT_WPDMA_GLO_CFG);
+	val &= MT_WPDMA_GLO_CFG_DMA_BURST_SIZE |
+	       MT_WPDMA_GLO_CFG_BIG_ENDIAN |
+	       MT_WPDMA_GLO_CFG_HDR_SEG_LEN;
+	val |= MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE;
+	mt76_wr(dev, MT_WPDMA_GLO_CFG, val);
+
+	mt76x2_reset_wlan(dev, true);
+	mt76x2_power_on(dev);
+
+	ret = mt76x2_eeprom_init(dev);
+	if (ret)
+		return ret;
+
+	ret = mt76x2_mac_reset(dev, true);
+	if (ret)
+		return ret;
+
+	ret = mt76x2_dma_init(dev);
+	if (ret)
+		return ret;
+
+	set_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
+	ret = mt76x2_mac_start(dev);
+	if (ret)
+		return ret;
+
+	ret = mt76x2_mcu_init(dev);
+	if (ret)
+		return ret;
+
+	mt76x2_mac_stop(dev, false);
+	dev->rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
+
+	return 0;
+}
+
+void mt76x2_stop_hardware(struct mt76x2_dev *dev)
+{
+	cancel_delayed_work_sync(&dev->cal_work);
+	cancel_delayed_work_sync(&dev->mac_work);
+	mt76x2_mcu_set_radio_state(dev, false);
+	mt76x2_mac_stop(dev, false);
+}
+
+void mt76x2_cleanup(struct mt76x2_dev *dev)
+{
+	mt76x2_stop_hardware(dev);
+	mt76x2_dma_cleanup(dev);
+	mt76x2_mcu_cleanup(dev);
+}
+
+struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
+{
+	static const struct mt76_driver_ops drv_ops = {
+		.txwi_size = sizeof(struct mt76x2_txwi),
+		.update_survey = mt76x2_update_channel,
+		.tx_prepare_skb = mt76x2_tx_prepare_skb,
+		.tx_complete_skb = mt76x2_tx_complete_skb,
+		.rx_skb = mt76x2_queue_rx_skb,
+		.rx_poll_complete = mt76x2_rx_poll_complete,
+	};
+	struct ieee80211_hw *hw;
+	struct mt76x2_dev *dev;
+
+	hw = ieee80211_alloc_hw(sizeof(*dev), &mt76x2_ops);
+	if (!hw)
+		return NULL;
+
+	dev = hw->priv;
+	dev->mt76.dev = pdev;
+	dev->mt76.hw = hw;
+	dev->mt76.drv = &drv_ops;
+	mutex_init(&dev->mutex);
+	spin_lock_init(&dev->irq_lock);
+
+	return dev;
+}
+
+#define CCK_RATE(_idx, _rate) {					\
+	.bitrate = _rate,					\
+	.flags = IEEE80211_RATE_SHORT_PREAMBLE,			\
+	.hw_value = (MT_PHY_TYPE_CCK << 8) | _idx,		\
+	.hw_value_short = (MT_PHY_TYPE_CCK << 8) | (8 + _idx),	\
+}
+
+#define OFDM_RATE(_idx, _rate) {				\
+	.bitrate = _rate,					\
+	.hw_value = (MT_PHY_TYPE_OFDM << 8) | _idx,		\
+	.hw_value_short = (MT_PHY_TYPE_OFDM << 8) | _idx,	\
+}
+
+static struct ieee80211_rate mt76x2_rates[] = {
+	CCK_RATE(0, 10),
+	CCK_RATE(1, 20),
+	CCK_RATE(2, 55),
+	CCK_RATE(3, 110),
+	OFDM_RATE(0, 60),
+	OFDM_RATE(1, 90),
+	OFDM_RATE(2, 120),
+	OFDM_RATE(3, 180),
+	OFDM_RATE(4, 240),
+	OFDM_RATE(5, 360),
+	OFDM_RATE(6, 480),
+	OFDM_RATE(7, 540),
+};
+
+static const struct ieee80211_iface_limit if_limits[] = {
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
+static const struct ieee80211_iface_combination if_comb[] = {
+	{
+		.limits = if_limits,
+		.n_limits = ARRAY_SIZE(if_limits),
+		.max_interfaces = 8,
+		.num_different_channels = 1,
+		.beacon_int_infra_match = true,
+	}
+};
+
+int mt76x2_register_device(struct mt76x2_dev *dev)
+{
+	struct ieee80211_hw *hw = mt76_hw(dev);
+	struct wiphy *wiphy = hw->wiphy;
+	void *status_fifo;
+	int fifo_size;
+	int i, ret;
+
+	fifo_size = roundup_pow_of_two(32 * sizeof(struct mt76x2_tx_status));
+	status_fifo = devm_kzalloc(dev->mt76.dev, fifo_size, GFP_KERNEL);
+	if (!status_fifo)
+		return -ENOMEM;
+
+	kfifo_init(&dev->txstatus_fifo, status_fifo, fifo_size);
+
+	ret = mt76x2_init_hardware(dev);
+	if (ret)
+		return ret;
+
+	hw->queues = 4;
+	hw->max_rates = 1;
+	hw->max_report_rates = 7;
+	hw->max_rate_tries = 1;
+	hw->extra_tx_headroom = 2;
+
+	hw->sta_data_size = sizeof(struct mt76x2_sta);
+	hw->vif_data_size = sizeof(struct mt76x2_vif);
+
+	for (i = 0; i < ARRAY_SIZE(dev->macaddr_list); i++) {
+		u8 *addr = dev->macaddr_list[i].addr;
+
+		memcpy(addr, dev->mt76.macaddr, ETH_ALEN);
+
+		if (!i)
+			continue;
+
+		addr[0] |= BIT(1);
+		addr[0] ^= ((i - 1) << 2);
+	}
+	wiphy->addresses = dev->macaddr_list;
+	wiphy->n_addresses = ARRAY_SIZE(dev->macaddr_list);
+
+	wiphy->iface_combinations = if_comb;
+	wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
+
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
+
+	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
+	INIT_DELAYED_WORK(&dev->cal_work, mt76x2_phy_calibrate);
+	INIT_DELAYED_WORK(&dev->mac_work, mt76x2_mac_work);
+
+	dev->mt76.sband_2g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
+	dev->mt76.sband_5g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
+
+	ret = mt76_register_device(&dev->mt76, true, mt76x2_rates,
+				   ARRAY_SIZE(mt76x2_rates));
+	if (ret)
+		goto fail;
+
+	mt76x2_init_debugfs(dev);
+
+	return 0;
+
+fail:
+	mt76x2_stop_hardware(dev);
+	return ret;
+}
+
+
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
new file mode 100644
index 0000000..649f5f3
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -0,0 +1,738 @@
+/*
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
+#include <linux/delay.h>
+#include "mt76x2.h"
+#include "mt76x2_mcu.h"
+#include "mt76x2_eeprom.h"
+#include "mt76x2_trace.h"
+
+void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr)
+{
+	idx &= 7;
+	mt76_wr(dev, MT_MAC_APC_BSSID_L(idx), get_unaligned_le32(addr));
+	mt76_rmw_field(dev, MT_MAC_APC_BSSID_H(idx), MT_MAC_APC_BSSID_H_ADDR,
+		       get_unaligned_le16(addr + 4));
+}
+
+static void
+mt76x2_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
+{
+	u8 idx = FIELD_GET(MT_RXWI_RATE_INDEX, rate);
+
+	switch (FIELD_GET(MT_RXWI_RATE_PHY, rate)) {
+	case MT_PHY_TYPE_OFDM:
+		if (idx >= 8)
+			idx = 0;
+
+		if (status->band == NL80211_BAND_2GHZ)
+			idx += 4;
+
+		status->rate_idx = idx;
+		return;
+	case MT_PHY_TYPE_CCK:
+		if (idx >= 8) {
+			idx -= 8;
+			status->flag |= RX_FLAG_SHORTPRE;
+		}
+
+		if (idx >= 4)
+			idx = 0;
+
+		status->rate_idx = idx;
+		return;
+	case MT_PHY_TYPE_HT_GF:
+		status->flag |= RX_FLAG_HT_GF;
+		/* fall through */
+	case MT_PHY_TYPE_HT:
+		status->flag |= RX_FLAG_HT;
+		status->rate_idx = idx;
+		break;
+	case MT_PHY_TYPE_VHT:
+		status->flag |= RX_FLAG_VHT;
+		status->rate_idx = FIELD_GET(MT_RATE_INDEX_VHT_IDX, idx);
+		status->vht_nss = FIELD_GET(MT_RATE_INDEX_VHT_NSS, idx) + 1;
+		break;
+	default:
+		WARN_ON(1);
+		return;
+	}
+
+	if (rate & MT_RXWI_RATE_LDPC)
+		status->flag |= RX_FLAG_LDPC;
+
+	if (rate & MT_RXWI_RATE_SGI)
+		status->flag |= RX_FLAG_SHORT_GI;
+
+	if (rate & MT_RXWI_RATE_STBC)
+		status->flag |= 1 << RX_FLAG_STBC_SHIFT;
+
+	switch (FIELD_GET(MT_RXWI_RATE_BW, rate)) {
+	case MT_PHY_BW_20:
+		break;
+	case MT_PHY_BW_40:
+		status->flag |= RX_FLAG_40MHZ;
+		break;
+	case MT_PHY_BW_80:
+		status->vht_flag |= RX_VHT_FLAG_80MHZ;
+		break;
+	default:
+		break;
+	}
+}
+
+static __le16
+mt76x2_mac_tx_rate_val(struct mt76x2_dev *dev,
+		       const struct ieee80211_tx_rate *rate, u8 *nss_val)
+{
+	u16 rateval;
+	u8 phy, rate_idx;
+	u8 nss = 1;
+	u8 bw = 0;
+
+	if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
+		rate_idx = rate->idx;
+		nss = 1 + (rate->idx >> 4);
+		phy = MT_PHY_TYPE_VHT;
+		if (rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+			bw = 2;
+		else if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			bw = 1;
+	} else if (rate->flags & IEEE80211_TX_RC_MCS) {
+		rate_idx = rate->idx;
+		nss = 1 + (rate->idx >> 3);
+		phy = MT_PHY_TYPE_HT;
+		if (rate->flags & IEEE80211_TX_RC_GREEN_FIELD)
+			phy = MT_PHY_TYPE_HT_GF;
+		if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			bw = 1;
+	} else {
+		const struct ieee80211_rate *r;
+		int band = dev->mt76.chandef.chan->band;
+		u16 val;
+
+		r = &mt76_hw(dev)->wiphy->bands[band]->bitrates[rate->idx];
+		if (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+			val = r->hw_value_short;
+		else
+			val = r->hw_value;
+
+		phy = val >> 8;
+		rate_idx = val & 0xff;
+		bw = 0;
+	}
+
+	rateval = FIELD_PREP(MT_RXWI_RATE_INDEX, rate_idx);
+	rateval |= FIELD_PREP(MT_RXWI_RATE_PHY, phy);
+	rateval |= FIELD_PREP(MT_RXWI_RATE_BW, bw);
+	if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
+		rateval |= MT_RXWI_RATE_SGI;
+
+	*nss_val = nss;
+	return cpu_to_le16(rateval);
+}
+
+void mt76x2_mac_wcid_set_rate(struct mt76x2_dev *dev, struct mt76_wcid *wcid,
+			      const struct ieee80211_tx_rate *rate)
+{
+	spin_lock_bh(&dev->mt76.lock);
+	wcid->tx_rate = mt76x2_mac_tx_rate_val(dev, rate, &wcid->tx_rate_nss);
+	wcid->tx_rate_set = true;
+	spin_unlock_bh(&dev->mt76.lock);
+}
+
+void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
+			   struct sk_buff *skb, struct mt76_wcid *wcid,
+			   struct ieee80211_sta *sta)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_rate *rate = &info->control.rates[0];
+	u16 rate_ht_mask = FIELD_PREP(MT_RXWI_RATE_PHY, BIT(1) | BIT(2));
+	u16 txwi_flags = 0;
+	u8 nss;
+	s8 txpwr_adj, max_txpwr_adj;
+
+	memset(txwi, 0, sizeof(*txwi));
+
+	if (wcid)
+		txwi->wcid = wcid->idx;
+	else
+		txwi->wcid = 0xff;
+
+	txwi->pktid = 1;
+
+	spin_lock_bh(&dev->mt76.lock);
+	if (rate->idx < 0 || !rate->count) {
+		txwi->rate = wcid->tx_rate;
+		max_txpwr_adj = wcid->max_txpwr_adj;
+		nss = wcid->tx_rate_nss;
+	} else {
+		txwi->rate = mt76x2_mac_tx_rate_val(dev, rate, &nss);
+		max_txpwr_adj = mt76x2_tx_get_max_txpwr_adj(dev, rate);
+	}
+	spin_unlock_bh(&dev->mt76.lock);
+
+	txpwr_adj = mt76x2_tx_get_txpwr_adj(dev, dev->txpower_conf,
+					    max_txpwr_adj);
+	txwi->ctl2 = FIELD_PREP(MT_TX_PWR_ADJ, txpwr_adj);
+
+	if (mt76xx_rev(dev) >= MT76XX_REV_E4)
+		txwi->txstream = 0x13;
+	else if (mt76xx_rev(dev) >= MT76XX_REV_E3 &&
+		 !(txwi->rate & cpu_to_le16(rate_ht_mask)))
+		txwi->txstream = 0x93;
+
+	if (info->flags & IEEE80211_TX_CTL_LDPC)
+		txwi->rate |= cpu_to_le16(MT_RXWI_RATE_LDPC);
+	if ((info->flags & IEEE80211_TX_CTL_STBC) && nss == 1)
+		txwi->rate |= cpu_to_le16(MT_RXWI_RATE_STBC);
+	if (nss > 1 && sta && sta->smps_mode == IEEE80211_SMPS_DYNAMIC)
+		txwi_flags |= MT_TXWI_FLAGS_MMPS;
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
+		txwi->ack_ctl |= MT_TXWI_ACK_CTL_REQ;
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+		txwi->ack_ctl |= MT_TXWI_ACK_CTL_NSEQ;
+	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
+		txwi->pktid |= MT_TXWI_PKTID_PROBE;
+	if ((info->flags & IEEE80211_TX_CTL_AMPDU) && sta) {
+		u8 ba_size = IEEE80211_MIN_AMPDU_BUF;
+
+		ba_size <<= sta->ht_cap.ampdu_factor;
+		ba_size = min_t(int, 63, ba_size - 1);
+		if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
+			ba_size = 0;
+		txwi->ack_ctl |= FIELD_PREP(MT_TXWI_ACK_CTL_BA_WINDOW, ba_size);
+
+		txwi_flags |= MT_TXWI_FLAGS_AMPDU |
+			 FIELD_PREP(MT_TXWI_FLAGS_MPDU_DENSITY,
+				    sta->ht_cap.ampdu_density);
+	}
+
+	txwi->flags |= cpu_to_le16(txwi_flags);
+	txwi->len_ctl = cpu_to_le16(skb->len);
+}
+
+static void mt76x2_remove_hdr_pad(struct sk_buff *skb)
+{
+	int len = ieee80211_get_hdrlen_from_skb(skb);
+
+	memmove(skb->data + 2, skb->data, len);
+	skb_pull(skb, 2);
+}
+
+int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
+			  void *rxi)
+{
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct mt76x2_rxwi *rxwi = rxi;
+	u32 ctl = le32_to_cpu(rxwi->ctl);
+	u16 rate = le16_to_cpu(rxwi->rate);
+	int len;
+
+	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_L2PAD))
+		mt76x2_remove_hdr_pad(skb);
+
+	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_DECRYPT)) {
+		status->flag |= RX_FLAG_DECRYPTED;
+		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
+	}
+
+	len = FIELD_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
+	if (WARN_ON_ONCE(len > skb->len))
+		return -EINVAL;
+
+	pskb_trim(skb, len);
+	status->chains = BIT(0) | BIT(1);
+	status->chain_signal[0] = mt76x2_phy_get_rssi(dev, rxwi->rssi[0], 0);
+	status->chain_signal[1] = mt76x2_phy_get_rssi(dev, rxwi->rssi[1], 1);
+	status->signal = max(status->chain_signal[0], status->chain_signal[1]);
+	status->freq = dev->mt76.chandef.chan->center_freq;
+	status->band = dev->mt76.chandef.chan->band;
+
+	mt76x2_mac_process_rate(status, rate);
+
+	return 0;
+}
+
+static void
+mt76x2_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
+			   enum nl80211_band band)
+{
+	u8 idx = FIELD_GET(MT_RXWI_RATE_INDEX, rate);
+
+	txrate->idx = 0;
+	txrate->flags = 0;
+	txrate->count = 1;
+
+	switch (FIELD_GET(MT_RXWI_RATE_PHY, rate)) {
+	case MT_PHY_TYPE_OFDM:
+		if (band == NL80211_BAND_2GHZ)
+			idx += 4;
+
+		txrate->idx = idx;
+		return;
+	case MT_PHY_TYPE_CCK:
+		if (idx >= 8)
+			idx -= 8;
+
+		txrate->idx = idx;
+		return;
+	case MT_PHY_TYPE_HT_GF:
+		txrate->flags |= IEEE80211_TX_RC_GREEN_FIELD;
+		/* fall through */
+	case MT_PHY_TYPE_HT:
+		txrate->flags |= IEEE80211_TX_RC_MCS;
+		txrate->idx = idx;
+		break;
+	case MT_PHY_TYPE_VHT:
+		txrate->flags |= IEEE80211_TX_RC_VHT_MCS;
+		txrate->idx = idx;
+		break;
+	default:
+		WARN_ON(1);
+		return;
+	}
+
+	switch (FIELD_GET(MT_RXWI_RATE_BW, rate)) {
+	case MT_PHY_BW_20:
+		break;
+	case MT_PHY_BW_40:
+		txrate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+		break;
+	case MT_PHY_BW_80:
+		txrate->flags |= IEEE80211_TX_RC_80_MHZ_WIDTH;
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	if (rate & MT_RXWI_RATE_SGI)
+		txrate->flags |= IEEE80211_TX_RC_SHORT_GI;
+}
+
+static void
+mt76x2_mac_fill_tx_status(struct mt76x2_dev *dev,
+			  struct ieee80211_tx_info *info,
+			  struct mt76x2_tx_status *st, int n_frames)
+{
+	struct ieee80211_tx_rate *rate = info->status.rates;
+	int cur_idx, last_rate;
+	int i;
+
+	last_rate = min_t(int, st->retry, IEEE80211_TX_MAX_RATES - 1);
+	mt76x2_mac_process_tx_rate(&rate[last_rate], st->rate,
+				 dev->mt76.chandef.chan->band);
+	if (last_rate < IEEE80211_TX_MAX_RATES - 1)
+		rate[last_rate + 1].idx = -1;
+
+	cur_idx = rate[last_rate].idx + st->retry;
+	for (i = 0; i <= last_rate; i++) {
+		rate[i].flags = rate[last_rate].flags;
+		rate[i].idx = max_t(int, 0, cur_idx - i);
+		rate[i].count = 1;
+	}
+
+	if (last_rate > 0)
+		rate[last_rate - 1].count = st->retry + 1 - last_rate;
+
+	info->status.ampdu_len = n_frames;
+	info->status.ampdu_ack_len = st->success ? n_frames : 0;
+
+	if (st->pktid & MT_TXWI_PKTID_PROBE)
+		info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
+
+	if (st->aggr)
+		info->flags |= IEEE80211_TX_CTL_AMPDU |
+			       IEEE80211_TX_STAT_AMPDU;
+
+	if (!st->ack_req)
+		info->flags |= IEEE80211_TX_CTL_NO_ACK;
+	else if (st->success)
+		info->flags |= IEEE80211_TX_STAT_ACK;
+}
+
+static void
+mt76x2_send_tx_status(struct mt76x2_dev *dev, struct mt76x2_tx_status *stat,
+		      u8 *update)
+{
+	struct ieee80211_tx_info info = {};
+	struct ieee80211_sta *sta = NULL;
+	struct mt76_wcid *wcid = NULL;
+	struct mt76x2_sta *msta = NULL;
+
+	rcu_read_lock();
+	if (stat->wcid < ARRAY_SIZE(dev->wcid))
+		wcid = rcu_dereference(dev->wcid[stat->wcid]);
+
+	if (wcid) {
+		void *priv;
+
+		priv = msta = container_of(wcid, struct mt76x2_sta, wcid);
+		sta = container_of(priv, struct ieee80211_sta,
+				   drv_priv);
+	}
+
+	if (msta && stat->aggr) {
+		u32 stat_val, stat_cache;
+
+		stat_val = stat->rate;
+		stat_val |= ((u32) stat->retry) << 16;
+		stat_cache = msta->status.rate;
+		stat_cache |= ((u32) msta->status.retry) << 16;
+
+		if (*update == 0 && stat_val == stat_cache &&
+		    stat->wcid == msta->status.wcid && ++msta->n_frames < 32)
+			goto out;
+
+		mt76x2_mac_fill_tx_status(dev, &info, &msta->status,
+					  msta->n_frames);
+
+		msta->status = *stat;
+		if (*update == 1) {
+			msta->n_frames = 1;
+			*update = 0;
+		} else {
+			msta->n_frames = 0;
+		}
+	} else {
+		mt76x2_mac_fill_tx_status(dev, &info, stat, 1);
+		*update = 1;
+	}
+
+	ieee80211_tx_status_noskb(mt76_hw(dev), sta, &info);
+
+out:
+	rcu_read_unlock();
+}
+
+void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq)
+{
+	struct mt76x2_tx_status stat = {};
+	unsigned long flags;
+	u8 update = 1;
+
+	if (!test_bit(MT76_STATE_RUNNING, &dev->mt76.state))
+		return;
+
+	trace_mac_txstat_poll(dev);
+
+	while (!irq || !kfifo_is_full(&dev->txstatus_fifo)) {
+		u32 stat1, stat2;
+
+		spin_lock_irqsave(&dev->irq_lock, flags);
+		stat2 = mt76_rr(dev, MT_TX_STAT_FIFO_EXT);
+		stat1 = mt76_rr(dev, MT_TX_STAT_FIFO);
+		if (!(stat1 & MT_TX_STAT_FIFO_VALID)) {
+			spin_unlock_irqrestore(&dev->irq_lock, flags);
+			break;
+		}
+
+		spin_unlock_irqrestore(&dev->irq_lock, flags);
+
+		stat.valid = 1;
+		stat.success = !!(stat1 & MT_TX_STAT_FIFO_SUCCESS);
+		stat.aggr = !!(stat1 & MT_TX_STAT_FIFO_AGGR);
+		stat.ack_req = !!(stat1 & MT_TX_STAT_FIFO_ACKREQ);
+		stat.wcid = FIELD_GET(MT_TX_STAT_FIFO_WCID, stat1);
+		stat.rate = FIELD_GET(MT_TX_STAT_FIFO_RATE, stat1);
+		stat.retry = FIELD_GET(MT_TX_STAT_FIFO_EXT_RETRY, stat2);
+		stat.pktid = FIELD_GET(MT_TX_STAT_FIFO_EXT_PKTID, stat2);
+		trace_mac_txstat_fetch(dev, &stat);
+
+		if (!irq) {
+			mt76x2_send_tx_status(dev, &stat, &update);
+			continue;
+		}
+
+		kfifo_put(&dev->txstatus_fifo, stat);
+	}
+}
+
+static void
+mt76x2_mac_queue_txdone(struct mt76x2_dev *dev, struct sk_buff *skb,
+			void *txwi_ptr)
+{
+	struct mt76x2_tx_info *txi = mt76x2_skb_tx_info(skb);
+	struct mt76x2_txwi *txwi = txwi_ptr;
+
+	mt76x2_mac_poll_tx_status(dev, false);
+
+	txi->tries = 0;
+	txi->jiffies = jiffies;
+	txi->wcid = txwi->wcid;
+	txi->pktid = txwi->pktid;
+	trace_mac_txdone_add(dev, txwi->wcid, txwi->pktid);
+	mt76x2_tx_complete(dev, skb);
+}
+
+void mt76x2_mac_process_tx_status_fifo(struct mt76x2_dev *dev)
+{
+	struct mt76x2_tx_status stat;
+	u8 update = 1;
+
+	while (kfifo_get(&dev->txstatus_fifo, &stat))
+		mt76x2_send_tx_status(dev, &stat, &update);
+}
+
+void mt76x2_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
+			    struct mt76_queue_entry *e, bool flush)
+{
+	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+
+	if (e->txwi)
+		mt76x2_mac_queue_txdone(dev, e->skb, &e->txwi->txwi);
+	else
+		dev_kfree_skb_any(e->skb);
+}
+
+static enum mt76x2_cipher_type
+mt76x2_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
+{
+	memset(key_data, 0, 32);
+	if (!key)
+		return MT_CIPHER_NONE;
+
+	if (key->keylen > 32)
+		return MT_CIPHER_NONE;
+
+	memcpy(key_data, key->key, key->keylen);
+
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+		return MT_CIPHER_WEP40;
+	case WLAN_CIPHER_SUITE_WEP104:
+		return MT_CIPHER_WEP104;
+	case WLAN_CIPHER_SUITE_TKIP:
+		return MT_CIPHER_TKIP;
+	case WLAN_CIPHER_SUITE_CCMP:
+		return MT_CIPHER_AES_CCMP;
+	default:
+		return MT_CIPHER_NONE;
+	}
+}
+
+void mt76x2_mac_wcid_setup(struct mt76x2_dev *dev, u8 idx, u8 vif_idx, u8 *mac)
+{
+	struct mt76_wcid_addr addr = {};
+	u32 attr;
+
+	attr = FIELD_PREP(MT_WCID_ATTR_BSS_IDX, vif_idx & 7) |
+	       FIELD_PREP(MT_WCID_ATTR_BSS_IDX_EXT, !!(vif_idx & 8));
+
+	mt76_wr(dev, MT_WCID_ATTR(idx), attr);
+
+	if (mac)
+		memcpy(addr.macaddr, mac, ETH_ALEN);
+
+	mt76_wr_copy(dev, MT_WCID_ADDR(idx), &addr, sizeof(addr));
+}
+
+int mt76x2_mac_wcid_set_key(struct mt76x2_dev *dev, u8 idx,
+			    struct ieee80211_key_conf *key)
+{
+	enum mt76x2_cipher_type cipher;
+	u8 key_data[32];
+	u8 iv_data[8];
+
+	cipher = mt76x2_mac_get_key_info(key, key_data);
+	if (cipher == MT_CIPHER_NONE && key)
+		return -EINVAL;
+
+	mt76_rmw_field(dev, MT_WCID_ATTR(idx), MT_WCID_ATTR_PKEY_MODE, cipher);
+	mt76_wr_copy(dev, MT_WCID_KEY(idx), key_data, sizeof(key_data));
+
+	memset(iv_data, 0, sizeof(iv_data));
+	if (key) {
+		mt76_rmw_field(dev, MT_WCID_ATTR(idx), MT_WCID_ATTR_PAIRWISE,
+			       !!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE));
+		iv_data[3] = key->keyidx << 6;
+		if (cipher >= MT_CIPHER_TKIP)
+			iv_data[3] |= 0x20;
+	}
+
+	mt76_wr_copy(dev, MT_WCID_IV(idx), iv_data, sizeof(iv_data));
+
+	return 0;
+}
+
+int mt76x2_mac_shared_key_setup(struct mt76x2_dev *dev, u8 vif_idx, u8 key_idx,
+			      struct ieee80211_key_conf *key)
+{
+	enum mt76x2_cipher_type cipher;
+	u8 key_data[32];
+	u32 val;
+
+	cipher = mt76x2_mac_get_key_info(key, key_data);
+	if (cipher == MT_CIPHER_NONE && key)
+		return -EINVAL;
+
+	val = mt76_rr(dev, MT_SKEY_MODE(vif_idx));
+	val &= ~(MT_SKEY_MODE_MASK << MT_SKEY_MODE_SHIFT(vif_idx, key_idx));
+	val |= cipher << MT_SKEY_MODE_SHIFT(vif_idx, key_idx);
+	mt76_wr(dev, MT_SKEY_MODE(vif_idx), val);
+
+	mt76_wr_copy(dev, MT_SKEY(vif_idx, key_idx), key_data,
+		     sizeof(key_data));
+
+	return 0;
+}
+
+static int
+mt76_write_beacon(struct mt76x2_dev *dev, int offset, struct sk_buff *skb)
+{
+	int beacon_len = dev->beacon_offsets[1] - dev->beacon_offsets[0];
+	struct mt76x2_txwi txwi;
+
+	if (WARN_ON_ONCE(beacon_len < skb->len + sizeof(struct mt76x2_txwi)))
+		return -ENOSPC;
+
+	mt76x2_mac_write_txwi(dev, &txwi, skb, NULL, NULL);
+	txwi.flags |= cpu_to_le16(MT_TXWI_FLAGS_TS);
+
+	mt76_wr_copy(dev, offset, &txwi, sizeof(txwi));
+	offset += sizeof(txwi);
+
+	mt76_wr_copy(dev, offset, skb->data, skb->len);
+	return 0;
+}
+
+static int
+__mt76x2_mac_set_beacon(struct mt76x2_dev *dev, u8 bcn_idx, struct sk_buff *skb)
+{
+	int beacon_len = dev->beacon_offsets[1] - dev->beacon_offsets[0];
+	int beacon_addr = dev->beacon_offsets[bcn_idx];
+	int ret = 0;
+	int i;
+
+	/* Prevent corrupt transmissions during update */
+	mt76_set(dev, MT_BCN_BYPASS_MASK, BIT(bcn_idx));
+
+	if (skb) {
+		ret = mt76_write_beacon(dev, beacon_addr, skb);
+		if (!ret)
+			dev->beacon_data_mask |= BIT(bcn_idx) &
+						 dev->beacon_mask;
+	} else {
+		dev->beacon_data_mask &= ~BIT(bcn_idx);
+		for (i = 0; i < beacon_len; i += 4)
+			mt76_wr(dev, beacon_addr + i, 0);
+	}
+
+	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xff00 | ~dev->beacon_data_mask);
+
+	return ret;
+}
+
+int mt76x2_mac_set_beacon(struct mt76x2_dev *dev, u8 vif_idx,
+			  struct sk_buff *skb)
+{
+	bool force_update = false;
+	int bcn_idx = 0;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dev->beacons); i++) {
+		if (vif_idx == i) {
+			force_update = !!dev->beacons[i] ^ !!skb;
+
+			if (dev->beacons[i])
+				dev_kfree_skb(dev->beacons[i]);
+
+			dev->beacons[i] = skb;
+			__mt76x2_mac_set_beacon(dev, bcn_idx, skb);
+		} else if (force_update && dev->beacons[i]) {
+			__mt76x2_mac_set_beacon(dev, bcn_idx, dev->beacons[i]);
+		}
+
+		bcn_idx += !!dev->beacons[i];
+	}
+
+	for (i = bcn_idx; i < ARRAY_SIZE(dev->beacons); i++) {
+		if (!(dev->beacon_data_mask & BIT(i)))
+			break;
+
+		__mt76x2_mac_set_beacon(dev, i, NULL);
+	}
+
+	mt76_rmw_field(dev, MT_MAC_BSSID_DW1, MT_MAC_BSSID_DW1_MBEACON_N,
+		       bcn_idx - 1);
+	return 0;
+}
+
+void mt76x2_mac_set_beacon_enable(struct mt76x2_dev *dev, u8 vif_idx, bool val)
+{
+	u8 old_mask = dev->beacon_mask;
+	bool en;
+	u32 reg;
+
+	if (val) {
+		dev->beacon_mask |= BIT(vif_idx);
+	} else {
+		dev->beacon_mask &= ~BIT(vif_idx);
+		mt76x2_mac_set_beacon(dev, vif_idx, NULL);
+	}
+
+	if (!!old_mask == !!dev->beacon_mask)
+		return;
+
+	en = dev->beacon_mask;
+
+	mt76_rmw_field(dev, MT_INT_TIMER_EN, MT_INT_TIMER_EN_PRE_TBTT_EN, en);
+	reg = MT_BEACON_TIME_CFG_BEACON_TX |
+	      MT_BEACON_TIME_CFG_TBTT_EN |
+	      MT_BEACON_TIME_CFG_TIMER_EN;
+	mt76_rmw(dev, MT_BEACON_TIME_CFG, reg, reg * en);
+
+	if (en)
+		mt76x2_irq_enable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
+	else
+		mt76x2_irq_disable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
+}
+
+void mt76x2_update_channel(struct mt76_dev *mdev)
+{
+	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+	struct mt76_channel_state *state;
+	u32 active, busy;
+
+	state = mt76_channel_state(&dev->mt76, dev->mt76.chandef.chan);
+
+	busy = mt76_rr(dev, MT_CH_BUSY);
+	active = busy + mt76_rr(dev, MT_CH_IDLE);
+
+	spin_lock_bh(&dev->mt76.cc_lock);
+	state->cc_busy += busy;
+	state->cc_active += active;
+	spin_unlock_bh(&dev->mt76.cc_lock);
+}
+
+void mt76x2_mac_work(struct work_struct *work)
+{
+	struct mt76x2_dev *dev = container_of(work, struct mt76x2_dev,
+					    mac_work.work);
+	int i, idx;
+
+	mt76x2_update_channel(&dev->mt76);
+	for (i = 0, idx = 0; i < 16; i++) {
+		u32 val = mt76_rr(dev, MT_TX_AGG_CNT(i));
+
+		dev->aggr_stats[idx++] += val & 0xffff;
+		dev->aggr_stats[idx++] += val >> 16;
+	}
+
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
+				     MT_CALIBRATE_INTERVAL);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
new file mode 100644
index 0000000..3012880
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
@@ -0,0 +1,189 @@
+/*
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
+#ifndef __MT76x2_MAC_H
+#define __MT76x2_MAC_H
+
+#include "mt76.h"
+
+struct mt76x2_dev;
+struct mt76x2_sta;
+struct mt76x2_vif;
+struct mt76x2_txwi;
+
+struct mt76x2_tx_status {
+	u8 valid:1;
+	u8 success:1;
+	u8 aggr:1;
+	u8 ack_req:1;
+	u8 wcid;
+	u8 pktid;
+	u8 retry;
+	u16 rate;
+} __packed __aligned(2);
+
+struct mt76x2_tx_info {
+	unsigned long jiffies;
+	u8 tries;
+
+	u8 wcid;
+	u8 pktid;
+	u8 retry;
+};
+
+struct mt76x2_rxwi {
+	__le32 rxinfo;
+
+	__le32 ctl;
+
+	__le16 tid_sn;
+	__le16 rate;
+
+	u8 rssi[4];
+
+	__le32 bbp_rxinfo[4];
+};
+
+#define MT_RXINFO_BA			BIT(0)
+#define MT_RXINFO_DATA			BIT(1)
+#define MT_RXINFO_NULL			BIT(2)
+#define MT_RXINFO_FRAG			BIT(3)
+#define MT_RXINFO_UNICAST		BIT(4)
+#define MT_RXINFO_MULTICAST		BIT(5)
+#define MT_RXINFO_BROADCAST		BIT(6)
+#define MT_RXINFO_MYBSS			BIT(7)
+#define MT_RXINFO_CRCERR		BIT(8)
+#define MT_RXINFO_ICVERR		BIT(9)
+#define MT_RXINFO_MICERR		BIT(10)
+#define MT_RXINFO_AMSDU			BIT(11)
+#define MT_RXINFO_HTC			BIT(12)
+#define MT_RXINFO_RSSI			BIT(13)
+#define MT_RXINFO_L2PAD			BIT(14)
+#define MT_RXINFO_AMPDU			BIT(15)
+#define MT_RXINFO_DECRYPT		BIT(16)
+#define MT_RXINFO_BSSIDX3		BIT(17)
+#define MT_RXINFO_WAPI_KEY		BIT(18)
+#define MT_RXINFO_PN_LEN		GENMASK(21, 19)
+#define MT_RXINFO_SW_FTYPE0		BIT(22)
+#define MT_RXINFO_SW_FTYPE1		BIT(23)
+#define MT_RXINFO_PROBE_RESP		BIT(24)
+#define MT_RXINFO_BEACON		BIT(25)
+#define MT_RXINFO_DISASSOC		BIT(26)
+#define MT_RXINFO_DEAUTH		BIT(27)
+#define MT_RXINFO_ACTION		BIT(28)
+#define MT_RXINFO_TCP_SUM_ERR		BIT(30)
+#define MT_RXINFO_IP_SUM_ERR		BIT(31)
+
+#define MT_RXWI_CTL_WCID		GENMASK(7, 0)
+#define MT_RXWI_CTL_KEY_IDX		GENMASK(9, 8)
+#define MT_RXWI_CTL_BSS_IDX		GENMASK(12, 10)
+#define MT_RXWI_CTL_UDF			GENMASK(15, 13)
+#define MT_RXWI_CTL_MPDU_LEN		GENMASK(29, 16)
+#define MT_RXWI_CTL_EOF			BIT(31)
+
+#define MT_RXWI_TID			GENMASK(3, 0)
+#define MT_RXWI_SN			GENMASK(15, 4)
+
+#define MT_RXWI_RATE_INDEX		GENMASK(5, 0)
+#define MT_RXWI_RATE_LDPC		BIT(6)
+#define MT_RXWI_RATE_BW			GENMASK(8, 7)
+#define MT_RXWI_RATE_SGI		BIT(9)
+#define MT_RXWI_RATE_STBC		BIT(10)
+#define MT_RXWI_RATE_LDPC_EXSYM		BIT(11)
+#define MT_RXWI_RATE_PHY		GENMASK(15, 13)
+
+#define MT_RATE_INDEX_VHT_IDX		GENMASK(3, 0)
+#define MT_RATE_INDEX_VHT_NSS		GENMASK(5, 4)
+
+#define MT_TX_PWR_ADJ			GENMASK(3, 0)
+
+enum mt76x2_phy_bandwidth {
+	MT_PHY_BW_20,
+	MT_PHY_BW_40,
+	MT_PHY_BW_80,
+};
+
+#define MT_TXWI_FLAGS_FRAG		BIT(0)
+#define MT_TXWI_FLAGS_MMPS		BIT(1)
+#define MT_TXWI_FLAGS_CFACK		BIT(2)
+#define MT_TXWI_FLAGS_TS		BIT(3)
+#define MT_TXWI_FLAGS_AMPDU		BIT(4)
+#define MT_TXWI_FLAGS_MPDU_DENSITY	GENMASK(7, 5)
+#define MT_TXWI_FLAGS_TXOP		GENMASK(9, 8)
+#define MT_TXWI_FLAGS_NDPS		BIT(10)
+#define MT_TXWI_FLAGS_RTSBWSIG		BIT(11)
+#define MT_TXWI_FLAGS_NDP_BW		GENMASK(13, 12)
+#define MT_TXWI_FLAGS_SOUND		BIT(14)
+#define MT_TXWI_FLAGS_TX_RATE_LUT	BIT(15)
+
+#define MT_TXWI_ACK_CTL_REQ		BIT(0)
+#define MT_TXWI_ACK_CTL_NSEQ		BIT(1)
+#define MT_TXWI_ACK_CTL_BA_WINDOW	GENMASK(7, 2)
+
+#define MT_TXWI_PKTID_PROBE		BIT(7)
+
+struct mt76x2_txwi {
+	__le16 flags;
+	__le16 rate;
+	u8 ack_ctl;
+	u8 wcid;
+	__le16 len_ctl;
+	__le32 iv;
+	__le32 eiv;
+	u8 aid;
+	u8 txstream;
+	u8 ctl2;
+	u8 pktid;
+} __packed __aligned(4);
+
+static inline struct mt76x2_tx_info *
+mt76x2_skb_tx_info(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	return (void *) info->status.status_driver_data;
+}
+
+int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard);
+int mt76x2_mac_start(struct mt76x2_dev *dev);
+void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force);
+void mt76x2_mac_resume(struct mt76x2_dev *dev);
+void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr);
+
+int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
+			  void *rxwi);
+void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
+			   struct sk_buff *skb, struct mt76_wcid *wcid,
+			   struct ieee80211_sta *sta);
+void mt76x2_mac_wcid_setup(struct mt76x2_dev *dev, u8 idx, u8 vif_idx, u8 *mac);
+int mt76x2_mac_wcid_set_key(struct mt76x2_dev *dev, u8 idx,
+			    struct ieee80211_key_conf *key);
+void mt76x2_mac_wcid_set_rate(struct mt76x2_dev *dev, struct mt76_wcid *wcid,
+			      const struct ieee80211_tx_rate *rate);
+
+int mt76x2_mac_shared_key_setup(struct mt76x2_dev *dev, u8 vif_idx, u8 key_idx,
+				struct ieee80211_key_conf *key);
+
+int mt76x2_mac_set_beacon(struct mt76x2_dev *dev, u8 vif_idx,
+			  struct sk_buff *skb);
+void mt76x2_mac_set_beacon_enable(struct mt76x2_dev *dev, u8 vif_idx, bool val);
+
+void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq);
+void mt76x2_mac_process_tx_status_fifo(struct mt76x2_dev *dev);
+
+void mt76x2_mac_work(struct work_struct *work);
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
new file mode 100644
index 0000000..1cd648e
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -0,0 +1,532 @@
+/*
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
+#include "mt76x2.h"
+
+static int
+mt76x2_start(struct ieee80211_hw *hw)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	int ret;
+
+	mutex_lock(&dev->mutex);
+
+	ret = mt76x2_mac_start(dev);
+	if (ret)
+		goto out;
+
+	ret = mt76x2_phy_start(dev);
+	if (ret)
+		goto out;
+
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
+				     MT_CALIBRATE_INTERVAL);
+
+	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+
+out:
+	mutex_unlock(&dev->mutex);
+	return ret;
+}
+
+static void
+mt76x2_stop(struct ieee80211_hw *hw)
+{
+	struct mt76x2_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mutex);
+	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+	mt76x2_stop_hardware(dev);
+	mutex_unlock(&dev->mutex);
+}
+
+static void
+mt76x2_txq_init(struct mt76x2_dev *dev, struct ieee80211_txq *txq)
+{
+	struct mt76_txq *mtxq;
+
+	if (!txq)
+		return;
+
+	mtxq = (struct mt76_txq *) txq->drv_priv;
+	if (txq->sta) {
+		struct mt76x2_sta *sta;
+
+		sta = (struct mt76x2_sta *) txq->sta->drv_priv;
+		mtxq->wcid = &sta->wcid;
+	} else {
+		struct mt76x2_vif *mvif;
+
+		mvif = (struct mt76x2_vif *) txq->vif->drv_priv;
+		mtxq->wcid = &mvif->group_wcid;
+	}
+
+	mt76_txq_init(&dev->mt76, txq);
+}
+
+static int
+mt76x2_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+	unsigned int idx = 0;
+	int ret = 0;
+
+	if (vif->addr[0] & BIT(1))
+		idx = 1 + (((dev->mt76.macaddr[0] ^ vif->addr[0]) >> 2) & 7);
+
+	/*
+	 * Client mode typically only has one configurable BSSID register,
+	 * which is used for bssidx=0. This is linked to the MAC address.
+	 * Since mac80211 allows changing interface types, and we cannot
+	 * force the use of the primary MAC address for a station mode
+	 * interface, we need some other way of configuring a per-interface
+	 * remote BSSID.
+	 * The hardware provides an AP-Client feature, where bssidx 0-7 are
+	 * used for AP mode and bssidx 8-15 for client mode.
+	 * We shift the station interface bss index by 8 to force the
+	 * hardware to recognize the BSSID.
+	 * The resulting bssidx mismatch for unicast frames is ignored by hw.
+	 */
+	if (vif->type == NL80211_IFTYPE_STATION)
+		idx += 8;
+
+	mvif->idx = idx;
+	mvif->group_wcid.idx = 254 - idx;
+	mvif->group_wcid.hw_key_idx = -1;
+	mt76x2_txq_init(dev, vif->txq);
+
+	return ret;
+}
+
+static void
+mt76x2_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct mt76x2_dev *dev = hw->priv;
+
+	mt76_txq_remove(&dev->mt76, vif->txq);
+}
+
+static int
+mt76x2_set_channel(struct mt76x2_dev *dev, struct cfg80211_chan_def *chandef)
+{
+	int ret;
+
+	mt76_set_channel(&dev->mt76);
+
+	tasklet_disable(&dev->pre_tbtt_tasklet);
+	cancel_delayed_work_sync(&dev->cal_work);
+
+	mt76x2_mac_stop(dev, true);
+	ret = mt76x2_phy_set_channel(dev, chandef);
+
+	/* channel cycle counters read-and-clear */
+	mt76_rr(dev, MT_CH_IDLE);
+	mt76_rr(dev, MT_CH_BUSY);
+
+	mt76x2_mac_resume(dev);
+	tasklet_enable(&dev->pre_tbtt_tasklet);
+
+	return ret;
+}
+
+static int
+mt76x2_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	int ret = 0;
+
+	mutex_lock(&dev->mutex);
+
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		dev->txpower_conf = hw->conf.power_level * 2;
+
+		if (test_bit(MT76_STATE_RUNNING, &dev->mt76.state)) {
+			mt76x2_phy_set_txpower(dev);
+			mt76x2_tx_set_txpwr_auto(dev, dev->txpower_conf);
+		}
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		ieee80211_stop_queues(hw);
+		ret = mt76x2_set_channel(dev, &hw->conf.chandef);
+		ieee80211_wake_queues(hw);
+	}
+
+	mutex_unlock(&dev->mutex);
+
+	return ret;
+}
+
+static void
+mt76x2_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
+			unsigned int *total_flags, u64 multicast)
+{
+	struct mt76x2_dev *dev = hw->priv;
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
+	mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+
+	mutex_unlock(&dev->mutex);
+}
+
+static void
+mt76x2_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			struct ieee80211_bss_conf *info, u32 changed)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+
+	mutex_lock(&dev->mutex);
+
+	if (changed & BSS_CHANGED_BSSID)
+		mt76x2_mac_set_bssid(dev, mvif->idx, info->bssid);
+
+	if (changed & BSS_CHANGED_BEACON_INT)
+		mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
+			       MT_BEACON_TIME_CFG_INTVAL,
+			       info->beacon_int << 4);
+
+	if (changed & BSS_CHANGED_BEACON_ENABLED) {
+		tasklet_disable(&dev->pre_tbtt_tasklet);
+		mt76x2_mac_set_beacon_enable(dev, mvif->idx,
+					     info->enable_beacon);
+		tasklet_enable(&dev->pre_tbtt_tasklet);
+	}
+
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		int slottime = info->use_short_slot ? 9 : 20;
+
+		dev->slottime = slottime;
+		mt76_rmw_field(dev, MT_BKOFF_SLOT_CFG,
+			       MT_BKOFF_SLOT_CFG_SLOTTIME, slottime);
+	}
+
+	mutex_unlock(&dev->mutex);
+}
+
+static int
+mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+	       struct ieee80211_sta *sta)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
+	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+	int ret = 0;
+	int idx = 0;
+	int i;
+
+	mutex_lock(&dev->mutex);
+
+	idx = mt76_wcid_alloc(dev->wcid_mask, ARRAY_SIZE(dev->wcid));
+	if (idx < 0) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	msta->wcid.idx = idx;
+	msta->wcid.hw_key_idx = -1;
+	mt76x2_mac_wcid_setup(dev, idx, mvif->idx, sta->addr);
+	mt76_clear(dev, MT_WCID_DROP(idx), MT_WCID_DROP_MASK(idx));
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+		mt76x2_txq_init(dev, sta->txq[i]);
+
+	rcu_assign_pointer(dev->wcid[idx], &msta->wcid);
+
+out:
+	mutex_unlock(&dev->mutex);
+
+	return ret;
+}
+
+static int
+mt76x2_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  struct ieee80211_sta *sta)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
+	int idx = msta->wcid.idx;
+	int i;
+
+	mutex_lock(&dev->mutex);
+	rcu_assign_pointer(dev->wcid[idx], NULL);
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+		mt76_txq_remove(&dev->mt76, sta->txq[i]);
+	mt76_set(dev, MT_WCID_DROP(idx), MT_WCID_DROP_MASK(idx));
+	mt76_wcid_free(dev->wcid_mask, idx);
+	mt76x2_mac_wcid_setup(dev, idx, 0, NULL);
+	mutex_unlock(&dev->mutex);
+
+	return 0;
+}
+
+static void
+mt76x2_sta_notify(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  enum sta_notify_cmd cmd, struct ieee80211_sta *sta)
+{
+	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
+	struct mt76x2_dev *dev = hw->priv;
+	int idx = msta->wcid.idx;
+
+	switch (cmd) {
+	case STA_NOTIFY_SLEEP:
+		mt76_set(dev, MT_WCID_DROP(idx), MT_WCID_DROP_MASK(idx));
+		mt76_stop_tx_queues(&dev->mt76, sta, true);
+		break;
+	case STA_NOTIFY_AWAKE:
+		mt76_clear(dev, MT_WCID_DROP(idx), MT_WCID_DROP_MASK(idx));
+		break;
+	}
+}
+
+static int
+mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+	       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+	       struct ieee80211_key_conf *key)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+	struct mt76x2_sta *msta;
+	struct mt76_wcid *wcid;
+	int idx = key->keyidx;
+	int ret;
+
+	msta = sta ? (struct mt76x2_sta *) sta->drv_priv : NULL;
+	wcid = msta ? &msta->wcid : &mvif->group_wcid;
+
+	if (cmd == SET_KEY) {
+		key->hw_key_idx = wcid->idx;
+		wcid->hw_key_idx = idx;
+	} else {
+		if (idx == wcid->hw_key_idx)
+			wcid->hw_key_idx = -1;
+
+		key = NULL;
+	}
+
+	if (!msta) {
+		if (key || wcid->hw_key_idx == idx) {
+			ret = mt76x2_mac_wcid_set_key(dev, wcid->idx, key);
+			if (ret)
+				return ret;
+		}
+
+		return mt76x2_mac_shared_key_setup(dev, mvif->idx, idx, key);
+	}
+
+	return mt76x2_mac_wcid_set_key(dev, msta->wcid.idx, key);
+}
+
+static int
+mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u16 queue,
+	       const struct ieee80211_tx_queue_params *params)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	u8 cw_min = 5, cw_max = 10;
+	u32 val;
+
+	if (params->cw_min)
+		cw_min = fls(params->cw_min);
+	if (params->cw_max)
+		cw_max = fls(params->cw_max);
+
+	val = FIELD_PREP(MT_EDCA_CFG_TXOP, params->txop) |
+	      FIELD_PREP(MT_EDCA_CFG_AIFSN, params->aifs) |
+	      FIELD_PREP(MT_EDCA_CFG_CWMIN, cw_min) |
+	      FIELD_PREP(MT_EDCA_CFG_CWMAX, cw_max);
+	mt76_wr(dev, MT_EDCA_CFG_AC(queue), val);
+
+	val = mt76_rr(dev, MT_WMM_TXOP(queue));
+	val &= ~(MT_WMM_TXOP_MASK << MT_WMM_TXOP_SHIFT(queue));
+	val |= params->txop << MT_WMM_TXOP_SHIFT(queue);
+	mt76_wr(dev, MT_WMM_TXOP(queue), val);
+
+	val = mt76_rr(dev, MT_WMM_AIFSN);
+	val &= ~(MT_WMM_AIFSN_MASK << MT_WMM_AIFSN_SHIFT(queue));
+	val |= params->aifs << MT_WMM_AIFSN_SHIFT(queue);
+	mt76_wr(dev, MT_WMM_AIFSN, val);
+
+	val = mt76_rr(dev, MT_WMM_CWMIN);
+	val &= ~(MT_WMM_CWMIN_MASK << MT_WMM_CWMIN_SHIFT(queue));
+	val |= cw_min << MT_WMM_CWMIN_SHIFT(queue);
+	mt76_wr(dev, MT_WMM_CWMIN, val);
+
+	val = mt76_rr(dev, MT_WMM_CWMAX);
+	val &= ~(MT_WMM_CWMAX_MASK << MT_WMM_CWMAX_SHIFT(queue));
+	val |= cw_max << MT_WMM_CWMAX_SHIFT(queue);
+	mt76_wr(dev, MT_WMM_CWMAX, val);
+
+	return 0;
+}
+
+static void
+mt76x2_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+	       const u8 *mac)
+{
+	struct mt76x2_dev *dev = hw->priv;
+
+	tasklet_disable(&dev->pre_tbtt_tasklet);
+	set_bit(MT76_SCANNING, &dev->mt76.state);
+}
+
+static void
+mt76x2_sw_scan_complete(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct mt76x2_dev *dev = hw->priv;
+
+	clear_bit(MT76_SCANNING, &dev->mt76.state);
+	tasklet_enable(&dev->pre_tbtt_tasklet);
+	mt76_txq_schedule_all(&dev->mt76);
+}
+
+static void
+mt76x2_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+	     u32 queues, bool drop)
+{
+}
+
+static int
+mt76x2_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif, int *dbm)
+{
+	struct mt76x2_dev *dev = hw->priv;
+
+	*dbm = dev->txpower_cur / 2;
+	return 0;
+}
+
+static int
+mt76x2_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		    struct ieee80211_ampdu_params *params)
+{
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	struct ieee80211_sta *sta = params->sta;
+	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
+	struct ieee80211_txq *txq = sta->txq[params->tid];
+	struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
+
+	if (!txq)
+		return -EINVAL;
+
+	switch (action) {
+	case IEEE80211_AMPDU_RX_START:
+		mt76_set(dev, MT_WCID_ADDR(msta->wcid.idx) + 4, BIT(16 + tid));
+		break;
+	case IEEE80211_AMPDU_RX_STOP:
+		mt76_clear(dev, MT_WCID_ADDR(msta->wcid.idx) + 4,
+			   BIT(16 + tid));
+		break;
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		mtxq->aggr = true;
+		mtxq->send_bar = false;
+		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
+		break;
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
+		mtxq->aggr = false;
+		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
+		break;
+	case IEEE80211_AMPDU_TX_START:
+		mtxq->agg_ssn = *ssn << 4;
+		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+		mtxq->aggr = false;
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	}
+
+	return 0;
+}
+
+static void
+mt76x2_sta_rate_tbl_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x2_sta *msta = (struct mt76x2_sta *) sta->drv_priv;
+	struct ieee80211_sta_rates *rates = rcu_dereference(sta->rates);
+	struct ieee80211_tx_rate rate = {};
+
+	if (!rates)
+		return;
+
+	rate.idx = rates->rate[0].idx;
+	rate.flags = rates->rate[0].flags;
+	mt76x2_mac_wcid_set_rate(dev, &msta->wcid, &rate);
+	msta->wcid.max_txpwr_adj = mt76x2_tx_get_max_txpwr_adj(dev, &rate);
+}
+
+static void mt76x2_set_coverage_class(struct ieee80211_hw *hw,
+				      s16 coverage_class)
+{
+	struct mt76x2_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mutex);
+	dev->coverage_class = coverage_class;
+	mt76x2_set_tx_ackto(dev);
+	mutex_unlock(&dev->mutex);
+}
+
+const struct ieee80211_ops mt76x2_ops = {
+	.tx = mt76x2_tx,
+	.start = mt76x2_start,
+	.stop = mt76x2_stop,
+	.add_interface = mt76x2_add_interface,
+	.remove_interface = mt76x2_remove_interface,
+	.config = mt76x2_config,
+	.configure_filter = mt76x2_configure_filter,
+	.bss_info_changed = mt76x2_bss_info_changed,
+	.sta_add = mt76x2_sta_add,
+	.sta_remove = mt76x2_sta_remove,
+	.sta_notify = mt76x2_sta_notify,
+	.set_key = mt76x2_set_key,
+	.conf_tx = mt76x2_conf_tx,
+	.sw_scan_start = mt76x2_sw_scan,
+	.sw_scan_complete = mt76x2_sw_scan_complete,
+	.flush = mt76x2_flush,
+	.ampdu_action = mt76x2_ampdu_action,
+	.get_txpower = mt76x2_get_txpower,
+	.wake_tx_queue = mt76_wake_tx_queue,
+	.sta_rate_tbl_update = mt76x2_sta_rate_tbl_update,
+	.release_buffered_frames = mt76_release_buffered_frames,
+	.set_coverage_class = mt76x2_set_coverage_class,
+	.get_survey = mt76_get_survey,
+};
+
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
new file mode 100644
index 0000000..4c94f84
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
@@ -0,0 +1,452 @@
+/*
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
+#include <linux/kernel.h>
+#include <linux/firmware.h>
+#include <linux/delay.h>
+
+#include "mt76x2.h"
+#include "mt76x2_mcu.h"
+#include "mt76x2_dma.h"
+#include "mt76x2_eeprom.h"
+
+struct mt76x2_fw_header {
+	__le32 ilm_len;
+	__le32 dlm_len;
+	__le16 build_ver;
+	__le16 fw_ver;
+	u8 pad[4];
+	char build_time[16];
+};
+
+struct mt76x2_patch_header {
+	char build_time[16];
+	char platform[4];
+	char hw_version[4];
+	char patch_version[4];
+	u8 pad[2];
+};
+
+static struct sk_buff *
+mt76x2_mcu_msg_alloc(struct mt76x2_dev *dev, const void *data, int len)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb(len, GFP_KERNEL);
+	memcpy(skb_put(skb, len), data, len);
+
+	return skb;
+}
+
+static struct sk_buff *
+mt76x2_mcu_get_response(struct mt76x2_dev *dev, unsigned long expires)
+{
+	unsigned long timeout;
+
+	if (!time_is_after_jiffies(expires))
+		return NULL;
+
+	timeout = expires - jiffies;
+	wait_event_timeout(dev->mcu.wait, !skb_queue_empty(&dev->mcu.res_q),
+			   timeout);
+	return skb_dequeue(&dev->mcu.res_q);
+}
+
+static int
+mt76x2_mcu_msg_send(struct mt76x2_dev *dev, struct sk_buff *skb,
+		    enum mcu_cmd cmd)
+{
+	unsigned long expires = jiffies + HZ;
+	int ret;
+	u8 seq;
+
+	if (!skb)
+		return -EINVAL;
+
+	mutex_lock(&dev->mcu.mutex);
+
+	seq = ++dev->mcu.msg_seq & 0xf;
+	if (!seq)
+		seq = ++dev->mcu.msg_seq & 0xf;
+
+	ret = mt76x2_tx_queue_mcu(dev, MT_TXQ_MCU, skb, cmd, seq);
+	if (ret)
+		goto out;
+
+	while (1) {
+		u32 *rxfce;
+		bool check_seq = false;
+
+		skb = mt76x2_mcu_get_response(dev, expires);
+		if (!skb) {
+			dev_err(dev->mt76.dev,
+				"MCU message %d (seq %d) timed out\n", cmd,
+				seq);
+			ret = -ETIMEDOUT;
+			break;
+		}
+
+		rxfce = (u32 *) skb->cb;
+
+		if (seq == FIELD_GET(MT_RX_FCE_INFO_CMD_SEQ, *rxfce))
+			check_seq = true;
+
+		dev_kfree_skb(skb);
+		if (check_seq)
+			break;
+	}
+
+out:
+	mutex_unlock(&dev->mcu.mutex);
+
+	return ret;
+}
+
+static int
+mt76pci_load_rom_patch(struct mt76x2_dev *dev)
+{
+	const struct firmware *fw = NULL;
+	struct mt76x2_patch_header *hdr;
+	bool rom_protect = !is_mt7612(dev);
+	int len, ret = 0;
+	__le32 *cur;
+	u32 patch_mask, patch_reg;
+
+	if (rom_protect && !mt76_poll(dev, MT_MCU_SEMAPHORE_03, 1, 1, 600)) {
+		dev_err(dev->mt76.dev,
+			"Could not get hardware semaphore for ROM PATCH\n");
+		return -ETIMEDOUT;
+	}
+
+	if (mt76xx_rev(dev) >= MT76XX_REV_E3) {
+		patch_mask = BIT(0);
+		patch_reg = MT_MCU_CLOCK_CTL;
+	} else {
+		patch_mask = BIT(1);
+		patch_reg = MT_MCU_COM_REG0;
+	}
+
+	if (rom_protect && (mt76_rr(dev, patch_reg) & patch_mask)) {
+		dev_info(dev->mt76.dev, "ROM patch already applied\n");
+		goto out;
+	}
+
+	ret = request_firmware(&fw, MT7662_ROM_PATCH, dev->mt76.dev);
+	if (ret)
+		goto out;
+
+	if (!fw || !fw->data || fw->size <= sizeof(*hdr)) {
+		ret = -EIO;
+		dev_err(dev->mt76.dev, "Failed to load firmware\n");
+		goto out;
+	}
+
+	hdr = (struct mt76x2_patch_header *) fw->data;
+	dev_info(dev->mt76.dev, "ROM patch build: %.15s\n", hdr->build_time);
+
+	mt76_wr(dev, MT_MCU_PCIE_REMAP_BASE4, MT_MCU_ROM_PATCH_OFFSET);
+
+	cur = (__le32 *) (fw->data + sizeof(*hdr));
+	len = fw->size - sizeof(*hdr);
+	mt76_wr_copy(dev, MT_MCU_ROM_PATCH_ADDR, cur, len);
+
+	mt76_wr(dev, MT_MCU_PCIE_REMAP_BASE4, 0);
+
+	/* Trigger ROM */
+	mt76_wr(dev, MT_MCU_INT_LEVEL, 4);
+
+	if (!mt76_poll_msec(dev, patch_reg, patch_mask, patch_mask, 2000)) {
+		dev_err(dev->mt76.dev, "Failed to load ROM patch\n");
+		ret = -ETIMEDOUT;
+	}
+
+out:
+	/* release semaphore */
+	if (rom_protect)
+		mt76_wr(dev, MT_MCU_SEMAPHORE_03, 1);
+	release_firmware(fw);
+	return ret;
+}
+
+static int
+mt76pci_load_firmware(struct mt76x2_dev *dev)
+{
+	const struct firmware *fw;
+	const struct mt76x2_fw_header *hdr;
+	int i, len, ret;
+	__le32 *cur;
+	u32 offset, val;
+
+	ret = request_firmware(&fw, MT7662_FIRMWARE, dev->mt76.dev);
+	if (ret)
+		return ret;
+
+	if (!fw || !fw->data || fw->size < sizeof(*hdr))
+		goto error;
+
+	hdr = (const struct mt76x2_fw_header *) fw->data;
+
+	len = sizeof(*hdr);
+	len += le32_to_cpu(hdr->ilm_len);
+	len += le32_to_cpu(hdr->dlm_len);
+
+	if (fw->size != len)
+		goto error;
+
+	val = le16_to_cpu(hdr->fw_ver);
+	dev_info(dev->mt76.dev, "Firmware Version: %d.%d.%02d\n",
+		 (val >> 12) & 0xf, (val >> 8) & 0xf, val & 0xf);
+
+	val = le16_to_cpu(hdr->build_ver);
+	dev_info(dev->mt76.dev, "Build: %x\n", val);
+	dev_info(dev->mt76.dev, "Build Time: %.16s\n", hdr->build_time);
+
+	cur = (__le32 *) (fw->data + sizeof(*hdr));
+	len = le32_to_cpu(hdr->ilm_len);
+
+	mt76_wr(dev, MT_MCU_PCIE_REMAP_BASE4, MT_MCU_ILM_OFFSET);
+	mt76_wr_copy(dev, MT_MCU_ILM_ADDR, cur, len);
+
+	cur += len / sizeof(*cur);
+	len = le32_to_cpu(hdr->dlm_len);
+
+	if (mt76xx_rev(dev) >= MT76XX_REV_E3)
+		offset = MT_MCU_DLM_ADDR_E3;
+	else
+		offset = MT_MCU_DLM_ADDR;
+
+	mt76_wr(dev, MT_MCU_PCIE_REMAP_BASE4, MT_MCU_DLM_OFFSET);
+	mt76_wr_copy(dev, offset, cur, len);
+
+	mt76_wr(dev, MT_MCU_PCIE_REMAP_BASE4, 0);
+
+	val = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_2);
+	if (FIELD_GET(MT_EE_NIC_CONF_2_XTAL_OPTION, val) == 1)
+		mt76_set(dev, MT_MCU_COM_REG0, BIT(30));
+
+	/* trigger firmware */
+	mt76_wr(dev, MT_MCU_INT_LEVEL, 2);
+	for (i = 200; i > 0; i--) {
+		val = mt76_rr(dev, MT_MCU_COM_REG0);
+
+		if (val & 1)
+			break;
+
+		msleep(10);
+	}
+
+	if (!i) {
+		dev_err(dev->mt76.dev, "Firmware failed to start\n");
+		release_firmware(fw);
+		return -ETIMEDOUT;
+	}
+
+	dev_info(dev->mt76.dev, "Firmware running!\n");
+
+	release_firmware(fw);
+
+	return ret;
+
+error:
+	dev_err(dev->mt76.dev, "Invalid firmware\n");
+	release_firmware(fw);
+	return -ENOENT;
+}
+
+static int
+mt76x2_mcu_function_select(struct mt76x2_dev *dev, enum mcu_function func,
+			   u32 val)
+{
+	struct sk_buff *skb;
+	struct {
+	    __le32 id;
+	    __le32 value;
+	} __packed __aligned(4) msg = {
+	    .id = cpu_to_le32(func),
+	    .value = cpu_to_le32(val),
+	};
+
+	skb = mt76x2_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	return mt76x2_mcu_msg_send(dev, skb, CMD_FUN_SET_OP);
+}
+
+int mt76x2_mcu_load_cr(struct mt76x2_dev *dev, u8 type, u8 temp_level,
+		       u8 channel)
+{
+	struct sk_buff *skb;
+	struct {
+		u8 cr_mode;
+		u8 temp;
+		u8 ch;
+		u8 _pad0;
+
+		__le32 cfg;
+	} __packed __aligned(4) msg = {
+		.cr_mode = type,
+		.temp = temp_level,
+		.ch = channel,
+	};
+	u32 val;
+
+	val = BIT(31);
+	val |= (mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_0) >> 8) & 0x00ff;
+	val |= (mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_1) << 8) & 0xff00;
+	msg.cfg = cpu_to_le32(val);
+
+	/* first set the channel without the extension channel info */
+	skb = mt76x2_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	return mt76x2_mcu_msg_send(dev, skb, CMD_LOAD_CR);
+}
+
+int mt76x2_mcu_set_channel(struct mt76x2_dev *dev, u8 channel, u8 bw,
+			   u8 bw_index, bool scan)
+{
+	struct sk_buff *skb;
+	struct {
+		u8 idx;
+		u8 scan;
+		u8 bw;
+		u8 _pad0;
+
+		__le16 chainmask;
+		u8 ext_chan;
+		u8 _pad1;
+
+	} __packed __aligned(4) msg = {
+		.idx = channel,
+		.scan = scan,
+		.bw = bw,
+		.chainmask = cpu_to_le16(dev->chainmask),
+	};
+
+	/* first set the channel without the extension channel info */
+	skb = mt76x2_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	mt76x2_mcu_msg_send(dev, skb, CMD_SWITCH_CHANNEL_OP);
+
+	usleep_range(5000, 10000);
+
+	msg.ext_chan = 0xe0 + bw_index;
+	skb = mt76x2_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	return mt76x2_mcu_msg_send(dev, skb, CMD_SWITCH_CHANNEL_OP);
+}
+
+int mt76x2_mcu_set_radio_state(struct mt76x2_dev *dev, bool on)
+{
+	struct sk_buff *skb;
+	struct {
+		__le32 mode;
+		__le32 level;
+	} __packed __aligned(4) msg = {
+		.mode = cpu_to_le32(on ? RADIO_ON : RADIO_OFF),
+		.level = cpu_to_le32(0),
+	};
+
+	skb = mt76x2_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	return mt76x2_mcu_msg_send(dev, skb, CMD_POWER_SAVING_OP);
+}
+
+int mt76x2_mcu_calibrate(struct mt76x2_dev *dev, enum mcu_calibration type,
+			 u32 param)
+{
+	struct sk_buff *skb;
+	struct {
+		__le32 id;
+		__le32 value;
+	} __packed __aligned(4) msg = {
+		.id = cpu_to_le32(type),
+		.value = cpu_to_le32(param),
+	};
+	int ret;
+
+	mt76_clear(dev, MT_MCU_COM_REG0, BIT(31));
+
+	skb = mt76x2_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	ret = mt76x2_mcu_msg_send(dev, skb, CMD_CALIBRATION_OP);
+	if (ret)
+		return ret;
+
+	if (WARN_ON(!mt76_poll_msec(dev, MT_MCU_COM_REG0,
+				    BIT(31), BIT(31), 100)))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+int mt76x2_mcu_tssi_comp(struct mt76x2_dev *dev,
+			 struct mt76x2_tssi_comp *tssi_data)
+{
+	struct sk_buff *skb;
+	struct {
+		__le32 id;
+		struct mt76x2_tssi_comp data;
+	} __packed __aligned(4) msg = {
+		.id = cpu_to_le32(MCU_CAL_TSSI_COMP),
+		.data = *tssi_data,
+	};
+
+	skb = mt76x2_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	return mt76x2_mcu_msg_send(dev, skb, CMD_CALIBRATION_OP);
+}
+
+int mt76x2_mcu_init_gain(struct mt76x2_dev *dev, u8 channel, u32 gain,
+			 bool force)
+{
+	struct sk_buff *skb;
+	struct {
+		__le32 channel;
+		__le32 gain_val;
+	} __packed __aligned(4) msg = {
+		.channel = cpu_to_le32(channel),
+		.gain_val = cpu_to_le32(gain),
+	};
+
+	if (force)
+		msg.channel |= cpu_to_le32(BIT(31));
+
+	skb = mt76x2_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	return mt76x2_mcu_msg_send(dev, skb, CMD_INIT_GAIN_OP);
+}
+
+int mt76x2_mcu_init(struct mt76x2_dev *dev)
+{
+	int ret;
+
+	mutex_init(&dev->mcu.mutex);
+
+	ret = mt76pci_load_rom_patch(dev);
+	if (ret)
+		return ret;
+
+	ret = mt76pci_load_firmware(dev);
+	if (ret)
+		return ret;
+
+	mt76x2_mcu_function_select(dev, Q_SELECT, 1);
+	return 0;
+}
+
+int mt76x2_mcu_cleanup(struct mt76x2_dev *dev)
+{
+	struct sk_buff *skb;
+
+	mt76_wr(dev, MT_MCU_INT_LEVEL, 1);
+	usleep_range(20000, 30000);
+
+	while ((skb = skb_dequeue(&dev->mcu.res_q)) != NULL)
+		dev_kfree_skb(skb);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
new file mode 100644
index 0000000..f5af7ec
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
@@ -0,0 +1,136 @@
+/*
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
+#ifndef __MT76x2_MCU_H
+#define __MT76x2_MCU_H
+
+/* Register definitions */
+#define MT_MCU_CPU_CTL			0x0704
+#define MT_MCU_CLOCK_CTL		0x0708
+#define MT_MCU_RESET_CTL		0x070C
+#define MT_MCU_INT_LEVEL		0x0718
+#define MT_MCU_COM_REG0			0x0730
+#define MT_MCU_COM_REG1			0x0734
+#define MT_MCU_COM_REG2			0x0738
+#define MT_MCU_COM_REG3			0x073C
+#define MT_MCU_PCIE_REMAP_BASE1		0x0740
+#define MT_MCU_PCIE_REMAP_BASE2		0x0744
+#define MT_MCU_PCIE_REMAP_BASE3		0x0748
+#define MT_MCU_PCIE_REMAP_BASE4		0x074C
+#define MT_MCU_LED_CTRL			0x0770
+#define MT_MCU_LED_TX_BLINK_0		0x0774
+#define MT_MCU_LED_TX_BLINK_1		0x0778
+#define MT_MCU_LED0_S0			0x077C
+#define MT_MCU_LED0_S1			0x0780
+#define MT_MCU_SEMAPHORE_00		0x07B0
+#define MT_MCU_SEMAPHORE_01		0x07B4
+#define MT_MCU_SEMAPHORE_02		0x07B8
+#define MT_MCU_SEMAPHORE_03		0x07BC
+
+#define MT_MCU_ROM_PATCH_OFFSET		0x80000
+#define MT_MCU_ROM_PATCH_ADDR		0x90000
+
+#define MT_MCU_ILM_OFFSET		0x80000
+#define MT_MCU_ILM_ADDR			0x80000
+
+#define MT_MCU_DLM_OFFSET		0x100000
+#define MT_MCU_DLM_ADDR			0x90000
+#define MT_MCU_DLM_ADDR_E3		0x90800
+
+enum mcu_cmd {
+	CMD_FUN_SET_OP = 1,
+	CMD_LOAD_CR = 2,
+	CMD_INIT_GAIN_OP = 3,
+	CMD_DYNC_VGA_OP = 6,
+	CMD_TDLS_CH_SW = 7,
+	CMD_BURST_WRITE = 8,
+	CMD_READ_MODIFY_WRITE = 9,
+	CMD_RANDOM_READ = 10,
+	CMD_BURST_READ = 11,
+	CMD_RANDOM_WRITE = 12,
+	CMD_LED_MODE_OP = 16,
+	CMD_POWER_SAVING_OP = 20,
+	CMD_WOW_CONFIG = 21,
+	CMD_WOW_QUERY = 22,
+	CMD_WOW_FEATURE = 24,
+	CMD_CARRIER_DETECT_OP = 28,
+	CMD_RADOR_DETECT_OP = 29,
+	CMD_SWITCH_CHANNEL_OP = 30,
+	CMD_CALIBRATION_OP = 31,
+	CMD_BEACON_OP = 32,
+	CMD_ANTENNA_OP = 33,
+};
+
+enum mcu_function {
+	Q_SELECT = 1,
+	BW_SETTING = 2,
+	USB2_SW_DISCONNECT = 2,
+	USB3_SW_DISCONNECT = 3,
+	LOG_FW_DEBUG_MSG = 4,
+	GET_FW_VERSION = 5,
+};
+
+enum mcu_power_mode {
+	RADIO_OFF = 0x30,
+	RADIO_ON = 0x31,
+	RADIO_OFF_AUTO_WAKEUP = 0x32,
+	RADIO_OFF_ADVANCE = 0x33,
+	RADIO_ON_ADVANCE = 0x34,
+};
+
+enum mcu_calibration {
+	MCU_CAL_R = 1,
+	MCU_CAL_TEMP_SENSOR,
+	MCU_CAL_RXDCOC,
+	MCU_CAL_RC,
+	MCU_CAL_SX_LOGEN,
+	MCU_CAL_LC,
+	MCU_CAL_TX_LOFT,
+	MCU_CAL_TXIQ,
+	MCU_CAL_TSSI,
+	MCU_CAL_TSSI_COMP,
+	MCU_CAL_DPD,
+	MCU_CAL_RXIQC_FI,
+	MCU_CAL_RXIQC_FD,
+	MCU_CAL_PWRON,
+	MCU_CAL_TX_SHAPING,
+};
+
+enum mt76x2_mcu_cr_mode {
+	MT_RF_CR,
+	MT_BBP_CR,
+	MT_RF_BBP_CR,
+	MT_HL_TEMP_CR_UPDATE,
+};
+
+struct mt76x2_tssi_comp {
+	u8 pa_mode;
+	u8 cal_mode;
+	u16 pad;
+
+	u8 slope0;
+	u8 slope1;
+	u8 offset0;
+	u8 offset1;
+} __packed __aligned(4);
+
+int mt76x2_mcu_calibrate(struct mt76x2_dev *dev, enum mcu_calibration type,
+			 u32 param);
+int mt76x2_mcu_tssi_comp(struct mt76x2_dev *dev, struct mt76x2_tssi_comp *data);
+int mt76x2_mcu_init_gain(struct mt76x2_dev *dev, u8 channel, u32 gain,
+			 bool force);
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
new file mode 100644
index 0000000..e5b07c6
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
@@ -0,0 +1,109 @@
+/*
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "mt76x2.h"
+#include "mt76x2_trace.h"
+
+static const struct pci_device_id mt76pci_device_table[] = {
+	{ PCI_DEVICE(0x14c3, 0x7662) },
+	{ PCI_DEVICE(0x14c3, 0x7612) },
+	{ },
+};
+
+static int
+mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct mt76x2_dev *dev;
+	int ret;
+
+	ret = pcim_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	ret = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
+	if (ret)
+		return ret;
+
+	pci_set_master(pdev);
+
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
+
+	dev = mt76x2_alloc_device(&pdev->dev);
+	if (!dev)
+		return -ENOMEM;
+
+	mt76_mmio_init(&dev->mt76, pcim_iomap_table(pdev)[0]);
+
+	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
+	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
+
+	ret = devm_request_irq(dev->mt76.dev, pdev->irq, mt76x2_irq_handler,
+			       IRQF_SHARED, KBUILD_MODNAME, dev);
+	if (ret)
+		goto error;
+
+	ret = mt76x2_register_device(dev);
+	if (ret)
+		goto error;
+
+	/* Fix up ASPM configuration */
+
+	/* RG_SSUSB_G1_CDR_BIR_LTR = 0x9 */
+	mt76_rmw_field(dev, 0x15a10, 0x1f << 16, 0x9);
+
+	/* RG_SSUSB_G1_CDR_BIC_LTR = 0xf */
+	mt76_rmw_field(dev, 0x15a0c, 0xf << 28, 0xf);
+
+	/* RG_SSUSB_CDR_BR_PE1D = 0x3 */
+	mt76_rmw_field(dev, 0x15c58, 0x3 << 6, 0x3);
+
+	return 0;
+
+error:
+	ieee80211_free_hw(mt76_hw(dev));
+	return ret;
+}
+
+static void
+mt76pci_remove(struct pci_dev *pdev)
+{
+	struct mt76_dev *mdev = pci_get_drvdata(pdev);
+	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+
+	mt76_unregister_device(mdev);
+	mt76x2_cleanup(dev);
+	ieee80211_free_hw(mdev->hw);
+}
+
+MODULE_DEVICE_TABLE(pci, mt76pci_device_table);
+MODULE_FIRMWARE(MT7662_FIRMWARE);
+MODULE_FIRMWARE(MT7662_ROM_PATCH);
+MODULE_LICENSE("Dual BSD/GPL");
+
+static struct pci_driver mt76pci_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= mt76pci_device_table,
+	.probe		= mt76pci_probe,
+	.remove		= mt76pci_remove,
+};
+
+module_pci_driver(mt76pci_driver);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
new file mode 100644
index 0000000..71b57b4
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -0,0 +1,688 @@
+/*
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
+#include <linux/delay.h>
+#include "mt76x2.h"
+#include "mt76x2_mcu.h"
+#include "mt76x2_eeprom.h"
+
+static void
+mt76x2_adjust_lna_gain(struct mt76x2_dev *dev, int reg, s8 offset)
+{
+	s8 gain;
+
+	gain = FIELD_GET(MT_BBP_AGC_LNA_GAIN, mt76_rr(dev, MT_BBP(AGC, reg)));
+	gain -= offset / 2;
+	mt76_rmw_field(dev, MT_BBP(AGC, reg), MT_BBP_AGC_LNA_GAIN, gain);
+}
+
+static void
+mt76x2_adjust_agc_gain(struct mt76x2_dev *dev, int reg, s8 offset)
+{
+	s8 gain;
+
+	gain = FIELD_GET(MT_BBP_AGC_GAIN, mt76_rr(dev, MT_BBP(AGC, reg)));
+	gain += offset;
+	mt76_rmw_field(dev, MT_BBP(AGC, reg), MT_BBP_AGC_GAIN, gain);
+}
+
+static void
+mt76x2_apply_gain_adj(struct mt76x2_dev *dev)
+{
+	s8 *gain_adj = dev->cal.rx.high_gain;
+
+	mt76x2_adjust_lna_gain(dev, 4, gain_adj[0]);
+	mt76x2_adjust_lna_gain(dev, 5, gain_adj[1]);
+
+	mt76x2_adjust_agc_gain(dev, 8, gain_adj[0]);
+	mt76x2_adjust_agc_gain(dev, 9, gain_adj[1]);
+}
+
+static u32
+mt76x2_tx_power_mask(u8 v1, u8 v2, u8 v3, u8 v4)
+{
+	u32 val = 0;
+
+	val |= (v1 & (BIT(6) - 1)) << 0;
+	val |= (v2 & (BIT(6) - 1)) << 8;
+	val |= (v3 & (BIT(6) - 1)) << 16;
+	val |= (v4 & (BIT(6) - 1)) << 24;
+	return val;
+}
+
+int mt76x2_phy_get_rssi(struct mt76x2_dev *dev, s8 rssi, int chain)
+{
+	struct mt76x2_rx_freq_cal *cal = &dev->cal.rx;
+
+	rssi += cal->rssi_offset[chain];
+	rssi -= cal->lna_gain;
+
+	return rssi;
+}
+
+static u8
+mt76x2_txpower_check(int value)
+{
+	if (value < 0)
+		return 0;
+	if (value > 0x2f)
+		return 0x2f;
+	return value;
+}
+
+static void
+mt76x2_add_rate_power_offset(struct mt76_rate_power *r, int offset)
+{
+	int i;
+
+	for (i = 0; i < sizeof(r->all); i++)
+		r->all[i] += offset;
+}
+
+static void
+mt76x2_limit_rate_power(struct mt76_rate_power *r, int limit)
+{
+	int i;
+
+	for (i = 0; i < sizeof(r->all); i++)
+		if (r->all[i] > limit)
+			r->all[i] = limit;
+}
+
+static int
+mt76x2_get_max_power(struct mt76_rate_power *r)
+{
+	int i;
+	s8 ret = 0;
+
+	for (i = 0; i < sizeof(r->all); i++)
+		ret = max(ret, r->all[i]);
+
+	return ret;
+}
+
+void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
+{
+	enum nl80211_chan_width width = dev->mt76.chandef.width;
+	struct mt76x2_tx_power_info txp;
+	int txp_0, txp_1, delta = 0;
+	struct mt76_rate_power t = {};
+
+	mt76x2_get_power_info(dev, &txp);
+
+	if (width == NL80211_CHAN_WIDTH_40)
+		delta = txp.delta_bw40;
+	else if (width == NL80211_CHAN_WIDTH_80)
+		delta = txp.delta_bw80;
+
+	if (txp.target_power > dev->txpower_conf)
+		delta -= txp.target_power - dev->txpower_conf;
+
+	mt76x2_get_rate_power(dev, &t);
+	mt76x2_add_rate_power_offset(&t, txp.chain[0].target_power +
+				   txp.chain[0].delta);
+	mt76x2_limit_rate_power(&t, dev->txpower_conf);
+	dev->txpower_cur = mt76x2_get_max_power(&t);
+	mt76x2_add_rate_power_offset(&t, -(txp.chain[0].target_power +
+					 txp.chain[0].delta + delta));
+	dev->target_power = txp.chain[0].target_power;
+	dev->target_power_delta[0] = txp.chain[0].delta + delta;
+	dev->target_power_delta[1] = txp.chain[1].delta + delta;
+	dev->rate_power = t;
+
+	txp_0 = mt76x2_txpower_check(txp.chain[0].target_power +
+				   txp.chain[0].delta + delta);
+
+	txp_1 = mt76x2_txpower_check(txp.chain[1].target_power +
+				   txp.chain[1].delta + delta);
+
+	mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_0, txp_0);
+	mt76_rmw_field(dev, MT_TX_ALC_CFG_0, MT_TX_ALC_CFG_0_CH_INIT_1, txp_1);
+
+	mt76_wr(dev, MT_TX_PWR_CFG_0,
+		mt76x2_tx_power_mask(t.cck[0], t.cck[2], t.ofdm[0], t.ofdm[2]));
+	mt76_wr(dev, MT_TX_PWR_CFG_1,
+		mt76x2_tx_power_mask(t.ofdm[4], t.ofdm[6], t.ht[0], t.ht[2]));
+	mt76_wr(dev, MT_TX_PWR_CFG_2,
+		mt76x2_tx_power_mask(t.ht[4], t.ht[6], t.ht[8], t.ht[10]));
+	mt76_wr(dev, MT_TX_PWR_CFG_3,
+		mt76x2_tx_power_mask(t.ht[12], t.ht[14], t.ht[0], t.ht[2]));
+	mt76_wr(dev, MT_TX_PWR_CFG_4,
+		mt76x2_tx_power_mask(t.ht[4], t.ht[6], 0, 0));
+	mt76_wr(dev, MT_TX_PWR_CFG_7,
+		mt76x2_tx_power_mask(t.ofdm[6], t.vht[8], t.ht[6], t.vht[8]));
+	mt76_wr(dev, MT_TX_PWR_CFG_8,
+		mt76x2_tx_power_mask(t.ht[14], t.vht[8], t.vht[8], 0));
+	mt76_wr(dev, MT_TX_PWR_CFG_9,
+		mt76x2_tx_power_mask(t.ht[6], t.vht[8], t.vht[8], 0));
+}
+
+static bool
+mt76x2_channel_silent(struct mt76x2_dev *dev)
+{
+	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+
+	return ((chan->flags & IEEE80211_CHAN_RADAR) &&
+		chan->dfs_state != NL80211_DFS_AVAILABLE);
+}
+
+static bool
+mt76x2_phy_tssi_init_cal(struct mt76x2_dev *dev)
+{
+	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+	u32 flag = 0;
+
+	if (!mt76x2_tssi_enabled(dev))
+		return false;
+
+	if (mt76x2_channel_silent(dev))
+		return false;
+
+	if (chan->band == NL80211_BAND_2GHZ)
+		flag |= BIT(0);
+
+	if (mt76x2_ext_pa_enabled(dev, chan->band))
+		flag |= BIT(8);
+
+	mt76x2_mcu_calibrate(dev, MCU_CAL_TSSI, flag);
+	dev->cal.tssi_cal_done = true;
+	return true;
+}
+
+static void
+mt76x2_phy_channel_calibrate(struct mt76x2_dev *dev, bool mac_stopped)
+{
+	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+	bool is_5ghz = chan->band == NL80211_BAND_5GHZ;
+
+	if (dev->cal.channel_cal_done)
+		return;
+
+	if (mt76x2_channel_silent(dev))
+		return;
+
+	if (!dev->cal.tssi_cal_done)
+		mt76x2_phy_tssi_init_cal(dev);
+
+	if (!mac_stopped)
+		mt76x2_mac_stop(dev, false);
+
+	if (is_5ghz)
+		mt76x2_mcu_calibrate(dev, MCU_CAL_LC, 0);
+
+	mt76x2_mcu_calibrate(dev, MCU_CAL_TX_LOFT, is_5ghz);
+	mt76x2_mcu_calibrate(dev, MCU_CAL_TXIQ, is_5ghz);
+	mt76x2_mcu_calibrate(dev, MCU_CAL_RXIQC_FI, is_5ghz);
+	mt76x2_mcu_calibrate(dev, MCU_CAL_TEMP_SENSOR, 0);
+	mt76x2_mcu_calibrate(dev, MCU_CAL_TX_SHAPING, 0);
+
+	if (!mac_stopped)
+		mt76x2_mac_resume(dev);
+
+	mt76x2_apply_gain_adj(dev);
+
+	dev->cal.channel_cal_done = true;
+}
+
+static void
+mt76x2_phy_set_txpower_regs(struct mt76x2_dev *dev, enum nl80211_band band)
+{
+	u32 pa_mode[2];
+	u32 pa_mode_adj;
+
+	if (band == NL80211_BAND_2GHZ) {
+		pa_mode[0] = 0x010055ff;
+		pa_mode[1] = 0x00550055;
+
+		mt76_wr(dev, MT_TX_ALC_CFG_2, 0x35160a00);
+		mt76_wr(dev, MT_TX_ALC_CFG_3, 0x35160a06);
+
+		if (mt76x2_ext_pa_enabled(dev, band)) {
+			mt76_wr(dev, MT_RF_PA_MODE_ADJ0, 0x0000ec00);
+			mt76_wr(dev, MT_RF_PA_MODE_ADJ1, 0x0000ec00);
+		} else {
+			mt76_wr(dev, MT_RF_PA_MODE_ADJ0, 0xf4000200);
+			mt76_wr(dev, MT_RF_PA_MODE_ADJ1, 0xfa000200);
+		}
+	} else {
+		pa_mode[0] = 0x0000ffff;
+		pa_mode[1] = 0x00ff00ff;
+
+		mt76_wr(dev, MT_TX_ALC_CFG_2, 0x1b0f0400);
+		mt76_wr(dev, MT_TX_ALC_CFG_3, 0x1b0f0476);
+		mt76_wr(dev, MT_TX_ALC_CFG_4, 0);
+
+		if (mt76x2_ext_pa_enabled(dev, band))
+			pa_mode_adj = 0x04000000;
+		else
+			pa_mode_adj = 0;
+
+		mt76_wr(dev, MT_RF_PA_MODE_ADJ0, pa_mode_adj);
+		mt76_wr(dev, MT_RF_PA_MODE_ADJ1, pa_mode_adj);
+	}
+
+	mt76_wr(dev, MT_BB_PA_MODE_CFG0, pa_mode[0]);
+	mt76_wr(dev, MT_BB_PA_MODE_CFG1, pa_mode[1]);
+	mt76_wr(dev, MT_RF_PA_MODE_CFG0, pa_mode[0]);
+	mt76_wr(dev, MT_RF_PA_MODE_CFG1, pa_mode[1]);
+
+	if (mt76x2_ext_pa_enabled(dev, band)) {
+		u32 val = 0x3c3c023c;
+
+		mt76_wr(dev, MT_TX0_RF_GAIN_CORR, val);
+		mt76_wr(dev, MT_TX1_RF_GAIN_CORR, val);
+		mt76_wr(dev, MT_TX_ALC_CFG_4, 0x00001818);
+	} else {
+		if (band == NL80211_BAND_2GHZ) {
+			u32 val = 0x0f3c3c3c;
+
+			mt76_wr(dev, MT_TX0_RF_GAIN_CORR, val);
+			mt76_wr(dev, MT_TX1_RF_GAIN_CORR, val);
+			mt76_wr(dev, MT_TX_ALC_CFG_4, 0x00000606);
+		} else {
+			mt76_wr(dev, MT_TX0_RF_GAIN_CORR, 0x383c023c);
+			mt76_wr(dev, MT_TX1_RF_GAIN_CORR, 0x24282e28);
+			mt76_wr(dev, MT_TX_ALC_CFG_4, 0);
+		}
+	}
+}
+
+static void
+mt76x2_configure_tx_delay(struct mt76x2_dev *dev, enum nl80211_band band, u8 bw)
+{
+	u32 cfg0, cfg1;
+
+	if (mt76x2_ext_pa_enabled(dev, band)) {
+		cfg0 = bw ? 0x000b0c01 : 0x00101101;
+		cfg1 = 0x00011414;
+	} else {
+		cfg0 = bw ? 0x000b0b01 : 0x00101001;
+		cfg1 = 0x00021414;
+	}
+	mt76_wr(dev, MT_TX_SW_CFG0, cfg0);
+	mt76_wr(dev, MT_TX_SW_CFG1, cfg1);
+
+	mt76_rmw_field(dev, MT_XIFS_TIME_CFG, MT_XIFS_TIME_CFG_CCK_SIFS,
+		       13 + (bw ? 1 : 0));
+}
+
+static void
+mt76x2_phy_set_bw(struct mt76x2_dev *dev, int width, u8 ctrl)
+{
+	int core_val, agc_val;
+
+	switch (width) {
+	case NL80211_CHAN_WIDTH_80:
+		core_val = 3;
+		agc_val = 7;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		core_val = 2;
+		agc_val = 3;
+		break;
+	default:
+		core_val = 0;
+		agc_val = 1;
+		break;
+	}
+
+	mt76_rmw_field(dev, MT_BBP(CORE, 1), MT_BBP_CORE_R1_BW, core_val);
+	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_BW, agc_val);
+	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_CTRL_CHAN, ctrl);
+	mt76_rmw_field(dev, MT_BBP(TXBE, 0), MT_BBP_TXBE_R0_CTRL_CHAN, ctrl);
+}
+
+static void
+mt76x2_phy_set_band(struct mt76x2_dev *dev, int band, bool primary_upper)
+{
+	switch (band) {
+	case NL80211_BAND_2GHZ:
+		mt76_set(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_2G);
+		mt76_clear(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_5G);
+		break;
+	case NL80211_BAND_5GHZ:
+		mt76_clear(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_2G);
+		mt76_set(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_5G);
+		break;
+	}
+
+	mt76_rmw_field(dev, MT_TX_BAND_CFG, MT_TX_BAND_CFG_UPPER_40M,
+		       primary_upper);
+}
+
+static void
+mt76x2_set_rx_chains(struct mt76x2_dev *dev)
+{
+	u32 val;
+
+	val = mt76_rr(dev, MT_BBP(AGC, 0));
+	val &= ~(BIT(3) | BIT(4));
+
+	if (dev->chainmask & BIT(1))
+		val |= BIT(3);
+
+	mt76_wr(dev, MT_BBP(AGC, 0), val);
+}
+
+static void
+mt76x2_set_tx_dac(struct mt76x2_dev *dev)
+{
+	if (dev->chainmask & BIT(1))
+		mt76_set(dev, MT_BBP(TXBE, 5), 3);
+	else
+		mt76_clear(dev, MT_BBP(TXBE, 5), 3);
+}
+
+static void
+mt76x2_get_agc_gain(struct mt76x2_dev *dev, u8 *dest)
+{
+	dest[0] = mt76_get_field(dev, MT_BBP(AGC, 8), MT_BBP_AGC_GAIN);
+	dest[1] = mt76_get_field(dev, MT_BBP(AGC, 9), MT_BBP_AGC_GAIN);
+}
+
+static int
+mt76x2_get_rssi_gain_thresh(struct mt76x2_dev *dev)
+{
+	switch (dev->mt76.chandef.width) {
+	case NL80211_CHAN_WIDTH_80:
+		return -62;
+	case NL80211_CHAN_WIDTH_40:
+		return -65;
+	default:
+		return -68;
+	}
+}
+
+static void
+mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
+{
+	u32 val = mt76_rr(dev, MT_BBP(AGC, 20));
+	int rssi0 = (s8) FIELD_GET(MT_BBP_AGC20_RSSI0, val);
+	int rssi1 = (s8) FIELD_GET(MT_BBP_AGC20_RSSI1, val);
+	u8 *gain = dev->cal.agc_gain_init, gain_delta;
+	bool low_gain;
+
+	dev->cal.avg_rssi[0] = (dev->cal.avg_rssi[0] * 15) / 16 + (rssi0 << 8);
+	dev->cal.avg_rssi[1] = (dev->cal.avg_rssi[1] * 15) / 16 + (rssi1 << 8);
+	dev->cal.avg_rssi_all = (dev->cal.avg_rssi[0] +
+				 dev->cal.avg_rssi[1]) / 512;
+
+	low_gain = dev->cal.avg_rssi_all > mt76x2_get_rssi_gain_thresh(dev);
+	if (dev->cal.low_gain == low_gain)
+		return;
+
+	dev->cal.low_gain = low_gain;
+
+	if (dev->mt76.chandef.width >= NL80211_CHAN_WIDTH_40)
+		val = 0x1e42 << 16;
+	else
+		val = 0x1836 << 16;
+
+	val |= 0xf8;
+
+	if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_80)
+		mt76_wr(dev, MT_BBP(RXO, 14), 0x00560411);
+	else
+		mt76_wr(dev, MT_BBP(RXO, 14), 0x00560423);
+
+	if (low_gain) {
+		mt76_wr(dev, MT_BBP(AGC, 35), 0x08080808);
+		mt76_wr(dev, MT_BBP(AGC, 37), 0x08080808);
+		if (mt76x2_has_ext_lna(dev))
+			gain_delta = 10;
+		else
+			gain_delta = 14;
+	} else {
+		mt76_wr(dev, MT_BBP(AGC, 35), 0x11111116);
+		mt76_wr(dev, MT_BBP(AGC, 37), 0x1010161C);
+		gain_delta = 0;
+	}
+
+	mt76_wr(dev, MT_BBP(AGC, 8),
+		val | FIELD_PREP(MT_BBP_AGC_GAIN, gain[0] - gain_delta));
+	mt76_wr(dev, MT_BBP(AGC, 9),
+		val | FIELD_PREP(MT_BBP_AGC_GAIN, gain[1] - gain_delta));
+}
+
+int mt76x2_phy_set_channel(struct mt76x2_dev *dev,
+			   struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_channel *chan = chandef->chan;
+	bool scan = test_bit(MT76_SCANNING, &dev->mt76.state);
+	enum nl80211_band band = chan->band;
+	u8 channel;
+
+	u32 ext_cca_chan[4] = {
+		[0] = FIELD_PREP(MT_EXT_CCA_CFG_CCA0, 0) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA1, 1) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA2, 2) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA3, 3) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA_MASK, BIT(0)),
+		[1] = FIELD_PREP(MT_EXT_CCA_CFG_CCA0, 1) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA1, 0) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA2, 2) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA3, 3) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA_MASK, BIT(1)),
+		[2] = FIELD_PREP(MT_EXT_CCA_CFG_CCA0, 2) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA1, 3) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA2, 1) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA3, 0) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA_MASK, BIT(2)),
+		[3] = FIELD_PREP(MT_EXT_CCA_CFG_CCA0, 3) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA1, 2) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA2, 1) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA3, 0) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA_MASK, BIT(3)),
+	};
+	int ch_group_index;
+	u8 bw, bw_index;
+	int freq, freq1;
+	int ret;
+	u8 sifs = 13;
+
+	dev->cal.channel_cal_done = false;
+	freq = chandef->chan->center_freq;
+	freq1 = chandef->center_freq1;
+	channel = chan->hw_value;
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_40:
+		bw = 1;
+		if (freq1 > freq) {
+			bw_index = 1;
+			ch_group_index = 0;
+		} else {
+			bw_index = 3;
+			ch_group_index = 1;
+		}
+		channel += 2 - ch_group_index * 4;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		ch_group_index = (freq - freq1 + 30) / 20;
+		if (WARN_ON(ch_group_index < 0 || ch_group_index > 3))
+			ch_group_index = 0;
+		bw = 2;
+		bw_index = ch_group_index;
+		channel += 6 - ch_group_index * 4;
+		break;
+	default:
+		bw = 0;
+		bw_index = 0;
+		ch_group_index = 0;
+		break;
+	}
+
+	mt76x2_read_rx_gain(dev);
+	mt76x2_phy_set_txpower_regs(dev, band);
+	mt76x2_configure_tx_delay(dev, band, bw);
+	mt76x2_phy_set_txpower(dev);
+
+	mt76x2_set_rx_chains(dev);
+	mt76x2_phy_set_band(dev, chan->band, ch_group_index & 1);
+	mt76x2_phy_set_bw(dev, chandef->width, ch_group_index);
+	mt76x2_set_tx_dac(dev);
+
+	mt76_rmw(dev, MT_EXT_CCA_CFG,
+		 (MT_EXT_CCA_CFG_CCA0 |
+		  MT_EXT_CCA_CFG_CCA1 |
+		  MT_EXT_CCA_CFG_CCA2 |
+		  MT_EXT_CCA_CFG_CCA3 |
+		  MT_EXT_CCA_CFG_CCA_MASK),
+		 ext_cca_chan[ch_group_index]);
+
+	if (chandef->width >= NL80211_CHAN_WIDTH_40)
+		sifs++;
+
+	mt76_rmw_field(dev, MT_XIFS_TIME_CFG, MT_XIFS_TIME_CFG_OFDM_SIFS, sifs);
+
+	ret = mt76x2_mcu_set_channel(dev, channel, bw, bw_index, scan);
+	if (ret)
+		return ret;
+
+	mt76x2_mcu_init_gain(dev, channel, dev->cal.rx.mcu_gain, true);
+
+	/* Enable LDPC Rx */
+	if (mt76xx_rev(dev) >= MT76XX_REV_E3)
+		mt76_set(dev, MT_BBP(RXO, 13), BIT(10));
+
+	if (!dev->cal.init_cal_done) {
+		u8 val = mt76x2_eeprom_get(dev, MT_EE_BT_RCAL_RESULT);
+
+		if (val != 0xff)
+			mt76x2_mcu_calibrate(dev, MCU_CAL_R, 0);
+	}
+
+	mt76x2_mcu_calibrate(dev, MCU_CAL_RXDCOC, channel);
+
+	/* Rx LPF calibration */
+	if (!dev->cal.init_cal_done)
+		mt76x2_mcu_calibrate(dev, MCU_CAL_RC, 0);
+
+	dev->cal.init_cal_done = true;
+
+	mt76_wr(dev, MT_BBP(AGC, 61), 0xFF64A4E2);
+	mt76_wr(dev, MT_BBP(AGC, 7), 0x08081010);
+	mt76_wr(dev, MT_BBP(AGC, 11), 0x00000404);
+	mt76_wr(dev, MT_BBP(AGC, 2), 0x00007070);
+	mt76_wr(dev, MT_TXOP_CTRL_CFG, 0x04101B3F);
+
+	if (scan)
+		return 0;
+
+	dev->cal.low_gain = -1;
+	mt76x2_phy_channel_calibrate(dev, true);
+	mt76x2_get_agc_gain(dev, dev->cal.agc_gain_init);
+
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->cal_work,
+				     MT_CALIBRATE_INTERVAL);
+
+	return 0;
+}
+
+static void
+mt76x2_phy_tssi_compensate(struct mt76x2_dev *dev)
+{
+	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+	struct mt76x2_tx_power_info txp;
+	struct mt76x2_tssi_comp t = {};
+
+	if (!dev->cal.tssi_cal_done)
+		return;
+
+	if (!dev->cal.tssi_comp_pending) {
+		/* TSSI trigger */
+		t.cal_mode = BIT(0);
+		mt76x2_mcu_tssi_comp(dev, &t);
+		dev->cal.tssi_comp_pending = true;
+	} else {
+		if (mt76_rr(dev, MT_BBP(CORE, 34)) & BIT(4))
+			return;
+
+		dev->cal.tssi_comp_pending = false;
+		mt76x2_get_power_info(dev, &txp);
+
+		if (mt76x2_ext_pa_enabled(dev, chan->band))
+			t.pa_mode = 1;
+
+		t.cal_mode = BIT(1);
+		t.slope0 = txp.chain[0].tssi_slope;
+		t.offset0 = txp.chain[0].tssi_offset;
+		t.slope1 = txp.chain[1].tssi_slope;
+		t.offset1 = txp.chain[1].tssi_offset;
+		mt76x2_mcu_tssi_comp(dev, &t);
+
+		if (t.pa_mode || dev->cal.dpd_cal_done)
+			return;
+
+		usleep_range(10000, 20000);
+		mt76x2_mcu_calibrate(dev, MCU_CAL_DPD, chan->hw_value);
+		dev->cal.dpd_cal_done = true;
+	}
+}
+
+static void
+mt76x2_phy_temp_compensate(struct mt76x2_dev *dev)
+{
+	struct mt76x2_temp_comp t;
+	int temp, db_diff;
+
+	if (mt76x2_get_temp_comp(dev, &t))
+		return;
+
+	temp = mt76_get_field(dev, MT_TEMP_SENSOR, MT_TEMP_SENSOR_VAL);
+	temp -= t.temp_25_ref;
+	temp = (temp * 1789) / 1000 + 25;
+	dev->cal.temp = temp;
+
+	if (temp > 25)
+		db_diff = (temp - 25) / t.high_slope;
+	else
+		db_diff = (25 - temp) / t.low_slope;
+
+	db_diff = min(db_diff, t.upper_bound);
+	db_diff = max(db_diff, t.lower_bound);
+
+	mt76_rmw_field(dev, MT_TX_ALC_CFG_1, MT_TX_ALC_CFG_1_TEMP_COMP,
+		       db_diff * 2);
+	mt76_rmw_field(dev, MT_TX_ALC_CFG_2, MT_TX_ALC_CFG_2_TEMP_COMP,
+		       db_diff * 2);
+}
+
+void mt76x2_phy_calibrate(struct work_struct *work)
+{
+	struct mt76x2_dev *dev;
+
+	dev = container_of(work, struct mt76x2_dev, cal_work.work);
+	mt76x2_phy_channel_calibrate(dev, false);
+	mt76x2_phy_tssi_compensate(dev);
+	mt76x2_phy_temp_compensate(dev);
+	mt76x2_phy_update_channel_gain(dev);
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->cal_work,
+				     MT_CALIBRATE_INTERVAL);
+}
+
+int mt76x2_phy_start(struct mt76x2_dev *dev)
+{
+	int ret;
+
+	ret = mt76x2_mcu_set_radio_state(dev, true);
+	if (ret)
+		return ret;
+
+	mt76x2_mcu_load_cr(dev, MT_RF_BBP_CR, 0, 0);
+
+	return ret;
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
new file mode 100644
index 0000000..1da6994
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
@@ -0,0 +1,564 @@
+/*
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
+#ifndef __MT76x2_REGS_H
+#define __MT76x2_REGS_H
+
+#define MT_ASIC_VERSION			0x0000
+
+#define MT76XX_REV_E3		0x22
+#define MT76XX_REV_E4		0x33
+
+#define MT_CMB_CTRL			0x0020
+#define MT_CMB_CTRL_XTAL_RDY		BIT(22)
+#define MT_CMB_CTRL_PLL_LD		BIT(23)
+
+#define MT_EFUSE_CTRL			0x0024
+#define MT_EFUSE_CTRL_AOUT		GENMASK(5, 0)
+#define MT_EFUSE_CTRL_MODE		GENMASK(7, 6)
+#define MT_EFUSE_CTRL_LDO_OFF_TIME	GENMASK(13, 8)
+#define MT_EFUSE_CTRL_LDO_ON_TIME	GENMASK(15, 14)
+#define MT_EFUSE_CTRL_AIN		GENMASK(25, 16)
+#define MT_EFUSE_CTRL_KICK		BIT(30)
+#define MT_EFUSE_CTRL_SEL		BIT(31)
+
+#define MT_EFUSE_DATA_BASE		0x0028
+#define MT_EFUSE_DATA(_n)		(MT_EFUSE_DATA_BASE + ((_n) << 2))
+
+#define MT_COEXCFG0			0x0040
+#define MT_COEXCFG0_COEX_EN		BIT(0)
+
+#define MT_WLAN_FUN_CTRL		0x0080
+#define MT_WLAN_FUN_CTRL_WLAN_EN	BIT(0)
+#define MT_WLAN_FUN_CTRL_WLAN_CLK_EN	BIT(1)
+#define MT_WLAN_FUN_CTRL_WLAN_RESET_RF	BIT(2)
+
+#define MT_WLAN_FUN_CTRL_WLAN_RESET	BIT(3) /* MT76x0 */
+#define MT_WLAN_FUN_CTRL_CSR_F20M_CKEN	BIT(3) /* MT76x2 */
+
+#define MT_WLAN_FUN_CTRL_PCIE_CLK_REQ	BIT(4)
+#define MT_WLAN_FUN_CTRL_FRC_WL_ANT_SEL	BIT(5)
+#define MT_WLAN_FUN_CTRL_INV_ANT_SEL	BIT(6)
+#define MT_WLAN_FUN_CTRL_WAKE_HOST	BIT(7)
+
+#define MT_WLAN_FUN_CTRL_THERM_RST	BIT(8) /* MT76x2 */
+#define MT_WLAN_FUN_CTRL_THERM_CKEN	BIT(9) /* MT76x2 */
+
+#define MT_WLAN_FUN_CTRL_GPIO_IN	GENMASK(15, 8) /* MT76x0 */
+#define MT_WLAN_FUN_CTRL_GPIO_OUT	GENMASK(23, 16) /* MT76x0 */
+#define MT_WLAN_FUN_CTRL_GPIO_OUT_EN	GENMASK(31, 24) /* MT76x0 */
+
+#define MT_XO_CTRL0			0x0100
+#define MT_XO_CTRL1			0x0104
+#define MT_XO_CTRL2			0x0108
+#define MT_XO_CTRL3			0x010c
+#define MT_XO_CTRL4			0x0110
+
+#define MT_XO_CTRL5			0x0114
+#define MT_XO_CTRL5_C2_VAL		GENMASK(14, 8)
+
+#define MT_XO_CTRL6			0x0118
+#define MT_XO_CTRL6_C2_CTRL		GENMASK(14, 8)
+
+#define MT_XO_CTRL7			0x011c
+
+#define MT_WLAN_MTC_CTRL		0x10148
+#define MT_WLAN_MTC_CTRL_MTCMOS_PWR_UP	BIT(0)
+#define MT_WLAN_MTC_CTRL_PWR_ACK	BIT(12)
+#define MT_WLAN_MTC_CTRL_PWR_ACK_S	BIT(13)
+#define MT_WLAN_MTC_CTRL_BBP_MEM_PD	GENMASK(19, 16)
+#define MT_WLAN_MTC_CTRL_PBF_MEM_PD	BIT(20)
+#define MT_WLAN_MTC_CTRL_FCE_MEM_PD	BIT(21)
+#define MT_WLAN_MTC_CTRL_TSO_MEM_PD	BIT(22)
+#define MT_WLAN_MTC_CTRL_BBP_MEM_RB	BIT(24)
+#define MT_WLAN_MTC_CTRL_PBF_MEM_RB	BIT(25)
+#define MT_WLAN_MTC_CTRL_FCE_MEM_RB	BIT(26)
+#define MT_WLAN_MTC_CTRL_TSO_MEM_RB	BIT(27)
+#define MT_WLAN_MTC_CTRL_STATE_UP	BIT(28)
+
+#define MT_INT_SOURCE_CSR		0x0200
+#define MT_INT_MASK_CSR			0x0204
+
+#define MT_INT_RX_DONE(_n)		BIT(_n)
+#define MT_INT_RX_DONE_ALL		GENMASK(1, 0)
+#define MT_INT_TX_DONE_ALL		GENMASK(13, 4)
+#define MT_INT_TX_DONE(_n)		BIT(_n + 4)
+#define MT_INT_RX_COHERENT		BIT(16)
+#define MT_INT_TX_COHERENT		BIT(17)
+#define MT_INT_ANY_COHERENT		BIT(18)
+#define MT_INT_MCU_CMD			BIT(19)
+#define MT_INT_TBTT			BIT(20)
+#define MT_INT_PRE_TBTT			BIT(21)
+#define MT_INT_TX_STAT			BIT(22)
+#define MT_INT_AUTO_WAKEUP		BIT(23)
+#define MT_INT_GPTIMER			BIT(24)
+#define MT_INT_RXDELAYINT		BIT(26)
+#define MT_INT_TXDELAYINT		BIT(27)
+
+#define MT_WPDMA_GLO_CFG		0x0208
+#define MT_WPDMA_GLO_CFG_TX_DMA_EN	BIT(0)
+#define MT_WPDMA_GLO_CFG_TX_DMA_BUSY	BIT(1)
+#define MT_WPDMA_GLO_CFG_RX_DMA_EN	BIT(2)
+#define MT_WPDMA_GLO_CFG_RX_DMA_BUSY	BIT(3)
+#define MT_WPDMA_GLO_CFG_DMA_BURST_SIZE	GENMASK(5, 4)
+#define MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE	BIT(6)
+#define MT_WPDMA_GLO_CFG_BIG_ENDIAN	BIT(7)
+#define MT_WPDMA_GLO_CFG_HDR_SEG_LEN	GENMASK(15, 8)
+#define MT_WPDMA_GLO_CFG_CLK_GATE_DIS	BIT(30)
+#define MT_WPDMA_GLO_CFG_RX_2B_OFFSET	BIT(31)
+
+#define MT_WPDMA_RST_IDX		0x020c
+
+#define MT_WPDMA_DELAY_INT_CFG		0x0210
+
+#define MT_WMM_AIFSN		0x0214
+#define MT_WMM_AIFSN_MASK		GENMASK(3, 0)
+#define MT_WMM_AIFSN_SHIFT(_n)		((_n) * 4)
+
+#define MT_WMM_CWMIN		0x0218
+#define MT_WMM_CWMIN_MASK		GENMASK(3, 0)
+#define MT_WMM_CWMIN_SHIFT(_n)		((_n) * 4)
+
+#define MT_WMM_CWMAX		0x021c
+#define MT_WMM_CWMAX_MASK		GENMASK(3, 0)
+#define MT_WMM_CWMAX_SHIFT(_n)		((_n) * 4)
+
+#define MT_WMM_TXOP_BASE		0x0220
+#define MT_WMM_TXOP(_n)			(MT_WMM_TXOP_BASE + (((_n) / 2) << 2))
+#define MT_WMM_TXOP_SHIFT(_n)		((_n & 1) * 16)
+#define MT_WMM_TXOP_MASK		GENMASK(15, 0)
+
+#define MT_TSO_CTRL			0x0250
+#define MT_HEADER_TRANS_CTRL_REG	0x0260
+
+#define MT_TX_RING_BASE			0x0300
+#define MT_RX_RING_BASE			0x03c0
+
+#define MT_TX_HW_QUEUE_MCU		8
+#define MT_TX_HW_QUEUE_MGMT		9
+
+#define MT_PBF_SYS_CTRL			0x0400
+#define MT_PBF_SYS_CTRL_MCU_RESET	BIT(0)
+#define MT_PBF_SYS_CTRL_DMA_RESET	BIT(1)
+#define MT_PBF_SYS_CTRL_MAC_RESET	BIT(2)
+#define MT_PBF_SYS_CTRL_PBF_RESET	BIT(3)
+#define MT_PBF_SYS_CTRL_ASY_RESET	BIT(4)
+
+#define MT_PBF_CFG			0x0404
+#define MT_PBF_CFG_TX0Q_EN		BIT(0)
+#define MT_PBF_CFG_TX1Q_EN		BIT(1)
+#define MT_PBF_CFG_TX2Q_EN		BIT(2)
+#define MT_PBF_CFG_TX3Q_EN		BIT(3)
+#define MT_PBF_CFG_RX0Q_EN		BIT(4)
+#define MT_PBF_CFG_RX_DROP_EN		BIT(8)
+
+#define MT_PBF_TX_MAX_PCNT		0x0408
+#define MT_PBF_RX_MAX_PCNT		0x040c
+
+#define MT_BCN_OFFSET_BASE		0x041c
+#define MT_BCN_OFFSET(_n)		(MT_BCN_OFFSET_BASE + ((_n) << 2))
+
+#define MT_RF_BYPASS_0			0x0504
+#define MT_RF_BYPASS_1			0x0508
+#define MT_RF_SETTING_0			0x050c
+
+#define MT_RF_DATA_WRITE		0x0524
+
+#define MT_RF_CTRL			0x0528
+#define MT_RF_CTRL_ADDR			GENMASK(11, 0)
+#define MT_RF_CTRL_WRITE		BIT(12)
+#define MT_RF_CTRL_BUSY			BIT(13)
+#define MT_RF_CTRL_IDX			BIT(16)
+
+#define MT_RF_DATA_READ			0x052c
+
+#define MT_FCE_PSE_CTRL			0x0800
+#define MT_FCE_PARAMETERS		0x0804
+#define MT_FCE_CSO			0x0808
+
+#define MT_FCE_L2_STUFF			0x080c
+#define MT_FCE_L2_STUFF_HT_L2_EN	BIT(0)
+#define MT_FCE_L2_STUFF_QOS_L2_EN	BIT(1)
+#define MT_FCE_L2_STUFF_RX_STUFF_EN	BIT(2)
+#define MT_FCE_L2_STUFF_TX_STUFF_EN	BIT(3)
+#define MT_FCE_L2_STUFF_WR_MPDU_LEN_EN	BIT(4)
+#define MT_FCE_L2_STUFF_MVINV_BSWAP	BIT(5)
+#define MT_FCE_L2_STUFF_TS_CMD_QSEL_EN	GENMASK(15, 8)
+#define MT_FCE_L2_STUFF_TS_LEN_EN	GENMASK(23, 16)
+#define MT_FCE_L2_STUFF_OTHER_PORT	GENMASK(25, 24)
+
+#define MT_FCE_WLAN_FLOW_CONTROL1	0x0824
+
+#define MT_PAUSE_ENABLE_CONTROL1	0x0a38
+
+#define MT_MAC_CSR0			0x1000
+
+#define MT_MAC_SYS_CTRL			0x1004
+#define MT_MAC_SYS_CTRL_RESET_CSR	BIT(0)
+#define MT_MAC_SYS_CTRL_RESET_BBP	BIT(1)
+#define MT_MAC_SYS_CTRL_ENABLE_TX	BIT(2)
+#define MT_MAC_SYS_CTRL_ENABLE_RX	BIT(3)
+
+#define MT_MAC_ADDR_DW0			0x1008
+#define MT_MAC_ADDR_DW1			0x100c
+
+#define MT_MAC_BSSID_DW0		0x1010
+#define MT_MAC_BSSID_DW1		0x1014
+#define MT_MAC_BSSID_DW1_ADDR		GENMASK(15, 0)
+#define MT_MAC_BSSID_DW1_MBSS_MODE	GENMASK(17, 16)
+#define MT_MAC_BSSID_DW1_MBEACON_N	GENMASK(20, 18)
+#define MT_MAC_BSSID_DW1_MBSS_LOCAL_BIT	BIT(21)
+#define MT_MAC_BSSID_DW1_MBSS_MODE_B2	BIT(22)
+#define MT_MAC_BSSID_DW1_MBEACON_N_B3	BIT(23)
+#define MT_MAC_BSSID_DW1_MBSS_IDX_BYTE	GENMASK(26, 24)
+
+#define MT_MAX_LEN_CFG			0x1018
+
+#define MT_AMPDU_MAX_LEN_20M1S		0x1030
+#define MT_AMPDU_MAX_LEN_20M2S		0x1034
+#define MT_AMPDU_MAX_LEN_40M1S		0x1038
+#define MT_AMPDU_MAX_LEN_40M2S		0x103c
+#define MT_AMPDU_MAX_LEN		0x1040
+
+#define MT_WCID_DROP_BASE		0x106c
+#define MT_WCID_DROP(_n)		(MT_WCID_DROP_BASE + ((_n) >> 5) * 4)
+#define MT_WCID_DROP_MASK(_n)		BIT((_n) % 32)
+
+#define MT_BCN_BYPASS_MASK		0x108c
+
+#define MT_MAC_APC_BSSID_BASE		0x1090
+#define MT_MAC_APC_BSSID_L(_n)		(MT_MAC_APC_BSSID_BASE + ((_n) * 8))
+#define MT_MAC_APC_BSSID_H(_n)		(MT_MAC_APC_BSSID_BASE + ((_n) * 8 + 4))
+#define MT_MAC_APC_BSSID_H_ADDR		GENMASK(15, 0)
+#define MT_MAC_APC_BSSID0_H_EN		BIT(16)
+
+#define MT_XIFS_TIME_CFG		0x1100
+#define MT_XIFS_TIME_CFG_CCK_SIFS	GENMASK(7, 0)
+#define MT_XIFS_TIME_CFG_OFDM_SIFS	GENMASK(15, 8)
+#define MT_XIFS_TIME_CFG_OFDM_XIFS	GENMASK(19, 16)
+#define MT_XIFS_TIME_CFG_EIFS		GENMASK(28, 20)
+#define MT_XIFS_TIME_CFG_BB_RXEND_EN	BIT(29)
+
+#define MT_BKOFF_SLOT_CFG		0x1104
+#define MT_BKOFF_SLOT_CFG_SLOTTIME	GENMASK(7, 0)
+#define MT_BKOFF_SLOT_CFG_CC_DELAY	GENMASK(11, 8)
+
+#define MT_CH_TIME_CFG			0x110c
+#define MT_CH_TIME_CFG_TIMER_EN		BIT(0)
+#define MT_CH_TIME_CFG_TX_AS_BUSY	BIT(1)
+#define MT_CH_TIME_CFG_RX_AS_BUSY	BIT(2)
+#define MT_CH_TIME_CFG_NAV_AS_BUSY	BIT(3)
+#define MT_CH_TIME_CFG_EIFS_AS_BUSY	BIT(4)
+#define MT_CH_TIME_CFG_MDRDY_CNT_EN	BIT(5)
+#define MT_CH_TIME_CFG_CH_TIMER_CLR	GENMASK(9, 8)
+#define MT_CH_TIME_CFG_MDRDY_CLR	GENMASK(11, 10)
+
+#define MT_BEACON_TIME_CFG		0x1114
+#define MT_BEACON_TIME_CFG_INTVAL	GENMASK(15, 0)
+#define MT_BEACON_TIME_CFG_TIMER_EN	BIT(16)
+#define MT_BEACON_TIME_CFG_SYNC_MODE	GENMASK(18, 17)
+#define MT_BEACON_TIME_CFG_TBTT_EN	BIT(19)
+#define MT_BEACON_TIME_CFG_BEACON_TX	BIT(20)
+#define MT_BEACON_TIME_CFG_TSF_COMP	GENMASK(31, 24)
+
+#define MT_TBTT_SYNC_CFG		0x1118
+#define MT_TBTT_TIMER_CFG		0x1124
+
+#define MT_INT_TIMER_CFG		0x1128
+#define MT_INT_TIMER_CFG_PRE_TBTT	GENMASK(15, 0)
+#define MT_INT_TIMER_CFG_GP_TIMER	GENMASK(31, 16)
+
+#define MT_INT_TIMER_EN			0x112c
+#define MT_INT_TIMER_EN_PRE_TBTT_EN	BIT(0)
+#define MT_INT_TIMER_EN_GP_TIMER_EN	BIT(1)
+
+#define MT_CH_IDLE			0x1130
+#define MT_CH_BUSY			0x1134
+#define MT_EXT_CH_BUSY			0x1138
+#define MT_ED_CCA_TIMER			0x1140
+
+#define MT_MAC_STATUS			0x1200
+#define MT_MAC_STATUS_TX		BIT(0)
+#define MT_MAC_STATUS_RX		BIT(1)
+
+#define MT_PWR_PIN_CFG			0x1204
+#define MT_AUX_CLK_CFG			0x120c
+
+#define MT_BB_PA_MODE_CFG0		0x1214
+#define MT_BB_PA_MODE_CFG1		0x1218
+#define MT_RF_PA_MODE_CFG0		0x121c
+#define MT_RF_PA_MODE_CFG1		0x1220
+
+#define MT_RF_PA_MODE_ADJ0		0x1228
+#define MT_RF_PA_MODE_ADJ1		0x122c
+
+#define MT_DACCLK_EN_DLY_CFG		0x1264
+
+#define MT_EDCA_CFG_BASE		0x1300
+#define MT_EDCA_CFG_AC(_n)		(MT_EDCA_CFG_BASE + ((_n) << 2))
+#define MT_EDCA_CFG_TXOP		GENMASK(7, 0)
+#define MT_EDCA_CFG_AIFSN		GENMASK(11, 8)
+#define MT_EDCA_CFG_CWMIN		GENMASK(15, 12)
+#define MT_EDCA_CFG_CWMAX		GENMASK(19, 16)
+
+#define MT_TX_PWR_CFG_0			0x1314
+#define MT_TX_PWR_CFG_1			0x1318
+#define MT_TX_PWR_CFG_2			0x131c
+#define MT_TX_PWR_CFG_3			0x1320
+#define MT_TX_PWR_CFG_4			0x1324
+
+#define MT_TX_BAND_CFG			0x132c
+#define MT_TX_BAND_CFG_UPPER_40M	BIT(0)
+#define MT_TX_BAND_CFG_5G		BIT(1)
+#define MT_TX_BAND_CFG_2G		BIT(2)
+
+#define MT_HT_FBK_TO_LEGACY		0x1384
+#define MT_TX_MPDU_ADJ_INT		0x1388
+
+#define MT_TX_PWR_CFG_7			0x13d4
+#define MT_TX_PWR_CFG_8			0x13d8
+#define MT_TX_PWR_CFG_9			0x13dc
+
+#define MT_TX_SW_CFG0			0x1330
+#define MT_TX_SW_CFG1			0x1334
+#define MT_TX_SW_CFG2			0x1338
+
+#define MT_TXOP_CTRL_CFG		0x1340
+
+#define MT_TX_RTS_CFG			0x1344
+#define MT_TX_RTS_CFG_RETRY_LIMIT	GENMASK(7, 0)
+#define MT_TX_RTS_CFG_THRESH		GENMASK(23, 8)
+#define MT_TX_RTS_FALLBACK		BIT(24)
+
+#define MT_TX_TIMEOUT_CFG		0x1348
+#define MT_TX_TIMEOUT_CFG_ACKTO		GENMASK(15, 8)
+
+#define MT_TX_RETRY_CFG			0x134c
+#define MT_VHT_HT_FBK_CFG1		0x1358
+
+#define MT_PROT_CFG_RATE		GENMASK(15, 0)
+#define MT_PROT_CFG_CTRL		GENMASK(17, 16)
+#define MT_PROT_CFG_NAV			GENMASK(19, 18)
+#define MT_PROT_CFG_TXOP_ALLOW		GENMASK(25, 20)
+#define MT_PROT_CFG_RTS_THRESH		BIT(26)
+
+#define MT_CCK_PROT_CFG			0x1364
+#define MT_OFDM_PROT_CFG		0x1368
+#define MT_MM20_PROT_CFG		0x136c
+#define MT_MM40_PROT_CFG		0x1370
+#define MT_GF20_PROT_CFG		0x1374
+#define MT_GF40_PROT_CFG		0x1378
+
+#define MT_EXP_ACK_TIME			0x1380
+
+#define MT_TX_PWR_CFG_0_EXT		0x1390
+#define MT_TX_PWR_CFG_1_EXT		0x1394
+
+#define MT_TX_FBK_LIMIT			0x1398
+#define MT_TX_FBK_LIMIT_MPDU_FBK	GENMASK(7, 0)
+#define MT_TX_FBK_LIMIT_AMPDU_FBK	GENMASK(15, 8)
+#define MT_TX_FBK_LIMIT_MPDU_UP_CLEAR	BIT(16)
+#define MT_TX_FBK_LIMIT_AMPDU_UP_CLEAR	BIT(17)
+#define MT_TX_FBK_LIMIT_RATE_LUT	BIT(18)
+
+#define MT_TX0_RF_GAIN_CORR		0x13a0
+#define MT_TX1_RF_GAIN_CORR		0x13a4
+
+#define MT_TX_ALC_CFG_0			0x13b0
+#define MT_TX_ALC_CFG_0_CH_INIT_0	GENMASK(5, 0)
+#define MT_TX_ALC_CFG_0_CH_INIT_1	GENMASK(13, 8)
+#define MT_TX_ALC_CFG_0_LIMIT_0		GENMASK(21, 16)
+#define MT_TX_ALC_CFG_0_LIMIT_1		GENMASK(29, 24)
+
+#define MT_TX_ALC_CFG_1			0x13b4
+#define MT_TX_ALC_CFG_1_TEMP_COMP	GENMASK(5, 0)
+
+#define MT_TX_ALC_CFG_2			0x13a8
+#define MT_TX_ALC_CFG_2_TEMP_COMP	GENMASK(5, 0)
+
+#define MT_TX_ALC_CFG_3			0x13ac
+#define MT_TX_ALC_CFG_4			0x13c0
+#define MT_TX_ALC_CFG_4_LOWGAIN_CH_EN	BIT(31)
+
+#define MT_TX_ALC_VGA3			0x13c8
+
+#define MT_TX_PROT_CFG6			0x13e0
+#define MT_TX_PROT_CFG7			0x13e4
+#define MT_TX_PROT_CFG8			0x13e8
+
+#define MT_PIFS_TX_CFG			0x13ec
+
+#define MT_RX_FILTR_CFG			0x1400
+
+#define MT_RX_FILTR_CFG_CRC_ERR		BIT(0)
+#define MT_RX_FILTR_CFG_PHY_ERR		BIT(1)
+#define MT_RX_FILTR_CFG_PROMISC		BIT(2)
+#define MT_RX_FILTR_CFG_OTHER_BSS	BIT(3)
+#define MT_RX_FILTR_CFG_VER_ERR		BIT(4)
+#define MT_RX_FILTR_CFG_MCAST		BIT(5)
+#define MT_RX_FILTR_CFG_BCAST		BIT(6)
+#define MT_RX_FILTR_CFG_DUP		BIT(7)
+#define MT_RX_FILTR_CFG_CFACK		BIT(8)
+#define MT_RX_FILTR_CFG_CFEND		BIT(9)
+#define MT_RX_FILTR_CFG_ACK		BIT(10)
+#define MT_RX_FILTR_CFG_CTS		BIT(11)
+#define MT_RX_FILTR_CFG_RTS		BIT(12)
+#define MT_RX_FILTR_CFG_PSPOLL		BIT(13)
+#define MT_RX_FILTR_CFG_BA		BIT(14)
+#define MT_RX_FILTR_CFG_BAR		BIT(15)
+#define MT_RX_FILTR_CFG_CTRL_RSV	BIT(16)
+
+#define MT_LEGACY_BASIC_RATE		0x1408
+#define MT_HT_BASIC_RATE		0x140c
+
+#define MT_HT_CTRL_CFG			0x1410
+
+#define MT_EXT_CCA_CFG			0x141c
+#define MT_EXT_CCA_CFG_CCA0		GENMASK(1, 0)
+#define MT_EXT_CCA_CFG_CCA1		GENMASK(3, 2)
+#define MT_EXT_CCA_CFG_CCA2		GENMASK(5, 4)
+#define MT_EXT_CCA_CFG_CCA3		GENMASK(7, 6)
+#define MT_EXT_CCA_CFG_CCA_MASK		GENMASK(11, 8)
+#define MT_EXT_CCA_CFG_ED_CCA_MASK	GENMASK(15, 12)
+
+#define MT_TX_SW_CFG3			0x1478
+
+#define MT_PN_PAD_MODE			0x150c
+
+#define MT_TXOP_HLDR_ET			0x1608
+
+#define MT_PROT_AUTO_TX_CFG		0x1648
+#define MT_PROT_AUTO_TX_CFG_PROT_PADJ	GENMASK(11, 8)
+#define MT_PROT_AUTO_TX_CFG_AUTO_PADJ	GENMASK(27, 24)
+
+#define MT_TX_STAT_FIFO			0x1718
+#define MT_TX_STAT_FIFO_VALID		BIT(0)
+#define MT_TX_STAT_FIFO_SUCCESS		BIT(5)
+#define MT_TX_STAT_FIFO_AGGR		BIT(6)
+#define MT_TX_STAT_FIFO_ACKREQ		BIT(7)
+#define MT_TX_STAT_FIFO_WCID		GENMASK(15, 8)
+#define MT_TX_STAT_FIFO_RATE		GENMASK(31, 16)
+
+#define MT_TX_AGG_CNT_BASE0		0x1720
+#define MT_TX_AGG_CNT_BASE1		0x174c
+
+#define MT_TX_AGG_CNT(_id)		((_id) < 8 ?			\
+					 MT_TX_AGG_CNT_BASE0 + ((_id) << 2) : \
+					 MT_TX_AGG_CNT_BASE1 + ((_id - 8) << 2))
+
+#define MT_TX_STAT_FIFO_EXT		0x1798
+#define MT_TX_STAT_FIFO_EXT_RETRY	GENMASK(7, 0)
+#define MT_TX_STAT_FIFO_EXT_PKTID	GENMASK(15, 8)
+
+#define MT_BBP_CORE_BASE		0x2000
+#define MT_BBP_IBI_BASE			0x2100
+#define MT_BBP_AGC_BASE			0x2300
+#define MT_BBP_TXC_BASE			0x2400
+#define MT_BBP_RXC_BASE			0x2500
+#define MT_BBP_TXO_BASE			0x2600
+#define MT_BBP_TXBE_BASE		0x2700
+#define MT_BBP_RXFE_BASE		0x2800
+#define MT_BBP_RXO_BASE			0x2900
+#define MT_BBP_DFS_BASE			0x2a00
+#define MT_BBP_TR_BASE			0x2b00
+#define MT_BBP_CAL_BASE			0x2c00
+#define MT_BBP_DSC_BASE			0x2e00
+#define MT_BBP_PFMU_BASE		0x2f00
+
+#define MT_BBP(_type, _n)		(MT_BBP_##_type##_BASE + ((_n) << 2))
+
+#define MT_BBP_CORE_R1_BW		GENMASK(4, 3)
+
+#define MT_BBP_AGC_R0_CTRL_CHAN		GENMASK(9, 8)
+#define MT_BBP_AGC_R0_BW		GENMASK(14, 12)
+
+/* AGC, R4/R5 */
+#define MT_BBP_AGC_LNA_GAIN		GENMASK(21, 16)
+
+/* AGC, R8/R9 */
+#define MT_BBP_AGC_GAIN			GENMASK(14, 8)
+
+#define MT_BBP_AGC20_RSSI0		GENMASK(7, 0)
+#define MT_BBP_AGC20_RSSI1		GENMASK(15, 8)
+
+#define MT_BBP_TXBE_R0_CTRL_CHAN	GENMASK(1, 0)
+
+#define MT_WCID_ADDR_BASE		0x1800
+#define MT_WCID_ADDR(_n)		(MT_WCID_ADDR_BASE + (_n) * 8)
+
+#define MT_SRAM_BASE			0x4000
+
+#define MT_WCID_KEY_BASE		0x8000
+#define MT_WCID_KEY(_n)			(MT_WCID_KEY_BASE + (_n) * 32)
+
+#define MT_WCID_IV_BASE			0xa000
+#define MT_WCID_IV(_n)			(MT_WCID_IV_BASE + (_n) * 8)
+
+#define MT_WCID_ATTR_BASE		0xa800
+#define MT_WCID_ATTR(_n)		(MT_WCID_ATTR_BASE + (_n) * 4)
+
+#define MT_WCID_ATTR_PAIRWISE		BIT(0)
+#define MT_WCID_ATTR_PKEY_MODE		GENMASK(3, 1)
+#define MT_WCID_ATTR_BSS_IDX		GENMASK(6, 4)
+#define MT_WCID_ATTR_RXWI_UDF		GENMASK(9, 7)
+#define MT_WCID_ATTR_PKEY_MODE_EXT	BIT(10)
+#define MT_WCID_ATTR_BSS_IDX_EXT	BIT(11)
+#define MT_WCID_ATTR_WAPI_MCBC		BIT(15)
+#define MT_WCID_ATTR_WAPI_KEYID		GENMASK(31, 24)
+
+#define MT_SKEY_BASE_0			0xac00
+#define MT_SKEY_BASE_1			0xb400
+#define MT_SKEY_0(_bss, _idx)		(MT_SKEY_BASE_0 + (4 * (_bss) + _idx) * 32)
+#define MT_SKEY_1(_bss, _idx)		(MT_SKEY_BASE_1 + (4 * ((_bss) & 7) + _idx) * 32)
+#define MT_SKEY(_bss, _idx)		((_bss & 8) ? MT_SKEY_1(_bss, _idx) : MT_SKEY_0(_bss, _idx))
+
+#define MT_SKEY_MODE_BASE_0		0xb000
+#define MT_SKEY_MODE_BASE_1		0xb3f0
+#define MT_SKEY_MODE_0(_bss)		(MT_SKEY_MODE_BASE_0 + ((_bss / 2) << 2))
+#define MT_SKEY_MODE_1(_bss)		(MT_SKEY_MODE_BASE_1 + ((((_bss) & 7) / 2) << 2))
+#define MT_SKEY_MODE(_bss)		((_bss & 8) ? MT_SKEY_MODE_1(_bss) : MT_SKEY_MODE_0(_bss))
+#define MT_SKEY_MODE_MASK		GENMASK(3, 0)
+#define MT_SKEY_MODE_SHIFT(_bss, _idx)	(4 * ((_idx) + 4 * (_bss & 1)))
+
+#define MT_BEACON_BASE			0xc000
+
+#define MT_TEMP_SENSOR			0x1d000
+#define MT_TEMP_SENSOR_VAL		GENMASK(6, 0)
+
+struct mt76_wcid_addr {
+	u8 macaddr[6];
+	__le16 ba_mask;
+} __packed __aligned(4);
+
+struct mt76_wcid_key {
+	u8 key[16];
+	u8 tx_mic[8];
+	u8 rx_mic[8];
+} __packed __aligned(4);
+
+enum mt76x2_cipher_type {
+	MT_CIPHER_NONE,
+	MT_CIPHER_WEP40,
+	MT_CIPHER_WEP104,
+	MT_CIPHER_TKIP,
+	MT_CIPHER_AES_CCMP,
+	MT_CIPHER_CKIP40,
+	MT_CIPHER_CKIP104,
+	MT_CIPHER_CKIP128,
+	MT_CIPHER_WAPI,
+};
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_trace.c b/drivers/net/wireless/mediatek/mt76/mt76x2_trace.c
new file mode 100644
index 0000000..a09f117
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_trace.c
@@ -0,0 +1,23 @@
+/*
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
+#include <linux/module.h>
+
+#ifndef __CHECKER__
+#define CREATE_TRACE_POINTS
+#include "mt76x2_trace.h"
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_trace.h b/drivers/net/wireless/mediatek/mt76/mt76x2_trace.h
new file mode 100644
index 0000000..4cd4241
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_trace.h
@@ -0,0 +1,144 @@
+/*
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
+#if !defined(__MT76x2_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __MT76x2_TRACE_H
+
+#include <linux/tracepoint.h>
+#include "mt76x2.h"
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mt76x2
+
+#define MAXNAME		32
+#define DEV_ENTRY	__array(char, wiphy_name, 32)
+#define DEV_ASSIGN	strlcpy(__entry->wiphy_name, wiphy_name(mt76_hw(dev)->wiphy), MAXNAME)
+#define DEV_PR_FMT	"%s"
+#define DEV_PR_ARG	__entry->wiphy_name
+
+#define TXID_ENTRY	__field(u8, wcid) __field(u8, pktid)
+#define TXID_ASSIGN	__entry->wcid = wcid; __entry->pktid = pktid
+#define TXID_PR_FMT	" [%d:%d]"
+#define TXID_PR_ARG	__entry->wcid, __entry->pktid
+
+DECLARE_EVENT_CLASS(dev_evt,
+	TP_PROTO(struct mt76x2_dev *dev),
+	TP_ARGS(dev),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+	),
+	TP_printk(DEV_PR_FMT, DEV_PR_ARG)
+);
+
+DECLARE_EVENT_CLASS(dev_txid_evt,
+	TP_PROTO(struct mt76x2_dev *dev, u8 wcid, u8 pktid),
+	TP_ARGS(dev, wcid, pktid),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		TXID_ENTRY
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		TXID_ASSIGN;
+	),
+	TP_printk(
+		DEV_PR_FMT TXID_PR_FMT,
+		DEV_PR_ARG, TXID_PR_ARG
+	)
+);
+
+DEFINE_EVENT(dev_evt, mac_txstat_poll,
+	TP_PROTO(struct mt76x2_dev *dev),
+	TP_ARGS(dev)
+);
+
+DEFINE_EVENT(dev_txid_evt, mac_txdone_add,
+	TP_PROTO(struct mt76x2_dev *dev, u8 wcid, u8 pktid),
+	TP_ARGS(dev, wcid, pktid)
+);
+
+TRACE_EVENT(mac_txstat_fetch,
+	TP_PROTO(struct mt76x2_dev *dev,
+		 struct mt76x2_tx_status *stat),
+
+	TP_ARGS(dev, stat),
+
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		TXID_ENTRY
+		__field(bool, success)
+		__field(bool, aggr)
+		__field(bool, ack_req)
+		__field(u16, rate)
+		__field(u8, retry)
+	),
+
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->success = stat->success;
+		__entry->aggr = stat->aggr;
+		__entry->ack_req = stat->ack_req;
+		__entry->wcid = stat->wcid;
+		__entry->pktid = stat->pktid;
+		__entry->rate = stat->rate;
+		__entry->retry = stat->retry;
+	),
+
+	TP_printk(
+		DEV_PR_FMT TXID_PR_FMT
+		" success:%d aggr:%d ack_req:%d"
+		" rate:%04x retry:%d",
+		DEV_PR_ARG, TXID_PR_ARG,
+		__entry->success, __entry->aggr, __entry->ack_req,
+		__entry->rate, __entry->retry
+	)
+);
+
+
+TRACE_EVENT(dev_irq,
+	TP_PROTO(struct mt76x2_dev *dev, u32 val, u32 mask),
+
+	TP_ARGS(dev, val, mask),
+
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(u32, val)
+		__field(u32, mask)
+	),
+
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->val = val;
+		__entry->mask = mask;
+	),
+
+	TP_printk(
+		DEV_PR_FMT " %08x & %08x",
+		DEV_PR_ARG, __entry->val, __entry->mask
+	)
+);
+
+#endif
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE mt76x2_trace
+
+#include <trace/define_trace.h>
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
new file mode 100644
index 0000000..1517b31
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
@@ -0,0 +1,262 @@
+/*
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
+#include "mt76x2.h"
+#include "mt76x2_dma.h"
+
+struct beacon_bc_data {
+	struct mt76x2_dev *dev;
+	struct sk_buff_head q;
+	struct sk_buff *tail[8];
+};
+
+void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
+	     struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct mt76x2_dev *dev = hw->priv;
+	struct ieee80211_vif *vif = info->control.vif;
+	struct mt76_wcid *wcid = &dev->global_wcid;
+
+	if (control->sta) {
+		struct mt76x2_sta *msta;
+
+		msta = (struct mt76x2_sta *) control->sta->drv_priv;
+		wcid = &msta->wcid;
+	} else if (vif) {
+		struct mt76x2_vif *mvif;
+
+		mvif = (struct mt76x2_vif *) vif->drv_priv;
+		wcid = &mvif->group_wcid;
+	}
+
+	mt76_tx(&dev->mt76, control->sta, wcid, skb);
+}
+
+void mt76x2_tx_complete(struct mt76x2_dev *dev, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+		ieee80211_free_txskb(mt76_hw(dev), skb);
+	} else {
+		ieee80211_tx_info_clear_status(info);
+		info->status.rates[0].idx = -1;
+		info->flags |= IEEE80211_TX_STAT_ACK;
+		ieee80211_tx_status(mt76_hw(dev), skb);
+	}
+}
+
+s8 mt76x2_tx_get_max_txpwr_adj(struct mt76x2_dev *dev,
+			       const struct ieee80211_tx_rate *rate)
+{
+	s8 max_txpwr;
+
+	if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
+		u8 mcs = ieee80211_rate_get_vht_mcs(rate);
+
+		if (mcs == 8 || mcs == 9) {
+			max_txpwr = dev->rate_power.vht[8];
+		} else {
+			u8 nss, idx;
+
+			nss = ieee80211_rate_get_vht_nss(rate);
+			idx = ((nss - 1) << 3) + mcs;
+			max_txpwr = dev->rate_power.ht[idx & 0xf];
+		}
+	} else if (rate->flags & IEEE80211_TX_RC_MCS) {
+		max_txpwr = dev->rate_power.ht[rate->idx & 0xf];
+	} else {
+		enum nl80211_band band = dev->mt76.chandef.chan->band;
+
+		if (band == NL80211_BAND_2GHZ) {
+			const struct ieee80211_rate *r;
+			struct wiphy *wiphy = mt76_hw(dev)->wiphy;
+			struct mt76_rate_power *rp = &dev->rate_power;
+
+			r = &wiphy->bands[band]->bitrates[rate->idx];
+			if (r->flags & IEEE80211_RATE_SHORT_PREAMBLE)
+				max_txpwr = rp->cck[r->hw_value & 0x3];
+			else
+				max_txpwr = rp->ofdm[r->hw_value & 0x7];
+		} else {
+			max_txpwr = dev->rate_power.ofdm[rate->idx & 0x7];
+		}
+	}
+
+	return max_txpwr;
+}
+
+s8 mt76x2_tx_get_txpwr_adj(struct mt76x2_dev *dev, s8 txpwr, s8 max_txpwr_adj)
+{
+	txpwr = min_t(s8, txpwr, dev->txpower_conf);
+	txpwr -= (dev->target_power + dev->target_power_delta[0]);
+	txpwr = min_t(s8, txpwr, max_txpwr_adj);
+
+	if (!dev->enable_tpc)
+		return 0;
+	else if (txpwr >= 0)
+		return min_t(s8, txpwr, 7);
+	else
+		return (txpwr < -16) ? 8 : (txpwr + 32) / 2;
+}
+
+void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr)
+{
+	s8 txpwr_adj;
+
+	txpwr_adj = mt76x2_tx_get_txpwr_adj(dev, txpwr,
+					    dev->rate_power.ofdm[4]);
+	mt76_rmw_field(dev, MT_PROT_AUTO_TX_CFG,
+		       MT_PROT_AUTO_TX_CFG_PROT_PADJ, txpwr_adj);
+	mt76_rmw_field(dev, MT_PROT_AUTO_TX_CFG,
+		       MT_PROT_AUTO_TX_CFG_AUTO_PADJ, txpwr_adj);
+}
+
+static int mt76x2_insert_hdr_pad(struct sk_buff *skb)
+{
+	int len = ieee80211_get_hdrlen_from_skb(skb);
+	int ret;
+
+	if (len % 4 == 0)
+		return 0;
+
+	if (skb_headroom(skb) < 2) {
+		ret = pskb_expand_head(skb, 2, 0, GFP_ATOMIC);
+		if (ret != 0)
+			return ret;
+	}
+
+	skb_push(skb, 2);
+	memmove(skb->data, skb->data + 2, len);
+
+	skb->data[len] = 0;
+	skb->data[len + 1] = 0;
+	return 2;
+}
+
+int mt76x2_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
+			  struct sk_buff *skb, struct mt76_queue *q,
+			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			  u32 *tx_info)
+{
+	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	int qsel = MT_QSEL_EDCA;
+	int ret;
+
+	mt76x2_mac_write_txwi(dev, txwi, skb, wcid, sta);
+
+	ret = mt76x2_insert_hdr_pad(skb);
+	if (ret < 0)
+		return ret;
+
+	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
+		qsel = 0;
+
+	*tx_info = FIELD_PREP(MT_TXD_INFO_QSEL, qsel) |
+		   MT_TXD_INFO_80211;
+
+	if (!wcid || wcid->hw_key_idx == 0xff)
+		*tx_info |= MT_TXD_INFO_WIV;
+
+	return 0;
+}
+
+static void
+mt76x2_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct mt76x2_dev *dev = (struct mt76x2_dev *) priv;
+	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+	struct sk_buff *skb = NULL;
+
+	if (!(dev->beacon_mask & BIT(mvif->idx)))
+		return;
+
+	skb = ieee80211_beacon_get(mt76_hw(dev), vif);
+	if (!skb)
+		return;
+
+	mt76x2_mac_set_beacon(dev, mvif->idx, skb);
+}
+
+static void
+mt76x2_add_buffered_bc(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct beacon_bc_data *data = priv;
+	struct mt76x2_dev *dev = data->dev;
+	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+	struct ieee80211_tx_info *info;
+	struct sk_buff *skb;
+
+	if (!(dev->beacon_mask & BIT(mvif->idx)))
+		return;
+
+	skb = ieee80211_get_buffered_bc(mt76_hw(dev), vif);
+	if (!skb)
+		return;
+
+	info = IEEE80211_SKB_CB(skb);
+	info->control.vif = vif;
+	info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
+	mt76_skb_set_moredata(skb, true);
+	__skb_queue_tail(&data->q, skb);
+	data->tail[mvif->idx] = skb;
+}
+
+void mt76x2_pre_tbtt_tasklet(unsigned long arg)
+{
+	struct mt76x2_dev *dev = (struct mt76x2_dev *) arg;
+	struct mt76_queue *q = &dev->mt76.q_tx[MT_TXQ_PSD];
+	struct beacon_bc_data data = {};
+	struct sk_buff *skb;
+	int i, nframes;
+
+	data.dev = dev;
+	__skb_queue_head_init(&data.q);
+
+	ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
+		IEEE80211_IFACE_ITER_RESUME_ALL,
+		mt76x2_update_beacon_iter, dev);
+
+	do {
+		nframes = skb_queue_len(&data.q);
+		ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
+			IEEE80211_IFACE_ITER_RESUME_ALL,
+			mt76x2_add_buffered_bc, &data);
+	} while (nframes != skb_queue_len(&data.q));
+
+	if (!nframes)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(data.tail); i++) {
+		if (!data.tail[i])
+			continue;
+
+		mt76_skb_set_moredata(data.tail[i], false);
+	}
+
+	spin_lock_bh(&q->lock);
+	while ((skb = __skb_dequeue(&data.q)) != NULL) {
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+		struct ieee80211_vif *vif = info->control.vif;
+		struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
+
+		mt76_tx_queue_skb(&dev->mt76, q, skb, &mvif->group_wcid, NULL);
+	}
+	spin_unlock_bh(&q->lock);
+}
+
-- 
2.8.4
