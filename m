Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52584 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab0LGImw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 03:42:52 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so12976195wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 00:42:51 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/4] b43: N-PHY: implement own maskset
Date: Tue,  7 Dec 2010 09:42:06 +0100
Message-Id: <1291711327-4690-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1291711327-4690-1-git-send-email-zajec5@gmail.com>
References: <1291711327-4690-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This let us avoid double addressing while still having reg check.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 905f1d7..f78f4e9 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3705,6 +3705,15 @@ static void b43_nphy_op_write(struct b43_wldev *dev, u16 reg, u16 value)
 	b43_write16(dev, B43_MMIO_PHY_DATA, value);
 }
 
+static void b43_nphy_op_maskset(struct b43_wldev *dev, u16 reg, u16 mask,
+				 u16 set)
+{
+	check_phyreg(dev, reg);
+	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16(dev, B43_MMIO_PHY_DATA,
+		    (b43_read16(dev, B43_MMIO_PHY_DATA) & mask) | set);
+}
+
 static u16 b43_nphy_op_radio_read(struct b43_wldev *dev, u16 reg)
 {
 	/* Register 1 is a 32-bit register. */
@@ -3799,6 +3808,7 @@ const struct b43_phy_operations b43_phyops_n = {
 	.init			= b43_nphy_op_init,
 	.phy_read		= b43_nphy_op_read,
 	.phy_write		= b43_nphy_op_write,
+	.phy_maskset		= b43_nphy_op_maskset,
 	.radio_read		= b43_nphy_op_radio_read,
 	.radio_write		= b43_nphy_op_radio_write,
 	.software_rfkill	= b43_nphy_op_software_rfkill,
-- 
1.6.3.3

