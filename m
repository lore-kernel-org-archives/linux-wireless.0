Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44617 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1LQM4a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 07:56:30 -0500
Received: by mail-ey0-f174.google.com with SMTP id j10so3614415eaa.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2011 04:56:29 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/8] b43: N-PHY: reorder functions: put basic ones at beginning
Date: Sat, 17 Dec 2011 13:57:20 +0100
Message-Id: <1324126647-22425-2-git-send-email-zajec5@gmail.com> (sfid-20111217_135634_492446_CD02B5C0)
In-Reply-To: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
References: <1324126647-22425-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  683 +++++++++++++++++++-------------------
 1 files changed, 341 insertions(+), 342 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index f2435e7..1ede258 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -78,19 +78,6 @@ enum b43_nphy_rssi_type {
 	B43_NPHY_RSSI_TBD,
 };
 
-/* TODO: reorder functions */
-static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev,
-						bool enable);
-static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
-					u8 *events, u8 *delays, u8 length);
-static void b43_nphy_force_rf_sequence(struct b43_wldev *dev,
-				       enum b43_nphy_rf_sequence seq);
-static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
-						u16 value, u8 core, bool off);
-static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
-						u16 value, u8 core);
-static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev);
-
 static inline bool b43_nphy_ipa(struct b43_wldev *dev)
 {
 	enum ieee80211_band band = b43_current_band(dev->wl);
@@ -98,6 +85,338 @@ static inline bool b43_nphy_ipa(struct b43_wldev *dev)
 		(dev->phy.n->ipa5g_on && band == IEEE80211_BAND_5GHZ));
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GetIpaGainTbl */
+static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
+{
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (dev->phy.rev >= 6) {
+			if (dev->dev->chip_id == 47162)
+				return txpwrctrl_tx_gain_ipa_rev5;
+			return txpwrctrl_tx_gain_ipa_rev6;
+		} else if (dev->phy.rev >= 5) {
+			return txpwrctrl_tx_gain_ipa_rev5;
+		} else {
+			return txpwrctrl_tx_gain_ipa;
+		}
+	} else {
+		return txpwrctrl_tx_gain_ipa_5g;
+	}
+}
+
+/**************************************************
+ * RF (just without b43_nphy_rf_control_intc_override)
+ **************************************************/
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ForceRFSeq */
+static void b43_nphy_force_rf_sequence(struct b43_wldev *dev,
+				       enum b43_nphy_rf_sequence seq)
+{
+	static const u16 trigger[] = {
+		[B43_RFSEQ_RX2TX]		= B43_NPHY_RFSEQTR_RX2TX,
+		[B43_RFSEQ_TX2RX]		= B43_NPHY_RFSEQTR_TX2RX,
+		[B43_RFSEQ_RESET2RX]		= B43_NPHY_RFSEQTR_RST2RX,
+		[B43_RFSEQ_UPDATE_GAINH]	= B43_NPHY_RFSEQTR_UPGH,
+		[B43_RFSEQ_UPDATE_GAINL]	= B43_NPHY_RFSEQTR_UPGL,
+		[B43_RFSEQ_UPDATE_GAINU]	= B43_NPHY_RFSEQTR_UPGU,
+	};
+	int i;
+	u16 seq_mode = b43_phy_read(dev, B43_NPHY_RFSEQMODE);
+
+	B43_WARN_ON(seq >= ARRAY_SIZE(trigger));
+
+	b43_phy_set(dev, B43_NPHY_RFSEQMODE,
+		    B43_NPHY_RFSEQMODE_CAOVER | B43_NPHY_RFSEQMODE_TROVER);
+	b43_phy_set(dev, B43_NPHY_RFSEQTR, trigger[seq]);
+	for (i = 0; i < 200; i++) {
+		if (!(b43_phy_read(dev, B43_NPHY_RFSEQST) & trigger[seq]))
+			goto ok;
+		msleep(1);
+	}
+	b43err(dev->wl, "RF sequence status timeout\n");
+ok:
+	b43_phy_write(dev, B43_NPHY_RFSEQMODE, seq_mode);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlOverride */
+static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
+						u16 value, u8 core, bool off)
+{
+	int i;
+	u8 index = fls(field);
+	u8 addr, en_addr, val_addr;
+	/* we expect only one bit set */
+	B43_WARN_ON(field & (~(1 << (index - 1))));
+
+	if (dev->phy.rev >= 3) {
+		const struct nphy_rf_control_override_rev3 *rf_ctrl;
+		for (i = 0; i < 2; i++) {
+			if (index == 0 || index == 16) {
+				b43err(dev->wl,
+					"Unsupported RF Ctrl Override call\n");
+				return;
+			}
+
+			rf_ctrl = &tbl_rf_control_override_rev3[index - 1];
+			en_addr = B43_PHY_N((i == 0) ?
+				rf_ctrl->en_addr0 : rf_ctrl->en_addr1);
+			val_addr = B43_PHY_N((i == 0) ?
+				rf_ctrl->val_addr0 : rf_ctrl->val_addr1);
+
+			if (off) {
+				b43_phy_mask(dev, en_addr, ~(field));
+				b43_phy_mask(dev, val_addr,
+						~(rf_ctrl->val_mask));
+			} else {
+				if (core == 0 || ((1 << core) & i) != 0) {
+					b43_phy_set(dev, en_addr, field);
+					b43_phy_maskset(dev, val_addr,
+						~(rf_ctrl->val_mask),
+						(value << rf_ctrl->val_shift));
+				}
+			}
+		}
+	} else {
+		const struct nphy_rf_control_override_rev2 *rf_ctrl;
+		if (off) {
+			b43_phy_mask(dev, B43_NPHY_RFCTL_OVER, ~(field));
+			value = 0;
+		} else {
+			b43_phy_set(dev, B43_NPHY_RFCTL_OVER, field);
+		}
+
+		for (i = 0; i < 2; i++) {
+			if (index <= 1 || index == 16) {
+				b43err(dev->wl,
+					"Unsupported RF Ctrl Override call\n");
+				return;
+			}
+
+			if (index == 2 || index == 10 ||
+			    (index >= 13 && index <= 15)) {
+				core = 1;
+			}
+
+			rf_ctrl = &tbl_rf_control_override_rev2[index - 2];
+			addr = B43_PHY_N((i == 0) ?
+				rf_ctrl->addr0 : rf_ctrl->addr1);
+
+			if ((core & (1 << i)) != 0)
+				b43_phy_maskset(dev, addr, ~(rf_ctrl->bmask),
+						(value << rf_ctrl->shift));
+
+			b43_phy_set(dev, B43_NPHY_RFCTL_OVER, 0x1);
+			b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
+					B43_NPHY_RFCTL_CMD_START);
+			udelay(1);
+			b43_phy_mask(dev, B43_NPHY_RFCTL_OVER, 0xFFFE);
+		}
+	}
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlIntcOverride */
+static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
+						u16 value, u8 core)
+{
+	u8 i, j;
+	u16 reg, tmp, val;
+
+	B43_WARN_ON(dev->phy.rev < 3);
+	B43_WARN_ON(field > 4);
+
+	for (i = 0; i < 2; i++) {
+		if ((core == 1 && i == 1) || (core == 2 && !i))
+			continue;
+
+		reg = (i == 0) ?
+			B43_NPHY_RFCTL_INTC1 : B43_NPHY_RFCTL_INTC2;
+		b43_phy_mask(dev, reg, 0xFBFF);
+
+		switch (field) {
+		case 0:
+			b43_phy_write(dev, reg, 0);
+			b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
+			break;
+		case 1:
+			if (!i) {
+				b43_phy_maskset(dev, B43_NPHY_RFCTL_INTC1,
+						0xFC3F, (value << 6));
+				b43_phy_maskset(dev, B43_NPHY_TXF_40CO_B1S1,
+						0xFFFE, 1);
+				b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
+						B43_NPHY_RFCTL_CMD_START);
+				for (j = 0; j < 100; j++) {
+					if (b43_phy_read(dev, B43_NPHY_RFCTL_CMD) & B43_NPHY_RFCTL_CMD_START) {
+						j = 0;
+						break;
+					}
+					udelay(10);
+				}
+				if (j)
+					b43err(dev->wl,
+						"intc override timeout\n");
+				b43_phy_mask(dev, B43_NPHY_TXF_40CO_B1S1,
+						0xFFFE);
+			} else {
+				b43_phy_maskset(dev, B43_NPHY_RFCTL_INTC2,
+						0xFC3F, (value << 6));
+				b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER,
+						0xFFFE, 1);
+				b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
+						B43_NPHY_RFCTL_CMD_RXTX);
+				for (j = 0; j < 100; j++) {
+					if (b43_phy_read(dev, B43_NPHY_RFCTL_CMD) & B43_NPHY_RFCTL_CMD_RXTX) {
+						j = 0;
+						break;
+					}
+					udelay(10);
+				}
+				if (j)
+					b43err(dev->wl,
+						"intc override timeout\n");
+				b43_phy_mask(dev, B43_NPHY_RFCTL_OVER,
+						0xFFFE);
+			}
+			break;
+		case 2:
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+				tmp = 0x0020;
+				val = value << 5;
+			} else {
+				tmp = 0x0010;
+				val = value << 4;
+			}
+			b43_phy_maskset(dev, reg, ~tmp, val);
+			break;
+		case 3:
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+				tmp = 0x0001;
+				val = value;
+			} else {
+				tmp = 0x0004;
+				val = value << 2;
+			}
+			b43_phy_maskset(dev, reg, ~tmp, val);
+			break;
+		case 4:
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+				tmp = 0x0002;
+				val = value << 1;
+			} else {
+				tmp = 0x0008;
+				val = value << 3;
+			}
+			b43_phy_maskset(dev, reg, ~tmp, val);
+			break;
+		}
+	}
+}
+
+/**************************************************
+ * Various PHY ops
+ **************************************************/
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/clip-detection */
+static void b43_nphy_write_clip_detection(struct b43_wldev *dev,
+					  const u16 *clip_st)
+{
+	b43_phy_write(dev, B43_NPHY_C1_CLIP1THRES, clip_st[0]);
+	b43_phy_write(dev, B43_NPHY_C2_CLIP1THRES, clip_st[1]);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/clip-detection */
+static void b43_nphy_read_clip_detection(struct b43_wldev *dev, u16 *clip_st)
+{
+	clip_st[0] = b43_phy_read(dev, B43_NPHY_C1_CLIP1THRES);
+	clip_st[1] = b43_phy_read(dev, B43_NPHY_C2_CLIP1THRES);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/classifier */
+static u16 b43_nphy_classifier(struct b43_wldev *dev, u16 mask, u16 val)
+{
+	u16 tmp;
+
+	if (dev->dev->core_rev == 16)
+		b43_mac_suspend(dev);
+
+	tmp = b43_phy_read(dev, B43_NPHY_CLASSCTL);
+	tmp &= (B43_NPHY_CLASSCTL_CCKEN | B43_NPHY_CLASSCTL_OFDMEN |
+		B43_NPHY_CLASSCTL_WAITEDEN);
+	tmp &= ~mask;
+	tmp |= (val & mask);
+	b43_phy_maskset(dev, B43_NPHY_CLASSCTL, 0xFFF8, tmp);
+
+	if (dev->dev->core_rev == 16)
+		b43_mac_enable(dev);
+
+	return tmp;
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CCA */
+static void b43_nphy_reset_cca(struct b43_wldev *dev)
+{
+	u16 bbcfg;
+
+	b43_phy_force_clock(dev, 1);
+	bbcfg = b43_phy_read(dev, B43_NPHY_BBCFG);
+	b43_phy_write(dev, B43_NPHY_BBCFG, bbcfg | B43_NPHY_BBCFG_RSTCCA);
+	udelay(1);
+	b43_phy_write(dev, B43_NPHY_BBCFG, bbcfg & ~B43_NPHY_BBCFG_RSTCCA);
+	b43_phy_force_clock(dev, 0);
+	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/carriersearch */
+static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev, bool enable)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = phy->n;
+
+	if (enable) {
+		static const u16 clip[] = { 0xFFFF, 0xFFFF };
+		if (nphy->deaf_count++ == 0) {
+			nphy->classifier_state = b43_nphy_classifier(dev, 0, 0);
+			b43_nphy_classifier(dev, 0x7, 0);
+			b43_nphy_read_clip_detection(dev, nphy->clip_state);
+			b43_nphy_write_clip_detection(dev, clip);
+		}
+		b43_nphy_reset_cca(dev);
+	} else {
+		if (--nphy->deaf_count == 0) {
+			b43_nphy_classifier(dev, 0x7, nphy->classifier_state);
+			b43_nphy_write_clip_detection(dev, nphy->clip_state);
+		}
+	}
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetRfSeq */
+static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
+					u8 *events, u8 *delays, u8 length)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	u8 i;
+	u8 end = (dev->phy.rev >= 3) ? 0x1F : 0x0F;
+	u16 offset1 = cmd << 4;
+	u16 offset2 = offset1 + 0x80;
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, true);
+
+	b43_ntab_write_bulk(dev, B43_NTAB8(7, offset1), length, events);
+	b43_ntab_write_bulk(dev, B43_NTAB8(7, offset2), length, delays);
+
+	for (i = length; i < 16; i++) {
+		b43_ntab_write(dev, B43_NTAB8(7, offset1 + i), end);
+		b43_ntab_write(dev, B43_NTAB8(7, offset2 + i), 1);
+	}
+
+	if (nphy->hang_avoid)
+		b43_nphy_stay_in_carrier_search(dev, false);
+}
+
+/**************************************************
+ * Others
+ **************************************************/
+
 void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
 {//TODO
 }
