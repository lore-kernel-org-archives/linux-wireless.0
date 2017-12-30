Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:46682 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdL3LFU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Dec 2017 06:05:20 -0500
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: kvalo@codeaurora.org, colin.king@canonical.com,
        johannes.berg@intel.com, tiwai@suse.de,
        kstewart@linuxfoundation.org, gregkh@linuxfoundation.org,
        andrew.zaborowski@intel.com
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] b43: Replace mdelay with msleep in b43_radio_2057_init_post
Date: Sat, 30 Dec 2017 19:08:27 +0800
Message-Id: <1514632107-14698-1-git-send-email-baijiaju1990@gmail.com> (sfid-20171230_120540_243852_70673DD6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

b43_radio_2057_init_post is not called in an interrupt handler 
nor holding a spinlock.
The function mdelay in it can be replaced with msleep, to reduce busy wait.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/broadcom/b43/phy_n.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index a5557d7..5bc838e 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -1031,7 +1031,7 @@ static void b43_radio_2057_init_post(struct b43_wldev *dev)
 
 	b43_radio_set(dev, R2057_RFPLL_MISC_CAL_RESETN, 0x78);
 	b43_radio_set(dev, R2057_XTAL_CONFIG2, 0x80);
-	mdelay(2);
+	msleep(2);
 	b43_radio_mask(dev, R2057_RFPLL_MISC_CAL_RESETN, ~0x78);
 	b43_radio_mask(dev, R2057_XTAL_CONFIG2, ~0x80);
 
-- 
1.7.9.5
