Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:39669 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab0AJWLx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 17:11:53 -0500
Received: by mail-ew0-f214.google.com with SMTP id 6so21225297ewy.29
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jan 2010 14:11:50 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sun, 10 Jan 2010 23:13:20 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 2/6] b43: N-PHY: add RSSI functions: poll and set 2055 vcm
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6b70ig59lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   96 ++++++++++++++++++++++++++++++++++++++
  1 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index a44fca1..d7e408b 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -711,6 +711,102 @@ static void b43_nphy_rssi_select(struct b43_wldev *dev, u8 code, u8 type)
  	}
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetRssi2055Vcm */
+static void b43_nphy_set_rssi_2055_vcm(struct b43_wldev *dev, u8 type, u8 *buf)
+{
+	int i;
+	for (i = 0; i < 2; i++) {
+		if (type == 2) {
+			if (i == 0) {
+				b43_radio_maskset(dev, B2055_C1_B0NB_RSSIVCM,
+						  0xFC, buf[0]);
+				b43_radio_maskset(dev, B2055_C1_RX_BB_RSSICTL5,
+						  0xFC, buf[1]);
+			} else {
+				b43_radio_maskset(dev, B2055_C2_B0NB_RSSIVCM,
+						  0xFC, buf[2 * i]);
+				b43_radio_maskset(dev, B2055_C2_RX_BB_RSSICTL5,
+						  0xFC, buf[2 * i + 1]);
+			}
+		} else {
+			if (i == 0)
+				b43_radio_maskset(dev, B2055_C1_RX_BB_RSSICTL5,
+						  0xF3, buf[0] << 2);
+			else
+				b43_radio_maskset(dev, B2055_C2_RX_BB_RSSICTL5,
+						  0xF3, buf[2 * i + 1] << 2);
+		}
+	}
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/PollRssi */
+static int b43_nphy_poll_rssi(struct b43_wldev *dev, u8 type, s32 *buf,
+				u8 nsamp)
+{
+	int i;
+	int out;
+	u16 save_regs_phy[9];
+	u16 s[2];
+
+	if (dev->phy.rev >= 3) {
+		save_regs_phy[0] = b43_phy_read(dev,
+						B43_NPHY_RFCTL_LUT_TRSW_UP1);
+		save_regs_phy[1] = b43_phy_read(dev,
+						B43_NPHY_RFCTL_LUT_TRSW_UP2);
+		save_regs_phy[2] = b43_phy_read(dev, B43_NPHY_AFECTL_C1);
+		save_regs_phy[3] = b43_phy_read(dev, B43_NPHY_AFECTL_C2);
+		save_regs_phy[4] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER1);
+		save_regs_phy[5] = b43_phy_read(dev, B43_NPHY_AFECTL_OVER);
+		save_regs_phy[6] = b43_phy_read(dev, B43_NPHY_TXF_40CO_B1S0);
+		save_regs_phy[7] = b43_phy_read(dev, B43_NPHY_TXF_40CO_B32S1);
+	}
+
+	b43_nphy_rssi_select(dev, 5, type);
+
+	if (dev->phy.rev < 2) {
+		save_regs_phy[8] = b43_phy_read(dev, B43_NPHY_GPIO_SEL);
+		b43_phy_write(dev, B43_NPHY_GPIO_SEL, 5);
+	}
+
+	for (i = 0; i < 4; i++)
+		buf[i] = 0;
+
+	for (i = 0; i < nsamp; i++) {
+		if (dev->phy.rev < 2) {
+			s[0] = b43_phy_read(dev, B43_NPHY_GPIO_LOOUT);
+			s[1] = b43_phy_read(dev, B43_NPHY_GPIO_HIOUT);
+		} else {
+			s[0] = b43_phy_read(dev, B43_NPHY_RSSI1);
+			s[1] = b43_phy_read(dev, B43_NPHY_RSSI2);
+		}
+
+		buf[0] += (s8)(((s[0] & 0x3F) << 2) >> 2);
+		buf[1] += (s8)((((s[0] >> 8) & 0x3F) << 2) >> 2);
+		buf[2] += (s8)(((s[1] & 0x3F) << 2) >> 2);
+		buf[3] += (s8)((((s[1] >> 8) & 0x3F) << 2) >> 2);
+	}
+	out = (buf[0] & 0xFF) << 24 | (buf[1] & 0xFF) << 16 |
+		(buf[2] & 0xFF) << 8 | (buf[3] & 0xFF);
+
+	if (dev->phy.rev < 2)
+		b43_phy_write(dev, B43_NPHY_GPIO_SEL, save_regs_phy[8]);
+
+	if (dev->phy.rev >= 3) {
+		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP1,
+				save_regs_phy[0]);
+		b43_phy_write(dev, B43_NPHY_RFCTL_LUT_TRSW_UP2,
+				save_regs_phy[1]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_C1, save_regs_phy[2]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_C2, save_regs_phy[3]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_OVER1, save_regs_phy[4]);
+		b43_phy_write(dev, B43_NPHY_AFECTL_OVER, save_regs_phy[5]);
+		b43_phy_write(dev, B43_NPHY_TXF_40CO_B1S0, save_regs_phy[6]);
+		b43_phy_write(dev, B43_NPHY_TXF_40CO_B32S1, save_regs_phy[7]);
+	}
+
+	return out;
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RSSICal */
  static void b43_nphy_rev2_rssi_cal(struct b43_wldev *dev, u8 type)
  {
-- 
1.6.4.2

