Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42975 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbeHHBHS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Aug 2018 21:07:18 -0400
Received: by mail-pg1-f194.google.com with SMTP id y4-v6so117104pgp.9
        for <linux-wireless@vger.kernel.org>; Tue, 07 Aug 2018 15:50:42 -0700 (PDT)
Date: Tue, 7 Aug 2018 15:50:40 -0700
From: Kees Cook <keescook@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH wireless-drivers] mt76x0: Remove VLA usage
Message-ID: <20180807225040.GA2164@beast> (sfid-20180808_005046_014859_55335E60)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even with "const" variables, the compiler will generate warnings about
VLA usage. In the quest to remove all VLAs from the kernel[1], this uses
a #define instead of a const to do the array sizing.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Fixes: e87b5039511a ("mt76x0: eeprom files")
Signed-off-by: Kees Cook <keescook@chromium.org>
---
Please include this for the v4.19 merge window. The VLA was introduced
with the new source file (which I also note is missing a SPDX line), so
I'd like to avoid the kernel ever getting released with a VLA here.
---
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 1ecd018f12b8..af2fd6a1bb44 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -81,15 +81,15 @@ mt76x0_efuse_read(struct mt76x0_dev *dev, u16 addr, u8 *data,
 	return 0;
 }
 
+#define MT_MAP_READS	DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16)
 static int
 mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
 {
-	const int map_reads = DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16);
-	u8 data[map_reads * 16];
+	u8 data[MT_MAP_READS * 16];
 	int ret, i;
 	u32 start = 0, end = 0, cnt_free;
 
-	for (i = 0; i < map_reads; i++) {
+	for (i = 0; i < MT_MAP_READS; i++) {
 		ret = mt76x0_efuse_read(dev, MT_EE_USAGE_MAP_START + i * 16,
 					 data + i * 16, MT_EE_PHYSICAL_READ);
 		if (ret)
-- 
2.17.1


-- 
Kees Cook
Pixel Security
