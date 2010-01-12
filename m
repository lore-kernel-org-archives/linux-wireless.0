Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:51661 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab0ALTiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 14:38:11 -0500
Received: by ewy1 with SMTP id 1so5080575ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2010 11:38:09 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Tue, 12 Jan 2010 20:38:07 +0100
Subject: [PATCH 1/3] b43: N-PHY: add b43_nphy_rx_iq_est and
 b43_nphy_tx_iq_workaround
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6fp5shd9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   59 +++++++++++++++++++++++++++++++++++++-
  1 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index c244ddf..7b2468d 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -31,6 +31,8 @@


  struct nphy_txgains { u16 txgm[2]; u16 pga[2]; u16 pad[2]; u16 ipa[2]; };
+struct nphy_iq_est { s32 iq0_prod; u32 i0_pwr; u32 q0_pwr; s32 iq1_prod;
+			u32 i1_pwr; u32 q1_pwr; };

  void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
  {//TODO
@@ -471,6 +473,61 @@ static void b43_nphy_rx_iq_coeffs(struct b43_wldev *dev, bool write,
  	}
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxIqEst */
+static void b43_nphy_rx_iq_est(struct b43_wldev *dev, struct nphy_iq_est *est,
+				u16 samps, u8 time, bool wait)
+{
+	int i;
+	u16 tmp;
+
+	b43_phy_write(dev, B43_NPHY_IQEST_SAMCNT, samps);
+	b43_phy_maskset(dev, B43_NPHY_IQEST_WT, ~B43_NPHY_IQEST_WT_VAL, time);
+	if (wait)
+		b43_phy_set(dev, B43_NPHY_IQEST_CMD, B43_NPHY_IQEST_CMD_MODE);
+	else
+		b43_phy_mask(dev, B43_NPHY_IQEST_CMD, B43_NPHY_IQEST_CMD_MODE);
+
+	b43_phy_set(dev, B43_NPHY_IQEST_CMD, B43_NPHY_IQEST_CMD_START);
+
+	for (i = 1000; i; i--) {
+		tmp = b43_phy_read(dev, B43_NPHY_IQEST_CMD);
+		if (!(tmp & B43_NPHY_IQEST_CMD_START)) {
+			est->i0_pwr = (b43_phy_read(dev, B43_NPHY_IQEST_IPACC_HI0) << 16) |
+					b43_phy_read(dev, B43_NPHY_IQEST_IPACC_LO0);
+			est->q0_pwr = (b43_phy_read(dev, B43_NPHY_IQEST_QPACC_HI0) << 16) |
+					b43_phy_read(dev, B43_NPHY_IQEST_QPACC_LO0);
+			est->iq0_prod = (b43_phy_read(dev, B43_NPHY_IQEST_IQACC_HI0) << 16) |
+					b43_phy_read(dev, B43_NPHY_IQEST_IQACC_LO0);
+
+			est->i1_pwr = (b43_phy_read(dev, B43_NPHY_IQEST_IPACC_HI1) << 16) |
+					b43_phy_read(dev, B43_NPHY_IQEST_IPACC_LO1);
+			est->q1_pwr = (b43_phy_read(dev, B43_NPHY_IQEST_QPACC_HI1) << 16) |
+					b43_phy_read(dev, B43_NPHY_IQEST_QPACC_LO1);
+			est->iq1_prod = (b43_phy_read(dev, B43_NPHY_IQEST_IQACC_HI1) << 16) |
+					b43_phy_read(dev, B43_NPHY_IQEST_IQACC_LO1);
+			return;
+		}
+		udelay(10);
+	}
+	memset(est, 0, sizeof(*est));
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxIqWar */
+static void b43_nphy_tx_iq_workaround(struct b43_wldev *dev)
+{
+	u16 array[4];
+	int i;
+
+	b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x3C50);
+	for (i = 0; i < 4; i++)
+		array[i] = b43_phy_read(dev, B43_NPHY_TABLE_DATALO);
+
+	b43_shm_write16(dev, B43_SHM_SHARED, 0x0700, array[0]);
+	b43_shm_write16(dev, B43_SHM_SHARED, 0x0702, array[1]);
+	b43_shm_write16(dev, B43_SHM_SHARED, 0x0704, array[2]);
+	b43_shm_write16(dev, B43_SHM_SHARED, 0x0706, array[3]);
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxLpFbw */
  static void b43_nphy_tx_lp_fbw(struct b43_wldev *dev)
  {
@@ -1108,7 +1165,7 @@ static void b43_nphy_restore_cal(struct b43_wldev *dev)
  	//TODO: Write an N PHY table with ID 15, length 2, offset 93, width 16 and data from loft

  	if (dev->phy.rev < 2)
-		;//TODO: Call N PHY TX IQ Workaround
+		b43_nphy_tx_iq_workaround(dev);

  	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
  		txcal_radio_regs = nphy->cal_cache.txcal_radio_regs_2G;
-- 
1.6.4.2

