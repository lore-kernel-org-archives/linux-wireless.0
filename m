Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:65080 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab0ABR5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 12:57:25 -0500
Received: by fxm25 with SMTP id 25so7742005fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jan 2010 09:57:22 -0800 (PST)
Content-Type: multipart/mixed; boundary=----------8iZTJx8JwXS8Edc3qjiQy1
Date: Sat, 02 Jan 2010 18:58:36 +0100
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: N-PHY: clean table init, check PHY rev (V3)
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
	"Michael Buesch" <mb@bu3sch.de>
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u5w2vyof9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------------8iZTJx8JwXS8Edc3qjiQy1
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: Quoted-Printable

Hopefully with Michaels's mysterious suggestion applied :)

 From 3d54059593785a820789c5af99ca1373eaf6b2c7 Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Rafa=3DC5=3D82=3D20Mi=3DC5=3D82ecki?=3D <zajec5@gmail.=
com>
Date: Sat, 2 Jan 2010 18:50:25 +0100
Subject: [PATCH] b43: N-PHY: clean table init, check PHY rev (V3)
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
index 992318a..a662ced 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -197,44 +197,15 @@ void b43_nphy_radio_turn_off(struct b43_wldev *dev=
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
------------8iZTJx8JwXS8Edc3qjiQy1
Content-Disposition: attachment; filename=0001-b43-N-PHY-clean-table-init-check-PHY-rev-V3.patch
Content-Type: application/octet-stream; name=0001-b43-N-PHY-clean-table-init-check-PHY-rev-V3.patch
Content-Transfer-Encoding: Base64

RnJvbSAzZDU0MDU5NTkzNzg1YTgyMDc4OWM1YWY5OWNhMTM3M2VhZjZiMmM3IE1v
biBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UmFmYT1DNT04
Mj0yME1pPUM1PTgyZWNraT89IDx6YWplYzVAZ21haWwuY29tPgpEYXRlOiBTYXQs
IDIgSmFuIDIwMTAgMTg6NTA6MjUgKzAxMDAKU3ViamVjdDogW1BBVENIXSBiNDM6
IE4tUEhZOiBjbGVhbiB0YWJsZSBpbml0LCBjaGVjayBQSFkgcmV2IChWMykKTUlN
RS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0
PVVURi04CkNvbnRlbnQtVHJhbnNmZXItRW5jb2Rpbmc6IDhiaXQKCk1vdmUgdGFi
bGUgaW5pdCB0byB0YWJsZXNfbnBoeS5jLCBkZXRlY3QgbmV3ZXIgUEhZIHdoaWNo
IHVzZSBkaWZmZXJlbnQgaW5pdC4KV2UgZG9uJ3QgaW5pdCBuZXdlciBQSFlzIHll
dCBidXQgdGhpcyBhdCBsZWFzdCBzaG93cyB3aGF0IG1vcmUgaXMgbmVlZGVkLgoK
VjI6IE1ha2Ugc29tZSBmdW5jdGlvbnMgYW5kIHRhYmxlcyBzdGF0aWMKVjM6IEp1
c3QgZHJvcCBzdGF0aWMgdGFibGUgZGVjbGFyYXRpb25zIGZyb20gaGVhZGVyCgpT
aWduZWQtb2ZmLWJ5OiBSYWZhxYIgTWnFgmVja2kgPHphamVjNUBnbWFpbC5jb20+
Ci0tLQogZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3BoeV9uLmMgICAgICAgfCAg
IDQzICsrLS0tLS0tLS0tLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My90YWJs
ZXNfbnBoeS5jIHwgIDEwMCArKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0t
CiBkcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvdGFibGVzX25waHkuaCB8ICAgMjkg
Ky0tLS0tLS0tLQogMyBmaWxlcyBjaGFuZ2VkLCA4MyBpbnNlcnRpb25zKCspLCA4
OSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9iNDMvcGh5X24uYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My9waHlfbi5j
CmluZGV4IDk5MjMxOGEuLmE2NjJjZWQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2I0My9waHlfbi5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2I0My9waHlfbi5jCkBAIC0xOTcsNDQgKzE5NywxNSBAQCB2b2lkIGI0M19ucGh5
X3JhZGlvX3R1cm5fb2ZmKHN0cnVjdCBiNDNfd2xkZXYgKmRldikKIAkJICAgICB+
QjQzX05QSFlfUkZDVExfQ01EX0VOKTsKIH0KIAotI2RlZmluZSBudGFiX3VwbG9h
ZChkZXYsIG9mZnNldCwgZGF0YSkgZG8geyBcCi0JCXVuc2lnbmVkIGludCBpOwkJ
CQkJCVwKLQkJZm9yIChpID0gMDsgaSA8IChvZmZzZXQjI19TSVpFKTsgaSsrKQkJ
CVwKLQkJCWI0M19udGFiX3dyaXRlKGRldiwgKG9mZnNldCkgKyBpLCAoZGF0YSlb
aV0pOwlcCi0JfSB3aGlsZSAoMCkKLQotLyogVXBsb2FkIHRoZSBOLVBIWSB0YWJs
ZXMuICovCisvKiBVcGxvYWQgdGhlIE4tUEhZIHRhYmxlcy4KKyAqIGh0dHA6Ly9i
Y20tdjQuc2lwc29sdXRpb25zLm5ldC84MDIuMTEvUEhZL04vSW5pdFRhYmxlcwor
ICovICAKIHN0YXRpYyB2b2lkIGI0M19ucGh5X3RhYmxlc19pbml0KHN0cnVjdCBi
NDNfd2xkZXYgKmRldikKIHsKLQkvKiBTdGF0aWMgdGFibGVzICovCi0JbnRhYl91
cGxvYWQoZGV2LCBCNDNfTlRBQl9GUkFNRVNUUlVDVCwgYjQzX250YWJfZnJhbWVz
dHJ1Y3QpOwotCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfRlJBTUVMVCwgYjQz
X250YWJfZnJhbWVsb29rdXApOwotCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJf
VE1BUCwgYjQzX250YWJfdG1hcCk7Ci0JbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRB
Ql9URFRSTiwgYjQzX250YWJfdGR0cm4pOwotCW50YWJfdXBsb2FkKGRldiwgQjQz
X05UQUJfSU5UTEVWRUwsIGI0M19udGFiX2ludGxldmVsKTsKLQludGFiX3VwbG9h
ZChkZXYsIEI0M19OVEFCX1BJTE9ULCBiNDNfbnRhYl9waWxvdCk7Ci0JbnRhYl91
cGxvYWQoZGV2LCBCNDNfTlRBQl9QSUxPVExULCBiNDNfbnRhYl9waWxvdGx0KTsK
LQludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX1RESTIwQTAsIGI0M19udGFiX3Rk
aTIwYTApOwotCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfVERJMjBBMSwgYjQz
X250YWJfdGRpMjBhMSk7Ci0JbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9UREk0
MEEwLCBiNDNfbnRhYl90ZGk0MGEwKTsKLQludGFiX3VwbG9hZChkZXYsIEI0M19O
VEFCX1RESTQwQTEsIGI0M19udGFiX3RkaTQwYTEpOwotCW50YWJfdXBsb2FkKGRl
diwgQjQzX05UQUJfQkRJLCBiNDNfbnRhYl9iZGkpOwotCW50YWJfdXBsb2FkKGRl
diwgQjQzX05UQUJfQ0hBTkVTVCwgYjQzX250YWJfY2hhbm5lbGVzdCk7Ci0JbnRh
Yl91cGxvYWQoZGV2LCBCNDNfTlRBQl9NQ1MsIGI0M19udGFiX21jcyk7Ci0KLQkv
KiBWb2xhdGlsZSB0YWJsZXMgKi8KLQludGFiX3VwbG9hZChkZXYsIEI0M19OVEFC
X05PSVNFVkFSMTAsIGI0M19udGFiX25vaXNldmFyMTApOwotCW50YWJfdXBsb2Fk
KGRldiwgQjQzX05UQUJfTk9JU0VWQVIxMSwgYjQzX250YWJfbm9pc2V2YXIxMSk7
Ci0JbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9DMF9FU1RQTFQsIGI0M19udGFi
X2VzdGltYXRlcG93ZXJsdDApOwotCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJf
QzFfRVNUUExULCBiNDNfbnRhYl9lc3RpbWF0ZXBvd2VybHQxKTsKLQludGFiX3Vw
bG9hZChkZXYsIEI0M19OVEFCX0MwX0FESlBMVCwgYjQzX250YWJfYWRqdXN0cG93
ZXIwKTsKLQludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0MxX0FESlBMVCwgYjQz
X250YWJfYWRqdXN0cG93ZXIxKTsKLQludGFiX3VwbG9hZChkZXYsIEI0M19OVEFC
X0MwX0dBSU5DVEwsIGI0M19udGFiX2dhaW5jdGwwKTsKLQludGFiX3VwbG9hZChk
ZXYsIEI0M19OVEFCX0MxX0dBSU5DVEwsIGI0M19udGFiX2dhaW5jdGwxKTsKLQlu
dGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0MwX0lRTFQsIGI0M19udGFiX2lxbHQw
KTsKLQludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0MxX0lRTFQsIGI0M19udGFi
X2lxbHQxKTsKLQludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0MwX0xPRkVFRFRI
LCBiNDNfbnRhYl9sb2Z0bHQwKTsKLQludGFiX3VwbG9hZChkZXYsIEI0M19OVEFC
X0MxX0xPRkVFRFRILCBiNDNfbnRhYl9sb2Z0bHQxKTsKKwlpZiAoZGV2LT5waHku
cmV2IDwgMykKKwkJYjQzX25waHlfcmV2MF8xXzJfdGFibGVzX2luaXQoZGV2KTsK
KwllbHNlCisJCWI0M19ucGh5X3JldjNwbHVzX3RhYmxlc19pbml0KGRldik7CiB9
CiAKIHN0YXRpYyB2b2lkIGI0M19ucGh5X3dvcmthcm91bmRzKHN0cnVjdCBiNDNf
d2xkZXYgKmRldikKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0
My90YWJsZXNfbnBoeS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3RhYmxl
c19ucGh5LmMKaW5kZXggNGUyMzM2My4uZDBiOTFiNSAxMDA2NDQKLS0tIGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYjQzL3RhYmxlc19ucGh5LmMKKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYjQzL3RhYmxlc19ucGh5LmMKQEAgLTEzMzYsNyArMTMz
Niw3IEBAIGI0M19ucGh5X2dldF9jaGFudGFiZW50KHN0cnVjdCBiNDNfd2xkZXYg
KmRldiwgdTggY2hhbm5lbCkKIH0KIAogCi1jb25zdCB1OCBiNDNfbnRhYl9hZGp1
c3Rwb3dlcjBbXSA9IHsKK3N0YXRpYyBjb25zdCB1OCBiNDNfbnRhYl9hZGp1c3Rw
b3dlcjBbXSA9IHsKIAkweDAwLCAweDAwLCAweDAwLCAweDAwLCAweDAxLCAweDAx
LCAweDAxLCAweDAxLAogCTB4MDIsIDB4MDIsIDB4MDIsIDB4MDIsIDB4MDMsIDB4
MDMsIDB4MDMsIDB4MDMsCiAJMHgwNCwgMHgwNCwgMHgwNCwgMHgwNCwgMHgwNSwg
MHgwNSwgMHgwNSwgMHgwNSwKQEAgLTEzNTUsNyArMTM1NSw3IEBAIGNvbnN0IHU4
IGI0M19udGFiX2FkanVzdHBvd2VyMFtdID0gewogCTB4MUUsIDB4MUUsIDB4MUUs
IDB4MUUsIDB4MUYsIDB4MUYsIDB4MUYsIDB4MUYsCiB9OwogCi1jb25zdCB1OCBi
NDNfbnRhYl9hZGp1c3Rwb3dlcjFbXSA9IHsKK3N0YXRpYyBjb25zdCB1OCBiNDNf
bnRhYl9hZGp1c3Rwb3dlcjFbXSA9IHsKIAkweDAwLCAweDAwLCAweDAwLCAweDAw
LCAweDAxLCAweDAxLCAweDAxLCAweDAxLAogCTB4MDIsIDB4MDIsIDB4MDIsIDB4
MDIsIDB4MDMsIDB4MDMsIDB4MDMsIDB4MDMsCiAJMHgwNCwgMHgwNCwgMHgwNCwg
MHgwNCwgMHgwNSwgMHgwNSwgMHgwNSwgMHgwNSwKQEAgLTEzNzQsMTEgKzEzNzQs
MTEgQEAgY29uc3QgdTggYjQzX250YWJfYWRqdXN0cG93ZXIxW10gPSB7CiAJMHgx
RSwgMHgxRSwgMHgxRSwgMHgxRSwgMHgxRiwgMHgxRiwgMHgxRiwgMHgxRiwKIH07
CiAKLWNvbnN0IHUxNiBiNDNfbnRhYl9iZGlbXSA9IHsKK3N0YXRpYyBjb25zdCB1
MTYgYjQzX250YWJfYmRpW10gPSB7CiAJMHgwMDcwLCAweDAxMjYsIDB4MDEyQywg
MHgwMjQ2LCAweDA0OEQsIDB4MDREMiwKIH07CiAKLWNvbnN0IHUzMiBiNDNfbnRh
Yl9jaGFubmVsZXN0W10gPSB7CitzdGF0aWMgY29uc3QgdTMyIGI0M19udGFiX2No
YW5uZWxlc3RbXSA9IHsKIAkweDQ0NDQ0NDQ0LCAweDQ0NDQ0NDQ0LCAweDQ0NDQ0
NDQ0LCAweDQ0NDQ0NDQ0LAogCTB4NDQ0NDQ0NDQsIDB4NDQ0NDQ0NDQsIDB4NDQ0
NDQ0NDQsIDB4NDQ0NDQ0NDQsCiAJMHgxMDEwMTAxMCwgMHgxMDEwMTAxMCwgMHgx
MDEwMTAxMCwgMHgxMDEwMTAxMCwKQEAgLTE0MDUsNyArMTQwNSw3IEBAIGNvbnN0
IHUzMiBiNDNfbnRhYl9jaGFubmVsZXN0W10gPSB7CiAJMHgxMDEwMTAxMCwgMHgx
MDEwMTAxMCwgMHgxMDEwMTAxMCwgMHgxMDEwMTAxMCwKIH07CiAKLWNvbnN0IHU4
IGI0M19udGFiX2VzdGltYXRlcG93ZXJsdDBbXSA9IHsKK3N0YXRpYyBjb25zdCB1
OCBiNDNfbnRhYl9lc3RpbWF0ZXBvd2VybHQwW10gPSB7CiAJMHg1MCwgMHg0Riwg
MHg0RSwgMHg0RCwgMHg0QywgMHg0QiwgMHg0QSwgMHg0OSwKIAkweDQ4LCAweDQ3
LCAweDQ2LCAweDQ1LCAweDQ0LCAweDQzLCAweDQyLCAweDQxLAogCTB4NDAsIDB4
M0YsIDB4M0UsIDB4M0QsIDB4M0MsIDB4M0IsIDB4M0EsIDB4MzksCkBAIC0xNDE2
LDcgKzE0MTYsNyBAQCBjb25zdCB1OCBiNDNfbnRhYl9lc3RpbWF0ZXBvd2VybHQw
W10gPSB7CiAJMHgxOCwgMHgxNywgMHgxNiwgMHgxNSwgMHgxNCwgMHgxMywgMHgx
MiwgMHgxMSwKIH07CiAKLWNvbnN0IHU4IGI0M19udGFiX2VzdGltYXRlcG93ZXJs
dDFbXSA9IHsKK3N0YXRpYyBjb25zdCB1OCBiNDNfbnRhYl9lc3RpbWF0ZXBvd2Vy
bHQxW10gPSB7CiAJMHg1MCwgMHg0RiwgMHg0RSwgMHg0RCwgMHg0QywgMHg0Qiwg
MHg0QSwgMHg0OSwKIAkweDQ4LCAweDQ3LCAweDQ2LCAweDQ1LCAweDQ0LCAweDQz
LCAweDQyLCAweDQxLAogCTB4NDAsIDB4M0YsIDB4M0UsIDB4M0QsIDB4M0MsIDB4
M0IsIDB4M0EsIDB4MzksCkBAIC0xNDI3LDE0ICsxNDI3LDE0IEBAIGNvbnN0IHU4
IGI0M19udGFiX2VzdGltYXRlcG93ZXJsdDFbXSA9IHsKIAkweDE4LCAweDE3LCAw
eDE2LCAweDE1LCAweDE0LCAweDEzLCAweDEyLCAweDExLAogfTsKIAotY29uc3Qg
dTggYjQzX250YWJfZnJhbWVsb29rdXBbXSA9IHsKK3N0YXRpYyBjb25zdCB1OCBi
NDNfbnRhYl9mcmFtZWxvb2t1cFtdID0gewogCTB4MDIsIDB4MDQsIDB4MTQsIDB4
MTQsIDB4MDMsIDB4MDUsIDB4MTYsIDB4MTYsCiAJMHgwQSwgMHgwQywgMHgxQywg
MHgxQywgMHgwQiwgMHgwRCwgMHgxRSwgMHgxRSwKIAkweDA2LCAweDA4LCAweDE4
LCAweDE4LCAweDA3LCAweDA5LCAweDFBLCAweDFBLAogCTB4MEUsIDB4MTAsIDB4
MjAsIDB4MjgsIDB4MEYsIDB4MTEsIDB4MjIsIDB4MkEsCiB9OwogCi1jb25zdCB1
MzIgYjQzX250YWJfZnJhbWVzdHJ1Y3RbXSA9IHsKK3N0YXRpYyBjb25zdCB1MzIg
YjQzX250YWJfZnJhbWVzdHJ1Y3RbXSA9IHsKIAkweDA4MDA0QTA0LCAweDAwMTAw
MDAwLCAweDAxMDAwQTA1LCAweDAwMTAwMDIwLAogCTB4MDk4MDQ1MDYsIDB4MDAx
MDAwMzAsIDB4MDk4MDQ1MDcsIDB4MDAxMDAwMzAsCiAJMHgwMDAwMDAwMCwgMHgw
MDAwMDAwMCwgMHgwMDAwMDAwMCwgMHgwMDAwMDAwMCwKQEAgLTE2NDUsNyArMTY0
NSw3IEBAIGNvbnN0IHUzMiBiNDNfbnRhYl9mcmFtZXN0cnVjdFtdID0gewogCTB4
MDAwMDAwMDAsIDB4MDAwMDAwMDAsIDB4MDAwMDAwMDAsIDB4MDAwMDAwMDAsCiB9
OwogCi1jb25zdCB1MzIgYjQzX250YWJfZ2FpbmN0bDBbXSA9IHsKK3N0YXRpYyBj
b25zdCB1MzIgYjQzX250YWJfZ2FpbmN0bDBbXSA9IHsKIAkweDAwN0YwMDNGLCAw
eDAwN0UwMTNGLCAweDAwN0QwMjNFLCAweDAwN0MwMzNFLAogCTB4MDA3QjA0M0Qs
IDB4MDA3QTA1M0QsIDB4MDA3OTA2M0MsIDB4MDA3ODA3M0MsCiAJMHgwMDc3MDgz
QiwgMHgwMDc2MDkzQiwgMHgwMDc1MEEzQSwgMHgwMDc0MEIzQSwKQEAgLTE2ODAs
NyArMTY4MCw3IEBAIGNvbnN0IHUzMiBiNDNfbnRhYl9nYWluY3RsMFtdID0gewog
CTB4MDAwMzBDMDEsIDB4MDAwMjBEMDEsIDB4MDAwMTBFMDAsIDB4MDAwMDBGMDAs
CiB9OwogCi1jb25zdCB1MzIgYjQzX250YWJfZ2FpbmN0bDFbXSA9IHsKK3N0YXRp
YyBjb25zdCB1MzIgYjQzX250YWJfZ2FpbmN0bDFbXSA9IHsKIAkweDAwN0YwMDNG
LCAweDAwN0UwMTNGLCAweDAwN0QwMjNFLCAweDAwN0MwMzNFLAogCTB4MDA3QjA0
M0QsIDB4MDA3QTA1M0QsIDB4MDA3OTA2M0MsIDB4MDA3ODA3M0MsCiAJMHgwMDc3
MDgzQiwgMHgwMDc2MDkzQiwgMHgwMDc1MEEzQSwgMHgwMDc0MEIzQSwKQEAgLTE3
MTUsMTIgKzE3MTUsMTIgQEAgY29uc3QgdTMyIGI0M19udGFiX2dhaW5jdGwxW10g
PSB7CiAJMHgwMDAzMEMwMSwgMHgwMDAyMEQwMSwgMHgwMDAxMEUwMCwgMHgwMDAw
MEYwMCwKIH07CiAKLWNvbnN0IHUzMiBiNDNfbnRhYl9pbnRsZXZlbFtdID0gewor
c3RhdGljIGNvbnN0IHUzMiBiNDNfbnRhYl9pbnRsZXZlbFtdID0gewogCTB4MDA4
MDIwNzAsIDB4MDY3MTE4OEQsIDB4MEE2MDE5MkMsIDB4MEEzMDBFNDYsCiAJMHgw
MEMxMTg4RCwgMHgwODAwMjREMiwgMHgwMDAwMDA3MCwKIH07CiAKLWNvbnN0IHUz
MiBiNDNfbnRhYl9pcWx0MFtdID0geworc3RhdGljIGNvbnN0IHUzMiBiNDNfbnRh
Yl9pcWx0MFtdID0gewogCTB4MDAwMDAwN0YsIDB4MDAwMDAwN0YsIDB4MDAwMDAw
N0YsIDB4MDAwMDAwN0YsCiAJMHgwMDAwMDA3RiwgMHgwMDAwMDA3RiwgMHgwMDAw
MDA3RiwgMHgwMDAwMDA3RiwKIAkweDAwMDAwMDdGLCAweDAwMDAwMDdGLCAweDAw
MDAwMDdGLCAweDAwMDAwMDdGLApAQCAtMTc1NSw3ICsxNzU1LDcgQEAgY29uc3Qg
dTMyIGI0M19udGFiX2lxbHQwW10gPSB7CiAJMHgwMDAwMDA3RiwgMHgwMDAwMDA3
RiwgMHgwMDAwMDA3RiwgMHgwMDAwMDA3RiwKIH07CiAKLWNvbnN0IHUzMiBiNDNf
bnRhYl9pcWx0MVtdID0geworc3RhdGljIGNvbnN0IHUzMiBiNDNfbnRhYl9pcWx0
MVtdID0gewogCTB4MDAwMDAwN0YsIDB4MDAwMDAwN0YsIDB4MDAwMDAwN0YsIDB4
MDAwMDAwN0YsCiAJMHgwMDAwMDA3RiwgMHgwMDAwMDA3RiwgMHgwMDAwMDA3Riwg
MHgwMDAwMDA3RiwKIAkweDAwMDAwMDdGLCAweDAwMDAwMDdGLCAweDAwMDAwMDdG
LCAweDAwMDAwMDdGLApAQCAtMTc5MCw3ICsxNzkwLDcgQEAgY29uc3QgdTMyIGI0
M19udGFiX2lxbHQxW10gPSB7CiAJMHgwMDAwMDA3RiwgMHgwMDAwMDA3RiwgMHgw
MDAwMDA3RiwgMHgwMDAwMDA3RiwKIH07CiAKLWNvbnN0IHUxNiBiNDNfbnRhYl9s
b2Z0bHQwW10gPSB7CitzdGF0aWMgY29uc3QgdTE2IGI0M19udGFiX2xvZnRsdDBb
XSA9IHsKIAkweDAwMDAsIDB4MDEwMSwgMHgwMDAyLCAweDAxMDMsIDB4MDAwMCwg
MHgwMTAxLAogCTB4MDAwMiwgMHgwMTAzLCAweDAwMDAsIDB4MDEwMSwgMHgwMDAy
LCAweDAxMDMsCiAJMHgwMDAwLCAweDAxMDEsIDB4MDAwMiwgMHgwMTAzLCAweDAw
MDAsIDB4MDEwMSwKQEAgLTE4MTUsNyArMTgxNSw3IEBAIGNvbnN0IHUxNiBiNDNf
bnRhYl9sb2Z0bHQwW10gPSB7CiAJMHgwMDAyLCAweDAxMDMsCiB9OwogCi1jb25z
dCB1MTYgYjQzX250YWJfbG9mdGx0MVtdID0geworc3RhdGljIGNvbnN0IHUxNiBi
NDNfbnRhYl9sb2Z0bHQxW10gPSB7CiAJMHgwMDAwLCAweDAxMDEsIDB4MDAwMiwg
MHgwMTAzLCAweDAwMDAsIDB4MDEwMSwKIAkweDAwMDIsIDB4MDEwMywgMHgwMDAw
LCAweDAxMDEsIDB4MDAwMiwgMHgwMTAzLAogCTB4MDAwMCwgMHgwMTAxLCAweDAw
MDIsIDB4MDEwMywgMHgwMDAwLCAweDAxMDEsCkBAIC0xODQwLDcgKzE4NDAsNyBA
QCBjb25zdCB1MTYgYjQzX250YWJfbG9mdGx0MVtdID0gewogCTB4MDAwMiwgMHgw
MTAzLAogfTsKIAotY29uc3QgdTggYjQzX250YWJfbWNzW10gPSB7CitzdGF0aWMg
Y29uc3QgdTggYjQzX250YWJfbWNzW10gPSB7CiAJMHgwMCwgMHgwOCwgMHgwQSwg
MHgxMCwgMHgxMiwgMHgxOSwgMHgxQSwgMHgxQywKIAkweDQwLCAweDQ4LCAweDRB
LCAweDUwLCAweDUyLCAweDU5LCAweDVBLCAweDVDLAogCTB4ODAsIDB4ODgsIDB4
OEEsIDB4OTAsIDB4OTIsIDB4OTksIDB4OUEsIDB4OUMsCkBAIC0xODU5LDcgKzE4
NTksNyBAQCBjb25zdCB1OCBiNDNfbnRhYl9tY3NbXSA9IHsKIAkweDAwLCAweDAw
LCAweDAwLCAweDAwLCAweDAwLCAweDAwLCAweDAwLCAweDAwLAogfTsKIAotY29u
c3QgdTMyIGI0M19udGFiX25vaXNldmFyMTBbXSA9IHsKK3N0YXRpYyBjb25zdCB1
MzIgYjQzX250YWJfbm9pc2V2YXIxMFtdID0gewogCTB4MDIwQzAyMEMsIDB4MDAw
MDAxNEQsIDB4MDIwQzAyMEMsIDB4MDAwMDAxNEQsCiAJMHgwMjBDMDIwQywgMHgw
MDAwMDE0RCwgMHgwMjBDMDIwQywgMHgwMDAwMDE0RCwKIAkweDAyMEMwMjBDLCAw
eDAwMDAwMTRELCAweDAyMEMwMjBDLCAweDAwMDAwMTRELApAQCAtMTkyNiw3ICsx
OTI2LDcgQEAgY29uc3QgdTMyIGI0M19udGFiX25vaXNldmFyMTBbXSA9IHsKIAkw
eDAyMEMwMjBDLCAweDAwMDAwMTRELCAweDAyMEMwMjBDLCAweDAwMDAwMTRELAog
fTsKIAotY29uc3QgdTMyIGI0M19udGFiX25vaXNldmFyMTFbXSA9IHsKK3N0YXRp
YyBjb25zdCB1MzIgYjQzX250YWJfbm9pc2V2YXIxMVtdID0gewogCTB4MDIwQzAy
MEMsIDB4MDAwMDAxNEQsIDB4MDIwQzAyMEMsIDB4MDAwMDAxNEQsCiAJMHgwMjBD
MDIwQywgMHgwMDAwMDE0RCwgMHgwMjBDMDIwQywgMHgwMDAwMDE0RCwKIAkweDAy
MEMwMjBDLCAweDAwMDAwMTRELCAweDAyMEMwMjBDLCAweDAwMDAwMTRELApAQCAt
MTk5Myw3ICsxOTkzLDcgQEAgY29uc3QgdTMyIGI0M19udGFiX25vaXNldmFyMTFb
XSA9IHsKIAkweDAyMEMwMjBDLCAweDAwMDAwMTRELCAweDAyMEMwMjBDLCAweDAw
MDAwMTRELAogfTsKIAotY29uc3QgdTE2IGI0M19udGFiX3BpbG90W10gPSB7Citz
dGF0aWMgY29uc3QgdTE2IGI0M19udGFiX3BpbG90W10gPSB7CiAJMHhGRjA4LCAw
eEZGMDgsIDB4RkYwOCwgMHhGRjA4LCAweEZGMDgsIDB4RkYwOCwKIAkweEZGMDgs
IDB4RkYwOCwgMHg4MEQ1LCAweDgwRDUsIDB4ODBENSwgMHg4MEQ1LAogCTB4ODBE
NSwgMHg4MEQ1LCAweDgwRDUsIDB4ODBENSwgMHhGRjBBLCAweEZGODIsCkBAIC0y
MDExLDEyICsyMDExLDEyIEBAIGNvbnN0IHUxNiBiNDNfbnRhYl9waWxvdFtdID0g
ewogCTB4RjBBMCwgMHhGMDI4LCAweEZGRkYsIDB4RkZGRiwKIH07CiAKLWNvbnN0
IHUzMiBiNDNfbnRhYl9waWxvdGx0W10gPSB7CitzdGF0aWMgY29uc3QgdTMyIGI0
M19udGFiX3BpbG90bHRbXSA9IHsKIAkweDc2NTQwMTIzLCAweDYyNDA3MzUxLCAw
eDc2NTQzMjAxLCAweDc2NTQwMjEzLAogCTB4NzY1NDAxMjMsIDB4NzY0MzA1MjEs
CiB9OwogCi1jb25zdCB1MzIgYjQzX250YWJfdGRpMjBhMFtdID0geworc3RhdGlj
IGNvbnN0IHUzMiBiNDNfbnRhYl90ZGkyMGEwW10gPSB7CiAJMHgwMDA5MTIyNiwg
MHgwMDBBMTQyOSwgMHgwMDBCNTZBRCwgMHgwMDBDNThCMCwKIAkweDAwMEQ1QUIz
LCAweDAwMEU5Q0I2LCAweDAwMEY5RUJBLCAweDAwMDBDMTNELAogCTB4MDAwMjAz
MDEsIDB4MDAwMzA1MDQsIDB4MDAwNDA3MDgsIDB4MDAwNTA5MEIsCkBAIC0yMDMz
LDcgKzIwMzMsNyBAQCBjb25zdCB1MzIgYjQzX250YWJfdGRpMjBhMFtdID0gewog
CTB4MDAwMDAwMDAsIDB4MDAwMDAwMDAsIDB4MDAwMDAwMDAsCiB9OwogCi1jb25z
dCB1MzIgYjQzX250YWJfdGRpMjBhMVtdID0geworc3RhdGljIGNvbnN0IHUzMiBi
NDNfbnRhYl90ZGkyMGExW10gPSB7CiAJMHgwMDAxNEIyNiwgMHgwMDAyOEQyOSwg
MHgwMDAzOTNBRCwgMHgwMDA0OTYzMCwKIAkweDAwMDVEODMzLCAweDAwMDZEQTM2
LCAweDAwMDk5QzNBLCAweDAwMEE5RTNELAogCTB4MDAwQkMwODEsIDB4MDAwQ0My
ODQsIDB4MDAwREM0ODgsIDB4MDAwRjA2OEIsCkBAIC0yMDUwLDcgKzIwNTAsNyBA
QCBjb25zdCB1MzIgYjQzX250YWJfdGRpMjBhMVtdID0gewogCTB4MDAwMDAwMDAs
IDB4MDAwMDAwMDAsIDB4MDAwMDAwMDAsCiB9OwogCi1jb25zdCB1MzIgYjQzX250
YWJfdGRpNDBhMFtdID0geworc3RhdGljIGNvbnN0IHUzMiBiNDNfbnRhYl90ZGk0
MGEwW10gPSB7CiAJMHgwMDExQTM0NiwgMHgwMDEzNkNDRiwgMHgwMDE0RjVEOSwg
MHgwMDE2NDFFMiwKIAkweDAwMTdDQjZCLCAweDAwMTk1NDc1LCAweDAwMUIyMzgz
LCAweDAwMUNBRDBDLAogCTB4MDAxRTc2MTYsIDB4MDAwMDgyMUYsIDB4MDAwMjBC
QTgsIDB4MDAwM0Q0QjIsCkBAIC0yMDgxLDcgKzIwODEsNyBAQCBjb25zdCB1MzIg
YjQzX250YWJfdGRpNDBhMFtdID0gewogCTB4MDAwMDAwMDAsIDB4MDAwMDAwMDAs
CiB9OwogCi1jb25zdCB1MzIgYjQzX250YWJfdGRpNDBhMVtdID0geworc3RhdGlj
IGNvbnN0IHUzMiBiNDNfbnRhYl90ZGk0MGExW10gPSB7CiAJMHgwMDFFREIzNiwg
MHgwMDAxMjlDQSwgMHgwMDAyQjM1MywgMHgwMDA0N0NERCwKIAkweDAwMDVDOEU2
LCAweDAwMDc5MUVGLCAweDAwMDkxQkY5LCAweDAwMEFBQTA3LAogCTB4MDAwQzMz
OTEsIDB4MDAwREZEMUEsIDB4MDAxMjA5MjMsIDB4MDAxM0QyMkQsCkBAIC0yMTEy
LDcgKzIxMTIsNyBAQCBjb25zdCB1MzIgYjQzX250YWJfdGRpNDBhMVtdID0gewog
CTB4MDAwMDAwMDAsIDB4MDAwMDAwMDAsCiB9OwogCi1jb25zdCB1MzIgYjQzX250
YWJfdGR0cm5bXSA9IHsKK3N0YXRpYyBjb25zdCB1MzIgYjQzX250YWJfdGR0cm5b
XSA9IHsKIAkweDA2MUMwNjFDLCAweDAwNTBFRTY4LCAweEY1OTJGRTM2LCAweEZF
NTIxMkY2LAogCTB4MDAwMDBDMzgsIDB4RkU1MjEyRjYsIDB4RjU5MkZFMzYsIDB4
MDA1MEVFNjgsCiAJMHgwNjFDMDYxQywgMHhFRTY4MDA1MCwgMHhGRTM2RjU5Miwg
MHgxMkY2RkU1MiwKQEAgLTIyOTEsNyArMjI5MSw3IEBAIGNvbnN0IHUzMiBiNDNf
bnRhYl90ZHRybltdID0gewogCTB4RkE1OEZDMDAsIDB4MEI2NEZDN0UsIDB4MDgw
MEY3QjYsIDB4MDBGMDA2QkUsCiB9OwogCi1jb25zdCB1MzIgYjQzX250YWJfdG1h
cFtdID0geworc3RhdGljIGNvbnN0IHUzMiBiNDNfbnRhYl90bWFwW10gPSB7CiAJ
MHg4QTg4QUE4MCwgMHg4QUFBQUE4QSwgMHg4QThBOEFBOCwgMHgwMDAwMDg4OCwK
IAkweDg4MDAwMDAwLCAweDhBOEE4OEFBLCAweDhBQTg4ODg4LCAweDg4ODhBOEE4
LAogCTB4RjExMTExMTAsIDB4MTExMTExMTEsIDB4MTFGMTExMTEsIDB4MDAwMDAx
MTEsCkBAIC0yNDc0LDMgKzI0NzQsNTEgQEAgdm9pZCBiNDNfbnRhYl93cml0ZShz
dHJ1Y3QgYjQzX3dsZGV2ICpkZXYsIHUzMiBvZmZzZXQsIHUzMiB2YWx1ZSkKIAkv
KiBTb21lIGNvbXBpbGV0aW1lIGFzc2VydGlvbnMuLi4gKi8KIAlhc3NlcnRfbnRh
Yl9hcnJheV9zaXplcygpOwogfQorCisjZGVmaW5lIG50YWJfdXBsb2FkKGRldiwg
b2Zmc2V0LCBkYXRhKSBkbyB7IFwKKwkJdW5zaWduZWQgaW50IGk7CQkJCQkJXAor
CQlmb3IgKGkgPSAwOyBpIDwgKG9mZnNldCMjX1NJWkUpOyBpKyspCQkJXAorCQkJ
YjQzX250YWJfd3JpdGUoZGV2LCAob2Zmc2V0KSArIGksIChkYXRhKVtpXSk7CVwK
Kwl9IHdoaWxlICgwKQorCit2b2lkIGI0M19ucGh5X3JldjBfMV8yX3RhYmxlc19p
bml0KHN0cnVjdCBiNDNfd2xkZXYgKmRldikKK3sKKwkvKiBTdGF0aWMgdGFibGVz
ICovCisJbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9GUkFNRVNUUlVDVCwgYjQz
X250YWJfZnJhbWVzdHJ1Y3QpOworCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJf
RlJBTUVMVCwgYjQzX250YWJfZnJhbWVsb29rdXApOworCW50YWJfdXBsb2FkKGRl
diwgQjQzX05UQUJfVE1BUCwgYjQzX250YWJfdG1hcCk7CisJbnRhYl91cGxvYWQo
ZGV2LCBCNDNfTlRBQl9URFRSTiwgYjQzX250YWJfdGR0cm4pOworCW50YWJfdXBs
b2FkKGRldiwgQjQzX05UQUJfSU5UTEVWRUwsIGI0M19udGFiX2ludGxldmVsKTsK
KwludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX1BJTE9ULCBiNDNfbnRhYl9waWxv
dCk7CisJbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9QSUxPVExULCBiNDNfbnRh
Yl9waWxvdGx0KTsKKwludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX1RESTIwQTAs
IGI0M19udGFiX3RkaTIwYTApOworCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJf
VERJMjBBMSwgYjQzX250YWJfdGRpMjBhMSk7CisJbnRhYl91cGxvYWQoZGV2LCBC
NDNfTlRBQl9UREk0MEEwLCBiNDNfbnRhYl90ZGk0MGEwKTsKKwludGFiX3VwbG9h
ZChkZXYsIEI0M19OVEFCX1RESTQwQTEsIGI0M19udGFiX3RkaTQwYTEpOworCW50
YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfQkRJLCBiNDNfbnRhYl9iZGkpOworCW50
YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfQ0hBTkVTVCwgYjQzX250YWJfY2hhbm5l
bGVzdCk7CisJbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9NQ1MsIGI0M19udGFi
X21jcyk7CisKKwkvKiBWb2xhdGlsZSB0YWJsZXMgKi8KKwludGFiX3VwbG9hZChk
ZXYsIEI0M19OVEFCX05PSVNFVkFSMTAsIGI0M19udGFiX25vaXNldmFyMTApOwor
CW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfTk9JU0VWQVIxMSwgYjQzX250YWJf
bm9pc2V2YXIxMSk7CisJbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9DMF9FU1RQ
TFQsIGI0M19udGFiX2VzdGltYXRlcG93ZXJsdDApOworCW50YWJfdXBsb2FkKGRl
diwgQjQzX05UQUJfQzFfRVNUUExULCBiNDNfbnRhYl9lc3RpbWF0ZXBvd2VybHQx
KTsKKwludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0MwX0FESlBMVCwgYjQzX250
YWJfYWRqdXN0cG93ZXIwKTsKKwludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0Mx
X0FESlBMVCwgYjQzX250YWJfYWRqdXN0cG93ZXIxKTsKKwludGFiX3VwbG9hZChk
ZXYsIEI0M19OVEFCX0MwX0dBSU5DVEwsIGI0M19udGFiX2dhaW5jdGwwKTsKKwlu
dGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0MxX0dBSU5DVEwsIGI0M19udGFiX2dh
aW5jdGwxKTsKKwludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0MwX0lRTFQsIGI0
M19udGFiX2lxbHQwKTsKKwludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0MxX0lR
TFQsIGI0M19udGFiX2lxbHQxKTsKKwludGFiX3VwbG9hZChkZXYsIEI0M19OVEFC
X0MwX0xPRkVFRFRILCBiNDNfbnRhYl9sb2Z0bHQwKTsKKwludGFiX3VwbG9hZChk
ZXYsIEI0M19OVEFCX0MxX0xPRkVFRFRILCBiNDNfbnRhYl9sb2Z0bHQxKTsKK30K
Kwordm9pZCBiNDNfbnBoeV9yZXYzcGx1c190YWJsZXNfaW5pdChzdHJ1Y3QgYjQz
X3dsZGV2ICpkZXYpCit7CisJLyogU3RhdGljIHRhYmxlcyAqLworCS8qIFRPRE8g
Ki8KKworCS8qIFZvbGF0aWxlIHRhYmxlcyAqLworCS8qIFRPRE8gKi8KK30KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My90YWJsZXNfbnBoeS5o
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3RhYmxlc19ucGh5LmgKaW5kZXgg
NGQ0OThiMC4uMWYwYTYwMiAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYjQzL3RhYmxlc19ucGh5LmgKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YjQzL3RhYmxlc19ucGh5LmgKQEAgLTEyOCwzMiArMTI4LDcgQEAgYjQzX25waHlf
Z2V0X2NoYW50YWJlbnQoc3RydWN0IGI0M193bGRldiAqZGV2LCB1OCBjaGFubmVs
KTsKIAogdm9pZCBiNDNfbnRhYl93cml0ZShzdHJ1Y3QgYjQzX3dsZGV2ICpkZXYs
IHUzMiBvZmZzZXQsIHUzMiB2YWx1ZSk7CiAKLWV4dGVybiBjb25zdCB1OCBiNDNf
bnRhYl9hZGp1c3Rwb3dlcjBbXTsKLWV4dGVybiBjb25zdCB1OCBiNDNfbnRhYl9h
ZGp1c3Rwb3dlcjFbXTsKLWV4dGVybiBjb25zdCB1MTYgYjQzX250YWJfYmRpW107
Ci1leHRlcm4gY29uc3QgdTMyIGI0M19udGFiX2NoYW5uZWxlc3RbXTsKLWV4dGVy
biBjb25zdCB1OCBiNDNfbnRhYl9lc3RpbWF0ZXBvd2VybHQwW107Ci1leHRlcm4g
Y29uc3QgdTggYjQzX250YWJfZXN0aW1hdGVwb3dlcmx0MVtdOwotZXh0ZXJuIGNv
bnN0IHU4IGI0M19udGFiX2ZyYW1lbG9va3VwW107Ci1leHRlcm4gY29uc3QgdTMy
IGI0M19udGFiX2ZyYW1lc3RydWN0W107Ci1leHRlcm4gY29uc3QgdTMyIGI0M19u
dGFiX2dhaW5jdGwwW107Ci1leHRlcm4gY29uc3QgdTMyIGI0M19udGFiX2dhaW5j
dGwxW107Ci1leHRlcm4gY29uc3QgdTMyIGI0M19udGFiX2ludGxldmVsW107Ci1l
eHRlcm4gY29uc3QgdTMyIGI0M19udGFiX2lxbHQwW107Ci1leHRlcm4gY29uc3Qg
dTMyIGI0M19udGFiX2lxbHQxW107Ci1leHRlcm4gY29uc3QgdTE2IGI0M19udGFi
X2xvZnRsdDBbXTsKLWV4dGVybiBjb25zdCB1MTYgYjQzX250YWJfbG9mdGx0MVtd
OwotZXh0ZXJuIGNvbnN0IHU4IGI0M19udGFiX21jc1tdOwotZXh0ZXJuIGNvbnN0
IHUzMiBiNDNfbnRhYl9ub2lzZXZhcjEwW107Ci1leHRlcm4gY29uc3QgdTMyIGI0
M19udGFiX25vaXNldmFyMTFbXTsKLWV4dGVybiBjb25zdCB1MTYgYjQzX250YWJf
cGlsb3RbXTsKLWV4dGVybiBjb25zdCB1MzIgYjQzX250YWJfcGlsb3RsdFtdOwot
ZXh0ZXJuIGNvbnN0IHUzMiBiNDNfbnRhYl90ZGkyMGEwW107Ci1leHRlcm4gY29u
c3QgdTMyIGI0M19udGFiX3RkaTIwYTFbXTsKLWV4dGVybiBjb25zdCB1MzIgYjQz
X250YWJfdGRpNDBhMFtdOwotZXh0ZXJuIGNvbnN0IHUzMiBiNDNfbnRhYl90ZGk0
MGExW107Ci1leHRlcm4gY29uc3QgdTMyIGI0M19udGFiX3RkdHJuW107Ci1leHRl
cm4gY29uc3QgdTMyIGI0M19udGFiX3RtYXBbXTsKLQordm9pZCBiNDNfbnBoeV9y
ZXYwXzFfMl90YWJsZXNfaW5pdChzdHJ1Y3QgYjQzX3dsZGV2ICpkZXYpOwordm9p
ZCBiNDNfbnBoeV9yZXYzcGx1c190YWJsZXNfaW5pdChzdHJ1Y3QgYjQzX3dsZGV2
ICpkZXYpOwogCiAjZW5kaWYgLyogQjQzX1RBQkxFU19OUEhZX0hfICovCi0tIAox
LjYuNC4yCgo=

------------8iZTJx8JwXS8Edc3qjiQy1--

