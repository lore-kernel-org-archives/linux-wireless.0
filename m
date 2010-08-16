Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41041 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab0HPUjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 16:39:22 -0400
Received: by mail-fx0-f46.google.com with SMTP id 13so3130309fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Aug 2010 13:39:21 -0700 (PDT)
From: =?UTF-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
To: John Linville <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Larry Finger <larry.finger@lwfinger.net>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	=?UTF-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
Subject: [PATCH 3/4] b43: N-PHY: Implement MAC PHY clock set
Date: Mon, 16 Aug 2010 22:39:16 +0200
Message-Id: <1281991157-1557-3-git-send-email-netrolller.3d@gmail.com>
In-Reply-To: <1281991157-1557-2-git-send-email-netrolller.3d@gmail.com>
References: <1281991157-1557-1-git-send-email-netrolller.3d@gmail.com>
 <1281991157-1557-2-git-send-email-netrolller.3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>

---
 drivers/net/wireless/b43/phy_n.c |   13 ++++++++++++-
 include/linux/ssb/ssb_regs.h     |    1 +
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index f1b5707..d2dab55 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3074,6 +3074,17 @@ static int b43_nphy_cal_rx_iq(struct b43_wldev *dev,
 		return b43_nphy_rev2_cal_rx_iq(dev, target, type, debug);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/MacPhyClkSet */
+static void b43_nphy_mac_phy_clock_set(struct b43_wldev *dev, bool on)
+{
+	u32 tmslow = ssb_read32(dev->dev, SSB_TMSLOW);
+	if (on)
+		tmslow |= SSB_TMSLOW_PHYCLK;
+	else
+		tmslow &= ~SSB_TMSLOW_PHYCLK;
+	ssb_write32(dev->dev, SSB_TMSLOW, tmslow);
+}
+
 /*
  * Init N-PHY
  * http://bcm-v4.sipsolutions.net/802.11/PHY/Init/N
@@ -3174,7 +3185,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_BBCFG, tmp & ~B43_NPHY_BBCFG_RSTCCA);
 	b43_nphy_bmac_clock_fgc(dev, 0);
 
-	/* TODO N PHY MAC PHY Clock Set with argument 1 */
+	b43_nphy_mac_phy_clock_set(dev, true);
 
 	b43_nphy_pa_override(dev, false);
 	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RX2TX);
diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index a6d5225..b2d4bed 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -97,6 +97,7 @@
 #define  SSB_TMSLOW_RESET	0x00000001 /* Reset */
 #define  SSB_TMSLOW_REJECT_22	0x00000002 /* Reject (Backplane rev 2.2) */
 #define  SSB_TMSLOW_REJECT_23	0x00000004 /* Reject (Backplane rev 2.3) */
+#define  SSB_TMSLOW_PHYCLK	0x00000010 /* MAC PHY Clock Control Enable */
 #define  SSB_TMSLOW_CLOCK	0x00010000 /* Clock Enable */
 #define  SSB_TMSLOW_FGC		0x00020000 /* Force Gated Clocks On */
 #define  SSB_TMSLOW_PE		0x40000000 /* Power Management Enable */
-- 
1.6.4.2

