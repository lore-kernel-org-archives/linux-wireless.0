Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33059 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083Ab2GYOOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 10:14:30 -0400
Received: by wgbfm10 with SMTP id fm10so4536494wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 07:14:28 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: rename host flags defines
Date: Wed, 25 Jul 2012 16:58:38 +0200
Message-Id: <1343228318-15445-1-git-send-email-zajec5@gmail.com> (sfid-20120725_161434_560330_C97270BF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are more than 3 registers on new hardware. Host flags handling has
to be rewritten, as we can't use u128 type to handle all 5 regs.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h        |    8 +++++---
 drivers/net/wireless/b43/main.c       |   12 ++++++------
 drivers/net/wireless/b43/phy_common.c |    2 +-
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index b0c7f47..b298e5d 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -241,16 +241,18 @@ enum {
 #define B43_SHM_SH_PHYVER		0x0050	/* PHY version */
 #define B43_SHM_SH_PHYTYPE		0x0052	/* PHY type */
 #define B43_SHM_SH_ANTSWAP		0x005C	/* Antenna swap threshold */
-#define B43_SHM_SH_HOSTFLO		0x005E	/* Hostflags for ucode options (low) */
-#define B43_SHM_SH_HOSTFMI		0x0060	/* Hostflags for ucode options (middle) */
-#define B43_SHM_SH_HOSTFHI		0x0062	/* Hostflags for ucode options (high) */
+#define B43_SHM_SH_HOSTF1		0x005E	/* Hostflags 1 for ucode options */
+#define B43_SHM_SH_HOSTF2		0x0060	/* Hostflags 2 for ucode options */
+#define B43_SHM_SH_HOSTF3		0x0062	/* Hostflags 3 for ucode options */
 #define B43_SHM_SH_RFATT		0x0064	/* Current radio attenuation value */
 #define B43_SHM_SH_RADAR		0x0066	/* Radar register */
 #define B43_SHM_SH_PHYTXNOI		0x006E	/* PHY noise directly after TX (lower 8bit only) */
 #define B43_SHM_SH_RFRXSP1		0x0072	/* RF RX SP Register 1 */
+#define B43_SHM_SH_HOSTF4		0x0078	/* Hostflags 4 for ucode options */
 #define B43_SHM_SH_CHAN			0x00A0	/* Current channel (low 8bit only) */
 #define  B43_SHM_SH_CHAN_5GHZ		0x0100	/* Bit set, if 5 Ghz channel */
 #define  B43_SHM_SH_CHAN_40MHZ		0x0200	/* Bit set, if 40 Mhz channel width */
+#define B43_SHM_SH_HOSTF5		0x00D4	/* Hostflags 5 for ucode options */
 #define B43_SHM_SH_BCMCFIFOID		0x0108	/* Last posted cookie to the bcast/mcast FIFO */
 /* TSSI information */
 #define B43_SHM_SH_TSSI_CCK		0x0058	/* TSSI for last 4 CCK frames (32bit) */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 9b0ce6b..977ac5b 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -533,11 +533,11 @@ u64 b43_hf_read(struct b43_wldev *dev)
 {
 	u64 ret;
 
-	ret = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFHI);
+	ret = b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTF3);
 	ret <<= 16;
-	ret |= b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFMI);
+	ret |= b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTF2);
 	ret <<= 16;
-	ret |= b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFLO);
+	ret |= b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTF1);
 
 	return ret;
 }
@@ -550,9 +550,9 @@ void b43_hf_write(struct b43_wldev *dev, u64 value)
 	lo = (value & 0x00000000FFFFULL);
 	mi = (value & 0x0000FFFF0000ULL) >> 16;
 	hi = (value & 0xFFFF00000000ULL) >> 32;
-	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFLO, lo);
-	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFMI, mi);
-	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFHI, hi);
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTF1, lo);
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTF2, mi);
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTF3, hi);
 }
 
 /* Read the firmware capabilities bitmask (Opensource firmware only) */
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 3f8883b..f627cef 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -428,7 +428,7 @@ int b43_phy_shm_tssi_read(struct b43_wldev *dev, u16 shm_offset)
 	average = (a + b + c + d + 2) / 4;
 	if (is_ofdm) {
 		/* Adjust for CCK-boost */
-		if (b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFLO)
+		if (b43_shm_read16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTF1)
 		    & B43_HF_CCKBOOST)
 			average = (average >= 13) ? (average - 13) : 0;
 	}
-- 
1.7.7

