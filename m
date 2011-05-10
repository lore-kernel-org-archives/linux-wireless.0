Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49896 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab1EJOFy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 10:05:54 -0400
Received: by ewy4 with SMTP id 4so1838560ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 07:05:53 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: move MAC PHY clock controling function
Date: Tue, 10 May 2011 16:05:33 +0200
Message-Id: <1305036333-11246-1-git-send-email-zajec5@gmail.com> (sfid-20110510_160603_579853_64B8BDA9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not N-PHY specific function, we partially duplicate code.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c  |   17 +++++++++++++----
 drivers/net/wireless/b43/main.h  |    1 +
 drivers/net/wireless/b43/phy_n.c |   13 +------------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index fd8bd98..53d109b 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2686,6 +2686,17 @@ out:
 	dev->mac_suspended++;
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/MacPhyClkSet */
+void b43_mac_phy_clock_set(struct b43_wldev *dev, bool on)
+{
+	u32 tmslow = ssb_read32(dev->dev, SSB_TMSLOW);
+	if (on)
+		tmslow |= B43_TMSLOW_MACPHYCLKEN;
+	else
+		tmslow &= ~B43_TMSLOW_MACPHYCLKEN;
+	ssb_write32(dev->dev, SSB_TMSLOW, tmslow);
+}
+
 static void b43_adjust_opmode(struct b43_wldev *dev)
 {
 	struct b43_wl *wl = dev->wl;
@@ -2842,7 +2853,7 @@ static int b43_chip_init(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	int err;
-	u32 value32, macctl;
+	u32 macctl;
 	u16 value16;
 
 	/* Initialize the MAC control */
@@ -2920,9 +2931,7 @@ static int b43_chip_init(struct b43_wldev *dev)
 	b43_write32(dev, B43_MMIO_DMA4_IRQ_MASK, 0x0000DC00);
 	b43_write32(dev, B43_MMIO_DMA5_IRQ_MASK, 0x0000DC00);
 
-	value32 = ssb_read32(dev->dev, SSB_TMSLOW);
-	value32 |= 0x00100000;
-	ssb_write32(dev->dev, SSB_TMSLOW, value32);
+	b43_mac_phy_clock_set(dev, true);
 
 	b43_write16(dev, B43_MMIO_POWERUP_DELAY,
 		    dev->dev->bus->chipco.fast_pwrup_delay);
diff --git a/drivers/net/wireless/b43/main.h b/drivers/net/wireless/b43/main.h
index 40db036..a0d327f 100644
--- a/drivers/net/wireless/b43/main.h
+++ b/drivers/net/wireless/b43/main.h
@@ -133,6 +133,7 @@ void b43_power_saving_ctl_bits(struct b43_wldev *dev, unsigned int ps_flags);
 
 void b43_mac_suspend(struct b43_wldev *dev);
 void b43_mac_enable(struct b43_wldev *dev);
+void b43_mac_phy_clock_set(struct b43_wldev *dev, bool on);
 
 
 struct b43_request_fw_context;
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 6755063..b075a3f 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3540,17 +3540,6 @@ static int b43_nphy_cal_rx_iq(struct b43_wldev *dev,
 		return b43_nphy_rev2_cal_rx_iq(dev, target, type, debug);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/MacPhyClkSet */
-static void b43_nphy_mac_phy_clock_set(struct b43_wldev *dev, bool on)
-{
-	u32 tmslow = ssb_read32(dev->dev, SSB_TMSLOW);
-	if (on)
-		tmslow |= B43_TMSLOW_MACPHYCLKEN;
-	else
-		tmslow &= ~B43_TMSLOW_MACPHYCLKEN;
-	ssb_write32(dev->dev, SSB_TMSLOW, tmslow);
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxCoreSetState */
 static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
 {
@@ -3691,7 +3680,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_BBCFG, tmp & ~B43_NPHY_BBCFG_RSTCCA);
 	b43_nphy_bmac_clock_fgc(dev, 0);
 
-	b43_nphy_mac_phy_clock_set(dev, true);
+	b43_mac_phy_clock_set(dev, true);
 
 	b43_nphy_pa_override(dev, false);
 	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RX2TX);
-- 
1.7.1

