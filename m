Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C00FC7112A
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 09:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D60FE205C9
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 09:33:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D60FE205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbeJORSR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 13:18:17 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37552 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbeJORSR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 13:18:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id y11-v6so20438378wrd.4
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2018 02:33:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m+TViy7H4UpiDkMmdYu04JWH75sY1jHSPZupBF/WTlE=;
        b=Dm+5V69Ao3Nf36bDfV9iygrLqPOy4W4oTL39Fc4RwOUorzQdy58uuwvjjtEE1/7R3Q
         3mDNa1hr7W7g8DRtqAxYdPKgKhnppi/5FEM8bXLqqA+dY5/YDf/5in8uM3eAuOzOf7e5
         Et82zw8HOucUbOnCZdmsFOk/fnm4MNHmLa7Yv/AKpFvzABnAI+ASPCTIYBMZpKjRLuEe
         B8Q6syn9/aOGuQ5GjoK5rXVWBEgpgrLvVtWabnDL7SJQfgXOnFOwSYf1+ffj62tuxbTY
         n+L5On3/lPtg9ZclAbwRwPmxH2t/Hc9Plh0CC5on5Pzp1lie/HFwJopt/Z7IeLATBOrC
         lB2w==
X-Gm-Message-State: ABuFfojvvKNMLPfB2vy4Uwrqj4U+Q4jAipkBxn5g7j6NpjAvfqX6kOXh
        oLs4Qvm/O7azrKcZpBA/MbA+U5g6zJs=
X-Google-Smtp-Source: ACcGV63jrgxuJJx4/VIpBKWHJ2O/TwwzcdV4VtP8nCAgJIrVSPyT1gUvsKrwz3Kd7ha+pwggb5bI5A==
X-Received: by 2002:adf:8206:: with SMTP id 6-v6mr13630707wrb.160.1539596028197;
        Mon, 15 Oct 2018 02:33:48 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id w11-v6sm17102507wrn.65.2018.10.15.02.33.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Oct 2018 02:33:47 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/6] mt76: move mt76x02_debugfs in mt76x02-lib module
Date:   Mon, 15 Oct 2018 11:33:13 +0200
Message-Id: <66fd04b8a16071177791404441901809f174d7ac.1539595605.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539595605.git.lorenzo.bianconi@redhat.com>
References: <cover.1539595605.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_debugfs in mt76x02-lib module in order to
be reused by mt76x0 driver and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  2 ++
 .../{mt76x2/debugfs.c => mt76x02_debugfs.c}   | 22 +++++++++----------
 .../wireless/mediatek/mt76/mt76x2/Makefile    |  2 +-
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  1 -
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  2 +-
 7 files changed, 17 insertions(+), 16 deletions(-)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2/debugfs.c => mt76x02_debugfs.c} (86%)

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 9b8d7488c545..a737a518802f 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -14,7 +14,7 @@ CFLAGS_mt76x02_trace.o := -I$(src)
 
 mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o mt76x02_mcu.o \
 		 mt76x02_eeprom.o mt76x02_phy.o mt76x02_mmio.o \
-		 mt76x02_txrx.o mt76x02_trace.o
+		 mt76x02_txrx.o mt76x02_trace.o mt76x02_debugfs.o
 
 mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 189c697973bd..58721307d917 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -162,6 +162,8 @@ void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev);
 void mt76x02_set_irq_mask(struct mt76x02_dev *dev, u32 clear, u32 set);
 void mt76x02_mac_start(struct mt76x02_dev *dev);
 
