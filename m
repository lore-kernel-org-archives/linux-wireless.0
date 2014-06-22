Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:53263 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaFVVSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2014 17:18:41 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so6021874wes.32
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2014 14:18:40 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: N-PHY: update low-pass filter setup
Date: Sun, 22 Jun 2014 23:18:22 +0200
Message-Id: <1403471902-12731-2-git-send-email-zajec5@gmail.com> (sfid-20140622_231857_011067_633A1319)
In-Reply-To: <1403471902-12731-1-git-send-email-zajec5@gmail.com>
References: <1403471902-12731-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for external PA and clean code a bit.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d9409b4..0fb5e14 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3706,21 +3706,28 @@ static void b43_nphy_pa_override(struct b43_wldev *dev, bool enable)
 	}
 }
 
-/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxLpFbw */
-static void b43_nphy_tx_lp_fbw(struct b43_wldev *dev)
+/*
+ * TX low-pass filter bandwidth setup
+ * http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxLpFbw
+ */
+static void b43_nphy_tx_lpf_bw(struct b43_wldev *dev)
 {
 	u16 tmp;
 
-	if (dev->phy.rev >= 3) {
-		if (b43_nphy_ipa(dev)) {
-			tmp = 4;
-			b43_phy_write(dev, B43_NPHY_TXF_40CO_B32S2,
-			      (((((tmp << 3) | tmp) << 3) | tmp) << 3) | tmp);
-		}
+	if (dev->phy.rev < 3 || dev->phy.rev >= 7)
+		return;
 
-		tmp = 1;
+	if (b43_nphy_ipa(dev))
+		tmp = b43_is_40mhz(dev) ? 5 : 4;
+	else
+		tmp = b43_is_40mhz(dev) ? 3 : 1;
+	b43_phy_write(dev, B43_NPHY_TXF_40CO_B32S2,
+		      (tmp << 9) | (tmp << 6) | (tmp << 3) | tmp);
+
+	if (b43_nphy_ipa(dev)) {
+		tmp = b43_is_40mhz(dev) ? 4 : 1;
 		b43_phy_write(dev, B43_NPHY_TXF_40CO_B1S2,
-			      (((((tmp << 3) | tmp) << 3) | tmp) << 3) | tmp);
+			      (tmp << 9) | (tmp << 6) | (tmp << 3) | tmp);
 	}
 }
 
@@ -5347,7 +5354,7 @@ static int b43_phy_initn(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_TXMACDELAY, 0x0320);
 	if (phy->rev >= 3 && phy->rev <= 6)
 		b43_phy_write(dev, B43_NPHY_PLOAD_CSENSE_EXTLEN, 0x0032);
-	b43_nphy_tx_lp_fbw(dev);
+	b43_nphy_tx_lpf_bw(dev);
 	if (phy->rev >= 3)
 		b43_nphy_spur_workaround(dev);
 
@@ -5433,7 +5440,7 @@ static void b43_nphy_channel_setup(struct b43_wldev *dev,
 	if (dev->phy.rev < 3)
 		b43_nphy_adjust_lna_gain_table(dev);
 
-	b43_nphy_tx_lp_fbw(dev);
+	b43_nphy_tx_lpf_bw(dev);
 
 	if (dev->phy.rev >= 3 &&
 	    dev->phy.n->spur_avoid != B43_SPUR_AVOID_DISABLE) {
-- 
1.8.4.5

