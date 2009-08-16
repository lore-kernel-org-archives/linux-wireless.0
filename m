Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:42899 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbZHPNcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 09:32:41 -0400
Received: by fxm11 with SMTP id 11so1869868fxm.39
        for <linux-wireless@vger.kernel.org>; Sun, 16 Aug 2009 06:32:42 -0700 (PDT)
Message-ID: <4A880A78.9050205@gmail.com>
Date: Sun, 16 Aug 2009 15:32:40 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: LP-PHY: Fix a spec error in the B2062 channel switch
 routine
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The channel switch routine had a whole instruction missing. Add it.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/phy_lp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index a51da6e..3889519 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1939,6 +1939,10 @@ static int lpphy_b2062_tune(struct b43_wldev *dev,
 	tmp5 = tmp7 * 0x100;
 	tmp6 = tmp5 / tmp4;
 	tmp7 = tmp5 % tmp4;
+	b43_radio_write(dev, B2062_S_RFPLL_CTL27, tmp6);
+	tmp5 = tmp7 * 0x100;
+	tmp6 = tmp5 / tmp4;
+	tmp7 = tmp5 % tmp4;
 	b43_radio_write(dev, B2062_S_RFPLL_CTL28, tmp6);
 	tmp5 = tmp7 * 0x100;
 	tmp6 = tmp5 / tmp4;
-- 
1.6.2.4



