Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:45853 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbZITIJc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2009 04:09:32 -0400
Subject: [RFC][PATCH] b43: Comment unused functions
 lpphy_restore_dig_flt_state and lpphy_disable_rx_gain_override
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Sep 2009 13:39:24 +0530
Message-Id: <1253434164.19515.5.camel@ht.satnam>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Commenting unused functions lpphy_restore_dig_flt_state and
lpphy_disable_rx_gain_override, may be we need these functions in future.

This also fixed following compilation warnings :
  CC [M]  drivers/net/wireless/b43/phy_lp.o
drivers/net/wireless/b43/phy_lp.c:383: warning: ‘lpphy_restore_dig_flt_state’ defined but not used
drivers/net/wireless/b43/phy_lp.c:891: warning: ‘lpphy_disable_rx_gain_override’ defined but not used

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/net/wireless/b43/phy_lp.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 3e02d96..9c31462 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -379,6 +379,8 @@ static void lpphy_save_dig_flt_state(struct b43_wldev *dev)
 	}
 }
 
+/* lpphy_restore_dig_flt_state is unused but kept as a reference */
+#if 0
 static void lpphy_restore_dig_flt_state(struct b43_wldev *dev)
 {
 	static const u16 addr[] = {
@@ -399,6 +401,7 @@ static void lpphy_restore_dig_flt_state(struct b43_wldev *dev)
 	for (i = 0; i < ARRAY_SIZE(addr); i++)
 		b43_phy_write(dev, addr[i], lpphy->dig_flt_state[i]);
 }
+#endif
 
 static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 {
@@ -887,6 +890,8 @@ static void lpphy_rev2plus_set_rx_gain(struct b43_wldev *dev, u32 gain)
 	}
 }
 
+/* lpphy_disable_rx_gain_override is unused but kept as a reference */
+#if 0
 static void lpphy_disable_rx_gain_override(struct b43_wldev *dev)
 {
 	b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_0, 0xFFFE);
@@ -902,6 +907,7 @@ static void lpphy_disable_rx_gain_override(struct b43_wldev *dev)
 		b43_phy_mask(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFDFF);
 	}
 }
+#endif
 
 static void lpphy_enable_rx_gain_override(struct b43_wldev *dev)
 {
-- 
1.6.4.4


