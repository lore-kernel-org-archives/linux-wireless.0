Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56900 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab1HaVeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 17:34:05 -0400
Received: by eyx24 with SMTP id 24so1223358eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 14:34:04 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/6] b43: LCN-PHY: minor fixes
Date: Wed, 31 Aug 2011 23:36:16 +0200
Message-Id: <1314826581-27852-1-git-send-email-zajec5@gmail.com> (sfid-20110831_233412_057193_60A2C5BA)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The biggest change is reversing order of reading 32-bit table value.
MMIO dumps has shown it's done that way for LCN-PHY.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h            |    2 ++
 drivers/net/wireless/b43/main.c           |    1 +
 drivers/net/wireless/b43/tables_phy_lcn.c |   10 ++++------
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 8ff7062..f8615cd 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -110,6 +110,8 @@
 #define B43_MMIO_TSF_CFP_START_LOW	0x604
 #define B43_MMIO_TSF_CFP_START_HIGH	0x606
 #define B43_MMIO_TSF_CFP_PRETBTT	0x612
+#define B43_MMIO_TSF_CLK_FRAC_LOW	0x62E
+#define B43_MMIO_TSF_CLK_FRAC_HIGH	0x630
 #define B43_MMIO_TSF_0			0x632	/* core rev < 3 only */
 #define B43_MMIO_TSF_1			0x634	/* core rev < 3 only */
 #define B43_MMIO_TSF_2			0x636	/* core rev < 3 only */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 1722941..6bca727 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2953,6 +2953,7 @@ static void b43_rate_memory_init(struct b43_wldev *dev)
 	case B43_PHYTYPE_N:
 	case B43_PHYTYPE_LP:
 	case B43_PHYTYPE_HT:
+	case B43_PHYTYPE_LCN:
 		b43_rate_memory_write(dev, B43_OFDM_RATE_6MB, 1);
 		b43_rate_memory_write(dev, B43_OFDM_RATE_12MB, 1);
 		b43_rate_memory_write(dev, B43_OFDM_RATE_18MB, 1);
diff --git a/drivers/net/wireless/b43/tables_phy_lcn.c b/drivers/net/wireless/b43/tables_phy_lcn.c
index 0a58428..916d3f1 100644
--- a/drivers/net/wireless/b43/tables_phy_lcn.c
+++ b/drivers/net/wireless/b43/tables_phy_lcn.c
@@ -318,9 +318,8 @@ u32 b43_lcntab_read(struct b43_wldev *dev, u32 offset)
 		break;
 	case B43_LCNTAB_32BIT:
 		b43_phy_write(dev, B43_PHY_LCN_TABLE_ADDR, offset);
-		value = b43_phy_read(dev, B43_PHY_LCN_TABLE_DATAHI);
-		value <<= 16;
-		value |= b43_phy_read(dev, B43_PHY_LCN_TABLE_DATALO);
+		value = b43_phy_read(dev, B43_PHY_LCN_TABLE_DATALO);
+		value |= (b43_phy_read(dev, B43_PHY_LCN_TABLE_DATAHI) << 16);
 		break;
 	default:
 		B43_WARN_ON(1);
@@ -357,10 +356,9 @@ void b43_lcntab_read_bulk(struct b43_wldev *dev, u32 offset,
 			break;
 		case B43_LCNTAB_32BIT:
 			*((u32 *)data) = b43_phy_read(dev,
-						      B43_PHY_LCN_TABLE_DATAHI);
-			*((u32 *)data) <<= 16;
-			*((u32 *)data) |= b43_phy_read(dev,
 						B43_PHY_LCN_TABLE_DATALO);
+			*((u32 *)data) |= (b43_phy_read(dev,
+					   B43_PHY_LCN_TABLE_DATAHI) << 16);
 			data += 4;
 			break;
 		default:
-- 
1.7.3.4

