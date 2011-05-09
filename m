Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32866 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1EIJFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 05:05:51 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so1473428eyx.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 02:05:51 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC ONLY 3/5] b43: bus: abstract R/W operations
Date: Mon,  9 May 2011 11:43:19 +0200
Message-Id: <1304934201-10626-3-git-send-email-zajec5@gmail.com> (sfid-20110509_110555_052180_CF82132F)
In-Reply-To: <1304934201-10626-1-git-send-email-zajec5@gmail.com>
References: <1304934201-10626-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/b43/b43.h |    8 ++++----
 drivers/net/wireless/b43/bus.c |   22 ++++++++++++++++++++++
 drivers/net/wireless/b43/bus.h |    5 +++++
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 8c8ae1e..11bf4d9 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -881,22 +881,22 @@ static inline enum ieee80211_band b43_current_band(struct b43_wl *wl)
 
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
 
 static inline bool b43_using_pio_transfers(struct b43_wldev *dev)
diff --git a/drivers/net/wireless/b43/bus.c b/drivers/net/wireless/b43/bus.c
index f8ccd2c..8f9c133 100644
--- a/drivers/net/wireless/b43/bus.c
+++ b/drivers/net/wireless/b43/bus.c
@@ -25,6 +25,23 @@
 
 
 /* SSB */
+static inline u16 b43_bus_ssb_read16(struct b43_bus_dev *dev, u16 offset)
+{
+	return ssb_read16(dev->sdev, offset);
+}
+static inline u32 b43_bus_ssb_read32(struct b43_bus_dev *dev, u16 offset)
+{
+	return ssb_read32(dev->sdev, offset);
+}
+static inline void b43_bus_ssb_write16(struct b43_bus_dev *dev, u16 offset, u16 value)
+{
+	ssb_write16(dev->sdev, offset, value);
+}
+static inline void b43_bus_ssb_write32(struct b43_bus_dev *dev, u16 offset, u32 value)
+{
+	ssb_write32(dev->sdev, offset, value);
+}
+
 struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
 {
 	struct b43_bus_dev *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -32,5 +49,10 @@ struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev)
 	dev->bus_type = B43_BUS_SSB;
 	dev->sdev = sdev;
 
+	dev->read16 = b43_bus_ssb_read16;
+	dev->read32 = b43_bus_ssb_read32;
+	dev->write16 = b43_bus_ssb_write16;
+	dev->write32 = b43_bus_ssb_write32;
+
 	return dev;
 }
diff --git a/drivers/net/wireless/b43/bus.h b/drivers/net/wireless/b43/bus.h
index 68bc00a..7d60f4f 100644
--- a/drivers/net/wireless/b43/bus.h
+++ b/drivers/net/wireless/b43/bus.h
@@ -10,6 +10,11 @@ struct b43_bus_dev {
 	union {
 		struct ssb_device *sdev;
 	};
+
+	u16 (*read16)(struct b43_bus_dev *dev, u16 offset);
+	u32 (*read32)(struct b43_bus_dev *dev, u16 offset);
+	void (*write16)(struct b43_bus_dev *dev, u16 offset, u16 value);
+	void (*write32)(struct b43_bus_dev *dev, u16 offset, u32 value);
 };
 
 struct b43_bus_dev *b43_bus_dev_ssb_init(struct ssb_device *sdev);
-- 
1.7.3.4

