Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:49566 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab0AKVSf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 16:18:35 -0500
Received: by mail-ew0-f209.google.com with SMTP id 1so3724154ewy.28
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2010 13:18:34 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Mon, 11 Jan 2010 22:18:31 +0100
Subject: [PATCH 3/6 V2] b43: N-PHY: add RSSI calculation for PHY rev < 3
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6dz45nl9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com
---
  drivers/net/wireless/b43/phy_n.c |  155 +++++++++++++++++++++++++++++++++++++-
  1 files changed, 154 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 214cf54..a0e6d81 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -810,7 +810,160 @@ static int b43_nphy_poll_rssi(struct b43_wldev *dev, u8 type, s32 *buf,
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal */
  static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
  {
-	//TODO
+	int i, j;
+	u8 state[4];
+	u8 code, val;
+	u16 class, override;
+	u8 regs_save_radio[2];
+	u16 regs_save_phy[2];
+	s8 offset[4];
+
+	u16 clip_state[2];
+	u16 clip_off[2] = { 0xFFFF, 0xFFFF };
+	s32 results_min[4] = { 0, };
+	u8 vcm_final[4] = { 0, };
+	s32 results[4][4] = { { 0, }, { 0, }, { 0, }, { 0, } };
+	s32 miniq[4][2] = { { 0, }, { 0, }, { 0, }, { 0, } };
+
+	if (type == 2) {
+		code = 0;
+		val = 6;
+	} else if (type < 2) {
+		code = 25;
+		val = 4;
+	} else {
+		B43_WARN_ON(1);
+		return;
+	}
+
+	class = b43_nphy_classifier(dev, 0, 0);
+	b43_nphy_classifier(dev, 7, 4);
+	b43_nphy_read_clip_detection(dev, clip_state);
+	b43_nphy_write_clip_detection(dev, clip_off);
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+		override = 0x140;
+	else
+		override = 0x110;
+
+	regs_save_phy[0] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC1);
+	regs_save_radio[0] = b43_radio_read16(dev, B2055_C1_PD_RXTX);
+	b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, override);
+	b43_radio_write16(dev, B2055_C1_PD_RXTX, val);
+
+	regs_save_phy[1] = b43_phy_read(dev, B43_NPHY_RFCTL_INTC2);
+	regs_save_radio[1] = b43_radio_read16(dev, B2055_C2_PD_RXTX);
+	b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, override);
+	b43_radio_write16(dev, B2055_C2_PD_RXTX, val);
+
+	state[0] = b43_radio_read16(dev, B2055_C1_PD_RSSIMISC) & 0x07;
+	state[1] = b43_radio_read16(dev, B2055_C2_PD_RSSIMISC) & 0x07;
+	b43_radio_mask(dev, B2055_C1_PD_RSSIMISC, 0xF8);
+	b43_radio_mask(dev, B2055_C2_PD_RSSIMISC, 0xF8);
+	state[2] = b43_radio_read16(dev, B2055_C1_SP_RSSI) & 0x07;
+	state[3] = b43_radio_read16(dev, B2055_C2_SP_RSSI) & 0x07;
+
+	b43_nphy_rssi_select(dev, 5, type);
+	b43_nphy_scale_offset_rssi(dev, 0, 0, 5, 0, type);
+	b43_nphy_scale_offset_rssi(dev, 0, 0, 5, 1, type);
+
+	for (i = 0; i < 4; i++) {
+		u8 tmp[4];
+		for (j = 0; j < 4; j++)
+			tmp[j] = i;
+		if (type != 1)
+			b43_nphy_set_rssi_2055_vcm(dev, type, tmp);
+		b43_nphy_poll_rssi(dev, type, results[i], 8);
+		if (type < 2)
+			for (j = 0; j < 2; j++)
+				miniq[i][j] = min(results[i][2 * j],
+						results[i][2 * j + 1]);
+	}
+
+	for (i = 0; i < 4; i++) {
+		s32 mind = 40;
+		u8 minvcm = 0;
+		s32 minpoll = 249;
+		s32 curr;
+		for (j = 0; j < 4; j++) {
+			if (type == 2)
+				curr = abs(results[j][i]);
+			else
+				curr = abs(miniq[j][i / 2] - code * 8);
+
+			if (curr < mind) {
+				mind = curr;
+				minvcm = j;
+			}
+
+			if (results[j][i] < minpoll)
+				minpoll = results[j][i];
+		}
+		results_min[i] = minpoll;
+		vcm_final[i] = minvcm;
+	}
+
+	if (type != 1)
+		b43_nphy_set_rssi_2055_vcm(dev, type, vcm_final);
+
+	for (i = 0; i < 4; i++) {
+		offset[i] = (code * 8) - results[vcm_final[i]][i];
+
+		if (offset[i] < 0)
+			offset[i] = -((abs(offset[i]) + 4) / 8);
+		else
+			offset[i] = (offset[i] + 4) / 8;
+
+		if (results_min[i] == 248)
+			offset[i] = code - 32;
+
+		if (i % 2 == 0)
+			b43_nphy_scale_offset_rssi(dev, 0, offset[i], 1, 0,
+							type);
+		else
+			b43_nphy_scale_offset_rssi(dev, 0, offset[i], 2, 1,
+							type);
+	}
+
+	b43_radio_maskset(dev, B2055_C1_PD_RSSIMISC, 0xF8, state[0]);
+	b43_radio_maskset(dev, B2055_C1_PD_RSSIMISC, 0xF8, state[1]);
+
+	switch (state[2]) {
+	case 1:
+		b43_nphy_rssi_select(dev, 1, 2);
+		break;
+	case 4:
+		b43_nphy_rssi_select(dev, 1, 0);
+		break;
+	case 2:
+		b43_nphy_rssi_select(dev, 1, 1);
+		break;
+	default:
+		b43_nphy_rssi_select(dev, 1, 1);
+		break;
+	}
+
+	switch (state[3]) {
+	case 1:
+		b43_nphy_rssi_select(dev, 2, 2);
+		break;
+	case 4:
+		b43_nphy_rssi_select(dev, 2, 0);
+		break;
+	default:
+		b43_nphy_rssi_select(dev, 2, 1);
+		break;
+	}
+
+	b43_nphy_rssi_select(dev, 0, type);
+
+	b43_phy_write(dev, B43_NPHY_RFCTL_INTC1, regs_save_phy[0]);
+	b43_radio_write16(dev, B2055_C1_PD_RXTX, regs_save_radio[0]);
+	b43_phy_write(dev, B43_NPHY_RFCTL_INTC2, regs_save_phy[1]);
+	b43_radio_write16(dev, B2055_C2_PD_RXTX, regs_save_radio[1]);
+
+	b43_nphy_classifier(dev, 7, class);
+	b43_nphy_write_clip_detection(dev, clip_state);
  }

  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICalRev3 */
-- 
1.6.4.2

