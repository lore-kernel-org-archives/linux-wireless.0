Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55528 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932892AbeFUJSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Jun 2018 05:18:05 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 7/9] mt76: add a debugfs file to dump agc calibration information
Date: Thu, 21 Jun 2018 11:17:59 +0200
Message-Id: <20180621091801.41184-7-nbd@nbd.name> (sfid-20180621_111820_220239_72B01870)
In-Reply-To: <20180621091801.41184-1-nbd@nbd.name>
References: <20180621091801.41184-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Useful for debugging gain adjustment issues triggered by signal strength
changes.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  1 +
 .../net/wireless/mediatek/mt76/mt76x2_debugfs.c    | 14 ++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c    |  1 +
 3 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 06ca5a77dfdf..21de1168076d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -72,6 +72,7 @@ struct mt76x2_calibration {
 	int avg_rssi[MT_MAX_CHAINS];
 	int avg_rssi_all;
 
+	u16 false_cca;
 	s8 agc_gain_adjust;
 	s8 low_gain;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
index 955ea3e692dd..3f86e01049f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
@@ -115,6 +115,18 @@ static const struct file_operations fops_dfs_stat = {
 	.release = single_release,
 };
 
+static int read_agc(struct seq_file *file, void *data)
+{
+	struct mt76x2_dev *dev = dev_get_drvdata(file->private);
+
+	seq_printf(file, "avg_rssi: %d\n", dev->cal.avg_rssi_all);
+	seq_printf(file, "low_gain: %d\n", dev->cal.low_gain);
+	seq_printf(file, "false_cca: %d\n", dev->cal.false_cca);
+	seq_printf(file, "agc_gain_adjust: %d\n", dev->cal.agc_gain_adjust);
+
+	return 0;
+}
+
 void mt76x2_init_debugfs(struct mt76x2_dev *dev)
 {
 	struct dentry *dir;
@@ -130,4 +142,6 @@ void mt76x2_init_debugfs(struct mt76x2_dev *dev)
 	debugfs_create_file("dfs_stats", 0400, dir, dev, &fops_dfs_stat);
 	debugfs_create_devm_seqfile(dev->mt76.dev, "txpower", dir,
 				    read_txpower);
+
+	debugfs_create_devm_seqfile(dev->mt76.dev, "agc", dir, read_agc);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index 9c7b19ce73f2..94943aeb249d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -488,6 +488,7 @@ mt76x2_phy_adjust_vga_gain(struct mt76x2_dev *dev)
 	u8 limit = dev->cal.low_gain > 0 ? 16 : 4;
 
 	false_cca = FIELD_GET(MT_RX_STAT_1_CCA_ERRORS, mt76_rr(dev, MT_RX_STAT_1));
+	dev->cal.false_cca = false_cca;
 	if (false_cca > 800 && dev->cal.agc_gain_adjust < limit)
 		dev->cal.agc_gain_adjust += 2;
 	else if (false_cca < 10 && dev->cal.agc_gain_adjust > 0)
-- 
2.17.0
