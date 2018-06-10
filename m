Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:54155 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932365AbeFJKvy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Jun 2018 06:51:54 -0400
Received: by mail-wm0-f67.google.com with SMTP id x6-v6so9901627wmc.3
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2018 03:51:54 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC v3 17/19] mt76: move mt76x2_debugfs in mt76-common module
Date: Sun, 10 Jun 2018 12:51:24 +0200
Message-Id: <20180610105126.28425-18-lorenzo.bianconi@redhat.com> (sfid-20180610_125211_916580_F57FBECC)
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
2.17.1
