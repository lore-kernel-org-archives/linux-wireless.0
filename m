Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62654 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761Ab0ANWm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 17:42:57 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so56513fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 14:42:56 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 14 Jan 2010 23:42:55 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 2/6] b43: N-PHY: add TX cal radio setup for rev < 3
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6jn1tvl9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   43 ++++++++++++++++++++++++++++++++++++++
  drivers/net/wireless/b43/phy_n.h |    1 +
  2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 75eb0e6..77be96d 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -901,6 +901,49 @@ static void b43_nphy_tx_lp_fbw(struct b43_wldev *dev)
  	}
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalRadioSetup */
+static void b43_nphy_tx_cal_radio_setup(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	u16 *save = nphy->tx_rx_cal_radio_saveregs;
+
+	if (dev->phy.rev >= 3) {
+		/* TODO */
+	} else {
+		save[0] = b43_radio_read16(dev, B2055_C1_TX_RF_IQCAL1);
+		b43_radio_write16(dev, B2055_C1_TX_RF_IQCAL1, 0x29);
+
+		save[1] = b43_radio_read16(dev, B2055_C1_TX_RF_IQCAL2);
+		b43_radio_write16(dev, B2055_C1_TX_RF_IQCAL2, 0x54);
+
+		save[2] = b43_radio_read16(dev, B2055_C2_TX_RF_IQCAL1);
+		b43_radio_write16(dev, B2055_C2_TX_RF_IQCAL1, 0x29);
+
+		save[3] = b43_radio_read16(dev, B2055_C2_TX_RF_IQCAL2);
+		b43_radio_write16(dev, B2055_C2_TX_RF_IQCAL2, 0x54);
+
+		save[3] = b43_radio_read16(dev, B2055_C1_PWRDET_RXTX);
+		save[4] = b43_radio_read16(dev, B2055_C2_PWRDET_RXTX);
+
+		if (!(b43_phy_read(dev, B43_NPHY_BANDCTL) &
+		    B43_NPHY_BANDCTL_5GHZ)) {
+			b43_radio_write16(dev, B2055_C1_PWRDET_RXTX, 0x04);
+			b43_radio_write16(dev, B2055_C2_PWRDET_RXTX, 0x04);
+		} else {
+			b43_radio_write16(dev, B2055_C1_PWRDET_RXTX, 0x20);
+			b43_radio_write16(dev, B2055_C2_PWRDET_RXTX, 0x20);
+		}
+
+		if (dev->phy.rev < 2) {
+			b43_radio_set(dev, B2055_C1_TX_BB_MXGM, 0x20);
+			b43_radio_set(dev, B2055_C2_TX_BB_MXGM, 0x20);
+		} else {
+			b43_radio_mask(dev, B2055_C1_TX_BB_MXGM, ~0x20);
+			b43_radio_mask(dev, B2055_C2_TX_BB_MXGM, ~0x20);
+		}
+	}
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GetTxGain */
  static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
  {
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index ab54b0f..d435720 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -971,6 +971,7 @@ struct b43_phy_n {
  	u8 perical;
  	u8 mphase_cal_phase_id;
  	u8 antsel_type;
+	u16 tx_rx_cal_radio_saveregs[22];
  	u16 papd_epsilon_offset[2];
  	u32 deaf_count;
  	u32 rxcalparams;
-- 
1.6.4.2

