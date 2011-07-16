Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:50986 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1GPWgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 18:36:40 -0400
Received: by fxd18 with SMTP id 18so4501722fxd.11
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jul 2011 15:36:39 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: bus: drop inline from SSB functions
Date: Sun, 17 Jul 2011 01:15:18 +0200
Message-Id: <1310858118-3948-1-git-send-email-zajec5@gmail.com> (sfid-20110717_003643_755125_47404F45)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We use all that functions by pointers only. This forces compiler to
create additional duplicated functions that are not inline.
Noticed by Michael in similar bcma code.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/bus.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index a5e61a9..64c3f65 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -126,55 +126,52 @@ struct b43_bus_dev *b43_bus_dev_bcma_init(struct bcma_device *core)
 
 /* SSB */
 #ifdef CONFIG_B43_SSB
-static inline int b43_bus_ssb_bus_may_powerdown(struct b43_bus_dev *dev)
+static int b43_bus_ssb_bus_may_powerdown(struct b43_bus_dev *dev)
 {
 	return ssb_bus_may_powerdown(dev->sdev->bus);
 }
-static inline int b43_bus_ssb_bus_powerup(struct b43_bus_dev *dev,
+static int b43_bus_ssb_bus_powerup(struct b43_bus_dev *dev,
 					  bool dynamic_pctl)
 {
 	return ssb_bus_powerup(dev->sdev->bus, dynamic_pctl);
 }
-static inline int b43_bus_ssb_device_is_enabled(struct b43_bus_dev *dev)
+static int b43_bus_ssb_device_is_enabled(struct b43_bus_dev *dev)
 {
 	return ssb_device_is_enabled(dev->sdev);
 }
-static inline void b43_bus_ssb_device_enable(struct b43_bus_dev *dev,
+static void b43_bus_ssb_device_enable(struct b43_bus_dev *dev,
 					     u32 core_specific_flags)
 {
 	ssb_device_enable(dev->sdev, core_specific_flags);
 }
-static inline void b43_bus_ssb_device_disable(struct b43_bus_dev *dev,
+static void b43_bus_ssb_device_disable(struct b43_bus_dev *dev,
 					      u32 core_specific_flags)
 {
 	ssb_device_disable(dev->sdev, core_specific_flags);
 }
 
-static inline u16 b43_bus_ssb_read16(struct b43_bus_dev *dev, u16 offset)
+static u16 b43_bus_ssb_read16(struct b43_bus_dev *dev, u16 offset)
 {
 	return ssb_read16(dev->sdev, offset);
 }
-static inline u32 b43_bus_ssb_read32(struct b43_bus_dev *dev, u16 offset)
+static u32 b43_bus_ssb_read32(struct b43_bus_dev *dev, u16 offset)
 {
 	return ssb_read32(dev->sdev, offset);
 }
-static inline
-void b43_bus_ssb_write16(struct b43_bus_dev *dev, u16 offset, u16 value)
+static void b43_bus_ssb_write16(struct b43_bus_dev *dev, u16 offset, u16 value)
 {
 	ssb_write16(dev->sdev, offset, value);
 }
-static inline
-void b43_bus_ssb_write32(struct b43_bus_dev *dev, u16 offset, u32 value)
+static void b43_bus_ssb_write32(struct b43_bus_dev *dev, u16 offset, u32 value)
 {
 	ssb_write32(dev->sdev, offset, value);
 }
-static inline
-void b43_bus_ssb_block_read(struct b43_bus_dev *dev, void *buffer,
-			    size_t count, u16 offset, u8 reg_width)
+static void b43_bus_ssb_block_read(struct b43_bus_dev *dev, void *buffer,
+				   size_t count, u16 offset, u8 reg_width)
 {
 	ssb_block_read(dev->sdev, buffer, count, offset, reg_width);
 }
-static inline
+static
 void b43_bus_ssb_block_write(struct b43_bus_dev *dev, const void *buffer,
 			     size_t count, u16 offset, u8 reg_width)
 {
-- 
1.7.3.4

