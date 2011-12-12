Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39708 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1LLUEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 15:04:23 -0500
Received: by eekc4 with SMTP id c4so1793076eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 12:04:22 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] b43: N-PHY: fix 32-bit reads of tables
Date: Mon, 12 Dec 2011 21:38:35 +0100
Message-Id: <1323722316-4265-1-git-send-email-zajec5@gmail.com> (sfid-20111212_210427_734282_68782C24)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The order is different than on older PHYs.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/tables_nphy.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 691839e..e1fc337 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2880,9 +2880,8 @@ u32 b43_ntab_read(struct b43_wldev *dev, u32 offset)
 		break;
 	case B43_NTAB_32BIT:
 		b43_phy_write(dev, B43_NPHY_TABLE_ADDR, offset);
-		value = b43_phy_read(dev, B43_NPHY_TABLE_DATAHI);
-		value <<= 16;
-		value |= b43_phy_read(dev, B43_NPHY_TABLE_DATALO);
+		value = b43_phy_read(dev, B43_NPHY_TABLE_DATALO);
+		value |= b43_phy_read(dev, B43_NPHY_TABLE_DATAHI) << 16;
 		break;
 	default:
 		B43_WARN_ON(1);
@@ -2916,9 +2915,10 @@ void b43_ntab_read_bulk(struct b43_wldev *dev, u32 offset,
 			data += 2;
 			break;
 		case B43_NTAB_32BIT:
-			*((u32 *)data) = b43_phy_read(dev, B43_NPHY_TABLE_DATAHI);
-			*((u32 *)data) <<= 16;
-			*((u32 *)data) |= b43_phy_read(dev, B43_NPHY_TABLE_DATALO);
+			*((u32 *)data) =
+				b43_phy_read(dev, B43_NPHY_TABLE_DATALO);
+			*((u32 *)data) |=
+				b43_phy_read(dev, B43_NPHY_TABLE_DATAHI) << 16;
 			data += 4;
 			break;
 		default:
-- 
1.7.3.4

