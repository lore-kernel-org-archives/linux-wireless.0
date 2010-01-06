Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:26835 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab0AFPkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 10:40:13 -0500
Received: by ey-out-2122.google.com with SMTP id 22so697478eye.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 07:40:11 -0800 (PST)
Content-Type: multipart/mixed; boundary=----------UKtM6x0WZFhbNXXUyPDIXX
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 06 Jan 2010 16:41:32 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 3/5] b43: N-PHY: clean table init, check PHY rev (V3)
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u54a7izg9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------------UKtM6x0WZFhbNXXUyPDIXX
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: Quoted-Printable

b43: N-PHY: clean table init, check PHY rev (V3)

This is resend with lines offset hunk "fixed".


 From cb7e670134c28e3bf44d8537d953e2e8d3ec4b30 Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Rafa=3DC5=3D82=3D20Mi=3DC5=3D82ecki?=3D <zajec5@gmail.=
com>
Date: Sat, 2 Jan 2010 18:50:25 +0100
Subject: [PATCH 3/5] b43: N-PHY: clean table init, check PHY rev (V3)
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Move table init to tables_nphy.c, detect newer PHY which use different i=
nit.
We don't init newer PHYs yet but this at least shows what more is needed=
.

V2: Make some functions and tables static
V3: Just drop static table declarations from header

Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c       |   43 ++-----------
  drivers/net/wireless/b43/tables_nphy.c |  100 +++++++++++++++++++++++-=
-------
  drivers/net/wireless/b43/tables_nphy.h |   29 +---------
  3 files changed, 83 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43=
/phy_n.c
index 249caf0..5341ba5 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -199,44 +199,15 @@ void b43_nphy_radio_turn_off(struct b43_wldev *dev=
)
  		     ~B43_NPHY_RFCTL_CMD_EN);
  }

-#define ntab_upload(dev, offset, data) do { \
-		unsigned int i;						\
-		for (i =3D 0; i < (offset##_SIZE); i++)			\
-			b43_ntab_write(dev, (offset) + i, (data)[i]);	\
-	} while (0)
-
-/* Upload the N-PHY tables. */
+/* Upload the N-PHY tables.
+ * http://bcm-v4.sipsolutions.net/802.11/PHY/N/InitTables
+ */
  static void b43_nphy_tables_init(struct b43_wldev *dev)
  {
-	/* Static tables */
-	ntab_upload(dev, B43_NTAB_FRAMESTRUCT, b43_ntab_framestruct);
-	ntab_upload(dev, B43_NTAB_FRAMELT, b43_ntab_framelookup);
-	ntab_upload(dev, B43_NTAB_TMAP, b43_ntab_tmap);
-	ntab_upload(dev, B43_NTAB_TDTRN, b43_ntab_tdtrn);
-	ntab_upload(dev, B43_NTAB_INTLEVEL, b43_ntab_intlevel);
-	ntab_upload(dev, B43_NTAB_PILOT, b43_ntab_pilot);
-	ntab_upload(dev, B43_NTAB_PILOTLT, b43_ntab_pilotlt);
-	ntab_upload(dev, B43_NTAB_TDI20A0, b43_ntab_tdi20a0);
-	ntab_upload(dev, B43_NTAB_TDI20A1, b43_ntab_tdi20a1);
-	ntab_upload(dev, B43_NTAB_TDI40A0, b43_ntab_tdi40a0);
-	ntab_upload(dev, B43_NTAB_TDI40A1, b43_ntab_tdi40a1);
-	ntab_upload(dev, B43_NTAB_BDI, b43_ntab_bdi);
-	ntab_upload(dev, B43_NTAB_CHANEST, b43_ntab_channelest);
-	ntab_upload(dev, B43_NTAB_MCS, b43_ntab_mcs);
-
-	/* Volatile tables */
-	ntab_upload(dev, B43_NTAB_NOISEVAR10, b43_ntab_noisevar10);
-	ntab_upload(dev, B43_NTAB_NOISEVAR11, b43_ntab_noisevar11);
-	ntab_upload(dev, B43_NTAB_C0_ESTPLT, b43_ntab_estimatepowerlt0);
-	ntab_upload(dev, B43_NTAB_C1_ESTPLT, b43_ntab_estimatepowerlt1);
-	ntab_upload(dev, B43_NTAB_C0_ADJPLT, b43_ntab_adjustpower0);
-	ntab_upload(dev, B43_NTAB_C1_ADJPLT, b43_ntab_adjustpower1);
-	ntab_upload(dev, B43_NTAB_C0_GAINCTL, b43_ntab_gainctl0);
-	ntab_upload(dev, B43_NTAB_C1_GAINCTL, b43_ntab_gainctl1);
-	ntab_upload(dev, B43_NTAB_C0_IQLT, b43_ntab_iqlt0);
-	ntab_upload(dev, B43_NTAB_C1_IQLT, b43_ntab_iqlt1);
-	ntab_upload(dev, B43_NTAB_C0_LOFEEDTH, b43_ntab_loftlt0);
-	ntab_upload(dev, B43_NTAB_C1_LOFEEDTH, b43_ntab_loftlt1);
+	if (dev->phy.rev < 3)
+		b43_nphy_rev0_1_2_tables_init(dev);
+	else
+		b43_nphy_rev3plus_tables_init(dev);
  }

  static void b43_nphy_workarounds(struct b43_wldev *dev)
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wirele=
ss/b43/tables_nphy.c
index 4e23363..d0b91b5 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -1336,7 +1336,7 @@ b43_nphy_get_chantabent(struct b43_wldev *dev, u8 =
channel)
  }


