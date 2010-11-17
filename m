Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41342 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab0KQVOq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 16:14:46 -0500
Received: by wyb28 with SMTP id 28so2427330wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 13:14:45 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] b43: rfkill: use HI enabled bit for all devices
Date: Wed, 17 Nov 2010 22:14:37 +0100
Message-Id: <1290028477-6462-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Devices which use LO enabled bit are covered by b43legacy

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Dropped some not needed stuff as pointed by Michael, thanks!

John: it's .38 ofc.
---
 drivers/net/wireless/b43/rfkill.c |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
index 78016ae..86bc0a0 100644
--- a/drivers/net/wireless/b43/rfkill.c
+++ b/drivers/net/wireless/b43/rfkill.c
@@ -28,23 +28,8 @@
 /* Returns TRUE, if the radio is enabled in hardware. */
 bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
 {
-	if (dev->phy.rev >= 3 || dev->phy.type == B43_PHYTYPE_LP) {
-		if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
-		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
-			return 1;
-	} else {
-		/* To prevent CPU fault on PPC, do not read a register
-		 * unless the interface is started; however, on resume
-		 * for hibernation, this routine is entered early. When
-		 * that happens, unconditionally return TRUE.
-		 */
-		if (b43_status(dev) < B43_STAT_STARTED)
-			return 1;
-		if (b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
-		    & B43_MMIO_RADIO_HWENABLED_LO_MASK)
-			return 1;
-	}
-	return 0;
+	return !(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
+		& B43_MMIO_RADIO_HWENABLED_HI_MASK);
 }
 
 /* The poll callback for the hardware button. */
-- 
1.6.0.4

