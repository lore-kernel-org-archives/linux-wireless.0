Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753170AbeGEGMx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 02:12:53 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 09/11] mt76x0: trace and debugfs files
Date: Thu,  5 Jul 2018 08:12:20 +0200
Message-Id: <1530771142-4118-10-git-send-email-sgruszka@redhat.com> (sfid-20180705_081307_600016_CE8BB998)
In-Reply-To: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
References: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add trace and debugfs files of mt76x0 driver.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/debugfs.c    | 166 ++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.c  |  21 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h  | 366 +++++++++++++++++++++
 3 files changed, 553 insertions(+)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
new file mode 100644
index 000000000000..e7a77a886068
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
@@ -0,0 +1,166 @@
+/*
+ * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
+ * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
+ * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/debugfs.h>
+
+#include "mt76x0.h"
+#include "eeprom.h"
+
+static int
+mt76_reg_set(void *data, u64 val)
+{
+	struct mt76x0_dev *dev = data;
+
+	mt76_wr(dev, dev->debugfs_reg, val);
+	return 0;
+}
+
+static int
+mt76_reg_get(void *data, u64 *val)
+{
+	struct mt76x0_dev *dev = data;
+
+	*val = mt76_rr(dev, dev->debugfs_reg);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_regval, mt76_reg_get, mt76_reg_set, "0x%08llx\n");
+
+static int
+mt76x0_ampdu_stat_read(struct seq_file *file, void *data)
+{
+	struct mt76x0_dev *dev = file->private;
+	int i, j;
+
+#define stat_printf(grp, off, name)					\
+	seq_printf(file, #name ":\t%llu\n", dev->stats.grp[off])
+
+	stat_printf(rx_stat, 0, rx_crc_err);
+	stat_printf(rx_stat, 1, rx_phy_err);
+	stat_printf(rx_stat, 2, rx_false_cca);
+	stat_printf(rx_stat, 3, rx_plcp_err);
+	stat_printf(rx_stat, 4, rx_fifo_overflow);
+	stat_printf(rx_stat, 5, rx_duplicate);
+
+	stat_printf(tx_stat, 0, tx_fail_cnt);
+	stat_printf(tx_stat, 1, tx_bcn_cnt);
+	stat_printf(tx_stat, 2, tx_success);
+	stat_printf(tx_stat, 3, tx_retransmit);
+	stat_printf(tx_stat, 4, tx_zero_len);
+	stat_printf(tx_stat, 5, tx_underflow);
+
+	stat_printf(aggr_stat, 0, non_aggr_tx);
+	stat_printf(aggr_stat, 1, aggr_tx);
+
+	stat_printf(zero_len_del, 0, tx_zero_len_del);
+	stat_printf(zero_len_del, 1, rx_zero_len_del);
+#undef stat_printf
+
+	seq_puts(file, "Aggregations stats:\n");
+	for (i = 0; i < 4; i++) {
+		for (j = 0; j < 8; j++)
+			seq_printf(file, "%08llx ",
+				   dev->stats.aggr_n[i * 8 + j]);
+		seq_putc(file, '\n');
+	}
+
+	seq_printf(file, "recent average AMPDU len: %d\n",
+		   atomic_read(&dev->avg_ampdu_len));
+
+	return 0;
+}
+
+static int
+mt76x0_ampdu_stat_open(struct inode *inode, struct file *f)
+{
+	return single_open(f, mt76x0_ampdu_stat_read, inode->i_private);
+}
+
+static const struct file_operations fops_ampdu_stat = {
+	.open = mt76x0_ampdu_stat_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int
+mt76x0_eeprom_param_read(struct seq_file *file, void *data)
+{
+	struct mt76x0_dev *dev = file->private;
+	int i;
+
+	seq_printf(file, "RF freq offset: %hhx\n", dev->ee->rf_freq_off);
+	seq_printf(file, "RSSI offset 2GHz: %hhx %hhx\n",
+		   dev->ee->rssi_offset_2ghz[0], dev->ee->rssi_offset_2ghz[1]);
+	seq_printf(file, "RSSI offset 5GHz: %hhx %hhx %hhx\n",
+		   dev->ee->rssi_offset_5ghz[0], dev->ee->rssi_offset_5ghz[1],
+		   dev->ee->rssi_offset_5ghz[2]);
+	seq_printf(file, "Temperature offset: %hhx\n", dev->ee->temp_off);
+	seq_printf(file, "LNA gain 2Ghz: %hhx\n", dev->ee->lna_gain_2ghz);
+	seq_printf(file, "LNA gain 5Ghz: %hhx %hhx %hhx\n",
+		   dev->ee->lna_gain_5ghz[0], dev->ee->lna_gain_5ghz[1],
+		   dev->ee->lna_gain_5ghz[2]);
+	seq_printf(file, "Power Amplifier type %hhx\n", dev->ee->pa_type);
+	seq_printf(file, "Reg channels: %hhu-%hhu\n", dev->ee->reg.start,
+		   dev->ee->reg.start + dev->ee->reg.num - 1);
+
+	seq_puts(file, "Per channel power:\n");
+	for (i = 0; i < 58; i++)
+		seq_printf(file, "\t%d chan:%d pwr:%d\n", i, i,
+			   dev->ee->tx_pwr_per_chan[i]);
+
+	seq_puts(file, "Per rate power 2GHz:\n");
+	for (i = 0; i < 5; i++)
+		seq_printf(file, "\t %d bw20:%d bw40:%d\n",
+			   i, dev->ee->tx_pwr_cfg_2g[i][0],
+			      dev->ee->tx_pwr_cfg_5g[i][1]);
+
+	seq_puts(file, "Per rate power 5GHz:\n");
+	for (i = 0; i < 5; i++)
+		seq_printf(file, "\t %d bw20:%d bw40:%d\n",
+			   i, dev->ee->tx_pwr_cfg_5g[i][0],
+			      dev->ee->tx_pwr_cfg_5g[i][1]);
+
+	return 0;
+}
+
+static int
+mt76x0_eeprom_param_open(struct inode *inode, struct file *f)
+{
+	return single_open(f, mt76x0_eeprom_param_read, inode->i_private);
+}
+
+static const struct file_operations fops_eeprom_param = {
+	.open = mt76x0_eeprom_param_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+void mt76x0_init_debugfs(struct mt76x0_dev *dev)
+{
+	struct dentry *dir;
+
+	dir = debugfs_create_dir("mt76x0", dev->mt76.hw->wiphy->debugfsdir);
+	if (!dir)
+		return;
+
+	debugfs_create_u32("regidx", S_IRUSR | S_IWUSR, dir, &dev->debugfs_reg);
+	debugfs_create_file("regval", S_IRUSR | S_IWUSR, dir, dev,
+			    &fops_regval);
+	debugfs_create_file("ampdu_stat", S_IRUSR, dir, dev, &fops_ampdu_stat);
+	debugfs_create_file("eeprom_param", S_IRUSR, dir, dev,
+			    &fops_eeprom_param);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/trace.c b/drivers/net/wireless/mediatek/mt76/mt76x0/trace.c
new file mode 100644
index 000000000000..8abdd3cd546d
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/trace.c
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
+ * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+
+#ifndef __CHECKER__
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h b/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
new file mode 100644
index 000000000000..cdf53e5442d8
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
@@ -0,0 +1,366 @@
+/*
+ * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
+ * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#if !defined(__MT76X0U_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __MT76X0U_TRACE_H
+
+#include <linux/tracepoint.h>
+#include "mt76x0.h"
+#include "mac.h"
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mt76x0
+
+#define MAXNAME		32
+#define DEV_ENTRY	__array(char, wiphy_name, 32)
+#define DEV_ASSIGN	strlcpy(__entry->wiphy_name,			\
+				wiphy_name(dev->hw->wiphy), MAXNAME)
+#define DEV_PR_FMT	"%s "
+#define DEV_PR_ARG	__entry->wiphy_name
+
+#define REG_ENTRY	__field(u32, reg) __field(u32, val)
+#define REG_ASSIGN	__entry->reg = reg; __entry->val = val
+#define REG_PR_FMT	"%04x=%08x"
+#define REG_PR_ARG	__entry->reg, __entry->val
+
+DECLARE_EVENT_CLASS(dev_reg_evt,
+	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
+	TP_ARGS(dev, reg, val),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		REG_ENTRY
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		REG_ASSIGN;
+	),
+	TP_printk(
+		DEV_PR_FMT REG_PR_FMT,
+		DEV_PR_ARG, REG_PR_ARG
+	)
+);
+
+DEFINE_EVENT(dev_reg_evt, reg_read,
+	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
+	TP_ARGS(dev, reg, val)
+);
+
+DEFINE_EVENT(dev_reg_evt, reg_write,
+	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
+	TP_ARGS(dev, reg, val)
+);
+
+TRACE_EVENT(mt_submit_urb,
+	TP_PROTO(struct mt76_dev *dev, struct urb *u),
+	TP_ARGS(dev, u),
+	TP_STRUCT__entry(
+		DEV_ENTRY __field(unsigned, pipe) __field(u32, len)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->pipe = u->pipe;
+		__entry->len = u->transfer_buffer_length;
+	),
+	TP_printk(DEV_PR_FMT "p:%08x len:%u",
+		  DEV_PR_ARG, __entry->pipe, __entry->len)
+);
+
+#define trace_mt_submit_urb_sync(__dev, __pipe, __len) ({	\
+	struct urb u;					\
+	u.pipe = __pipe;				\
+	u.transfer_buffer_length = __len;		\
+	trace_mt_submit_urb(__dev, &u);			\
+})
+
+TRACE_EVENT(mt_mcu_msg_send,
+	TP_PROTO(struct mt76_dev *dev,
+		 struct sk_buff *skb, u32 csum, bool resp),
+	TP_ARGS(dev, skb, csum, resp),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(u32, info)
+		__field(u32, csum)
+		__field(bool, resp)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->info = *(u32 *)skb->data;
+		__entry->csum = csum;
+		__entry->resp = resp;
+	),
+	TP_printk(DEV_PR_FMT "i:%08x c:%08x r:%d",
+		  DEV_PR_ARG, __entry->info, __entry->csum, __entry->resp)
+);
+
+TRACE_EVENT(mt_vend_req,
+	TP_PROTO(struct mt76_dev *dev, unsigned pipe, u8 req, u8 req_type,
+		 u16 val, u16 offset, void *buf, size_t buflen, int ret),
+	TP_ARGS(dev, pipe, req, req_type, val, offset, buf, buflen, ret),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(unsigned, pipe) __field(u8, req) __field(u8, req_type)
+		__field(u16, val) __field(u16, offset) __field(void*, buf)
+		__field(int, buflen) __field(int, ret)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->pipe = pipe;
+		__entry->req = req;
+		__entry->req_type = req_type;
+		__entry->val = val;
+		__entry->offset = offset;
+		__entry->buf = buf;
+		__entry->buflen = buflen;
+		__entry->ret = ret;
+	),
+	TP_printk(DEV_PR_FMT
+		  "%d p:%08x req:%02hhx %02hhx val:%04hx %04hx buf:%d %d",
+		  DEV_PR_ARG, __entry->ret, __entry->pipe, __entry->req,
+		  __entry->req_type, __entry->val, __entry->offset,
+		  !!__entry->buf, __entry->buflen)
+);
+
+TRACE_EVENT(ee_read,
+	TP_PROTO(struct mt76_dev *dev, int offset, u16 val),
+	TP_ARGS(dev, offset, val),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(int, o) __field(u16, v)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->o = offset;
+		__entry->v = val;
+	),
+	TP_printk(DEV_PR_FMT "%04x=%04x", DEV_PR_ARG, __entry->o, __entry->v)
+);
+
+DECLARE_EVENT_CLASS(dev_rf_reg_evt,
+	TP_PROTO(struct mt76_dev *dev, u8 bank, u8 reg, u8 val),
+	TP_ARGS(dev, bank, reg, val),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(u8, bank)
+		__field(u8, reg)
+		__field(u8, val)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		REG_ASSIGN;
+		__entry->bank = bank;
+	),
+	TP_printk(
+		DEV_PR_FMT "%02hhx:%02hhx=%02hhx",
+		DEV_PR_ARG, __entry->bank, __entry->reg, __entry->val
+	)
+);
+
+DEFINE_EVENT(dev_rf_reg_evt, rf_read,
+	TP_PROTO(struct mt76_dev *dev, u8 bank, u8 reg, u8 val),
+	TP_ARGS(dev, bank, reg, val)
+);
+
+DEFINE_EVENT(dev_rf_reg_evt, rf_write,
+	TP_PROTO(struct mt76_dev *dev, u8 bank, u8 reg, u8 val),
+	TP_ARGS(dev, bank, reg, val)
+);
+
+DECLARE_EVENT_CLASS(dev_bbp_reg_evt,
+	TP_PROTO(struct mt76_dev *dev, u8 reg, u8 val),
+	TP_ARGS(dev, reg, val),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(u8, reg)
+		__field(u8, val)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		REG_ASSIGN;
+	),
+	TP_printk(
+		DEV_PR_FMT "%02hhx=%02hhx",
+		DEV_PR_ARG, __entry->reg, __entry->val
+	)
+);
+
+DEFINE_EVENT(dev_bbp_reg_evt, bbp_read,
+	TP_PROTO(struct mt76_dev *dev, u8 reg, u8 val),
+	TP_ARGS(dev, reg, val)
+);
+
+DEFINE_EVENT(dev_bbp_reg_evt, bbp_write,
+	TP_PROTO(struct mt76_dev *dev, u8 reg, u8 val),
+	TP_ARGS(dev, reg, val)
+);
+
+DECLARE_EVENT_CLASS(dev_simple_evt,
+	TP_PROTO(struct mt76_dev *dev, u8 val),
+	TP_ARGS(dev, val),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(u8, val)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->val = val;
+	),
+	TP_printk(
+		DEV_PR_FMT "%02hhx", DEV_PR_ARG, __entry->val
+	)
+);
+
+DEFINE_EVENT(dev_simple_evt, temp_mode,
+	TP_PROTO(struct mt76_dev *dev, u8 val),
+	TP_ARGS(dev, val)
+);
+
+DEFINE_EVENT(dev_simple_evt, read_temp,
+	TP_PROTO(struct mt76_dev *dev, u8 val),
+	TP_ARGS(dev, val)
+);
+
+TRACE_EVENT(mt_rx,
+	TP_PROTO(struct mt76_dev *dev, struct mt76x0_rxwi *rxwi, u32 f),
+	TP_ARGS(dev, rxwi, f),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field_struct(struct mt76x0_rxwi, rxwi)
+		__field(u32, fce_info)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->rxwi = *rxwi;
+		__entry->fce_info = f;
+	),
+	TP_printk(DEV_PR_FMT "rxi:%08x ctl:%08x", DEV_PR_ARG,
+		  le32_to_cpu(__entry->rxwi.rxinfo),
+		  le32_to_cpu(__entry->rxwi.ctl))
+);
+
+TRACE_EVENT(mt_tx,
+	TP_PROTO(struct mt76_dev *dev, struct sk_buff *skb,
+		 struct mt76_sta *sta, struct mt76_txwi *h),
+	TP_ARGS(dev, skb, sta, h),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field_struct(struct mt76_txwi, h)
+		__field(struct sk_buff *, skb)
+		__field(struct mt76_sta *, sta)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->h = *h;
+		__entry->skb = skb;
+		__entry->sta = sta;
+	),
+	TP_printk(DEV_PR_FMT "skb:%p sta:%p  flg:%04hx rate_ctl:%04hx "
+		  "ack:%02hhx wcid:%02hhx len_ctl:%05hx", DEV_PR_ARG,
+		  __entry->skb, __entry->sta,
+		  le16_to_cpu(__entry->h.flags),
+		  le16_to_cpu(__entry->h.rate_ctl),
+		  __entry->h.ack_ctl, __entry->h.wcid,
+		  le16_to_cpu(__entry->h.len_ctl))
+);
+
+TRACE_EVENT(mt_tx_dma_done,
+	TP_PROTO(struct mt76_dev *dev, struct sk_buff *skb),
+	TP_ARGS(dev, skb),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(struct sk_buff *, skb)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->skb = skb;
+	),
+	TP_printk(DEV_PR_FMT "%p", DEV_PR_ARG, __entry->skb)
+);
+
+TRACE_EVENT(mt_tx_status_cleaned,
+	TP_PROTO(struct mt76_dev *dev, int cleaned),
+	TP_ARGS(dev, cleaned),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(int, cleaned)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->cleaned = cleaned;
+	),
+	TP_printk(DEV_PR_FMT "%d", DEV_PR_ARG, __entry->cleaned)
+);
+
+TRACE_EVENT(mt_tx_status,
+	TP_PROTO(struct mt76_dev *dev, u32 stat1, u32 stat2),
+	TP_ARGS(dev, stat1, stat2),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(u32, stat1)	__field(u32, stat2)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->stat1 = stat1;
+		__entry->stat2 = stat2;
+	),
+	TP_printk(DEV_PR_FMT "%08x %08x",
+		  DEV_PR_ARG, __entry->stat1, __entry->stat2)
+);
+
+TRACE_EVENT(mt_rx_dma_aggr,
+	TP_PROTO(struct mt76_dev *dev, int cnt, bool paged),
+	TP_ARGS(dev, cnt, paged),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(u8, cnt)
+		__field(bool, paged)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->cnt = cnt;
+		__entry->paged = paged;
+	),
+	TP_printk(DEV_PR_FMT "cnt:%d paged:%d",
+		  DEV_PR_ARG, __entry->cnt, __entry->paged)
+);
+
+DEFINE_EVENT(dev_simple_evt, set_key,
+	TP_PROTO(struct mt76_dev *dev, u8 val),
+	TP_ARGS(dev, val)
+);
+
+TRACE_EVENT(set_shared_key,
+	TP_PROTO(struct mt76_dev *dev, u8 vid, u8 key),
+	TP_ARGS(dev, vid, key),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(u8, vid)
+		__field(u8, key)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->vid = vid;
+		__entry->key = key;
+	),
+	TP_printk(DEV_PR_FMT "phy:%02hhx off:%02hhx",
+		  DEV_PR_ARG, __entry->vid, __entry->key)
+);
+
+#endif
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
+#include <trace/define_trace.h>
-- 
1.9.3
