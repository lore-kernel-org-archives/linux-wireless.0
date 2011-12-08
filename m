Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2175 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab1LHXHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:17 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/23] bcma: use static keyword for inline function
 declaration in bcma.h
Date: Thu, 8 Dec 2011 15:06:42 -0800
Message-ID: <1323385619-7454-7-git-send-email-frankyl@broadcom.com> (sfid-20111209_000825_071758_1EE00847)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Just scratching an itch here, but it makes more sense to use the
static keyword if you think about how the compiler treats inline
functions.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 include/linux/bcma/bcma.h |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index de6057f..f4b8346 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -205,50 +205,51 @@ struct bcma_bus {
 	struct ssb_sprom sprom;
 };
 
-extern inline u32 bcma_read8(struct bcma_device *core, u16 offset)
+static inline u32 bcma_read8(struct bcma_device *core, u16 offset)
 {
 	return core->bus->ops->read8(core, offset);
 }
-extern inline u32 bcma_read16(struct bcma_device *core, u16 offset)
+static inline u32 bcma_read16(struct bcma_device *core, u16 offset)
 {
 	return core->bus->ops->read16(core, offset);
 }
-extern inline u32 bcma_read32(struct bcma_device *core, u16 offset)
+static inline u32 bcma_read32(struct bcma_device *core, u16 offset)
 {
 	return core->bus->ops->read32(core, offset);
 }
-extern inline
+static inline
 void bcma_write8(struct bcma_device *core, u16 offset, u32 value)
 {
 	core->bus->ops->write8(core, offset, value);
 }
-extern inline
+static inline
 void bcma_write16(struct bcma_device *core, u16 offset, u32 value)
 {
 	core->bus->ops->write16(core, offset, value);
 }
-extern inline
+static inline
 void bcma_write32(struct bcma_device *core, u16 offset, u32 value)
 {
 	core->bus->ops->write32(core, offset, value);
 }
 #ifdef CONFIG_BCMA_BLOCKIO
-extern inline void bcma_block_read(struct bcma_device *core, void *buffer,
+static inline void bcma_block_read(struct bcma_device *core, void *buffer,
 				   size_t count, u16 offset, u8 reg_width)
 {
 	core->bus->ops->block_read(core, buffer, count, offset, reg_width);
 }
-extern inline void bcma_block_write(struct bcma_device *core, const void *buffer,
-				    size_t count, u16 offset, u8 reg_width)
+static inline void bcma_block_write(struct bcma_device *core,
+				    const void *buffer, size_t count,
+				    u16 offset, u8 reg_width)
 {
 	core->bus->ops->block_write(core, buffer, count, offset, reg_width);
 }
 #endif
-extern inline u32 bcma_aread32(struct bcma_device *core, u16 offset)
+static inline u32 bcma_aread32(struct bcma_device *core, u16 offset)
 {
 	return core->bus->ops->aread32(core, offset);
 }
-extern inline
+static inline
 void bcma_awrite32(struct bcma_device *core, u16 offset, u32 value)
 {
 	core->bus->ops->awrite32(core, offset, value);
-- 
1.7.5.4


