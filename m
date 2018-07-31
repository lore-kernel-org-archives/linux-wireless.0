Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44393 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731181AbeGaJst (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:48:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id r16-v6so15597505wrt.11
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 01:09:40 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH v2 17/19] mt76: move mt76x2_debugfs in mt76-common module
Date: Tue, 31 Jul 2018 10:09:18 +0200
Message-Id: <08bbc41492a05a051b32759adeff0818153b42f8.1533023328.git.lorenzo.bianconi@redhat.com> (sfid-20180731_101000_842082_BCB295BF)
In-Reply-To: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
References: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76x2_debugfs code in mt76-common module since it is shared
between mt76x2 and mt76x2u

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile         | 5 +++--
 drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 5a9f34b14ee4..e1bc229e4aad 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -9,11 +9,12 @@ CFLAGS_trace.o := -I$(src)
 
 mt76x2-common-y := \
 	mt76x2_eeprom.o mt76x2_tx_common.o mt76x2_mac_common.o \
-	mt76x2_init_common.o mt76x2_common.o mt76x2_phy_common.o
+	mt76x2_init_common.o mt76x2_common.o mt76x2_phy_common.o \
+	mt76x2_debugfs.o
 
 mt76x2e-y := \
 	mt76x2_pci.o mt76x2_dma.o \
-	mt76x2_main.o mt76x2_init.o mt76x2_debugfs.o mt76x2_tx.o \
+	mt76x2_main.o mt76x2_init.o mt76x2_tx.o \
 	mt76x2_core.o mt76x2_mac.o mt76x2_mcu.o mt76x2_phy.o \
 	mt76x2_dfs.o mt76x2_trace.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
index 74725902e6dc..77b5ff1be05f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
@@ -153,3 +153,4 @@ void mt76x2_init_debugfs(struct mt76x2_dev *dev)
 
 	debugfs_create_devm_seqfile(dev->mt76.dev, "agc", dir, read_agc);
 }
+EXPORT_SYMBOL_GPL(mt76x2_init_debugfs);
-- 
2.17.1