+void mt76x02_init_debugfs(struct mt76x02_dev *dev);
+
 static inline bool is_mt76x2(struct mt76x02_dev *dev)
 {
 	return mt76_chip(&dev->mt76) == 0x7612 ||
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
similarity index 86%
rename from drivers/net/wireless/mediatek/mt76/mt76x2/debugfs.c
rename to drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
index e8f8ccc0a5ed..a9d52ba1e270 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
@@ -15,10 +15,10 @@
  */
 
 #include <linux/debugfs.h>
-#include "mt76x2.h"
+#include "mt76x02.h"
 
 static int
-mt76x2_ampdu_stat_read(struct seq_file *file, void *data)
+mt76x02_ampdu_stat_read(struct seq_file *file, void *data)
 {
 	struct mt76x02_dev *dev = file->private;
 	int i, j;
@@ -42,9 +42,9 @@ mt76x2_ampdu_stat_read(struct seq_file *file, void *data)
 }
 
 static int
-mt76x2_ampdu_stat_open(struct inode *inode, struct file *f)
+mt76x02_ampdu_stat_open(struct inode *inode, struct file *f)
 {
-	return single_open(f, mt76x2_ampdu_stat_read, inode->i_private);
+	return single_open(f, mt76x02_ampdu_stat_read, inode->i_private);
 }
 
 static int read_txpower(struct seq_file *file, void *data)
@@ -59,14 +59,14 @@ static int read_txpower(struct seq_file *file, void *data)
 }
 
 static const struct file_operations fops_ampdu_stat = {
-	.open = mt76x2_ampdu_stat_open,
+	.open = mt76x02_ampdu_stat_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
 };
 
 static int
-mt76x2_dfs_stat_read(struct seq_file *file, void *data)
+mt76x02_dfs_stat_read(struct seq_file *file, void *data)
 {
 	struct mt76x02_dev *dev = file->private;
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
@@ -92,13 +92,13 @@ mt76x2_dfs_stat_read(struct seq_file *file, void *data)
 }
 
 static int
-mt76x2_dfs_stat_open(struct inode *inode, struct file *f)
+mt76x02_dfs_stat_open(struct inode *inode, struct file *f)
 {
-	return single_open(f, mt76x2_dfs_stat_read, inode->i_private);
+	return single_open(f, mt76x02_dfs_stat_read, inode->i_private);
 }
 
 static const struct file_operations fops_dfs_stat = {
-	.open = mt76x2_dfs_stat_open,
+	.open = mt76x02_dfs_stat_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
@@ -116,7 +116,7 @@ static int read_agc(struct seq_file *file, void *data)
 	return 0;
 }
 
-void mt76x2_init_debugfs(struct mt76x02_dev *dev)
+void mt76x02_init_debugfs(struct mt76x02_dev *dev)
 {
 	struct dentry *dir;
 
@@ -134,4 +134,4 @@ void mt76x2_init_debugfs(struct mt76x02_dev *dev)
 
 	debugfs_create_devm_seqfile(dev->mt76.dev, "agc", dir, read_agc);
 }
-EXPORT_SYMBOL_GPL(mt76x2_init_debugfs);
+EXPORT_SYMBOL_GPL(mt76x02_init_debugfs);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
index b71bb1049170..696f071f47f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
@@ -3,7 +3,7 @@ obj-$(CONFIG_MT76x2E) += mt76x2e.o
 obj-$(CONFIG_MT76x2U) += mt76x2u.o
 
 mt76x2-common-y := \
-	eeprom.o mac.o init.o phy.o debugfs.o mcu.o
+	eeprom.o mac.o init.o phy.o mcu.o
 
 mt76x2e-y := \
 	pci.o pci_main.o pci_init.o pci_tx.o \
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index eca142ac656d..7408db788409 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -52,7 +52,6 @@ extern const struct ieee80211_ops mt76x2_ops;
 
 struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev);
 int mt76x2_register_device(struct mt76x02_dev *dev);
-void mt76x2_init_debugfs(struct mt76x02_dev *dev);
 void mt76x2_init_device(struct mt76x02_dev *dev);
 
 void mt76x2_phy_power_on(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 0dea7d7b17a3..5b167aaaf7f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -515,7 +515,7 @@ int mt76x2_register_device(struct mt76x02_dev *dev)
 	if (ret)
 		goto fail;
 
-	mt76x2_init_debugfs(dev);
+	mt76x02_init_debugfs(dev);
 	mt76x2_init_txpower(dev, &dev->mt76.sband_2g.sband);
 	mt76x2_init_txpower(dev, &dev->mt76.sband_5g.sband);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 13cce2937573..dfc80ecfde92 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -282,7 +282,7 @@ int mt76x2u_register_device(struct mt76x02_dev *dev)
 
 	set_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
 
-	mt76x2_init_debugfs(dev);
+	mt76x02_init_debugfs(dev);
 	mt76x2_init_txpower(dev, &dev->mt76.sband_2g.sband);
 	mt76x2_init_txpower(dev, &dev->mt76.sband_5g.sband);
 
-- 
2.19.0

