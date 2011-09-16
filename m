Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48228 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1IPKbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 06:31:16 -0400
Received: by mail-fx0-f46.google.com with SMTP id 4so1527867fxe.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 03:31:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/6] b43: LCN-PHY: implement SPUR avoidance mode
Date: Fri, 16 Sep 2011 12:34:01 +0200
Message-Id: <1316169243-8808-4-git-send-email-zajec5@gmail.com> (sfid-20110916_123122_287818_B8746D56)
In-Reply-To: <1316169243-8808-1-git-send-email-zajec5@gmail.com>
References: <1316169243-8808-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_lcn.c |   58 ++++++++++++++++++++++++++++++++++-
 1 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index 7650364..8951647 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -42,6 +42,39 @@ struct lcn_tx_iir_filter {
 	u16 values[16];
 };
 
+/* In theory it's PHY common function, move if needed */
+/* brcms_b_switch_macfreq */
+static void b43_phy_switch_macfreq(struct b43_wldev *dev, u8 spurmode)
+{
+	if (dev->dev->chip_id == 43224 || dev->dev->chip_id == 43225) {
+		switch (spurmode) {
+		case 2:		/* 126 Mhz */
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x2082);
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x8);
+			break;
+		case 1:		/* 123 Mhz */
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x5341);
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x8);
+			break;
+		default:	/* 120 Mhz */
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x8889);
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x8);
+			break;
+		}
+	} else if (dev->phy.type == B43_PHYTYPE_LCN) {
+		switch (spurmode) {
+		case 1:		/* 82 Mhz */
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x7CE0);
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0xC);
+			break;
+		default:	/* 80 Mhz */
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0xCCCD);
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0xC);
+			break;
+		}
+	}
+}
+
 /**************************************************
  * Radio 2064.
  **************************************************/
@@ -367,6 +400,27 @@ static bool b43_phy_lcn_load_tx_iir_ofdm_filter(struct b43_wldev *dev,
 	return false;
 }
 
+/* wlc_lcnphy_txrx_spur_avoidance_mode */
+static void b43_phy_lcn_txrx_spur_avoidance_mode(struct b43_wldev *dev,
+						 bool enable)
+{
+	if (enable) {
+		b43_phy_write(dev, 0x942, 0x7);
+		b43_phy_write(dev, 0x93b, ((1 << 13) + 23));
+		b43_phy_write(dev, 0x93c, ((1 << 13) + 1989));
+
+		b43_phy_write(dev, 0x44a, 0x084);
+		b43_phy_write(dev, 0x44a, 0x080);
+		b43_phy_write(dev, 0x6d3, 0x2222);
+		b43_phy_write(dev, 0x6d3, 0x2220);
+	} else {
+		b43_phy_write(dev, 0x942, 0x0);
+		b43_phy_write(dev, 0x93b, ((0 << 13) + 23));
+		b43_phy_write(dev, 0x93c, ((0 << 13) + 1989));
+	}
+	b43_phy_switch_macfreq(dev, enable);
+}
+
 /**************************************************
  * Channel switching ops.
  **************************************************/
@@ -388,7 +442,7 @@ static void b43_phy_lcn_set_channel_tweaks(struct b43_wldev *dev, int channel)
 
 		b43_phy_write(dev, 0x942, 0);
 
-		/* b43_phy_lcn_txrx_spur_avoidance_mode(dev, false); */
+		b43_phy_lcn_txrx_spur_avoidance_mode(dev, false);
 		b43_phy_maskset(dev, 0x424, (u16) ~0xff00, 0x1b00);
 		b43_phy_write(dev, 0x425, 0x5907);
 	} else {
@@ -400,7 +454,7 @@ static void b43_phy_lcn_set_channel_tweaks(struct b43_wldev *dev, int channel)
 
 		b43_phy_write(dev, 0x942, 0);
 
-		/* b43_phy_lcn_txrx_spur_avoidance_mode(dev, true); */
+		b43_phy_lcn_txrx_spur_avoidance_mode(dev, true);
 		b43_phy_maskset(dev, 0x424, (u16) ~0xff00, 0x1f00);
 		b43_phy_write(dev, 0x425, 0x590a);
 	}
-- 
1.7.3.4

