Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:35025 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab0AQXVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 18:21:45 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so627454fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 15:21:45 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Mon, 18 Jan 2010 00:21:49 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 5/5 V2] b43: N-PHY: silence warnings, add missing call
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6o9unx49lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
New patch I didn't include earlier.
---
  drivers/net/wireless/b43/phy_n.c |    6 +++---
  1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 2356d84..3a3cc2f 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1624,7 +1624,7 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
  		b43_phy_write(dev, B43_NPHY_AFECTL_OVER, tmp | 0x0600);

  		regs[4] = b43_phy_read(dev, B43_NPHY_BBCFG);
-		b43_phy_mask(dev, B43_NPHY_BBCFG, ~B43_NPHY_BBCFG_RSTRX);
+		b43_phy_mask(dev, B43_NPHY_BBCFG, (u16)~B43_NPHY_BBCFG_RSTRX);

  		tmp = b43_ntab_read(dev, B43_NTAB16(8, 3));
  		regs[5] = tmp;
@@ -1970,7 +1970,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
  	u16 lna[3] = { 3, 3, 1 };
  	u16 hpf1[3] = { 7, 2, 0 };
  	u16 hpf2[3] = { 2, 0, 0 };
-	u32 power[3];
+	u32 power[3] = { };
  	u16 gain_save[2];
  	u16 cal_gain[2];
  	struct nphy_iqcal_params cal_params[2];
@@ -2077,7 +2077,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
  					(cur_lna << 2));
  			/* TODO:Call N PHY RF Ctrl Override with 0x400, tmp[0],
  				3, 0 as arguments */
-			/* TODO: Call N PHY Force RF Seq with 2 as argument */
+			b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
  			b43_nphy_stop_playback(dev);

  			if (playtone) {
-- 
1.6.4.2

