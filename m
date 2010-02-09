Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:34124 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab0BIUFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 15:05:25 -0500
Received: by mail-ew0-f228.google.com with SMTP id 28so4264852ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 09 Feb 2010 12:05:24 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 08/11] b43: implement writing to MMIO shared memory
Date: Tue,  9 Feb 2010 21:04:40 +0100
Message-Id: <1265745883-3392-9-git-send-email-zajec5@gmail.com>
In-Reply-To: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_common.c |   11 +++++++++++
 drivers/net/wireless/b43/phy_common.h |    2 ++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 8f7d7ef..0b0f9df 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -466,3 +466,14 @@ struct b43_c32 b43_cordic(int theta)
 
 	return ret;
 }
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacWriteShm */
+void b43_bmac_write_shm(struct b43_wldev *dev, u32 offset, u16 value)
+{
+	b43_write32(dev, B43_MMIO_SHM_CONTROL, 0x00010000 | (offset >> 2));
+	b43_read32(dev, B43_MMIO_SHM_CONTROL);
+	if (offset & 2)
+		b43_write16(dev, 0x165, value);
+	else
+		b43_write16(dev, B43_MMIO_SHM_DATA, value);
+}
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index bd480b4..484d4d7 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -429,4 +429,6 @@ void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on);
 
 struct b43_c32 b43_cordic(int theta);
 
+void b43_bmac_write_shm(struct b43_wldev *dev, u32 offset, u16 value);
+
 #endif /* LINUX_B43_PHY_COMMON_H_ */
-- 
1.6.4.2

