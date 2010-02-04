Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:17274 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab0BDLaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 06:30:20 -0500
Received: by fg-out-1718.google.com with SMTP id 19so30056fgg.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2010 03:30:19 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/5] b43: N-PHY: prepare code for reapplying TX cal coeffs
Date: Thu,  4 Feb 2010 12:23:10 +0100
Message-Id: <1265282592-25491-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1265282592-25491-1-git-send-email-zajec5@gmail.com>
References: <1265282592-25491-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 89e9d66..e8266ed 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2611,6 +2611,39 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 	return error;
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/ReapplyTxCalCoeffs */
+static void b43_nphy_reapply_tx_cal_coeffs(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	u8 i;
+	u16 buffer[7];
+	bool equal = true;
+
+	if (!nphy->txiqlocal_coeffsvalid || 1 /* FIXME */)
+		return;
+
+	b43_ntab_read_bulk(dev, B43_NTAB16(15, 80), 7, buffer);
+	for (i = 0; i < 4; i++) {
+		if (buffer[i] != nphy->txiqlocal_bestc[i]) {
+			equal = false;
+			break;
+		}
+	}
+
+	if (!equal) {
+		b43_ntab_write_bulk(dev, B43_NTAB16(15, 80), 4,
+					nphy->txiqlocal_bestc);
+		for (i = 0; i < 4; i++)
+			buffer[i] = 0;
+		b43_ntab_write_bulk(dev, B43_NTAB16(15, 88), 4,
+					buffer);
+		b43_ntab_write_bulk(dev, B43_NTAB16(15, 85), 2,
+					&nphy->txiqlocal_bestc[5]);
+		b43_ntab_write_bulk(dev, B43_NTAB16(15, 93), 2,
+					&nphy->txiqlocal_bestc[5]);
+	}
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalRxIqRev2 */
 static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
 			struct nphy_txgains target, u8 type, bool debug)
@@ -2641,7 +2674,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
 	b43_nphy_stay_in_carrier_search(dev, 1);
 
 	if (dev->phy.rev < 2)
-		;/* TODO: Call N PHY Reapply TX Cal Coeffs */
+		b43_nphy_reapply_tx_cal_coeffs(dev);
 	b43_ntab_read_bulk(dev, B43_NTAB16(7, 0x110), 2, gain_save);
 	for (i = 0; i < 2; i++) {
 		b43_nphy_iq_cal_gain_params(dev, i, target, &cal_params[i]);
-- 
1.6.4.2

