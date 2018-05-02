Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:37184 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbeEBJqt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 05:46:49 -0400
Received: by mail-wm0-f68.google.com with SMTP id l1so23225764wmb.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 May 2018 02:46:49 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: fix avg_rssi estimation
Date: Wed,  2 May 2018 11:46:36 +0200
Message-Id: <62914ffe8256eb60af815fca6591473d67f5a639.1525254116.git.lorenzo.bianconi@redhat.com> (sfid-20180502_114742_841583_1F889E75)
In-Reply-To: <cover.1525254116.git.lorenzo.bianconi@redhat.com>
References: <cover.1525254116.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add leftover filter coefficients in IIR rssi estimation

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index 038d1fe6c726..c1c38ca3330a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -508,8 +508,10 @@ mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
 	u8 gain_delta;
 	int low_gain;
 
-	dev->cal.avg_rssi[0] = (dev->cal.avg_rssi[0] * 15) / 16 + (rssi0 << 8);
-	dev->cal.avg_rssi[1] = (dev->cal.avg_rssi[1] * 15) / 16 + (rssi1 << 8);
+	dev->cal.avg_rssi[0] = (dev->cal.avg_rssi[0] * 15) / 16 +
+			       (rssi0 << 8) / 16;
+	dev->cal.avg_rssi[1] = (dev->cal.avg_rssi[1] * 15) / 16 +
+			       (rssi1 << 8) / 16;
 	dev->cal.avg_rssi_all = (dev->cal.avg_rssi[0] +
 				 dev->cal.avg_rssi[1]) / 512;
 
-- 
2.14.3
