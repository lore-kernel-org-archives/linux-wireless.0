Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:52190 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbaDTLGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 07:06:14 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so2921087eek.20
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 04:06:13 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 5/9] b43: N-PHY: implement RF control INTC for revs 7+
Date: Sun, 20 Apr 2014 13:05:47 +0200
Message-Id: <1397991951-13478-6-git-send-email-zajec5@gmail.com> (sfid-20140420_130654_440506_A2950F48)
In-Reply-To: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
References: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This patch cause a small "line over 80 characters" warning that I think
we can accept to keep code cleaner.
---
 drivers/net/wireless/b43/phy_n.c | 72 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 3d13e73..0d4067e 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -257,6 +257,72 @@ static void b43_nphy_rf_ctl_override(struct b43_wldev *dev, u16 field,
 	}
 }
 
+static void b43_nphy_rf_ctl_intc_override_rev7(struct b43_wldev *dev,
+					       enum n_intc_override intc_override,
+					       u16 value, u8 core_sel)
+{
+	u16 reg, tmp, tmp2, val;
+	int core;
+
+	for (core = 0; core < 2; core++) {
+		if ((core_sel == 1 && core != 0) ||
+		    (core_sel == 2 && core != 1))
+			continue;
+
+		reg = (core == 0) ? B43_NPHY_RFCTL_INTC1 : B43_NPHY_RFCTL_INTC2;
+
+		switch (intc_override) {
+		case N_INTC_OVERRIDE_OFF:
+			b43_phy_write(dev, reg, 0);
+			b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
+			break;
+		case N_INTC_OVERRIDE_TRSW:
+			b43_phy_maskset(dev, reg, ~0xC0, value << 6);
+			b43_phy_set(dev, reg, 0x400);
+
+			b43_phy_mask(dev, 0x2ff, ~0xC000 & 0xFFFF);
+			b43_phy_set(dev, 0x2ff, 0x2000);
+			b43_phy_set(dev, 0x2ff, 0x0001);
+			break;
+		case N_INTC_OVERRIDE_PA:
+			tmp = 0x0030;
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ)
+				val = value << 5;
+			else
+				val = value << 4;
+			b43_phy_maskset(dev, reg, ~tmp, val);
+			b43_phy_set(dev, reg, 0x1000);
+			break;
+		case N_INTC_OVERRIDE_EXT_LNA_PU:
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+				tmp = 0x0001;
+				tmp2 = 0x0004;
+				val = value;
+			} else {
+				tmp = 0x0004;
+				tmp2 = 0x0001;
+				val = value << 2;
+			}
+			b43_phy_maskset(dev, reg, ~tmp, val);
+			b43_phy_mask(dev, reg, ~tmp2);
+			break;
+		case N_INTC_OVERRIDE_EXT_LNA_GAIN:
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) {
+				tmp = 0x0002;
+				tmp2 = 0x0008;
+				val = value << 1;
+			} else {
+				tmp = 0x0008;
+				tmp2 = 0x0002;
+				val = value << 3;
+			}
+			b43_phy_maskset(dev, reg, ~tmp, val);
+			b43_phy_mask(dev, reg, ~tmp2);
+			break;
+		}
+	}
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/RFCtrlIntcOverride */
 static void b43_nphy_rf_ctl_intc_override(struct b43_wldev *dev,
 					  enum n_intc_override intc_override,
@@ -265,6 +331,12 @@ static void b43_nphy_rf_ctl_intc_override(struct b43_wldev *dev,
 	u8 i, j;
 	u16 reg, tmp, val;
 
+	if (dev->phy.rev >= 7) {
+		b43_nphy_rf_ctl_intc_override_rev7(dev, intc_override, value,
+						   core);
+		return;
+	}
+
 	B43_WARN_ON(dev->phy.rev < 3);
 
 	for (i = 0; i < 2; i++) {
-- 
1.8.4.5

