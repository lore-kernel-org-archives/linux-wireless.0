Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:39669 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0AJWMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 17:12:25 -0500
Received: by mail-ew0-f214.google.com with SMTP id 6so21225297ewy.29
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jan 2010 14:12:24 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sun, 10 Jan 2010 23:13:54 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 5/6] b43: N-PHY: add calibration restore
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6b71gdb9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com
---
  drivers/net/wireless/b43/phy_n.c |   70 +++++++++++++++++++++++++++++++++++++-
  drivers/net/wireless/b43/phy_n.h |   11 ++++++
  2 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 22e7432..577c626 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1073,6 +1073,74 @@ static void b43_nphy_restore_rssi_cal(struct b43_wldev *dev)
  	b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_Y, rssical_phy_regs[11]);
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RestoreCal */
+static void b43_nphy_restore_cal(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	u16 coef[4];
+	u16 *loft = NULL;
+	u16 *table = NULL;
+
+	int i;
+	u16 *txcal_radio_regs = NULL;
+	struct b43_phy_n_iq_comp *rxcal_coeffs = NULL;
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (nphy->iqcal_chanspec_2G == 0)
+			return;
+		table = nphy->cal_cache.txcal_coeffs_2G;
+		loft = &nphy->cal_cache.txcal_coeffs_2G[5];
+	} else {
+		if (nphy->iqcal_chanspec_5G == 0)
+			return;
+		table = nphy->cal_cache.txcal_coeffs_5G;
+		loft = &nphy->cal_cache.txcal_coeffs_5G[5];
+	}
+
+	//TODO: Write an N PHY table with ID 15, length 4, offset 80, width 16, and data from table
+
+	for (i = 0; i < 4; i++) {
+		if (dev->phy.rev >= 3)
+			table[i] = coef[i];
+		else
+			coef[i] = 0;
+	}
+
+	//TODO: Write an N PHY table with ID 15, length 4, offset 88, width 16, and data from coef
+	//TODO: Write an N PHY table with ID 15, length 2, offset 85, width 16 and data from loft
+	//TODO: Write an N PHY table with ID 15, length 2, offset 93, width 16 and data from loft
+
+	if (dev->phy.rev < 2)
+		;//TODO: Call N PHY TX IQ Workaround
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		txcal_radio_regs = nphy->cal_cache.txcal_radio_regs_2G;
+		rxcal_coeffs = &nphy->cal_cache.rxcal_coeffs_2G;
+	} else {
+		txcal_radio_regs = nphy->cal_cache.txcal_radio_regs_5G;
+		rxcal_coeffs = &nphy->cal_cache.rxcal_coeffs_5G;
+	}
+
+	/* TODO use some definitions */
+	if (dev->phy.rev >= 3) {
+		b43_radio_write(dev, 0x2021, txcal_radio_regs[0]);
+		b43_radio_write(dev, 0x2022, txcal_radio_regs[1]);
+		b43_radio_write(dev, 0x3021, txcal_radio_regs[2]);
+		b43_radio_write(dev, 0x3022, txcal_radio_regs[3]);
+		b43_radio_write(dev, 0x2023, txcal_radio_regs[4]);
+		b43_radio_write(dev, 0x2024, txcal_radio_regs[5]);
+		b43_radio_write(dev, 0x3023, txcal_radio_regs[6]);
+		b43_radio_write(dev, 0x3024, txcal_radio_regs[7]);
+	} else {
+		b43_radio_write(dev, 0x8B, txcal_radio_regs[0]);
+		b43_radio_write(dev, 0xBA, txcal_radio_regs[1]);
+		b43_radio_write(dev, 0x8D, txcal_radio_regs[2]);
+		b43_radio_write(dev, 0xBC, txcal_radio_regs[3]);
+	}
+	b43_nphy_rx_iq_coeffs(dev, true, rxcal_coeffs);
+}
+
  /* Init N-PHY
   * http://bcm-v4.sipsolutions.net/802.11/PHY/Init/N
   */
@@ -1241,7 +1309,7 @@ int b43_phy_initn(struct b43_wldev *dev)
  				//TODO N PHY Periodic Calibration with argument 3
  			}
  		} else {
-			//TODO N PHY Restore Calibration
+			b43_nphy_restore_cal(dev);
  		}
  	}

diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index e2479c5..b23987c 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -939,6 +939,16 @@ struct b43_phy_n_rssical_cache {
  	u16 rssical_phy_regs_5G[12];
  };

+struct b43_phy_n_cal_cache {
+	u16 txcal_radio_regs_2G[8];
+	u16 txcal_coeffs_2G[8];
+	struct b43_phy_n_iq_comp rxcal_coeffs_2G;
+
+	u16 txcal_radio_regs_5G[8];
+	u16 txcal_coeffs_5G[8];
+	struct b43_phy_n_iq_comp rxcal_coeffs_5G;
+};
+
  struct b43_phy_n {
  	u8 txpwrctrl;
  	u8 cal_orig_pwr_idx[2];
@@ -964,6 +974,7 @@ struct b43_phy_n {
  	u8 rssical_chanspec_5G;

  	struct b43_phy_n_rssical_cache rssical_cache;
+	struct b43_phy_n_cal_cache cal_cache;

  	bool crsminpwr_adjusted;
  	bool noisevars_adjusted;
-- 
1.6.4.2

