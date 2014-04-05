Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:39097 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaDEOfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2014 10:35:39 -0400
Received: by mail-we0-f176.google.com with SMTP id x48so4566598wes.7
        for <linux-wireless@vger.kernel.org>; Sat, 05 Apr 2014 07:35:38 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH][FIX 3.15] b43: N-PHY: access B43_MMIO_PSM_PHY_HDR using 16b ops
Date: Sat,  5 Apr 2014 16:35:24 +0200
Message-Id: <1396708524-12199-1-git-send-email-zajec5@gmail.com> (sfid-20140405_163559_966834_E71BAD8D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Register B43_MMIO_PSM_PHY_HDR is 16 bit one, so accessing it with 32b
functions isn't safe. On my machine it causes delayed (!) CPU exception:

Disabling lock debugging due to kernel taint
mce: [Hardware Error]: CPU 0: Machine Check Exception: 4 Bank 4: b200000000070f0f
mce: [Hardware Error]: TSC 164083803dc
mce: [Hardware Error]: PROCESSOR 2:20fc2 TIME 1396650505 SOCKET 0 APIC 0 microcode 0
mce: [Hardware Error]: Run the above through 'mcelog --ascii'
mce: [Hardware Error]: Machine check: Processor context corrupt
Kernel panic - not syncing: Fatal machine check on current CPU
Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: I think this patch it worth picking for 3.15 release. This bug
causes instability and can be triggered depending on the default state
of B43_NPHY_BANDCTL register.
It doesn't cause exception immediately, so I spent few hours tracing it.
---
 drivers/net/wireless/b43/phy_n.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 05ee7f1..24ccbe9 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -5176,22 +5176,22 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 	int ch = new_channel->hw_value;
 
 	u16 old_band_5ghz;
-	u32 tmp32;
+	u16 tmp16;
 
 	old_band_5ghz =
 		b43_phy_read(dev, B43_NPHY_BANDCTL) & B43_NPHY_BANDCTL_5GHZ;
 	if (new_channel->band == IEEE80211_BAND_5GHZ && !old_band_5ghz) {
-		tmp32 = b43_read32(dev, B43_MMIO_PSM_PHY_HDR);
-		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32 | 4);
+		tmp16 = b43_read16(dev, B43_MMIO_PSM_PHY_HDR);
+		b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp16 | 4);
 		b43_phy_set(dev, B43_PHY_B_BBCFG, 0xC000);
-		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32);
+		b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp16);
 		b43_phy_set(dev, B43_NPHY_BANDCTL, B43_NPHY_BANDCTL_5GHZ);
 	} else if (new_channel->band == IEEE80211_BAND_2GHZ && old_band_5ghz) {
 		b43_phy_mask(dev, B43_NPHY_BANDCTL, ~B43_NPHY_BANDCTL_5GHZ);
-		tmp32 = b43_read32(dev, B43_MMIO_PSM_PHY_HDR);
-		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32 | 4);
+		tmp16 = b43_read16(dev, B43_MMIO_PSM_PHY_HDR);
+		b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp16 | 4);
 		b43_phy_mask(dev, B43_PHY_B_BBCFG, 0x3FFF);
-		b43_write32(dev, B43_MMIO_PSM_PHY_HDR, tmp32);
+		b43_write16(dev, B43_MMIO_PSM_PHY_HDR, tmp16);
 	}
 
 	b43_chantab_phy_upload(dev, e);
-- 
1.8.4.5

