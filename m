Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37645 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0AQMDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 07:03:45 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so298468fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 04:03:45 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sun, 17 Jan 2010 13:03:48 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 4/7] b43: N-PHY: implement stopping playback
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6oegmpb9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   34 +++++++++++++++++++++++++++++++---
  drivers/net/wireless/b43/phy_n.h |    1 +
  2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 582d6b0..c6d3d5a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -749,6 +749,34 @@ static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev, bool enable)
  	}
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/stop-playback */
+static void b43_nphy_stop_playback(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	u16 tmp;
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 1);
+
+	tmp = b43_phy_read(dev, B43_NPHY_SAMP_STAT);
+	if (tmp & 0x1)
+		b43_phy_set(dev, B43_NPHY_SAMP_CMD, B43_NPHY_SAMP_CMD_STOP);
+	else if (tmp & 0x2)
+		b43_phy_mask(dev, B43_NPHY_IQLOCAL_CMDGCTL, (u16)~0x8000);
+
+	b43_phy_mask(dev, B43_NPHY_SAMP_CMD, ~0x0004);
+
+	if (nphy->bb_mult_save & 0x80000000) {
+		tmp = nphy->bb_mult_save & 0xFFFF;
+		/* TODO: Write an N PHY Table with ID 15, length 1, offset 87,
+			width 16 and data from tmp */
+		nphy->bb_mult_save = 0;
+	}
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, 0);
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlCoefSetup */
  static void b43_nphy_tx_pwr_ctrl_coef_setup(struct b43_wldev *dev)
  {
@@ -1906,7 +1934,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
  				nphy->mphase_txcal_bestcoeffs */
  		}

-		/* TODO: Call N PHY Stop Playback */
+		b43_nphy_stop_playback(dev);
  		b43_phy_write(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0);
  	}

@@ -2053,7 +2081,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
  			/* TODO:Call N PHY RF Ctrl Override with 0x400, tmp[0],
  				3, 0 as arguments */
  			/* TODO: Call N PHY Force RF Seq with 2 as argument */
-			/* TODO: Call N PHT Stop Playback */
+			b43_nphy_stop_playback(dev);

  			if (playtone) {
  				/* TODO: Call N PHY TX Tone with 4000,
@@ -2080,7 +2108,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
  				} else {
  					b43_nphy_calc_rx_iq_comp(dev, 1 << i);
  				}
-				/* TODO: Call N PHY Stop Playback */
+				b43_nphy_stop_playback(dev);
  			}

  			if (ret != 0)
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index ae00e3f..d6c92a8 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -974,6 +974,7 @@ struct b43_phy_n {
  	bool mute;
  	u16 papd_epsilon_offset[2];
  	s32 preamble_override;
+	u32 bb_mult_save;

  	u8 mphase_cal_phase_id;
  	u16 mphase_txcal_cmdidx;
-- 
1.6.4.2

