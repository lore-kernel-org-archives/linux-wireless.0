Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:50442 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbZHNTT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 15:19:58 -0400
Received: by bwz22 with SMTP id 22so1316822bwz.18
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 12:19:58 -0700 (PDT)
Message-ID: <4A85B8DE.3000704@gmail.com>
Date: Fri, 14 Aug 2009 21:19:58 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: LP-PHY: Fix setting TX power control mode during RC
 calibration
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Call set_tx_power_control with a LPPHY_TXPCTL rather than an
LPPHY_TX_PWR_CTL_CMD_MODE.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
This should fix the WARN_ON testers were seeing during init.

 drivers/net/wireless/b43/phy_lp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index adfa7bf..558224b 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1080,7 +1080,7 @@ static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
 	old_txpctl = b43_phy_read(dev, B43_LPPHY_TX_PWR_CTL_CMD) &
 					B43_LPPHY_TX_PWR_CTL_CMD_MODE;
 
-	lpphy_set_tx_power_control(dev, B43_LPPHY_TX_PWR_CTL_CMD_MODE_OFF);
+	lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
 	lpphy_disable_crs(dev);
 	loopback = lpphy_loopback(dev);
 	if (loopback == -1)
-- 
1.6.2.4



