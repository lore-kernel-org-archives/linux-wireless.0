Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:45327 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0AOB0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 20:26:01 -0500
Received: by fxm25 with SMTP id 25so145174fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 17:26:00 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Fri, 15 Jan 2010 02:25:59 +0100
Subject: [RFR][PATCH] b43: N-PHY: TX cal PHY code for setup and cleanup
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6jvllf79lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: as we decided, I'll prepare patch bomb with everything posted so far. So this one is posted
for review rather than real including to wireless-testing/kernel.
---
  drivers/net/wireless/b43/phy_n.c |   81 ++++++++++++++++++++++++++++++++++++++
  drivers/net/wireless/b43/phy_n.h |    2 +
  2 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d7eeed0..bdf1355 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -632,6 +632,87 @@ static void b43_nphy_calc_rx_iq_comp(struct b43_wldev *dev, u8 mask)
  	b43_nphy_rx_iq_coeffs(dev, true, &new);
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalPhyCleanup */
+static void b43_nphy_tx_cal_phy_cleanup(struct b43_wldev *dev, u8 core)
+{
+	u16 *regs = &dev->nphy.tx_rx_cal_phy_saveregs;
+
+	b43_phy_write(dev, B43_NPHY_RFSEQCA, regs[0]);
+	if (core == 0) {
+		b43_phy_write(dev, B43_NPHY_AFECTL_C1, regs[1]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_OVER1, regs[2]);
+	} else {
+		b43_phy_write(dev, B43_NPHY_AFECTL_C2, regs[1]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_OVER, regs[2]);
+	}
+	b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, regs[3]);
+	b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, regs[4]);
+	b43_phy_write(dev, B43_NPHY_RFCTL_RSSIO1, regs[5]);
+	b43_phy_write(dev, B43_NPHY_RFCTL_RSSIO2, regs[6]);
+	b43_phy_write(dev, B43_NPHY_TXF_40CO_B1S1, regs[7]);
+	b43_phy_write(dev, B43_NPHY_RFCTL_OVER, regs[8]);
+	b43_phy_write(dev, B43_NPHY_PAPD_EN0, regs[9]);
+	b43_phy_write(dev, B43_NPHY_PAPD_EN1, regs[10]);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalPhySetup */
+static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev, u8 core)
+{
+	u16 *regs = &dev->nphy.tx_rx_cal_phy_saveregs;
+
+	regs[0] = b43_phy_read(dev, B43_NPHY_RFSEQCA);
+	if (core == 0) {
+		regs[1] = b43_phy_read(dev, B43_NPHY_AFECTL_C1);
+		regs[2] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER1);
+	} else {
+		regs[1] = b43_phy_read(dev, B43_NPHY_AFECTL_C2);
+		regs[2] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER);
+	}
+	regs[3] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC1);
+	regs[4] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC2);
+	regs[5] = b43_phy_read(dev, B43_NPHY_RFCTL_RSSIO1);
+	regs[6] = b43_phy_read(dev, B43_NPHY_RFCTL_RSSIO2);
+	regs[7] = b43_phy_read(dev, B43_NPHY_TXF_40CO_B1S1);
+	regs[8] = b43_phy_read(dev, B43_NPHY_RFCTL_OVER);
+	regs[9] = b43_phy_read(dev, B43_NPHY_PAPD_EN0);
+	regs[10] = b43_phy_read(dev, B43_NPHY_PAPD_EN1);
+
+	b43_phy_mask(dev, B43_NPHY_PAPD_EN0, ~0x0001);
+	b43_phy_mask(dev, B43_NPHY_PAPD_EN1, ~0x0001);
+
+	b43_phy_maskset(dev, B43_NPHY_RFSEQCA, ~B43_NPHY_RFSEQCA_RXDIS,
+			((1 - core) << B43_NPHY_RFSEQCA_RXDIS_SHIFT));
+	b43_phy_maskset(dev, B43_NPHY_RFSEQCA, ~B43_NPHY_RFSEQCA_TXEN,
+			((1 - core) << B43_NPHY_RFSEQCA_TXEN_SHIFT));
+	b43_phy_maskset(dev, B43_NPHY_RFSEQCA, ~B43_NPHY_RFSEQCA_RXEN,
+			(core << B43_NPHY_RFSEQCA_RXEN_SHIFT));
+	b43_phy_maskset(dev, B43_NPHY_RFSEQCA, ~B43_NPHY_RFSEQCA_TXDIS,
+			(core << B43_NPHY_RFSEQCA_TXDIS_SHIFT));
+
+	if (core == 0) {
+		b43_phy_mask(dev, B43_NPHY_AFECTL_C1, ~0x0007);
+		b43_phy_set(dev, B43_NPHY_AFECTL_OVER1, 0x0007);
+	} else {
+		b43_phy_mask(dev, B43_NPHY_AFECTL_C2, ~0x0007);
+		b43_phy_set(dev, B43_NPHY_AFECTL_OVER, 0x0007);
+	}
+
+	/* TODO: Call N PHY RF Ctrl Intc Override with 2, 0, 3 as arguments */
+	/* TODO: Call N PHY RF Intc Override with 8, 0, 3, 0 as arguments */
+	/* TODO: Call N PHY RF Seq with 0 as argument */
+
+	if (core == 0) {
+		rxval = 1;
+		txval = 8;
+	} else {
+		rxval = 4;
+		txval = 2;
+	}
+
+	/* TODO: Call N PHY RF Ctrl Intc Override with 1, rxval, (core + 1) as arguments */
+	/* TODO: Call N PHY RF Ctrl Intc Override with 1, txval, (2 - core) as arguments */
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/IqCalGainParams */
  static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
  					struct nphy_txgains target,
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 121050b..9ef5aaf 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -977,7 +977,9 @@ struct b43_phy_n {

  	u8 antsel_type;

+	u16 tx_rx_cal_phy_saveregs[11];
  	u16 tx_rx_cal_radio_saveregs[22];
+
  	u16 txcal_bbmult;
  	u16 txiqlocal_bestc[11];
  	bool txiqlocal_coeffsvalid;
-- 
1.6.4.2

