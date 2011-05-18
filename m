Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57019 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab1EQX3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 19:29:09 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so286932eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 16:29:08 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/9] b43: bus: abstract R/W operations
Date: Wed, 18 May 2011 02:06:37 +0200
Message-Id: <1305677203-16660-3-git-send-email-zajec5@gmail.com> (sfid-20110518_012913_537036_D7D59228)
In-Reply-To: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
References: <1305677203-16660-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h |   12 ++++++------
 drivers/net/wireless/b43/bus.c |   38 ++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/bus.h |    9 +++++++++
 3 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 9e9b24b..a6d4848 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -883,34 +883,34 @@ static inline enum ieee80211_band b43_current_band(struct b43_wl *wl)
 
 static inline u16 b43_read16(struct b43_wldev *dev, u16 offset)
 {
-	return ssb_read16(dev->sdev, offset);
+	return dev->dev->read16(dev->dev, offset);
 }
 
 static inline void b43_write16(struct b43_wldev *dev, u16 offset, u16 value)
 {
-	ssb_write16(dev->sdev, offset, value);
+	dev->dev->write16(dev->dev, offset, value);
 }
 
 static inline u32 b43_read32(struct b43_wldev *dev, u16 offset)
 {
-	return ssb_read32(dev->sdev, offset);
+	return dev->dev->read32(dev->dev, offset);
 }
 
 static inline void b43_write32(struct b43_wldev *dev, u16 offset, u32 value)
 {
-	ssb_write32(dev->sdev, offset, value);
+	dev->dev->write32(dev->dev, offset, value);
 }
 
 static inline void b43_block_read(struct b43_wldev *dev, void *buffer,
 				 size_t count, u16 offset, u8 reg_width)
 {
-	ssb_block_read(dev->sdev, buffer, count, offset, reg_width);
+	dev->dev->block_read(dev->dev, buffer, count, offset, reg_width);
 }
 
 static inline void b43_block_write(struct b43_wldev *dev, const void *buffer,
 				   size_t count, u16 offset, u8 reg_width)
 {
-	ssb_block_write(dev->sdev, buffer, count, offset, reg_width);
+	dev->dev->block_write(dev->dev, buffer, count, offset, reg_width);
 }
 
 static inline bool b43_using_pio_transfers(struct b43_wldev *dev)
diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index f8ccd2c..fe5fa26 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -25,6 +25,37 @@
 
 
 /* SSB */
+static inline u16 b43_bus_ssb_read16(struct b43_bus_dev *dev, u16 offset)
+{
+	return ssb_read16(dev->sdev, offset);
+}
+static inline u32 b43_bus_ssb_read32(struct b43_bus_dev *dev, u16 offset)
+{
+	return ssb_read32(dev->sdev, offset);
+}
+static inline
+void b43_bus_ssb_write16(struct b43_bus_dev *dev, u16 offset, u16 value)
+{
+	ssb_write16(dev->sdev, offset, value);
+}
+static inline
+void b43_bus_ssb_write32(struct b43_bus_dev *dev, u16 offset, u32 value)
+{
+	ssb_write32(dev->sdev, offset, value);
+}
+static inline
+void b43_bus_ssb_block_read(struct b43_bus_dev *dev, void *buffer,
+			    size_t count, u16 offset, u8 reg_width)
+{
+	ssb_block_read(dev->sdev, buffer, count, offset, reg_width);
+}
+static inline
+void b43_bus_ssb_block_write(struct b43_bus_dev *dev, const void *buffer,
+			     size_t count, u16 offset, u8 reg_width)
+{
+	ssb_block_write(dev->sdev, buffer, count, offset, reg_width);
+}
+
 struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
 {
 	struct b43_bus_dev *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -32,5 +63,12 @@ struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
 	dev->bus_type = B43_BUS_SSB;
 	dev->sdev = sdev;
 
+	dev->read16 = b43_bus_ssb_read16;
+	dev->read32 = b43_bus_ssb_read32;
+	dev->write16 = b43_bus_ssb_write16;
+	dev->write32 = b43_bus_ssb_write32;
+	dev->block_read = b43_bus_ssb_block_read;
+	dev->block_write = b43_bus_ssb_block_write;
+
 	return dev;
 }
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index 68bc00a..9b39002 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -10,6 +10,15 @@ struct b43_bus_dev {
 	union {
 		struct ssb_device *sdev;
 	};
+
+	u16 (*read16)(struct b43_bus_dev *dev, u16 offset);
+	u32 (*read32)(struct b43_bus_dev *dev, u16 offset);
+	void (*write16)(struct b43_bus_dev *dev, u16 offset, u16 value);
+	void (*write32)(struct b43_bus_dev *dev, u16 offset, u32 value);
+	void (*block_read)(struct b43_bus_dev *dev, void *buffer,
+			   size_t count, u16 offset, u8 reg_width);
+	void (*block_write)(struct b43_bus_dev *dev, const void *buffer,
+			    size_t count, u16 offset, u8 reg_width);
 };
 
 struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev);
-- 
1.7.3.4

