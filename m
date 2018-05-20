Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:40811 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbeETIQB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 May 2018 04:16:01 -0400
Received: by mail-wr0-f195.google.com with SMTP id v60-v6so13016433wrc.7
        for <linux-wireless@vger.kernel.org>; Sun, 20 May 2018 01:16:00 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC v2 16/18] mt76: move mt76x2_debugfs in mt76-common module
Date: Sun, 20 May 2018 10:15:20 +0200
Message-Id: <20180520081522.10163-17-lorenzo.bianconi@redhat.com> (sfid-20180520_101638_442881_10D223C7)
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
index 955ea3e692dd..9613fe5f0d12 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
@@ -131,3 +131,4 @@ void mt76x2_init_debugfs(struct mt76x2_dev *dev)
 	debugfs_create_devm_seqfile(dev->mt76.dev, "txpower", dir,
 				    read_txpower);
 }
+EXPORT_SYMBOL_GPL(mt76x2_init_debugfs);
-- 
2.16.3
