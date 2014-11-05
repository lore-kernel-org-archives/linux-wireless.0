Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:51362 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbaKEWbT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 17:31:19 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	andrey.krieger.utkin@gmail.com, v.kempter@pe.tu-clausthal.de,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3.18+] b43: fix NULL pointer dereference in b43_phy_copy()
Date: Wed,  5 Nov 2014 23:31:07 +0100
Message-Id: <1415226667-28207-1-git-send-email-hauke@hauke-m.de> (sfid-20141105_233122_394191_59EB1DFE)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

phy_read and phy_write are not set for every phy any more sine this:
commit d342b95dd735014a590f9051b1ba227eb54ca8f6
Author: Rafał Miłecki <zajec5@gmail.com>
Date:   Thu Jul 31 21:59:43 2014 +0200

    b43: don't duplicate common PHY read/write ops

b43_phy_copy() accesses phy_read and phy_write directly and will fail
with some phys. This patch fixes the regression by using the
b43_phy_read() and b43_phy_write() functions which should be used for
read and write access.

This should fix this bug report:
https://bugzilla.kernel.org/show_bug.cgi?id=87731

Reported-by: Volker Kempter <v.kempter@pe.tu-clausthal.de>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/phy_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

This should go into wireless-testing and into 3.18 as it fixes a 
regression in 3.18.

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 1dfc682..3f37401 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -301,8 +301,7 @@ void b43_phy_write(struct b43_wldev *dev, u16 reg, u16 value)
 void b43_phy_copy(struct b43_wldev *dev, u16 destreg, u16 srcreg)
 {
 	assert_mac_suspended(dev);
-	dev->phy.ops->phy_write(dev, destreg,
-		dev->phy.ops->phy_read(dev, srcreg));
+	b43_phy_write(dev, destreg, b43_phy_read(dev, srcreg));
 }
 
 void b43_phy_mask(struct b43_wldev *dev, u16 offset, u16 mask)
-- 
1.9.1

