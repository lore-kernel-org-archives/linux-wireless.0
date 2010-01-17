Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:35709 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab0AQXVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 18:21:18 -0500
Received: by fxm25 with SMTP id 25so627467fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 15:21:15 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Mon, 18 Jan 2010 00:21:21 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 2/5 V2] b43: N-PHY: implement and add multi-dimensional table
 writing
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6o9tvst9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: updated to apply without fuzz
---
  drivers/net/wireless/b43/phy_n.c       |   58 ++++++++++++++------------------
  drivers/net/wireless/b43/tables_nphy.c |   40 ++++++++++++++++++++++
  drivers/net/wireless/b43/tables_nphy.h |    2 +
  3 files changed, 67 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 16f1f9b..6b200e5 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1699,8 +1699,7 @@ static void b43_nphy_restore_cal(struct b43_wldev *dev)
  		loft = &nphy->cal_cache.txcal_coeffs_5G[5];
  	}

-	/* TODO: Write an N PHY table with ID 15, length 4, offset 80,
-		width 16, and data from table */
+	b43_ntab_write_bulk(dev, B43_NTAB16(15, 80), 4, table);

  	for (i = 0; i < 4; i++) {
  		if (dev->phy.rev >= 3)
@@ -1709,12 +1708,9 @@ static void b43_nphy_restore_cal(struct b43_wldev *dev)
  			coef[i] = 0;
  	}

-	/* TODO: Write an N PHY table with ID 15, length 4, offset 88,
-		width 16, and data from coef */
-	/* TODO: Write an N PHY table with ID 15, length 2, offset 85,
-		width 16 and data from loft */
-	/* TODO: Write an N PHY table with ID 15, length 2, offset 93,
-		width 16 and data from loft */
+	b43_ntab_write_bulk(dev, B43_NTAB16(15, 88), 4, coef);
+	b43_ntab_write_bulk(dev, B43_NTAB16(15, 85), 2, loft);
+	b43_ntab_write_bulk(dev, B43_NTAB16(15, 93), 2, loft);

  	if (dev->phy.rev < 2)
  		b43_nphy_tx_iq_workaround(dev);
@@ -1782,8 +1778,8 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
  		b43_nphy_iq_cal_gain_params(dev, i, target, &params[i]);
  		gain[i] = params[i].cal_gain;
  	}
-	/* TODO: Write an N PHY Table with ID 7, length 2, offset 0x110,
-		width 16, and data pointer gain */
+
+	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x110), 2, gain);

  	b43_nphy_tx_cal_radio_setup(dev);
  	b43_nphy_tx_cal_phy_setup(dev);
@@ -1833,8 +1829,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
  			}
  		}

-		/* TODO: Write an N PHY Table with ID 15, length from above,
-			offset 64, width 16, and the data pointer from above */
+		b43_ntab_write_bulk(dev, B43_NTAB16(15, 64), length, table);

  		if (full) {
  			if (dev->phy.rev >= 3)
@@ -1902,9 +1897,8 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
  			/* TODO: Read an N PHY Table with ID 15,
  				length table_length, offset 96, width 16,
  				and data pointer buffer */
-			/* TODO: Write an N PHY Table with ID 15,
-				length table_length, offset 64, width 16,
-				and data pointer buffer */
+			b43_ntab_write_bulk(dev, B43_NTAB16(15, 64), length,
+						buffer);

  			if (type == 1 || type == 3 || type == 4)
  				buffer[0] = diq_start;
@@ -1916,8 +1910,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
  		last = (dev->phy.rev < 3) ? 6 : 7;

  		if (!mphase || nphy->mphase_cal_phase_id == last) {
-			/* TODO: Write an N PHY Table with ID 15, length 4,
-				offset 96, width 16, and data pointer buffer */
+			b43_ntab_write_bulk(dev, B43_NTAB16(15, 96), 4, buffer);
  			/* TODO: Read an N PHY Table with ID 15, length 4,
  				offset 80, width 16, and data pointer buffer */
  			if (dev->phy.rev < 3) {
@@ -1926,14 +1919,14 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
  				buffer[2] = 0;
  				buffer[3] = 0;
  			}
-			/* TODO: Write an N PHY Table with ID 15, length 4,
-				offset 88, width 16, and data pointer buffer */
-			/* TODO: Read an N PHY Table with ID 15, length 2,
-				offset 101, width 16, and data pointer buffer*/
-			/* TODO: Write an N PHY Table with ID 15, length 2,
-				offset 85, width 16, and data pointer buffer */
-			/* TODO: Write an N PHY Table with ID 15, length 2,
-				offset 93, width 16, and data pointer buffer */
+			b43_ntab_write_bulk(dev, B43_NTAB16(15, 88), 4,
+						buffer);
+			b43_ntab_write_bulk(dev, B43_NTAB16(15, 101), 2,
+						buffer);
+			b43_ntab_write_bulk(dev, B43_NTAB16(15, 85), 2,
+						buffer);
+			b43_ntab_write_bulk(dev, B43_NTAB16(15, 93), 2,
+						buffer);
  			length = 11;
  			if (dev->phy.rev < 3)
  				length -= 2;
@@ -1957,8 +1950,7 @@ static int b43_nphy_cal_tx_iq_lo(struct b43_wldev *dev,
  	}

  	b43_nphy_tx_cal_phy_cleanup(dev);
-	/* TODO: Write an N PHY Table with ID 7, length 2, offset 0x110,
-		width 16, and data from save */
+	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x110), 2, save);

  	if (dev->phy.rev < 2 && (!mphase || nphy->mphase_cal_phase_id == last))
  		b43_nphy_tx_iq_workaround(dev);
