Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40123 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab0GUQAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 12:00:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@wfinger.net>,
	=?UTF-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: silense most sparse warnings
Date: Wed, 21 Jul 2010 11:45:42 -0400
Message-Id: <1279727142-25234-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   drivers/net/wireless/b43/main.c
drivers/net/wireless/b43/main.c:111:5: warning: symbol 'b43_modparam_pio' was not declared. Should it be static?
  CHECK   drivers/net/wireless/b43/phy_g.c
drivers/net/wireless/b43/phy_g.c:975:56: warning: cast truncates bits from constant value (ffff7fff becomes 7fff)
  CHECK   drivers/net/wireless/b43/phy_lp.c
drivers/net/wireless/b43/phy_lp.c:2701:6: warning: symbol 'b43_lpphy_op_switch_analog' was not declared. Should it be static?
drivers/net/wireless/b43/phy_lp.c:1148:30: warning: cast truncates bits from constant value (ffff1fff becomes 1fff)
drivers/net/wireless/b43/phy_lp.c:1525:30: warning: cast truncates bits from constant value (ffff1fff becomes 1fff)
drivers/net/wireless/b43/phy_lp.c:1529:30: warning: cast truncates bits from constant value (ffff1fff becomes 1fff)
  CHECK   drivers/net/wireless/b43/wa.c
drivers/net/wireless/b43/wa.c:385:60: warning: cast truncates bits from constant value (ffff00ff becomes ff)
drivers/net/wireless/b43/wa.c:403:55: warning: cast truncates bits from constant value (ffff00ff becomes ff)
drivers/net/wireless/b43/wa.c:405:55: warning: cast truncates bits from constant value (ffff00ff becomes ff)
drivers/net/wireless/b43/wa.c:415:71: warning: cast truncates bits from constant value (ffff0fff becomes fff)

AFAICT, none of these amount to real bugs.  But this reduces warning
spam from sparse w/o significantly affecting readability of the code (IMHO).

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43/main.c   |    2 +-
 drivers/net/wireless/b43/phy_g.c  |    2 +-
 drivers/net/wireless/b43/phy_lp.c |    8 ++++----
 drivers/net/wireless/b43/wa.c     |    8 ++++----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 8e24379..20631ae 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -108,7 +108,7 @@ int b43_modparam_verbose = B43_VERBOSITY_DEFAULT;
 module_param_named(verbose, b43_modparam_verbose, int, 0644);
 MODULE_PARM_DESC(verbose, "Log message verbosity: 0=error, 1=warn, 2=info(default), 3=debug");
 
-int b43_modparam_pio = B43_PIO_DEFAULT;
+static int b43_modparam_pio = B43_PIO_DEFAULT;
 module_param_named(pio, b43_modparam_pio, int, 0644);
 MODULE_PARM_DESC(pio, "Use PIO accesses by default: 0=DMA, 1=PIO");
 
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index 29bf34c..0dc33b6 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -972,7 +972,7 @@ b43_radio_interference_mitigation_enable(struct b43_wldev *dev, int mode)
 		b43_phy_maskset(dev, 0x04A2, 0xFFF0, 0x000B);
 
 		if (phy->rev >= 3) {
-			b43_phy_mask(dev, 0x048A, (u16)~0x8000);
+			b43_phy_mask(dev, 0x048A, 0x7FFF);
 			b43_phy_maskset(dev, 0x0415, 0x8000, 0x36D8);
 			b43_phy_maskset(dev, 0x0416, 0x8000, 0x36D8);
 			b43_phy_maskset(dev, 0x0417, 0xFE00, 0x016D);
diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index c6afe9d..fd50eb1 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1145,7 +1145,7 @@ static void lpphy_write_tx_pctl_mode_to_hardware(struct b43_wldev *dev)
 		B43_WARN_ON(1);
 	}
 	b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_CMD,
