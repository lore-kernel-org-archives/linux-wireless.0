Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37645 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab0AQMEA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 07:04:00 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so298468fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 04:03:59 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sun, 17 Jan 2010 13:04:02 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 6/7] b43: N-PHY: move RF sequence declarations top, add
 missing calls
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6oeg0uf9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   28 ++++++++++++++++------------
  1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d24e2b4..34be98b 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -55,6 +55,18 @@ struct nphy_iq_est {
  	u32 q1_pwr;
  };

+enum b43_nphy_rf_sequence {
+	B43_RFSEQ_RX2TX,
+	B43_RFSEQ_TX2RX,
+	B43_RFSEQ_RESET2RX,
+	B43_RFSEQ_UPDATE_GAINH,
+	B43_RFSEQ_UPDATE_GAINL,
+	B43_RFSEQ_UPDATE_GAINU,
+};
+
+static void b43_nphy_force_rf_sequence(struct b43_wldev *dev,
+				       enum b43_nphy_rf_sequence seq);
+
  void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
  {//TODO
  }
@@ -421,7 +433,7 @@ static void b43_nphy_reset_cca(struct b43_wldev *dev)
  	udelay(1);
  	b43_phy_write(dev, B43_NPHY_BBCFG, bbcfg & ~B43_NPHY_BBCFG_RSTCCA);
  	b43_nphy_bmac_clock_fgc(dev, 0);
-	/* TODO: N PHY Force RF Seq with argument 2 */
+	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
  }

  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/MIMOConfig */
@@ -689,7 +701,7 @@ static void b43_nphy_rx_cal_phy_setup(struct b43_wldev *dev, u8 core)

  	/* TODO: Call N PHY RF Ctrl Intc Override with 2, 0, 3 as arguments */
  	/* TODO: Call N PHY RF Intc Override with 8, 0, 3, 0 as arguments */
-	/* TODO: Call N PHY RF Seq with 0 as argument */
+	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RX2TX);

  	if (core == 0) {
  		rxval = 1;
@@ -872,15 +884,7 @@ static void b43_nphy_tx_pwr_ctrl_coef_setup(struct b43_wldev *dev)
  		b43_nphy_stay_in_carrier_search(dev, false);
  }

-enum b43_nphy_rf_sequence {
-	B43_RFSEQ_RX2TX,
-	B43_RFSEQ_TX2RX,
-	B43_RFSEQ_RESET2RX,
-	B43_RFSEQ_UPDATE_GAINH,
-	B43_RFSEQ_UPDATE_GAINL,
-	B43_RFSEQ_UPDATE_GAINU,
-};
-
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ForceRFSeq */
  static void b43_nphy_force_rf_sequence(struct b43_wldev *dev,
  				       enum b43_nphy_rf_sequence seq)
  {
@@ -2156,7 +2160,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
  	}

  	/* TODO: Call N PHY RF Ctrl Override with 0x400, 0, 3, 1 as arguments*/
-	/* TODO: Call N PHY Force RF Seq with 2 as argument */
+	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
  	/* TODO: Write an N PHY Table with ID 7, length 2, offset 0x110,
  		width 16, and data from gain_save */

-- 
1.6.4.2

