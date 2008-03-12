Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:34975 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYCLQwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 12:52:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: phy.c fix typo in register write
Date: Wed, 12 Mar 2008 17:51:04 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Harvey Harrison <harvey.harrison@gmail.com>
MIME-Version: 1.0
Message-Id: <200803121751.04560.mb@bu3sch.de> (sfid-20080312_165230_360936_88DDB000)
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

Commit 61bca6eb85c863603d6054530e2f65c3b9aba85b b43: rewrite A PHY initialization
has a typo, the result of the register read should be masked, not the
register offset.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Can be applied for 2.6.25, although this is A-PHY only.


 drivers/net/wireless/b43/phy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy.c b/drivers/net/wireless/b43/phy.c
index 71507b2..575c543 100644
--- a/drivers/net/wireless/b43/phy.c
+++ b/drivers/net/wireless/b43/phy.c
@@ -860,7 +860,7 @@ static void b43_phy_ww(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_PHY_OFDM(0xBB),
 		(b43_phy_read(dev, B43_PHY_OFDM(0xBB)) & 0xF000) | 0x0053);
 	b43_phy_write(dev, B43_PHY_OFDM61,
-		(b43_phy_read(dev, B43_PHY_OFDM61 & 0xFE1F)) | 0x0120);
+		(b43_phy_read(dev, B43_PHY_OFDM61) & 0xFE1F) | 0x0120);
 	b43_phy_write(dev, B43_PHY_OFDM(0x13),
 		(b43_phy_read(dev, B43_PHY_OFDM(0x13)) & 0x0FFF) | 0x3000);
 	b43_phy_write(dev, B43_PHY_OFDM(0x14),
-- 
1.5.4.4.592.g32d4c





-------------------------------------------------------

-- 
Greetings Michael.
