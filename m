Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59028 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2ADXYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 18:24:11 -0500
Received: by eekc4 with SMTP id c4so17070386eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2012 15:24:09 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 4/5] b43: N-PHY: implement RSSI calibration for rev3+
Date: Thu,  5 Jan 2012 01:05:30 +0100
Message-Id: <1325721930-3525-1-git-send-email-zajec5@gmail.com> (sfid-20120105_002415_174782_7B85AF6D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: fix typo in argument being not a variable increased by for(){}
add one missing b43_nphy_scale_offset_rssi call
---
 drivers/net/wireless/b43/phy_n.c |  193 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 187 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index c4c310d..06a9cd0 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -85,6 +85,13 @@ static inline bool b43_nphy_ipa(struct b43_wldev *dev)
 		(dev->phy.n->ipa5g_on && band == IEEE80211_BAND_5GHZ));
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RxCoreGetState */
+static u8 b43_nphy_get_rx_core_state(struct b43_wldev *dev)
+{
+	return (b43_phy_read(dev, B43_NPHY_RFSEQCA) & B43_NPHY_RFSEQCA_RXEN) >>
+		B43_NPHY_RFSEQCA_RXEN_SHIFT;
+}
+
 /**************************************************
  * RF (just without b43_nphy_rf_control_intc_override)
  **************************************************/
