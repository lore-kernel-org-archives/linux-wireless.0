Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:44813 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbZH0Utu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 16:49:50 -0400
Received: by ewy2 with SMTP id 2so1594075ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 13:49:51 -0700 (PDT)
Message-ID: <4A96F16D.2020304@gmail.com>
Date: Thu, 27 Aug 2009 22:49:49 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] b43: Implement antenna diversity support for LP-PHY
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The A/G-PHY changes are fallout fixes from the enum change,
which in turn allows the LP-PHY code to be much simpler.
The antenna_to_phyctl change is a fix for a potential
existing bug that this patch may otherwise trigger.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
v2: Fix a typo.

 drivers/net/wireless/b43/main.c       |    3 ++-
 drivers/net/wireless/b43/phy_a.c      |    2 +-
 drivers/net/wireless/b43/phy_common.h |   10 +++++-----
 drivers/net/wireless/b43/phy_g.c      |    2 +-
 drivers/net/wireless/b43/phy_lp.c     |    9 ++++++++-
 5 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 289e06c..3b038c9 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1456,7 +1456,8 @@ static u16 b43_antenna_to_phyctl(int antenna)
 		return B43_TXH_PHY_ANT2;
 	case B43_ANTENNA3:
 		return B43_TXH_PHY_ANT3;
-	case B43_ANTENNA_AUTO:
+	case B43_ANTENNA_AUTO0:
+	case B43_ANTENNA_AUTO1:
 		return B43_TXH_PHY_ANT01AUTO;
 	}
 	B43_WARN_ON(1);
diff --git a/drivers/net/wireless/b43/phy_a.c b/drivers/net/wireless/b43/phy_a.c
index 816e028..809ec97 100644
--- a/drivers/net/wireless/b43/phy_a.c
+++ b/drivers/net/wireless/b43/phy_a.c
@@ -531,7 +531,7 @@ static void b43_aphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
 
 	tmp = b43_phy_read(dev, B43_PHY_BBANDCFG);
 	tmp &= ~B43_PHY_BBANDCFG_RXANT;
-	tmp |= (autodiv ? B43_ANTENNA_AUTO0 : antenna)
+	tmp |= (autodiv ? B43_ANTENNA_AUTO1 : antenna)
 	    << B43_PHY_BBANDCFG_RXANT_SHIFT;
 	b43_phy_write(dev, B43_PHY_BBANDCFG, tmp);
 
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index b47a0f5..28e3846 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -49,11 +49,11 @@ enum b43_interference_mitigation {
 
 /* Antenna identifiers */
 enum {
-	B43_ANTENNA0,		/* Antenna 0 */
-	B43_ANTENNA1,		/* Antenna 0 */
-	B43_ANTENNA_AUTO1,	/* Automatic, starting with antenna 1 */
-	B43_ANTENNA_AUTO0,	/* Automatic, starting with antenna 0 */
-	B43_ANTENNA2,
+	B43_ANTENNA0 = 0,	/* Antenna 0 */
+	B43_ANTENNA1 = 1,	/* Antenna 1 */
+	B43_ANTENNA_AUTO0 = 2,	/* Automatic, starting with antenna 0 */
+	B43_ANTENNA_AUTO1 = 3,	/* Automatic, starting with antenna 1 */
+	B43_ANTENNA2 = 4,
 	B43_ANTENNA3 = 8,
 
 	B43_ANTENNA_AUTO = B43_ANTENNA_AUTO0,
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index c6c9d2f..c6d639d 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -2651,7 +2651,7 @@ static void b43_gphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
 
 	tmp = b43_phy_read(dev, B43_PHY_BBANDCFG);
 	tmp &= ~B43_PHY_BBANDCFG_RXANT;
-	tmp |= (autodiv ? B43_ANTENNA_AUTO0 : antenna)
+	tmp |= (autodiv ? B43_ANTENNA_AUTO1 : antenna)
 			<< B43_PHY_BBANDCFG_RXANT_SHIFT;
 	b43_phy_write(dev, B43_PHY_BBANDCFG, tmp);
 
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 837d952..fded6e5 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -2204,7 +2204,14 @@ static int b43_lpphy_op_init(struct b43_wldev *dev)
 
 static void b43_lpphy_op_set_rx_antenna(struct b43_wldev *dev, int antenna)
 {
-	//TODO
+	if (dev->phy.rev >= 2)
+		return; // rev2+ doesn't support antenna diversity
+
+	if (B43_WARN_ON(antenna > B43_ANTENNA_AUTO1))
+		return;
+
+	b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFFFD, antenna & 0x2);
+	b43_phy_maskset(dev, B43_LPPHY_CRSGAIN_CTL, 0xFFFE, antenna & 0x1);
 }
 
 static void b43_lpphy_op_adjust_txpower(struct b43_wldev *dev)
-- 
1.6.2.4



