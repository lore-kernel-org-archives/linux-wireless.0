Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:62025 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbZHMOvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 10:51:52 -0400
Received: by fxm28 with SMTP id 28so636756fxm.17
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 07:51:52 -0700 (PDT)
Message-ID: <4A842887.2080109@gmail.com>
Date: Thu, 13 Aug 2009 16:51:51 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] b43: Update dummy transmission to match V4 specs
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The V4 dummy transmission has two extra bools in its prototype,
so update all callers with the 2 bools.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
v2: Convert all callers to v4, and drop the v3->v4 wrapper.

 drivers/net/wireless/b43/lo.c    |    2 +-
 drivers/net/wireless/b43/main.c  |   42 ++++++++++++++++++++++---------------
 drivers/net/wireless/b43/main.h  |    2 +-
 drivers/net/wireless/b43/phy_g.c |    6 ++--
 drivers/net/wireless/b43/wa.c    |    2 +-
 5 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/b43/lo.c b/drivers/net/wireless/b43/lo.c
index 22d0fbd..976104f 100644
--- a/drivers/net/wireless/b43/lo.c
+++ b/drivers/net/wireless/b43/lo.c
@@ -477,7 +477,7 @@ static void lo_measure_setup(struct b43_wldev *dev,
 	} else
 		b43_phy_write(dev, B43_PHY_CCK(0x2B), 0x0802);
 	if (phy->rev >= 2)
-		b43_dummy_transmission(dev);
+		b43_dummy_transmission(dev, false, true);
 	b43_gphy_channel_switch(dev, 6, 0);
 	b43_radio_read16(dev, 0x51);	/* dummy read */
 	if (phy->type == B43_PHYTYPE_G)
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index cb4a871..fbcbe4f 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -684,9 +684,9 @@ static void b43_synchronize_irq(struct b43_wldev *dev)
 }
 
 /* DummyTransmission function, as documented on
- * http://bcm-specs.sipsolutions.net/DummyTransmission
+ * http://bcm-v4.sipsolutions.net/802.11/DummyTransmission
  */
-void b43_dummy_transmission(struct b43_wldev *dev)
+void b43_dummy_transmission(struct b43_wldev *dev, bool ofdm, bool pa_on)
 {
 	struct b43_wl *wl = dev->wl;
 	struct b43_phy *phy = &dev->phy;
@@ -700,19 +700,12 @@ void b43_dummy_transmission(struct b43_wldev *dev)
 		0x00000000,
 	};
 
