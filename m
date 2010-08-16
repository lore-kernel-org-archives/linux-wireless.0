Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41041 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab0HPUjY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 16:39:24 -0400
Received: by mail-fx0-f46.google.com with SMTP id 13so3130309fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Aug 2010 13:39:23 -0700 (PDT)
From: =?UTF-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
To: John Linville <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Larry Finger <larry.finger@lwfinger.net>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	=?UTF-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
Subject: [PATCH 4/4] b43: N-PHY: Implement RX core state setting for rev.2 and earlier PHYs
Date: Mon, 16 Aug 2010 22:39:17 +0200
Message-Id: <1281991157-1557-4-git-send-email-netrolller.3d@gmail.com>
In-Reply-To: <1281991157-1557-3-git-send-email-netrolller.3d@gmail.com>
References: <1281991157-1557-1-git-send-email-netrolller.3d@gmail.com>
 <1281991157-1557-2-git-send-email-netrolller.3d@gmail.com>
 <1281991157-1557-3-git-send-email-netrolller.3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rev.3+ support coming in a later patch.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   40 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d2dab55..92cf8b8 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3085,6 +3085,44 @@ static void b43_nphy_mac_phy_clock_set(struct b43_wldev *dev, bool on)
 	ssb_write32(dev->dev, SSB_TMSLOW, tmslow);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxCoreSetState */
+static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = phy->n;
+	u16 buf[16];
+
+	if (0 /* FIXME clk */)
+		return;
+
+	b43_mac_suspend(dev);
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, true);
+
+	b43_phy_maskset(dev, B43_NPHY_RFSEQCA, ~B43_NPHY_RFSEQCA_RXEN,
+			(mask & 0x3) << B43_NPHY_RFSEQCA_RXEN_SHIFT);
+
+	if (maskbits & 0x3 != 0x3) {
+		b43_phy_write(dev, B43_NPHY_HPANT_SWTHRES, 1);
+		if (dev->phy.rev >= 3) {
+			/* TODO */
+		}
+	} else {
+		b43_phy_write(dev, B43_NPHY_HPANT_SWTHRES, 0x1E);
+		if (dev->phy.rev >= 3) {
+			/* TODO */
+		}
+	}
+
+	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, false);
+
+	b43_mac_enable(dev);
+}
+
 /*
  * Init N-PHY
  * http://bcm-v4.sipsolutions.net/802.11/PHY/Init/N
@@ -3211,7 +3249,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	}
 
 	if (nphy->phyrxchain != 3)
-		;/* TODO N PHY RX Core Set State with phyrxchain as argument */
+		b43_nphy_set_rx_core_state(dev, nphy->phyrxchain);
 	if (nphy->mphase_cal_phase_id > 0)
 		;/* TODO PHY Periodic Calibration Multi-Phase Restart */
 
-- 
1.6.4.2

