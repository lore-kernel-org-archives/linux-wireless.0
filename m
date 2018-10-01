Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30632C64EB5
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF5972089A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 22:19:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF5972089A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbeJBE7f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 00:59:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40427 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbeJBE7e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 00:59:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id y8-v6so15682106wrh.7
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 15:19:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EumIYdYOh9eJzIOQZyoRXkxpgJp9EI9B78LvBR0oJxQ=;
        b=APVNH6hZAUuml2Fhw9Hoy9y04kqwoMYTiroWD2xf9QZc8MPVyWiGEcJQTE0dKdhLX2
         Z6d54aIdsSpncriMC4fjpFOufhubENxn+X0PKFY8EMh7iWHVzjXA44PKk4p855r87Jfz
         NHkRq3bkKdwUx8jQ++ZjeWk1GGqC2qoUAn4tb01V7rU8ITS/85zbYyT2GOc+JcG5/eO/
         59bB97yx4YnZD6z164Zwj7z4QFL79GQeO1EuGExUH0TsczxS1Wf8WTQGIGTDjUjoHRzL
         SDgmD602N/oEZO00+pwjca4CiCmAz1PP4JilRqM29JFdY1B78x58/ikTp8/SkZ0dLPDM
         icjw==
X-Gm-Message-State: ABuFfoisbNcNx5XbQp+elUoYXAvR60aDN+jcNrSEryeqGhFycRxz0Uk1
        RVSOmZMeHL8NrGM4KVjkBsEJQQ==
X-Google-Smtp-Source: ACcGV61MyAgU+VMT41w6Zis8tTJpki8sqJ0TqPqn/OQULYjebn6gnMPm8U+GWPzuOR6yPaefWad8oA==
X-Received: by 2002:adf:9564:: with SMTP id 91-v6mr8864993wrs.60.1538432369856;
        Mon, 01 Oct 2018 15:19:29 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id t4-v6sm9203420wrb.45.2018.10.01.15.19.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 15:19:29 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 06/10] mt76x2: move mt76x2_dev in mt76x02_util.h
Date:   Tue,  2 Oct 2018 00:19:04 +0200
Message-Id: <20181001221908.16005-7-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x2_dev in mt76x02_util.h and rename it in mt76x02_dev
in order to be shared between mt76x2 and mt76x0 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x02_dfs.h  | 140 +++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_util.h |  71 +++++++++
 .../wireless/mediatek/mt76/mt76x2/common.c    |   2 +-
 .../wireless/mediatek/mt76/mt76x2/debugfs.c   |  12 +-
 .../net/wireless/mediatek/mt76/mt76x2/dfs.h   | 134 +----------------
 .../wireless/mediatek/mt76/mt76x2/eeprom.c    |  40 ++---
 .../wireless/mediatek/mt76/mt76x2/eeprom.h    |  10 +-
 .../net/wireless/mediatek/mt76/mt76x2/init.c  |  10 +-
 .../net/wireless/mediatek/mt76/mt76x2/mac.c   |   8 +-
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   |  20 +--
 .../net/wireless/mediatek/mt76/mt76x2/mcu.c   |   8 +-
 .../net/wireless/mediatek/mt76/mt76x2/mcu.h   |   4 +-
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    | 141 +++++-------------
 .../wireless/mediatek/mt76/mt76x2/mt76x2u.h   |  38 ++---
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   |   4 +-
 .../wireless/mediatek/mt76/mt76x2/pci_core.c  |   2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_dfs.c   | 139 ++++++++---------
 .../wireless/mediatek/mt76/mt76x2/pci_dma.c   |   4 +-
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  38 ++---
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   |  27 ++--
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |  26 ++--
 .../wireless/mediatek/mt76/mt76x2/pci_mcu.c   |   6 +-
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  28 ++--
 .../wireless/mediatek/mt76/mt76x2/pci_tx.c    |  12 +-
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   |  18 +--
 .../net/wireless/mediatek/mt76/mt76x2/trace.h |  12 +-
 .../net/wireless/mediatek/mt76/mt76x2/tx.c    |   6 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb.c   |   8 +-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  26 ++--
 .../wireless/mediatek/mt76/mt76x2/usb_mac.c   |  12 +-
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |  16 +-
 .../wireless/mediatek/mt76/mt76x2/usb_mcu.c   |  16 +-
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  10 +-
 33 files changed, 539 insertions(+), 509 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h
new file mode 100644
index 000000000000..7e177c934592
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.h
@@ -0,0 +1,140 @@
+/*
+ * Copyright (C) 2016 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
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
+#ifndef __MT76x02_DFS_H
+#define __MT76x02_DFS_H
+
+#include <linux/types.h>
+#include <linux/nl80211.h>
+
+#define MT_DFS_GP_INTERVAL		(10 << 4) /* 64 us unit */
+#define MT_DFS_NUM_ENGINES		4
+
+/* bbp params */
+#define MT_DFS_SYM_ROUND		0
+#define MT_DFS_DELTA_DELAY		2
+#define MT_DFS_VGA_MASK			0
+#define MT_DFS_PWR_GAIN_OFFSET		3
+#define MT_DFS_PWR_DOWN_TIME		0xf
+#define MT_DFS_RX_PE_MASK		0xff
+#define MT_DFS_PKT_END_MASK		0
+#define MT_DFS_CH_EN			0xf
+
+/* sw detector params */
+#define MT_DFS_EVENT_LOOP		64
+#define MT_DFS_SW_TIMEOUT		(HZ / 20)
+#define MT_DFS_EVENT_WINDOW		(HZ / 5)
+#define MT_DFS_SEQUENCE_WINDOW		(200 * (1 << 20))
+#define MT_DFS_EVENT_TIME_MARGIN	2000
+#define MT_DFS_PRI_MARGIN		4
+#define MT_DFS_SEQUENCE_TH		6
+
+#define MT_DFS_FCC_MAX_PRI		((28570 << 1) + 1000)
+#define MT_DFS_FCC_MIN_PRI		(3000 - 2)
+#define MT_DFS_JP_MAX_PRI		((80000 << 1) + 1000)
+#define MT_DFS_JP_MIN_PRI		(28500 - 2)
+#define MT_DFS_ETSI_MAX_PRI		(133333 + 125000 + 117647 + 1000)
+#define MT_DFS_ETSI_MIN_PRI		(4500 - 20)
+
+struct mt76x02_radar_specs {
+	u8 mode;
+	u16 avg_len;
+	u16 e_low;
+	u16 e_high;
+	u16 w_low;
+	u16 w_high;
+	u16 w_margin;
+	u32 t_low;
+	u32 t_high;
+	u16 t_margin;
+	u32 b_low;
+	u32 b_high;
+	u32 event_expiration;
+	u16 pwr_jmp;
+};
+
+#define MT_DFS_CHECK_EVENT(x)		((x) != GENMASK(31, 0))
+#define MT_DFS_EVENT_ENGINE(x)		(((x) & BIT(31)) ? 2 : 0)
+#define MT_DFS_EVENT_TIMESTAMP(x)	((x) & GENMASK(21, 0))
+#define MT_DFS_EVENT_WIDTH(x)		((x) & GENMASK(11, 0))
+struct mt76x02_dfs_event {
+	unsigned long fetch_ts;
+	u32 ts;
+	u16 width;
+	u8 engine;
+};
+
+#define MT_DFS_EVENT_BUFLEN		256
+struct mt76x02_dfs_event_rb {
+	struct mt76x02_dfs_event data[MT_DFS_EVENT_BUFLEN];
+	int h_rb, t_rb;
+};
+
+struct mt76x02_dfs_sequence {
+	struct list_head head;
+	u32 first_ts;
+	u32 last_ts;
+	u32 pri;
+	u16 count;
+	u8 engine;
+};
+
+struct mt76x02_dfs_hw_pulse {
+	u8 engine;
+	u32 period;
+	u32 w1;
+	u32 w2;
+	u32 burst;
+};
+
+struct mt76x02_dfs_sw_detector_params {
+	u32 min_pri;
+	u32 max_pri;
+	u32 pri_margin;
+};
+
+struct mt76x02_dfs_engine_stats {
+	u32 hw_pattern;
+	u32 hw_pulse_discarded;
+	u32 sw_pattern;
+};
+
+struct mt76x02_dfs_seq_stats {
+	u32 seq_pool_len;
+	u32 seq_len;
+};
+
+struct mt76x02_dfs_pattern_detector {
+	enum nl80211_dfs_regions region;
+
+	u8 chirp_pulse_cnt;
+	u32 chirp_pulse_ts;
+
+	struct mt76x02_dfs_sw_detector_params sw_dpd_params;
+	struct mt76x02_dfs_event_rb event_rb[2];
+
+	struct list_head sequences;
+	struct list_head seq_pool;
+	struct mt76x02_dfs_seq_stats seq_stats;
+
+	unsigned long last_sw_check;
+	u32 last_event_ts;
+
+	struct mt76x02_dfs_engine_stats stats[MT_DFS_NUM_ENGINES];
+	struct tasklet_struct dfs_tasklet;
+};
+
+#endif /* __MT76x02_DFS_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 5ad8f5c458c4..b628e9a50d87 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -18,6 +18,77 @@
 #ifndef __MT76X02_UTIL_H
 #define __MT76X02_UTIL_H
 
