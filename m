Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:41376 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752241AbeB1O1Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 09:27:24 -0500
Received: by mail-wr0-f194.google.com with SMTP id f14so2612494wre.8
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2018 06:27:24 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: kubakici@wp.pl
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt7601u: remove a warning in mt7601u_efuse_physical_size_check()
Date: Wed, 28 Feb 2018 15:26:57 +0100
Message-Id: <2850551da4495924bde846dd237b736e41913d0f.1519827461.git.lorenzo.bianconi@redhat.com> (sfid-20180228_152728_270562_022E3D12)
In-Reply-To: <cover.1519827461.git.lorenzo.bianconi@redhat.com>
References: <cover.1519827461.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the following sparse warning in mt7601u_efuse_physical_size_check:
- drivers/net/wireless/mediatek/mt7601u/eeprom.c:77:27: warning:
  Variable length array is used

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.c b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
index da6faea092d6..a462064b5c91 100644
--- a/drivers/net/wireless/mediatek/mt7601u/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
@@ -74,7 +74,7 @@ static int
 mt7601u_efuse_physical_size_check(struct mt7601u_dev *dev)
 {
 	const int map_reads = DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16);
-	u8 data[map_reads * 16];
+	u8 data[round_up(MT_EFUSE_USAGE_MAP_SIZE, 16)];
 	int ret, i;
 	u32 start = 0, end = 0, cnt_free;
 
-- 
2.14.3
