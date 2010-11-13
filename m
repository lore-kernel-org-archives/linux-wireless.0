Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33747 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab0KMSOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 13:14:18 -0500
Received: by mail-ew0-f46.google.com with SMTP id 8so221913ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 10:14:18 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/9] rt2x00: Use ioremap for SoC devices instead of KSEG1ADDR.
Date: Sat, 13 Nov 2010 19:11:22 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201011131908.15595.IvDoorn@gmail.com> <201011131910.32367.IvDoorn@gmail.com> <201011131910.55175.IvDoorn@gmail.com>
In-Reply-To: <201011131910.55175.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011131911.22874.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Make the code a bit more portable to architectures that do not support
KSEG1ADDR.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Tested-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    4 +++-
 drivers/net/wireless/rt2x00/rt2x00soc.c |    6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index b0946f8..433c7f3 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -87,9 +87,11 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 #if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
 static void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
 {
-	u32 *base_addr = (u32 *) KSEG1ADDR(0x1F040000); /* XXX for RT3052 */
+	void __iomem *base_addr = ioremap(0x1F040000, EEPROM_SIZE);
 
 	memcpy_fromio(rt2x00dev->eeprom, base_addr, EEPROM_SIZE);
+
+	iounmap(base_addr);
 }
 #else
 static inline void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.c b/drivers/net/wireless/rt2x00/rt2x00soc.c
index fc98063..2aa5c38 100644
--- a/drivers/net/wireless/rt2x00/rt2x00soc.c
+++ b/drivers/net/wireless/rt2x00/rt2x00soc.c
@@ -40,6 +40,8 @@ static void rt2x00soc_free_reg(struct rt2x00_dev *rt2x00dev)
 
 	kfree(rt2x00dev->eeprom);
 	rt2x00dev->eeprom = NULL;
+
+	iounmap(rt2x00dev->csr.base);
 }
 
 static int rt2x00soc_alloc_reg(struct rt2x00_dev *rt2x00dev)
@@ -51,9 +53,9 @@ static int rt2x00soc_alloc_reg(struct rt2x00_dev *rt2x00dev)
 	if (!res)
 		return -ENODEV;
 
-	rt2x00dev->csr.base = (void __iomem *)KSEG1ADDR(res->start);
+	rt2x00dev->csr.base = ioremap(res->start, resource_size(res));
 	if (!rt2x00dev->csr.base)
-		goto exit;
+		return -ENOMEM;
 
 	rt2x00dev->eeprom = kzalloc(rt2x00dev->ops->eeprom_size, GFP_KERNEL);
 	if (!rt2x00dev->eeprom)
-- 
1.7.2.3

