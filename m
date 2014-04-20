Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:56431 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbaDTLGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 07:06:13 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so2960337eei.28
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 04:06:12 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/9] b43: N-PHY: implement reading support for radio 0x2057
Date: Sun, 20 Apr 2014 13:05:46 +0200
Message-Id: <1397991951-13478-5-git-send-email-zajec5@gmail.com> (sfid-20140420_130651_560234_83D53D36)
In-Reply-To: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
References: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bit 0x200 has been noticed in the following log:
 radio_read(0x02ca) -> 0x0000
radio_write(0x00ca) <- 0x0080

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index cbeb299..3d13e73 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -5522,8 +5522,11 @@ static u16 b43_nphy_op_radio_read(struct b43_wldev *dev, u16 reg)
 {
 	/* Register 1 is a 32-bit register. */
 	B43_WARN_ON(reg == 1);
-	/* N-PHY needs 0x100 for read access */
-	reg |= 0x100;
+
+	if (dev->phy.rev >= 7)
+		reg |= 0x200; /* Radio 0x2057 */
+	else
+		reg |= 0x100;
 
 	b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
 	return b43_read16(dev, B43_MMIO_RADIO_DATA_LOW);
-- 
1.8.4.5

