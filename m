Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:64478 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbZHNVAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 17:00:31 -0400
Received: by bwz22 with SMTP id 22so1356783bwz.18
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 14:00:32 -0700 (PDT)
Message-ID: <4A85D070.6070702@gmail.com>
Date: Fri, 14 Aug 2009 23:00:32 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: LP-PHY: Fix another TX power control abuse
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should fix the remaining WARN_ON.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/phy_lp.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index bf89173..3872a31 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1059,7 +1059,8 @@ static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
 	bool old_txg_ovr;
 	u8 old_bbmult;
 	u16 old_rf_ovr, old_rf_ovrval, old_afe_ovr, old_afe_ovrval,
-	    old_rf2_ovr, old_rf2_ovrval, old_phy_ctl, old_txpctl;
+	    old_rf2_ovr, old_rf2_ovrval, old_phy_ctl;
+	enum b43_lpphy_txpctl_mode old_txpctl;
 	u32 normal_pwr, ideal_pwr, mean_sq_pwr, tmp = 0, mean_sq_pwr_min = 0;
 	int loopback, i, j, inner_sum;
 
@@ -1077,8 +1078,8 @@ static void lpphy_rev0_1_rc_calib(struct b43_wldev *dev)
 	old_rf2_ovr = b43_phy_read(dev, B43_LPPHY_RF_OVERRIDE_2);
 	old_rf2_ovrval = b43_phy_read(dev, B43_LPPHY_RF_OVERRIDE_2_VAL);
 	old_phy_ctl = b43_phy_read(dev, B43_LPPHY_LP_PHY_CTL);
-	old_txpctl = b43_phy_read(dev, B43_LPPHY_TX_PWR_CTL_CMD) &
-					B43_LPPHY_TX_PWR_CTL_CMD_MODE;
+	lpphy_read_tx_pctl_mode_from_hardware(dev);
+	old_txpctl = lpphy->txpctl_mode;
 
 	lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
 	lpphy_disable_crs(dev);
-- 
1.6.2.4