@@ -835,20 +1154,6 @@ static void b43_nphy_tx_lp_fbw(struct b43_wldev *dev)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CCA */
-static void b43_nphy_reset_cca(struct b43_wldev *dev)
-{
-	u16 bbcfg;
-
-	b43_phy_force_clock(dev, 1);
-	bbcfg = b43_phy_read(dev, B43_NPHY_BBCFG);
-	b43_phy_write(dev, B43_NPHY_BBCFG, bbcfg | B43_NPHY_BBCFG_RSTCCA);
-	udelay(1);
-	b43_phy_write(dev, B43_NPHY_BBCFG, bbcfg & ~B43_NPHY_BBCFG_RSTCCA);
-	b43_phy_force_clock(dev, 0);
-	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/MIMOConfig */
 static void b43_nphy_update_mimo_config(struct b43_wldev *dev, s32 preamble)
 {
@@ -1142,21 +1447,6 @@ static void b43_nphy_tx_iq_workaround(struct b43_wldev *dev)
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_NPHY_TXIQW3, array[3]);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/clip-detection */
-static void b43_nphy_write_clip_detection(struct b43_wldev *dev,
-					  const u16 *clip_st)
-{
-	b43_phy_write(dev, B43_NPHY_C1_CLIP1THRES, clip_st[0]);
-	b43_phy_write(dev, B43_NPHY_C2_CLIP1THRES, clip_st[1]);
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/clip-detection */
-static void b43_nphy_read_clip_detection(struct b43_wldev *dev, u16 *clip_st)
-{
-	clip_st[0] = b43_phy_read(dev, B43_NPHY_C1_CLIP1THRES);
-	clip_st[1] = b43_phy_read(dev, B43_NPHY_C2_CLIP1THRES);
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SuperSwitchInit */
 static void b43_nphy_superswitch_init(struct b43_wldev *dev, bool init)
 {
@@ -1192,59 +1482,15 @@ static void b43_nphy_superswitch_init(struct b43_wldev *dev, bool init)
 			b43_read32(dev, B43_MMIO_MACCTL) &
 			~B43_MACCTL_GPOUTSMSK);
 		b43_write16(dev, B43_MMIO_GPIO_MASK,
-			b43_read16(dev, B43_MMIO_GPIO_MASK) | 0xFC00);
-		b43_write16(dev, B43_MMIO_GPIO_CONTROL,
-			b43_read16(dev, B43_MMIO_GPIO_CONTROL) & ~0xFC00);
-
-		if (init) {
-			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO1, 0x2D8);
-			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP1, 0x301);
-			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO2, 0x2D8);
-			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0x301);
-		}
-	}
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/classifier */
-static u16 b43_nphy_classifier(struct b43_wldev *dev, u16 mask, u16 val)
-{
-	u16 tmp;
-
-	if (dev->dev->core_rev == 16)
-		b43_mac_suspend(dev);
-
-	tmp = b43_phy_read(dev, B43_NPHY_CLASSCTL);
-	tmp &= (B43_NPHY_CLASSCTL_CCKEN | B43_NPHY_CLASSCTL_OFDMEN |
-		B43_NPHY_CLASSCTL_WAITEDEN);
-	tmp &= ~mask;
-	tmp |= (val & mask);
-	b43_phy_maskset(dev, B43_NPHY_CLASSCTL, 0xFFF8, tmp);
-
-	if (dev->dev->core_rev == 16)
-		b43_mac_enable(dev);
-
-	return tmp;
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/carriersearch */
-static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev, bool enable)
-{
-	struct b43_phy *phy = &dev->phy;
-	struct b43_phy_n *nphy = phy->n;
-
-	if (enable) {
-		static const u16 clip[] = { 0xFFFF, 0xFFFF };
-		if (nphy->deaf_count++ == 0) {
-			nphy->classifier_state = b43_nphy_classifier(dev, 0, 0);
-			b43_nphy_classifier(dev, 0x7, 0);
-			b43_nphy_read_clip_detection(dev, nphy->clip_state);
-			b43_nphy_write_clip_detection(dev, clip);
-		}
-		b43_nphy_reset_cca(dev);
-	} else {
-		if (--nphy->deaf_count == 0) {
-			b43_nphy_classifier(dev, 0x7, nphy->classifier_state);
-			b43_nphy_write_clip_detection(dev, nphy->clip_state);
+			b43_read16(dev, B43_MMIO_GPIO_MASK) | 0xFC00);
+		b43_write16(dev, B43_MMIO_GPIO_CONTROL,
+			b43_read16(dev, B43_MMIO_GPIO_CONTROL) & ~0xFC00);
+
+		if (init) {
+			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO1, 0x2D8);
+			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP1, 0x301);
+			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_LO2, 0x2D8);
+			b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2, 0x301);
 		}
 	}
 }
