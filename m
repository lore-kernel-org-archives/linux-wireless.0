Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:34467 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab3CGPr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 10:47:59 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so442082eek.11
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 07:47:58 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 08/13] b43: HT-PHY: implement controlling TX power control
Date: Thu,  7 Mar 2013 16:47:22 +0100
Message-Id: <1362671247-10766-9-git-send-email-zajec5@gmail.com> (sfid-20130307_164802_447306_F478EEBE)
In-Reply-To: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't enable it until we have (almost?) whole TX power management
figured out. It's similar to the N-PHY, the difference is that we call a
"fix" *before* disabling power control.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   55 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/phy_ht.h |   13 +++++++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 3b3517c..4300867 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -319,6 +319,46 @@ static void b43_phy_ht_tx_power_fix(struct b43_wldev *dev)
 	}
 }
 
+#if 0
+static void b43_phy_ht_tx_power_ctl(struct b43_wldev *dev, bool enable)
+{
+	struct b43_phy_ht *phy_ht = dev->phy.ht;
+	u16 en_bits = B43_PHY_HT_TXPCTL_CMD_C1_COEFF |
+		      B43_PHY_HT_TXPCTL_CMD_C1_HWPCTLEN |
+		      B43_PHY_HT_TXPCTL_CMD_C1_PCTLEN;
+	const u16 cmd_regs[3] = { B43_PHY_HT_TXPCTL_CMD_C1,
+				  B43_PHY_HT_TXPCTL_CMD_C2,
+				  B43_PHY_HT_TXPCTL_CMD_C3 };
+	int i;
+
+	if (!enable) {
+		if (b43_phy_read(dev, B43_PHY_HT_TXPCTL_CMD_C1) & en_bits) {
+			/* We disable enabled TX pwr ctl, save it's state */
+			/*
+			 * TODO: find the registers. On N-PHY they were 0x1ed
+			 * and 0x1ee, we need 3 such a registers for HT-PHY
+			 */
+		}
+		b43_phy_mask(dev, B43_PHY_HT_TXPCTL_CMD_C1, ~en_bits);
+	} else {
+		b43_phy_set(dev, B43_PHY_HT_TXPCTL_CMD_C1, en_bits);
+
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+			for (i = 0; i < 3; i++)
+				b43_phy_write(dev, cmd_regs[i], 0x32);
+		}
+
+		for (i = 0; i < 3; i++)
+			if (phy_ht->tx_pwr_idx[i] <=
+			    B43_PHY_HT_TXPCTL_CMD_C1_INIT)
+				b43_phy_write(dev, cmd_regs[i],
+					      phy_ht->tx_pwr_idx[i]);
+	}
+
+	phy_ht->tx_pwr_ctl = enable;
+}
+#endif
+
 /**************************************************
  * Channel switching ops.
  **************************************************/
@@ -455,14 +495,21 @@ static void b43_phy_ht_op_prepare_structs(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
 	struct b43_phy_ht *phy_ht = phy->ht;
+	int i;
 
 	memset(phy_ht, 0, sizeof(*phy_ht));
+
+	phy_ht->tx_pwr_ctl = true;
+	for (i = 0; i < 3; i++)
+		phy_ht->tx_pwr_idx[i] = B43_PHY_HT_TXPCTL_CMD_C1_INIT + 1;
 }
 
 static int b43_phy_ht_op_init(struct b43_wldev *dev)
 {
+	struct b43_phy_ht *phy_ht = dev->phy.ht;
 	u16 tmp;
 	u16 clip_state[3];
+	bool saved_tx_pwr_ctl;
 
 	if (dev->dev->bus_type != B43_BUS_BCMA) {
 		b43err(dev->wl, "HT-PHY is supported only on BCMA bus!\n");
@@ -589,6 +636,14 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 	b43_httab_write_bulk(dev, B43_HTTAB32(0x1a, 0xc0),
 			B43_HTTAB_1A_C0_LATE_SIZE, b43_httab_0x1a_0xc0_late);
 
+	saved_tx_pwr_ctl = phy_ht->tx_pwr_ctl;
+	b43_phy_ht_tx_power_fix(dev);
+#if 0
+	b43_phy_ht_tx_power_ctl(dev, false);
+	/* TODO */
+	b43_phy_ht_tx_power_ctl(dev, saved_tx_pwr_ctl);
+#endif
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index 684807c..bc7a43f 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -22,6 +22,13 @@
 #define B43_PHY_HT_BW4				0x1D1
 #define B43_PHY_HT_BW5				0x1D2
 #define B43_PHY_HT_BW6				0x1D3
+#define B43_PHY_HT_TXPCTL_CMD_C1		0x1E7	/* TX power control command */
+#define  B43_PHY_HT_TXPCTL_CMD_C1_INIT		0x007F	/* Init */
+#define  B43_PHY_HT_TXPCTL_CMD_C1_COEFF		0x2000	/* Power control coefficients */
+#define  B43_PHY_HT_TXPCTL_CMD_C1_HWPCTLEN	0x4000	/* Hardware TX power control enable */
+#define  B43_PHY_HT_TXPCTL_CMD_C1_PCTLEN	0x8000	/* TX power control enable */
+#define B43_PHY_HT_TXPCTL_CMD_C2		0x222
+#define  B43_PHY_HT_TXPCTL_CMD_C2_INIT		0x007F
 
 #define B43_PHY_HT_C1_CLIP1THRES		B43_PHY_OFDM(0x00E)
 #define B43_PHY_HT_C2_CLIP1THRES		B43_PHY_OFDM(0x04E)
@@ -51,6 +58,9 @@
 #define B43_PHY_HT_AFE_C3_OVER			B43_PHY_EXTG(0x118)
 #define B43_PHY_HT_AFE_C3			B43_PHY_EXTG(0x119)
 
+#define B43_PHY_HT_TXPCTL_CMD_C3		B43_PHY_EXTG(0x164)
+#define  B43_PHY_HT_TXPCTL_CMD_C3_INIT		0x007F
+
 #define B43_PHY_HT_TEST				B43_PHY_N_BMODE(0x00A)
 
 
@@ -67,6 +77,9 @@ struct b43_phy_ht_channeltab_e_phy {
 
 struct b43_phy_ht {
 	u16 rf_ctl_int_save[3];
+
+	bool tx_pwr_ctl;
+	u8 tx_pwr_idx[3];
 };
 
 
-- 
1.7.10.4

