Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:36165 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbaC1RNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 13:13:21 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so4304682eek.41
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 10:13:20 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: dan.carpenter@oracle.com, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	andrea.merello@gmail.com
Subject: [PATCH 2/2] rtl8180: don't use weird trick to access "far" registers
Date: Fri, 28 Mar 2014 18:14:28 +0100
Message-Id: <1396026868-5622-1-git-send-email-andrea.merello@gmail.com> (sfid-20140328_181326_432580_B2B6F41F)
In-Reply-To: <20140328093038.GD7045@mwanda>
References: <20140328093038.GD7045@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In rtl8180/rtl8185/rtl8187se the register space is represented
using packed structure type. Register are thus accessed using a
pointer of this type.
All registers are packed toghether, and only small gaps are present.

However Rtl8187se has also some "sparse" registers, very far from
the "main register block".

It could be possible to access them by simply declare huge reserved
blocks inside the register struct (and this causes NO memory waste).
However, for various reasons, access to those "far" registers is
done with special dedicated macros, without declaring them in the
register struct.

This is done in an intricate manner, that makes code less readable
and caused static analisys tool to produce warnings.

This patch keeps the "macro" mechanism, but it changes its
implementation in a simplier and more straightforward way.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl818x.h | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl818x.h b/drivers/net/wireless/rtl818x/rtl818x.h
index 99dbc12..45ea4e1 100644
--- a/drivers/net/wireless/rtl818x/rtl818x.h
+++ b/drivers/net/wireless/rtl818x/rtl818x.h
@@ -17,13 +17,7 @@
 
 struct rtl818x_csr {
 
-	union {
-		u8	MAC[6];
-		u8	offset1[6];     /* upper page indexing helpers */
-		__le16	offset2[1];
-		__le32	offset4[1];
-	} __packed;
-
+	u8	MAC[6];
 	u8	reserved_0[2];
 
 	union {
@@ -340,9 +334,9 @@ struct rtl818x_csr {
  * I don't like to introduce a ton of "reserved"..
  * They are for RTL8187SE
  */
-#define REG_ADDR1(addr)	((u8 __iomem *)(&priv->map->offset1[(addr)]))
-#define REG_ADDR2(addr)	((__le16 __iomem *)(&priv->map->offset2[((addr) >> 1)]))
-#define REG_ADDR4(addr)	((__le32 __iomem *)(&priv->map->offset4[((addr) >> 2)]))
+#define REG_ADDR1(addr)	((u8 __iomem *)priv->map + addr)
+#define REG_ADDR2(addr)	((__le16 __iomem *)priv->map + (addr >> 1))
+#define REG_ADDR4(addr)	((__le32 __iomem *)priv->map + (addr >> 2))
 
 #define FEMR_SE		REG_ADDR2(0x1D4)
 #define ARFR		REG_ADDR2(0x1E0)
-- 
1.8.3.2

