Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:37721 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbeEJOGT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 10:06:19 -0400
Received: by mail-wr0-f196.google.com with SMTP id h5-v6so2162328wrm.4
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2018 07:06:18 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: add a polling delay in mt76x2_mac_stop routine
Date: Thu, 10 May 2018 16:06:09 +0200
Message-Id: <e7c7fcf87f42a137472b8dfd1460a8d41a295bfa.1525960967.git.lorenzo.bianconi@redhat.com> (sfid-20180510_160623_628763_937BF6D4)
In-Reply-To: <cover.1525960967.git.lorenzo.bianconi@redhat.com>
References: <cover.1525960967.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a usleep_range in mt76x2_mac_stop routine in order to add
a polling delay checking values of MT_MAC_STATUS and IBI_R12 registers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index d21e4a7c1bb9..dd4c1127797e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -370,12 +370,12 @@ void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force)
 
 	/* Wait for MAC to become idle */
 	for (i = 0; i < 300; i++) {
-		if (mt76_rr(dev, MT_MAC_STATUS) &
-		    (MT_MAC_STATUS_RX | MT_MAC_STATUS_TX))
-			continue;
-
-		if (mt76_rr(dev, MT_BBP(IBI, 12)))
+		if ((mt76_rr(dev, MT_MAC_STATUS) &
+		     (MT_MAC_STATUS_RX | MT_MAC_STATUS_TX)) ||
+		    mt76_rr(dev, MT_BBP(IBI, 12))) {
+			usleep_range(10, 20);
 			continue;
+		}
 
 		stopped = true;
 		break;
-- 
2.14.3
