Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:61791 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688AbXDCWIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2007 18:08:43 -0400
Received: from aamtaout01-winn.ispmail.ntl.com ([81.103.221.35])
          by mtaout01-winn.ispmail.ntl.com with ESMTP
          id <20070403220841.LCOS2951.mtaout01-winn.ispmail.ntl.com@aamtaout01-winn.ispmail.ntl.com>
          for <linux-wireless@vger.kernel.org>;
          Tue, 3 Apr 2007 23:08:41 +0100
Received: from zog.reactivated.net ([86.14.211.88])
          by aamtaout01-winn.ispmail.ntl.com with ESMTP
          id <20070403220841.IZEA219.aamtaout01-winn.ispmail.ntl.com@zog.reactivated.net>
          for <linux-wireless@vger.kernel.org>;
          Tue, 3 Apr 2007 23:08:41 +0100
From: Daniel Drake <dsd@gentoo.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] zd1211rw-mac80211: Fix E2P_PHY_REG patching
Message-Id: <20070403220848.0C9557B409F@zog.reactivated.net>
Date: Tue,  3 Apr 2007 23:08:47 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to conflicting/confusing defines in the vendor driver, we were
reading E2P_PHY_REG from the wrong location.

CR157 patching was slightly incorrect in that the vendor driver only
patches in an 8-bit value, whereas we were patching 24 bits.

Additionally, CR157 patching was happening on both zd1211 and zd1211b,
but this should only happen on zd1211.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_chip.c |   11 +++--------
 drivers/net/wireless/mac80211/zd1211rw/zd_chip.h |    2 +-
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
index 53bbd34..3b1cd65 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.c
@@ -593,16 +593,16 @@ int zd_chip_unlock_phy_regs(struct zd_chip *chip)
 	return r;
 }
 
-/* CR157 can be optionally patched by the EEPROM */
+/* CR157 can be optionally patched by the EEPROM for original ZD1211 */
 static int patch_cr157(struct zd_chip *chip)
 {
 	int r;
-	u32 value;
+	u16 value;
 
 	if (!chip->patch_cr157)
 		return 0;
 
-	r = zd_ioread32_locked(chip, &value, E2P_PHY_REG);
+	r = zd_ioread16_locked(chip, &value, E2P_PHY_REG);
 	if (r)
 		return r;
 
@@ -792,11 +792,6 @@ static int zd1211b_hw_reset_phy(struct zd_chip *chip)
 		goto out;
 
 	r = zd_iowrite16a_locked(chip, ioreqs, ARRAY_SIZE(ioreqs));
-	if (r)
-		goto unlock;
-
-	r = patch_cr157(chip);
-unlock:
 	t = zd_chip_unlock_phy_regs(chip);
 	if (t && !r)
 		r = t;
diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
index 446fe9f..0a8f0e5 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_chip.h
@@ -636,8 +636,8 @@ enum {
  * also only 11 channels. */
 #define E2P_ALLOWED_CHANNEL	E2P_DATA(0x18)
 
-#define E2P_PHY_REG		E2P_DATA(0x1a)
 #define E2P_DEVICE_VER		E2P_DATA(0x20)
+#define E2P_PHY_REG		E2P_DATA(0x25)
 #define E2P_36M_CAL_VALUE1	E2P_DATA(0x28)
 #define E2P_36M_CAL_VALUE2      E2P_DATA(0x2a)
 #define E2P_36M_CAL_VALUE3      E2P_DATA(0x2c)
-- 
1.5.0.6

