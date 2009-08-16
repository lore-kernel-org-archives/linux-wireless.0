Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:64541 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZHPQkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 12:40:10 -0400
Received: by fxm11 with SMTP id 11so1916389fxm.39
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2009 09:40:11 -0700 (PDT)
Message-ID: <4A883669.6010504@gmail.com>
Date: Sun, 16 Aug 2009 18:40:09 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: LP-PHY: Fix a bug in the B2062 channel tune path
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I missed the "+16" part of the instruction in the specs.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/phy_lp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 1de4a74..5a7b873 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1952,7 +1952,7 @@ static int lpphy_b2062_tune(struct b43_wldev *dev,
 	b43_radio_write(dev, B2062_S_RFPLL_CTL29, tmp6 + ((2 * tmp7) / tmp4));
 	tmp8 = b43_phy_read(dev, B2062_S_RFPLL_CTL19);
 	tmp9 = ((2 * tmp3 * (tmp8 + 1)) + (3 * tmp1)) / (6 * tmp1);
-	b43_radio_write(dev, B2062_S_RFPLL_CTL23, tmp9 >> 8);
+	b43_radio_write(dev, B2062_S_RFPLL_CTL23, (tmp9 >> 8) + 16);
 	b43_radio_write(dev, B2062_S_RFPLL_CTL24, tmp9 & 0xFF);
 	
 	lpphy_b2062_vco_calib(dev);
-- 
1.6.2.4



