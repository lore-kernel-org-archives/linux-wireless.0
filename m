Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:42543 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750946AbeAWJDi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 04:03:38 -0500
Received: by mail-wm0-f68.google.com with SMTP id r71so307283wmd.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jan 2018 01:03:37 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2] mt76x2: init: disable all pending tasklets during device removal
Date: Tue, 23 Jan 2018 10:03:24 +0100
Message-Id: <612e527f5358f4d7d465f21fc72b5b649dce5f40.1516697336.git.lorenzo.bianconi@redhat.com> (sfid-20180123_100343_112509_5F118061)
In-Reply-To: <cover.1516697336.git.lorenzo.bianconi@redhat.com>
References: <cover.1516697336.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a possible race in mt76x2_stop_hardware() since pre_tbtt and
dfs tasklets could run during driver cleanup. Fix it disabling all
pending tasklets during device removal

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
Changes since v1:
- add proper commit message
- squash patch 1/2 and 2/2
---
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 9f20a308ff76..7b4851481dd6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -614,6 +614,8 @@ void mt76x2_stop_hardware(struct mt76x2_dev *dev)
 
 void mt76x2_cleanup(struct mt76x2_dev *dev)
 {
+	tasklet_disable(&dev->dfs_pd.dfs_tasklet);
+	tasklet_disable(&dev->pre_tbtt_tasklet);
 	mt76x2_stop_hardware(dev);
 	mt76x2_dma_cleanup(dev);
 	mt76x2_mcu_cleanup(dev);
-- 
2.14.3
