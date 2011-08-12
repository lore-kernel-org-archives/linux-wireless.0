Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38327 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab1HLKeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 06:34:46 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so2219714fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 03:34:45 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/4] b43: HT-PHY: init: copy tables and reset CCA
Date: Fri, 12 Aug 2011 13:13:46 +0200
Message-Id: <1313147627-8713-3-git-send-email-zajec5@gmail.com> (sfid-20110812_123455_858435_E06C8A42)
In-Reply-To: <1313147627-8713-1-git-send-email-zajec5@gmail.com>
References: <1313147627-8713-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Copying comes from following part of the dump:
phy_write(0x0072) <- 0x1d44
 phy_read(0x0073) -> 0x0002
phy_write(0x0072) <- 0x1d4a
phy_write(0x0073) <- 0x0002

phy_write(0x0072) <- 0x1d54
 phy_read(0x0073) -> 0x0002
phy_write(0x0072) <- 0x1d5a
phy_write(0x0073) <- 0x0002

phy_write(0x0072) <- 0x1d64
 phy_read(0x0073) -> 0x0002
phy_write(0x0072) <- 0x1d6a
phy_write(0x0073) <- 0x0002

CCA reset from dump (known from N-PHY):
 read32 0xb0601408 -> 0x00002055
write32 0xb0601408 <- 0x00002057
 read32 0xb0601408 -> 0x00002057
 phy_read(0x0001) -> 0x0000
phy_write(0x0001) <- 0x4000
phy_write(0x0001) <- 0x0000
 read32 0xb0601408 -> 0x00002057
write32 0xb0601408 <- 0x00002055
 read32 0xb0601408 -> 0x00002055

Finally well-known MAC PHY clock en:
 read32 0xb0601408 -> 0x00002055
write32 0xb0601408 <- 0x00002055
 read32 0xb0601408 -> 0x00002055
---
 drivers/net/wireless/b43/phy_ht.c |   21 +++++++++++++++++++++
 drivers/net/wireless/b43/phy_ht.h |    4 ++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 969e86e..2ea7b08 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -273,6 +273,8 @@ static void b43_phy_ht_op_prepare_structs(struct b43_wldev *dev)
 
 static int b43_phy_ht_op_init(struct b43_wldev *dev)
 {
+	u16 tmp;
+
 	b43_phy_ht_tables_init(dev);
 
 	/* TODO: PHY ops on regs 0x0be, 0x23f 0x240 0x241 */
@@ -301,6 +303,25 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
 
 	b43_phy_write(dev, 0x0b9, 0x0072);
 
+	/* TODO: Some ops here */
+
+	/* Copy some tables entries */
+	tmp = b43_httab_read(dev, B43_HTTAB16(7, 0x144));
+	b43_httab_write(dev, B43_HTTAB16(7, 0x14a), tmp);
+	tmp = b43_httab_read(dev, B43_HTTAB16(7, 0x154));
+	b43_httab_write(dev, B43_HTTAB16(7, 0x15a), tmp);
+	tmp = b43_httab_read(dev, B43_HTTAB16(7, 0x164));
+	b43_httab_write(dev, B43_HTTAB16(7, 0x16a), tmp);
+
+	/* Reset CCA */
+	b43_phy_force_clock(dev, true);
+	tmp = b43_phy_read(dev, B43_PHY_HT_BBCFG);
+	b43_phy_write(dev, B43_PHY_HT_BBCFG, tmp | B43_PHY_HT_BBCFG_RSTCCA);
+	b43_phy_write(dev, B43_PHY_HT_BBCFG, tmp & ~B43_PHY_HT_BBCFG_RSTCCA);
+	b43_phy_force_clock(dev, false);
+
+	b43_mac_phy_clock_set(dev, true);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/b43/phy_ht.h b/drivers/net/wireless/b43/phy_ht.h
index 7ad7aff..f70af0c 100644
--- a/drivers/net/wireless/b43/phy_ht.h
+++ b/drivers/net/wireless/b43/phy_ht.h
@@ -4,7 +4,11 @@
 #include "phy_common.h"
 
 
+#define B43_PHY_HT_BBCFG			0x001 /* BB config */
+#define  B43_PHY_HT_BBCFG_RSTCCA		0x4000 /* Reset CCA */
+#define  B43_PHY_HT_BBCFG_RSTRX			0x8000 /* Reset RX */
 #define B43_PHY_HT_BANDCTL			0x009 /* Band control */
+#define  B43_PHY_HT_BANDCTL_5GHZ		0x0001 /* Use the 5GHz band */
 #define B43_PHY_HT_TABLE_ADDR			0x072 /* Table address */
 #define B43_PHY_HT_TABLE_DATALO			0x073 /* Table data low */
 #define B43_PHY_HT_TABLE_DATAHI			0x074 /* Table data high */
-- 
1.7.3.4

