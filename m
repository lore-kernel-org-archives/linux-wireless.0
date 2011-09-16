Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48228 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1IPKbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 06:31:19 -0400
Received: by mail-fx0-f46.google.com with SMTP id 4so1527867fxe.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 03:31:18 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/6] b43: LCN-PHY: init TX power control
Date: Fri, 16 Sep 2011 12:34:02 +0200
Message-Id: <1316169243-8808-5-git-send-email-zajec5@gmail.com> (sfid-20110916_123122_926336_3CEE8A94)
In-Reply-To: <1316169243-8808-1-git-send-email-zajec5@gmail.com>
References: <1316169243-8808-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_lcn.c |   92 +++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/phy_lcn.h |    2 +
 2 files changed, 93 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index 8951647..8810bc9 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -37,6 +37,13 @@
 #include "tables_phy_lcn.h"
 #include "main.h"
 
+struct lcn_tx_gains {
+	u16 gm_gain;
+	u16 pga_gain;
+	u16 pad_gain;
+	u16 dac_gain;
+};
+
 struct lcn_tx_iir_filter {
 	u8 type;
 	u16 values[16];
@@ -198,6 +205,29 @@ static void b43_phy_lcn_afe_set_unset(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_PHY_LCN_AFE_CTL1, afe_ctl1);
 }
 
+/* wlc_lcnphy_get_pa_gain */
+static u16 b43_phy_lcn_get_pa_gain(struct b43_wldev *dev)
+{
+	return (b43_phy_read(dev, 0x4fb) & 0x7f00) >> 8;
+}
+
+/* wlc_lcnphy_set_dac_gain */
+static void b43_phy_lcn_set_dac_gain(struct b43_wldev *dev, u16 dac_gain)
+{
+	u16 dac_ctrl;
+
+	dac_ctrl = b43_phy_read(dev, 0x439);
+	dac_ctrl = dac_ctrl & 0xc7f;
+	dac_ctrl = dac_ctrl | (dac_gain << 7);
+	b43_phy_maskset(dev, 0x439, ~0xfff, dac_ctrl);
+}
+
+/* wlc_lcnphy_set_bbmult */
+static void b43_phy_lcn_set_bbmult(struct b43_wldev *dev, u8 m0)
+{
+	b43_lcntab_write(dev, B43_LCNTAB16(0x00, 0x57), m0 << 8);
+}
+
 /* wlc_lcnphy_clear_tx_power_offsets */
 static void b43_phy_lcn_clear_tx_power_offsets(struct b43_wldev *dev)
 {
@@ -400,6 +430,65 @@ static bool b43_phy_lcn_load_tx_iir_ofdm_filter(struct b43_wldev *dev,
 	return false;
 }
 
+/* wlc_lcnphy_set_tx_gain_override */
+static void b43_phy_lcn_set_tx_gain_override(struct b43_wldev *dev, bool enable)
+{
+	b43_phy_maskset(dev, 0x4b0, ~(0x1 << 7), enable << 7);
+	b43_phy_maskset(dev, 0x4b0, ~(0x1 << 14), enable << 14);
+	b43_phy_maskset(dev, 0x43b, ~(0x1 << 6), enable << 6);
+}
+
+/* wlc_lcnphy_set_tx_gain */
+static void b43_phy_lcn_set_tx_gain(struct b43_wldev *dev,
+				    struct lcn_tx_gains *target_gains)
+{
+	u16 pa_gain = b43_phy_lcn_get_pa_gain(dev);
+
+	b43_phy_write(dev, 0x4b5,
+		      (target_gains->gm_gain | (target_gains->pga_gain << 8)));
+	b43_phy_maskset(dev, 0x4fb, ~0x7fff,
+			(target_gains->pad_gain | (pa_gain << 8)));
+	b43_phy_write(dev, 0x4fc,
+		      (target_gains->gm_gain | (target_gains->pga_gain << 8)));
+	b43_phy_maskset(dev, 0x4fd, ~0x7fff,
+			(target_gains->pad_gain | (pa_gain << 8)));
+
+	b43_phy_lcn_set_dac_gain(dev, target_gains->dac_gain);
+	b43_phy_lcn_set_tx_gain_override(dev, true);
+}
+
+/* wlc_lcnphy_tx_pwr_ctrl_init */
+static void b43_phy_lcn_tx_pwr_ctl_init(struct b43_wldev *dev)
+{
+	struct lcn_tx_gains tx_gains;
+	u8 bbmult;
+
+	b43_mac_suspend(dev);
+
+	if (!dev->phy.lcn->hw_pwr_ctl_capable) {
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+			tx_gains.gm_gain = 4;
+			tx_gains.pga_gain = 12;
+			tx_gains.pad_gain = 12;
+			tx_gains.dac_gain = 0;
+			bbmult = 150;
+		} else {
+			tx_gains.gm_gain = 7;
+			tx_gains.pga_gain = 15;
+			tx_gains.pad_gain = 14;
+			tx_gains.dac_gain = 0;
+			bbmult = 150;
+		}
+		b43_phy_lcn_set_tx_gain(dev, &tx_gains);
+		b43_phy_lcn_set_bbmult(dev, bbmult);
+		b43_phy_lcn_sense_setup(dev); /* TODO: TEMPSENSE as arg */
+	} else {
+		b43err(dev->wl, "TX power control not supported for this HW\n");
+	}
+
+	b43_mac_enable(dev);
+}
+
 /* wlc_lcnphy_txrx_spur_avoidance_mode */
 static void b43_phy_lcn_txrx_spur_avoidance_mode(struct b43_wldev *dev,
 						 bool enable)
@@ -562,7 +651,8 @@ static int b43_phy_lcn_op_init(struct b43_wldev *dev)
 	else
 		B43_WARN_ON(1);
 
-	b43_phy_lcn_sense_setup(dev);
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		b43_phy_lcn_tx_pwr_ctl_init(dev);
 
 	b43_switch_channel(dev, dev->phy.channel);
 
diff --git a/drivers/net/wireless/b43/phy_lcn.h b/drivers/net/wireless/b43/phy_lcn.h
index 25f06e8..2a386d0 100644
--- a/drivers/net/wireless/b43/phy_lcn.h
+++ b/drivers/net/wireless/b43/phy_lcn.h
@@ -19,6 +19,8 @@
 
 
 struct b43_phy_lcn {
+	bool hw_pwr_ctl;
+	bool hw_pwr_ctl_capable;
 };
 
 
-- 
1.7.3.4

