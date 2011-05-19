Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58716 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608Ab1ESMdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 08:33:41 -0400
Received: by eyx24 with SMTP id 24so743998eyx.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 05:33:39 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	Julian Calaby <julian.calaby@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/4] b43: LP-PHY: use new pointers path to access ssb_device
Date: Thu, 19 May 2011 15:11:24 +0200
Message-Id: <1305810687-4567-1-git-send-email-zajec5@gmail.com> (sfid-20110519_143344_480163_59B6A401)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

LP-PHY code is SSB specific, add check for bus type.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_lp.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 2606c25..daec1d9 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -214,7 +214,7 @@ static void lpphy_table_init(struct b43_wldev *dev)
 
 static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
+	struct ssb_bus *bus = dev->dev->sdev->bus;
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy_lp *lpphy = dev->phy.lp;
 	u16 tmp, tmp2;
@@ -519,7 +519,7 @@ struct b2062_freqdata {
 static void lpphy_2062_init(struct b43_wldev *dev)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
-	struct ssb_bus *bus = dev->sdev->bus;
+	struct ssb_bus *bus = dev->dev->sdev->bus;
 	u32 crystalfreq, tmp, ref;
 	unsigned int i;
 	const struct b2062_freqdata *fd = NULL;
@@ -1289,7 +1289,7 @@ finish:
 
 static void lpphy_rev2plus_rc_calib(struct b43_wldev *dev)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
+	struct ssb_bus *bus = dev->dev->sdev->bus;
 	u32 crystal_freq = bus->chipco.pmu.crystalfreq * 1000;
 	u8 tmp = b43_radio_read(dev, B2063_RX_BB_SP8) & 0xFF;
 	int i;
@@ -2428,7 +2428,7 @@ static int lpphy_b2062_tune(struct b43_wldev *dev,
 			    unsigned int channel)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
-	struct ssb_bus *bus = dev->sdev->bus;
+	struct ssb_bus *bus = dev->dev->sdev->bus;
 	const struct b206x_channel *chandata = NULL;
 	u32 crystal_freq = bus->chipco.pmu.crystalfreq * 1000;
 	u32 tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9;
@@ -2518,7 +2518,7 @@ static void lpphy_b2063_vco_calib(struct b43_wldev *dev)
 static int lpphy_b2063_tune(struct b43_wldev *dev,
 			    unsigned int channel)
 {
-	struct ssb_bus *bus = dev->sdev->bus;
+	struct ssb_bus *bus = dev->dev->sdev->bus;
 
 	static const struct b206x_channel *chandata = NULL;
 	u32 crystal_freq = bus->chipco.pmu.crystalfreq * 1000;
@@ -2666,6 +2666,11 @@ static int b43_lpphy_op_init(struct b43_wldev *dev)
 {
 	int err;
 
+	if (dev->dev->bus_type != B43_BUS_SSB) {
+		b43err(dev->wl, "LP-PHY is supported only on SSB!\n");
+		return -EOPNOTSUPP;
+	}
+
 	lpphy_read_band_sprom(dev); //FIXME should this be in prepare_structs?
 	lpphy_baseband_init(dev);
 	lpphy_radio_init(dev);
-- 
1.7.3.4