@@ -2008,8 +2000,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,
  		b43_nphy_iq_cal_gain_params(dev, i, target, &cal_params[i]);
  		cal_gain[i] = cal_params[i].cal_gain;
  	}
-	/* TODO: Write an N PHY Table with ID 7, length 2, offset 0x110,
-		width 16, and data from cal_gain */
+	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x110), 2, cal_gain);

  	for (i = 0; i < 2; i++) {
  		if (i == 0) {
@@ -2147,8 +2138,7 @@ static int b43_nphy_rev2_cal_rx_iq(struct b43_wldev *dev,

  	/* TODO: Call N PHY RF Ctrl Override with 0x400, 0, 3, 1 as arguments*/
  	b43_nphy_force_rf_sequence(dev, B43_RFSEQ_RESET2RX);
-	/* TODO: Write an N PHY Table with ID 7, length 2, offset 0x110,
-		width 16, and data from gain_save */
+	b43_ntab_write_bulk(dev, B43_NTAB16(7, 0x110), 2, gain_save);

  	b43_nphy_stay_in_carrier_search(dev, 0);

@@ -2290,8 +2280,10 @@ int b43_phy_initn(struct b43_wldev *dev)
  	if (phy->rev >= 3) {
  		/* TODO */
  	} else {
-		/* TODO Write an N PHY table with ID 26, length 128, offset 192, width 32, and the data from Rev 2 TX Power Control Table */
-		/* TODO Write an N PHY table with ID 27, length 128, offset 192, width 32, and the data from Rev 2 TX Power Control Table */
+		b43_ntab_write_bulk(dev, B43_NTAB32(26, 192), 128,
+					b43_ntab_tx_gain_rev0_1_2);
+		b43_ntab_write_bulk(dev, B43_NTAB32(27, 192), 128,
+					b43_ntab_tx_gain_rev0_1_2);
  	}

  	if (nphy->phyrxchain != 3)
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 7dff853..fc08be0 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2952,6 +2952,46 @@ void b43_ntab_write(struct b43_wldev *dev, u32 offset, u32 value)
  	assert_ntab_array_sizes();
  }

+void b43_ntab_write_bulk(struct b43_wldev *dev, u32 offset,
+			  unsigned int nr_elements, const void *_data)
+{
+	u32 type, value;
+	const u8 *data = _data;
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
+			value = *data;
+			data++;
+			B43_WARN_ON(value & ~0xFF);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, value);
+			break;
+		case B43_NTAB_16BIT:
+			value = *((u16 *)data);
+			data += 2;
+			B43_WARN_ON(value & ~0xFFFF);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO, value);
+			break;
+		case B43_NTAB_32BIT:
+			value = *((u32 *)data);
+			data += 4;
+			b43_phy_write(dev, B43_NPHY_TABLE_DATAHI, value >> 16);
+			b43_phy_write(dev, B43_NPHY_TABLE_DATALO,
+					value & 0xFFFF);
+			break;
+		default:
+			B43_WARN_ON(1);
+		}
+	}
+}
+
  #define ntab_upload(dev, offset, data) do { \
  		unsigned int i;						\
  		for (i = 0; i < (offset##_SIZE); i++)			\
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 51636d0..d5605df 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -143,6 +143,8 @@ b43_nphy_get_chantabent(struct b43_wldev *dev, u8 channel);
  #define B43_NTAB_TX_IQLO_CAL_CMDS_FULLCAL_REV3		12

  void b43_ntab_write(struct b43_wldev *dev, u32 offset, u32 value);
+void b43_ntab_write_bulk(struct b43_wldev *dev, u32 offset,
+			  unsigned int nr_elements, const void *_data);

  void b43_nphy_rev0_1_2_tables_init(struct b43_wldev *dev);
  void b43_nphy_rev3plus_tables_init(struct b43_wldev *dev);
-- 
1.6.4.2

