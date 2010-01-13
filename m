Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37326 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab0AMXyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 18:54:15 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so801959fxm.21
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2010 15:54:15 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 14 Jan 2010 00:54:13 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 1/3 v2] b43: N-PHY: add b43_nphy_rx_iq_est and
 b43_nphy_tx_iq_workaround
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6hwok0u9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---

V2: Use definitions for SHM, fix mask and struct defitnion style.

---
  drivers/net/wireless/b43/b43.h   |    5 +++
  drivers/net/wireless/b43/phy_n.c |   66 +++++++++++++++++++++++++++++++++++++-
  2 files changed, 70 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 6607162..d5c67a6 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -255,6 +255,11 @@ enum {
  #define B43_SHM_SH_MAXBFRAMES		0x0080	/* Maximum number of frames in a burst */
  #define B43_SHM_SH_SPUWKUP		0x0094	/* pre-wakeup for synth PU in us */
  #define B43_SHM_SH_PRETBTT		0x0096	/* pre-TBTT in us */
+/* SHM_SHARED tx iq workarounds */
+#define B43_SHM_SH_NPHY_TXIQW0		0x0700
+#define B43_SHM_SH_NPHY_TXIQW1		0x0702
+#define B43_SHM_SH_NPHY_TXIQW2		0x0704
+#define B43_SHM_SH_NPHY_TXIQW3		0x0706

  /* SHM_SCRATCH offsets */
  #define B43_SHM_SC_MINCONT		0x0003	/* Minimum contention window */
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index c244ddf..db10a9f 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -32,6 +32,15 @@

  struct nphy_txgains { u16 txgm[2]; u16 pga[2]; u16 pad[2]; u16 ipa[2]; };

+struct nphy_iq_est {
+	s32 iq0_prod;
+	u32 i0_pwr;
+	u32 q0_pwr;
+	s32 iq1_prod;
+	u32 i1_pwr;
+	u32 q1_pwr;
+};
+
  void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
  {//TODO
  }
@@ -471,6 +480,61 @@ static void b43_nphy_rx_iq_coeffs(struct b43_wldev *dev, bool write,
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
+		b43_phy_mask(dev, B43_NPHY_IQEST_CMD, ~B43_NPHY_IQEST_CMD_MODE);
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
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_NPHY_TXIQW0, array[0]);
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_NPHY_TXIQW1, array[1]);
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_NPHY_TXIQW2, array[2]);
+	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_NPHY_TXIQW3, array[3]);
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxLpFbw */
  static void b43_nphy_tx_lp_fbw(struct b43_wldev *dev)
  {
@@ -1108,7 +1172,7 @@ static void b43_nphy_restore_cal(struct b43_wldev *dev)
  	//TODO: Write an N PHY table with ID 15, length 2, offset 93, width 16 and data from loft

  	if (dev->phy.rev < 2)
-		;//TODO: Call N PHY TX IQ Workaround
+		b43_nphy_tx_iq_workaround(dev);

  	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
  		txcal_radio_regs = nphy->cal_cache.txcal_radio_regs_2G;
-- 
1.6.4.2

