Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:55087 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbaINVJX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2014 17:09:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/5] b43: add missing rate
Date: Sun, 14 Sep 2014 23:09:10 +0200
Message-Id: <1410728952-25779-3-git-send-email-hauke@hauke-m.de> (sfid-20140914_230930_100671_B11EC7A8)
In-Reply-To: <1410728952-25779-1-git-send-email-hauke@hauke-m.de>
References: <1410728952-25779-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The OFDM reate 9MB was not set here

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 2d7716e..96edbd2 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3121,6 +3121,7 @@ static void b43_rate_memory_init(struct b43_wldev *dev)
 	case B43_PHYTYPE_HT:
 	case B43_PHYTYPE_LCN:
 		b43_rate_memory_write(dev, B43_OFDM_RATE_6MB, 1);
+		b43_rate_memory_write(dev, B43_OFDM_RATE_9MB, 1);
 		b43_rate_memory_write(dev, B43_OFDM_RATE_12MB, 1);
 		b43_rate_memory_write(dev, B43_OFDM_RATE_18MB, 1);
 		b43_rate_memory_write(dev, B43_OFDM_RATE_24MB, 1);
-- 
1.9.1

