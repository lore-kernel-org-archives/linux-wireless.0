Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38417 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387520AbeITOzO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id j8-v6so4850255wrw.5
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:46 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 20/20] mt76x0: use shared debugfs implementation
Date: Thu, 20 Sep 2018 11:12:07 +0200
Message-Id: <91751ba6b25f23a8da693d237282988057f1a60a.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_111300_186593_5FF424C9)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use mt76 shared debugfs implementation and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   | 66 +------------------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  2 -
 2 files changed, 1 insertion(+), 67 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
index a34feead2cc4..5fc68bd81d3f 100644
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
@@ -95,45 +75,6 @@ static const struct file_operations fops_ampdu_stat = {
 	.release = single_release,
 };
 
-static int
-mt76x0_eeprom_param_read(struct seq_file *file, void *data)
-{
-	struct mt76x0_dev *dev = file->private;
-	u16 val;
-	int i;
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
-	seq_puts(file, "Per channel power:\n");
-	for (i = 0; i < MT76X0_NUM_CHANS; i++)
-		seq_printf(file, "\t%d chan:%d pwr:%d\n", i, i,
-			   dev->caldata.tx_pwr_per_chan[i]);
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
 static int mt76x0_read_txpower(struct seq_file *file, void *data)
 {
 	struct mt76x0_dev *dev = dev_get_drvdata(file->private);
@@ -155,16 +96,11 @@ void mt76x0_init_debugfs(struct mt76x0_dev *dev)
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
 	debugfs_create_devm_seqfile(dev->mt76.dev, "txpower", dir,
 				    mt76x0_read_txpower);
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
2.17.1
