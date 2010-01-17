Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:55399 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab0AQWh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 17:37:59 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so609289fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2010 14:37:58 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sun, 17 Jan 2010 23:38:02 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 3/4] b43: N-PHY: implement and add reading one element tables
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6o7to019lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c       |    6 ++----
  drivers/net/wireless/b43/tables_nphy.c |   31 +++++++++++++++++++++++++++++++
  drivers/net/wireless/b43/tables_nphy.h |    1 +
  3 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 6fd48d0..298a30a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1628,8 +1628,7 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
  		regs[4] = b43_phy_read(dev, B43_NPHY_BBCFG);
  		b43_phy_mask(dev, B43_NPHY_BBCFG, ~B43_NPHY_BBCFG_RSTRX);

-		/* TODO: Read an N PHY Table with ID 8, length 1, offset 3,
-			width 16, and data pointing to tmp */
+		tmp = b43_ntab_read(dev, B43_NTAB16(8, 3));
  		regs[5] = tmp;
  		b43_ntab_write(dev, B43_NTAB16(8, 3), 0);
  		b43_ntab_write(dev, B43_NTAB16(8, 19), tmp);
@@ -1652,8 +1651,7 @@ static void b43_nphy_tx_cal_phy_setup(struct b43_wldev *dev)
  		tmp = b43_phy_read(dev, B43_NPHY_AFECTL_OVER);
  		regs[2] = tmp;
  		b43_phy_write(dev, B43_NPHY_AFECTL_OVER, tmp | 0x3000);
-		/* TODO: Read an N PHY Table with ID 8, length 1, offset 2,
-			width 16, and data pointing to tmp */
+		tmp = b43_ntab_read(dev, B43_NTAB16(8, 3));
  		regs[3] = tmp;
  		tmp |= 0x2000;
  		b43_ntab_write(dev, B43_NTAB16(8, 2), tmp);
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index fc08be0..b8aed45 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2919,6 +2919,37 @@ static inline void assert_ntab_array_sizes(void)
  #undef check
  }

+u32 b43_ntab_read(struct b43_wldev *dev, u32 offset)
+{
+	u32 type, value;
+
+	type = offset & B43_NTAB_TYPEMASK;
+	offset &= ~B43_NTAB_TYPEMASK;
+	B43_WARN_ON(offset > 0xFFFF);
+
+	switch (type) {
+	case B43_NTAB_8BIT:
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, offset);
+		value = b43_phy_read(dev, B43_NPHY_TABLE_DATALO) & 0xFF;
+		break;
+	case B43_NTAB_16BIT:
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, offset);
+		value = b43_phy_read(dev, B43_NPHY_TABLE_DATALO);
+		break;
+	case B43_NTAB_32BIT:
+		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, offset);
+		value = b43_phy_read(dev, B43_NPHY_TABLE_DATAHI);
+		value <<= 16;
+		value |= b43_phy_read(dev, B43_NPHY_TABLE_DATALO);
+		break;
+	default:
+		B43_WARN_ON(1);
+		value = 0;
+	}
+
+	return value;
+}
+
  void b43_ntab_write(struct b43_wldev *dev, u32 offset, u32 value)
  {
  	u32 type;
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index d5605df..64e990a 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -142,6 +142,7 @@ b43_nphy_get_chantabent(struct b43_wldev *dev, u8 channel);
  #define B43_NTAB_TX_IQLO_CAL_CMDS_FULLCAL		10
  #define B43_NTAB_TX_IQLO_CAL_CMDS_FULLCAL_REV3		12

+u32 b43_ntab_read(struct b43_wldev *dev, u32 offset);
  void b43_ntab_write(struct b43_wldev *dev, u32 offset, u32 value);
  void b43_ntab_write_bulk(struct b43_wldev *dev, u32 offset,
  			  unsigned int nr_elements, const void *_data);
-- 
1.6.4.2

