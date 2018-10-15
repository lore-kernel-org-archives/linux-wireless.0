Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A15D3C7112B
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 09:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C694205C9
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 09:33:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C694205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbeJORSW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 13:18:22 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34131 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbeJORSV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 13:18:21 -0400
Received: by mail-wr1-f65.google.com with SMTP id l6-v6so20035453wrt.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2018 02:33:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vc2GCx2snhNge816xnprsHaHaOGpGGCIiqIIMpJt63c=;
        b=PumiE6TUh2CVCjghdI4iNkTofP0PEUCm+fRwQOqeNYNba7QvnXds6qZZWeZRNud8eH
         tySgX98ZLAygakA8pBRdUP4c5tjiG5hDxOH1iiwXfbo5i5BSQOKlBUMGIi1emvsbkVzL
         Q0jwjHnm40zx1j71b/Exc5gDgsjweP86g5A9naAlrgEIbrIZ0DCMikvpdeZseMQmml1P
         OdnQ7yMgQO1kXmiBtyfibZNVYNuyLCu2hpjXMbyVoyhCChuzSbo3mtfulJknFCNw4ck0
         63iJ9caRyIEKEw2Xbi1qHMaz6F4oFOtSEa0X6i4eMbRE+KuEWsPWvSoC/gB9hNHiPXGp
         XDng==
X-Gm-Message-State: ABuFfoiSN1W8Y7uk/FdgYLMokm8P8rN3Tfh3LB3bfJj3uCxKvWlXM7Vo
        U4FaX+4tyINWUdcsSIPWK25Og9rSgUg=
X-Google-Smtp-Source: ACcGV63PZEaEY8a+CpULLRjoadfxkmfjEpTERftImUIVbHdXmTTo855drQqoW6clcix4+W4aPfvVkg==
X-Received: by 2002:adf:ff90:: with SMTP id j16-v6mr13320357wrr.296.1539596031969;
        Mon, 15 Oct 2018 02:33:51 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id w11-v6sm17102507wrn.65.2018.10.15.02.33.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Oct 2018 02:33:51 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] mt76x0: use shared debugfs implementation
Date:   Mon, 15 Oct 2018 11:33:14 +0200
Message-Id: <b8e293c413e163c7ce3a3dcf22a42b5ec00c1249.1539595605.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539595605.git.lorenzo.bianconi@redhat.com>
References: <cover.1539595605.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02 debugfs implementation and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/Makefile    |  4 +-
 .../wireless/mediatek/mt76/mt76x0/debugfs.c   | 87 -------------------
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  2 -
 4 files changed, 3 insertions(+), 92 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
index 20672978dceb..e49cbf6be945 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
@@ -3,8 +3,8 @@ obj-$(CONFIG_MT76x0E) += mt76x0e.o
 obj-$(CONFIG_MT76x0_COMMON) += mt76x0-common.o
 
 mt76x0-common-y := \
-	init.o main.o trace.o eeprom.o phy.o \
-	mac.o debugfs.o
+	init.o main.o trace.o eeprom.o phy.o mac.o
+
 mt76x0u-y := usb.o usb_mcu.o
 mt76x0e-y := pci.o pci_mcu.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
deleted file mode 100644
index 3224e5b1a1e5..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
+++ /dev/null
@@ -1,87 +0,0 @@
-/*
- * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
- * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
- * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2
- * as published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/debugfs.h>
-
-#include "mt76x0.h"
-#include "eeprom.h"
-
-static int
-mt76x0_ampdu_stat_read(struct seq_file *file, void *data)
-{
-	struct mt76x02_dev *dev = file->private;
-	int i, j;
-
-#define stat_printf(grp, off, name)					\
-	seq_printf(file, #name ":\t%llu\n", dev->stats.grp[off])
-
-	stat_printf(rx_stat, 0, rx_crc_err);
-	stat_printf(rx_stat, 1, rx_phy_err);
-	stat_printf(rx_stat, 2, rx_false_cca);
-	stat_printf(rx_stat, 3, rx_plcp_err);
-	stat_printf(rx_stat, 4, rx_fifo_overflow);
-	stat_printf(rx_stat, 5, rx_duplicate);
-
-	stat_printf(tx_stat, 0, tx_fail_cnt);
-	stat_printf(tx_stat, 1, tx_bcn_cnt);
-	stat_printf(tx_stat, 2, tx_success);
-	stat_printf(tx_stat, 3, tx_retransmit);
-	stat_printf(tx_stat, 4, tx_zero_len);
-	stat_printf(tx_stat, 5, tx_underflow);
-
-	stat_printf(aggr_stat, 0, non_aggr_tx);
-	stat_printf(aggr_stat, 1, aggr_tx);
-
-	stat_printf(zero_len_del, 0, tx_zero_len_del);
-	stat_printf(zero_len_del, 1, rx_zero_len_del);
-#undef stat_printf
-
-	seq_puts(file, "Aggregations stats:\n");
-	for (i = 0; i < 4; i++) {
-		for (j = 0; j < 8; j++)
-			seq_printf(file, "%08llx ",
-				   dev->stats.aggr_n[i * 8 + j]);
-		seq_putc(file, '\n');
-	}
-
-	seq_printf(file, "recent average AMPDU len: %d\n",
-		   atomic_read(&dev->avg_ampdu_len));
-
-	return 0;
-}
-
-static int
-mt76x0_ampdu_stat_open(struct inode *inode, struct file *f)
-{
-	return single_open(f, mt76x0_ampdu_stat_read, inode->i_private);
-}
-
-static const struct file_operations fops_ampdu_stat = {
-	.open = mt76x0_ampdu_stat_open,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-void mt76x0_init_debugfs(struct mt76x02_dev *dev)
-{
-	struct dentry *dir;
-
-	dir = mt76_register_debugfs(&dev->mt76);
-	if (!dir)
-		return;
-
-	debugfs_create_file("ampdu_stat", S_IRUSR, dir, dev, &fops_ampdu_stat);
-}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index d7d4dfbbd04d..f90ef4d803d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -389,7 +389,7 @@ int mt76x0_register_device(struct mt76x02_dev *dev)
 	if (mdev->cap.has_5ghz)
 		mt76x0_vht_cap_mask(&dev->mt76.sband_5g.sband);
 
-	mt76x0_init_debugfs(dev);
+	mt76x02_init_debugfs(dev);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 17fc7206c55d..b9743b575099 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -37,8 +37,6 @@ static inline bool is_mt7610e(struct mt76x02_dev *dev)
 	return false;
 }
 
-void mt76x0_init_debugfs(struct mt76x02_dev *dev);
-
 /* Init */
 struct mt76x02_dev *
 mt76x0_alloc_device(struct device *pdev,
-- 
2.19.0

