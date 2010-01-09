Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37494 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0AIM7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jan 2010 07:59:39 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so13340575fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jan 2010 04:59:38 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sat, 09 Jan 2010 14:01:06 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 2/4] b43: N-PHY: add b43_nphy_pa_override
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u59nr4cg9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   40 ++++++++++++++++++++++++++++++++++++-
  drivers/net/wireless/b43/phy_n.h |    3 ++
  2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 5cd4b1a..739973e 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -330,6 +330,40 @@ void b43_nphy_bmac_clock_fgc(struct b43_wldev *dev, bool force)
  	ssb_write32(dev->dev, SSB_TMSLOW, tmslow);
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/PA%20override */
+static void b43_nphy_pa_override(struct b43_wldev *dev, bool enable)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	enum ieee80211_band band;
+	u16 tmp;
+
+	if (!enable) {
+		nphy->rfctrl_intc1_save = b43_phy_read(dev,
+						       B43_NPHY_RFCTL_INTC1);
+		nphy->rfctrl_intc2_save = b43_phy_read(dev,
+						       B43_NPHY_RFCTL_INTC2);
+		band = b43_current_band(dev->wl);
+		if (dev->phy.rev >= 3) {
+			if (band == IEEE80211_BAND_5GHZ)
+				tmp = 0x600;
+			else
+				tmp = 0x480;
+		} else {
+			if (band == IEEE80211_BAND_5GHZ)
+				tmp = 0x180;
+			else
+				tmp = 0x120;
+		}
+		b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, tmp);
+		b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, tmp);
+	} else {
+		b43_phy_write(dev, B43_NPHY_RFCTL_INTC1,
+				nphy->rfctrl_intc1_save);
+		b43_phy_write(dev, B43_NPHY_RFCTL_INTC2,
+				nphy->rfctrl_intc2_save);
+	}
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CCA */
  static void b43_nphy_reset_cca(struct b43_wldev *dev)
  {
@@ -662,10 +696,12 @@ int b43_phy_initn(struct b43_wldev *dev)
  	b43_nphy_bmac_clock_fgc(dev, 0);

  	//TODO N PHY MAC PHY Clock Set with argument 1
-	//TODO Disable PA Override
+
+	b43_nphy_pa_override(dev, false);
  	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RX2TX);
  	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
-	//TODO Turn on PA override
+	b43_nphy_pa_override(dev, true);
+
  	//TODO N PHY Classifier with arguments 0 and 0
  	//TODO N PHY Det Clip with 0 and the clip array as arguments
  	tx_pwr_state = nphy->txpwrctrl;
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index f90e905..6bb9476 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -936,6 +936,9 @@ struct b43_phy_n {
  	bool hang_avoid;
  	bool mute;

+	u16 rfctrl_intc1_save;
+	u16 rfctrl_intc2_save;
+
  	u16 classifier_state;
  	u16 clip_state[2];

-- 
1.6.4.2