@@ -2034,235 +2280,6 @@ static void b43_nphy_tx_pwr_ctrl_coef_setup(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, false);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetRfSeq */
-static void b43_nphy_set_rf_sequence(struct b43_wldev *dev, u8 cmd,
-					u8 *events, u8 *delays, u8 length)
-{
-	struct b43_phy_n *nphy = dev->phy.n;
-	u8 i;
-	u8 end = (dev->phy.rev >= 3) ? 0x1F : 0x0F;
-	u16 offset1 = cmd << 4;
-	u16 offset2 = offset1 + 0x80;
-
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, true);
-
-	b43_ntab_write_bulk(dev, B43_NTAB8(7, offset1), length, events);
-	b43_ntab_write_bulk(dev, B43_NTAB8(7, offset2), length, delays);
-
-	for (i = length; i < 16; i++) {
-		b43_ntab_write(dev, B43_NTAB8(7, offset1 + i), end);
-		b43_ntab_write(dev, B43_NTAB8(7, offset2 + i), 1);
-	}
-
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, false);
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ForceRFSeq */
-static void b43_nphy_force_rf_sequence(struct b43_wldev *dev,
-				       enum b43_nphy_rf_sequence seq)
-{
-	static const u16 trigger[] = {
-		[B43_RFSEQ_RX2TX]		= B43_NPHY_RFSEQTR_RX2TX,
-		[B43_RFSEQ_TX2RX]		= B43_NPHY_RFSEQTR_TX2RX,
-		[B43_RFSEQ_RESET2RX]		= B43_NPHY_RFSEQTR_RST2RX,
-		[B43_RFSEQ_UPDATE_GAINH]	= B43_NPHY_RFSEQTR_UPGH,
-		[B43_RFSEQ_UPDATE_GAINL]	= B43_NPHY_RFSEQTR_UPGL,
-		[B43_RFSEQ_UPDATE_GAINU]	= B43_NPHY_RFSEQTR_UPGU,
-	};
-	int i;
-	u16 seq_mode = b43_phy_read(dev, B43_NPHY_RFSEQMODE);
-
-	B43_WARN_ON(seq >= ARRAY_SIZE(trigger));
-
-	b43_phy_set(dev, B43_NPHY_RFSEQMODE,
-		    B43_NPHY_RFSEQMODE_CAOVER | B43_NPHY_RFSEQMODE_TROVER);
-	b43_phy_set(dev, B43_NPHY_RFSEQTR, trigger[seq]);
-	for (i = 0; i < 200; i++) {
-		if (!(b43_phy_read(dev, B43_NPHY_RFSEQST) & trigger[seq]))
-			goto ok;
-		msleep(1);
-	}
-	b43err(dev->wl, "RF sequence status timeout\n");
-ok:
-	b43_phy_write(dev, B43_NPHY_RFSEQMODE, seq_mode);
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlOverride */
-static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
-						u16 value, u8 core, bool off)
-{
-	int i;
-	u8 index = fls(field);
-	u8 addr, en_addr, val_addr;
-	/* we expect only one bit set */
-	B43_WARN_ON(field & (~(1 << (index - 1))));
-
-	if (dev->phy.rev >= 3) {
-		const struct nphy_rf_control_override_rev3 *rf_ctrl;
-		for (i = 0; i < 2; i++) {
-			if (index == 0 || index == 16) {
-				b43err(dev->wl,
-					"Unsupported RF Ctrl Override call\n");
-				return;
-			}
-
-			rf_ctrl = &tbl_rf_control_override_rev3[index - 1];
-			en_addr = B43_PHY_N((i == 0) ?
-				rf_ctrl->en_addr0 : rf_ctrl->en_addr1);
-			val_addr = B43_PHY_N((i == 0) ?
-				rf_ctrl->val_addr0 : rf_ctrl->val_addr1);
-
-			if (off) {
-				b43_phy_mask(dev, en_addr, ~(field));
-				b43_phy_mask(dev, val_addr,
-						~(rf_ctrl->val_mask));
-			} else {
-				if (core == 0 || ((1 << core) & i) != 0) {
-					b43_phy_set(dev, en_addr, field);
-					b43_phy_maskset(dev, val_addr,
-						~(rf_ctrl->val_mask),
-						(value << rf_ctrl->val_shift));
-				}
-			}
-		}
-	} else {
-		const struct nphy_rf_control_override_rev2 *rf_ctrl;
-		if (off) {
-			b43_phy_mask(dev, B43_NPHY_RFCTL_OVER, ~(field));
-			value = 0;
-		} else {
-			b43_phy_set(dev, B43_NPHY_RFCTL_OVER, field);
-		}
-
-		for (i = 0; i < 2; i++) {
-			if (index <= 1 || index == 16) {
-				b43err(dev->wl,
-					"Unsupported RF Ctrl Override call\n");
-				return;
-			}
-
-			if (index == 2 || index == 10 ||
-			    (index >= 13 && index <= 15)) {
-				core = 1;
-			}
-
-			rf_ctrl = &tbl_rf_control_override_rev2[index - 2];
-			addr = B43_PHY_N((i == 0) ?
-				rf_ctrl->addr0 : rf_ctrl->addr1);
-
-			if ((core & (1 << i)) != 0)
-				b43_phy_maskset(dev, addr, ~(rf_ctrl->bmask),
-						(value << rf_ctrl->shift));
-
-			b43_phy_set(dev, B43_NPHY_RFCTL_OVER, 0x1);
-			b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
-					B43_NPHY_RFCTL_CMD_START);
-			udelay(1);
-			b43_phy_mask(dev, B43_NPHY_RFCTL_OVER, 0xFFFE);
-		}
-	}
-}
-
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlIntcOverride */
-static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
-						u16 value, u8 core)
-{
-	u8 i, j;
-	u16 reg, tmp, val;
-
-	B43_WARN_ON(dev->phy.rev < 3);
-	B43_WARN_ON(field > 4);
-
-	for (i = 0; i < 2; i++) {
-		if ((core == 1 && i == 1) || (core == 2 && !i))
-			continue;
-
-		reg = (i == 0) ?
-			B43_NPHY_RFCTL_INTC1 : B43_NPHY_RFCTL_INTC2;
-		b43_phy_mask(dev, reg, 0xFBFF);
-
-		switch (field) {
-		case 0:
-			b43_phy_write(dev, reg, 0);
-			b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
-			break;
-		case 1:
-			if (!i) {
-				b43_phy_maskset(dev, B43_NPHY_RFCTL_INTC1,
-						0xFC3F, (value << 6));
-				b43_phy_maskset(dev, B43_NPHY_TXF_40CO_B1S1,
-						0xFFFE, 1);
-				b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
-						B43_NPHY_RFCTL_CMD_START);
-				for (j = 0; j < 100; j++) {
-					if (b43_phy_read(dev, B43_NPHY_RFCTL_CMD) & B43_NPHY_RFCTL_CMD_START) {
-						j = 0;
-						break;
-					}
-					udelay(10);
-				}
-				if (j)
-					b43err(dev->wl,
-						"intc override timeout\n");
-				b43_phy_mask(dev, B43_NPHY_TXF_40CO_B1S1,
-						0xFFFE);
-			} else {
-				b43_phy_maskset(dev, B43_NPHY_RFCTL_INTC2,
-						0xFC3F, (value << 6));
-				b43_phy_maskset(dev, B43_NPHY_RFCTL_OVER,
-						0xFFFE, 1);
-				b43_phy_set(dev, B43_NPHY_RFCTL_CMD,
-						B43_NPHY_RFCTL_CMD_RXTX);
-				for (j = 0; j < 100; j++) {
-					if (b43_phy_read(dev, B43_NPHY_RFCTL_CMD) & B43_NPHY_RFCTL_CMD_RXTX) {
-						j = 0;
-						break;
-					}
-					udelay(10);
-				}
-				if (j)
-					b43err(dev->wl,
-						"intc override timeout\n");
-				b43_phy_mask(dev, B43_NPHY_RFCTL_OVER,
-						0xFFFE);
-			}
-			break;
-		case 2:
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
-				tmp = 0x0020;
-				val = value << 5;
-			} else {
-				tmp = 0x0010;
-				val = value << 4;
-			}
-			b43_phy_maskset(dev, reg, ~tmp, val);
-			break;
-		case 3:
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
-				tmp = 0x0001;
-				val = value;
-			} else {
-				tmp = 0x0004;
-				val = value << 2;
-			}
-			b43_phy_maskset(dev, reg, ~tmp, val);
-			break;
-		case 4:
-			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
-				tmp = 0x0002;
-				val = value << 1;
-			} else {
-				tmp = 0x0008;
-				val = value << 3;
-			}
-			b43_phy_maskset(dev, reg, ~tmp, val);
-			break;
-		}
-	}
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/BPHYInit */
 static void b43_nphy_bphy_init(struct b43_wldev *dev)
 {
@@ -2846,24 +2863,6 @@ static void b43_nphy_restore_rssi_cal(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_RSSIMC_1Q_RSSI_Y, rssical_phy_regs[11]);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GetIpaGainTbl */
-static const u32 *b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
-{
-	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
-		if (dev->phy.rev >= 6) {
-			if (dev->dev->chip_id == 47162)
-				return txpwrctrl_tx_gain_ipa_rev5;
-			return txpwrctrl_tx_gain_ipa_rev6;
-		} else if (dev->phy.rev >= 5) {
-			return txpwrctrl_tx_gain_ipa_rev5;
-		} else {
-			return txpwrctrl_tx_gain_ipa;
-		}
-	} else {
-		return txpwrctrl_tx_gain_ipa_5g;
-	}
-}
-
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxCalRadioSetup */
 static void b43_nphy_tx_cal_radio_setup(struct b43_wldev *dev)
 {
-- 
1.7.7