-const u8 b43_ntab_adjustpower0[] =3D {
+static const u8 b43_ntab_adjustpower0[] =3D {
  	0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x01,
  	0x02, 0x02, 0x02, 0x02, 0x03, 0x03, 0x03, 0x03,
  	0x04, 0x04, 0x04, 0x04, 0x05, 0x05, 0x05, 0x05,
@@ -1355,7 +1355,7 @@ const u8 b43_ntab_adjustpower0[] =3D {
  	0x1E, 0x1E, 0x1E, 0x1E, 0x1F, 0x1F, 0x1F, 0x1F,
  };

-const u8 b43_ntab_adjustpower1[] =3D {
+static const u8 b43_ntab_adjustpower1[] =3D {
  	0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x01,
  	0x02, 0x02, 0x02, 0x02, 0x03, 0x03, 0x03, 0x03,
  	0x04, 0x04, 0x04, 0x04, 0x05, 0x05, 0x05, 0x05,
@@ -1374,11 +1374,11 @@ const u8 b43_ntab_adjustpower1[] =3D {
  	0x1E, 0x1E, 0x1E, 0x1E, 0x1F, 0x1F, 0x1F, 0x1F,
  };

-const u16 b43_ntab_bdi[] =3D {
+static const u16 b43_ntab_bdi[] =3D {
  	0x0070, 0x0126, 0x012C, 0x0246, 0x048D, 0x04D2,
  };

-const u32 b43_ntab_channelest[] =3D {
+static const u32 b43_ntab_channelest[] =3D {
  	0x44444444, 0x44444444, 0x44444444, 0x44444444,
  	0x44444444, 0x44444444, 0x44444444, 0x44444444,
  	0x10101010, 0x10101010, 0x10101010, 0x10101010,
@@ -1405,7 +1405,7 @@ const u32 b43_ntab_channelest[] =3D {
  	0x10101010, 0x10101010, 0x10101010, 0x10101010,
  };

-const u8 b43_ntab_estimatepowerlt0[] =3D {
+static const u8 b43_ntab_estimatepowerlt0[] =3D {
  	0x50, 0x4F, 0x4E, 0x4D, 0x4C, 0x4B, 0x4A, 0x49,
  	0x48, 0x47, 0x46, 0x45, 0x44, 0x43, 0x42, 0x41,
  	0x40, 0x3F, 0x3E, 0x3D, 0x3C, 0x3B, 0x3A, 0x39,
@@ -1416,7 +1416,7 @@ const u8 b43_ntab_estimatepowerlt0[] =3D {
  	0x18, 0x17, 0x16, 0x15, 0x14, 0x13, 0x12, 0x11,
  };

-const u8 b43_ntab_estimatepowerlt1[] =3D {
+static const u8 b43_ntab_estimatepowerlt1[] =3D {
  	0x50, 0x4F, 0x4E, 0x4D, 0x4C, 0x4B, 0x4A, 0x49,
  	0x48, 0x47, 0x46, 0x45, 0x44, 0x43, 0x42, 0x41,
  	0x40, 0x3F, 0x3E, 0x3D, 0x3C, 0x3B, 0x3A, 0x39,
@@ -1427,14 +1427,14 @@ const u8 b43_ntab_estimatepowerlt1[] =3D {
  	0x18, 0x17, 0x16, 0x15, 0x14, 0x13, 0x12, 0x11,
  };

-const u8 b43_ntab_framelookup[] =3D {
+static const u8 b43_ntab_framelookup[] =3D {
  	0x02, 0x04, 0x14, 0x14, 0x03, 0x05, 0x16, 0x16,
  	0x0A, 0x0C, 0x1C, 0x1C, 0x0B, 0x0D, 0x1E, 0x1E,
  	0x06, 0x08, 0x18, 0x18, 0x07, 0x09, 0x1A, 0x1A,
  	0x0E, 0x10, 0x20, 0x28, 0x0F, 0x11, 0x22, 0x2A,
  };

-const u32 b43_ntab_framestruct[] =3D {
+static const u32 b43_ntab_framestruct[] =3D {
  	0x08004A04, 0x00100000, 0x01000A05, 0x00100020,
  	0x09804506, 0x00100030, 0x09804507, 0x00100030,
  	0x00000000, 0x00000000, 0x00000000, 0x00000000,
@@ -1645,7 +1645,7 @@ const u32 b43_ntab_framestruct[] =3D {
  	0x00000000, 0x00000000, 0x00000000, 0x00000000,
  };

-const u32 b43_ntab_gainctl0[] =3D {
+static const u32 b43_ntab_gainctl0[] =3D {
  	0x007F003F, 0x007E013F, 0x007D023E, 0x007C033E,
  	0x007B043D, 0x007A053D, 0x0079063C, 0x0078073C,
  	0x0077083B, 0x0076093B, 0x00750A3A, 0x00740B3A,
@@ -1680,7 +1680,7 @@ const u32 b43_ntab_gainctl0[] =3D {
  	0x00030C01, 0x00020D01, 0x00010E00, 0x00000F00,
  };

-const u32 b43_ntab_gainctl1[] =3D {
+static const u32 b43_ntab_gainctl1[] =3D {
  	0x007F003F, 0x007E013F, 0x007D023E, 0x007C033E,
  	0x007B043D, 0x007A053D, 0x0079063C, 0x0078073C,
  	0x0077083B, 0x0076093B, 0x00750A3A, 0x00740B3A,
@@ -1715,12 +1715,12 @@ const u32 b43_ntab_gainctl1[] =3D {
  	0x00030C01, 0x00020D01, 0x00010E00, 0x00000F00,
  };

-const u32 b43_ntab_intlevel[] =3D {
+static const u32 b43_ntab_intlevel[] =3D {
  	0x00802070, 0x0671188D, 0x0A60192C, 0x0A300E46,
  	0x00C1188D, 0x080024D2, 0x00000070,
  };

-const u32 b43_ntab_iqlt0[] =3D {
+static const u32 b43_ntab_iqlt0[] =3D {
  	0x0000007F, 0x0000007F, 0x0000007F, 0x0000007F,
  	0x0000007F, 0x0000007F, 0x0000007F, 0x0000007F,
  	0x0000007F, 0x0000007F, 0x0000007F, 0x0000007F,
@@ -1755,7 +1755,7 @@ const u32 b43_ntab_iqlt0[] =3D {
  	0x0000007F, 0x0000007F, 0x0000007F, 0x0000007F,
  };

-const u32 b43_ntab_iqlt1[] =3D {
+static const u32 b43_ntab_iqlt1[] =3D {
  	0x0000007F, 0x0000007F, 0x0000007F, 0x0000007F,
  	0x0000007F, 0x0000007F, 0x0000007F, 0x0000007F,
  	0x0000007F, 0x0000007F, 0x0000007F, 0x0000007F,
@@ -1790,7 +1790,7 @@ const u32 b43_ntab_iqlt1[] =3D {
  	0x0000007F, 0x0000007F, 0x0000007F, 0x0000007F,
  };

-const u16 b43_ntab_loftlt0[] =3D {
+static const u16 b43_ntab_loftlt0[] =3D {
  	0x0000, 0x0101, 0x0002, 0x0103, 0x0000, 0x0101,
  	0x0002, 0x0103, 0x0000, 0x0101, 0x0002, 0x0103,
  	0x0000, 0x0101, 0x0002, 0x0103, 0x0000, 0x0101,
@@ -1815,7 +1815,7 @@ const u16 b43_ntab_loftlt0[] =3D {
  	0x0002, 0x0103,
  };

-const u16 b43_ntab_loftlt1[] =3D {
+static const u16 b43_ntab_loftlt1[] =3D {
  	0x0000, 0x0101, 0x0002, 0x0103, 0x0000, 0x0101,
  	0x0002, 0x0103, 0x0000, 0x0101, 0x0002, 0x0103,
  	0x0000, 0x0101, 0x0002, 0x0103, 0x0000, 0x0101,
@@ -1840,7 +1840,7 @@ const u16 b43_ntab_loftlt1[] =3D {
  	0x0002, 0x0103,
  };

-const u8 b43_ntab_mcs[] =3D {
+static const u8 b43_ntab_mcs[] =3D {
  	0x00, 0x08, 0x0A, 0x10, 0x12, 0x19, 0x1A, 0x1C,
  	0x40, 0x48, 0x4A, 0x50, 0x52, 0x59, 0x5A, 0x5C,
  	0x80, 0x88, 0x8A, 0x90, 0x92, 0x99, 0x9A, 0x9C,
@@ -1859,7 +1859,7 @@ const u8 b43_ntab_mcs[] =3D {
  	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  };

-const u32 b43_ntab_noisevar10[] =3D {
+static const u32 b43_ntab_noisevar10[] =3D {
  	0x020C020C, 0x0000014D, 0x020C020C, 0x0000014D,
  	0x020C020C, 0x0000014D, 0x020C020C, 0x0000014D,
  	0x020C020C, 0x0000014D, 0x020C020C, 0x0000014D,
@@ -1926,7 +1926,7 @@ const u32 b43_ntab_noisevar10[] =3D {
  	0x020C020C, 0x0000014D, 0x020C020C, 0x0000014D,
  };

-const u32 b43_ntab_noisevar11[] =3D {
+static const u32 b43_ntab_noisevar11[] =3D {
  	0x020C020C, 0x0000014D, 0x020C020C, 0x0000014D,
  	0x020C020C, 0x0000014D, 0x020C020C, 0x0000014D,
  	0x020C020C, 0x0000014D, 0x020C020C, 0x0000014D,
@@ -1993,7 +1993,7 @@ const u32 b43_ntab_noisevar11[] =3D {
  	0x020C020C, 0x0000014D, 0x020C020C, 0x0000014D,
  };

-const u16 b43_ntab_pilot[] =3D {
+static const u16 b43_ntab_pilot[] =3D {
  	0xFF08, 0xFF08, 0xFF08, 0xFF08, 0xFF08, 0xFF08,
  	0xFF08, 0xFF08, 0x80D5, 0x80D5, 0x80D5, 0x80D5,
  	0x80D5, 0x80D5, 0x80D5, 0x80D5, 0xFF0A, 0xFF82,
@@ -2011,12 +2011,12 @@ const u16 b43_ntab_pilot[] =3D {
  	0xF0A0, 0xF028, 0xFFFF, 0xFFFF,
  };

-const u32 b43_ntab_pilotlt[] =3D {
+static const u32 b43_ntab_pilotlt[] =3D {
  	0x76540123, 0x62407351, 0x76543201, 0x76540213,
  	0x76540123, 0x76430521,
  };

-const u32 b43_ntab_tdi20a0[] =3D {
+static const u32 b43_ntab_tdi20a0[] =3D {
  	0x00091226, 0x000A1429, 0x000B56AD, 0x000C58B0,
  	0x000D5AB3, 0x000E9CB6, 0x000F9EBA, 0x0000C13D,
  	0x00020301, 0x00030504, 0x00040708, 0x0005090B,
@@ -2033,7 +2033,7 @@ const u32 b43_ntab_tdi20a0[] =3D {
  	0x00000000, 0x00000000, 0x00000000,
  };

-const u32 b43_ntab_tdi20a1[] =3D {
+static const u32 b43_ntab_tdi20a1[] =3D {
  	0x00014B26, 0x00028D29, 0x000393AD, 0x00049630,
  	0x0005D833, 0x0006DA36, 0x00099C3A, 0x000A9E3D,
  	0x000BC081, 0x000CC284, 0x000DC488, 0x000F068B,
@@ -2050,7 +2050,7 @@ const u32 b43_ntab_tdi20a1[] =3D {
  	0x00000000, 0x00000000, 0x00000000,
  };

-const u32 b43_ntab_tdi40a0[] =3D {
+static const u32 b43_ntab_tdi40a0[] =3D {
  	0x0011A346, 0x00136CCF, 0x0014F5D9, 0x001641E2,
  	0x0017CB6B, 0x00195475, 0x001B2383, 0x001CAD0C,
  	0x001E7616, 0x0000821F, 0x00020BA8, 0x0003D4B2,
@@ -2081,7 +2081,7 @@ const u32 b43_ntab_tdi40a0[] =3D {
  	0x00000000, 0x00000000,
  };

-const u32 b43_ntab_tdi40a1[] =3D {
+static const u32 b43_ntab_tdi40a1[] =3D {
  	0x001EDB36, 0x000129CA, 0x0002B353, 0x00047CDD,
  	0x0005C8E6, 0x000791EF, 0x00091BF9, 0x000AAA07,
  	0x000C3391, 0x000DFD1A, 0x00120923, 0x0013D22D,
@@ -2112,7 +2112,7 @@ const u32 b43_ntab_tdi40a1[] =3D {
  	0x00000000, 0x00000000,
  };

-const u32 b43_ntab_tdtrn[] =3D {
+static const u32 b43_ntab_tdtrn[] =3D {
  	0x061C061C, 0x0050EE68, 0xF592FE36, 0xFE5212F6,
  	0x00000C38, 0xFE5212F6, 0xF592FE36, 0x0050EE68,
  	0x061C061C, 0xEE680050, 0xFE36F592, 0x12F6FE52,
@@ -2291,7 +2291,7 @@ const u32 b43_ntab_tdtrn[] =3D {
  	0xFA58FC00, 0x0B64FC7E, 0x0800F7B6, 0x00F006BE,
  };

-const u32 b43_ntab_tmap[] =3D {
+static const u32 b43_ntab_tmap[] =3D {
  	0x8A88AA80, 0x8AAAAA8A, 0x8A8A8AA8, 0x00000888,
  	0x88000000, 0x8A8A88AA, 0x8AA88888, 0x8888A8A8,
  	0xF1111110, 0x11111111, 0x11F11111, 0x00000111,
@@ -2474,3 +2474,51 @@ void b43_ntab_write(struct b43_wldev *dev, u32 of=
fset, u32 value)
  	/* Some compiletime assertions... */
  	assert_ntab_array_sizes();
  }
+
+#define ntab_upload(dev, offset, data) do { \
+		unsigned int i;						\
+		for (i =3D 0; i < (offset##_SIZE); i++)			\
+			b43_ntab_write(dev, (offset) + i, (data)[i]);	\
+	} while (0)
+
+void b43_nphy_rev0_1_2_tables_init(struct b43_wldev *dev)
+{
+	/* Static tables */
+	ntab_upload(dev, B43_NTAB_FRAMESTRUCT, b43_ntab_framestruct);
+	ntab_upload(dev, B43_NTAB_FRAMELT, b43_ntab_framelookup);
+	ntab_upload(dev, B43_NTAB_TMAP, b43_ntab_tmap);
+	ntab_upload(dev, B43_NTAB_TDTRN, b43_ntab_tdtrn);
+	ntab_upload(dev, B43_NTAB_INTLEVEL, b43_ntab_intlevel);
+	ntab_upload(dev, B43_NTAB_PILOT, b43_ntab_pilot);
+	ntab_upload(dev, B43_NTAB_PILOTLT, b43_ntab_pilotlt);
+	ntab_upload(dev, B43_NTAB_TDI20A0, b43_ntab_tdi20a0);
+	ntab_upload(dev, B43_NTAB_TDI20A1, b43_ntab_tdi20a1);
+	ntab_upload(dev, B43_NTAB_TDI40A0, b43_ntab_tdi40a0);
+	ntab_upload(dev, B43_NTAB_TDI40A1, b43_ntab_tdi40a1);
+	ntab_upload(dev, B43_NTAB_BDI, b43_ntab_bdi);
+	ntab_upload(dev, B43_NTAB_CHANEST, b43_ntab_channelest);
+	ntab_upload(dev, B43_NTAB_MCS, b43_ntab_mcs);
+
+	/* Volatile tables */
+	ntab_upload(dev, B43_NTAB_NOISEVAR10, b43_ntab_noisevar10);
+	ntab_upload(dev, B43_NTAB_NOISEVAR11, b43_ntab_noisevar11);
+	ntab_upload(dev, B43_NTAB_C0_ESTPLT, b43_ntab_estimatepowerlt0);
+	ntab_upload(dev, B43_NTAB_C1_ESTPLT, b43_ntab_estimatepowerlt1);
+	ntab_upload(dev, B43_NTAB_C0_ADJPLT, b43_ntab_adjustpower0);
+	ntab_upload(dev, B43_NTAB_C1_ADJPLT, b43_ntab_adjustpower1);
+	ntab_upload(dev, B43_NTAB_C0_GAINCTL, b43_ntab_gainctl0);
+	ntab_upload(dev, B43_NTAB_C1_GAINCTL, b43_ntab_gainctl1);
+	ntab_upload(dev, B43_NTAB_C0_IQLT, b43_ntab_iqlt0);
+	ntab_upload(dev, B43_NTAB_C1_IQLT, b43_ntab_iqlt1);
+	ntab_upload(dev, B43_NTAB_C0_LOFEEDTH, b43_ntab_loftlt0);
+	ntab_upload(dev, B43_NTAB_C1_LOFEEDTH, b43_ntab_loftlt1);
+}
+
+void b43_nphy_rev3plus_tables_init(struct b43_wldev *dev)
+{
+	/* Static tables */
+	/* TODO */
+
+	/* Volatile tables */
+	/* TODO */
+}
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wirele=
ss/b43/tables_nphy.h
index 4d498b0..1f0a602 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -128,32 +128,7 @@ b43_nphy_get_chantabent(struct b43_wldev *dev, u8 c=
hannel);

  void b43_ntab_write(struct b43_wldev *dev, u32 offset, u32 value);

-extern const u8 b43_ntab_adjustpower0[];
-extern const u8 b43_ntab_adjustpower1[];
-extern const u16 b43_ntab_bdi[];
-extern const u32 b43_ntab_channelest[];
-extern const u8 b43_ntab_estimatepowerlt0[];
-extern const u8 b43_ntab_estimatepowerlt1[];
-extern const u8 b43_ntab_framelookup[];
-extern const u32 b43_ntab_framestruct[];
-extern const u32 b43_ntab_gainctl0[];
-extern const u32 b43_ntab_gainctl1[];
-extern const u32 b43_ntab_intlevel[];
-extern const u32 b43_ntab_iqlt0[];
-extern const u32 b43_ntab_iqlt1[];
-extern const u16 b43_ntab_loftlt0[];
-extern const u16 b43_ntab_loftlt1[];
-extern const u8 b43_ntab_mcs[];
-extern const u32 b43_ntab_noisevar10[];
-extern const u32 b43_ntab_noisevar11[];
-extern const u16 b43_ntab_pilot[];
-extern const u32 b43_ntab_pilotlt[];
-extern const u32 b43_ntab_tdi20a0[];
-extern const u32 b43_ntab_tdi20a1[];
-extern const u32 b43_ntab_tdi40a0[];
-extern const u32 b43_ntab_tdi40a1[];
-extern const u32 b43_ntab_tdtrn[];
-extern const u32 b43_ntab_tmap[];
-
+void b43_nphy_rev0_1_2_tables_init(struct b43_wldev *dev);
+void b43_nphy_rev3plus_tables_init(struct b43_wldev *dev);

  #endif /* B43_TABLES_NPHY_H_ */
-- =

1.6.4.2
------------UKtM6x0WZFhbNXXUyPDIXX
Content-Disposition: attachment; filename=0003-b43-N-PHY-clean-table-init-check-PHY-rev-V3.patch
Content-Type: application/octet-stream; name=0003-b43-N-PHY-clean-table-init-check-PHY-rev-V3.patch
Content-Transfer-Encoding: Base64

RnJvbSBjYjdlNjcwMTM0YzI4ZTNiZjQ0ZDg1MzdkOTUzZTJlOGQzZWM0YjMwIE1v
biBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UmFmYT1DNT04
Mj0yME1pPUM1PTgyZWNraT89IDx6YWplYzVAZ21haWwuY29tPgpEYXRlOiBTYXQs
IDIgSmFuIDIwMTAgMTg6NTA6MjUgKzAxMDAKU3ViamVjdDogW1BBVENIIDMvNV0g
YjQzOiBOLVBIWTogY2xlYW4gdGFibGUgaW5pdCwgY2hlY2sgUEhZIHJldiAoVjMp
Ck1JTUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsgY2hh
cnNldD1VVEYtOApDb250ZW50LVRyYW5zZmVyLUVuY29kaW5nOiA4Yml0CgpNb3Zl
IHRhYmxlIGluaXQgdG8gdGFibGVzX25waHkuYywgZGV0ZWN0IG5ld2VyIFBIWSB3
aGljaCB1c2UgZGlmZmVyZW50IGluaXQuCldlIGRvbid0IGluaXQgbmV3ZXIgUEhZ
cyB5ZXQgYnV0IHRoaXMgYXQgbGVhc3Qgc2hvd3Mgd2hhdCBtb3JlIGlzIG5lZWRl
ZC4KClYyOiBNYWtlIHNvbWUgZnVuY3Rpb25zIGFuZCB0YWJsZXMgc3RhdGljClYz
OiBKdXN0IGRyb3Agc3RhdGljIHRhYmxlIGRlY2xhcmF0aW9ucyBmcm9tIGhlYWRl
cgoKU2lnbmVkLW9mZi1ieTogUmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwu
Y29tPgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9waHlfbi5jICAgICAg
IHwgICA0MyArKy0tLS0tLS0tLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9iNDMv
dGFibGVzX25waHkuYyB8ICAxMDAgKysrKysrKysrKysrKysrKysrKysrKystLS0t
LS0tLQogZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3RhYmxlc19ucGh5LmggfCAg
IDI5ICstLS0tLS0tLS0KIDMgZmlsZXMgY2hhbmdlZCwgODMgaW5zZXJ0aW9ucygr
KSwgODkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYjQzL3BoeV9uLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvcGh5
X24uYwppbmRleCAyNDljYWYwLi41MzQxYmE1IDEwMDY0NAotLS0gYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9iNDMvcGh5X24uYworKysgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9iNDMvcGh5X24uYwpAQCAtMTk5LDQ0ICsxOTksMTUgQEAgdm9pZCBiNDNf
bnBoeV9yYWRpb190dXJuX29mZihzdHJ1Y3QgYjQzX3dsZGV2ICpkZXYpCiAJCSAg
ICAgfkI0M19OUEhZX1JGQ1RMX0NNRF9FTik7CiB9CiAKLSNkZWZpbmUgbnRhYl91
cGxvYWQoZGV2LCBvZmZzZXQsIGRhdGEpIGRvIHsgXAotCQl1bnNpZ25lZCBpbnQg
aTsJCQkJCQlcCi0JCWZvciAoaSA9IDA7IGkgPCAob2Zmc2V0IyNfU0laRSk7IGkr
KykJCQlcCi0JCQliNDNfbnRhYl93cml0ZShkZXYsIChvZmZzZXQpICsgaSwgKGRh
dGEpW2ldKTsJXAotCX0gd2hpbGUgKDApCi0KLS8qIFVwbG9hZCB0aGUgTi1QSFkg
dGFibGVzLiAqLworLyogVXBsb2FkIHRoZSBOLVBIWSB0YWJsZXMuCisgKiBodHRw
Oi8vYmNtLXY0LnNpcHNvbHV0aW9ucy5uZXQvODAyLjExL1BIWS9OL0luaXRUYWJs
ZXMKKyAqLwogc3RhdGljIHZvaWQgYjQzX25waHlfdGFibGVzX2luaXQoc3RydWN0
IGI0M193bGRldiAqZGV2KQogewotCS8qIFN0YXRpYyB0YWJsZXMgKi8KLQludGFi
X3VwbG9hZChkZXYsIEI0M19OVEFCX0ZSQU1FU1RSVUNULCBiNDNfbnRhYl9mcmFt
ZXN0cnVjdCk7Ci0JbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9GUkFNRUxULCBi
NDNfbnRhYl9mcmFtZWxvb2t1cCk7Ci0JbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRB
Ql9UTUFQLCBiNDNfbnRhYl90bWFwKTsKLQludGFiX3VwbG9hZChkZXYsIEI0M19O
VEFCX1REVFJOLCBiNDNfbnRhYl90ZHRybik7Ci0JbnRhYl91cGxvYWQoZGV2LCBC
NDNfTlRBQl9JTlRMRVZFTCwgYjQzX250YWJfaW50bGV2ZWwpOwotCW50YWJfdXBs
b2FkKGRldiwgQjQzX05UQUJfUElMT1QsIGI0M19udGFiX3BpbG90KTsKLQludGFi
X3VwbG9hZChkZXYsIEI0M19OVEFCX1BJTE9UTFQsIGI0M19udGFiX3BpbG90bHQp
OwotCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfVERJMjBBMCwgYjQzX250YWJf
dGRpMjBhMCk7Ci0JbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9UREkyMEExLCBi
NDNfbnRhYl90ZGkyMGExKTsKLQludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX1RE
STQwQTAsIGI0M19udGFiX3RkaTQwYTApOwotCW50YWJfdXBsb2FkKGRldiwgQjQz
X05UQUJfVERJNDBBMSwgYjQzX250YWJfdGRpNDBhMSk7Ci0JbnRhYl91cGxvYWQo
ZGV2LCBCNDNfTlRBQl9CREksIGI0M19udGFiX2JkaSk7Ci0JbnRhYl91cGxvYWQo
ZGV2LCBCNDNfTlRBQl9DSEFORVNULCBiNDNfbnRhYl9jaGFubmVsZXN0KTsKLQlu
dGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX01DUywgYjQzX250YWJfbWNzKTsKLQot
CS8qIFZvbGF0aWxlIHRhYmxlcyAqLwotCW50YWJfdXBsb2FkKGRldiwgQjQzX05U
QUJfTk9JU0VWQVIxMCwgYjQzX250YWJfbm9pc2V2YXIxMCk7Ci0JbnRhYl91cGxv
YWQoZGV2LCBCNDNfTlRBQl9OT0lTRVZBUjExLCBiNDNfbnRhYl9ub2lzZXZhcjEx
KTsKLQludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0MwX0VTVFBMVCwgYjQzX250
YWJfZXN0aW1hdGVwb3dlcmx0MCk7Ci0JbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRB
Ql9DMV9FU1RQTFQsIGI0M19udGFiX2VzdGltYXRlcG93ZXJsdDEpOwotCW50YWJf
dXBsb2FkKGRldiwgQjQzX05UQUJfQzBfQURKUExULCBiNDNfbnRhYl9hZGp1c3Rw
b3dlcjApOwotCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfQzFfQURKUExULCBi
NDNfbnRhYl9hZGp1c3Rwb3dlcjEpOwotCW50YWJfdXBsb2FkKGRldiwgQjQzX05U
QUJfQzBfR0FJTkNUTCwgYjQzX250YWJfZ2FpbmN0bDApOwotCW50YWJfdXBsb2Fk
KGRldiwgQjQzX05UQUJfQzFfR0FJTkNUTCwgYjQzX250YWJfZ2FpbmN0bDEpOwot
CW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfQzBfSVFMVCwgYjQzX250YWJfaXFs
dDApOwotCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfQzFfSVFMVCwgYjQzX250
YWJfaXFsdDEpOwotCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfQzBfTE9GRUVE
VEgsIGI0M19udGFiX2xvZnRsdDApOwotCW50YWJfdXBsb2FkKGRldiwgQjQzX05U
QUJfQzFfTE9GRUVEVEgsIGI0M19udGFiX2xvZnRsdDEpOworCWlmIChkZXYtPnBo
eS5yZXYgPCAzKQorCQliNDNfbnBoeV9yZXYwXzFfMl90YWJsZXNfaW5pdChkZXYp
OworCWVsc2UKKwkJYjQzX25waHlfcmV2M3BsdXNfdGFibGVzX2luaXQoZGV2KTsK
IH0KIAogc3RhdGljIHZvaWQgYjQzX25waHlfd29ya2Fyb3VuZHMoc3RydWN0IGI0
M193bGRldiAqZGV2KQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YjQzL3RhYmxlc19ucGh5LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvdGFi
bGVzX25waHkuYwppbmRleCA0ZTIzMzYzLi5kMGI5MWI1IDEwMDY0NAotLS0gYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9iNDMvdGFibGVzX25waHkuYworKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9iNDMvdGFibGVzX25waHkuYwpAQCAtMTMzNiw3ICsx
MzM2LDcgQEAgYjQzX25waHlfZ2V0X2NoYW50YWJlbnQoc3RydWN0IGI0M193bGRl
diAqZGV2LCB1OCBjaGFubmVsKQogfQogCiAKLWNvbnN0IHU4IGI0M19udGFiX2Fk
anVzdHBvd2VyMFtdID0geworc3RhdGljIGNvbnN0IHU4IGI0M19udGFiX2FkanVz
dHBvd2VyMFtdID0gewogCTB4MDAsIDB4MDAsIDB4MDAsIDB4MDAsIDB4MDEsIDB4
MDEsIDB4MDEsIDB4MDEsCiAJMHgwMiwgMHgwMiwgMHgwMiwgMHgwMiwgMHgwMywg
MHgwMywgMHgwMywgMHgwMywKIAkweDA0LCAweDA0LCAweDA0LCAweDA0LCAweDA1
LCAweDA1LCAweDA1LCAweDA1LApAQCAtMTM1NSw3ICsxMzU1LDcgQEAgY29uc3Qg
dTggYjQzX250YWJfYWRqdXN0cG93ZXIwW10gPSB7CiAJMHgxRSwgMHgxRSwgMHgx
RSwgMHgxRSwgMHgxRiwgMHgxRiwgMHgxRiwgMHgxRiwKIH07CiAKLWNvbnN0IHU4
IGI0M19udGFiX2FkanVzdHBvd2VyMVtdID0geworc3RhdGljIGNvbnN0IHU4IGI0
M19udGFiX2FkanVzdHBvd2VyMVtdID0gewogCTB4MDAsIDB4MDAsIDB4MDAsIDB4
MDAsIDB4MDEsIDB4MDEsIDB4MDEsIDB4MDEsCiAJMHgwMiwgMHgwMiwgMHgwMiwg
MHgwMiwgMHgwMywgMHgwMywgMHgwMywgMHgwMywKIAkweDA0LCAweDA0LCAweDA0
LCAweDA0LCAweDA1LCAweDA1LCAweDA1LCAweDA1LApAQCAtMTM3NCwxMSArMTM3
NCwxMSBAQCBjb25zdCB1OCBiNDNfbnRhYl9hZGp1c3Rwb3dlcjFbXSA9IHsKIAkw
eDFFLCAweDFFLCAweDFFLCAweDFFLCAweDFGLCAweDFGLCAweDFGLCAweDFGLAog
fTsKIAotY29uc3QgdTE2IGI0M19udGFiX2JkaVtdID0geworc3RhdGljIGNvbnN0
IHUxNiBiNDNfbnRhYl9iZGlbXSA9IHsKIAkweDAwNzAsIDB4MDEyNiwgMHgwMTJD
LCAweDAyNDYsIDB4MDQ4RCwgMHgwNEQyLAogfTsKIAotY29uc3QgdTMyIGI0M19u
dGFiX2NoYW5uZWxlc3RbXSA9IHsKK3N0YXRpYyBjb25zdCB1MzIgYjQzX250YWJf
Y2hhbm5lbGVzdFtdID0gewogCTB4NDQ0NDQ0NDQsIDB4NDQ0NDQ0NDQsIDB4NDQ0
NDQ0NDQsIDB4NDQ0NDQ0NDQsCiAJMHg0NDQ0NDQ0NCwgMHg0NDQ0NDQ0NCwgMHg0
NDQ0NDQ0NCwgMHg0NDQ0NDQ0NCwKIAkweDEwMTAxMDEwLCAweDEwMTAxMDEwLCAw
eDEwMTAxMDEwLCAweDEwMTAxMDEwLApAQCAtMTQwNSw3ICsxNDA1LDcgQEAgY29u
c3QgdTMyIGI0M19udGFiX2NoYW5uZWxlc3RbXSA9IHsKIAkweDEwMTAxMDEwLCAw
eDEwMTAxMDEwLCAweDEwMTAxMDEwLCAweDEwMTAxMDEwLAogfTsKIAotY29uc3Qg
dTggYjQzX250YWJfZXN0aW1hdGVwb3dlcmx0MFtdID0geworc3RhdGljIGNvbnN0
IHU4IGI0M19udGFiX2VzdGltYXRlcG93ZXJsdDBbXSA9IHsKIAkweDUwLCAweDRG
LCAweDRFLCAweDRELCAweDRDLCAweDRCLCAweDRBLCAweDQ5LAogCTB4NDgsIDB4
NDcsIDB4NDYsIDB4NDUsIDB4NDQsIDB4NDMsIDB4NDIsIDB4NDEsCiAJMHg0MCwg
MHgzRiwgMHgzRSwgMHgzRCwgMHgzQywgMHgzQiwgMHgzQSwgMHgzOSwKQEAgLTE0
MTYsNyArMTQxNiw3IEBAIGNvbnN0IHU4IGI0M19udGFiX2VzdGltYXRlcG93ZXJs
dDBbXSA9IHsKIAkweDE4LCAweDE3LCAweDE2LCAweDE1LCAweDE0LCAweDEzLCAw
eDEyLCAweDExLAogfTsKIAotY29uc3QgdTggYjQzX250YWJfZXN0aW1hdGVwb3dl
cmx0MVtdID0geworc3RhdGljIGNvbnN0IHU4IGI0M19udGFiX2VzdGltYXRlcG93
ZXJsdDFbXSA9IHsKIAkweDUwLCAweDRGLCAweDRFLCAweDRELCAweDRDLCAweDRC
LCAweDRBLCAweDQ5LAogCTB4NDgsIDB4NDcsIDB4NDYsIDB4NDUsIDB4NDQsIDB4
NDMsIDB4NDIsIDB4NDEsCiAJMHg0MCwgMHgzRiwgMHgzRSwgMHgzRCwgMHgzQywg
MHgzQiwgMHgzQSwgMHgzOSwKQEAgLTE0MjcsMTQgKzE0MjcsMTQgQEAgY29uc3Qg
dTggYjQzX250YWJfZXN0aW1hdGVwb3dlcmx0MVtdID0gewogCTB4MTgsIDB4MTcs
IDB4MTYsIDB4MTUsIDB4MTQsIDB4MTMsIDB4MTIsIDB4MTEsCiB9OwogCi1jb25z
dCB1OCBiNDNfbnRhYl9mcmFtZWxvb2t1cFtdID0geworc3RhdGljIGNvbnN0IHU4
IGI0M19udGFiX2ZyYW1lbG9va3VwW10gPSB7CiAJMHgwMiwgMHgwNCwgMHgxNCwg
MHgxNCwgMHgwMywgMHgwNSwgMHgxNiwgMHgxNiwKIAkweDBBLCAweDBDLCAweDFD
LCAweDFDLCAweDBCLCAweDBELCAweDFFLCAweDFFLAogCTB4MDYsIDB4MDgsIDB4
MTgsIDB4MTgsIDB4MDcsIDB4MDksIDB4MUEsIDB4MUEsCiAJMHgwRSwgMHgxMCwg
MHgyMCwgMHgyOCwgMHgwRiwgMHgxMSwgMHgyMiwgMHgyQSwKIH07CiAKLWNvbnN0
IHUzMiBiNDNfbnRhYl9mcmFtZXN0cnVjdFtdID0geworc3RhdGljIGNvbnN0IHUz
MiBiNDNfbnRhYl9mcmFtZXN0cnVjdFtdID0gewogCTB4MDgwMDRBMDQsIDB4MDAx
MDAwMDAsIDB4MDEwMDBBMDUsIDB4MDAxMDAwMjAsCiAJMHgwOTgwNDUwNiwgMHgw
MDEwMDAzMCwgMHgwOTgwNDUwNywgMHgwMDEwMDAzMCwKIAkweDAwMDAwMDAwLCAw
eDAwMDAwMDAwLCAweDAwMDAwMDAwLCAweDAwMDAwMDAwLApAQCAtMTY0NSw3ICsx
NjQ1LDcgQEAgY29uc3QgdTMyIGI0M19udGFiX2ZyYW1lc3RydWN0W10gPSB7CiAJ
MHgwMDAwMDAwMCwgMHgwMDAwMDAwMCwgMHgwMDAwMDAwMCwgMHgwMDAwMDAwMCwK
IH07CiAKLWNvbnN0IHUzMiBiNDNfbnRhYl9nYWluY3RsMFtdID0geworc3RhdGlj
IGNvbnN0IHUzMiBiNDNfbnRhYl9nYWluY3RsMFtdID0gewogCTB4MDA3RjAwM0Ys
IDB4MDA3RTAxM0YsIDB4MDA3RDAyM0UsIDB4MDA3QzAzM0UsCiAJMHgwMDdCMDQz
RCwgMHgwMDdBMDUzRCwgMHgwMDc5MDYzQywgMHgwMDc4MDczQywKIAkweDAwNzcw
ODNCLCAweDAwNzYwOTNCLCAweDAwNzUwQTNBLCAweDAwNzQwQjNBLApAQCAtMTY4
MCw3ICsxNjgwLDcgQEAgY29uc3QgdTMyIGI0M19udGFiX2dhaW5jdGwwW10gPSB7
CiAJMHgwMDAzMEMwMSwgMHgwMDAyMEQwMSwgMHgwMDAxMEUwMCwgMHgwMDAwMEYw
MCwKIH07CiAKLWNvbnN0IHUzMiBiNDNfbnRhYl9nYWluY3RsMVtdID0geworc3Rh
dGljIGNvbnN0IHUzMiBiNDNfbnRhYl9nYWluY3RsMVtdID0gewogCTB4MDA3RjAw
M0YsIDB4MDA3RTAxM0YsIDB4MDA3RDAyM0UsIDB4MDA3QzAzM0UsCiAJMHgwMDdC
MDQzRCwgMHgwMDdBMDUzRCwgMHgwMDc5MDYzQywgMHgwMDc4MDczQywKIAkweDAw
NzcwODNCLCAweDAwNzYwOTNCLCAweDAwNzUwQTNBLCAweDAwNzQwQjNBLApAQCAt
MTcxNSwxMiArMTcxNSwxMiBAQCBjb25zdCB1MzIgYjQzX250YWJfZ2FpbmN0bDFb
XSA9IHsKIAkweDAwMDMwQzAxLCAweDAwMDIwRDAxLCAweDAwMDEwRTAwLCAweDAw
MDAwRjAwLAogfTsKIAotY29uc3QgdTMyIGI0M19udGFiX2ludGxldmVsW10gPSB7
CitzdGF0aWMgY29uc3QgdTMyIGI0M19udGFiX2ludGxldmVsW10gPSB7CiAJMHgw
MDgwMjA3MCwgMHgwNjcxMTg4RCwgMHgwQTYwMTkyQywgMHgwQTMwMEU0NiwKIAkw
eDAwQzExODhELCAweDA4MDAyNEQyLCAweDAwMDAwMDcwLAogfTsKIAotY29uc3Qg
dTMyIGI0M19udGFiX2lxbHQwW10gPSB7CitzdGF0aWMgY29uc3QgdTMyIGI0M19u
dGFiX2lxbHQwW10gPSB7CiAJMHgwMDAwMDA3RiwgMHgwMDAwMDA3RiwgMHgwMDAw
MDA3RiwgMHgwMDAwMDA3RiwKIAkweDAwMDAwMDdGLCAweDAwMDAwMDdGLCAweDAw
MDAwMDdGLCAweDAwMDAwMDdGLAogCTB4MDAwMDAwN0YsIDB4MDAwMDAwN0YsIDB4
MDAwMDAwN0YsIDB4MDAwMDAwN0YsCkBAIC0xNzU1LDcgKzE3NTUsNyBAQCBjb25z
dCB1MzIgYjQzX250YWJfaXFsdDBbXSA9IHsKIAkweDAwMDAwMDdGLCAweDAwMDAw
MDdGLCAweDAwMDAwMDdGLCAweDAwMDAwMDdGLAogfTsKIAotY29uc3QgdTMyIGI0
M19udGFiX2lxbHQxW10gPSB7CitzdGF0aWMgY29uc3QgdTMyIGI0M19udGFiX2lx
bHQxW10gPSB7CiAJMHgwMDAwMDA3RiwgMHgwMDAwMDA3RiwgMHgwMDAwMDA3Riwg
MHgwMDAwMDA3RiwKIAkweDAwMDAwMDdGLCAweDAwMDAwMDdGLCAweDAwMDAwMDdG
LCAweDAwMDAwMDdGLAogCTB4MDAwMDAwN0YsIDB4MDAwMDAwN0YsIDB4MDAwMDAw
N0YsIDB4MDAwMDAwN0YsCkBAIC0xNzkwLDcgKzE3OTAsNyBAQCBjb25zdCB1MzIg
YjQzX250YWJfaXFsdDFbXSA9IHsKIAkweDAwMDAwMDdGLCAweDAwMDAwMDdGLCAw
eDAwMDAwMDdGLCAweDAwMDAwMDdGLAogfTsKIAotY29uc3QgdTE2IGI0M19udGFi
X2xvZnRsdDBbXSA9IHsKK3N0YXRpYyBjb25zdCB1MTYgYjQzX250YWJfbG9mdGx0
MFtdID0gewogCTB4MDAwMCwgMHgwMTAxLCAweDAwMDIsIDB4MDEwMywgMHgwMDAw
LCAweDAxMDEsCiAJMHgwMDAyLCAweDAxMDMsIDB4MDAwMCwgMHgwMTAxLCAweDAw
MDIsIDB4MDEwMywKIAkweDAwMDAsIDB4MDEwMSwgMHgwMDAyLCAweDAxMDMsIDB4
MDAwMCwgMHgwMTAxLApAQCAtMTgxNSw3ICsxODE1LDcgQEAgY29uc3QgdTE2IGI0
M19udGFiX2xvZnRsdDBbXSA9IHsKIAkweDAwMDIsIDB4MDEwMywKIH07CiAKLWNv
bnN0IHUxNiBiNDNfbnRhYl9sb2Z0bHQxW10gPSB7CitzdGF0aWMgY29uc3QgdTE2
IGI0M19udGFiX2xvZnRsdDFbXSA9IHsKIAkweDAwMDAsIDB4MDEwMSwgMHgwMDAy
LCAweDAxMDMsIDB4MDAwMCwgMHgwMTAxLAogCTB4MDAwMiwgMHgwMTAzLCAweDAw
MDAsIDB4MDEwMSwgMHgwMDAyLCAweDAxMDMsCiAJMHgwMDAwLCAweDAxMDEsIDB4
MDAwMiwgMHgwMTAzLCAweDAwMDAsIDB4MDEwMSwKQEAgLTE4NDAsNyArMTg0MCw3
IEBAIGNvbnN0IHUxNiBiNDNfbnRhYl9sb2Z0bHQxW10gPSB7CiAJMHgwMDAyLCAw
eDAxMDMsCiB9OwogCi1jb25zdCB1OCBiNDNfbnRhYl9tY3NbXSA9IHsKK3N0YXRp
YyBjb25zdCB1OCBiNDNfbnRhYl9tY3NbXSA9IHsKIAkweDAwLCAweDA4LCAweDBB
LCAweDEwLCAweDEyLCAweDE5LCAweDFBLCAweDFDLAogCTB4NDAsIDB4NDgsIDB4
NEEsIDB4NTAsIDB4NTIsIDB4NTksIDB4NUEsIDB4NUMsCiAJMHg4MCwgMHg4OCwg
MHg4QSwgMHg5MCwgMHg5MiwgMHg5OSwgMHg5QSwgMHg5QywKQEAgLTE4NTksNyAr
MTg1OSw3IEBAIGNvbnN0IHU4IGI0M19udGFiX21jc1tdID0gewogCTB4MDAsIDB4
MDAsIDB4MDAsIDB4MDAsIDB4MDAsIDB4MDAsIDB4MDAsIDB4MDAsCiB9OwogCi1j
b25zdCB1MzIgYjQzX250YWJfbm9pc2V2YXIxMFtdID0geworc3RhdGljIGNvbnN0
IHUzMiBiNDNfbnRhYl9ub2lzZXZhcjEwW10gPSB7CiAJMHgwMjBDMDIwQywgMHgw
MDAwMDE0RCwgMHgwMjBDMDIwQywgMHgwMDAwMDE0RCwKIAkweDAyMEMwMjBDLCAw
eDAwMDAwMTRELCAweDAyMEMwMjBDLCAweDAwMDAwMTRELAogCTB4MDIwQzAyMEMs
IDB4MDAwMDAxNEQsIDB4MDIwQzAyMEMsIDB4MDAwMDAxNEQsCkBAIC0xOTI2LDcg
KzE5MjYsNyBAQCBjb25zdCB1MzIgYjQzX250YWJfbm9pc2V2YXIxMFtdID0gewog
CTB4MDIwQzAyMEMsIDB4MDAwMDAxNEQsIDB4MDIwQzAyMEMsIDB4MDAwMDAxNEQs
CiB9OwogCi1jb25zdCB1MzIgYjQzX250YWJfbm9pc2V2YXIxMVtdID0geworc3Rh
dGljIGNvbnN0IHUzMiBiNDNfbnRhYl9ub2lzZXZhcjExW10gPSB7CiAJMHgwMjBD
MDIwQywgMHgwMDAwMDE0RCwgMHgwMjBDMDIwQywgMHgwMDAwMDE0RCwKIAkweDAy
MEMwMjBDLCAweDAwMDAwMTRELCAweDAyMEMwMjBDLCAweDAwMDAwMTRELAogCTB4
MDIwQzAyMEMsIDB4MDAwMDAxNEQsIDB4MDIwQzAyMEMsIDB4MDAwMDAxNEQsCkBA
IC0xOTkzLDcgKzE5OTMsNyBAQCBjb25zdCB1MzIgYjQzX250YWJfbm9pc2V2YXIx
MVtdID0gewogCTB4MDIwQzAyMEMsIDB4MDAwMDAxNEQsIDB4MDIwQzAyMEMsIDB4
MDAwMDAxNEQsCiB9OwogCi1jb25zdCB1MTYgYjQzX250YWJfcGlsb3RbXSA9IHsK
K3N0YXRpYyBjb25zdCB1MTYgYjQzX250YWJfcGlsb3RbXSA9IHsKIAkweEZGMDgs
IDB4RkYwOCwgMHhGRjA4LCAweEZGMDgsIDB4RkYwOCwgMHhGRjA4LAogCTB4RkYw
OCwgMHhGRjA4LCAweDgwRDUsIDB4ODBENSwgMHg4MEQ1LCAweDgwRDUsCiAJMHg4
MEQ1LCAweDgwRDUsIDB4ODBENSwgMHg4MEQ1LCAweEZGMEEsIDB4RkY4MiwKQEAg
LTIwMTEsMTIgKzIwMTEsMTIgQEAgY29uc3QgdTE2IGI0M19udGFiX3BpbG90W10g
PSB7CiAJMHhGMEEwLCAweEYwMjgsIDB4RkZGRiwgMHhGRkZGLAogfTsKIAotY29u
c3QgdTMyIGI0M19udGFiX3BpbG90bHRbXSA9IHsKK3N0YXRpYyBjb25zdCB1MzIg
YjQzX250YWJfcGlsb3RsdFtdID0gewogCTB4NzY1NDAxMjMsIDB4NjI0MDczNTEs
IDB4NzY1NDMyMDEsIDB4NzY1NDAyMTMsCiAJMHg3NjU0MDEyMywgMHg3NjQzMDUy
MSwKIH07CiAKLWNvbnN0IHUzMiBiNDNfbnRhYl90ZGkyMGEwW10gPSB7CitzdGF0
aWMgY29uc3QgdTMyIGI0M19udGFiX3RkaTIwYTBbXSA9IHsKIAkweDAwMDkxMjI2
LCAweDAwMEExNDI5LCAweDAwMEI1NkFELCAweDAwMEM1OEIwLAogCTB4MDAwRDVB
QjMsIDB4MDAwRTlDQjYsIDB4MDAwRjlFQkEsIDB4MDAwMEMxM0QsCiAJMHgwMDAy
MDMwMSwgMHgwMDAzMDUwNCwgMHgwMDA0MDcwOCwgMHgwMDA1MDkwQiwKQEAgLTIw
MzMsNyArMjAzMyw3IEBAIGNvbnN0IHUzMiBiNDNfbnRhYl90ZGkyMGEwW10gPSB7
CiAJMHgwMDAwMDAwMCwgMHgwMDAwMDAwMCwgMHgwMDAwMDAwMCwKIH07CiAKLWNv
bnN0IHUzMiBiNDNfbnRhYl90ZGkyMGExW10gPSB7CitzdGF0aWMgY29uc3QgdTMy
IGI0M19udGFiX3RkaTIwYTFbXSA9IHsKIAkweDAwMDE0QjI2LCAweDAwMDI4RDI5
LCAweDAwMDM5M0FELCAweDAwMDQ5NjMwLAogCTB4MDAwNUQ4MzMsIDB4MDAwNkRB
MzYsIDB4MDAwOTlDM0EsIDB4MDAwQTlFM0QsCiAJMHgwMDBCQzA4MSwgMHgwMDBD
QzI4NCwgMHgwMDBEQzQ4OCwgMHgwMDBGMDY4QiwKQEAgLTIwNTAsNyArMjA1MCw3
IEBAIGNvbnN0IHUzMiBiNDNfbnRhYl90ZGkyMGExW10gPSB7CiAJMHgwMDAwMDAw
MCwgMHgwMDAwMDAwMCwgMHgwMDAwMDAwMCwKIH07CiAKLWNvbnN0IHUzMiBiNDNf
bnRhYl90ZGk0MGEwW10gPSB7CitzdGF0aWMgY29uc3QgdTMyIGI0M19udGFiX3Rk
aTQwYTBbXSA9IHsKIAkweDAwMTFBMzQ2LCAweDAwMTM2Q0NGLCAweDAwMTRGNUQ5
LCAweDAwMTY0MUUyLAogCTB4MDAxN0NCNkIsIDB4MDAxOTU0NzUsIDB4MDAxQjIz
ODMsIDB4MDAxQ0FEMEMsCiAJMHgwMDFFNzYxNiwgMHgwMDAwODIxRiwgMHgwMDAy
MEJBOCwgMHgwMDAzRDRCMiwKQEAgLTIwODEsNyArMjA4MSw3IEBAIGNvbnN0IHUz
MiBiNDNfbnRhYl90ZGk0MGEwW10gPSB7CiAJMHgwMDAwMDAwMCwgMHgwMDAwMDAw
MCwKIH07CiAKLWNvbnN0IHUzMiBiNDNfbnRhYl90ZGk0MGExW10gPSB7CitzdGF0
aWMgY29uc3QgdTMyIGI0M19udGFiX3RkaTQwYTFbXSA9IHsKIAkweDAwMUVEQjM2
LCAweDAwMDEyOUNBLCAweDAwMDJCMzUzLCAweDAwMDQ3Q0RELAogCTB4MDAwNUM4
RTYsIDB4MDAwNzkxRUYsIDB4MDAwOTFCRjksIDB4MDAwQUFBMDcsCiAJMHgwMDBD
MzM5MSwgMHgwMDBERkQxQSwgMHgwMDEyMDkyMywgMHgwMDEzRDIyRCwKQEAgLTIx
MTIsNyArMjExMiw3IEBAIGNvbnN0IHUzMiBiNDNfbnRhYl90ZGk0MGExW10gPSB7
CiAJMHgwMDAwMDAwMCwgMHgwMDAwMDAwMCwKIH07CiAKLWNvbnN0IHUzMiBiNDNf
bnRhYl90ZHRybltdID0geworc3RhdGljIGNvbnN0IHUzMiBiNDNfbnRhYl90ZHRy
bltdID0gewogCTB4MDYxQzA2MUMsIDB4MDA1MEVFNjgsIDB4RjU5MkZFMzYsIDB4
RkU1MjEyRjYsCiAJMHgwMDAwMEMzOCwgMHhGRTUyMTJGNiwgMHhGNTkyRkUzNiwg
MHgwMDUwRUU2OCwKIAkweDA2MUMwNjFDLCAweEVFNjgwMDUwLCAweEZFMzZGNTky
LCAweDEyRjZGRTUyLApAQCAtMjI5MSw3ICsyMjkxLDcgQEAgY29uc3QgdTMyIGI0
M19udGFiX3RkdHJuW10gPSB7CiAJMHhGQTU4RkMwMCwgMHgwQjY0RkM3RSwgMHgw
ODAwRjdCNiwgMHgwMEYwMDZCRSwKIH07CiAKLWNvbnN0IHUzMiBiNDNfbnRhYl90
bWFwW10gPSB7CitzdGF0aWMgY29uc3QgdTMyIGI0M19udGFiX3RtYXBbXSA9IHsK
IAkweDhBODhBQTgwLCAweDhBQUFBQThBLCAweDhBOEE4QUE4LCAweDAwMDAwODg4
LAogCTB4ODgwMDAwMDAsIDB4OEE4QTg4QUEsIDB4OEFBODg4ODgsIDB4ODg4OEE4
QTgsCiAJMHhGMTExMTExMCwgMHgxMTExMTExMSwgMHgxMUYxMTExMSwgMHgwMDAw
MDExMSwKQEAgLTI0NzQsMyArMjQ3NCw1MSBAQCB2b2lkIGI0M19udGFiX3dyaXRl
KHN0cnVjdCBiNDNfd2xkZXYgKmRldiwgdTMyIG9mZnNldCwgdTMyIHZhbHVlKQog
CS8qIFNvbWUgY29tcGlsZXRpbWUgYXNzZXJ0aW9ucy4uLiAqLwogCWFzc2VydF9u
dGFiX2FycmF5X3NpemVzKCk7CiB9CisKKyNkZWZpbmUgbnRhYl91cGxvYWQoZGV2
LCBvZmZzZXQsIGRhdGEpIGRvIHsgXAorCQl1bnNpZ25lZCBpbnQgaTsJCQkJCQlc
CisJCWZvciAoaSA9IDA7IGkgPCAob2Zmc2V0IyNfU0laRSk7IGkrKykJCQlcCisJ
CQliNDNfbnRhYl93cml0ZShkZXYsIChvZmZzZXQpICsgaSwgKGRhdGEpW2ldKTsJ
XAorCX0gd2hpbGUgKDApCisKK3ZvaWQgYjQzX25waHlfcmV2MF8xXzJfdGFibGVz
X2luaXQoc3RydWN0IGI0M193bGRldiAqZGV2KQoreworCS8qIFN0YXRpYyB0YWJs
ZXMgKi8KKwludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0ZSQU1FU1RSVUNULCBi
NDNfbnRhYl9mcmFtZXN0cnVjdCk7CisJbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRB
Ql9GUkFNRUxULCBiNDNfbnRhYl9mcmFtZWxvb2t1cCk7CisJbnRhYl91cGxvYWQo
ZGV2LCBCNDNfTlRBQl9UTUFQLCBiNDNfbnRhYl90bWFwKTsKKwludGFiX3VwbG9h
ZChkZXYsIEI0M19OVEFCX1REVFJOLCBiNDNfbnRhYl90ZHRybik7CisJbnRhYl91
cGxvYWQoZGV2LCBCNDNfTlRBQl9JTlRMRVZFTCwgYjQzX250YWJfaW50bGV2ZWwp
OworCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfUElMT1QsIGI0M19udGFiX3Bp
bG90KTsKKwludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX1BJTE9UTFQsIGI0M19u
dGFiX3BpbG90bHQpOworCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfVERJMjBB
MCwgYjQzX250YWJfdGRpMjBhMCk7CisJbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRB
Ql9UREkyMEExLCBiNDNfbnRhYl90ZGkyMGExKTsKKwludGFiX3VwbG9hZChkZXYs
IEI0M19OVEFCX1RESTQwQTAsIGI0M19udGFiX3RkaTQwYTApOworCW50YWJfdXBs
b2FkKGRldiwgQjQzX05UQUJfVERJNDBBMSwgYjQzX250YWJfdGRpNDBhMSk7CisJ
bnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9CREksIGI0M19udGFiX2JkaSk7CisJ
bnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9DSEFORVNULCBiNDNfbnRhYl9jaGFu
bmVsZXN0KTsKKwludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX01DUywgYjQzX250
YWJfbWNzKTsKKworCS8qIFZvbGF0aWxlIHRhYmxlcyAqLworCW50YWJfdXBsb2Fk
KGRldiwgQjQzX05UQUJfTk9JU0VWQVIxMCwgYjQzX250YWJfbm9pc2V2YXIxMCk7
CisJbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9OT0lTRVZBUjExLCBiNDNfbnRh
Yl9ub2lzZXZhcjExKTsKKwludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0MwX0VT
VFBMVCwgYjQzX250YWJfZXN0aW1hdGVwb3dlcmx0MCk7CisJbnRhYl91cGxvYWQo
ZGV2LCBCNDNfTlRBQl9DMV9FU1RQTFQsIGI0M19udGFiX2VzdGltYXRlcG93ZXJs
dDEpOworCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfQzBfQURKUExULCBiNDNf
bnRhYl9hZGp1c3Rwb3dlcjApOworCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJf
QzFfQURKUExULCBiNDNfbnRhYl9hZGp1c3Rwb3dlcjEpOworCW50YWJfdXBsb2Fk
KGRldiwgQjQzX05UQUJfQzBfR0FJTkNUTCwgYjQzX250YWJfZ2FpbmN0bDApOwor
CW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfQzFfR0FJTkNUTCwgYjQzX250YWJf
Z2FpbmN0bDEpOworCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfQzBfSVFMVCwg
YjQzX250YWJfaXFsdDApOworCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfQzFf
SVFMVCwgYjQzX250YWJfaXFsdDEpOworCW50YWJfdXBsb2FkKGRldiwgQjQzX05U
QUJfQzBfTE9GRUVEVEgsIGI0M19udGFiX2xvZnRsdDApOworCW50YWJfdXBsb2Fk
KGRldiwgQjQzX05UQUJfQzFfTE9GRUVEVEgsIGI0M19udGFiX2xvZnRsdDEpOwor
fQorCit2b2lkIGI0M19ucGh5X3JldjNwbHVzX3RhYmxlc19pbml0KHN0cnVjdCBi
NDNfd2xkZXYgKmRldikKK3sKKwkvKiBTdGF0aWMgdGFibGVzICovCisJLyogVE9E
TyAqLworCisJLyogVm9sYXRpbGUgdGFibGVzICovCisJLyogVE9ETyAqLworfQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3RhYmxlc19ucGh5
LmggYi9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvdGFibGVzX25waHkuaAppbmRl
eCA0ZDQ5OGIwLi4xZjBhNjAyIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9iNDMvdGFibGVzX25waHkuaAorKysgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9iNDMvdGFibGVzX25waHkuaApAQCAtMTI4LDMyICsxMjgsNyBAQCBiNDNfbnBo
eV9nZXRfY2hhbnRhYmVudChzdHJ1Y3QgYjQzX3dsZGV2ICpkZXYsIHU4IGNoYW5u
ZWwpOwogCiB2b2lkIGI0M19udGFiX3dyaXRlKHN0cnVjdCBiNDNfd2xkZXYgKmRl
diwgdTMyIG9mZnNldCwgdTMyIHZhbHVlKTsKIAotZXh0ZXJuIGNvbnN0IHU4IGI0
M19udGFiX2FkanVzdHBvd2VyMFtdOwotZXh0ZXJuIGNvbnN0IHU4IGI0M19udGFi
X2FkanVzdHBvd2VyMVtdOwotZXh0ZXJuIGNvbnN0IHUxNiBiNDNfbnRhYl9iZGlb
XTsKLWV4dGVybiBjb25zdCB1MzIgYjQzX250YWJfY2hhbm5lbGVzdFtdOwotZXh0
ZXJuIGNvbnN0IHU4IGI0M19udGFiX2VzdGltYXRlcG93ZXJsdDBbXTsKLWV4dGVy
biBjb25zdCB1OCBiNDNfbnRhYl9lc3RpbWF0ZXBvd2VybHQxW107Ci1leHRlcm4g
Y29uc3QgdTggYjQzX250YWJfZnJhbWVsb29rdXBbXTsKLWV4dGVybiBjb25zdCB1
MzIgYjQzX250YWJfZnJhbWVzdHJ1Y3RbXTsKLWV4dGVybiBjb25zdCB1MzIgYjQz
X250YWJfZ2FpbmN0bDBbXTsKLWV4dGVybiBjb25zdCB1MzIgYjQzX250YWJfZ2Fp
bmN0bDFbXTsKLWV4dGVybiBjb25zdCB1MzIgYjQzX250YWJfaW50bGV2ZWxbXTsK
LWV4dGVybiBjb25zdCB1MzIgYjQzX250YWJfaXFsdDBbXTsKLWV4dGVybiBjb25z
dCB1MzIgYjQzX250YWJfaXFsdDFbXTsKLWV4dGVybiBjb25zdCB1MTYgYjQzX250
YWJfbG9mdGx0MFtdOwotZXh0ZXJuIGNvbnN0IHUxNiBiNDNfbnRhYl9sb2Z0bHQx
W107Ci1leHRlcm4gY29uc3QgdTggYjQzX250YWJfbWNzW107Ci1leHRlcm4gY29u
c3QgdTMyIGI0M19udGFiX25vaXNldmFyMTBbXTsKLWV4dGVybiBjb25zdCB1MzIg
YjQzX250YWJfbm9pc2V2YXIxMVtdOwotZXh0ZXJuIGNvbnN0IHUxNiBiNDNfbnRh
Yl9waWxvdFtdOwotZXh0ZXJuIGNvbnN0IHUzMiBiNDNfbnRhYl9waWxvdGx0W107
Ci1leHRlcm4gY29uc3QgdTMyIGI0M19udGFiX3RkaTIwYTBbXTsKLWV4dGVybiBj
b25zdCB1MzIgYjQzX250YWJfdGRpMjBhMVtdOwotZXh0ZXJuIGNvbnN0IHUzMiBi
NDNfbnRhYl90ZGk0MGEwW107Ci1leHRlcm4gY29uc3QgdTMyIGI0M19udGFiX3Rk
aTQwYTFbXTsKLWV4dGVybiBjb25zdCB1MzIgYjQzX250YWJfdGR0cm5bXTsKLWV4
dGVybiBjb25zdCB1MzIgYjQzX250YWJfdG1hcFtdOwotCit2b2lkIGI0M19ucGh5
X3JldjBfMV8yX3RhYmxlc19pbml0KHN0cnVjdCBiNDNfd2xkZXYgKmRldik7Cit2
b2lkIGI0M19ucGh5X3JldjNwbHVzX3RhYmxlc19pbml0KHN0cnVjdCBiNDNfd2xk
ZXYgKmRldik7CiAKICNlbmRpZiAvKiBCNDNfVEFCTEVTX05QSFlfSF8gKi8KLS0g
CjEuNi40LjIKCg==

------------UKtM6x0WZFhbNXXUyPDIXX--

