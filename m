Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34794 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753461AbeBAA1r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 19:27:47 -0500
Received: by mail-wr0-f194.google.com with SMTP id 36so17007731wrh.1
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jan 2018 16:27:47 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: remove warnings in mt76x2_mac_write_txwi()
Date: Thu,  1 Feb 2018 01:27:36 +0100
Message-Id: <39ba1292cb67ee2d4bf0f2813af63786f4241df1.1517443974.git.lorenzo.bianconi@redhat.com> (sfid-20180201_012751_765068_9F887CBF)
In-Reply-To: <cover.1517443974.git.lorenzo.bianconi@redhat.com>
References: <cover.1517443974.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix following sparse warnings in mt76x2_mac_write_txwi:
- drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:201:26: warning:
  incorrect type in assignment (different base types)
- drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:201:26: expected
  restricted __le32 [usertype] iv
- drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:201:26: got unsigned
  int [unsigned] [usertype] <noident>
- drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:202:27: warning:
  incorrect type in assignment (different base types)
- drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:202:27: expected
  restricted __le32 [usertype] eiv
- drivers/net/wireless/mediatek/mt76/mt76x2_mac.c:202:27: got unsigned
  int [unsigned] [usertype] <noident>

Fixes: 23405236460b ("mt76: fix transmission of encrypted management
frames")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 6c30b5eaa9ca..279cd8717806 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -198,8 +198,8 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 		ccmp_pn[5] = pn >> 24;
 		ccmp_pn[6] = pn >> 32;
 		ccmp_pn[7] = pn >> 40;
-		txwi->iv = *((u32 *) &ccmp_pn[0]);
-		txwi->eiv = *((u32 *) &ccmp_pn[1]);
+		txwi->iv = *((__le32 *)&ccmp_pn[0]);
+		txwi->eiv = *((__le32 *)&ccmp_pn[1]);
 	}
 
 	spin_lock_bh(&dev->mt76.lock);
-- 
2.14.3
