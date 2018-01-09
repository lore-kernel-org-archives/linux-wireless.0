Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:46273 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756364AbeAIBg1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 20:36:27 -0500
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: Larry.Finger@lwfinger.net, kvalo@codeaurora.org,
        kstewart@linuxfoundation.org, johannes.berg@intel.com,
        tiwai@suse.de, gregkh@linuxfoundation.org,
        colin.king@canonical.com, andrew.zaborowski@intel.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2] b43: Replace mdelay with usleep_range in b43_radio_2057_init_post
Date: Tue,  9 Jan 2018 09:40:06 +0800
Message-Id: <1515462006-6144-1-git-send-email-baijiaju1990@gmail.com> (sfid-20180109_024113_907336_33DE9F37)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

b43_radio_2057_init_post is not called in an interrupt handler
nor holding a spinlock.
The function mdelay in it can be replaced with usleep_range, 
to reduce busy wait.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
v2:
* Replace mdelay with usleep_range, instead of msleep in v1.
  Thank Larry for good advice.
---
 drivers/net/wireless/broadcom/b43/phy_n.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/phy_n.c b/drivers/net/wireless/broadcom/b43/phy_n.c
index a5557d7..f2a2f41 100644
--- a/drivers/net/wireless/broadcom/b43/phy_n.c
+++ b/drivers/net/wireless/broadcom/b43/phy_n.c
@@ -1031,7 +1031,7 @@ static void b43_radio_2057_init_post(struct b43_wldev *dev)
 
 	b43_radio_set(dev, R2057_RFPLL_MISC_CAL_RESETN, 0x78);
 	b43_radio_set(dev, R2057_XTAL_CONFIG2, 0x80);
-	mdelay(2);
+	usleep_range(2000, 3000);
 	b43_radio_mask(dev, R2057_RFPLL_MISC_CAL_RESETN, ~0x78);
 	b43_radio_mask(dev, R2057_XTAL_CONFIG2, ~0x80);
 
-- 
1.7.9.5
