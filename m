Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:57317 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZHZVpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 17:45:11 -0400
Received: by bwz22 with SMTP id 22so500458bwz.18
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 14:45:12 -0700 (PDT)
From: =?utf-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] b43: LP-PHY: Revert to the original PHY register write routine
Date: Wed, 26 Aug 2009 23:45:10 +0200
Message-Id: <1251323110-7151-1-git-send-email-netrolller.3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After some discussion on IRC about the PHY register write change,
I am not sure anymore if this is the right thing to do.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
v2: No more "From: root".

 drivers/net/wireless/b43/phy_lp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 80f245c..a57c40d 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -1496,7 +1496,8 @@ static u16 b43_lpphy_op_read(struct b43_wldev *dev, u16 reg)
 
 static void b43_lpphy_op_write(struct b43_wldev *dev, u16 reg, u16 value)
 {
-	b43_write32(dev, B43_MMIO_PHY_CONTROL, ((u32)value << 16) | reg);
+	b43_write32(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write32(dev, B43_MMIO_PHY_DATA, value);
 }
 
 static void b43_lpphy_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
-- 
1.5.6

