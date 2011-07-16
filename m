Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:50893 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab1GPW1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 18:27:32 -0400
Received: by fxd18 with SMTP id 18so4497137fxd.11
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jul 2011 15:27:31 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/4] bcma: trivial: add helpers for masking/setting
Date: Sun, 17 Jul 2011 01:06:03 +0200
Message-Id: <1310857566-2876-1-git-send-email-zajec5@gmail.com> (sfid-20110717_002735_846120_726F486B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 include/linux/bcma/bcma.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 3895aeb..6e5dc7b 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -243,8 +243,16 @@ void bcma_awrite32(struct bcma_device *core, u16 offset, u32 value)
 	core->bus->ops->awrite32(core, offset, value);
 }
 
+#define bcma_mask32(cc, offset, mask) \
+	bcma_write32(cc, offset, bcma_read32(cc, offset) & (mask))
+#define bcma_set32(cc, offset, set) \
+	bcma_write32(cc, offset, bcma_read32(cc, offset) | (set))
+#define bcma_maskset32(cc, offset, mask, set) \
+	bcma_write32(cc, offset, (bcma_read32(cc, offset) & (mask)) | (set))
+
 extern bool bcma_core_is_enabled(struct bcma_device *core);
 extern void bcma_core_disable(struct bcma_device *core, u32 flags);
 extern int bcma_core_enable(struct bcma_device *core, u32 flags);
 
+
 #endif /* LINUX_BCMA_H_ */
-- 
1.7.3.4

