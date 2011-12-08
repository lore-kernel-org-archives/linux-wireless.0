Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2131 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab1LHXHM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:12 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/23] bcma: add set/mask macros for 16-bit register
 access
Date: Thu, 8 Dec 2011 15:06:41 -0800
Message-ID: <1323385619-7454-6-git-send-email-frankyl@broadcom.com> (sfid-20111209_000732_870562_8A570711)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The BCMA header only had definitions for 32-bit register access. Used
those as a template for the 16-bit flavour. Also changed them to inline
functions to be on the safe side. As offset parameter is used twice there
would be a problem when used like this: bcma_set32(core, offset++, val);

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 include/linux/bcma/bcma.h |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 4d4b59d..de6057f 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -254,12 +254,32 @@ void bcma_awrite32(struct bcma_device *core, u16 offset, u32 value)
 	core->bus->ops->awrite32(core, offset, value);
 }
 
-#define bcma_mask32(cc, offset, mask) \
-	bcma_write32(cc, offset, bcma_read32(cc, offset) & (mask))
-#define bcma_set32(cc, offset, set) \
-	bcma_write32(cc, offset, bcma_read32(cc, offset) | (set))
-#define bcma_maskset32(cc, offset, mask, set) \
-	bcma_write32(cc, offset, (bcma_read32(cc, offset) & (mask)) | (set))
+static inline void bcma_mask32(struct bcma_device *cc, u16 offset, u32 mask)
+{
+	bcma_write32(cc, offset, bcma_read32(cc, offset) & mask);
+}
+static inline void bcma_set32(struct bcma_device *cc, u16 offset, u32 set)
+{
+	bcma_write32(cc, offset, bcma_read32(cc, offset) | set);
+}
+static inline void bcma_maskset32(struct bcma_device *cc,
+				  u16 offset, u32 mask, u32 set)
+{
+	bcma_write32(cc, offset, (bcma_read32(cc, offset) & mask) | set);
+}
+static inline void bcma_mask16(struct bcma_device *cc, u16 offset, u16 mask)
+{
+	bcma_write16(cc, offset, bcma_read16(cc, offset) & mask);
+}
+static inline void bcma_set16(struct bcma_device *cc, u16 offset, u16 set)
+{
+	bcma_write16(cc, offset, bcma_read16(cc, offset) | set);
+}
+static inline void bcma_maskset16(struct bcma_device *cc,
+				  u16 offset, u16 mask, u16 set)
+{
+	bcma_write16(cc, offset, (bcma_read16(cc, offset) & mask) | set);
+}
 
 extern bool bcma_core_is_enabled(struct bcma_device *core);
 extern void bcma_core_disable(struct bcma_device *core, u32 flags);
-- 
1.7.5.4


