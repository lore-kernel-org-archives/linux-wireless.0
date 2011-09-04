Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39760 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1IDVV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Sep 2011 17:21:27 -0400
Received: by bke11 with SMTP id 11so4036793bke.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Sep 2011 14:21:26 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/4] b43: N-PHY: replace some hacks with nice tables ops
Date: Sun,  4 Sep 2011 23:23:51 +0200
Message-Id: <1315171433-26625-2-git-send-email-zajec5@gmail.com> (sfid-20110904_232130_031937_FA43582A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 40e436e..c291ae5 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -444,19 +444,14 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 		else
 			b43_phy_write(dev, B43_NPHY_AFECTL_DACGAIN2, dac_gain);
 
-		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x1D10 + i);
-		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, radio_gain);
-
-		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x3C57);
-		tmp = b43_phy_read(dev, B43_NPHY_TABLE_DATALO);
+		b43_ntab_write(dev, B43_NTAB16(0x7, 0x110 + i), radio_gain);
 
+		tmp = b43_ntab_read(dev, B43_NTAB16(0xF, 0x57));
 		if (i == 0)
 			tmp = (tmp & 0x00FF) | (bbmult << 8);
 		else
 			tmp = (tmp & 0xFF00) | bbmult;
-
-		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x3C57);
-		b43_phy_write(dev, B43_NPHY_TABLE_DATALO, tmp);
+		b43_ntab_write(dev, B43_NTAB16(0xF, 0x57), tmp);
 
 		if (0)
 			; /* TODO */
@@ -970,11 +965,7 @@ static void b43_nphy_calc_rx_iq_comp(struct b43_wldev *dev, u8 mask)
 static void b43_nphy_tx_iq_workaround(struct b43_wldev *dev)
 {
 	u16 array[4];
-	int i;
-
-	b43_phy_write(dev, B43_NPHY_TABLE_ADDR, 0x3C50);
-	for (i = 0; i < 4; i++)
-		array[i] = b43_phy_read(dev, B43_NPHY_TABLE_DATALO);
+	b43_ntab_read_bulk(dev, B43_NTAB16(0xF, 0x50), 4, array);
 
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_NPHY_TXIQW0, array[0]);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_NPHY_TXIQW1, array[1]);
-- 
1.7.3.4

