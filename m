Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36520 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab2ACVIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 16:08:11 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so16211505eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2012 13:08:10 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/5] b43: N-PHY: trivial: change save&rest order in RSSI polling
Date: Tue,  3 Jan 2012 22:49:21 +0100
Message-Id: <1325627361-3394-5-git-send-email-zajec5@gmail.com> (sfid-20120103_220817_811332_0FAEEE99)
In-Reply-To: <1325627361-3394-1-git-send-email-zajec5@gmail.com>
References: <1325627361-3394-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d794ad9..b779396 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1220,12 +1220,12 @@ static int b43_nphy_poll_rssi(struct b43_wldev *dev, u8 type, s32 *buf,
 	u16 s[2];
 
 	if (dev->phy.rev >= 3) {
-		save_regs_phy[0] = b43_phy_read(dev,
+		save_regs_phy[0] = b43_phy_read(dev, B43_NPHY_AFECTL_C1);
+		save_regs_phy[1] = b43_phy_read(dev, B43_NPHY_AFECTL_C2);
+		save_regs_phy[2] = b43_phy_read(dev,
 						B43_NPHY_RFCTL_LUT_TRSW_UP1);
-		save_regs_phy[1] = b43_phy_read(dev,
+		save_regs_phy[3] = b43_phy_read(dev,
 						B43_NPHY_RFCTL_LUT_TRSW_UP2);
-		save_regs_phy[2] = b43_phy_read(dev, B43_NPHY_AFECTL_C1);
-		save_regs_phy[3] = b43_phy_read(dev, B43_NPHY_AFECTL_C2);
 		save_regs_phy[4] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER1);
 		save_regs_phy[5] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER);
 		save_regs_phy[6] = b43_phy_read(dev, B43_NPHY_TXF_40CO_B1S0);
@@ -1274,12 +1274,12 @@ static int b43_nphy_poll_rssi(struct b43_wldev *dev, u8 type, s32 *buf,
 		b43_phy_write(dev, B43_NPHY_GPIO_SEL, save_regs_phy[8]);
 
 	if (dev->phy.rev >= 3) {
+		b43_phy_write(dev, B43_NPHY_AFECTL_C1, save_regs_phy[0]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_C2, save_regs_phy[1]);
 		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP1,
-				save_regs_phy[0]);
+				save_regs_phy[2]);
 		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2,
-				save_regs_phy[1]);
-		b43_phy_write(dev, B43_NPHY_AFECTL_C1, save_regs_phy[2]);
-		b43_phy_write(dev, B43_NPHY_AFECTL_C2, save_regs_phy[3]);
+				save_regs_phy[3]);
 		b43_phy_write(dev, B43_NPHY_AFECTL_OVER1, save_regs_phy[4]);
 		b43_phy_write(dev, B43_NPHY_AFECTL_OVER, save_regs_phy[5]);
 		b43_phy_write(dev, B43_NPHY_TXF_40CO_B1S0, save_regs_phy[6]);
-- 
1.7.3.4