-			(u16)~B43_LPPHY_TX_PWR_CTL_CMD_MODE, ctl);
+			~B43_LPPHY_TX_PWR_CTL_CMD_MODE & 0xFFFF, ctl);
 }
 
 static void lpphy_set_tx_power_control(struct b43_wldev *dev,
@@ -1522,11 +1522,11 @@ static void lpphy_tx_pctl_init_hw(struct b43_wldev *dev)
 	b43_phy_mask(dev, B43_LPPHY_TX_PWR_CTL_DELTAPWR_LIMIT, 0xFF);
 	b43_phy_write(dev, B43_LPPHY_TX_PWR_CTL_DELTAPWR_LIMIT, 0xA);
 	b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_CMD,
-			(u16)~B43_LPPHY_TX_PWR_CTL_CMD_MODE,
+			~B43_LPPHY_TX_PWR_CTL_CMD_MODE & 0xFFFF,
 			B43_LPPHY_TX_PWR_CTL_CMD_MODE_OFF);
 	b43_phy_mask(dev, B43_LPPHY_TX_PWR_CTL_NNUM, 0xF8FF);
 	b43_phy_maskset(dev, B43_LPPHY_TX_PWR_CTL_CMD,
-			(u16)~B43_LPPHY_TX_PWR_CTL_CMD_MODE,
+			~B43_LPPHY_TX_PWR_CTL_CMD_MODE & 0xFFFF,
 			B43_LPPHY_TX_PWR_CTL_CMD_MODE_SW);
 
 	if (dev->phy.rev < 2) {
@@ -2698,7 +2698,7 @@ static enum b43_txpwr_result b43_lpphy_op_recalc_txpower(struct b43_wldev *dev,
 	return B43_TXPWR_RES_DONE;
 }
 
-void b43_lpphy_op_switch_analog(struct b43_wldev *dev, bool on)
+static void b43_lpphy_op_switch_analog(struct b43_wldev *dev, bool on)
 {
        if (on) {
                b43_phy_mask(dev, B43_LPPHY_AFE_CTL_OVR, 0xfff8);
diff --git a/drivers/net/wireless/b43/wa.c b/drivers/net/wireless/b43/wa.c
index 97c7916..9a335da 100644
--- a/drivers/net/wireless/b43/wa.c
+++ b/drivers/net/wireless/b43/wa.c
@@ -382,7 +382,7 @@ static void b43_wa_altagc(struct b43_wldev *dev)
 		b43_ofdmtab_write16(dev, B43_OFDMTAB_AGC1, 3, 25);
 	}
 
-	b43_phy_maskset(dev, B43_PHY_CCKSHIFTBITS_WA, (u16)~0xFF00, 0x5700);
+	b43_phy_maskset(dev, B43_PHY_CCKSHIFTBITS_WA, 0x00FF, 0x5700);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x1A), ~0x007F, 0x000F);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x1A), ~0x3F80, 0x2B80);
 	b43_phy_maskset(dev, B43_PHY_ANTWRSETT, 0xF0FF, 0x0300);
@@ -400,9 +400,9 @@ static void b43_wa_altagc(struct b43_wldev *dev)
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x89), ~0x00FF, 0x0020);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x89), ~0x3F00, 0x0200);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x82), ~0x00FF, 0x002E);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), (u16)~0xFF00, 0x1A00);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x96), 0x00FF, 0x1A00);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), ~0x00FF, 0x0028);
-	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), (u16)~0xFF00, 0x2C00);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x81), 0x00FF, 0x2C00);
 	if (phy->rev == 1) {
 		b43_phy_write(dev, B43_PHY_PEAK_COUNT, 0x092B);
 		b43_phy_maskset(dev, B43_PHY_OFDM(0x1B), ~0x001E, 0x0002);
@@ -412,7 +412,7 @@ static void b43_wa_altagc(struct b43_wldev *dev)
 		b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, ~0x000F, 0x0004);
 		if (phy->rev >= 6) {
 			b43_phy_write(dev, B43_PHY_OFDM(0x22), 0x287A);
-			b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, (u16)~0xF000, 0x3000);
+			b43_phy_maskset(dev, B43_PHY_LPFGAINCTL, 0x0FFF, 0x3000);
 		}
 	}
 	b43_phy_maskset(dev, B43_PHY_DIVSRCHIDX, 0x8080, 0x7874);
-- 
1.7.1.1

