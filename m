Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:35025 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab0AQXVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 18:21:16 -0500
Received: by fxm25 with SMTP id 25so627454fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 15:21:13 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Mon, 18 Jan 2010 00:21:17 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 1/5 V2] b43: N-PHY: add writing one element tables
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6o9toms9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: don't write instead of reading ;/ Thanks Michael
---
  drivers/net/wireless/b43/phy_n.c |   40 ++++++++++++-------------------------
  1 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 141d4ed..16f1f9b 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -808,8 +808,7 @@ static void b43_nphy_stop_playback(struct b43_wldev *dev)

  	if (nphy->bb_mult_save & 0x80000000) {
  		tmp = nphy->bb_mult_save & 0xFFFF;
-		/* TODO: Write an N PHY Table with ID 15, length 1, offset 87,
-			width 16 and data from tmp */
+		b43_ntab_write(dev, B43_NTAB16(15, 87), tmp);
  		nphy->bb_mult_save = 0;
  	}

@@ -1486,13 +1485,11 @@ static void b43_nphy_update_tx_cal_ladder(struct b43_wldev *dev, u16 core)
  	for (i = 0; i < 18; i++) {
  		scale = (ladder_lo[i].percent * tmp) / 100;
  		entry = ((scale & 0xFF) << 8) | ladder_lo[i].g_env;
-		/* TODO: Write an N PHY Table with ID 15, length 1,
-			offset i, width 16, and data entry */
+		b43_ntab_write(dev, B43_NTAB16(15, i), entry);

  		scale = (ladder_iq[i].percent * tmp) / 100;
  		entry = ((scale & 0xFF) << 8) | ladder_iq[i].g_env;
-		/* TODO: Write an N PHY Table with ID 15, length 1,
-			offset i + 32, width 16, and data entry */
+		b43_ntab_write(dev, B43_NTAB16(15, i + 32), entry);
  	}
  }

@@ -1590,10 +1587,8 @@ static void b43_nphy_tx_cal_phy_cleanup(struct b43_wldev *dev)
  		b43_phy_write(dev, B43_NPHY_AFECTL_OVER1, regs[2]);
  		b43_phy_write(dev, B43_NPHY_AFECTL_OVER, regs[3]);
  		b43_phy_write(dev, B43_NPHY_BBCFG, regs[4]);
-		/* TODO: Write an N PHY Table with ID 8, length 1, offset 3,
-			width 16, and data from regs[5] */
-		/* TODO: Write an N PHY Table with ID 8, length 1, offset 19,
-			width 16, and data from regs[6] */
+		b43_ntab_write(dev, B43_NTAB16(8, 3), regs[5]);
+		b43_ntab_write(dev, B43_NTAB16(8, 19), regs[6]);
  		b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, regs[7]);
  		b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, regs[8]);
  		b43_phy_write(dev, B43_NPHY_PAPD_EN0, regs[9]);
@@ -1603,10 +1598,8 @@ static void b43_nphy_tx_cal_phy_cleanup(struct b43_wldev *dev)
  		b43_phy_maskset(dev, B43_NPHY_AFECTL_C1, 0x0FFF, regs[0]);
  		b43_phy_maskset(dev, B43_NPHY_AFECTL_C2, 0x0FFF, regs[1]);
  		b43_phy_write(dev, B43_NPHY_AFECTL_OVER, regs[2]);
-		/* TODO: Write an N PHY Table with ID 8, length 1, offset 2,
-			width 16, and data from regs[3] */
-		/* TODO: Write an N PHY Table with ID 8, length 1, offset 18,
-			width 16, and data from regs[4] */
+		b43_ntab_write(dev, B43_NTAB16(8, 2), regs[3]);
+		b43_ntab_write(dev, B43_NTAB16(8, 18), regs[4]);
  		b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, regs[5]);
  		b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, regs[6]);
  	}
@@ -1638,15 +1631,11 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
  		/* TODO: Read an N PHY Table with ID 8, length 1, offset 3,
  			width 16, and data pointing to tmp */
  		regs[5] = tmp;
-
-		/* TODO: Write an N PHY Table with ID 8, length 1, offset 3,
-			width 16, and data 0 */
+		b43_ntab_write(dev, B43_NTAB16(8, 3), 0);
  		/* TODO: Read an N PHY Table with ID 8, length 1, offset 19,
  			width 16, and data pointing to tmp */
  		regs[6] = tmp;
-
-		/* TODO: Write an N PHY Table with ID 8, length 1, offset 19,
-			width 16, and data 0 */
+		b43_ntab_write(dev, B43_NTAB16(8, 19), 0);
  		regs[7] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC1);
  		regs[8] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC2);

@@ -1668,14 +1657,12 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
  			width 16, and data pointing to tmp */
  		regs[3] = tmp;
  		tmp |= 0x2000;
-		/* TODO: Write an N PHY Table with ID 8, length 1, offset 2,
-			width 16, and data pointer tmp */
+		b43_ntab_write(dev, B43_NTAB16(8, 2), tmp);
  		/* TODO: Read an N PHY Table with ID 8, length 1, offset 18,
  			width 16, and data pointer tmp */
  		regs[4] = tmp;
  		tmp |= 0x2000;
-		/* TODO: Write an N PHY Table with ID 8, length 1, offset 18,
-			width 16, and data pointer tmp */
+		b43_ntab_write(dev, B43_NTAB16(8, 18), tmp);
  		regs[5] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC1);
  		regs[6] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC2);
  		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
@@ -1900,9 +1887,8 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
  					width 16, and data pointer buffer */
  				diq_start = buffer[0];
  				buffer[0] = 0;
-				/* TODO: Write an N PHY Table with ID 15,
-					length 1, offset 69 + core, width 16,
-					and data of 0 */
+				b43_ntab_write(dev, B43_NTAB16(15, 69 + core),
+						0);
  			}

  			b43_phy_write(dev, B43_NPHY_IQLOCAL_CMD, cmd);
-- 
1.6.4.2