@@ -1290,6 +1297,186 @@ static int b43_nphy_poll_rssi(struct b43_wldev *dev, u8 type, s32 *buf,
 	return out;
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICalRev3 */
+static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	u16 saved_regs_phy_rfctl[2];
+	u16 saved_regs_phy[13];
+	u16 regs_to_store[] = {
+		B43_NPHY_AFECTL_OVER1, B43_NPHY_AFECTL_OVER,
+		B43_NPHY_AFECTL_C1, B43_NPHY_AFECTL_C2,
+		B43_NPHY_TXF_40CO_B1S1, B43_NPHY_RFCTL_OVER,
+		B43_NPHY_TXF_40CO_B1S0, B43_NPHY_TXF_40CO_B32S1,
+		B43_NPHY_RFCTL_CMD,
+		B43_NPHY_RFCTL_LUT_TRSW_UP1, B43_NPHY_RFCTL_LUT_TRSW_UP2,
+		B43_NPHY_RFCTL_RSSIO1, B43_NPHY_RFCTL_RSSIO2
+	};
+
+	u16 class;
+
+	u16 clip_state[2];
+	u16 clip_off[2] = { 0xFFFF, 0xFFFF };
+
+	u8 vcm_final = 0;
+	s8 offset[4];
+	s32 results[8][4] = { };
+	s32 results_min[4] = { };
+	s32 poll_results[4] = { };
+
+	u16 *rssical_radio_regs = NULL;
+	u16 *rssical_phy_regs = NULL;
+
+	u16 r; /* routing */
+	u8 rx_core_state;
+	u8 core, i, j;
+
+	class = b43_nphy_classifier(dev, 0, 0);
+	b43_nphy_classifier(dev, 7, 4);
+	b43_nphy_read_clip_detection(dev, clip_state);
+	b43_nphy_write_clip_detection(dev, clip_off);
+
+	saved_regs_phy_rfctl[0] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC1);
+	saved_regs_phy_rfctl[1] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC2);
+	for (i = 0; i < ARRAY_SIZE(regs_to_store); i++)
+		saved_regs_phy[i] = b43_phy_read(dev, regs_to_store[i]);
+
+	b43_nphy_rf_control_intc_override(dev, 0, 0, 7);
+	b43_nphy_rf_control_intc_override(dev, 1, 1, 7);
+	b43_nphy_rf_control_override(dev, 0x1, 0, 0, false);
+	b43_nphy_rf_control_override(dev, 0x2, 1, 0, false);
+	b43_nphy_rf_control_override(dev, 0x80, 1, 0, false);
+	b43_nphy_rf_control_override(dev, 0x40, 1, 0, false);
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+		b43_nphy_rf_control_override(dev, 0x20, 0, 0, false);
+		b43_nphy_rf_control_override(dev, 0x10, 1, 0, false);
+	} else {
+		b43_nphy_rf_control_override(dev, 0x10, 0, 0, false);
+		b43_nphy_rf_control_override(dev, 0x20, 1, 0, false);
+	}
+
+	rx_core_state = b43_nphy_get_rx_core_state(dev);
+	for (core = 0; core < 2; core++) {
+		if (!(rx_core_state & (1 << core)))
+			continue;
+		r = core ? B2056_RX1 : B2056_RX0;
+		b43_nphy_scale_offset_rssi(dev, 0, 0, core + 1, 0, 2);
+		b43_nphy_scale_offset_rssi(dev, 0, 0, core + 1, 1, 2);
+		for (i = 0; i < 8; i++) {
+			b43_radio_maskset(dev, r | B2056_RX_RSSI_MISC, 0xE3,
+					i << 2);
+			b43_nphy_poll_rssi(dev, 2, results[i], 8);
+		}
+		for (i = 0; i < 4; i++) {
+			s32 curr;
+			s32 mind = 40;
+			s32 minpoll = 249;
+			u8 minvcm = 0;
+			if (2 * core != i)
+				continue;
+			for (j = 0; j < 8; j++) {
+				curr = results[j][i] * results[j][i] +
+					results[j][i + 1] * results[j][i];
+				if (curr < mind) {
+					mind = curr;
+					minvcm = j;
+				}
+				if (results[j][i] < minpoll)
+					minpoll = results[j][i];
+			}
+			vcm_final = minvcm;
+			results_min[i] = minpoll;
+		}
+		b43_radio_maskset(dev, r | B2056_RX_RSSI_MISC, 0xE3,
+				  vcm_final << 2);
+		for (i = 0; i < 4; i++) {
+			if (core != i / 2)
+				continue;
+			offset[i] = -results[vcm_final][i];
+			if (offset[i] < 0)
+				offset[i] = -((abs(offset[i]) + 4) / 8);
+			else
+				offset[i] = (offset[i] + 4) / 8;
+			if (results_min[i] == 248)
+				offset[i] = -32;
+			b43_nphy_scale_offset_rssi(dev, 0, offset[i],
+						   (i / 2 == 0) ? 1 : 2,
+						   (i % 2 == 0) ? 0 : 1,
+						   2);
+		}
+	}
+	for (core = 0; core < 2; core++) {
+		if (!(rx_core_state & (1 << core)))
+			continue;
+		for (i = 0; i < 2; i++) {
+			b43_nphy_scale_offset_rssi(dev, 0, 0, core + 1, 0, i);
+			b43_nphy_scale_offset_rssi(dev, 0, 0, core + 1, 1, i);
+			b43_nphy_poll_rssi(dev, i, poll_results, 8);
+			for (j = 0; j < 4; j++) {
+				if (j / 2 == core)
+					offset[j] = 232 - poll_results[j];
+				if (offset[j] < 0)
+					offset[j] = -(abs(offset[j] + 4) / 8);
+				else
+					offset[j] = (offset[j] + 4) / 8;
+				b43_nphy_scale_offset_rssi(dev, 0,
+					offset[2 * core], core + 1, j % 2, i);
+			}
+		}
+	}
+
+	b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, saved_regs_phy_rfctl[0]);
+	b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, saved_regs_phy_rfctl[1]);
+
+	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
+
+	b43_phy_set(dev, B43_NPHY_TXF_40CO_B1S1, 0x1);
+	b43_phy_set(dev, B43_NPHY_RFCTL_CMD, B43_NPHY_RFCTL_CMD_START);
+	b43_phy_mask(dev, B43_NPHY_TXF_40CO_B1S1, ~0x1);
+
+	b43_phy_set(dev, B43_NPHY_RFCTL_OVER, 0x1);
+	b43_phy_set(dev, B43_NPHY_RFCTL_CMD, B43_NPHY_RFCTL_CMD_RXTX);
+	b43_phy_mask(dev, B43_NPHY_TXF_40CO_B1S1, ~0x1);
+
+	for (i = 0; i < ARRAY_SIZE(regs_to_store); i++)
+		b43_phy_write(dev, regs_to_store[i], saved_regs_phy[i]);
+
+	/* Store for future configuration */
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		rssical_radio_regs = nphy->rssical_cache.rssical_radio_regs_2G;
+		rssical_phy_regs = nphy->rssical_cache.rssical_phy_regs_2G;
+	} else {
+		rssical_radio_regs = nphy->rssical_cache.rssical_radio_regs_5G;
+		rssical_phy_regs = nphy->rssical_cache.rssical_phy_regs_5G;
+	}
+	rssical_radio_regs[0] = b43_radio_read(dev, 0x602B);
+	rssical_radio_regs[0] = b43_radio_read(dev, 0x702B);
+	rssical_phy_regs[0] = b43_phy_read(dev, B43_NPHY_RSSIMC_0I_RSSI_Z);
+	rssical_phy_regs[1] = b43_phy_read(dev, B43_NPHY_RSSIMC_0Q_RSSI_Z);
+	rssical_phy_regs[2] = b43_phy_read(dev, B43_NPHY_RSSIMC_1I_RSSI_Z);
+	rssical_phy_regs[3] = b43_phy_read(dev, B43_NPHY_RSSIMC_1Q_RSSI_Z);
+	rssical_phy_regs[4] = b43_phy_read(dev, B43_NPHY_RSSIMC_0I_RSSI_X);
+	rssical_phy_regs[5] = b43_phy_read(dev, B43_NPHY_RSSIMC_0Q_RSSI_X);
+	rssical_phy_regs[6] = b43_phy_read(dev, B43_NPHY_RSSIMC_1I_RSSI_X);
+	rssical_phy_regs[7] = b43_phy_read(dev, B43_NPHY_RSSIMC_1Q_RSSI_X);
+	rssical_phy_regs[8] = b43_phy_read(dev, B43_NPHY_RSSIMC_0I_RSSI_Y);
+	rssical_phy_regs[9] = b43_phy_read(dev, B43_NPHY_RSSIMC_0Q_RSSI_Y);
+	rssical_phy_regs[10] = b43_phy_read(dev, B43_NPHY_RSSIMC_1I_RSSI_Y);
+	rssical_phy_regs[11] = b43_phy_read(dev, B43_NPHY_RSSIMC_1Q_RSSI_Y);
+
+	/* Remember for which channel we store configuration */
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		nphy->rssical_chanspec_2G.center_freq = dev->phy.channel_freq;
+	else
+		nphy->rssical_chanspec_5G.center_freq = dev->phy.channel_freq;
+
+	/* End of calibration, restore configuration */
+	b43_nphy_classifier(dev, 7, class);
+	b43_nphy_write_clip_detection(dev, clip_state);
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal */
 static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
 {
@@ -1454,12 +1641,6 @@ static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
 	b43_nphy_reset_cca(dev);
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICalRev3 */
-static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
-{
-	/* TODO */
-}
-
 /*
  * RSSI Calibration
  * http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal
-- 
1.7.3.4

