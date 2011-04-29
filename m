Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49973 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933658Ab1D2TBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 15:01:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: avoid uninitialized variable warnings in phy_n
Date: Fri, 29 Apr 2011 14:59:19 -0400
Message-Id: <1304103559-28415-1-git-send-email-linville@tuxdriver.com> (sfid-20110429_210125_903967_8F65C8DB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/b43/phy_n.o
drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_set_channel’:
drivers/net/wireless/b43/phy_n.c:3848:47: warning: ‘tabent_r2’ may be used uninitialized in this function
drivers/net/wireless/b43/phy_n.c:3849:47: warning: ‘tabent_r3’ may be used uninitialized in this function
drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_poll_rssi.clone.14’:
drivers/net/wireless/b43/phy_n.c:2270:6: warning: ‘save_regs_phy$7’ may be used uninitialized in this function
drivers/net/wireless/b43/phy_n.c:2270:6: warning: ‘save_regs_phy$8’ may be used uninitialized in this function

FWIW, the usage of these variables is goverened by checks that match
their initializations.  So, I think these are actually false warnings.
Still, I would rather avoid the warning SPAM...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43/phy_n.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 8a00f9a..6755063 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2281,6 +2281,7 @@ static int b43_nphy_poll_rssi(struct b43_wldev *dev, u8 type, s32 *buf,
 		save_regs_phy[5] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER);
 		save_regs_phy[6] = b43_phy_read(dev, B43_NPHY_TXF_40CO_B1S0);
 		save_regs_phy[7] = b43_phy_read(dev, B43_NPHY_TXF_40CO_B32S1);
+		save_regs_phy[8] = 0;
 	} else {
 		save_regs_phy[0] = b43_phy_read(dev, B43_NPHY_AFECTL_C1);
 		save_regs_phy[1] = b43_phy_read(dev, B43_NPHY_AFECTL_C2);
@@ -2289,6 +2290,8 @@ static int b43_nphy_poll_rssi(struct b43_wldev *dev, u8 type, s32 *buf,
 		save_regs_phy[4] = b43_phy_read(dev, B43_NPHY_RFCTL_OVER);
 		save_regs_phy[5] = b43_phy_read(dev, B43_NPHY_RFCTL_RSSIO1);
 		save_regs_phy[6] = b43_phy_read(dev, B43_NPHY_RFCTL_RSSIO2);
+		save_regs_phy[7] = 0;
+		save_regs_phy[8] = 0;
 	}
 
 	b43_nphy_rssi_select(dev, 5, type);
@@ -3845,8 +3848,8 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 {
 	struct b43_phy *phy = &dev->phy;
 
-	const struct b43_nphy_channeltab_entry_rev2 *tabent_r2;
-	const struct b43_nphy_channeltab_entry_rev3 *tabent_r3;
+	const struct b43_nphy_channeltab_entry_rev2 *tabent_r2 = NULL;
+	const struct b43_nphy_channeltab_entry_rev3 *tabent_r3 = NULL;
 
 	u8 tmp;
 
-- 
1.7.4.4

