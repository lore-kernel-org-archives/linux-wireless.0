Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:52449 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab0ABQcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 11:32:41 -0500
Received: by fg-out-1718.google.com with SMTP id 19so5889807fgg.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jan 2010 08:32:39 -0800 (PST)
Content-Type: multipart/mixed; boundary=----------0rjEM5Y4VVUEHCjNoz9mbP
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
To: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 02 Jan 2010 17:33:53 +0100
Subject: [PATCH] b43: N-PHY: clean table init, check PHY rev (V2)
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u5wyyryj9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------------0rjEM5Y4VVUEHCjNoz9mbP
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: Quoted-Printable

 From 2ba3a7f93ac358a49f36433f49b6d3cf2f930d5c Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Rafa=3DC5=3D82=3D20Mi=3DC5=3D82ecki?=3D <zajec5@gmail.=
com>
Date: Sat, 2 Jan 2010 17:06:12 +0100
Subject: [PATCH] b43: N-PHY: clean table init, check PHY rev (V2)
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Move table init to tables_nphy.c, detect newer PHY which use different i=
nit.
We don't init newer PHYs yet but this at least shows what more is needed=
.

V2: Make some functions and tables static

Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c       |   43 ++-----------
  drivers/net/wireless/b43/tables_nphy.c |  100 +++++++++++++++++++++++-=
-------
  drivers/net/wireless/b43/tables_nphy.h |   55 +++++++++--------
  3 files changed, 110 insertions(+), 88 deletions(-)

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
index 4d498b0..2240345 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -128,32 +128,35 @@ b43_nphy_get_chantabent(struct b43_wldev *dev, u8 =
channel);

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
+void b43_nphy_rev0_1_2_tables_init(struct b43_wldev *dev);
+void b43_nphy_rev3plus_tables_init(struct b43_wldev *dev);
+
+static const u8 b43_ntab_adjustpower0[];
+static const u8 b43_ntab_adjustpower1[];
+static const u16 b43_ntab_bdi[];
+static const u32 b43_ntab_channelest[];
+static const u8 b43_ntab_estimatepowerlt0[];
+static const u8 b43_ntab_estimatepowerlt1[];
+static const u8 b43_ntab_framelookup[];
+static const u32 b43_ntab_framestruct[];
+static const u32 b43_ntab_gainctl0[];
+static const u32 b43_ntab_gainctl1[];
+static const u32 b43_ntab_intlevel[];
+static const u32 b43_ntab_iqlt0[];
+static const u32 b43_ntab_iqlt1[];
+static const u16 b43_ntab_loftlt0[];
+static const u16 b43_ntab_loftlt1[];
+static const u8 b43_ntab_mcs[];
+static const u32 b43_ntab_noisevar10[];
+static const u32 b43_ntab_noisevar11[];
+static const u16 b43_ntab_pilot[];
+static const u32 b43_ntab_pilotlt[];
+static const u32 b43_ntab_tdi20a0[];
+static const u32 b43_ntab_tdi20a1[];
+static const u32 b43_ntab_tdi40a0[];
+static const u32 b43_ntab_tdi40a1[];
+static const u32 b43_ntab_tdtrn[];
+static const u32 b43_ntab_tmap[];


  #endif /* B43_TABLES_NPHY_H_ */
-- =

1.6.4.2

-- =

Rafa=C5=82
------------0rjEM5Y4VVUEHCjNoz9mbP
Content-Disposition: attachment; filename=0001-b43-N-PHY-clean-table-init-check-PHY-rev-V2.patch
Content-Type: application/octet-stream; name=0001-b43-N-PHY-clean-table-init-check-PHY-rev-V2.patch
Content-Transfer-Encoding: Base64

