Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36469 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaGaUAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2014 16:00:51 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so3223885wgh.1
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jul 2014 13:00:50 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3.18 2/7] b43: don't duplicate common PHY read/write ops
Date: Thu, 31 Jul 2014 21:59:43 +0200
Message-Id: <1406836788-23704-3-git-send-email-zajec5@gmail.com> (sfid-20140731_220055_600590_2F5AD1E5)
In-Reply-To: <1406836788-23704-1-git-send-email-zajec5@gmail.com>
References: <1406836788-23704-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most of the PHYs use the same way of accessing registers, so move that
code to the shared place. An exception is G-PHY which sometimes access
A-PHY regs and requires special handling.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_common.c | 14 ++++++++++++--
 drivers/net/wireless/b43/phy_ht.c     | 14 --------------
 drivers/net/wireless/b43/phy_lcn.c    | 14 --------------
 drivers/net/wireless/b43/phy_lp.c     | 14 --------------
 drivers/net/wireless/b43/phy_n.c      | 16 ----------------
 5 files changed, 12 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index c868748..08ca524 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -274,7 +274,12 @@ u16 b43_phy_read(struct b43_wldev *dev, u16 reg)
 {
 	assert_mac_suspended(dev);
 	dev->phy.writes_counter = 0;
-	return dev->phy.ops->phy_read(dev, reg);
+
+	if (dev->phy.ops->phy_read)
+		return dev->phy.ops->phy_read(dev, reg);
+
+	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	return b43_read16(dev, B43_MMIO_PHY_DATA);
 }
 
 void b43_phy_write(struct b43_wldev *dev, u16 reg, u16 value)
@@ -285,7 +290,12 @@ void b43_phy_write(struct b43_wldev *dev, u16 reg, u16 value)
 		b43_read16(dev, B43_MMIO_PHY_VER);
 		dev->phy.writes_counter = 1;
 	}
-	dev->phy.ops->phy_write(dev, reg, value);
+
+	if (dev->phy.ops->phy_write)
+		return dev->phy.ops->phy_write(dev, reg, value);
+
+	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16(dev, B43_MMIO_PHY_DATA, value);
 }
 
 void b43_phy_copy(struct b43_wldev *dev, u16 destreg, u16 srcreg)
diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index f2974c6..8b0b4b6 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -1071,18 +1071,6 @@ static unsigned int b43_phy_ht_op_get_default_chan(struct b43_wldev *dev)
  * R/W ops.
  **************************************************/
 
-static u16 b43_phy_ht_op_read(struct b43_wldev *dev, u16 reg)
-{
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
-	return b43_read16(dev, B43_MMIO_PHY_DATA);
-}
-
-static void b43_phy_ht_op_write(struct b43_wldev *dev, u16 reg, u16 value)
-{
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
-	b43_write16(dev, B43_MMIO_PHY_DATA, value);
-}
-
 static void b43_phy_ht_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
 				 u16 set)
 {
@@ -1126,8 +1114,6 @@ const struct b43_phy_operations b43_phyops_ht = {
 	.free			= b43_phy_ht_op_free,
 	.prepare_structs	= b43_phy_ht_op_prepare_structs,
 	.init			= b43_phy_ht_op_init,
-	.phy_read		= b43_phy_ht_op_read,
-	.phy_write		= b43_phy_ht_op_write,
 	.phy_maskset		= b43_phy_ht_op_maskset,
 	.radio_read		= b43_phy_ht_op_radio_read,
 	.radio_write		= b43_phy_ht_op_radio_write,
diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index e76bbdf..bf29c3e 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -810,18 +810,6 @@ static void b43_phy_lcn_op_adjust_txpower(struct b43_wldev *dev)
  * R/W ops.
  **************************************************/
 
-static u16 b43_phy_lcn_op_read(struct b43_wldev *dev, u16 reg)
-{
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
-	return b43_read16(dev, B43_MMIO_PHY_DATA);
-}
-
-static void b43_phy_lcn_op_write(struct b43_wldev *dev, u16 reg, u16 value)
-{
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
-	b43_write16(dev, B43_MMIO_PHY_DATA, value);
-}
-
 static void b43_phy_lcn_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
 				   u16 set)
 {
@@ -855,8 +843,6 @@ const struct b43_phy_operations b43_phyops_lcn = {
 	.free			= b43_phy_lcn_op_free,
 	.prepare_structs	= b43_phy_lcn_op_prepare_structs,
 	.init			= b43_phy_lcn_op_init,
-	.phy_read		= b43_phy_lcn_op_read,
-	.phy_write		= b43_phy_lcn_op_write,
 	.phy_maskset		= b43_phy_lcn_op_maskset,
 	.radio_read		= b43_phy_lcn_op_radio_read,
 	.radio_write		= b43_phy_lcn_op_radio_write,
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 92190da..1e9bae6 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1985,18 +1985,6 @@ static void lpphy_calibration(struct b43_wldev *dev)
 	b43_mac_enable(dev);
 }
 
-static u16 b43_lpphy_op_read(struct b43_wldev *dev, u16 reg)
-{
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
-	return b43_read16(dev, B43_MMIO_PHY_DATA);
-}
-
-static void b43_lpphy_op_write(struct b43_wldev *dev, u16 reg, u16 value)
-{
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
-	b43_write16(dev, B43_MMIO_PHY_DATA, value);
-}
-
 static void b43_lpphy_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
 				 u16 set)
 {
@@ -2713,8 +2701,6 @@ const struct b43_phy_operations b43_phyops_lp = {
 	.free			= b43_lpphy_op_free,
 	.prepare_structs	= b43_lpphy_op_prepare_structs,
 	.init			= b43_lpphy_op_init,
-	.phy_read		= b43_lpphy_op_read,
-	.phy_write		= b43_lpphy_op_write,
 	.phy_maskset		= b43_lpphy_op_maskset,
 	.radio_read		= b43_lpphy_op_radio_read,
 	.radio_write		= b43_lpphy_op_radio_write,
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index b04aa34..5565318 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -6497,20 +6497,6 @@ static inline void check_phyreg(struct b43_wldev *dev, u16 offset)
 #endif /* B43_DEBUG */
 }
 
-static u16 b43_nphy_op_read(struct b43_wldev *dev, u16 reg)
-{
-	check_phyreg(dev, reg);
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
-	return b43_read16(dev, B43_MMIO_PHY_DATA);
-}
-
-static void b43_nphy_op_write(struct b43_wldev *dev, u16 reg, u16 value)
-{
-	check_phyreg(dev, reg);
-	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
-	b43_write16(dev, B43_MMIO_PHY_DATA, value);
-}
-
 static void b43_nphy_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
 				 u16 set)
 {
@@ -6653,8 +6639,6 @@ const struct b43_phy_operations b43_phyops_n = {
 	.free			= b43_nphy_op_free,
 	.prepare_structs	= b43_nphy_op_prepare_structs,
 	.init			= b43_nphy_op_init,
-	.phy_read		= b43_nphy_op_read,
-	.phy_write		= b43_nphy_op_write,
 	.phy_maskset		= b43_nphy_op_maskset,
 	.radio_read		= b43_nphy_op_radio_read,
 	.radio_write		= b43_nphy_op_radio_write,
-- 
1.8.4.5