-	switch (phy->type) {
-	case B43_PHYTYPE_A:
+	if (ofdm) {
 		max_loop = 0x1E;
 		buffer[0] = 0x000201CC;
-		break;
-	case B43_PHYTYPE_B:
-	case B43_PHYTYPE_G:
+	} else {
 		max_loop = 0xFA;
 		buffer[0] = 0x000B846E;
-		break;
-	default:
-		B43_WARN_ON(1);
-		return;
 	}
 
 	spin_lock_irq(&wl->irq_lock);
@@ -721,20 +714,35 @@ void b43_dummy_transmission(struct b43_wldev *dev)
 	for (i = 0; i < 5; i++)
 		b43_ram_write(dev, i * 4, buffer[i]);
 
-	/* Commit writes */
-	b43_read32(dev, B43_MMIO_MACCTL);
-
 	b43_write16(dev, 0x0568, 0x0000);
-	b43_write16(dev, 0x07C0, 0x0000);
-	value = ((phy->type == B43_PHYTYPE_A) ? 1 : 0);
+	if (dev->dev->id.revision < 11)
+		b43_write16(dev, 0x07C0, 0x0000);
+	else
+		b43_write16(dev, 0x07C0, 0x0100);
+	value = (ofdm ? 0x41 : 0x40);
 	b43_write16(dev, 0x050C, value);
+	if ((phy->type == B43_PHYTYPE_N) || (phy->type == B43_PHYTYPE_LP))
+		b43_write16(dev, 0x0514, 0x1A02);
 	b43_write16(dev, 0x0508, 0x0000);
 	b43_write16(dev, 0x050A, 0x0000);
 	b43_write16(dev, 0x054C, 0x0000);
 	b43_write16(dev, 0x056A, 0x0014);
 	b43_write16(dev, 0x0568, 0x0826);
 	b43_write16(dev, 0x0500, 0x0000);
-	b43_write16(dev, 0x0502, 0x0030);
+	if (!pa_on && (phy->type == B43_PHYTYPE_N)) {
+		//SPEC TODO
+	}
+
+	switch (phy->type) {
+	case B43_PHYTYPE_N:
+		b43_write16(dev, 0x0502, 0x00D0);
+		break;
+	case B43_PHYTYPE_LP:
+		b43_write16(dev, 0x0502, 0x0050);
+		break;
+	default:
+		b43_write16(dev, 0x0502, 0x0030);
+	}
 
 	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
 		b43_radio_write16(dev, 0x0051, 0x0017);
diff --git a/drivers/net/wireless/b43/main.h b/drivers/net/wireless/b43/main.h
index 40abcf5..2d23f65 100644
--- a/drivers/net/wireless/b43/main.h
+++ b/drivers/net/wireless/b43/main.h
@@ -124,7 +124,7 @@ void __b43_shm_write16(struct b43_wldev *dev, u16 routing, u16 offset, u16 value
 u64 b43_hf_read(struct b43_wldev *dev);
 void b43_hf_write(struct b43_wldev *dev, u64 value);
 
-void b43_dummy_transmission(struct b43_wldev *dev);
+void b43_dummy_transmission(struct b43_wldev *dev, bool ofdm, bool pa_on);
 
 void b43_wireless_core_reset(struct b43_wldev *dev, u32 flags);
 
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index e7b98f0..e75a39d 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -333,7 +333,7 @@ static void b43_set_all_gains(struct b43_wldev *dev,
 		b43_phy_maskset(dev, 0x04A1, 0xBFBF, tmp);
 		b43_phy_maskset(dev, 0x04A2, 0xBFBF, tmp);
 	}
-	b43_dummy_transmission(dev);
+	b43_dummy_transmission(dev, false, true);
 }
 
 static void b43_set_original_gains(struct b43_wldev *dev)
@@ -365,7 +365,7 @@ static void b43_set_original_gains(struct b43_wldev *dev)
 	b43_phy_maskset(dev, 0x04A0, 0xBFBF, 0x4040);
 	b43_phy_maskset(dev, 0x04A1, 0xBFBF, 0x4040);
 	b43_phy_maskset(dev, 0x04A2, 0xBFBF, 0x4000);
-	b43_dummy_transmission(dev);
+	b43_dummy_transmission(dev, false, true);
 }
 
 /* http://bcm-specs.sipsolutions.net/NRSSILookupTable */
@@ -1964,7 +1964,7 @@ static void b43_phy_init_pctl(struct b43_wldev *dev)
 			}
 			b43_set_txpower_g(dev, &bbatt, &rfatt, 0);
 		}
-		b43_dummy_transmission(dev);
+		b43_dummy_transmission(dev, false, true);
 		gphy->cur_idle_tssi = b43_phy_read(dev, B43_PHY_ITSSI);
 		if (B43_DEBUG) {
 			/* Current-Idle-TSSI sanity check. */
diff --git a/drivers/net/wireless/b43/wa.c b/drivers/net/wireless/b43/wa.c
index e1e20f6..73e97fa 100644
--- a/drivers/net/wireless/b43/wa.c
+++ b/drivers/net/wireless/b43/wa.c
@@ -37,7 +37,7 @@ static void b43_wa_papd(struct b43_wldev *dev)
 	backup = b43_ofdmtab_read16(dev, B43_OFDMTAB_PWRDYN2, 0);
 	b43_ofdmtab_write16(dev, B43_OFDMTAB_PWRDYN2, 0, 7);
 	b43_ofdmtab_write16(dev, B43_OFDMTAB_UNKNOWN_APHY, 0, 0);
-	b43_dummy_transmission(dev);
+	b43_dummy_transmission(dev, true, true);
 	b43_ofdmtab_write16(dev, B43_OFDMTAB_PWRDYN2, 0, backup);
 }
 
-- 
1.6.2.4



