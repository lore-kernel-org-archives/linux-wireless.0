Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37278 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731665AbeITOyy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:54:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id u12-v6so8580730wrr.4
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:25 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 01/20] mt76: move seq_put_array in mt76-core module
Date: Thu, 20 Sep 2018 11:11:48 +0200
Message-Id: <c908dfcaf7a0f5333e6ebd6fb5f7a9a58961c7a0.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_111249_108761_15783A52)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move seq_put_array utility routine in mt76-core module
in order to be reused in mt76x0 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/debugfs.c  | 12 +++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 ++
 .../wireless/mediatek/mt76/mt76x2_debugfs.c   | 31 ++++++-------------
 3 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/debugfs.c b/drivers/net/wireless/mediatek/mt76/debugfs.c
index a38d05dea599..03ce635334fa 100644
--- a/drivers/net/wireless/mediatek/mt76/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/debugfs.c
@@ -56,6 +56,18 @@ mt76_queues_read(struct seq_file *s, void *data)
 	return 0;
 }
 
+void mt76_seq_puts_array(struct seq_file *file, const char *str,
+			 s8 *val, int len)
+{
+	int i;
+
+	seq_printf(file, "%10s:", str);
+	for (i = 0; i < len; i++)
+		seq_printf(file, " %2d", val[i]);
+	seq_puts(file, "\n");
+}
+EXPORT_SYMBOL_GPL(mt76_seq_puts_array);
+
 struct dentry *mt76_register_debugfs(struct mt76_dev *dev)
 {
 	struct dentry *dir;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index dbda49243a10..b4980959efa7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -539,6 +539,8 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 void mt76_unregister_device(struct mt76_dev *dev);
 
 struct dentry *mt76_register_debugfs(struct mt76_dev *dev);
+void mt76_seq_puts_array(struct seq_file *file, const char *str,
+			 s8 *val, int len);
 
 int mt76_eeprom_init(struct mt76_dev *dev, int len);
 void mt76_eeprom_override(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
index 77b5ff1be05f..2cd0d8200a57 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
@@ -47,33 +47,22 @@ mt76x2_ampdu_stat_open(struct inode *inode, struct file *f)
 	return single_open(f, mt76x2_ampdu_stat_read, inode->i_private);
 }
 
-static void
-seq_puts_array(struct seq_file *file, const char *str, s8 *val, int len)
-{
-	int i;
-
-	seq_printf(file, "%10s:", str);
-	for (i = 0; i < len; i++)
-		seq_printf(file, " %2d", val[i]);
-	seq_puts(file, "\n");
-}
-
 static int read_txpower(struct seq_file *file, void *data)
 {
 	struct mt76x2_dev *dev = dev_get_drvdata(file->private);
 
 	seq_printf(file, "Target power: %d\n", dev->target_power);
 
-	seq_puts_array(file, "Delta", dev->target_power_delta,
-		       ARRAY_SIZE(dev->target_power_delta));
-	seq_puts_array(file, "CCK", dev->rate_power.cck,
-		       ARRAY_SIZE(dev->rate_power.cck));
-	seq_puts_array(file, "OFDM", dev->rate_power.ofdm,
-		       ARRAY_SIZE(dev->rate_power.ofdm));
-	seq_puts_array(file, "HT", dev->rate_power.ht,
-		       ARRAY_SIZE(dev->rate_power.ht));
-	seq_puts_array(file, "VHT", dev->rate_power.vht,
-		       ARRAY_SIZE(dev->rate_power.vht));
+	mt76_seq_puts_array(file, "Delta", dev->target_power_delta,
+			    ARRAY_SIZE(dev->target_power_delta));
+	mt76_seq_puts_array(file, "CCK", dev->rate_power.cck,
+			    ARRAY_SIZE(dev->rate_power.cck));
+	mt76_seq_puts_array(file, "OFDM", dev->rate_power.ofdm,
+			    ARRAY_SIZE(dev->rate_power.ofdm));
+	mt76_seq_puts_array(file, "HT", dev->rate_power.ht,
+			    ARRAY_SIZE(dev->rate_power.ht));
+	mt76_seq_puts_array(file, "VHT", dev->rate_power.vht,
+			    ARRAY_SIZE(dev->rate_power.vht));
 	return 0;
 }
 
-- 
2.17.1
