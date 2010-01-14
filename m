Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62654 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719Ab0ANWmr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 17:42:47 -0500
Received: by fxm25 with SMTP id 25so56513fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 14:42:46 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 14 Jan 2010 23:42:44 +0100
Subject: [PATCH 1/6] b43: N-PHY: add b43_nphy_calc_rx_iq_comp
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6jn1ijm9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |  101 +++++++++++++++++++++++++++++++++++++-
  1 files changed, 100 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index fbdabfe..75eb0e6 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -533,6 +533,105 @@ static void b43_nphy_rx_iq_est(struct b43_wldev *dev, struct nphy_iq_est *est,
  	memset(est, 0, sizeof(*est));
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalcRxIqComp */
+static void b43_nphy_calc_rx_iq_comp(struct b43_wldev *dev, u8 mask)
+{
+	int i;
+	s32 iq;
+	u32 ii;
+	u32 qq;
+	int iq_nbits, qq_nbits;
+	int arsh, brsh;
+	u16 tmp, a, b;
+
+	struct nphy_iq_est est;
+	struct b43_phy_n_iq_comp old;
+	struct b43_phy_n_iq_comp new = { };
+	bool error = false;
+
+	if (mask == 0)
+		return;
+
+	b43_nphy_rx_iq_coeffs(dev, false, &old);
+	b43_nphy_rx_iq_coeffs(dev, true, &new);
+	b43_nphy_rx_iq_est(dev, &est, 0x4000, 32, false);
+	new = old;
+
+	for (i = 0; i < 2; i++) {
+		if (i == 0 && (mask & 1)) {
+			iq = est.iq0_prod;
+			ii = est.i0_pwr;
+			qq = est.q0_pwr;
+		} else if (i == 1 && (mask & 2)) {
+			iq = est.iq1_prod;
+			ii = est.i1_pwr;
+			qq = est.q1_pwr;
+		} else {
+			B43_WARN_ON(1);
+			continue;
+		}
+
+		if (ii + qq < 2) {
+			error = true;
+			break;
+		}
+
+		iq_nbits = phy_nbits(iq);
+		qq_nbits = phy_nbits(qq);
+
+		arsh = iq_nbits - 20;
+		if (arsh >= 0) {
+			a = -((iq << (30 - iq_nbits)) + (ii >> (1 + arsh)));
+			tmp = ii >> arsh;
+		} else {
+			a = -((iq << (30 - iq_nbits)) + (ii << (-1 - arsh)));
+			tmp = ii << -arsh;
+		}
+		if (tmp == 0) {
+			error = true;
+			break;
+		}
+		a /= tmp;
+
+		brsh = qq_nbits - 11;
+		if (brsh >= 0) {
+			b = (qq << (31 - qq_nbits));
+			tmp = ii >> brsh;
+		} else {
+			b = (qq << (31 - qq_nbits));
+			tmp = ii << -brsh;
+		}
+		if (tmp == 0) {
+			error = true;
+			break;
+		}
+		b = int_sqrt(b / tmp - a * a) - (1 << 10);
+
+		if (i == 0 && (mask & 0x1)) {
+			if (dev->phy.rev >= 3) {
+				new.a0 = a & 0x3FF;
+				new.b0 = b & 0x3FF;
+			} else {
+				new.a0 = b & 0x3FF;
+				new.b0 = a & 0x3FF;
+			}
+		} else if (i == 1 && (mask & 0x2)) {
+			if (dev->phy.rev >= 3) {
+				new.a1 = a & 0x3FF;
+				new.b1 = b & 0x3FF;
+			} else {
+				new.a1 = b & 0x3FF;
+				new.b1 = a & 0x3FF;
+			}
+		}
+	}
+
+	if (error)
+		new = old;
+
+	b43_nphy_rx_iq_coeffs(dev, true, &new);
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/IqCalGainParams */
  static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
  					struct nphy_txgains target,
@@ -734,7 +833,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
  					}
  					power[i] = ((real + imag) / 1024) + 1;
  				} else {
-					//TODO: Call N PHY Calc RX IQ Comp with (1 << i) as argument
+					b43_nphy_calc_rx_iq_comp(dev, 1 << i);
  				}
  				//TODO: Call N PHY Stop Playback
  			}
-- 
1.6.4.2

