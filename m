Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:35709 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab0AQXVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 18:21:32 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so627467fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 15:21:32 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Mon, 18 Jan 2010 00:21:35 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 4/5 V2] b43: N-PHY: implement and add multi-dimensional table
 reading
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6o9t9t19lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: updated to apply without offset
---
  drivers/net/wireless/b43/phy_n.c       |   30 ++++++++++-----------------
  drivers/net/wireless/b43/tables_nphy.c |   35 ++++++++++++++++++++++++++++++++
  drivers/net/wireless/b43/tables_nphy.h |    2 +
  3 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 6398656..2356d84 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -829,8 +829,7 @@ static void b43_nphy_tx_pwr_ctrl_coef_setup(struct b43_wldev *dev)
  	if (nphy->hang_avoid)
  		b43_nphy_stay_in_carrier_search(dev, true);

-	/* TODO: Read an N PHY Table with ID 15, length 7, offset 80,
-		width 16, and data pointer buffer */
+	b43_ntab_read_bulk(dev, B43_NTAB16(15, 80), 7, buffer);

  	for (i = 0; i < 2; i++) {
  		tmp = ((buffer[i * 2] & 0x3FF) << 10) |
@@ -1507,8 +1506,7 @@ static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)

  		if (nphy->hang_avoid)
  			b43_nphy_stay_in_carrier_search(dev, true);
-		/* TODO: Read an N PHY Table with ID 7, length 2,
-			offset 0x110, width 16, and curr_gain */
+		b43_ntab_read_bulk(dev, B43_NTAB16(7, 0x110), 2, curr_gain);
  		if (nphy->hang_avoid)
  			b43_nphy_stay_in_carrier_search(dev, false);

@@ -1768,8 +1766,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
  		nphy->hang_avoid = 0;
  	}

-	/* TODO: Read an N PHY Table with ID 7, length 2, offset 0x110,
-		width 16, and data pointer save */
+	b43_ntab_read_bulk(dev, B43_NTAB16(7, 0x110), 2, save);

  	for (i = 0; i < 2; i++) {
  		b43_nphy_iq_cal_gain_params(dev, i, target, &params[i]);
@@ -1890,9 +1887,8 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
  				udelay(10);
  			}

-			/* TODO: Read an N PHY Table with ID 15,
-				length table_length, offset 96, width 16,
-				and data pointer buffer */
+			b43_ntab_read_bulk(dev, B43_NTAB16(15, 96), length,
+						buffer);
  			b43_ntab_write_bulk(dev, B43_NTAB16(15, 64), length,
  						buffer);

@@ -1907,8 +1903,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,

  		if (!mphase || nphy->mphase_cal_phase_id == last) {
  			b43_ntab_write_bulk(dev, B43_NTAB16(15, 96), 4, buffer);
-			/* TODO: Read an N PHY Table with ID 15, length 4,
-				offset 80, width 16, and data pointer buffer */
+			b43_ntab_read_bulk(dev, B43_NTAB16(15, 80), 4, buffer);
  			if (dev->phy.rev < 3) {
  				buffer[0] = 0;
  				buffer[1] = 0;
@@ -1926,9 +1921,8 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
  			length = 11;
  			if (dev->phy.rev < 3)
  				length -= 2;
-			/* TODO: Read an N PHY Table with ID 15, length length,
-				offset 96, width 16, and data pointer
-				nphy->txiqlocal_bestc */
+			b43_ntab_read_bulk(dev, B43_NTAB16(15, 96), length,
+						nphy->txiqlocal_bestc);
  			nphy->txiqlocal_coeffsvalid = true;
  			/* TODO: Set nphy->txiqlocal_chanspec to
  				the current channel */
@@ -1936,9 +1930,8 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
  			length = 11;
  			if (dev->phy.rev < 3)
  				length -= 2;
-			/* TODO: Read an N PHY Table with ID 5, length length,
-				offset 96, width 16, and data pointer
-				nphy->mphase_txcal_bestcoeffs */
+			b43_ntab_read_bulk(dev, B43_NTAB16(15, 96), length,
+						nphy->mphase_txcal_bestcoeffs);
  		}

  		b43_nphy_stop_playback(dev);
@@ -1990,8 +1983,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,

  	if (dev->phy.rev < 2)
  		;/* TODO: Call N PHY Reapply TX Cal Coeffs */
-	/* TODO: Read an N PHY Table with ID 7, length 2, offset 0x110,
-		width 16, and data gain_save */
+	b43_ntab_read_bulk(dev, B43_NTAB16(7, 0x110), 2, gain_save);
  	for (i = 0; i < 2; i++) {
  		b43_nphy_iq_cal_gain_params(dev, i, target, &cal_params[i]);
  		cal_gain[i] = cal_params[i].cal_gain;
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index b8aed45..b8c9fc6 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2950,6 +2950,41 @@ u32 b43_ntab_read(struct b43_wldev *dev, u32 offset)
  	return value;
  }

+void b43_ntab_read_bulk(struct b43_wldev *dev, u32 offset,
+			 unsigned int nr_elements, void *_data)
+{
+	u32 type;
+	u8 *data = _data;
+	unsigned int i;
+
+	type = offset & B43_NTAB_TYPEMASK;
+	offset &= ~B43_NTAB_TYPEMASK;
+	B43_WARN_ON(offset > 0xFFFF);
+
+	b43_phy_write(dev, B43_NPHY_TABLE_ADDR, offset);
+
+	for (i = 0; i < nr_elements; i++) {
+		switch (type) {
+		case B43_NTAB_8BIT:
+			*data = b43_phy_read(dev, B43_NPHY_TABLE_DATALO) & 0xFF;
+			data++;
+			break;
+		case B43_NTAB_16BIT:
+			*((u16 *)data) = b43_phy_read(dev, B43_NPHY_TABLE_DATALO);
+			data += 2;
+			break;
+		case B43_NTAB_32BIT:
+			*((u32 *)data) = b43_phy_read(dev, B43_NPHY_TABLE_DATAHI);
+			*((u32 *)data) <<= 16;
+			*((u32 *)data) |= b43_phy_read(dev, B43_NPHY_TABLE_DATALO);
+			data += 4;
+			break;
+		default:
+			B43_WARN_ON(1);
+		}
+	}
+}
+
  void b43_ntab_write(struct b43_wldev *dev, u32 offset, u32 value)
  {
  	u32 type;
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 64e990a..6bbef89 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -143,6 +143,8 @@ b43_nphy_get_chantabent(struct b43_wldev *dev, u8 channel);
  #define B43_NTAB_TX_IQLO_CAL_CMDS_FULLCAL_REV3		12

  u32 b43_ntab_read(struct b43_wldev *dev, u32 offset);
+void b43_ntab_read_bulk(struct b43_wldev *dev, u32 offset,
+			 unsigned int nr_elements, void *_data);
  void b43_ntab_write(struct b43_wldev *dev, u32 offset, u32 value);
  void b43_ntab_write_bulk(struct b43_wldev *dev, u32 offset,
  			  unsigned int nr_elements, const void *_data);
-- 
1.6.4.2

