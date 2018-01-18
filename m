Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35692 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932379AbeARXIX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 18:08:23 -0500
Received: by mail-wm0-f65.google.com with SMTP id r78so86700wme.0
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jan 2018 15:08:22 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mt76x2: init: disable tbtt tasklet during device cleanup
Date: Fri, 19 Jan 2018 00:08:13 +0100
Message-Id: <f46c90a50429201056419aae168a836fcc406f47.1516315624.git.lorenzo.bianconi@redhat.com> (sfid-20180119_000826_879267_C0CAECD7)
In-Reply-To: <cover.1516315624.git.lorenzo.bianconi@redhat.com>
References: <cover.1516315624.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 9f20a308ff76..66d4bfc70977 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -614,6 +614,7 @@ void mt76x2_stop_hardware(struct mt76x2_dev *dev)
 
 void mt76x2_cleanup(struct mt76x2_dev *dev)
 {
+	tasklet_disable(&dev->pre_tbtt_tasklet);
 	mt76x2_stop_hardware(dev);
 	mt76x2_dma_cleanup(dev);
 	mt76x2_mcu_cleanup(dev);
-- 
2.13.6
