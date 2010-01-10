Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:39669 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab0AJWMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 17:12:15 -0500
Received: by mail-ew0-f214.google.com with SMTP id 6so21225297ewy.29
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jan 2010 14:12:15 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sun, 10 Jan 2010 23:13:45 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 4/6] b43: N-PHY: add b43_nphy_rx_iq_coeffs and
 b43_nphy_tx_lp_fbw
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6b707kg9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com
---
  drivers/net/wireless/b43/phy_n.c |   41 +++++++++++++++++++++++++++++++++++++-
  drivers/net/wireless/b43/phy_n.h |    7 ++++++
  2 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index b39b817..22e7432 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -454,6 +454,45 @@ static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev, bool enable)
  	}
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxIqCoeffs */
+static void b43_nphy_rx_iq_coeffs(struct b43_wldev *dev, bool write,
+					struct b43_phy_n_iq_comp *pcomp)
+{
+	if (write) {
+		b43_phy_write(dev, B43_NPHY_C1_RXIQ_COMPA0, pcomp->a0);
+		b43_phy_write(dev, B43_NPHY_C1_RXIQ_COMPB0, pcomp->b0);
+		b43_phy_write(dev, B43_NPHY_C2_RXIQ_COMPA1, pcomp->a1);
+		b43_phy_write(dev, B43_NPHY_C2_RXIQ_COMPB1, pcomp->b1);
+	} else {
+		pcomp->a0 = b43_phy_read(dev, B43_NPHY_C1_RXIQ_COMPA0);
+		pcomp->b0 = b43_phy_read(dev, B43_NPHY_C1_RXIQ_COMPB0);
+		pcomp->a1 = b43_phy_read(dev, B43_NPHY_C2_RXIQ_COMPA1);
+		pcomp->b1 = b43_phy_read(dev, B43_NPHY_C2_RXIQ_COMPB1);
+	}
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxLpFbw */
+static void b43_nphy_tx_lp_fbw(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	u16 tmp;
+	enum ieee80211_band band = b43_current_band(dev->wl);
+	bool ipa = (nphy->ipa2g_on && band == IEEE80211_BAND_2GHZ) ||
+			(nphy->ipa5g_on && band == IEEE80211_BAND_5GHZ);
+
+	if (dev->phy.rev >= 3) {
+		if (ipa) {
+			tmp = 4;
+			b43_phy_write(dev, B43_NPHY_TXF_40CO_B32S2,
+			      (((((tmp << 3) | tmp) << 3) | tmp) << 3) | tmp);
+		}
+
+		tmp = 1;
+		b43_phy_write(dev, B43_NPHY_TXF_40CO_B1S2,
+			      (((((tmp << 3) | tmp) << 3) | tmp) << 3) | tmp);
+	}
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GetTxGain */
  static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
  {
@@ -1212,7 +1251,7 @@ int b43_phy_initn(struct b43_wldev *dev)
  	b43_phy_write(dev, B43_NPHY_TXMACDELAY, 0x0320);
  	if (phy->rev >= 3 && phy->rev <= 6)
  		b43_phy_write(dev, B43_NPHY_PLOAD_CSENSE_EXTLEN, 0x0014);
-	//TODO N PHY TX LP FBW
+	b43_nphy_tx_lp_fbw(dev);
  	//TODO N PHY Spur Workaround

  	b43err(dev->wl, "IEEE 802.11n devices are not supported, yet.\n");
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index ca1fd11..e2479c5 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -924,6 +924,13 @@

  struct b43_wldev;

+struct b43_phy_n_iq_comp {
+	s16 a0;
+	s16 b0;
+	s16 a1;
+	s16 b1;
+};
+
  struct b43_phy_n_rssical_cache {
  	u16 rssical_radio_regs_2G[2];
  	u16 rssical_phy_regs_2G[12];
-- 
1.6.4.2

