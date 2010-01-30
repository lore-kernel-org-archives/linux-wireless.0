Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:65124 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab0A3TSX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 14:18:23 -0500
Received: by fg-out-1718.google.com with SMTP id l26so1263655fgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jan 2010 11:18:21 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/5] b43: N-PHY: fix Cal TX IQ LO for newer PHYs
Date: Sat, 30 Jan 2010 20:18:05 +0100
Message-Id: <1264879087-14326-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264879087-14326-1-git-send-email-zajec5@gmail.com>
References: <1264879087-14326-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 690aaad..cf107c5 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2229,7 +2229,17 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
 		(dev->phy.rev == 5 && nphy->ipa2g_on &&
 		b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ);
 	if (phy6or5x) {
-		/* TODO */
+		if (dev->phy.is_40mhz) {
+			b43_ntab_write_bulk(dev, B43_NTAB16(15, 0), 18,
+					tbl_tx_iqlo_cal_loft_ladder_40);
+			b43_ntab_write_bulk(dev, B43_NTAB16(15, 32), 18,
+					tbl_tx_iqlo_cal_iqimb_ladder_40);
+		} else {
+			b43_ntab_write_bulk(dev, B43_NTAB16(15, 0), 18,
+					tbl_tx_iqlo_cal_loft_ladder_20);
+			b43_ntab_write_bulk(dev, B43_NTAB16(15, 32), 18,
+					tbl_tx_iqlo_cal_iqimb_ladder_20);
+		}
 	}
 
 	b43_phy_write(dev, B43_NPHY_IQLOCAL_CMDGCTL, 0x8AA9);
-- 
1.6.4.2

