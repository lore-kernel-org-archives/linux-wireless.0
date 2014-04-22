Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:42104 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaDVLys (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 07:54:48 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so4608121eek.9
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2014 04:54:47 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] b43: bcma: respect GMODE (band choice) during core reset
Date: Tue, 22 Apr 2014 13:54:35 +0200
Message-Id: <1398167677-9207-1-git-send-email-zajec5@gmail.com> (sfid-20140422_135548_319774_D631AF04)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 07024c6..f0de7dd 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1195,8 +1195,13 @@ static void b43_bcma_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 		  B43_BCMA_CLKCTLST_PHY_PLL_REQ;
 	u32 status = B43_BCMA_CLKCTLST_80211_PLL_ST |
 		     B43_BCMA_CLKCTLST_PHY_PLL_ST;
+	u32 flags;
+
+	flags = B43_BCMA_IOCTL_PHY_CLKEN;
+	if (gmode)
+		flags |= B43_BCMA_IOCTL_GMODE;
+	b43_device_enable(dev, flags);
 
-	b43_device_enable(dev, B43_BCMA_IOCTL_PHY_CLKEN);
 	bcma_core_set_clockmode(dev->dev->bdev, BCMA_CLKMODE_FAST);
 	b43_bcma_phy_reset(dev);
 	bcma_core_pll_ctl(dev->dev->bdev, req, status, true);
-- 
1.8.4.5

