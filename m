Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36340 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbeIVRjJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 13:39:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id y13-v6so987470wmi.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2018 04:45:51 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/9] mt76: move rate_txpower handler in mt76 debugfs
Date: Sat, 22 Sep 2018 13:45:31 +0200
Message-Id: <20180922114537.24004-4-lorenzo.bianconi@redhat.com> (sfid-20180922_134903_486887_2BFB184A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move rate_txpower handler in mt76 debugfs in order to be reused
in mt76x0 driver and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/debugfs.c  | 19 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2_debugfs.c   | 10 ----------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/debugfs.c b/drivers/net/wireless/mediatek/mt76/debugfs.c
index 03ce635334fa..a5adf22c3ffa 100644
--- a/drivers/net/wireless/mediatek/mt76/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/debugfs.c
@@ -68,6 +68,23 @@ void mt76_seq_puts_array(struct seq_file *file, const char *str,
 }
 EXPORT_SYMBOL_GPL(mt76_seq_puts_array);
 
+static int mt76_read_rate_txpower(struct seq_file *s, void *data)
+{
+	struct mt76_dev *dev = dev_get_drvdata(s->private);
+
+	mt76_seq_puts_array(s, "CCK", dev->rate_power.cck,
+			    ARRAY_SIZE(dev->rate_power.cck));
+	mt76_seq_puts_array(s, "OFDM", dev->rate_power.ofdm,
+			    ARRAY_SIZE(dev->rate_power.ofdm));
+	mt76_seq_puts_array(s, "STBC", dev->rate_power.stbc,
+			    ARRAY_SIZE(dev->rate_power.stbc));
+	mt76_seq_puts_array(s, "HT", dev->rate_power.ht,
+			    ARRAY_SIZE(dev->rate_power.ht));
+	mt76_seq_puts_array(s, "VHT", dev->rate_power.vht,
+			    ARRAY_SIZE(dev->rate_power.vht));
+	return 0;
+}
+
 struct dentry *mt76_register_debugfs(struct mt76_dev *dev)
 {
 	struct dentry *dir;
@@ -84,6 +101,8 @@ struct dentry *mt76_register_debugfs(struct mt76_dev *dev)
 	if (dev->otp.data)
 		debugfs_create_blob("otp", 0400, dir, &dev->otp);
 	debugfs_create_devm_seqfile(dev->dev, "queues", dir, mt76_queues_read);
+	debugfs_create_devm_seqfile(dev->dev, "rate_txpower", dir,
+				    mt76_read_rate_txpower);
 
 	return dir;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
index 527c94d07d67..ea373bae1522 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
@@ -55,16 +55,6 @@ static int read_txpower(struct seq_file *file, void *data)
 
 	mt76_seq_puts_array(file, "Delta", dev->target_power_delta,
 			    ARRAY_SIZE(dev->target_power_delta));
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
 	return 0;
 }
 
-- 
2.18.0
