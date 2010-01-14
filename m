Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:28653 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab0ANMVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 07:21:32 -0500
Received: by fg-out-1718.google.com with SMTP id 19so155607fgg.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 04:21:30 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 14 Jan 2010 13:21:27 +0100
Subject: [PATCH 1/2] b43: make finding the most significant bit common
 function
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6iu91z39lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_common.c |   14 ++++++++++++++
  drivers/net/wireless/b43/phy_common.h |    1 +
  drivers/net/wireless/b43/phy_lp.c     |   17 ++---------------
  3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 75b26e1..1389ab2 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -421,3 +421,17 @@ void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on)
  {
  	b43_write16(dev, B43_MMIO_PHY0, on ? 0 : 0xF4);
  }
+
+/* Find the position of the most significant bit */
+u8 phy_nbits(s32 val)
+{
+	u32 tmp = abs(val);
+	u8 nbits = 0;
+
+	while (tmp != 0) {
+		nbits++;
+		tmp >>= 1;
+	}
+
+	return nbits;
+}
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 9edd4e8..332ba4c 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -418,5 +418,6 @@ int b43_phy_shm_tssi_read(struct b43_wldev *dev, u16 shm_offset);
   */
  void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on);

+u8 phy_nbits(s32 val);

  #endif /* LINUX_B43_PHY_COMMON_H_ */
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index c4e9c5c..7ad9215 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1593,19 +1593,6 @@ static const struct lpphy_rx_iq_comp lpphy_rev2plus_iq_comp = {
  	.c0 = 0,
  };

-static u8 lpphy_nbits(s32 val)
-{
-	u32 tmp = abs(val);
-	u8 nbits = 0;
-
-	while (tmp != 0) {
-		nbits++;
-		tmp >>= 1;
-	}
-
-	return nbits;
-}
-
  static int lpphy_calc_rx_iq_comp(struct b43_wldev *dev, u16 samples)
  {
  	struct lpphy_iq_est iq_est;
@@ -1632,8 +1619,8 @@ static int lpphy_calc_rx_iq_comp(struct b43_wldev *dev, u16 samples)
  		goto out;
  	}

-	prod_msb = lpphy_nbits(prod);
-	q_msb = lpphy_nbits(qpwr);
+	prod_msb = phy_nbits(prod);
+	q_msb = phy_nbits(qpwr);
  	tmp1 = prod_msb - 20;

  	if (tmp1 >= 0) {
-- 
1.6.4.2

