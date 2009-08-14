Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:60960 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbZHNS3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 14:29:47 -0400
Received: by bwz22 with SMTP id 22so1295212bwz.18
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 11:29:47 -0700 (PDT)
Message-ID: <4A85AD1B.1060008@gmail.com>
Date: Fri, 14 Aug 2009 20:29:47 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: LP-PHY: Fix reading old mode in the set TX power control
 routine
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the mode the hardware is in, not the mode we used the last time.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
Mark, please test if this fixes the TX power control WARN_ON you were seeing.

 drivers/net/wireless/b43/phy_lp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 292ee51..76457f7 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1015,9 +1015,9 @@ static void lpphy_set_tx_power_control(struct b43_wldev *dev,
 	struct b43_phy_lp *lpphy = dev->phy.lp;
 	enum b43_lpphy_txpctl_mode oldmode;
 
-	oldmode = lpphy->txpctl_mode;
 	lpphy_read_tx_pctl_mode_from_hardware(dev);
-	if (lpphy->txpctl_mode == mode)
+	oldmode = lpphy->txpctl_mode;
+	if (oldmode == mode)
 		return;
 	lpphy->txpctl_mode = mode;
 
-- 
1.6.2.4



