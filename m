Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62826 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab0KRUK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 15:10:58 -0500
Received: by eye27 with SMTP id 27so2259732eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 12:10:57 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: N-PHY: rev2: save and restore PHY regs on RSSI poll
Date: Thu, 18 Nov 2010 21:11:42 +0100
Message-Id: <1290111103-19308-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1290111103-19308-1-git-send-email-zajec5@gmail.com>
References: <1290111103-19308-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index ff0c2b9..1354228 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1845,6 +1845,14 @@ static int b43_nphy_poll_rssi(struct b43_wldev *dev, u8 type, s32 *buf,
 		save_regs_phy[5] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER);
 		save_regs_phy[6] = b43_phy_read(dev, B43_NPHY_TXF_40CO_B1S0);
 		save_regs_phy[7] = b43_phy_read(dev, B43_NPHY_TXF_40CO_B32S1);
+	} else if (dev->phy.rev == 2) {
+		save_regs_phy[0] = b43_phy_read(dev, B43_NPHY_AFECTL_C1);
+		save_regs_phy[1] = b43_phy_read(dev, B43_NPHY_AFECTL_C2);
+		save_regs_phy[2] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER);
+		save_regs_phy[3] = b43_phy_read(dev, B43_NPHY_RFCTL_CMD);
+		save_regs_phy[4] = b43_phy_read(dev, B43_NPHY_RFCTL_OVER);
+		save_regs_phy[5] = b43_phy_read(dev, B43_NPHY_RFCTL_RSSIO1);
+		save_regs_phy[6] = b43_phy_read(dev, B43_NPHY_RFCTL_RSSIO2);
 	}
 
 	b43_nphy_rssi_select(dev, 5, type);
@@ -1888,6 +1896,14 @@ static int b43_nphy_poll_rssi(struct b43_wldev *dev, u8 type, s32 *buf,
 		b43_phy_write(dev, B43_NPHY_AFECTL_OVER, save_regs_phy[5]);
 		b43_phy_write(dev, B43_NPHY_TXF_40CO_B1S0, save_regs_phy[6]);
 		b43_phy_write(dev, B43_NPHY_TXF_40CO_B32S1, save_regs_phy[7]);
+	} else if (dev->phy.rev == 2) {
+		b43_phy_write(dev, B43_NPHY_AFECTL_C1, save_regs_phy[0]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_C2, save_regs_phy[1]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_OVER, save_regs_phy[2]);
+		b43_phy_write(dev, B43_NPHY_RFCTL_CMD, save_regs_phy[3]);
+		b43_phy_write(dev, B43_NPHY_RFCTL_OVER, save_regs_phy[4]);
+		b43_phy_write(dev, B43_NPHY_RFCTL_RSSIO1, save_regs_phy[5]);
+		b43_phy_write(dev, B43_NPHY_RFCTL_RSSIO2, save_regs_phy[6]);
 	}
 
 	return out;
-- 
1.7.1

