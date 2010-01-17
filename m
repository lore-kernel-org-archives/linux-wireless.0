Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37645 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab0AQMDw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 07:03:52 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so298468fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 04:03:52 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sun, 17 Jan 2010 13:03:55 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 5/7] b43: N-PHY: implement chain selection
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6oegtv69lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   30 +++++++++++++++++++++++++++++-
  drivers/net/wireless/b43/phy_n.h |    1 +
  2 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index c6d3d5a..d24e2b4 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -438,6 +438,34 @@ static void b43_nphy_update_mimo_config(struct b43_wldev *dev, s32 preamble)
  	b43_phy_write(dev, B43_NPHY_MIMOCFG, mimocfg);
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/Chains */
+static void b43_nphy_update_txrx_chain(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	bool override = false;
+	u16 chain = 0x33;
+
+	if (nphy->txrx_chain == 0) {
+		chain = 0x11;
+		override = true;
+	} else if (nphy->txrx_chain == 1) {
+		chain = 0x22;
+		override = true;
+	}
+
+	b43_phy_maskset(dev, B43_NPHY_RFSEQCA,
+			~(B43_NPHY_RFSEQCA_TXEN | B43_NPHY_RFSEQCA_RXEN),
+			chain);
+
+	if (override)
+		b43_phy_set(dev, B43_NPHY_RFSEQMODE,
+				B43_NPHY_RFSEQMODE_CAOVER);
+	else
+		b43_phy_mask(dev, B43_NPHY_RFSEQMODE,
+				~B43_NPHY_RFSEQMODE_CAOVER);
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxIqEst */
  static void b43_nphy_rx_iq_est(struct b43_wldev *dev, struct nphy_iq_est *est,
  				u16 samps, u8 time, bool wait)
@@ -2223,7 +2251,7 @@ int b43_phy_initn(struct b43_wldev *dev)
  	b43_phy_write(dev, B43_NPHY_TXRIFS_FRDEL, 0x30);

  	b43_nphy_update_mimo_config(dev, nphy->preamble_override);
-	/* TODO Update TX/RX chain */
+	b43_nphy_update_txrx_chain(dev);

  	if (phy->rev < 2) {
  		b43_phy_write(dev, B43_NPHY_DUP40_GFBL, 0xAA8);
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index d6c92a8..f5a2766 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -987,6 +987,7 @@ struct b43_phy_n {
  	bool txiqlocal_coeffsvalid;
  	struct b43_phy_n_txpwrindex txpwrindex[2];

+	u8 txrx_chain;
  	u16 tx_rx_cal_phy_saveregs[11];
  	u16 tx_rx_cal_radio_saveregs[22];

-- 
1.6.4.2