RnJvbSAyYmEzYTdmOTNhYzM1OGE0OWYzNjQzM2Y0OWI2ZDNjZjJmOTMwZDVjIE1v
biBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiA9P1VURi04P3E/UmFmYT1DNT04
Mj0yME1pPUM1PTgyZWNraT89IDx6YWplYzVAZ21haWwuY29tPgpEYXRlOiBTYXQs
IDIgSmFuIDIwMTAgMTc6MDY6MTIgKzAxMDAKU3ViamVjdDogW1BBVENIXSBiNDM6
IE4tUEhZOiBjbGVhbiB0YWJsZSBpbml0LCBjaGVjayBQSFkgcmV2IChWMikKTUlN
RS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0
PVVURi04CkNvbnRlbnQtVHJhbnNmZXItRW5jb2Rpbmc6IDhiaXQKCk1vdmUgdGFi
bGUgaW5pdCB0byB0YWJsZXNfbnBoeS5jLCBkZXRlY3QgbmV3ZXIgUEhZIHdoaWNo
IHVzZSBkaWZmZXJlbnQgaW5pdC4KV2UgZG9uJ3QgaW5pdCBuZXdlciBQSFlzIHll
dCBidXQgdGhpcyBhdCBsZWFzdCBzaG93cyB3aGF0IG1vcmUgaXMgbmVlZGVkLgoK
VjI6IE1ha2Ugc29tZSBmdW5jdGlvbnMgYW5kIHRhYmxlcyBzdGF0aWMKClNpZ25l
ZC1vZmYtYnk6IFJhZmHFgiBNacWCZWNraSA8emFqZWM1QGdtYWlsLmNvbT4KLS0t
CiBkcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvcGh5X24uYyAgICAgICB8ICAgNDMg
KystLS0tLS0tLS0tLQogZHJpdmVycy9uZXQvd2lyZWxlc3MvYjQzL3RhYmxlc19u
cGh5LmMgfCAgMTAwICsrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0KIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL2I0My90YWJsZXNfbnBoeS5oIHwgICA1NSArKysr
KysrKystLS0tLS0tLQogMyBmaWxlcyBjaGFuZ2VkLCAxMTAgaW5zZXJ0aW9ucygr
KSwgODggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYjQzL3BoeV9uLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvcGh5
X24uYwppbmRleCA5OTIzMThhLi5hNjYyY2VkIDEwMDY0NAotLS0gYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9iNDMvcGh5X24uYworKysgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9iNDMvcGh5X24uYwpAQCAtMTk3LDQ0ICsxOTcsMTUgQEAgdm9pZCBiNDNf
bnBoeV9yYWRpb190dXJuX29mZihzdHJ1Y3QgYjQzX3dsZGV2ICpkZXYpCiAJCSAg
ICAgfkI0M19OUEhZX1JGQ1RMX0NNRF9FTik7CiB9CiAKLSNkZWZpbmUgbnRhYl91
cGxvYWQoZGV2LCBvZmZzZXQsIGRhdGEpIGRvIHsgXAotCQl1bnNpZ25lZCBpbnQg
aTsJCQkJCQlcCi0JCWZvciAoaSA9IDA7IGkgPCAob2Zmc2V0IyNfU0laRSk7IGkr
KykJCQlcCi0JCQliNDNfbnRhYl93cml0ZShkZXYsIChvZmZzZXQpICsgaSwgKGRh
dGEpW2ldKTsJXAotCX0gd2hpbGUgKDApCi0KLS8qIFVwbG9hZCB0aGUgTi1QSFkg
dGFibGVzLiAqLworLyogVXBsb2FkIHRoZSBOLVBIWSB0YWJsZXMuCisgKiBodHRw
Oi8vYmNtLXY0LnNpcHNvbHV0aW9ucy5uZXQvODAyLjExL1BIWS9OL0luaXRUYWJs
ZXMKKyAqLyAgCiBzdGF0aWMgdm9pZCBiNDNfbnBoeV90YWJsZXNfaW5pdChzdHJ1
Y3QgYjQzX3dsZGV2ICpkZXYpCiB7Ci0JLyogU3RhdGljIHRhYmxlcyAqLwotCW50
YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfRlJBTUVTVFJVQ1QsIGI0M19udGFiX2Zy
YW1lc3RydWN0KTsKLQludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0ZSQU1FTFQs
IGI0M19udGFiX2ZyYW1lbG9va3VwKTsKLQludGFiX3VwbG9hZChkZXYsIEI0M19O
VEFCX1RNQVAsIGI0M19udGFiX3RtYXApOwotCW50YWJfdXBsb2FkKGRldiwgQjQz
X05UQUJfVERUUk4sIGI0M19udGFiX3RkdHJuKTsKLQludGFiX3VwbG9hZChkZXYs
IEI0M19OVEFCX0lOVExFVkVMLCBiNDNfbnRhYl9pbnRsZXZlbCk7Ci0JbnRhYl91
cGxvYWQoZGV2LCBCNDNfTlRBQl9QSUxPVCwgYjQzX250YWJfcGlsb3QpOwotCW50
YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfUElMT1RMVCwgYjQzX250YWJfcGlsb3Rs
dCk7Ci0JbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9UREkyMEEwLCBiNDNfbnRh
Yl90ZGkyMGEwKTsKLQludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX1RESTIwQTEs
IGI0M19udGFiX3RkaTIwYTEpOwotCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJf
VERJNDBBMCwgYjQzX250YWJfdGRpNDBhMCk7Ci0JbnRhYl91cGxvYWQoZGV2LCBC
NDNfTlRBQl9UREk0MEExLCBiNDNfbnRhYl90ZGk0MGExKTsKLQludGFiX3VwbG9h
ZChkZXYsIEI0M19OVEFCX0JESSwgYjQzX250YWJfYmRpKTsKLQludGFiX3VwbG9h
ZChkZXYsIEI0M19OVEFCX0NIQU5FU1QsIGI0M19udGFiX2NoYW5uZWxlc3QpOwot
CW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfTUNTLCBiNDNfbnRhYl9tY3MpOwot
Ci0JLyogVm9sYXRpbGUgdGFibGVzICovCi0JbnRhYl91cGxvYWQoZGV2LCBCNDNf
TlRBQl9OT0lTRVZBUjEwLCBiNDNfbnRhYl9ub2lzZXZhcjEwKTsKLQludGFiX3Vw
bG9hZChkZXYsIEI0M19OVEFCX05PSVNFVkFSMTEsIGI0M19udGFiX25vaXNldmFy
MTEpOwotCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfQzBfRVNUUExULCBiNDNf
bnRhYl9lc3RpbWF0ZXBvd2VybHQwKTsKLQludGFiX3VwbG9hZChkZXYsIEI0M19O
VEFCX0MxX0VTVFBMVCwgYjQzX250YWJfZXN0aW1hdGVwb3dlcmx0MSk7Ci0JbnRh
Yl91cGxvYWQoZGV2LCBCNDNfTlRBQl9DMF9BREpQTFQsIGI0M19udGFiX2FkanVz
dHBvd2VyMCk7Ci0JbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9DMV9BREpQTFQs
IGI0M19udGFiX2FkanVzdHBvd2VyMSk7Ci0JbnRhYl91cGxvYWQoZGV2LCBCNDNf
TlRBQl9DMF9HQUlOQ1RMLCBiNDNfbnRhYl9nYWluY3RsMCk7Ci0JbnRhYl91cGxv
YWQoZGV2LCBCNDNfTlRBQl9DMV9HQUlOQ1RMLCBiNDNfbnRhYl9nYWluY3RsMSk7
Ci0JbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9DMF9JUUxULCBiNDNfbnRhYl9p
cWx0MCk7Ci0JbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9DMV9JUUxULCBiNDNf
bnRhYl9pcWx0MSk7Ci0JbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9DMF9MT0ZF
RURUSCwgYjQzX250YWJfbG9mdGx0MCk7Ci0JbnRhYl91cGxvYWQoZGV2LCBCNDNf
TlRBQl9DMV9MT0ZFRURUSCwgYjQzX250YWJfbG9mdGx0MSk7CisJaWYgKGRldi0+
cGh5LnJldiA8IDMpCisJCWI0M19ucGh5X3JldjBfMV8yX3RhYmxlc19pbml0KGRl
dik7CisJZWxzZQorCQliNDNfbnBoeV9yZXYzcGx1c190YWJsZXNfaW5pdChkZXYp
OwogfQogCiBzdGF0aWMgdm9pZCBiNDNfbnBoeV93b3JrYXJvdW5kcyhzdHJ1Y3Qg
YjQzX3dsZGV2ICpkZXYpCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9iNDMvdGFibGVzX25waHkuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My90
YWJsZXNfbnBoeS5jCmluZGV4IDRlMjMzNjMuLmQwYjkxYjUgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My90YWJsZXNfbnBoeS5jCisrKyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL2I0My90YWJsZXNfbnBoeS5jCkBAIC0xMzM2LDcg
KzEzMzYsNyBAQCBiNDNfbnBoeV9nZXRfY2hhbnRhYmVudChzdHJ1Y3QgYjQzX3ds
ZGV2ICpkZXYsIHU4IGNoYW5uZWwpCiB9CiAKIAotY29uc3QgdTggYjQzX250YWJf
YWRqdXN0cG93ZXIwW10gPSB7CitzdGF0aWMgY29uc3QgdTggYjQzX250YWJfYWRq
dXN0cG93ZXIwW10gPSB7CiAJMHgwMCwgMHgwMCwgMHgwMCwgMHgwMCwgMHgwMSwg
MHgwMSwgMHgwMSwgMHgwMSwKIAkweDAyLCAweDAyLCAweDAyLCAweDAyLCAweDAz
LCAweDAzLCAweDAzLCAweDAzLAogCTB4MDQsIDB4MDQsIDB4MDQsIDB4MDQsIDB4
MDUsIDB4MDUsIDB4MDUsIDB4MDUsCkBAIC0xMzU1LDcgKzEzNTUsNyBAQCBjb25z
dCB1OCBiNDNfbnRhYl9hZGp1c3Rwb3dlcjBbXSA9IHsKIAkweDFFLCAweDFFLCAw
eDFFLCAweDFFLCAweDFGLCAweDFGLCAweDFGLCAweDFGLAogfTsKIAotY29uc3Qg
dTggYjQzX250YWJfYWRqdXN0cG93ZXIxW10gPSB7CitzdGF0aWMgY29uc3QgdTgg
YjQzX250YWJfYWRqdXN0cG93ZXIxW10gPSB7CiAJMHgwMCwgMHgwMCwgMHgwMCwg
MHgwMCwgMHgwMSwgMHgwMSwgMHgwMSwgMHgwMSwKIAkweDAyLCAweDAyLCAweDAy
LCAweDAyLCAweDAzLCAweDAzLCAweDAzLCAweDAzLAogCTB4MDQsIDB4MDQsIDB4
MDQsIDB4MDQsIDB4MDUsIDB4MDUsIDB4MDUsIDB4MDUsCkBAIC0xMzc0LDExICsx
Mzc0LDExIEBAIGNvbnN0IHU4IGI0M19udGFiX2FkanVzdHBvd2VyMVtdID0gewog
CTB4MUUsIDB4MUUsIDB4MUUsIDB4MUUsIDB4MUYsIDB4MUYsIDB4MUYsIDB4MUYs
CiB9OwogCi1jb25zdCB1MTYgYjQzX250YWJfYmRpW10gPSB7CitzdGF0aWMgY29u
c3QgdTE2IGI0M19udGFiX2JkaVtdID0gewogCTB4MDA3MCwgMHgwMTI2LCAweDAx
MkMsIDB4MDI0NiwgMHgwNDhELCAweDA0RDIsCiB9OwogCi1jb25zdCB1MzIgYjQz
X250YWJfY2hhbm5lbGVzdFtdID0geworc3RhdGljIGNvbnN0IHUzMiBiNDNfbnRh
Yl9jaGFubmVsZXN0W10gPSB7CiAJMHg0NDQ0NDQ0NCwgMHg0NDQ0NDQ0NCwgMHg0
NDQ0NDQ0NCwgMHg0NDQ0NDQ0NCwKIAkweDQ0NDQ0NDQ0LCAweDQ0NDQ0NDQ0LCAw
eDQ0NDQ0NDQ0LCAweDQ0NDQ0NDQ0LAogCTB4MTAxMDEwMTAsIDB4MTAxMDEwMTAs
IDB4MTAxMDEwMTAsIDB4MTAxMDEwMTAsCkBAIC0xNDA1LDcgKzE0MDUsNyBAQCBj
b25zdCB1MzIgYjQzX250YWJfY2hhbm5lbGVzdFtdID0gewogCTB4MTAxMDEwMTAs
IDB4MTAxMDEwMTAsIDB4MTAxMDEwMTAsIDB4MTAxMDEwMTAsCiB9OwogCi1jb25z
dCB1OCBiNDNfbnRhYl9lc3RpbWF0ZXBvd2VybHQwW10gPSB7CitzdGF0aWMgY29u
c3QgdTggYjQzX250YWJfZXN0aW1hdGVwb3dlcmx0MFtdID0gewogCTB4NTAsIDB4
NEYsIDB4NEUsIDB4NEQsIDB4NEMsIDB4NEIsIDB4NEEsIDB4NDksCiAJMHg0OCwg
MHg0NywgMHg0NiwgMHg0NSwgMHg0NCwgMHg0MywgMHg0MiwgMHg0MSwKIAkweDQw
LCAweDNGLCAweDNFLCAweDNELCAweDNDLCAweDNCLCAweDNBLCAweDM5LApAQCAt
MTQxNiw3ICsxNDE2LDcgQEAgY29uc3QgdTggYjQzX250YWJfZXN0aW1hdGVwb3dl
cmx0MFtdID0gewogCTB4MTgsIDB4MTcsIDB4MTYsIDB4MTUsIDB4MTQsIDB4MTMs
IDB4MTIsIDB4MTEsCiB9OwogCi1jb25zdCB1OCBiNDNfbnRhYl9lc3RpbWF0ZXBv
d2VybHQxW10gPSB7CitzdGF0aWMgY29uc3QgdTggYjQzX250YWJfZXN0aW1hdGVw
b3dlcmx0MVtdID0gewogCTB4NTAsIDB4NEYsIDB4NEUsIDB4NEQsIDB4NEMsIDB4
NEIsIDB4NEEsIDB4NDksCiAJMHg0OCwgMHg0NywgMHg0NiwgMHg0NSwgMHg0NCwg
MHg0MywgMHg0MiwgMHg0MSwKIAkweDQwLCAweDNGLCAweDNFLCAweDNELCAweDND
LCAweDNCLCAweDNBLCAweDM5LApAQCAtMTQyNywxNCArMTQyNywxNCBAQCBjb25z
dCB1OCBiNDNfbnRhYl9lc3RpbWF0ZXBvd2VybHQxW10gPSB7CiAJMHgxOCwgMHgx
NywgMHgxNiwgMHgxNSwgMHgxNCwgMHgxMywgMHgxMiwgMHgxMSwKIH07CiAKLWNv
bnN0IHU4IGI0M19udGFiX2ZyYW1lbG9va3VwW10gPSB7CitzdGF0aWMgY29uc3Qg
dTggYjQzX250YWJfZnJhbWVsb29rdXBbXSA9IHsKIAkweDAyLCAweDA0LCAweDE0
LCAweDE0LCAweDAzLCAweDA1LCAweDE2LCAweDE2LAogCTB4MEEsIDB4MEMsIDB4
MUMsIDB4MUMsIDB4MEIsIDB4MEQsIDB4MUUsIDB4MUUsCiAJMHgwNiwgMHgwOCwg
MHgxOCwgMHgxOCwgMHgwNywgMHgwOSwgMHgxQSwgMHgxQSwKIAkweDBFLCAweDEw
LCAweDIwLCAweDI4LCAweDBGLCAweDExLCAweDIyLCAweDJBLAogfTsKIAotY29u
c3QgdTMyIGI0M19udGFiX2ZyYW1lc3RydWN0W10gPSB7CitzdGF0aWMgY29uc3Qg
dTMyIGI0M19udGFiX2ZyYW1lc3RydWN0W10gPSB7CiAJMHgwODAwNEEwNCwgMHgw
MDEwMDAwMCwgMHgwMTAwMEEwNSwgMHgwMDEwMDAyMCwKIAkweDA5ODA0NTA2LCAw
eDAwMTAwMDMwLCAweDA5ODA0NTA3LCAweDAwMTAwMDMwLAogCTB4MDAwMDAwMDAs
IDB4MDAwMDAwMDAsIDB4MDAwMDAwMDAsIDB4MDAwMDAwMDAsCkBAIC0xNjQ1LDcg
KzE2NDUsNyBAQCBjb25zdCB1MzIgYjQzX250YWJfZnJhbWVzdHJ1Y3RbXSA9IHsK
IAkweDAwMDAwMDAwLCAweDAwMDAwMDAwLCAweDAwMDAwMDAwLCAweDAwMDAwMDAw
LAogfTsKIAotY29uc3QgdTMyIGI0M19udGFiX2dhaW5jdGwwW10gPSB7CitzdGF0
aWMgY29uc3QgdTMyIGI0M19udGFiX2dhaW5jdGwwW10gPSB7CiAJMHgwMDdGMDAz
RiwgMHgwMDdFMDEzRiwgMHgwMDdEMDIzRSwgMHgwMDdDMDMzRSwKIAkweDAwN0Iw
NDNELCAweDAwN0EwNTNELCAweDAwNzkwNjNDLCAweDAwNzgwNzNDLAogCTB4MDA3
NzA4M0IsIDB4MDA3NjA5M0IsIDB4MDA3NTBBM0EsIDB4MDA3NDBCM0EsCkBAIC0x
NjgwLDcgKzE2ODAsNyBAQCBjb25zdCB1MzIgYjQzX250YWJfZ2FpbmN0bDBbXSA9
IHsKIAkweDAwMDMwQzAxLCAweDAwMDIwRDAxLCAweDAwMDEwRTAwLCAweDAwMDAw
RjAwLAogfTsKIAotY29uc3QgdTMyIGI0M19udGFiX2dhaW5jdGwxW10gPSB7Citz
dGF0aWMgY29uc3QgdTMyIGI0M19udGFiX2dhaW5jdGwxW10gPSB7CiAJMHgwMDdG
MDAzRiwgMHgwMDdFMDEzRiwgMHgwMDdEMDIzRSwgMHgwMDdDMDMzRSwKIAkweDAw
N0IwNDNELCAweDAwN0EwNTNELCAweDAwNzkwNjNDLCAweDAwNzgwNzNDLAogCTB4
MDA3NzA4M0IsIDB4MDA3NjA5M0IsIDB4MDA3NTBBM0EsIDB4MDA3NDBCM0EsCkBA
IC0xNzE1LDEyICsxNzE1LDEyIEBAIGNvbnN0IHUzMiBiNDNfbnRhYl9nYWluY3Rs
MVtdID0gewogCTB4MDAwMzBDMDEsIDB4MDAwMjBEMDEsIDB4MDAwMTBFMDAsIDB4
MDAwMDBGMDAsCiB9OwogCi1jb25zdCB1MzIgYjQzX250YWJfaW50bGV2ZWxbXSA9
IHsKK3N0YXRpYyBjb25zdCB1MzIgYjQzX250YWJfaW50bGV2ZWxbXSA9IHsKIAkw
eDAwODAyMDcwLCAweDA2NzExODhELCAweDBBNjAxOTJDLCAweDBBMzAwRTQ2LAog
CTB4MDBDMTE4OEQsIDB4MDgwMDI0RDIsIDB4MDAwMDAwNzAsCiB9OwogCi1jb25z
dCB1MzIgYjQzX250YWJfaXFsdDBbXSA9IHsKK3N0YXRpYyBjb25zdCB1MzIgYjQz
X250YWJfaXFsdDBbXSA9IHsKIAkweDAwMDAwMDdGLCAweDAwMDAwMDdGLCAweDAw
MDAwMDdGLCAweDAwMDAwMDdGLAogCTB4MDAwMDAwN0YsIDB4MDAwMDAwN0YsIDB4
MDAwMDAwN0YsIDB4MDAwMDAwN0YsCiAJMHgwMDAwMDA3RiwgMHgwMDAwMDA3Riwg
MHgwMDAwMDA3RiwgMHgwMDAwMDA3RiwKQEAgLTE3NTUsNyArMTc1NSw3IEBAIGNv
bnN0IHUzMiBiNDNfbnRhYl9pcWx0MFtdID0gewogCTB4MDAwMDAwN0YsIDB4MDAw
MDAwN0YsIDB4MDAwMDAwN0YsIDB4MDAwMDAwN0YsCiB9OwogCi1jb25zdCB1MzIg
YjQzX250YWJfaXFsdDFbXSA9IHsKK3N0YXRpYyBjb25zdCB1MzIgYjQzX250YWJf
aXFsdDFbXSA9IHsKIAkweDAwMDAwMDdGLCAweDAwMDAwMDdGLCAweDAwMDAwMDdG
LCAweDAwMDAwMDdGLAogCTB4MDAwMDAwN0YsIDB4MDAwMDAwN0YsIDB4MDAwMDAw
N0YsIDB4MDAwMDAwN0YsCiAJMHgwMDAwMDA3RiwgMHgwMDAwMDA3RiwgMHgwMDAw
MDA3RiwgMHgwMDAwMDA3RiwKQEAgLTE3OTAsNyArMTc5MCw3IEBAIGNvbnN0IHUz
MiBiNDNfbnRhYl9pcWx0MVtdID0gewogCTB4MDAwMDAwN0YsIDB4MDAwMDAwN0Ys
IDB4MDAwMDAwN0YsIDB4MDAwMDAwN0YsCiB9OwogCi1jb25zdCB1MTYgYjQzX250
YWJfbG9mdGx0MFtdID0geworc3RhdGljIGNvbnN0IHUxNiBiNDNfbnRhYl9sb2Z0
bHQwW10gPSB7CiAJMHgwMDAwLCAweDAxMDEsIDB4MDAwMiwgMHgwMTAzLCAweDAw
MDAsIDB4MDEwMSwKIAkweDAwMDIsIDB4MDEwMywgMHgwMDAwLCAweDAxMDEsIDB4
MDAwMiwgMHgwMTAzLAogCTB4MDAwMCwgMHgwMTAxLCAweDAwMDIsIDB4MDEwMywg
MHgwMDAwLCAweDAxMDEsCkBAIC0xODE1LDcgKzE4MTUsNyBAQCBjb25zdCB1MTYg
YjQzX250YWJfbG9mdGx0MFtdID0gewogCTB4MDAwMiwgMHgwMTAzLAogfTsKIAot
Y29uc3QgdTE2IGI0M19udGFiX2xvZnRsdDFbXSA9IHsKK3N0YXRpYyBjb25zdCB1
MTYgYjQzX250YWJfbG9mdGx0MVtdID0gewogCTB4MDAwMCwgMHgwMTAxLCAweDAw
MDIsIDB4MDEwMywgMHgwMDAwLCAweDAxMDEsCiAJMHgwMDAyLCAweDAxMDMsIDB4
MDAwMCwgMHgwMTAxLCAweDAwMDIsIDB4MDEwMywKIAkweDAwMDAsIDB4MDEwMSwg
MHgwMDAyLCAweDAxMDMsIDB4MDAwMCwgMHgwMTAxLApAQCAtMTg0MCw3ICsxODQw
LDcgQEAgY29uc3QgdTE2IGI0M19udGFiX2xvZnRsdDFbXSA9IHsKIAkweDAwMDIs
IDB4MDEwMywKIH07CiAKLWNvbnN0IHU4IGI0M19udGFiX21jc1tdID0geworc3Rh
dGljIGNvbnN0IHU4IGI0M19udGFiX21jc1tdID0gewogCTB4MDAsIDB4MDgsIDB4
MEEsIDB4MTAsIDB4MTIsIDB4MTksIDB4MUEsIDB4MUMsCiAJMHg0MCwgMHg0OCwg
MHg0QSwgMHg1MCwgMHg1MiwgMHg1OSwgMHg1QSwgMHg1QywKIAkweDgwLCAweDg4
LCAweDhBLCAweDkwLCAweDkyLCAweDk5LCAweDlBLCAweDlDLApAQCAtMTg1OSw3
ICsxODU5LDcgQEAgY29uc3QgdTggYjQzX250YWJfbWNzW10gPSB7CiAJMHgwMCwg
MHgwMCwgMHgwMCwgMHgwMCwgMHgwMCwgMHgwMCwgMHgwMCwgMHgwMCwKIH07CiAK
LWNvbnN0IHUzMiBiNDNfbnRhYl9ub2lzZXZhcjEwW10gPSB7CitzdGF0aWMgY29u
c3QgdTMyIGI0M19udGFiX25vaXNldmFyMTBbXSA9IHsKIAkweDAyMEMwMjBDLCAw
eDAwMDAwMTRELCAweDAyMEMwMjBDLCAweDAwMDAwMTRELAogCTB4MDIwQzAyMEMs
IDB4MDAwMDAxNEQsIDB4MDIwQzAyMEMsIDB4MDAwMDAxNEQsCiAJMHgwMjBDMDIw
QywgMHgwMDAwMDE0RCwgMHgwMjBDMDIwQywgMHgwMDAwMDE0RCwKQEAgLTE5MjYs
NyArMTkyNiw3IEBAIGNvbnN0IHUzMiBiNDNfbnRhYl9ub2lzZXZhcjEwW10gPSB7
CiAJMHgwMjBDMDIwQywgMHgwMDAwMDE0RCwgMHgwMjBDMDIwQywgMHgwMDAwMDE0
RCwKIH07CiAKLWNvbnN0IHUzMiBiNDNfbnRhYl9ub2lzZXZhcjExW10gPSB7Citz
dGF0aWMgY29uc3QgdTMyIGI0M19udGFiX25vaXNldmFyMTFbXSA9IHsKIAkweDAy
MEMwMjBDLCAweDAwMDAwMTRELCAweDAyMEMwMjBDLCAweDAwMDAwMTRELAogCTB4
MDIwQzAyMEMsIDB4MDAwMDAxNEQsIDB4MDIwQzAyMEMsIDB4MDAwMDAxNEQsCiAJ
MHgwMjBDMDIwQywgMHgwMDAwMDE0RCwgMHgwMjBDMDIwQywgMHgwMDAwMDE0RCwK
QEAgLTE5OTMsNyArMTk5Myw3IEBAIGNvbnN0IHUzMiBiNDNfbnRhYl9ub2lzZXZh
cjExW10gPSB7CiAJMHgwMjBDMDIwQywgMHgwMDAwMDE0RCwgMHgwMjBDMDIwQywg
MHgwMDAwMDE0RCwKIH07CiAKLWNvbnN0IHUxNiBiNDNfbnRhYl9waWxvdFtdID0g
eworc3RhdGljIGNvbnN0IHUxNiBiNDNfbnRhYl9waWxvdFtdID0gewogCTB4RkYw
OCwgMHhGRjA4LCAweEZGMDgsIDB4RkYwOCwgMHhGRjA4LCAweEZGMDgsCiAJMHhG
RjA4LCAweEZGMDgsIDB4ODBENSwgMHg4MEQ1LCAweDgwRDUsIDB4ODBENSwKIAkw
eDgwRDUsIDB4ODBENSwgMHg4MEQ1LCAweDgwRDUsIDB4RkYwQSwgMHhGRjgyLApA
QCAtMjAxMSwxMiArMjAxMSwxMiBAQCBjb25zdCB1MTYgYjQzX250YWJfcGlsb3Rb
XSA9IHsKIAkweEYwQTAsIDB4RjAyOCwgMHhGRkZGLCAweEZGRkYsCiB9OwogCi1j
b25zdCB1MzIgYjQzX250YWJfcGlsb3RsdFtdID0geworc3RhdGljIGNvbnN0IHUz
MiBiNDNfbnRhYl9waWxvdGx0W10gPSB7CiAJMHg3NjU0MDEyMywgMHg2MjQwNzM1
MSwgMHg3NjU0MzIwMSwgMHg3NjU0MDIxMywKIAkweDc2NTQwMTIzLCAweDc2NDMw
NTIxLAogfTsKIAotY29uc3QgdTMyIGI0M19udGFiX3RkaTIwYTBbXSA9IHsKK3N0
YXRpYyBjb25zdCB1MzIgYjQzX250YWJfdGRpMjBhMFtdID0gewogCTB4MDAwOTEy
MjYsIDB4MDAwQTE0MjksIDB4MDAwQjU2QUQsIDB4MDAwQzU4QjAsCiAJMHgwMDBE
NUFCMywgMHgwMDBFOUNCNiwgMHgwMDBGOUVCQSwgMHgwMDAwQzEzRCwKIAkweDAw
MDIwMzAxLCAweDAwMDMwNTA0LCAweDAwMDQwNzA4LCAweDAwMDUwOTBCLApAQCAt
MjAzMyw3ICsyMDMzLDcgQEAgY29uc3QgdTMyIGI0M19udGFiX3RkaTIwYTBbXSA9
IHsKIAkweDAwMDAwMDAwLCAweDAwMDAwMDAwLCAweDAwMDAwMDAwLAogfTsKIAot
Y29uc3QgdTMyIGI0M19udGFiX3RkaTIwYTFbXSA9IHsKK3N0YXRpYyBjb25zdCB1
MzIgYjQzX250YWJfdGRpMjBhMVtdID0gewogCTB4MDAwMTRCMjYsIDB4MDAwMjhE
MjksIDB4MDAwMzkzQUQsIDB4MDAwNDk2MzAsCiAJMHgwMDA1RDgzMywgMHgwMDA2
REEzNiwgMHgwMDA5OUMzQSwgMHgwMDBBOUUzRCwKIAkweDAwMEJDMDgxLCAweDAw
MENDMjg0LCAweDAwMERDNDg4LCAweDAwMEYwNjhCLApAQCAtMjA1MCw3ICsyMDUw
LDcgQEAgY29uc3QgdTMyIGI0M19udGFiX3RkaTIwYTFbXSA9IHsKIAkweDAwMDAw
MDAwLCAweDAwMDAwMDAwLCAweDAwMDAwMDAwLAogfTsKIAotY29uc3QgdTMyIGI0
M19udGFiX3RkaTQwYTBbXSA9IHsKK3N0YXRpYyBjb25zdCB1MzIgYjQzX250YWJf
dGRpNDBhMFtdID0gewogCTB4MDAxMUEzNDYsIDB4MDAxMzZDQ0YsIDB4MDAxNEY1
RDksIDB4MDAxNjQxRTIsCiAJMHgwMDE3Q0I2QiwgMHgwMDE5NTQ3NSwgMHgwMDFC
MjM4MywgMHgwMDFDQUQwQywKIAkweDAwMUU3NjE2LCAweDAwMDA4MjFGLCAweDAw
MDIwQkE4LCAweDAwMDNENEIyLApAQCAtMjA4MSw3ICsyMDgxLDcgQEAgY29uc3Qg
dTMyIGI0M19udGFiX3RkaTQwYTBbXSA9IHsKIAkweDAwMDAwMDAwLCAweDAwMDAw
MDAwLAogfTsKIAotY29uc3QgdTMyIGI0M19udGFiX3RkaTQwYTFbXSA9IHsKK3N0
YXRpYyBjb25zdCB1MzIgYjQzX250YWJfdGRpNDBhMVtdID0gewogCTB4MDAxRURC
MzYsIDB4MDAwMTI5Q0EsIDB4MDAwMkIzNTMsIDB4MDAwNDdDREQsCiAJMHgwMDA1
QzhFNiwgMHgwMDA3OTFFRiwgMHgwMDA5MUJGOSwgMHgwMDBBQUEwNywKIAkweDAw
MEMzMzkxLCAweDAwMERGRDFBLCAweDAwMTIwOTIzLCAweDAwMTNEMjJELApAQCAt
MjExMiw3ICsyMTEyLDcgQEAgY29uc3QgdTMyIGI0M19udGFiX3RkaTQwYTFbXSA9
IHsKIAkweDAwMDAwMDAwLCAweDAwMDAwMDAwLAogfTsKIAotY29uc3QgdTMyIGI0
M19udGFiX3RkdHJuW10gPSB7CitzdGF0aWMgY29uc3QgdTMyIGI0M19udGFiX3Rk
dHJuW10gPSB7CiAJMHgwNjFDMDYxQywgMHgwMDUwRUU2OCwgMHhGNTkyRkUzNiwg
MHhGRTUyMTJGNiwKIAkweDAwMDAwQzM4LCAweEZFNTIxMkY2LCAweEY1OTJGRTM2
LCAweDAwNTBFRTY4LAogCTB4MDYxQzA2MUMsIDB4RUU2ODAwNTAsIDB4RkUzNkY1
OTIsIDB4MTJGNkZFNTIsCkBAIC0yMjkxLDcgKzIyOTEsNyBAQCBjb25zdCB1MzIg
YjQzX250YWJfdGR0cm5bXSA9IHsKIAkweEZBNThGQzAwLCAweDBCNjRGQzdFLCAw
eDA4MDBGN0I2LCAweDAwRjAwNkJFLAogfTsKIAotY29uc3QgdTMyIGI0M19udGFi
X3RtYXBbXSA9IHsKK3N0YXRpYyBjb25zdCB1MzIgYjQzX250YWJfdG1hcFtdID0g
ewogCTB4OEE4OEFBODAsIDB4OEFBQUFBOEEsIDB4OEE4QThBQTgsIDB4MDAwMDA4
ODgsCiAJMHg4ODAwMDAwMCwgMHg4QThBODhBQSwgMHg4QUE4ODg4OCwgMHg4ODg4
QThBOCwKIAkweEYxMTExMTEwLCAweDExMTExMTExLCAweDExRjExMTExLCAweDAw
MDAwMTExLApAQCAtMjQ3NCwzICsyNDc0LDUxIEBAIHZvaWQgYjQzX250YWJfd3Jp
dGUoc3RydWN0IGI0M193bGRldiAqZGV2LCB1MzIgb2Zmc2V0LCB1MzIgdmFsdWUp
CiAJLyogU29tZSBjb21waWxldGltZSBhc3NlcnRpb25zLi4uICovCiAJYXNzZXJ0
X250YWJfYXJyYXlfc2l6ZXMoKTsKIH0KKworI2RlZmluZSBudGFiX3VwbG9hZChk
ZXYsIG9mZnNldCwgZGF0YSkgZG8geyBcCisJCXVuc2lnbmVkIGludCBpOwkJCQkJ
CVwKKwkJZm9yIChpID0gMDsgaSA8IChvZmZzZXQjI19TSVpFKTsgaSsrKQkJCVwK
KwkJCWI0M19udGFiX3dyaXRlKGRldiwgKG9mZnNldCkgKyBpLCAoZGF0YSlbaV0p
OwlcCisJfSB3aGlsZSAoMCkKKwordm9pZCBiNDNfbnBoeV9yZXYwXzFfMl90YWJs
ZXNfaW5pdChzdHJ1Y3QgYjQzX3dsZGV2ICpkZXYpCit7CisJLyogU3RhdGljIHRh
YmxlcyAqLworCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfRlJBTUVTVFJVQ1Qs
IGI0M19udGFiX2ZyYW1lc3RydWN0KTsKKwludGFiX3VwbG9hZChkZXYsIEI0M19O
VEFCX0ZSQU1FTFQsIGI0M19udGFiX2ZyYW1lbG9va3VwKTsKKwludGFiX3VwbG9h
ZChkZXYsIEI0M19OVEFCX1RNQVAsIGI0M19udGFiX3RtYXApOworCW50YWJfdXBs
b2FkKGRldiwgQjQzX05UQUJfVERUUk4sIGI0M19udGFiX3RkdHJuKTsKKwludGFi
X3VwbG9hZChkZXYsIEI0M19OVEFCX0lOVExFVkVMLCBiNDNfbnRhYl9pbnRsZXZl
bCk7CisJbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9QSUxPVCwgYjQzX250YWJf
cGlsb3QpOworCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfUElMT1RMVCwgYjQz
X250YWJfcGlsb3RsdCk7CisJbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9UREky
MEEwLCBiNDNfbnRhYl90ZGkyMGEwKTsKKwludGFiX3VwbG9hZChkZXYsIEI0M19O
VEFCX1RESTIwQTEsIGI0M19udGFiX3RkaTIwYTEpOworCW50YWJfdXBsb2FkKGRl
diwgQjQzX05UQUJfVERJNDBBMCwgYjQzX250YWJfdGRpNDBhMCk7CisJbnRhYl91
cGxvYWQoZGV2LCBCNDNfTlRBQl9UREk0MEExLCBiNDNfbnRhYl90ZGk0MGExKTsK
KwludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0JESSwgYjQzX250YWJfYmRpKTsK
KwludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX0NIQU5FU1QsIGI0M19udGFiX2No
YW5uZWxlc3QpOworCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfTUNTLCBiNDNf
bnRhYl9tY3MpOworCisJLyogVm9sYXRpbGUgdGFibGVzICovCisJbnRhYl91cGxv
YWQoZGV2LCBCNDNfTlRBQl9OT0lTRVZBUjEwLCBiNDNfbnRhYl9ub2lzZXZhcjEw
KTsKKwludGFiX3VwbG9hZChkZXYsIEI0M19OVEFCX05PSVNFVkFSMTEsIGI0M19u
dGFiX25vaXNldmFyMTEpOworCW50YWJfdXBsb2FkKGRldiwgQjQzX05UQUJfQzBf
RVNUUExULCBiNDNfbnRhYl9lc3RpbWF0ZXBvd2VybHQwKTsKKwludGFiX3VwbG9h
ZChkZXYsIEI0M19OVEFCX0MxX0VTVFBMVCwgYjQzX250YWJfZXN0aW1hdGVwb3dl
cmx0MSk7CisJbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9DMF9BREpQTFQsIGI0
M19udGFiX2FkanVzdHBvd2VyMCk7CisJbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRB
Ql9DMV9BREpQTFQsIGI0M19udGFiX2FkanVzdHBvd2VyMSk7CisJbnRhYl91cGxv
YWQoZGV2LCBCNDNfTlRBQl9DMF9HQUlOQ1RMLCBiNDNfbnRhYl9nYWluY3RsMCk7
CisJbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9DMV9HQUlOQ1RMLCBiNDNfbnRh
Yl9nYWluY3RsMSk7CisJbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9DMF9JUUxU
LCBiNDNfbnRhYl9pcWx0MCk7CisJbnRhYl91cGxvYWQoZGV2LCBCNDNfTlRBQl9D
MV9JUUxULCBiNDNfbnRhYl9pcWx0MSk7CisJbnRhYl91cGxvYWQoZGV2LCBCNDNf
TlRBQl9DMF9MT0ZFRURUSCwgYjQzX250YWJfbG9mdGx0MCk7CisJbnRhYl91cGxv
YWQoZGV2LCBCNDNfTlRBQl9DMV9MT0ZFRURUSCwgYjQzX250YWJfbG9mdGx0MSk7
Cit9CisKK3ZvaWQgYjQzX25waHlfcmV2M3BsdXNfdGFibGVzX2luaXQoc3RydWN0
IGI0M193bGRldiAqZGV2KQoreworCS8qIFN0YXRpYyB0YWJsZXMgKi8KKwkvKiBU
T0RPICovCisKKwkvKiBWb2xhdGlsZSB0YWJsZXMgKi8KKwkvKiBUT0RPICovCit9
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9iNDMvdGFibGVzX25w
aHkuaCBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2I0My90YWJsZXNfbnBoeS5oCmlu
ZGV4IDRkNDk4YjAuLjIyNDAzNDUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2I0My90YWJsZXNfbnBoeS5oCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2I0My90YWJsZXNfbnBoeS5oCkBAIC0xMjgsMzIgKzEyOCwzNSBAQCBiNDNf
bnBoeV9nZXRfY2hhbnRhYmVudChzdHJ1Y3QgYjQzX3dsZGV2ICpkZXYsIHU4IGNo
YW5uZWwpOwogCiB2b2lkIGI0M19udGFiX3dyaXRlKHN0cnVjdCBiNDNfd2xkZXYg
KmRldiwgdTMyIG9mZnNldCwgdTMyIHZhbHVlKTsKIAotZXh0ZXJuIGNvbnN0IHU4
IGI0M19udGFiX2FkanVzdHBvd2VyMFtdOwotZXh0ZXJuIGNvbnN0IHU4IGI0M19u
dGFiX2FkanVzdHBvd2VyMVtdOwotZXh0ZXJuIGNvbnN0IHUxNiBiNDNfbnRhYl9i
ZGlbXTsKLWV4dGVybiBjb25zdCB1MzIgYjQzX250YWJfY2hhbm5lbGVzdFtdOwot
ZXh0ZXJuIGNvbnN0IHU4IGI0M19udGFiX2VzdGltYXRlcG93ZXJsdDBbXTsKLWV4
dGVybiBjb25zdCB1OCBiNDNfbnRhYl9lc3RpbWF0ZXBvd2VybHQxW107Ci1leHRl
cm4gY29uc3QgdTggYjQzX250YWJfZnJhbWVsb29rdXBbXTsKLWV4dGVybiBjb25z
dCB1MzIgYjQzX250YWJfZnJhbWVzdHJ1Y3RbXTsKLWV4dGVybiBjb25zdCB1MzIg
YjQzX250YWJfZ2FpbmN0bDBbXTsKLWV4dGVybiBjb25zdCB1MzIgYjQzX250YWJf
Z2FpbmN0bDFbXTsKLWV4dGVybiBjb25zdCB1MzIgYjQzX250YWJfaW50bGV2ZWxb
XTsKLWV4dGVybiBjb25zdCB1MzIgYjQzX250YWJfaXFsdDBbXTsKLWV4dGVybiBj
b25zdCB1MzIgYjQzX250YWJfaXFsdDFbXTsKLWV4dGVybiBjb25zdCB1MTYgYjQz
X250YWJfbG9mdGx0MFtdOwotZXh0ZXJuIGNvbnN0IHUxNiBiNDNfbnRhYl9sb2Z0
bHQxW107Ci1leHRlcm4gY29uc3QgdTggYjQzX250YWJfbWNzW107Ci1leHRlcm4g
Y29uc3QgdTMyIGI0M19udGFiX25vaXNldmFyMTBbXTsKLWV4dGVybiBjb25zdCB1
MzIgYjQzX250YWJfbm9pc2V2YXIxMVtdOwotZXh0ZXJuIGNvbnN0IHUxNiBiNDNf
bnRhYl9waWxvdFtdOwotZXh0ZXJuIGNvbnN0IHUzMiBiNDNfbnRhYl9waWxvdGx0
W107Ci1leHRlcm4gY29uc3QgdTMyIGI0M19udGFiX3RkaTIwYTBbXTsKLWV4dGVy
biBjb25zdCB1MzIgYjQzX250YWJfdGRpMjBhMVtdOwotZXh0ZXJuIGNvbnN0IHUz
MiBiNDNfbnRhYl90ZGk0MGEwW107Ci1leHRlcm4gY29uc3QgdTMyIGI0M19udGFi
X3RkaTQwYTFbXTsKLWV4dGVybiBjb25zdCB1MzIgYjQzX250YWJfdGR0cm5bXTsK
LWV4dGVybiBjb25zdCB1MzIgYjQzX250YWJfdG1hcFtdOwordm9pZCBiNDNfbnBo
eV9yZXYwXzFfMl90YWJsZXNfaW5pdChzdHJ1Y3QgYjQzX3dsZGV2ICpkZXYpOwor
dm9pZCBiNDNfbnBoeV9yZXYzcGx1c190YWJsZXNfaW5pdChzdHJ1Y3QgYjQzX3ds
ZGV2ICpkZXYpOworCitzdGF0aWMgY29uc3QgdTggYjQzX250YWJfYWRqdXN0cG93
ZXIwW107CitzdGF0aWMgY29uc3QgdTggYjQzX250YWJfYWRqdXN0cG93ZXIxW107
CitzdGF0aWMgY29uc3QgdTE2IGI0M19udGFiX2JkaVtdOworc3RhdGljIGNvbnN0
IHUzMiBiNDNfbnRhYl9jaGFubmVsZXN0W107CitzdGF0aWMgY29uc3QgdTggYjQz
X250YWJfZXN0aW1hdGVwb3dlcmx0MFtdOworc3RhdGljIGNvbnN0IHU4IGI0M19u
dGFiX2VzdGltYXRlcG93ZXJsdDFbXTsKK3N0YXRpYyBjb25zdCB1OCBiNDNfbnRh
Yl9mcmFtZWxvb2t1cFtdOworc3RhdGljIGNvbnN0IHUzMiBiNDNfbnRhYl9mcmFt
ZXN0cnVjdFtdOworc3RhdGljIGNvbnN0IHUzMiBiNDNfbnRhYl9nYWluY3RsMFtd
Oworc3RhdGljIGNvbnN0IHUzMiBiNDNfbnRhYl9nYWluY3RsMVtdOworc3RhdGlj
IGNvbnN0IHUzMiBiNDNfbnRhYl9pbnRsZXZlbFtdOworc3RhdGljIGNvbnN0IHUz
MiBiNDNfbnRhYl9pcWx0MFtdOworc3RhdGljIGNvbnN0IHUzMiBiNDNfbnRhYl9p
cWx0MVtdOworc3RhdGljIGNvbnN0IHUxNiBiNDNfbnRhYl9sb2Z0bHQwW107Citz
dGF0aWMgY29uc3QgdTE2IGI0M19udGFiX2xvZnRsdDFbXTsKK3N0YXRpYyBjb25z
dCB1OCBiNDNfbnRhYl9tY3NbXTsKK3N0YXRpYyBjb25zdCB1MzIgYjQzX250YWJf
bm9pc2V2YXIxMFtdOworc3RhdGljIGNvbnN0IHUzMiBiNDNfbnRhYl9ub2lzZXZh
cjExW107CitzdGF0aWMgY29uc3QgdTE2IGI0M19udGFiX3BpbG90W107CitzdGF0
aWMgY29uc3QgdTMyIGI0M19udGFiX3BpbG90bHRbXTsKK3N0YXRpYyBjb25zdCB1
MzIgYjQzX250YWJfdGRpMjBhMFtdOworc3RhdGljIGNvbnN0IHUzMiBiNDNfbnRh
Yl90ZGkyMGExW107CitzdGF0aWMgY29uc3QgdTMyIGI0M19udGFiX3RkaTQwYTBb
XTsKK3N0YXRpYyBjb25zdCB1MzIgYjQzX250YWJfdGRpNDBhMVtdOworc3RhdGlj
IGNvbnN0IHUzMiBiNDNfbnRhYl90ZHRybltdOworc3RhdGljIGNvbnN0IHUzMiBi
NDNfbnRhYl90bWFwW107CiAKIAogI2VuZGlmIC8qIEI0M19UQUJMRVNfTlBIWV9I
XyAqLwotLSAKMS42LjQuMgoK

------------0rjEM5Y4VVUEHCjNoz9mbP--

