Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37494 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab0AINAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jan 2010 08:00:10 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so13340575fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jan 2010 05:00:09 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sat, 09 Jan 2010 14:01:37 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 4/4] b43: N-PHY: some comments, function definion fix, missing
 calls
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u59nszh39lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   19 ++++++++++++++-----
  1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 6452cb3..c2c2602 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -315,7 +315,7 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
  }

  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/BmacPhyClkFgc */
-void b43_nphy_bmac_clock_fgc(struct b43_wldev *dev, bool force)
+static void b43_nphy_bmac_clock_fgc(struct b43_wldev *dev, bool force)
  {
  	u32 tmslow;

@@ -454,6 +454,7 @@ static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev, bool enable)
  	}
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GetTxGain */
  static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
  {
  	struct b43_phy_n *nphy = dev->phy.n;
@@ -589,17 +590,22 @@ static void b43_nphy_bphy_init(struct b43_wldev *dev)
  	b43_phy_write(dev, B43_PHY_N_BMODE(0x38), 0x668);
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal */
  static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
  {
  	//TODO
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICalRev3 */
  static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
  {
  	//TODO
  }

-/* RSSI Calibration */
+/*
+ * RSSI Calibration
+ * http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal
+ */
  static void b43_nphy_rssi_cal(struct b43_wldev *dev)
  {
  	if (dev->phy.rev >= 3) {
@@ -611,7 +617,10 @@ static void b43_nphy_rssi_cal(struct b43_wldev *dev)
  	}
  }

-/* Restore RSSI Calibration */
+/*
+ * Restore RSSI Calibration
+ * http://bcm-v4.sipsolutions.net/802.11/PHY/N/RestoreRssiCal
+ */
  static void b43_nphy_restore_rssi_cal(struct b43_wldev *dev)
  {
  	//TODO
@@ -720,8 +729,8 @@ int b43_phy_initn(struct b43_wldev *dev)
  	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
  	b43_nphy_pa_override(dev, true);

-	//TODO N PHY Classifier with arguments 0 and 0
-	//TODO N PHY Det Clip with 0 and the clip array as arguments
+	b43_nphy_classifier(dev, 0, 0);
+	b43_nphy_read_clip_detection(dev, clip);
  	tx_pwr_state = nphy->txpwrctrl;
  	//TODO N PHY TX power control with argument 0 (turning off power control)
  	//TODO Fix the TX Power Settings
-- 
1.6.4.2

