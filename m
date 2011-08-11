Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61218 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab1HKVbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 17:31:20 -0400
Received: by fxh19 with SMTP id 19so1950791fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 14:31:19 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH] b43: HT-PHY: allow writing longer tables with a single call
Date: Fri, 12 Aug 2011 00:10:27 +0200
Message-Id: <1313100627-26186-1-git-send-email-zajec5@gmail.com> (sfid-20110811_233123_565075_61608F63)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometime we need to write table which is 2-10 elements long. It's easier
to create such a function instead of defining array every time.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/tables_phy_ht.c |   45 ++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/tables_phy_ht.h |    1 +
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/tables_phy_ht.c b/drivers/net/wireless/b43/tables_phy_ht.c
index 6039386..9681af5 100644
--- a/drivers/net/wireless/b43/tables_phy_ht.c
+++ b/drivers/net/wireless/b43/tables_phy_ht.c
@@ -674,6 +674,51 @@ void b43_httab_write(struct b43_wldev *dev, u32 offset, u32 value)
 	return;
 }
 
+void b43_httab_write_few(struct b43_wldev *dev, u32 offset, size_t num, ...)
+{
+	va_list args;
+	u32 type, value;
+	unsigned int i;
+
+	type = offset & B43_HTTAB_TYPEMASK;
+	offset &= 0xFFFF;
+
+	va_start(args, num);
+	switch (type) {
+	case B43_HTTAB_8BIT:
+		b43_phy_write(dev, B43_PHY_HT_TABLE_ADDR, offset);
+		for (i = 0; i < num; i++) {
+			value = va_arg(args, int);
+			B43_WARN_ON(value & ~0xFF);
+			b43_phy_write(dev, B43_PHY_HT_TABLE_DATALO, value);
+		}
+		break;
+	case B43_HTTAB_16BIT:
+		b43_phy_write(dev, B43_PHY_HT_TABLE_ADDR, offset);
+		for (i = 0; i < num; i++) {
+			value = va_arg(args, int);
+			B43_WARN_ON(value & ~0xFFFF);
+			b43_phy_write(dev, B43_PHY_HT_TABLE_DATALO, value);
+		}
+		break;
+	case B43_HTTAB_32BIT:
+		b43_phy_write(dev, B43_PHY_HT_TABLE_ADDR, offset);
+		for (i = 0; i < num; i++) {
+			value = va_arg(args, int);
+			b43_phy_write(dev, B43_PHY_HT_TABLE_DATAHI,
+				      value >> 16);
+			b43_phy_write(dev, B43_PHY_HT_TABLE_DATALO,
+				      value & 0xFFFF);
+		}
+		break;
+	default:
+		B43_WARN_ON(1);
+	}
+	va_end(args);
+
+	return;
+}
+
 void b43_httab_write_bulk(struct b43_wldev *dev, u32 offset,
 			  unsigned int nr_elements, const void *_data)
 {
diff --git a/drivers/net/wireless/b43/tables_phy_ht.h b/drivers/net/wireless/b43/tables_phy_ht.h
index ea3be38..c68b0fa 100644
--- a/drivers/net/wireless/b43/tables_phy_ht.h
+++ b/drivers/net/wireless/b43/tables_phy_ht.h
@@ -14,6 +14,7 @@ u32 b43_httab_read(struct b43_wldev *dev, u32 offset);
 void b43_httab_read_bulk(struct b43_wldev *dev, u32 offset,
 			 unsigned int nr_elements, void *_data);
 void b43_httab_write(struct b43_wldev *dev, u32 offset, u32 value);
+void b43_httab_write_few(struct b43_wldev *dev, u32 offset, size_t num, ...);
 void b43_httab_write_bulk(struct b43_wldev *dev, u32 offset,
 			  unsigned int nr_elements, const void *_data);
 
-- 
1.7.3.4

