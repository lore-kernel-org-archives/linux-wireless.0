Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:48984 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaDTLGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 07:06:11 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so2908523eek.41
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 04:06:10 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/9] b43: N-PHY: random updates and typo fixes all around
Date: Sun, 20 Apr 2014 13:05:45 +0200
Message-Id: <1397991951-13478-4-git-send-email-zajec5@gmail.com> (sfid-20140420_130649_698361_75C48774)
In-Reply-To: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
References: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index e9658ee..cbeb299 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -419,7 +419,8 @@ static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev, bool enable)
 		static const u16 clip[] = { 0xFFFF, 0xFFFF };
 		if (nphy->deaf_count++ == 0) {
 			nphy->classifier_state = b43_nphy_classifier(dev, 0, 0);
-			b43_nphy_classifier(dev, 0x7, 0);
+			b43_nphy_classifier(dev, 0x7,
+					    B43_NPHY_CLASSCTL_WAITEDEN);
 			b43_nphy_read_clip_detection(dev, nphy->clip_state);
 			b43_nphy_write_clip_detection(dev, clip);
 		}
@@ -1164,23 +1165,20 @@ static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
 	u16 seq_mode;
 	u32 tmp;
 
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, true);
+	b43_nphy_stay_in_carrier_search(dev, true);
 
 	if ((nphy->bb_mult_save & 0x80000000) == 0) {
 		tmp = b43_ntab_read(dev, B43_NTAB16(15, 87));
 		nphy->bb_mult_save = (tmp & 0xFFFF) | 0x80000000;
 	}
 
+	/* TODO: add modify_bbmult argument */
 	if (!dev->phy.is_40mhz)
 		tmp = 0x6464;
 	else
 		tmp = 0x4747;
 	b43_ntab_write(dev, B43_NTAB16(15, 87), tmp);
 
-	if (nphy->hang_avoid)
-		b43_nphy_stay_in_carrier_search(dev, false);
-
 	b43_phy_write(dev, B43_NPHY_SAMP_DEPCNT, (samps - 1));
 
 	if (loops != 0xFFFF)
@@ -1213,6 +1211,8 @@ static void b43_nphy_run_samples(struct b43_wldev *dev, u16 samps, u16 loops,
 		b43err(dev->wl, "run samples timeout\n");
 
 	b43_phy_write(dev, B43_NPHY_RFSEQMODE, seq_mode);
+
+	b43_nphy_stay_in_carrier_search(dev, false);
 }
 
 /**************************************************
@@ -1736,7 +1736,7 @@ static void b43_nphy_rev3_rssi_cal(struct b43_wldev *dev)
 
 	b43_phy_set(dev, B43_NPHY_RFCTL_OVER, 0x1);
 	b43_phy_set(dev, B43_NPHY_RFCTL_CMD, B43_NPHY_RFCTL_CMD_RXTX);
-	b43_phy_mask(dev, B43_NPHY_TXF_40CO_B1S1, ~0x1);
+	b43_phy_mask(dev, B43_NPHY_RFCTL_OVER, ~0x1);
 
 	for (i = 0; i < ARRAY_SIZE(regs_to_store); i++)
 		b43_phy_write(dev, regs_to_store[i], saved_regs_phy[i]);
@@ -2681,7 +2681,7 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	/* Dropped probably-always-true condition */
 	b43_phy_write(dev, B43_NPHY_ED_CRS40ASSERTTHRESH0, 0x03eb);
 	b43_phy_write(dev, B43_NPHY_ED_CRS40ASSERTTHRESH1, 0x03eb);
-	b43_phy_write(dev, B43_NPHY_ED_CRS40DEASSERTTHRESH1, 0x0341);
+	b43_phy_write(dev, B43_NPHY_ED_CRS40DEASSERTTHRESH0, 0x0341);
 	b43_phy_write(dev, B43_NPHY_ED_CRS40DEASSERTTHRESH1, 0x0341);
 	b43_phy_write(dev, B43_NPHY_ED_CRS20LASSERTTHRESH0, 0x042b);
 	b43_phy_write(dev, B43_NPHY_ED_CRS20LASSERTTHRESH1, 0x042b);
@@ -5205,7 +5205,7 @@ static int b43_phy_initn(struct b43_wldev *dev)
 	b43_phy_write(dev, B43_NPHY_TXMACIF_HOLDOFF, 0x0015);
 	b43_phy_write(dev, B43_NPHY_TXMACDELAY, 0x0320);
 	if (phy->rev >= 3 && phy->rev <= 6)
-		b43_phy_write(dev, B43_NPHY_PLOAD_CSENSE_EXTLEN, 0x0014);
+		b43_phy_write(dev, B43_NPHY_PLOAD_CSENSE_EXTLEN, 0x0032);
 	b43_nphy_tx_lp_fbw(dev);
 	if (phy->rev >= 3)
 		b43_nphy_spur_workaround(dev);
-- 
1.8.4.5

