Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52460 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729025AbeIVRjO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 13:39:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id l7-v6so628322wme.2
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2018 04:45:56 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 8/9] mt76x0: use shared debugfs implementation
Date: Sat, 22 Sep 2018 13:45:36 +0200
Message-Id: <20180922114537.24004-9-lorenzo.bianconi@redhat.com> (sfid-20180922_134906_956974_4FC76053)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use mt76 shared debugfs implementation and remove duplicated code
in mt76x0 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   | 80 +------------------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  2 -
 2 files changed, 1 insertion(+), 81 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
index 75484cd0c9de..ddc1af626b3b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
@@ -18,26 +18,6 @@
 #include "mt76x0.h"
 #include "eeprom.h"
 
-static int
-mt76_reg_set(void *data, u64 val)
-{
-	struct mt76x0_dev *dev = data;
-
-	mt76_wr(dev, dev->debugfs_reg, val);
-	return 0;
-}
-
-static int
-mt76_reg_get(void *data, u64 *val)
-{
-	struct mt76x0_dev *dev = data;
-
-	*val = mt76_rr(dev, dev->debugfs_reg);
-	return 0;
-}
-
-DEFINE_SIMPLE_ATTRIBUTE(fops_regval, mt76_reg_get, mt76_reg_set, "0x%08llx\n");
-
 static int
 mt76x0_ampdu_stat_read(struct seq_file *file, void *data)
 {
@@ -95,71 +75,13 @@ static const struct file_operations fops_ampdu_stat = {
 	.release = single_release,
 };
 
-static int
-mt76x0_eeprom_param_read(struct seq_file *file, void *data)
-{
-	struct mt76x0_dev *dev = file->private;
-	u16 val;
-
-	seq_printf(file, "RF freq offset: %hhx\n",
-		   dev->caldata.freq_offset);
-	seq_printf(file, "RSSI offset: %hhx %hhx\n",
-		   dev->caldata.rssi_offset[0], dev->caldata.rssi_offset[1]);
-	seq_printf(file, "Temperature offset: %hhx\n",
-		   dev->caldata.temp_offset);
-	seq_printf(file, "LNA gain: %x\n", dev->caldata.lna_gain);
-
-	val = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_0);
-	seq_printf(file, "Power Amplifier type %lx\n",
-		   val & MT_EE_NIC_CONF_0_PA_TYPE);
-
-	return 0;
-}
-
-static int
-mt76x0_eeprom_param_open(struct inode *inode, struct file *f)
-{
-	return single_open(f, mt76x0_eeprom_param_read, inode->i_private);
-}
-
-static const struct file_operations fops_eeprom_param = {
-	.open = mt76x0_eeprom_param_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int mt76x0_read_txpower(struct seq_file *file, void *data)
-{
-	struct mt76x0_dev *dev = dev_get_drvdata(file->private);
-
-	mt76_seq_puts_array(file, "CCK", dev->mt76.rate_power.cck,
-			    ARRAY_SIZE(dev->mt76.rate_power.cck));
-	mt76_seq_puts_array(file, "OFDM", dev->mt76.rate_power.ofdm,
-			    ARRAY_SIZE(dev->mt76.rate_power.ofdm));
-	mt76_seq_puts_array(file, "STBC", dev->mt76.rate_power.stbc,
-			    ARRAY_SIZE(dev->mt76.rate_power.stbc));
-	mt76_seq_puts_array(file, "HT", dev->mt76.rate_power.ht,
-			    ARRAY_SIZE(dev->mt76.rate_power.ht));
-	mt76_seq_puts_array(file, "VHT", dev->mt76.rate_power.vht,
-			    ARRAY_SIZE(dev->mt76.rate_power.vht));
-	return 0;
-}
-
 void mt76x0_init_debugfs(struct mt76x0_dev *dev)
 {
 	struct dentry *dir;
 
-	dir = debugfs_create_dir("mt76x0", dev->mt76.hw->wiphy->debugfsdir);
+	dir = mt76_register_debugfs(&dev->mt76);
 	if (!dir)
 		return;
 
-	debugfs_create_u32("regidx", S_IRUSR | S_IWUSR, dir, &dev->debugfs_reg);
-	debugfs_create_file("regval", S_IRUSR | S_IWUSR, dir, dev,
-			    &fops_regval);
 	debugfs_create_file("ampdu_stat", S_IRUSR, dir, dev, &fops_ampdu_stat);
-	debugfs_create_file("eeprom_param", S_IRUSR, dir, dev,
-			    &fops_eeprom_param);
-	debugfs_create_devm_seqfile(dev->mt76.dev, "txpower", dir,
-				    mt76x0_read_txpower);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 101332a35f40..e0b349c921b1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -94,8 +94,6 @@ struct mt76x0_dev {
 	struct mutex reg_atomic_mutex;
 	struct mutex hw_atomic_mutex;
 
-	u32 debugfs_reg;
-
 	atomic_t avg_ampdu_len;
 
 	/* Connection monitoring things */
-- 
2.18.0