+#include <linux/kfifo.h>
+
+#include "mt76x02_mac.h"
+#include "mt76x02_dfs.h"
+
+#define MT_MAX_CHAINS		2
+struct mt76x02_rx_freq_cal {
+	s8 high_gain[MT_MAX_CHAINS];
+	s8 rssi_offset[MT_MAX_CHAINS];
+	s8 lna_gain;
+	u32 mcu_gain;
+};
+
+struct mt76x02_calibration {
+	struct mt76x02_rx_freq_cal rx;
+
+	u8 agc_gain_init[MT_MAX_CHAINS];
+	u8 agc_gain_cur[MT_MAX_CHAINS];
+
+	u16 false_cca;
+	s8 avg_rssi_all;
+	s8 agc_gain_adjust;
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
+struct mt76x02_dev {
+	struct mt76_dev mt76; /* must be first */
+
+	struct mac_address macaddr_list[8];
+
+	struct mutex mutex;
+
+	u8 txdone_seq;
+	DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x02_tx_status);
+
+	struct sk_buff *rx_head;
+
+	struct tasklet_struct tx_tasklet;
+	struct tasklet_struct pre_tbtt_tasklet;
+	struct delayed_work cal_work;
+	struct delayed_work mac_work;
+
+	u32 aggr_stats[32];
+
+	struct sk_buff *beacons[8];
+	u8 beacon_mask;
+	u8 beacon_data_mask;
+
+	u8 tbtt_count;
+	u16 beacon_int;
+
+	struct mt76x02_calibration cal;
+
+	s8 target_power;
+	s8 target_power_delta[2];
+	bool enable_tpc;
+
+	u8 coverage_class;
+	u8 slottime;
+
+	struct mt76x02_dfs_pattern_detector dfs_pd;
+};
+
 extern struct ieee80211_rate mt76x02_rates[12];
 
 void mt76x02_configure_filter(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/common.c b/drivers/net/wireless/mediatek/mt76/mt76x2/common.c
index fa6bad3bf613..eb9861f89e1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/common.c
@@ -21,7 +21,7 @@
 void mt76x2_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			 struct sk_buff *skb)
 {
-	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	void *rxwi = skb->data;
 
 	if (q == MT_RXQ_MCU) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2/debugfs.c
index ea373bae1522..e8f8ccc0a5ed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/debugfs.c
@@ -20,7 +20,7 @@
 static int
 mt76x2_ampdu_stat_read(struct seq_file *file, void *data)
 {
-	struct mt76x2_dev *dev = file->private;
+	struct mt76x02_dev *dev = file->private;
 	int i, j;
 
 	for (i = 0; i < 4; i++) {
@@ -49,7 +49,7 @@ mt76x2_ampdu_stat_open(struct inode *inode, struct file *f)
 
 static int read_txpower(struct seq_file *file, void *data)
 {
-	struct mt76x2_dev *dev = dev_get_drvdata(file->private);
+	struct mt76x02_dev *dev = dev_get_drvdata(file->private);
 
 	seq_printf(file, "Target power: %d\n", dev->target_power);
 
@@ -68,9 +68,9 @@ static const struct file_operations fops_ampdu_stat = {
 static int
 mt76x2_dfs_stat_read(struct seq_file *file, void *data)
 {
+	struct mt76x02_dev *dev = file->private;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 	int i;
-	struct mt76x2_dev *dev = file->private;
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
 	seq_printf(file, "allocated sequences:\t%d\n",
 		   dfs_pd->seq_stats.seq_pool_len);
@@ -106,7 +106,7 @@ static const struct file_operations fops_dfs_stat = {
 
 static int read_agc(struct seq_file *file, void *data)
 {
-	struct mt76x2_dev *dev = dev_get_drvdata(file->private);
+	struct mt76x02_dev *dev = dev_get_drvdata(file->private);
 
 	seq_printf(file, "avg_rssi: %d\n", dev->cal.avg_rssi_all);
 	seq_printf(file, "low_gain: %d\n", dev->cal.low_gain);
@@ -116,7 +116,7 @@ static int read_agc(struct seq_file *file, void *data)
 	return 0;
 }
 
-void mt76x2_init_debugfs(struct mt76x2_dev *dev)
+void mt76x2_init_debugfs(struct mt76x02_dev *dev)
 {
 	struct dentry *dir;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h b/drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h
index 693f421bf096..3cb9d1864286 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h
@@ -14,133 +14,13 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef __MT76x2_DFS_H
-#define __MT76x2_DFS_H
+#ifndef __DFS_H
+#define __DFS_H
 
-#include <linux/types.h>
-#include <linux/nl80211.h>
-
-#define MT_DFS_GP_INTERVAL		(10 << 4) /* 64 us unit */
-#define MT_DFS_NUM_ENGINES		4
-
-/* bbp params */
-#define MT_DFS_SYM_ROUND		0
-#define MT_DFS_DELTA_DELAY		2
-#define MT_DFS_VGA_MASK			0
-#define MT_DFS_PWR_GAIN_OFFSET		3
-#define MT_DFS_PWR_DOWN_TIME		0xf
-#define MT_DFS_RX_PE_MASK		0xff
-#define MT_DFS_PKT_END_MASK		0
-#define MT_DFS_CH_EN			0xf
-
-/* sw detector params */
-#define MT_DFS_EVENT_LOOP		64
-#define MT_DFS_SW_TIMEOUT		(HZ / 20)
-#define MT_DFS_EVENT_WINDOW		(HZ / 5)
-#define MT_DFS_SEQUENCE_WINDOW		(200 * (1 << 20))
-#define MT_DFS_EVENT_TIME_MARGIN	2000
-#define MT_DFS_PRI_MARGIN		4
-#define MT_DFS_SEQUENCE_TH		6
-
-#define MT_DFS_FCC_MAX_PRI		((28570 << 1) + 1000)
-#define MT_DFS_FCC_MIN_PRI		(3000 - 2)
-#define MT_DFS_JP_MAX_PRI		((80000 << 1) + 1000)
-#define MT_DFS_JP_MIN_PRI		(28500 - 2)
-#define MT_DFS_ETSI_MAX_PRI		(133333 + 125000 + 117647 + 1000)
-#define MT_DFS_ETSI_MIN_PRI		(4500 - 20)
-
-struct mt76x2_radar_specs {
-	u8 mode;
-	u16 avg_len;
-	u16 e_low;
-	u16 e_high;
-	u16 w_low;
-	u16 w_high;
-	u16 w_margin;
-	u32 t_low;
-	u32 t_high;
-	u16 t_margin;
-	u32 b_low;
-	u32 b_high;
-	u32 event_expiration;
-	u16 pwr_jmp;
-};
-
-#define MT_DFS_CHECK_EVENT(x)		((x) != GENMASK(31, 0))
-#define MT_DFS_EVENT_ENGINE(x)		(((x) & BIT(31)) ? 2 : 0)
-#define MT_DFS_EVENT_TIMESTAMP(x)	((x) & GENMASK(21, 0))
-#define MT_DFS_EVENT_WIDTH(x)		((x) & GENMASK(11, 0))
-struct mt76x2_dfs_event {
-	unsigned long fetch_ts;
-	u32 ts;
-	u16 width;
-	u8 engine;
-};
-
-#define MT_DFS_EVENT_BUFLEN		256
-struct mt76x2_dfs_event_rb {
-	struct mt76x2_dfs_event data[MT_DFS_EVENT_BUFLEN];
-	int h_rb, t_rb;
-};
-
-struct mt76x2_dfs_sequence {
-	struct list_head head;
-	u32 first_ts;
-	u32 last_ts;
-	u32 pri;
-	u16 count;
-	u8 engine;
-};
-
-struct mt76x2_dfs_hw_pulse {
-	u8 engine;
-	u32 period;
-	u32 w1;
-	u32 w2;
-	u32 burst;
-};
-
-struct mt76x2_dfs_sw_detector_params {
-	u32 min_pri;
-	u32 max_pri;
-	u32 pri_margin;
-};
-
-struct mt76x2_dfs_engine_stats {
-	u32 hw_pattern;
-	u32 hw_pulse_discarded;
-	u32 sw_pattern;
-};
-
-struct mt76x2_dfs_seq_stats {
-	u32 seq_pool_len;
-	u32 seq_len;
-};
-
-struct mt76x2_dfs_pattern_detector {
-	enum nl80211_dfs_regions region;
-
-	u8 chirp_pulse_cnt;
-	u32 chirp_pulse_ts;
-
-	struct mt76x2_dfs_sw_detector_params sw_dpd_params;
-	struct mt76x2_dfs_event_rb event_rb[2];
-
-	struct list_head sequences;
-	struct list_head seq_pool;
-	struct mt76x2_dfs_seq_stats seq_stats;
-
-	unsigned long last_sw_check;
-	u32 last_event_ts;
-
-	struct mt76x2_dfs_engine_stats stats[MT_DFS_NUM_ENGINES];
-	struct tasklet_struct dfs_tasklet;
-};
-
-void mt76x2_dfs_init_params(struct mt76x2_dev *dev);
-void mt76x2_dfs_init_detector(struct mt76x2_dev *dev);
-void mt76x2_dfs_adjust_agc(struct mt76x2_dev *dev);
-void mt76x2_dfs_set_domain(struct mt76x2_dev *dev,
+void mt76x2_dfs_init_params(struct mt76x02_dev *dev);
+void mt76x2_dfs_init_detector(struct mt76x02_dev *dev);
+void mt76x2_dfs_adjust_agc(struct mt76x02_dev *dev);
+void mt76x2_dfs_set_domain(struct mt76x02_dev *dev,
 			   enum nl80211_dfs_regions region);
 
-#endif /* __MT76x2_DFS_H */
+#endif /* __DFS_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
index 55eda67f0e79..bbab021b5f1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
@@ -22,7 +22,7 @@
 #define EE_FIELD(_name, _value) [MT_EE_##_name] = (_value) | 1
 
 static int
-mt76x2_eeprom_copy(struct mt76x2_dev *dev, enum mt76x02_eeprom_field field,
+mt76x2_eeprom_copy(struct mt76x02_dev *dev, enum mt76x02_eeprom_field field,
 		   void *dest, int len)
 {
 	if (field + len > dev->mt76.eeprom.size)
@@ -33,7 +33,7 @@ mt76x2_eeprom_copy(struct mt76x2_dev *dev, enum mt76x02_eeprom_field field,
 }
 
 static int
-mt76x2_eeprom_get_macaddr(struct mt76x2_dev *dev)
+mt76x2_eeprom_get_macaddr(struct mt76x02_dev *dev)
 {
 	void *src = dev->mt76.eeprom.data + MT_EE_MAC_ADDR;
 
@@ -42,7 +42,7 @@ mt76x2_eeprom_get_macaddr(struct mt76x2_dev *dev)
 }
 
 static bool
-mt76x2_has_cal_free_data(struct mt76x2_dev *dev, u8 *efuse)
+mt76x2_has_cal_free_data(struct mt76x02_dev *dev, u8 *efuse)
 {
 	u16 *efuse_w = (u16 *) efuse;
 
@@ -68,7 +68,7 @@ mt76x2_has_cal_free_data(struct mt76x2_dev *dev, u8 *efuse)
 }
 
 static void
-mt76x2_apply_cal_free_data(struct mt76x2_dev *dev, u8 *efuse)
+mt76x2_apply_cal_free_data(struct mt76x02_dev *dev, u8 *efuse)
 {
 #define GROUP_5G(_id)							   \
 	MT_EE_TX_POWER_0_START_5G + MT_TX_POWER_GROUP_SIZE_5G * (_id),	   \
@@ -137,7 +137,7 @@ mt76x2_apply_cal_free_data(struct mt76x2_dev *dev, u8 *efuse)
 		eeprom[MT_EE_BT_PMUCFG] = val & 0xff;
 }
 
-static int mt76x2_check_eeprom(struct mt76x2_dev *dev)
+static int mt76x2_check_eeprom(struct mt76x02_dev *dev)
 {
 	u16 val = get_unaligned_le16(dev->mt76.eeprom.data);
 
@@ -155,7 +155,7 @@ static int mt76x2_check_eeprom(struct mt76x2_dev *dev)
 }
 
 static int
-mt76x2_eeprom_load(struct mt76x2_dev *dev)
+mt76x2_eeprom_load(struct mt76x02_dev *dev)
 {
 	void *efuse;
 	bool found;
@@ -197,7 +197,7 @@ mt76x2_eeprom_load(struct mt76x2_dev *dev)
 }
 
 static void
-mt76x2_set_rx_gain_group(struct mt76x2_dev *dev, u8 val)
+mt76x2_set_rx_gain_group(struct mt76x02_dev *dev, u8 val)
 {
 	s8 *dest = dev->cal.rx.high_gain;
 
@@ -212,7 +212,7 @@ mt76x2_set_rx_gain_group(struct mt76x2_dev *dev, u8 val)
 }
 
 static void
-mt76x2_set_rssi_offset(struct mt76x2_dev *dev, int chain, u8 val)
+mt76x2_set_rssi_offset(struct mt76x02_dev *dev, int chain, u8 val)
 {
 	s8 *dest = dev->cal.rx.rssi_offset;
 
@@ -241,7 +241,7 @@ mt76x2_get_cal_channel_group(int channel)
 }
 
 static u8
-mt76x2_get_5g_rx_gain(struct mt76x2_dev *dev, u8 channel)
+mt76x2_get_5g_rx_gain(struct mt76x02_dev *dev, u8 channel)
 {
 	enum mt76x2_cal_channel_group group;
 
@@ -268,7 +268,7 @@ mt76x2_get_5g_rx_gain(struct mt76x2_dev *dev, u8 channel)
 	}
 }
 
-void mt76x2_read_rx_gain(struct mt76x2_dev *dev)
+void mt76x2_read_rx_gain(struct mt76x02_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	int channel = chan->hw_value;
@@ -298,7 +298,7 @@ void mt76x2_read_rx_gain(struct mt76x2_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x2_read_rx_gain);
 
-void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
+void mt76x2_get_rate_power(struct mt76x02_dev *dev, struct mt76_rate_power *t,
 			   struct ieee80211_channel *chan)
 {
 	bool is_5ghz;
@@ -366,8 +366,10 @@ void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
 EXPORT_SYMBOL_GPL(mt76x2_get_rate_power);
 
 static void
-mt76x2_get_power_info_2g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
-		         struct ieee80211_channel *chan, int chain, int offset)
+mt76x2_get_power_info_2g(struct mt76x02_dev *dev,
+			 struct mt76x2_tx_power_info *t,
+			 struct ieee80211_channel *chan,
+			 int chain, int offset)
 {
 	int channel = chan->hw_value;
 	int delta_idx;
@@ -393,8 +395,10 @@ mt76x2_get_power_info_2g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
 }
 
 static void
-mt76x2_get_power_info_5g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
-		         struct ieee80211_channel *chan, int chain, int offset)
+mt76x2_get_power_info_5g(struct mt76x02_dev *dev,
+			 struct mt76x2_tx_power_info *t,
+		         struct ieee80211_channel *chan,
+			 int chain, int offset)
 {
 	int channel = chan->hw_value;
 	enum mt76x2_cal_channel_group group;
@@ -441,7 +445,7 @@ mt76x2_get_power_info_5g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
 	t->target_power = val & 0xff;
 }
 
-void mt76x2_get_power_info(struct mt76x2_dev *dev,
+void mt76x2_get_power_info(struct mt76x02_dev *dev,
 			   struct mt76x2_tx_power_info *t,
 			   struct ieee80211_channel *chan)
 {
@@ -474,7 +478,7 @@ void mt76x2_get_power_info(struct mt76x2_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x2_get_power_info);
 
-int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t)
+int mt76x2_get_temp_comp(struct mt76x02_dev *dev, struct mt76x2_temp_comp *t)
 {
 	enum nl80211_band band = dev->mt76.chandef.chan->band;
 	u16 val, slope;
@@ -511,7 +515,7 @@ int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t)
 }
 EXPORT_SYMBOL_GPL(mt76x2_get_temp_comp);
 
-int mt76x2_eeprom_init(struct mt76x2_dev *dev)
+int mt76x2_eeprom_init(struct mt76x02_dev *dev)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h
index 33277c7bca9c..c97b31c77d83 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h
@@ -51,16 +51,16 @@ struct mt76x2_temp_comp {
 	unsigned int low_slope; /* J / dB */
 };
 
-void mt76x2_get_rate_power(struct mt76x2_dev *dev, struct mt76_rate_power *t,
+void mt76x2_get_rate_power(struct mt76x02_dev *dev, struct mt76_rate_power *t,
 			   struct ieee80211_channel *chan);
-void mt76x2_get_power_info(struct mt76x2_dev *dev,
+void mt76x2_get_power_info(struct mt76x02_dev *dev,
 			   struct mt76x2_tx_power_info *t,
 			   struct ieee80211_channel *chan);
-int mt76x2_get_temp_comp(struct mt76x2_dev *dev, struct mt76x2_temp_comp *t);
-void mt76x2_read_rx_gain(struct mt76x2_dev *dev);
+int mt76x2_get_temp_comp(struct mt76x02_dev *dev, struct mt76x2_temp_comp *t);
+void mt76x2_read_rx_gain(struct mt76x02_dev *dev);
 
 static inline bool
-mt76x2_has_ext_lna(struct mt76x2_dev *dev)
+mt76x2_has_ext_lna(struct mt76x02_dev *dev)
 {
 	u32 val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_1);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
index d672771963d5..ccd9bc9d3e1e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/init.c
@@ -20,7 +20,7 @@
 #include "../mt76x02_phy.h"
 
 static void
-mt76x2_set_wlan_state(struct mt76x2_dev *dev, bool enable)
+mt76x2_set_wlan_state(struct mt76x02_dev *dev, bool enable)
 {
 	u32 val = mt76_rr(dev, MT_WLAN_FUN_CTRL);
 
@@ -35,7 +35,7 @@ mt76x2_set_wlan_state(struct mt76x2_dev *dev, bool enable)
 	udelay(20);
 }
 
-void mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable)
+void mt76x2_reset_wlan(struct mt76x02_dev *dev, bool enable)
 {
 	u32 val;
 
@@ -62,7 +62,7 @@ void mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable)
 }
 EXPORT_SYMBOL_GPL(mt76x2_reset_wlan);
 
-void mt76_write_mac_initvals(struct mt76x2_dev *dev)
+void mt76_write_mac_initvals(struct mt76x02_dev *dev)
 {
 #define DEFAULT_PROT_CFG_CCK				\
 	(FIELD_PREP(MT_PROT_CFG_RATE, 0x3) |		\
@@ -158,7 +158,7 @@ void mt76_write_mac_initvals(struct mt76x2_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76_write_mac_initvals);
 
-void mt76x2_init_device(struct mt76x2_dev *dev)
+void mt76x2_init_device(struct mt76x02_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
 
@@ -187,7 +187,7 @@ void mt76x2_init_device(struct mt76x2_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x2_init_device);
 
-void mt76x2_init_txpower(struct mt76x2_dev *dev,
+void mt76x2_init_txpower(struct mt76x02_dev *dev,
 			 struct ieee80211_supported_band *sband)
 {
 	struct ieee80211_channel *chan;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
index 93bf8a9404b1..7aefe72fc506 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
@@ -18,7 +18,7 @@
 #include "mt76x2.h"
 #include "../mt76x02_util.h"
 
-void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force)
+void mt76x2_mac_stop(struct mt76x02_dev *dev, bool force)
 {
 	bool stopped = false;
 	u32 rts_cfg;
@@ -54,9 +54,9 @@ void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force)
 }
 EXPORT_SYMBOL_GPL(mt76x2_mac_stop);
 
-int mt76x2_mac_get_rssi(struct mt76x2_dev *dev, s8 rssi, int chain)
+int mt76x2_mac_get_rssi(struct mt76x02_dev *dev, s8 rssi, int chain)
 {
-	struct mt76x2_rx_freq_cal *cal = &dev->cal.rx;
+	struct mt76x02_rx_freq_cal *cal = &dev->cal.rx;
 
 	rssi += cal->rssi_offset[chain];
 	rssi -= cal->lna_gain;
@@ -64,7 +64,7 @@ int mt76x2_mac_get_rssi(struct mt76x2_dev *dev, s8 rssi, int chain)
 	return rssi;
 }
 
-int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
+int mt76x2_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 			  void *rxi)
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
index 95ad5eea4274..db36232277cd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
@@ -20,7 +20,7 @@
 #include "../mt76.h"
 #include "../mt76x02_mac.h"
 
-struct mt76x2_dev;
+struct mt76x02_dev;
 struct mt76x2_sta;
 struct mt76x02_vif;
 
@@ -41,20 +41,20 @@ mt76x2_skb_tx_info(struct sk_buff *skb)
 	return (void *) info->status.status_driver_data;
 }
 
-int mt76x2_mac_start(struct mt76x2_dev *dev);
-void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force);
-void mt76x2_mac_resume(struct mt76x2_dev *dev);
-void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr);
+int mt76x2_mac_start(struct mt76x02_dev *dev);
+void mt76x2_mac_stop(struct mt76x02_dev *dev, bool force);
+void mt76x2_mac_resume(struct mt76x02_dev *dev);
+void mt76x2_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr);
 
-int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
+int mt76x2_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 			  void *rxi);
 
-int mt76x2_mac_set_beacon(struct mt76x2_dev *dev, u8 vif_idx,
+int mt76x2_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 			  struct sk_buff *skb);
-void mt76x2_mac_set_beacon_enable(struct mt76x2_dev *dev, u8 vif_idx, bool val);
+void mt76x2_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx, bool val);
 
-void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq);
-void mt76x2_mac_process_tx_status_fifo(struct mt76x2_dev *dev);
+void mt76x2_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq);
+void mt76x2_mac_process_tx_status_fifo(struct mt76x02_dev *dev);
 
 void mt76x2_mac_work(struct work_struct *work);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
index 86b09534326e..7d944f50956a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
@@ -24,7 +24,7 @@
 #include "eeprom.h"
 #include "../mt76x02_dma.h"
 
-int mt76x2_mcu_set_channel(struct mt76x2_dev *dev, u8 channel, u8 bw,
+int mt76x2_mcu_set_channel(struct mt76x02_dev *dev, u8 channel, u8 bw,
 			   u8 bw_index, bool scan)
 {
 	struct sk_buff *skb;
@@ -57,7 +57,7 @@ int mt76x2_mcu_set_channel(struct mt76x2_dev *dev, u8 channel, u8 bw,
 }
 EXPORT_SYMBOL_GPL(mt76x2_mcu_set_channel);
 
-int mt76x2_mcu_load_cr(struct mt76x2_dev *dev, u8 type, u8 temp_level,
+int mt76x2_mcu_load_cr(struct mt76x02_dev *dev, u8 type, u8 temp_level,
 		       u8 channel)
 {
 	struct mt76_dev *mdev = &dev->mt76;
@@ -87,7 +87,7 @@ int mt76x2_mcu_load_cr(struct mt76x2_dev *dev, u8 type, u8 temp_level,
 }
 EXPORT_SYMBOL_GPL(mt76x2_mcu_load_cr);
 
-int mt76x2_mcu_init_gain(struct mt76x2_dev *dev, u8 channel, u32 gain,
+int mt76x2_mcu_init_gain(struct mt76x02_dev *dev, u8 channel, u32 gain,
 			 bool force)
 {
 	struct sk_buff *skb;
@@ -107,7 +107,7 @@ int mt76x2_mcu_init_gain(struct mt76x2_dev *dev, u8 channel, u32 gain,
 }
 EXPORT_SYMBOL_GPL(mt76x2_mcu_init_gain);
 
-int mt76x2_mcu_tssi_comp(struct mt76x2_dev *dev,
+int mt76x2_mcu_tssi_comp(struct mt76x02_dev *dev,
 			 struct mt76x2_tssi_comp *tssi_data)
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.h
index 98a73e285a45..acfa2b570c7c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.h
@@ -94,8 +94,8 @@ struct mt76x2_tssi_comp {
 	u8 offset1;
 } __packed __aligned(4);
 
-int mt76x2_mcu_tssi_comp(struct mt76x2_dev *dev, struct mt76x2_tssi_comp *tssi_data);
-int mt76x2_mcu_init_gain(struct mt76x2_dev *dev, u8 channel, u32 gain,
+int mt76x2_mcu_tssi_comp(struct mt76x02_dev *dev, struct mt76x2_tssi_comp *tssi_data);
+int mt76x2_mcu_init_gain(struct mt76x02_dev *dev, u8 channel, u32 gain,
 			 bool force);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index f9ca93ad91cd..b4de10b7b31e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -26,7 +26,6 @@
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
 #include <linux/bitops.h>
-#include <linux/kfifo.h>
 
 #define MT7662_FIRMWARE		"mt7662.bin"
 #define MT7662_ROM_PATCH	"mt7662_rom_patch.bin"
@@ -35,86 +34,20 @@
 #define MT7662U_FIRMWARE	"mediatek/mt7662u.bin"
 #define MT7662U_ROM_PATCH	"mediatek/mt7662u_rom_patch.bin"
 
-#define MT_MAX_CHAINS		2
-
 #define MT_CALIBRATE_INTERVAL	HZ
 
 #include "../mt76.h"
 #include "../mt76x02_regs.h"
+#include "../mt76x02_util.h"
 #include "mac.h"
 #include "dfs.h"
 
-struct mt76x2_rx_freq_cal {
-	s8 high_gain[MT_MAX_CHAINS];
-	s8 rssi_offset[MT_MAX_CHAINS];
-	s8 lna_gain;
-	u32 mcu_gain;
-};
-
-struct mt76x2_calibration {
-	struct mt76x2_rx_freq_cal rx;
-
-	u8 agc_gain_init[MT_MAX_CHAINS];
-	u8 agc_gain_cur[MT_MAX_CHAINS];
-
-	u16 false_cca;
-	s8 avg_rssi_all;
-	s8 agc_gain_adjust;
-	s8 low_gain;
-
-	u8 temp;
-
-	bool init_cal_done;
-	bool tssi_cal_done;
-	bool tssi_comp_pending;
-	bool dpd_cal_done;
-	bool channel_cal_done;
-};
-
-struct mt76x2_dev {
-	struct mt76_dev mt76; /* must be first */
-
-	struct mac_address macaddr_list[8];
-
-	struct mutex mutex;
-
-	u8 txdone_seq;
-	DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x02_tx_status);
-
-	struct sk_buff *rx_head;
-
-	struct tasklet_struct tx_tasklet;
-	struct tasklet_struct pre_tbtt_tasklet;
-	struct delayed_work cal_work;
-	struct delayed_work mac_work;
-
-	u32 aggr_stats[32];
-
-	struct sk_buff *beacons[8];
-	u8 beacon_mask;
-	u8 beacon_data_mask;
-
-	u8 tbtt_count;
-	u16 beacon_int;
-
-	struct mt76x2_calibration cal;
-
-	s8 target_power;
-	s8 target_power_delta[2];
-	bool enable_tpc;
-
-	u8 coverage_class;
-	u8 slottime;
-
-	struct mt76x2_dfs_pattern_detector dfs_pd;
-};
-
-static inline bool is_mt7612(struct mt76x2_dev *dev)
+static inline bool is_mt7612(struct mt76x02_dev *dev)
 {
 	return mt76_chip(&dev->mt76) == 0x7612;
 }
 
-static inline bool mt76x2_channel_silent(struct mt76x2_dev *dev)
+static inline bool mt76x2_channel_silent(struct mt76x02_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 
@@ -124,37 +57,37 @@ static inline bool mt76x2_channel_silent(struct mt76x2_dev *dev)
 
 extern const struct ieee80211_ops mt76x2_ops;
 
-struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev);
-int mt76x2_register_device(struct mt76x2_dev *dev);
-void mt76x2_init_debugfs(struct mt76x2_dev *dev);
-void mt76x2_init_device(struct mt76x2_dev *dev);
+struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev);
+int mt76x2_register_device(struct mt76x02_dev *dev);
+void mt76x2_init_debugfs(struct mt76x02_dev *dev);
+void mt76x2_init_device(struct mt76x02_dev *dev);
 
 irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance);
-void mt76x2_phy_power_on(struct mt76x2_dev *dev);
-int mt76x2_init_hardware(struct mt76x2_dev *dev);
-void mt76x2_stop_hardware(struct mt76x2_dev *dev);
-int mt76x2_eeprom_init(struct mt76x2_dev *dev);
-int mt76x2_apply_calibration_data(struct mt76x2_dev *dev, int channel);
-void mt76x2_set_tx_ackto(struct mt76x2_dev *dev);
-
-void mt76x2_phy_set_antenna(struct mt76x2_dev *dev);
-int mt76x2_phy_start(struct mt76x2_dev *dev);
-int mt76x2_phy_set_channel(struct mt76x2_dev *dev,
-			 struct cfg80211_chan_def *chandef);
-int mt76x2_mac_get_rssi(struct mt76x2_dev *dev, s8 rssi, int chain);
+void mt76x2_phy_power_on(struct mt76x02_dev *dev);
+int mt76x2_init_hardware(struct mt76x02_dev *dev);
+void mt76x2_stop_hardware(struct mt76x02_dev *dev);
+int mt76x2_eeprom_init(struct mt76x02_dev *dev);
+int mt76x2_apply_calibration_data(struct mt76x02_dev *dev, int channel);
+void mt76x2_set_tx_ackto(struct mt76x02_dev *dev);
+
+void mt76x2_phy_set_antenna(struct mt76x02_dev *dev);
+int mt76x2_phy_start(struct mt76x02_dev *dev);
+int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
+			   struct cfg80211_chan_def *chandef);
+int mt76x2_mac_get_rssi(struct mt76x02_dev *dev, s8 rssi, int chain);
 void mt76x2_phy_calibrate(struct work_struct *work);
-void mt76x2_phy_set_txpower(struct mt76x2_dev *dev);
+void mt76x2_phy_set_txpower(struct mt76x02_dev *dev);
 
-int mt76x2_mcu_init(struct mt76x2_dev *dev);
-int mt76x2_mcu_set_channel(struct mt76x2_dev *dev, u8 channel, u8 bw,
+int mt76x2_mcu_init(struct mt76x02_dev *dev);
+int mt76x2_mcu_set_channel(struct mt76x02_dev *dev, u8 channel, u8 bw,
 			   u8 bw_index, bool scan);
-int mt76x2_mcu_load_cr(struct mt76x2_dev *dev, u8 type, u8 temp_level,
+int mt76x2_mcu_load_cr(struct mt76x02_dev *dev, u8 type, u8 temp_level,
 		       u8 channel);
 
 void mt76x2_tx_tasklet(unsigned long data);
-void mt76x2_dma_cleanup(struct mt76x2_dev *dev);
+void mt76x2_dma_cleanup(struct mt76x02_dev *dev);
 
-void mt76x2_cleanup(struct mt76x2_dev *dev);
+void mt76x2_cleanup(struct mt76x02_dev *dev);
 
 void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	       struct sk_buff *skb);
@@ -164,7 +97,7 @@ int mt76x2_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 			  u32 *tx_info);
 void mt76x2_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			    struct mt76_queue_entry *e, bool flush);
-void mt76x2_mac_set_tx_protection(struct mt76x2_dev *dev, u32 val);
+void mt76x2_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val);
 
 void mt76x2_pre_tbtt_tasklet(unsigned long arg);
 
@@ -177,13 +110,13 @@ void mt76x2_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
 void mt76x2_update_channel(struct mt76_dev *mdev);
 
 s8 mt76x2_tx_get_txpwr_adj(struct mt76_dev *mdev, s8 txpwr, s8 max_txpwr_adj);
-void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr);
+void mt76x2_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr);
 
 
-void mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable);
-void mt76x2_init_txpower(struct mt76x2_dev *dev,
+void mt76x2_reset_wlan(struct mt76x02_dev *dev, bool enable);
+void mt76x2_init_txpower(struct mt76x02_dev *dev,
 			 struct ieee80211_supported_band *sband);
-void mt76_write_mac_initvals(struct mt76x2_dev *dev);
+void mt76_write_mac_initvals(struct mt76x02_dev *dev);
 
 int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta);
@@ -193,15 +126,15 @@ void mt76x2_remove_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif);
 int mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   u16 queue, const struct ieee80211_tx_queue_params *params);
-void mt76x2_txq_init(struct mt76x2_dev *dev, struct ieee80211_txq *txq);
+void mt76x2_txq_init(struct mt76x02_dev *dev, struct ieee80211_txq *txq);
 
-void mt76x2_phy_tssi_compensate(struct mt76x2_dev *dev, bool wait);
-void mt76x2_phy_set_txpower_regs(struct mt76x2_dev *dev,
+void mt76x2_phy_tssi_compensate(struct mt76x02_dev *dev, bool wait);
+void mt76x2_phy_set_txpower_regs(struct mt76x02_dev *dev,
 				 enum nl80211_band band);
-void mt76x2_configure_tx_delay(struct mt76x2_dev *dev,
+void mt76x2_configure_tx_delay(struct mt76x02_dev *dev,
 			       enum nl80211_band band, u8 bw);
-void mt76x2_phy_set_bw(struct mt76x2_dev *dev, int width, u8 ctrl);
-void mt76x2_phy_set_band(struct mt76x2_dev *dev, int band, bool primary_upper);
-void mt76x2_apply_gain_adj(struct mt76x2_dev *dev);
+void mt76x2_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl);
+void mt76x2_phy_set_band(struct mt76x02_dev *dev, int band, bool primary_upper);
+void mt76x2_apply_gain_adj(struct mt76x02_dev *dev);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
index e5d08cc8ca73..b3270b0b0930 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
@@ -30,31 +30,31 @@
 
 extern const struct ieee80211_ops mt76x2u_ops;
 
-struct mt76x2_dev *mt76x2u_alloc_device(struct device *pdev);
-int mt76x2u_register_device(struct mt76x2_dev *dev);
-int mt76x2u_init_hardware(struct mt76x2_dev *dev);
-void mt76x2u_cleanup(struct mt76x2_dev *dev);
-void mt76x2u_stop_hw(struct mt76x2_dev *dev);
-
-int mt76x2u_mac_reset(struct mt76x2_dev *dev);
-void mt76x2u_mac_resume(struct mt76x2_dev *dev);
-int mt76x2u_mac_start(struct mt76x2_dev *dev);
-int mt76x2u_mac_stop(struct mt76x2_dev *dev);
-
-int mt76x2u_phy_set_channel(struct mt76x2_dev *dev,
+struct mt76x02_dev *mt76x2u_alloc_device(struct device *pdev);
+int mt76x2u_register_device(struct mt76x02_dev *dev);
+int mt76x2u_init_hardware(struct mt76x02_dev *dev);
+void mt76x2u_cleanup(struct mt76x02_dev *dev);
+void mt76x2u_stop_hw(struct mt76x02_dev *dev);
+
+int mt76x2u_mac_reset(struct mt76x02_dev *dev);
+void mt76x2u_mac_resume(struct mt76x02_dev *dev);
+int mt76x2u_mac_start(struct mt76x02_dev *dev);
+int mt76x2u_mac_stop(struct mt76x02_dev *dev);
+
+int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 			    struct cfg80211_chan_def *chandef);
 void mt76x2u_phy_calibrate(struct work_struct *work);
-void mt76x2u_phy_channel_calibrate(struct mt76x2_dev *dev);
+void mt76x2u_phy_channel_calibrate(struct mt76x02_dev *dev);
 
 void mt76x2u_mcu_complete_urb(struct urb *urb);
-int mt76x2u_mcu_set_dynamic_vga(struct mt76x2_dev *dev, u8 channel, bool ap,
+int mt76x2u_mcu_set_dynamic_vga(struct mt76x02_dev *dev, u8 channel, bool ap,
 				bool ext, int rssi, u32 false_cca);
-int mt76x2u_mcu_init(struct mt76x2_dev *dev);
-int mt76x2u_mcu_fw_init(struct mt76x2_dev *dev);
+int mt76x2u_mcu_init(struct mt76x02_dev *dev);
+int mt76x2u_mcu_fw_init(struct mt76x02_dev *dev);
 
-int mt76x2u_alloc_queues(struct mt76x2_dev *dev);
-void mt76x2u_queues_deinit(struct mt76x2_dev *dev);
-void mt76x2u_stop_queues(struct mt76x2_dev *dev);
+int mt76x2u_alloc_queues(struct mt76x02_dev *dev);
+void mt76x2u_queues_deinit(struct mt76x02_dev *dev);
+void mt76x2u_stop_queues(struct mt76x02_dev *dev);
 int mt76x2u_skb_dma_info(struct sk_buff *skb, enum dma_msg_port port,
 			 u32 flags);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index 49556becb72d..1fcf23dad06f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -31,7 +31,7 @@ static const struct pci_device_id mt76pci_device_table[] = {
 static int
 mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct mt76x2_dev *dev;
+	struct mt76x02_dev *dev;
 	int ret;
 
 	ret = pcim_enable_device(pdev);
@@ -89,7 +89,7 @@ static void
 mt76pci_remove(struct pci_dev *pdev)
 {
 	struct mt76_dev *mdev = pci_get_drvdata(pdev);
-	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 
 	mt76_unregister_device(mdev);
 	mt76x2_cleanup(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
index b343742b36ee..6da12fca668c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
@@ -26,7 +26,7 @@ void mt76x2_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
 
 irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance)
 {
-	struct mt76x2_dev *dev = dev_instance;
+	struct mt76x02_dev *dev = dev_instance;
 	u32 intr;
 
 	intr = mt76_rr(dev, MT_INT_SOURCE_CSR);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
index 18926a6478ab..b36286bc8b69 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
@@ -37,7 +37,7 @@
 	.pwr_jmp = power_jmp				\
 }
 
-static const struct mt76x2_radar_specs etsi_radar_specs[] = {
+static const struct mt76x02_radar_specs etsi_radar_specs[] = {
 	/* 20MHz */
 	RADAR_SPEC(0, 8, 2, 15, 106, 150, 10, 4900, 100096, 10, 0,
 		   0x7fffffff, 0x155cc0, 0x19cc),
@@ -67,7 +67,7 @@ static const struct mt76x2_radar_specs etsi_radar_specs[] = {
 		   0x7fffffff, 0x2191c0, 0x15cc)
 };
 
-static const struct mt76x2_radar_specs fcc_radar_specs[] = {
+static const struct mt76x02_radar_specs fcc_radar_specs[] = {
 	/* 20MHz */
 	RADAR_SPEC(0, 8, 2, 12, 106, 150, 5, 2900, 80100, 5, 0,
 		   0x7fffffff, 0xfe808, 0x13dc),
@@ -97,7 +97,7 @@ static const struct mt76x2_radar_specs fcc_radar_specs[] = {
 		   0x3938700, 0x57bcf00, 0x1289)
 };
 
-static const struct mt76x2_radar_specs jp_w56_radar_specs[] = {
+static const struct mt76x02_radar_specs jp_w56_radar_specs[] = {
 	/* 20MHz */
 	RADAR_SPEC(0, 8, 2, 7, 106, 150, 5, 2900, 80100, 5, 0,
 		   0x7fffffff, 0x14c080, 0x13dc),
@@ -127,7 +127,7 @@ static const struct mt76x2_radar_specs jp_w56_radar_specs[] = {
 		   0x3938700, 0X57bcf00, 0x1289)
 };
 
-static const struct mt76x2_radar_specs jp_w53_radar_specs[] = {
+static const struct mt76x02_radar_specs jp_w53_radar_specs[] = {
 	/* 20MHz */
 	RADAR_SPEC(0, 8, 2, 9, 106, 150, 20, 28400, 77000, 20, 0,
 		   0x7fffffff, 0x14c080, 0x16cc),
@@ -151,8 +151,9 @@ static const struct mt76x2_radar_specs jp_w53_radar_specs[] = {
 	{ 0 }
 };
 
-static void mt76x2_dfs_set_capture_mode_ctrl(struct mt76x2_dev *dev,
-					     u8 enable)
+static void
+mt76x2_dfs_set_capture_mode_ctrl(struct mt76x02_dev *dev,
+				 u8 enable)
 {
 	u32 data;
 
@@ -160,10 +161,10 @@ static void mt76x2_dfs_set_capture_mode_ctrl(struct mt76x2_dev *dev,
 	mt76_wr(dev, MT_BBP(DFS, 36), data);
 }
 
-static void mt76x2_dfs_seq_pool_put(struct mt76x2_dev *dev,
-				    struct mt76x2_dfs_sequence *seq)
+static void mt76x2_dfs_seq_pool_put(struct mt76x02_dev *dev,
+				    struct mt76x02_dfs_sequence *seq)
 {
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
 	list_add(&seq->head, &dfs_pd->seq_pool);
 
@@ -171,17 +172,17 @@ static void mt76x2_dfs_seq_pool_put(struct mt76x2_dev *dev,
 	dfs_pd->seq_stats.seq_len--;
 }
 
-static
-struct mt76x2_dfs_sequence *mt76x2_dfs_seq_pool_get(struct mt76x2_dev *dev)
+static struct mt76x02_dfs_sequence *
+mt76x2_dfs_seq_pool_get(struct mt76x02_dev *dev)
 {
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
-	struct mt76x2_dfs_sequence *seq;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_sequence *seq;
 
 	if (list_empty(&dfs_pd->seq_pool)) {
 		seq = devm_kzalloc(dev->mt76.dev, sizeof(*seq), GFP_ATOMIC);
 	} else {
 		seq = list_first_entry(&dfs_pd->seq_pool,
-				       struct mt76x2_dfs_sequence,
+				       struct mt76x02_dfs_sequence,
 				       head);
 		list_del(&seq->head);
 		dfs_pd->seq_stats.seq_pool_len--;
@@ -214,10 +215,10 @@ static int mt76x2_dfs_get_multiple(int val, int frac, int margin)
 	return factor;
 }
 
-static void mt76x2_dfs_detector_reset(struct mt76x2_dev *dev)
+static void mt76x2_dfs_detector_reset(struct mt76x02_dev *dev)
 {
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
-	struct mt76x2_dfs_sequence *seq, *tmp_seq;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_sequence *seq, *tmp_seq;
 	int i;
 
 	/* reset hw detector */
@@ -235,11 +236,11 @@ static void mt76x2_dfs_detector_reset(struct mt76x2_dev *dev)
 	}
 }
 
-static bool mt76x2_dfs_check_chirp(struct mt76x2_dev *dev)
+static bool mt76x2_dfs_check_chirp(struct mt76x02_dev *dev)
 {
 	bool ret = false;
 	u32 current_ts, delta_ts;
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
 	current_ts = mt76_rr(dev, MT_PBF_LIFE_TIMER);
 	delta_ts = current_ts - dfs_pd->chirp_pulse_ts;
@@ -256,8 +257,8 @@ static bool mt76x2_dfs_check_chirp(struct mt76x2_dev *dev)
 	return ret;
 }
 
-static void mt76x2_dfs_get_hw_pulse(struct mt76x2_dev *dev,
-				    struct mt76x2_dfs_hw_pulse *pulse)
+static void mt76x2_dfs_get_hw_pulse(struct mt76x02_dev *dev,
+				    struct mt76x02_dfs_hw_pulse *pulse)
 {
 	u32 data;
 
@@ -276,8 +277,8 @@ static void mt76x2_dfs_get_hw_pulse(struct mt76x2_dev *dev,
 	pulse->burst = mt76_rr(dev, MT_BBP(DFS, 22));
 }
 
-static bool mt76x2_dfs_check_hw_pulse(struct mt76x2_dev *dev,
-				      struct mt76x2_dfs_hw_pulse *pulse)
+static bool mt76x2_dfs_check_hw_pulse(struct mt76x02_dev *dev,
+				      struct mt76x02_dfs_hw_pulse *pulse)
 {
 	bool ret = false;
 
@@ -371,8 +372,8 @@ static bool mt76x2_dfs_check_hw_pulse(struct mt76x2_dev *dev,
 	return ret;
 }
 
-static bool mt76x2_dfs_fetch_event(struct mt76x2_dev *dev,
-				   struct mt76x2_dfs_event *event)
+static bool mt76x2_dfs_fetch_event(struct mt76x02_dev *dev,
+				   struct mt76x02_dfs_event *event)
 {
 	u32 data;
 
@@ -398,12 +399,12 @@ static bool mt76x2_dfs_fetch_event(struct mt76x2_dev *dev,
 	return true;
 }
 
-static bool mt76x2_dfs_check_event(struct mt76x2_dev *dev,
-				   struct mt76x2_dfs_event *event)
+static bool mt76x2_dfs_check_event(struct mt76x02_dev *dev,
+				   struct mt76x02_dfs_event *event)
 {
 	if (event->engine == 2) {
-		struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
-		struct mt76x2_dfs_event_rb *event_buff = &dfs_pd->event_rb[1];
+		struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+		struct mt76x02_dfs_event_rb *event_buff = &dfs_pd->event_rb[1];
 		u16 last_event_idx;
 		u32 delta_ts;
 
@@ -417,11 +418,11 @@ static bool mt76x2_dfs_check_event(struct mt76x2_dev *dev,
 	return true;
 }
 
-static void mt76x2_dfs_queue_event(struct mt76x2_dev *dev,
-				   struct mt76x2_dfs_event *event)
+static void mt76x2_dfs_queue_event(struct mt76x02_dev *dev,
+				   struct mt76x02_dfs_event *event)
 {
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
-	struct mt76x2_dfs_event_rb *event_buff;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_event_rb *event_buff;
 
 	/* add radar event to ring buffer */
 	event_buff = event->engine == 2 ? &dfs_pd->event_rb[1]
@@ -435,16 +436,16 @@ static void mt76x2_dfs_queue_event(struct mt76x2_dev *dev,
 					     MT_DFS_EVENT_BUFLEN);
 }
 
-static int mt76x2_dfs_create_sequence(struct mt76x2_dev *dev,
-				      struct mt76x2_dfs_event *event,
+static int mt76x2_dfs_create_sequence(struct mt76x02_dev *dev,
+				      struct mt76x02_dfs_event *event,
 				      u16 cur_len)
 {
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
-	struct mt76x2_dfs_sw_detector_params *sw_params;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_sw_detector_params *sw_params;
 	u32 width_delta, with_sum, factor, cur_pri;
-	struct mt76x2_dfs_sequence seq, *seq_p;
-	struct mt76x2_dfs_event_rb *event_rb;
-	struct mt76x2_dfs_event *cur_event;
+	struct mt76x02_dfs_sequence seq, *seq_p;
+	struct mt76x02_dfs_event_rb *event_rb;
+	struct mt76x02_dfs_event *cur_event;
 	int i, j, end, pri;
 
 	event_rb = event->engine == 2 ? &dfs_pd->event_rb[1]
@@ -522,12 +523,12 @@ static int mt76x2_dfs_create_sequence(struct mt76x2_dev *dev,
 	return 0;
 }
 
-static u16 mt76x2_dfs_add_event_to_sequence(struct mt76x2_dev *dev,
-					    struct mt76x2_dfs_event *event)
+static u16 mt76x2_dfs_add_event_to_sequence(struct mt76x02_dev *dev,
+					    struct mt76x02_dfs_event *event)
 {
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
-	struct mt76x2_dfs_sw_detector_params *sw_params;
-	struct mt76x2_dfs_sequence *seq, *tmp_seq;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_sw_detector_params *sw_params;
+	struct mt76x02_dfs_sequence *seq, *tmp_seq;
 	u16 max_seq_len = 0;
 	u32 factor, pri;
 
@@ -554,10 +555,10 @@ static u16 mt76x2_dfs_add_event_to_sequence(struct mt76x2_dev *dev,
 	return max_seq_len;
 }
 
-static bool mt76x2_dfs_check_detection(struct mt76x2_dev *dev)
+static bool mt76x2_dfs_check_detection(struct mt76x02_dev *dev)
 {
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
-	struct mt76x2_dfs_sequence *seq;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_sequence *seq;
 
 	if (list_empty(&dfs_pd->sequences))
 		return false;
@@ -571,10 +572,10 @@ static bool mt76x2_dfs_check_detection(struct mt76x2_dev *dev)
 	return false;
 }
 
-static void mt76x2_dfs_add_events(struct mt76x2_dev *dev)
+static void mt76x2_dfs_add_events(struct mt76x02_dev *dev)
 {
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
-	struct mt76x2_dfs_event event;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_event event;
 	int i, seq_len;
 
 	/* disable debug mode */
@@ -598,11 +599,11 @@ static void mt76x2_dfs_add_events(struct mt76x2_dev *dev)
 	mt76x2_dfs_set_capture_mode_ctrl(dev, true);
 }
 
-static void mt76x2_dfs_check_event_window(struct mt76x2_dev *dev)
+static void mt76x2_dfs_check_event_window(struct mt76x02_dev *dev)
 {
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
-	struct mt76x2_dfs_event_rb *event_buff;
-	struct mt76x2_dfs_event *event;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_event_rb *event_buff;
+	struct mt76x02_dfs_event *event;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(dfs_pd->event_rb); i++) {
@@ -623,8 +624,8 @@ static void mt76x2_dfs_check_event_window(struct mt76x2_dev *dev)
 
 static void mt76x2_dfs_tasklet(unsigned long arg)
 {
-	struct mt76x2_dev *dev = (struct mt76x2_dev *)arg;
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dev *dev = (struct mt76x02_dev *)arg;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 	u32 engine_mask;
 	int i;
 
@@ -654,7 +655,7 @@ static void mt76x2_dfs_tasklet(unsigned long arg)
 		goto out;
 
 	for (i = 0; i < MT_DFS_NUM_ENGINES; i++) {
-		struct mt76x2_dfs_hw_pulse pulse;
+		struct mt76x02_dfs_hw_pulse pulse;
 
 		if (!(engine_mask & (1 << i)))
 			continue;
@@ -682,9 +683,9 @@ static void mt76x2_dfs_tasklet(unsigned long arg)
 	mt76x02_irq_enable(&dev->mt76, MT_INT_GPTIMER);
 }
 
-static void mt76x2_dfs_init_sw_detector(struct mt76x2_dev *dev)
+static void mt76x2_dfs_init_sw_detector(struct mt76x02_dev *dev)
 {
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
 	switch (dev->dfs_pd.region) {
 	case NL80211_DFS_FCC:
@@ -708,11 +709,11 @@ static void mt76x2_dfs_init_sw_detector(struct mt76x2_dev *dev)
 	}
 }
 
-static void mt76x2_dfs_set_bbp_params(struct mt76x2_dev *dev)
+static void mt76x2_dfs_set_bbp_params(struct mt76x02_dev *dev)
 {
-	u32 data;
+	const struct mt76x02_radar_specs *radar_specs;
 	u8 i, shift;
-	const struct mt76x2_radar_specs *radar_specs;
+	u32 data;
 
 	switch (dev->mt76.chandef.width) {
 	case NL80211_CHAN_WIDTH_40:
@@ -803,7 +804,7 @@ static void mt76x2_dfs_set_bbp_params(struct mt76x2_dev *dev)
 	mt76_wr(dev, 0x212c, 0x0c350001);
 }
 
-void mt76x2_dfs_adjust_agc(struct mt76x2_dev *dev)
+void mt76x2_dfs_adjust_agc(struct mt76x02_dev *dev)
 {
 	u32 agc_r8, agc_r4, val_r8, val_r4, dfs_r31;
 
@@ -824,7 +825,7 @@ void mt76x2_dfs_adjust_agc(struct mt76x2_dev *dev)
 	mt76_wr(dev, MT_BBP(DFS, 32), 0x00040071);
 }
 
-void mt76x2_dfs_init_params(struct mt76x2_dev *dev)
+void mt76x2_dfs_init_params(struct mt76x02_dev *dev)
 {
 	struct cfg80211_chan_def *chandef = &dev->mt76.chandef;
 
@@ -851,9 +852,9 @@ void mt76x2_dfs_init_params(struct mt76x2_dev *dev)
 	}
 }
 
-void mt76x2_dfs_init_detector(struct mt76x2_dev *dev)
+void mt76x2_dfs_init_detector(struct mt76x02_dev *dev)
 {
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
 	INIT_LIST_HEAD(&dfs_pd->sequences);
 	INIT_LIST_HEAD(&dfs_pd->seq_pool);
@@ -863,10 +864,10 @@ void mt76x2_dfs_init_detector(struct mt76x2_dev *dev)
 		     (unsigned long)dev);
 }
 
-void mt76x2_dfs_set_domain(struct mt76x2_dev *dev,
+void mt76x2_dfs_set_domain(struct mt76x02_dev *dev,
 			   enum nl80211_dfs_regions region)
 {
-	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
 	if (dfs_pd->region != region) {
 		tasklet_disable(&dfs_pd->dfs_tasklet);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
index fdd5103e8c93..35f0ceb7094b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
@@ -20,7 +20,7 @@
 
 void mt76x2_tx_tasklet(unsigned long data)
 {
-	struct mt76x2_dev *dev = (struct mt76x2_dev *) data;
+	struct mt76x02_dev *dev = (struct mt76x02_dev *) data;
 	int i;
 
 	mt76x2_mac_process_tx_status_fifo(dev);
@@ -32,7 +32,7 @@ void mt76x2_tx_tasklet(unsigned long data)
 	mt76x02_irq_enable(&dev->mt76, MT_INT_TX_DONE_ALL);
 }
 
-void mt76x2_dma_cleanup(struct mt76x2_dev *dev)
+void mt76x2_dma_cleanup(struct mt76x02_dev *dev)
 {
 	tasklet_kill(&dev->tx_tasklet);
 	mt76_dma_cleanup(&dev->mt76);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index a6c66bf08ded..2b38f97c3103 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -22,7 +22,7 @@
 #include "../mt76x02_dma.h"
 
 static void
-mt76x2_mac_pbf_init(struct mt76x2_dev *dev)
+mt76x2_mac_pbf_init(struct mt76x02_dev *dev)
 {
 	u32 val;
 
@@ -40,7 +40,7 @@ mt76x2_mac_pbf_init(struct mt76x2_dev *dev)
 }
 
 static void
-mt76x2_fixup_xtal(struct mt76x2_dev *dev)
+mt76x2_fixup_xtal(struct mt76x02_dev *dev)
 {
 	u16 eep_val;
 	s8 offset = 0;
@@ -79,7 +79,7 @@ mt76x2_fixup_xtal(struct mt76x2_dev *dev)
 	}
 }
 
-static int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
+static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 {
 	static const u8 null_addr[ETH_ALEN] = {};
 	const u8 *macaddr = dev->mt76.macaddr;
@@ -177,7 +177,7 @@ static int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
 	return 0;
 }
 
-int mt76x2_mac_start(struct mt76x2_dev *dev)
+int mt76x2_mac_start(struct mt76x02_dev *dev)
 {
 	int i;
 
@@ -193,7 +193,7 @@ int mt76x2_mac_start(struct mt76x2_dev *dev)
 	return 0;
 }
 
-void mt76x2_mac_resume(struct mt76x2_dev *dev)
+void mt76x2_mac_resume(struct mt76x02_dev *dev)
 {
 	mt76_wr(dev, MT_MAC_SYS_CTRL,
 		MT_MAC_SYS_CTRL_ENABLE_TX |
@@ -201,7 +201,7 @@ void mt76x2_mac_resume(struct mt76x2_dev *dev)
 }
 
 static void
-mt76x2_power_on_rf_patch(struct mt76x2_dev *dev)
+mt76x2_power_on_rf_patch(struct mt76x02_dev *dev)
 {
 	mt76_set(dev, 0x10130, BIT(0) | BIT(16));
 	udelay(1);
@@ -222,7 +222,7 @@ mt76x2_power_on_rf_patch(struct mt76x2_dev *dev)
 }
 
 static void
-mt76x2_power_on_rf(struct mt76x2_dev *dev, int unit)
+mt76x2_power_on_rf(struct mt76x02_dev *dev, int unit)
 {
 	int shift = unit ? 8 : 0;
 
@@ -244,7 +244,7 @@ mt76x2_power_on_rf(struct mt76x2_dev *dev, int unit)
 }
 
 static void
-mt76x2_power_on(struct mt76x2_dev *dev)
+mt76x2_power_on(struct mt76x02_dev *dev)
 {
 	u32 val;
 
@@ -279,7 +279,7 @@ mt76x2_power_on(struct mt76x2_dev *dev)
 	mt76x2_power_on_rf(dev, 1);
 }
 
-void mt76x2_set_tx_ackto(struct mt76x2_dev *dev)
+void mt76x2_set_tx_ackto(struct mt76x02_dev *dev)
 {
 	u8 ackto, sifs, slottime = dev->slottime;
 
@@ -296,7 +296,7 @@ void mt76x2_set_tx_ackto(struct mt76x2_dev *dev)
 		       MT_TX_TIMEOUT_CFG_ACKTO, ackto);
 }
 
-int mt76x2_init_hardware(struct mt76x2_dev *dev)
+int mt76x2_init_hardware(struct mt76x02_dev *dev)
 {
 	int ret;
 
@@ -335,7 +335,7 @@ int mt76x2_init_hardware(struct mt76x2_dev *dev)
 	return 0;
 }
 
-void mt76x2_stop_hardware(struct mt76x2_dev *dev)
+void mt76x2_stop_hardware(struct mt76x02_dev *dev)
 {
 	cancel_delayed_work_sync(&dev->cal_work);
 	cancel_delayed_work_sync(&dev->mac_work);
@@ -343,7 +343,7 @@ void mt76x2_stop_hardware(struct mt76x2_dev *dev)
 	mt76x2_mac_stop(dev, false);
 }
 
-void mt76x2_cleanup(struct mt76x2_dev *dev)
+void mt76x2_cleanup(struct mt76x02_dev *dev)
 {
 	tasklet_disable(&dev->dfs_pd.dfs_tasklet);
 	tasklet_disable(&dev->pre_tbtt_tasklet);
@@ -352,7 +352,7 @@ void mt76x2_cleanup(struct mt76x2_dev *dev)
 	mt76x02_mcu_cleanup(&dev->mt76);
 }
 
-struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
+struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
 {
 	static const struct mt76_driver_ops drv_ops = {
 		.txwi_size = sizeof(struct mt76x02_txwi),
@@ -364,14 +364,14 @@ struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
 		.sta_ps = mt76x2_sta_ps,
 		.get_tx_txpwr_adj = mt76x2_tx_get_txpwr_adj,
 	};
-	struct mt76x2_dev *dev;
+	struct mt76x02_dev *dev;
 	struct mt76_dev *mdev;
 
 	mdev = mt76_alloc_device(sizeof(*dev), &mt76x2_ops);
 	if (!mdev)
 		return NULL;
 
-	dev = container_of(mdev, struct mt76x2_dev, mt76);
+	dev = container_of(mdev, struct mt76x02_dev, mt76);
 	mdev->dev = pdev;
 	mdev->drv = &drv_ops;
 
@@ -382,7 +382,7 @@ static void mt76x2_regd_notifier(struct wiphy *wiphy,
 				 struct regulatory_request *request)
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	mt76x2_dfs_set_domain(dev, request->dfs_region);
 }
@@ -418,8 +418,8 @@ static const struct ieee80211_iface_combination if_comb[] = {
 static void mt76x2_led_set_config(struct mt76_dev *mt76, u8 delay_on,
 				  u8 delay_off)
 {
-	struct mt76x2_dev *dev = container_of(mt76, struct mt76x2_dev,
-					      mt76);
+	struct mt76x02_dev *dev = container_of(mt76, struct mt76x02_dev,
+					       mt76);
 	u32 val;
 
 	val = MT_LED_STATUS_DURATION(0xff) |
@@ -463,7 +463,7 @@ static void mt76x2_led_set_brightness(struct led_classdev *led_cdev,
 		mt76x2_led_set_config(mt76, 0xff, 0);
 }
 
-int mt76x2_register_device(struct mt76x2_dev *dev)
+int mt76x2_register_device(struct mt76x02_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
 	struct wiphy *wiphy = hw->wiphy;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
index 8037bfb51555..4538afc7e50e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
@@ -21,7 +21,7 @@
 #include "trace.h"
 #include "../mt76x02_util.h"
 
-void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr)
+void mt76x2_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
 {
 	idx &= 7;
 	mt76_wr(dev, MT_MAC_APC_BSSID_L(idx), get_unaligned_le32(addr));
@@ -29,7 +29,7 @@ void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr)
 		       get_unaligned_le16(addr + 4));
 }
 
-void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq)
+void mt76x2_mac_poll_tx_status(struct mt76x02_dev *dev, bool irq)
 {
 	struct mt76x02_tx_status stat = {};
 	unsigned long flags;
@@ -61,7 +61,7 @@ void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq)
 }
 
 static void
-mt76x2_mac_queue_txdone(struct mt76x2_dev *dev, struct sk_buff *skb,
+mt76x2_mac_queue_txdone(struct mt76x02_dev *dev, struct sk_buff *skb,
 			void *txwi_ptr)
 {
 	struct mt76x2_tx_info *txi = mt76x2_skb_tx_info(skb);
@@ -77,7 +77,7 @@ mt76x2_mac_queue_txdone(struct mt76x2_dev *dev, struct sk_buff *skb,
 	mt76x02_tx_complete(&dev->mt76, skb);
 }
 
-void mt76x2_mac_process_tx_status_fifo(struct mt76x2_dev *dev)
+void mt76x2_mac_process_tx_status_fifo(struct mt76x02_dev *dev)
 {
 	struct mt76x02_tx_status stat;
 	u8 update = 1;
@@ -89,7 +89,7 @@ void mt76x2_mac_process_tx_status_fifo(struct mt76x2_dev *dev)
 void mt76x2_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			    struct mt76_queue_entry *e, bool flush)
 {
-	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 
 	if (e->txwi)
 		mt76x2_mac_queue_txdone(dev, e->skb, &e->txwi->txwi);
@@ -98,7 +98,7 @@ void mt76x2_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 }
 
 static int
-mt76_write_beacon(struct mt76x2_dev *dev, int offset, struct sk_buff *skb)
+mt76_write_beacon(struct mt76x02_dev *dev, int offset, struct sk_buff *skb)
 {
 	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
 	struct mt76x02_txwi txwi;
@@ -116,7 +116,7 @@ mt76_write_beacon(struct mt76x2_dev *dev, int offset, struct sk_buff *skb)
 }
 
 static int
-__mt76x2_mac_set_beacon(struct mt76x2_dev *dev, u8 bcn_idx, struct sk_buff *skb)
+__mt76x2_mac_set_beacon(struct mt76x02_dev *dev, u8 bcn_idx, struct sk_buff *skb)
 {
 	int beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
 	int beacon_addr = mt76x02_beacon_offsets[bcn_idx];
@@ -141,7 +141,7 @@ __mt76x2_mac_set_beacon(struct mt76x2_dev *dev, u8 bcn_idx, struct sk_buff *skb)
 	return ret;
 }
 
-int mt76x2_mac_set_beacon(struct mt76x2_dev *dev, u8 vif_idx,
+int mt76x2_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 			  struct sk_buff *skb)
 {
 	bool force_update = false;
@@ -176,7 +176,8 @@ int mt76x2_mac_set_beacon(struct mt76x2_dev *dev, u8 vif_idx,
 	return 0;
 }
 
-void mt76x2_mac_set_beacon_enable(struct mt76x2_dev *dev, u8 vif_idx, bool val)
+void mt76x2_mac_set_beacon_enable(struct mt76x02_dev *dev,
+				  u8 vif_idx, bool val)
 {
 	u8 old_mask = dev->beacon_mask;
 	bool en;
@@ -208,7 +209,7 @@ void mt76x2_mac_set_beacon_enable(struct mt76x2_dev *dev, u8 vif_idx, bool val)
 
 void mt76x2_update_channel(struct mt76_dev *mdev)
 {
-	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	struct mt76_channel_state *state;
 	u32 active, busy;
 
@@ -225,8 +226,8 @@ void mt76x2_update_channel(struct mt76_dev *mdev)
 
 void mt76x2_mac_work(struct work_struct *work)
 {
-	struct mt76x2_dev *dev = container_of(work, struct mt76x2_dev,
-					    mac_work.work);
+	struct mt76x02_dev *dev = container_of(work, struct mt76x02_dev,
+					       mac_work.work);
 	int i, idx;
 
 	mt76x2_update_channel(&dev->mt76);
@@ -241,7 +242,7 @@ void mt76x2_mac_work(struct work_struct *work)
 				     MT_CALIBRATE_INTERVAL);
 }
 
-void mt76x2_mac_set_tx_protection(struct mt76x2_dev *dev, u32 val)
+void mt76x2_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val)
 {
 	u32 data = 0;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 521c9265bfe0..2556c65c6528 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -20,7 +20,7 @@
 static int
 mt76x2_start(struct ieee80211_hw *hw)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 	int ret;
 
 	mutex_lock(&dev->mt76.mutex);
@@ -46,7 +46,7 @@ mt76x2_start(struct ieee80211_hw *hw)
 static void
 mt76x2_stop(struct ieee80211_hw *hw)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	mutex_lock(&dev->mt76.mutex);
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
@@ -55,7 +55,7 @@ mt76x2_stop(struct ieee80211_hw *hw)
 }
 
 static int
-mt76x2_set_channel(struct mt76x2_dev *dev, struct cfg80211_chan_def *chandef)
+mt76x2_set_channel(struct mt76x02_dev *dev, struct cfg80211_chan_def *chandef)
 {
 	int ret;
 
@@ -91,7 +91,7 @@ mt76x2_set_channel(struct mt76x2_dev *dev, struct cfg80211_chan_def *chandef)
 static int
 mt76x2_config(struct ieee80211_hw *hw, u32 changed)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 	int ret = 0;
 
 	mutex_lock(&dev->mt76.mutex);
@@ -132,7 +132,7 @@ static void
 mt76x2_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			struct ieee80211_bss_conf *info, u32 changed)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 
 	mutex_lock(&dev->mt76.mutex);
@@ -169,7 +169,7 @@ void
 mt76x2_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 {
 	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
-	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	int idx = msta->wcid.idx;
 
 	mt76_stop_tx_queues(&dev->mt76, sta, true);
@@ -180,7 +180,7 @@ static void
 mt76x2_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	       const u8 *mac)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	tasklet_disable(&dev->pre_tbtt_tasklet);
 	set_bit(MT76_SCANNING, &dev->mt76.state);
@@ -189,7 +189,7 @@ mt76x2_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 static void
 mt76x2_sw_scan_complete(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	clear_bit(MT76_SCANNING, &dev->mt76.state);
 	tasklet_enable(&dev->pre_tbtt_tasklet);
@@ -204,7 +204,7 @@ mt76x2_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 static int
 mt76x2_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif, int *dbm)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	*dbm = dev->mt76.txpower_cur / 2;
 
@@ -217,7 +217,7 @@ mt76x2_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif, int *dbm)
 static void mt76x2_set_coverage_class(struct ieee80211_hw *hw,
 				      s16 coverage_class)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	mutex_lock(&dev->mt76.mutex);
 	dev->coverage_class = coverage_class;
@@ -234,7 +234,7 @@ mt76x2_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
 static int mt76x2_set_antenna(struct ieee80211_hw *hw, u32 tx_ant,
 			      u32 rx_ant)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	if (!tx_ant || tx_ant > 3 || tx_ant != rx_ant)
 		return -EINVAL;
@@ -255,7 +255,7 @@ static int mt76x2_set_antenna(struct ieee80211_hw *hw, u32 tx_ant,
 static int mt76x2_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant,
 			      u32 *rx_ant)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	mutex_lock(&dev->mt76.mutex);
 	*tx_ant = dev->mt76.antenna_mask;
@@ -268,7 +268,7 @@ static int mt76x2_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant,
 static int
 mt76x2_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	if (val != ~0 && val > 0xffff)
 		return -EINVAL;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
index 38fa84bddf7b..a17c9a5279ad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
@@ -24,7 +24,7 @@
 #include "../mt76x02_dma.h"
 
 static int
-mt76pci_load_rom_patch(struct mt76x2_dev *dev)
+mt76pci_load_rom_patch(struct mt76x02_dev *dev)
 {
 	const struct firmware *fw = NULL;
 	struct mt76x02_patch_header *hdr;
@@ -90,7 +90,7 @@ mt76pci_load_rom_patch(struct mt76x2_dev *dev)
 }
 
 static int
-mt76pci_load_firmware(struct mt76x2_dev *dev)
+mt76pci_load_firmware(struct mt76x02_dev *dev)
 {
 	const struct firmware *fw;
 	const struct mt76x02_fw_header *hdr;
@@ -166,7 +166,7 @@ mt76pci_load_firmware(struct mt76x2_dev *dev)
 	return -ENOENT;
 }
 
-int mt76x2_mcu_init(struct mt76x2_dev *dev)
+int mt76x2_mcu_init(struct mt76x02_dev *dev)
 {
 	static const struct mt76_mcu_ops mt76x2_mcu_ops = {
 		.mcu_msg_alloc = mt76x02_mcu_msg_alloc,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index 2ac0cc6c7126..40ea5f7480fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -21,7 +21,7 @@
 #include "../mt76x02_phy.h"
 
 static bool
-mt76x2_phy_tssi_init_cal(struct mt76x2_dev *dev)
+mt76x2_phy_tssi_init_cal(struct mt76x02_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	u32 flag = 0;
@@ -44,7 +44,7 @@ mt76x2_phy_tssi_init_cal(struct mt76x2_dev *dev)
 }
 
 static void
-mt76x2_phy_channel_calibrate(struct mt76x2_dev *dev, bool mac_stopped)
+mt76x2_phy_channel_calibrate(struct mt76x02_dev *dev, bool mac_stopped)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	bool is_5ghz = chan->band == NL80211_BAND_5GHZ;
@@ -78,7 +78,7 @@ mt76x2_phy_channel_calibrate(struct mt76x2_dev *dev, bool mac_stopped)
 	dev->cal.channel_cal_done = true;
 }
 
-void mt76x2_phy_set_antenna(struct mt76x2_dev *dev)
+void mt76x2_phy_set_antenna(struct mt76x02_dev *dev)
 {
 	u32 val;
 
@@ -125,14 +125,14 @@ void mt76x2_phy_set_antenna(struct mt76x2_dev *dev)
 }
 
 static void
-mt76x2_get_agc_gain(struct mt76x2_dev *dev, u8 *dest)
+mt76x2_get_agc_gain(struct mt76x02_dev *dev, u8 *dest)
 {
 	dest[0] = mt76_get_field(dev, MT_BBP(AGC, 8), MT_BBP_AGC_GAIN);
 	dest[1] = mt76_get_field(dev, MT_BBP(AGC, 9), MT_BBP_AGC_GAIN);
 }
 
 static int
-mt76x2_get_rssi_gain_thresh(struct mt76x2_dev *dev)
+mt76x2_get_rssi_gain_thresh(struct mt76x02_dev *dev)
 {
 	switch (dev->mt76.chandef.width) {
 	case NL80211_CHAN_WIDTH_80:
@@ -145,7 +145,7 @@ mt76x2_get_rssi_gain_thresh(struct mt76x2_dev *dev)
 }
 
 static int
-mt76x2_get_low_rssi_gain_thresh(struct mt76x2_dev *dev)
+mt76x2_get_low_rssi_gain_thresh(struct mt76x02_dev *dev)
 {
 	switch (dev->mt76.chandef.width) {
 	case NL80211_CHAN_WIDTH_80:
@@ -158,7 +158,7 @@ mt76x2_get_low_rssi_gain_thresh(struct mt76x2_dev *dev)
 }
 
 static void
-mt76x2_phy_set_gain_val(struct mt76x2_dev *dev)
+mt76x2_phy_set_gain_val(struct mt76x02_dev *dev)
 {
 	u32 val;
 	u8 gain_val[2];
@@ -183,7 +183,7 @@ mt76x2_phy_set_gain_val(struct mt76x2_dev *dev)
 }
 
 static void
-mt76x2_phy_adjust_vga_gain(struct mt76x2_dev *dev)
+mt76x2_phy_adjust_vga_gain(struct mt76x02_dev *dev)
 {
 	u32 false_cca;
 	u8 limit = dev->cal.low_gain > 0 ? 16 : 4;
@@ -202,7 +202,7 @@ mt76x2_phy_adjust_vga_gain(struct mt76x2_dev *dev)
 }
 
 static void
-mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
+mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
 {
 	u8 *gain = dev->cal.agc_gain_init;
 	u8 low_gain_delta, gain_delta;
@@ -265,7 +265,7 @@ mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
 	mt76_rr(dev, MT_RX_STAT_1);
 }
 
-int mt76x2_phy_set_channel(struct mt76x2_dev *dev,
+int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 			   struct cfg80211_chan_def *chandef)
 {
 	struct ieee80211_channel *chan = chandef->chan;
@@ -405,7 +405,7 @@ int mt76x2_phy_set_channel(struct mt76x2_dev *dev,
 }
 
 static void
-mt76x2_phy_temp_compensate(struct mt76x2_dev *dev)
+mt76x2_phy_temp_compensate(struct mt76x02_dev *dev)
 {
 	struct mt76x2_temp_comp t;
 	int temp, db_diff;
@@ -434,9 +434,9 @@ mt76x2_phy_temp_compensate(struct mt76x2_dev *dev)
 
 void mt76x2_phy_calibrate(struct work_struct *work)
 {
-	struct mt76x2_dev *dev;
+	struct mt76x02_dev *dev;
 
-	dev = container_of(work, struct mt76x2_dev, cal_work.work);
+	dev = container_of(work, struct mt76x02_dev, cal_work.work);
 	mt76x2_phy_channel_calibrate(dev, false);
 	mt76x2_phy_tssi_compensate(dev, true);
 	mt76x2_phy_temp_compensate(dev);
@@ -445,7 +445,7 @@ void mt76x2_phy_calibrate(struct work_struct *work)
 				     MT_CALIBRATE_INTERVAL);
 }
 
-int mt76x2_phy_start(struct mt76x2_dev *dev)
+int mt76x2_phy_start(struct mt76x02_dev *dev)
 {
 	int ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
index bef28d57bfcc..ab9cb632222c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_tx.c
@@ -19,7 +19,7 @@
 #include "../mt76x02_dma.h"
 
 struct beacon_bc_data {
-	struct mt76x2_dev *dev;
+	struct mt76x02_dev *dev;
 	struct sk_buff_head q;
 	struct sk_buff *tail[8];
 };
@@ -29,7 +29,7 @@ int mt76x2_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			  u32 *tx_info)
 {
-	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int qsel = MT_QSEL_EDCA;
 	int ret;
@@ -58,7 +58,7 @@ int mt76x2_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 static void
 mt76x2_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 {
-	struct mt76x2_dev *dev = (struct mt76x2_dev *) priv;
+	struct mt76x02_dev *dev = (struct mt76x02_dev *) priv;
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	struct sk_buff *skb = NULL;
 
@@ -76,7 +76,7 @@ static void
 mt76x2_add_buffered_bc(void *priv, u8 *mac, struct ieee80211_vif *vif)
 {
 	struct beacon_bc_data *data = priv;
-	struct mt76x2_dev *dev = data->dev;
+	struct mt76x02_dev *dev = data->dev;
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
@@ -97,7 +97,7 @@ mt76x2_add_buffered_bc(void *priv, u8 *mac, struct ieee80211_vif *vif)
 }
 
 static void
-mt76x2_resync_beacon_timer(struct mt76x2_dev *dev)
+mt76x2_resync_beacon_timer(struct mt76x02_dev *dev)
 {
 	u32 timer_val = dev->beacon_int << 4;
 
@@ -129,7 +129,7 @@ mt76x2_resync_beacon_timer(struct mt76x2_dev *dev)
 
 void mt76x2_pre_tbtt_tasklet(unsigned long arg)
 {
-	struct mt76x2_dev *dev = (struct mt76x2_dev *) arg;
+	struct mt76x02_dev *dev = (struct mt76x02_dev *) arg;
 	struct mt76_queue *q = &dev->mt76.q_tx[MT_TXQ_PSD];
 	struct beacon_bc_data data = {};
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index 06ef2c4a5c11..f00aed915ee8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -21,7 +21,7 @@
 #include "../mt76x02_phy.h"
 
 static void
-mt76x2_adjust_high_lna_gain(struct mt76x2_dev *dev, int reg, s8 offset)
+mt76x2_adjust_high_lna_gain(struct mt76x02_dev *dev, int reg, s8 offset)
 {
 	s8 gain;
 
@@ -31,7 +31,7 @@ mt76x2_adjust_high_lna_gain(struct mt76x2_dev *dev, int reg, s8 offset)
 }
 
 static void
-mt76x2_adjust_agc_gain(struct mt76x2_dev *dev, int reg, s8 offset)
+mt76x2_adjust_agc_gain(struct mt76x02_dev *dev, int reg, s8 offset)
 {
 	s8 gain;
 
@@ -40,7 +40,7 @@ mt76x2_adjust_agc_gain(struct mt76x2_dev *dev, int reg, s8 offset)
 	mt76_rmw_field(dev, MT_BBP(AGC, reg), MT_BBP_AGC_GAIN, gain);
 }
 
-void mt76x2_apply_gain_adj(struct mt76x2_dev *dev)
+void mt76x2_apply_gain_adj(struct mt76x02_dev *dev)
 {
 	s8 *gain_adj = dev->cal.rx.high_gain;
 
@@ -52,7 +52,7 @@ void mt76x2_apply_gain_adj(struct mt76x2_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x2_apply_gain_adj);
 
-void mt76x2_phy_set_txpower_regs(struct mt76x2_dev *dev,
+void mt76x2_phy_set_txpower_regs(struct mt76x02_dev *dev,
 				 enum nl80211_band band)
 {
 	u32 pa_mode[2];
@@ -144,7 +144,7 @@ mt76x2_get_min_rate_power(struct mt76_rate_power *r)
 	return ret;
 }
 
-void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
+void mt76x2_phy_set_txpower(struct mt76x02_dev *dev)
 {
 	enum nl80211_chan_width width = dev->mt76.chandef.width;
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
@@ -191,7 +191,7 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x2_phy_set_txpower);
 
-void mt76x2_configure_tx_delay(struct mt76x2_dev *dev,
+void mt76x2_configure_tx_delay(struct mt76x02_dev *dev,
 			       enum nl80211_band band, u8 bw)
 {
 	u32 cfg0, cfg1;
@@ -210,7 +210,7 @@ void mt76x2_configure_tx_delay(struct mt76x2_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x2_configure_tx_delay);
 
-void mt76x2_phy_set_bw(struct mt76x2_dev *dev, int width, u8 ctrl)
+void mt76x2_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl)
 {
 	int core_val, agc_val;
 
@@ -236,7 +236,7 @@ void mt76x2_phy_set_bw(struct mt76x2_dev *dev, int width, u8 ctrl)
 }
 EXPORT_SYMBOL_GPL(mt76x2_phy_set_bw);
 
-void mt76x2_phy_set_band(struct mt76x2_dev *dev, int band, bool primary_upper)
+void mt76x2_phy_set_band(struct mt76x02_dev *dev, int band, bool primary_upper)
 {
 	switch (band) {
 	case NL80211_BAND_2GHZ:
@@ -254,7 +254,7 @@ void mt76x2_phy_set_band(struct mt76x2_dev *dev, int band, bool primary_upper)
 }
 EXPORT_SYMBOL_GPL(mt76x2_phy_set_band);
 
-void mt76x2_phy_tssi_compensate(struct mt76x2_dev *dev, bool wait)
+void mt76x2_phy_tssi_compensate(struct mt76x02_dev *dev, bool wait)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	struct mt76x2_tx_power_info txp;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h b/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h
index 9dceabace936..ef88623fa6c9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h
@@ -35,7 +35,7 @@
 #define TXID_PR_ARG	__entry->wcid, __entry->pktid
 
 DECLARE_EVENT_CLASS(dev_evt,
-	TP_PROTO(struct mt76x2_dev *dev),
+	TP_PROTO(struct mt76x02_dev *dev),
 	TP_ARGS(dev),
 	TP_STRUCT__entry(
 		DEV_ENTRY
@@ -47,7 +47,7 @@ DECLARE_EVENT_CLASS(dev_evt,
 );
 
 DECLARE_EVENT_CLASS(dev_txid_evt,
-	TP_PROTO(struct mt76x2_dev *dev, u8 wcid, u8 pktid),
+	TP_PROTO(struct mt76x02_dev *dev, u8 wcid, u8 pktid),
 	TP_ARGS(dev, wcid, pktid),
 	TP_STRUCT__entry(
 		DEV_ENTRY
@@ -64,17 +64,17 @@ DECLARE_EVENT_CLASS(dev_txid_evt,
 );
 
 DEFINE_EVENT(dev_evt, mac_txstat_poll,
-	TP_PROTO(struct mt76x2_dev *dev),
+	TP_PROTO(struct mt76x02_dev *dev),
 	TP_ARGS(dev)
 );
 
 DEFINE_EVENT(dev_txid_evt, mac_txdone_add,
-	TP_PROTO(struct mt76x2_dev *dev, u8 wcid, u8 pktid),
+	TP_PROTO(struct mt76x02_dev *dev, u8 wcid, u8 pktid),
 	TP_ARGS(dev, wcid, pktid)
 );
 
 TRACE_EVENT(mac_txstat_fetch,
-	TP_PROTO(struct mt76x2_dev *dev,
+	TP_PROTO(struct mt76x02_dev *dev,
 		 struct mt76x02_tx_status *stat),
 
 	TP_ARGS(dev, stat),
@@ -112,7 +112,7 @@ TRACE_EVENT(mac_txstat_fetch,
 
 
 TRACE_EVENT(dev_irq,
-	TP_PROTO(struct mt76x2_dev *dev, u32 val, u32 mask),
+	TP_PROTO(struct mt76x02_dev *dev, u32 val, u32 mask),
 
 	TP_ARGS(dev, val, mask),
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
index c8203e49560c..144ee6973797 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/tx.c
@@ -22,7 +22,7 @@ void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	       struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 	struct ieee80211_vif *vif = info->control.vif;
 	struct mt76_wcid *wcid = &dev->mt76.global_wcid;
 
@@ -49,7 +49,7 @@ EXPORT_SYMBOL_GPL(mt76x2_tx);
 
 s8 mt76x2_tx_get_txpwr_adj(struct mt76_dev *mdev, s8 txpwr, s8 max_txpwr_adj)
 {
-	struct mt76x2_dev  *dev = container_of(mdev, struct mt76x2_dev, mt76);
+	struct mt76x02_dev  *dev = container_of(mdev, struct mt76x02_dev, mt76);
 
 	txpwr = min_t(s8, txpwr, dev->mt76.txpower_conf);
 	txpwr -= (dev->target_power + dev->target_power_delta[0]);
@@ -64,7 +64,7 @@ s8 mt76x2_tx_get_txpwr_adj(struct mt76_dev *mdev, s8 txpwr, s8 max_txpwr_adj)
 }
 EXPORT_SYMBOL_GPL(mt76x2_tx_get_txpwr_adj);
 
-void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr)
+void mt76x2_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr)
 {
 	s8 txpwr_adj;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index b0c172107aae..57baf8d1c830 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -37,7 +37,7 @@ static int mt76x2u_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
-	struct mt76x2_dev *dev;
+	struct mt76x02_dev *dev;
 	int err;
 
 	dev = mt76x2u_alloc_device(&intf->dev);
@@ -72,7 +72,7 @@ static int mt76x2u_probe(struct usb_interface *intf,
 static void mt76x2u_disconnect(struct usb_interface *intf)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
-	struct mt76x2_dev *dev = usb_get_intfdata(intf);
+	struct mt76x02_dev *dev = usb_get_intfdata(intf);
 	struct ieee80211_hw *hw = mt76_hw(dev);
 
 	set_bit(MT76_REMOVED, &dev->mt76.state);
@@ -87,7 +87,7 @@ static void mt76x2u_disconnect(struct usb_interface *intf)
 static int __maybe_unused mt76x2u_suspend(struct usb_interface *intf,
 					  pm_message_t state)
 {
-	struct mt76x2_dev *dev = usb_get_intfdata(intf);
+	struct mt76x02_dev *dev = usb_get_intfdata(intf);
 	struct mt76_usb *usb = &dev->mt76.usb;
 
 	mt76u_stop_queues(&dev->mt76);
@@ -99,7 +99,7 @@ static int __maybe_unused mt76x2u_suspend(struct usb_interface *intf,
 
 static int __maybe_unused mt76x2u_resume(struct usb_interface *intf)
 {
-	struct mt76x2_dev *dev = usb_get_intfdata(intf);
+	struct mt76x02_dev *dev = usb_get_intfdata(intf);
 	struct mt76_usb *usb = &dev->mt76.usb;
 	int err;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index d00c449d13b8..abadcc503281 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -22,7 +22,7 @@
 #include "eeprom.h"
 #include "../mt76x02_usb.h"
 
-static void mt76x2u_init_dma(struct mt76x2_dev *dev)
+static void mt76x2u_init_dma(struct mt76x02_dev *dev)
 {
 	u32 val = mt76_rr(dev, MT_VEND_ADDR(CFG, MT_USB_U3DMA_CFG));
 
@@ -37,7 +37,7 @@ static void mt76x2u_init_dma(struct mt76x2_dev *dev)
 	mt76_wr(dev, MT_VEND_ADDR(CFG, MT_USB_U3DMA_CFG), val);
 }
 
-static void mt76x2u_power_on_rf_patch(struct mt76x2_dev *dev)
+static void mt76x2u_power_on_rf_patch(struct mt76x02_dev *dev)
 {
 	mt76_set(dev, MT_VEND_ADDR(CFG, 0x130), BIT(0) | BIT(16));
 	udelay(1);
@@ -57,7 +57,7 @@ static void mt76x2u_power_on_rf_patch(struct mt76x2_dev *dev)
 	mt76_set(dev, MT_VEND_ADDR(CFG, 0x14c), BIT(19) | BIT(20));
 }
 
-static void mt76x2u_power_on_rf(struct mt76x2_dev *dev, int unit)
+static void mt76x2u_power_on_rf(struct mt76x02_dev *dev, int unit)
 {
 	int shift = unit ? 8 : 0;
 	u32 val = (BIT(1) | BIT(3) | BIT(4) | BIT(5)) << shift;
@@ -79,7 +79,7 @@ static void mt76x2u_power_on_rf(struct mt76x2_dev *dev, int unit)
 	mt76_set(dev, 0x530, 0xf);
 }
 
-static void mt76x2u_power_on(struct mt76x2_dev *dev)
+static void mt76x2u_power_on(struct mt76x02_dev *dev)
 {
 	u32 val;
 
@@ -115,7 +115,7 @@ static void mt76x2u_power_on(struct mt76x2_dev *dev)
 	mt76x2u_power_on_rf(dev, 1);
 }
 
-static int mt76x2u_init_eeprom(struct mt76x2_dev *dev)
+static int mt76x2u_init_eeprom(struct mt76x02_dev *dev)
 {
 	u32 val, i;
 
@@ -135,7 +135,7 @@ static int mt76x2u_init_eeprom(struct mt76x2_dev *dev)
 	return 0;
 }
 
-struct mt76x2_dev *mt76x2u_alloc_device(struct device *pdev)
+struct mt76x02_dev *mt76x2u_alloc_device(struct device *pdev)
 {
 	static const struct mt76_driver_ops drv_ops = {
 		.tx_prepare_skb = mt76x02u_tx_prepare_skb,
@@ -143,21 +143,21 @@ struct mt76x2_dev *mt76x2u_alloc_device(struct device *pdev)
 		.tx_status_data = mt76x02_tx_status_data,
 		.rx_skb = mt76x2_queue_rx_skb,
 	};
-	struct mt76x2_dev *dev;
+	struct mt76x02_dev *dev;
 	struct mt76_dev *mdev;
 
 	mdev = mt76_alloc_device(sizeof(*dev), &mt76x2u_ops);
 	if (!mdev)
 		return NULL;
 
-	dev = container_of(mdev, struct mt76x2_dev, mt76);
+	dev = container_of(mdev, struct mt76x02_dev, mt76);
 	mdev->dev = pdev;
 	mdev->drv = &drv_ops;
 
 	return dev;
 }
 
-static void mt76x2u_init_beacon_offsets(struct mt76x2_dev *dev)
+static void mt76x2u_init_beacon_offsets(struct mt76x02_dev *dev)
 {
 	mt76_wr(dev, MT_BCN_OFFSET(0), 0x18100800);
 	mt76_wr(dev, MT_BCN_OFFSET(1), 0x38302820);
@@ -165,7 +165,7 @@ static void mt76x2u_init_beacon_offsets(struct mt76x2_dev *dev)
 	mt76_wr(dev, MT_BCN_OFFSET(3), 0x78706860);
 }
 
-int mt76x2u_init_hardware(struct mt76x2_dev *dev)
+int mt76x2u_init_hardware(struct mt76x02_dev *dev)
 {
 	const struct mt76_wcid_addr addr = {
 		.macaddr = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff},
@@ -244,7 +244,7 @@ int mt76x2u_init_hardware(struct mt76x2_dev *dev)
 	return mt76x2u_mac_stop(dev);
 }
 
-int mt76x2u_register_device(struct mt76x2_dev *dev)
+int mt76x2u_register_device(struct mt76x02_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
 	struct wiphy *wiphy = hw->wiphy;
@@ -295,14 +295,14 @@ int mt76x2u_register_device(struct mt76x2_dev *dev)
 	return err;
 }
 
-void mt76x2u_stop_hw(struct mt76x2_dev *dev)
+void mt76x2u_stop_hw(struct mt76x02_dev *dev)
 {
 	mt76u_stop_stat_wk(&dev->mt76);
 	cancel_delayed_work_sync(&dev->cal_work);
 	mt76x2u_mac_stop(dev);
 }
 
-void mt76x2u_cleanup(struct mt76x2_dev *dev)
+void mt76x2u_cleanup(struct mt76x02_dev *dev)
 {
 	mt76x02_mcu_set_radio_state(&dev->mt76, false, false);
 	mt76x2u_stop_hw(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
index ae89461f803c..dbd635aa763b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mac.c
@@ -17,7 +17,7 @@
 #include "mt76x2u.h"
 #include "eeprom.h"
 
-static void mt76x2u_mac_reset_counters(struct mt76x2_dev *dev)
+static void mt76x2u_mac_reset_counters(struct mt76x02_dev *dev)
 {
 	mt76_rr(dev, MT_RX_STAT_0);
 	mt76_rr(dev, MT_RX_STAT_1);
@@ -27,7 +27,7 @@ static void mt76x2u_mac_reset_counters(struct mt76x2_dev *dev)
 	mt76_rr(dev, MT_TX_STA_2);
 }
 
-static void mt76x2u_mac_fixup_xtal(struct mt76x2_dev *dev)
+static void mt76x2u_mac_fixup_xtal(struct mt76x02_dev *dev)
 {
 	s8 offset = 0;
 	u16 eep_val;
@@ -80,7 +80,7 @@ static void mt76x2u_mac_fixup_xtal(struct mt76x2_dev *dev)
 	}
 }
 
-int mt76x2u_mac_reset(struct mt76x2_dev *dev)
+int mt76x2u_mac_reset(struct mt76x02_dev *dev)
 {
 	mt76_wr(dev, MT_WPDMA_GLO_CFG, BIT(4) | BIT(5));
 
@@ -114,7 +114,7 @@ int mt76x2u_mac_reset(struct mt76x2_dev *dev)
 	return 0;
 }
 
-int mt76x2u_mac_start(struct mt76x2_dev *dev)
+int mt76x2u_mac_start(struct mt76x02_dev *dev)
 {
 	mt76x2u_mac_reset_counters(dev);
 
@@ -131,7 +131,7 @@ int mt76x2u_mac_start(struct mt76x2_dev *dev)
 	return 0;
 }
 
-int mt76x2u_mac_stop(struct mt76x2_dev *dev)
+int mt76x2u_mac_stop(struct mt76x02_dev *dev)
 {
 	int i, count = 0, val;
 	bool stopped = false;
@@ -212,7 +212,7 @@ int mt76x2u_mac_stop(struct mt76x2_dev *dev)
 	return 0;
 }
 
-void mt76x2u_mac_resume(struct mt76x2_dev *dev)
+void mt76x2u_mac_resume(struct mt76x02_dev *dev)
 {
 	mt76_wr(dev, MT_MAC_SYS_CTRL,
 		MT_MAC_SYS_CTRL_ENABLE_TX |
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 26f1c04ea448..6c2f26c6722e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -19,7 +19,7 @@
 
 static int mt76x2u_start(struct ieee80211_hw *hw)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 	int ret;
 
 	mutex_lock(&dev->mt76.mutex);
@@ -37,7 +37,7 @@ static int mt76x2u_start(struct ieee80211_hw *hw)
 
 static void mt76x2u_stop(struct ieee80211_hw *hw)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	mutex_lock(&dev->mt76.mutex);
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
@@ -48,7 +48,7 @@ static void mt76x2u_stop(struct ieee80211_hw *hw)
 static int mt76x2u_add_interface(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
 		mt76x02_mac_setaddr(&dev->mt76, vif->addr);
@@ -58,7 +58,7 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
 }
 
 static int
-mt76x2u_set_channel(struct mt76x2_dev *dev,
+mt76x2u_set_channel(struct mt76x02_dev *dev,
 		    struct cfg80211_chan_def *chandef)
 {
 	int err;
@@ -86,7 +86,7 @@ static void
 mt76x2u_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 struct ieee80211_bss_conf *info, u32 changed)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	mutex_lock(&dev->mt76.mutex);
 
@@ -108,7 +108,7 @@ mt76x2u_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 static int
 mt76x2u_config(struct ieee80211_hw *hw, u32 changed)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 	int err = 0;
 
 	mutex_lock(&dev->mt76.mutex);
@@ -146,7 +146,7 @@ static void
 mt76x2u_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		const u8 *mac)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	set_bit(MT76_SCANNING, &dev->mt76.state);
 }
@@ -154,7 +154,7 @@ mt76x2u_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 static void
 mt76x2u_sw_scan_complete(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
-	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x02_dev *dev = hw->priv;
 
 	clear_bit(MT76_SCANNING, &dev->mt76.state);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
index 35e157be456c..259ceae2a3a9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
@@ -29,7 +29,7 @@
 #define MT76U_MCU_DLM_OFFSET		0x110000
 #define MT76U_MCU_ROM_PATCH_OFFSET	0x90000
 
-int mt76x2u_mcu_set_dynamic_vga(struct mt76x2_dev *dev, u8 channel, bool ap,
+int mt76x2u_mcu_set_dynamic_vga(struct mt76x02_dev *dev, u8 channel, bool ap,
 				bool ext, int rssi, u32 false_cca)
 {
 	struct {
@@ -53,14 +53,14 @@ int mt76x2u_mcu_set_dynamic_vga(struct mt76x2_dev *dev, u8 channel, bool ap,
 	return mt76_mcu_send_msg(dev, skb, CMD_DYNC_VGA_OP, true);
 }
 
-static void mt76x2u_mcu_load_ivb(struct mt76x2_dev *dev)
+static void mt76x2u_mcu_load_ivb(struct mt76x02_dev *dev)
 {
 	mt76u_vendor_request(&dev->mt76, MT_VEND_DEV_MODE,
 			     USB_DIR_OUT | USB_TYPE_VENDOR,
 			     0x12, 0, NULL, 0);
 }
 
-static void mt76x2u_mcu_enable_patch(struct mt76x2_dev *dev)
+static void mt76x2u_mcu_enable_patch(struct mt76x02_dev *dev)
 {
 	struct mt76_usb *usb = &dev->mt76.usb;
 	const u8 data[] = {
@@ -75,7 +75,7 @@ static void mt76x2u_mcu_enable_patch(struct mt76x2_dev *dev)
 			     0x12, 0, usb->data, sizeof(data));
 }
 
-static void mt76x2u_mcu_reset_wmt(struct mt76x2_dev *dev)
+static void mt76x2u_mcu_reset_wmt(struct mt76x02_dev *dev)
 {
 	struct mt76_usb *usb = &dev->mt76.usb;
 	u8 data[] = {
@@ -89,7 +89,7 @@ static void mt76x2u_mcu_reset_wmt(struct mt76x2_dev *dev)
 			     0x12, 0, usb->data, sizeof(data));
 }
 
-static int mt76x2u_mcu_load_rom_patch(struct mt76x2_dev *dev)
+static int mt76x2u_mcu_load_rom_patch(struct mt76x02_dev *dev)
 {
 	bool rom_protect = !is_mt7612(dev);
 	struct mt76x02_patch_header *hdr;
@@ -176,7 +176,7 @@ static int mt76x2u_mcu_load_rom_patch(struct mt76x2_dev *dev)
 	return err;
 }
 
-static int mt76x2u_mcu_load_firmware(struct mt76x2_dev *dev)
+static int mt76x2u_mcu_load_firmware(struct mt76x02_dev *dev)
 {
 	u32 val, dlm_offset = MT76U_MCU_DLM_OFFSET;
 	const struct mt76x02_fw_header *hdr;
@@ -268,7 +268,7 @@ static int mt76x2u_mcu_load_firmware(struct mt76x2_dev *dev)
 	return err;
 }
 
-int mt76x2u_mcu_fw_init(struct mt76x2_dev *dev)
+int mt76x2u_mcu_fw_init(struct mt76x02_dev *dev)
 {
 	int err;
 
@@ -279,7 +279,7 @@ int mt76x2u_mcu_fw_init(struct mt76x2_dev *dev)
 	return mt76x2u_mcu_load_firmware(dev);
 }
 
-int mt76x2u_mcu_init(struct mt76x2_dev *dev)
+int mt76x2u_mcu_init(struct mt76x02_dev *dev)
 {
 	int err;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index b14c073b0006..b11f8a6a6254 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -18,7 +18,7 @@
 #include "eeprom.h"
 #include "../mt76x02_phy.h"
 
-void mt76x2u_phy_channel_calibrate(struct mt76x2_dev *dev)
+void mt76x2u_phy_channel_calibrate(struct mt76x02_dev *dev)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	bool is_5ghz = chan->band == NL80211_BAND_5GHZ;
@@ -40,7 +40,7 @@ void mt76x2u_phy_channel_calibrate(struct mt76x2_dev *dev)
 }
 
 static void
-mt76x2u_phy_update_channel_gain(struct mt76x2_dev *dev)
+mt76x2u_phy_update_channel_gain(struct mt76x02_dev *dev)
 {
 	u8 channel = dev->mt76.chandef.chan->hw_value;
 	int freq, freq1;
@@ -79,9 +79,9 @@ mt76x2u_phy_update_channel_gain(struct mt76x2_dev *dev)
 
 void mt76x2u_phy_calibrate(struct work_struct *work)
 {
-	struct mt76x2_dev *dev;
+	struct mt76x02_dev *dev;
 
-	dev = container_of(work, struct mt76x2_dev, cal_work.work);
+	dev = container_of(work, struct mt76x02_dev, cal_work.work);
 	mt76x2_phy_tssi_compensate(dev, false);
 	mt76x2u_phy_update_channel_gain(dev);
 
@@ -89,7 +89,7 @@ void mt76x2u_phy_calibrate(struct work_struct *work)
 				     MT_CALIBRATE_INTERVAL);
 }
 
-int mt76x2u_phy_set_channel(struct mt76x2_dev *dev,
+int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 			    struct cfg80211_chan_def *chandef)
 {
 	u32 ext_cca_chan[4] = {
-- 
2.19.0

