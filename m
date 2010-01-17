Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37645 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab0AQMDi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 07:03:38 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so298468fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 04:03:38 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sun, 17 Jan 2010 13:03:40 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 3/7] b43: N-PHY: implement MIMO config update
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6oegeb39lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   16 +++++++++++++++-
  drivers/net/wireless/b43/phy_n.h |    1 +
  2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 34dd4a2..582d6b0 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -424,6 +424,20 @@ static void b43_nphy_reset_cca(struct b43_wldev *dev)
  	/* TODO: N PHY Force RF Seq with argument 2 */
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/MIMOConfig */
+static void b43_nphy_update_mimo_config(struct b43_wldev *dev, s32 preamble)
+{
+	u16 mimocfg = b43_phy_read(dev, B43_NPHY_MIMOCFG);
+
+	mimocfg |= B43_NPHY_MIMOCFG_AUTO;
+	if (preamble == 1)
+		mimocfg |= B43_NPHY_MIMOCFG_GFMIX;
+	else
+		mimocfg &= ~B43_NPHY_MIMOCFG_GFMIX;
+
+	b43_phy_write(dev, B43_NPHY_MIMOCFG, mimocfg);
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxIqEst */
  static void b43_nphy_rx_iq_est(struct b43_wldev *dev, struct nphy_iq_est *est,
  				u16 samps, u8 time, bool wait)
@@ -2180,7 +2194,7 @@ int b43_phy_initn(struct b43_wldev *dev)
  	b43_phy_write(dev, B43_NPHY_PLOAD_CSENSE_EXTLEN, 0x50);
  	b43_phy_write(dev, B43_NPHY_TXRIFS_FRDEL, 0x30);

-	/* TODO MIMO-Config */
+	b43_nphy_update_mimo_config(dev, nphy->preamble_override);
  	/* TODO Update TX/RX chain */

  	if (phy->rev < 2) {
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 4572866..ae00e3f 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -973,6 +973,7 @@ struct b43_phy_n {
  	bool hang_avoid;
  	bool mute;
  	u16 papd_epsilon_offset[2];
+	s32 preamble_override;

  	u8 mphase_cal_phase_id;
  	u16 mphase_txcal_cmdidx;
-- 
1.6.4.2

