Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36360 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaGQRc4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 13:32:56 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so2393993wgh.14
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 10:32:55 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/6] b43: use one shared function for setting MAC frequency
Date: Thu, 17 Jul 2014 19:31:05 +0200
Message-Id: <1405618266-20200-5-git-send-email-zajec5@gmail.com> (sfid-20140717_193304_625695_6E14A7E5)
In-Reply-To: <1405618266-20200-1-git-send-email-zajec5@gmail.com>
References: <1405618266-20200-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By the way add few chipsets that were tracked with "wl" dumps.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c    | 39 ++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/main.h    |  1 +
 drivers/net/wireless/b43/phy_lcn.c | 35 +---------------------------------
 drivers/net/wireless/b43/phy_n.c   |  7 +------
 include/linux/bcma/bcma.h          |  1 +
 5 files changed, 43 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 3dcd3aa..3e127be 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2964,6 +2964,45 @@ void b43_mac_phy_clock_set(struct b43_wldev *dev, bool on)
 	}
 }
 
+/* brcms_b_switch_macfreq */
+void b43_mac_switch_freq(struct b43_wldev *dev, u8 spurmode)
+{
+	u16 chip_id = dev->dev->chip_id;
+
+	if (chip_id == BCMA_CHIP_ID_BCM43217 ||
+	    chip_id == BCMA_CHIP_ID_BCM43222 ||
+	    chip_id == BCMA_CHIP_ID_BCM43224 ||
+	    chip_id == BCMA_CHIP_ID_BCM43225 ||
+	    chip_id == BCMA_CHIP_ID_BCM43227 ||
+	    chip_id == BCMA_CHIP_ID_BCM43228) {
+		switch (spurmode) {
+		case 2: /* 126 Mhz */
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x2082);
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x8);
+			break;
+		case 1: /* 123 Mhz */
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x5341);
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x8);
+			break;
+		default: /* 120 Mhz */
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x8889);
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x8);
+			break;
+		}
+	} else if (dev->phy.type == B43_PHYTYPE_LCN) {
+		switch (spurmode) {
+		case 1: /* 82 Mhz */
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x7CE0);
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0xC);
+			break;
+		default: /* 80 Mhz */
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0xCCCD);
+			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0xC);
+			break;
+		}
+	}
+}
+
 static void b43_adjust_opmode(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
diff --git a/drivers/net/wireless/b43/main.h b/drivers/net/wireless/b43/main.h
index f476fc3..9f22e4b 100644
--- a/drivers/net/wireless/b43/main.h
+++ b/drivers/net/wireless/b43/main.h
@@ -99,6 +99,7 @@ void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags);
 void b43_mac_suspend(struct b43_wldev *dev);
 void b43_mac_enable(struct b43_wldev *dev);
 void b43_mac_phy_clock_set(struct b43_wldev *dev, bool on);
+void b43_mac_switch_freq(struct b43_wldev *dev, u8 spurmode);
 
 
 struct b43_request_fw_context;
diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index 0bafa3b..e76bbdf 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -54,39 +54,6 @@ enum lcn_sense_type {
 	B43_SENSE_VBAT,
 };
 
-/* In theory it's PHY common function, move if needed */
-/* brcms_b_switch_macfreq */
-static void b43_phy_switch_macfreq(struct b43_wldev *dev, u8 spurmode)
-{
-	if (dev->dev->chip_id == 43224 || dev->dev->chip_id == 43225) {
-		switch (spurmode) {
-		case 2:		/* 126 Mhz */
-			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x2082);
-			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x8);
-			break;
-		case 1:		/* 123 Mhz */
-			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x5341);
-			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x8);
-			break;
-		default:	/* 120 Mhz */
-			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x8889);
-			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x8);
-			break;
-		}
-	} else if (dev->phy.type == B43_PHYTYPE_LCN) {
-		switch (spurmode) {
-		case 1:		/* 82 Mhz */
-			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0x7CE0);
-			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0xC);
-			break;
-		default:	/* 80 Mhz */
-			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW, 0xCCCD);
-			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0xC);
-			break;
-		}
-	}
-}
-
 /**************************************************
  * Radio 2064.
  **************************************************/
@@ -609,7 +576,7 @@ static void b43_phy_lcn_txrx_spur_avoidance_mode(struct b43_wldev *dev,
 		b43_phy_write(dev, 0x93b, ((0 << 13) + 23));
 		b43_phy_write(dev, 0x93c, ((0 << 13) + 1989));
 	}
-	b43_phy_switch_macfreq(dev, enable);
+	b43_mac_switch_freq(dev, enable);
 }
 
 /**************************************************
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index ef1acae..0f0c130 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -6113,12 +6113,7 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 
 		b43_nphy_pmu_spur_avoid(dev, avoid);
 
-		if (dev->dev->chip_id == 43222 || dev->dev->chip_id == 43224 ||
-		    dev->dev->chip_id == 43225) {
-			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_LOW,
-				    avoid ? 0x5341 : 0x8889);
-			b43_write16(dev, B43_MMIO_TSF_CLK_FRAC_HIGH, 0x8);
-		}
+		b43_mac_switch_freq(dev, avoid);
 
 		if (dev->phy.rev == 3 || dev->phy.rev == 4)
 			; /* TODO: reset PLL */
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 7cb2344..969af0f 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -159,6 +159,7 @@ struct bcma_host_ops {
 #define BCMA_CHIP_ID_BCM4313	0x4313
 #define BCMA_CHIP_ID_BCM43142	43142
 #define BCMA_CHIP_ID_BCM43217	43217
+#define BCMA_CHIP_ID_BCM43222	43222
 #define BCMA_CHIP_ID_BCM43224	43224
 #define  BCMA_PKG_ID_BCM43224_FAB_CSM	0x8
 #define  BCMA_PKG_ID_BCM43224_FAB_SMIC	0xa
-- 
1.8.4.5

