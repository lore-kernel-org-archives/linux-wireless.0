Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:37592 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751482AbeDCPB4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 11:01:56 -0400
Received: by mail-wr0-f193.google.com with SMTP id l49so19051691wrl.4
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2018 08:01:55 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: make mt76x2_mac_reset routine static
Date: Tue,  3 Apr 2018 17:01:43 +0200
Message-Id: <3ac4534e4e14515843c8cb5fbd9accecfcef40d0.1522767292.git.lorenzo.bianconi@redhat.com> (sfid-20180403_170159_987872_33EAA42D)
In-Reply-To: <cover.1522767292.git.lorenzo.bianconi@redhat.com>
References: <cover.1522767292.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add static qualifier to mt76x2_mac_reset routine and remove the
prototype from mt76x2_mac.h since it is used just in mt76x2_init.c

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h  | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 934c331d995e..359b105235b3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -228,7 +228,7 @@ mt76x2_init_beacon_offsets(struct mt76x2_dev *dev)
 		mt76_wr(dev, MT_BCN_OFFSET(i), regs[i]);
 }
 
-int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
+static int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
 {
 	static const u8 null_addr[ETH_ALEN] = {};
 	const u8 *macaddr = dev->mt76.macaddr;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
index 8a8a25e32d5f..c048cd06df6b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
@@ -157,7 +157,6 @@ mt76x2_skb_tx_info(struct sk_buff *skb)
 	return (void *) info->status.status_driver_data;
 }
 
-int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard);
 int mt76x2_mac_start(struct mt76x2_dev *dev);
 void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force);
 void mt76x2_mac_resume(struct mt76x2_dev *dev);
-- 
2.14.3
