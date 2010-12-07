Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42578 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab0LGIm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 03:42:59 -0500
Received: by wwa36 with SMTP id 36so13861226wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 00:42:57 -0800 (PST)
From: =?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?utf-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/4] b43: flush PHY writes when needed
Date: Tue,  7 Dec 2010 09:42:07 +0100
Message-Id: <1291711327-4690-4-git-send-email-zajec5@gmail.com>
In-Reply-To: <1291711327-4690-1-git-send-email-zajec5@gmail.com>
References: <1291711327-4690-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_common.c |    5 +++++
 drivers/net/wireless/b43/phy_common.h |    6 ++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index fa7f83f..0a91fc3 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -231,6 +231,7 @@ void b43_radio_maskset(struct b43_wldev *dev, u16 offset, u16 mask, u16 set)
 u16 b43_phy_read(struct b43_wldev *dev, u16 reg)
 {
 	assert_mac_suspended(dev);
+	dev->phy.writes_counter = 0;
 	return dev->phy.ops->phy_read(dev, reg);
 }
 
@@ -238,6 +239,10 @@ void b43_phy_write(struct b43_wldev *dev, u16 reg, u16 value)
 {
 	assert_mac_suspended(dev);
 	dev->phy.ops->phy_write(dev, reg, value);
+	if (++dev->phy.writes_counter == B43_MAX_WRITES_IN_ROW) {
+		b43_read16(dev, B43_MMIO_PHY_VER);
+		dev->phy.writes_counter = 0;
+	}
 }
 
 void b43_phy_copy(struct b43_wldev *dev, u16 destreg, u16 srcreg)
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 0e61942..2ed60e5 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -39,6 +39,9 @@ struct b43_c32 { s32 i, q; };
 #define B43_PHYVER_TYPE_SHIFT		8
 #define B43_PHYVER_VERSION		0x00FF
 
+/* PHY writes need to be flushed if we reach limit */
+#define B43_MAX_WRITES_IN_ROW		24
+
 /**
  * enum b43_interference_mitigation - Interference Mitigation mode
  *
@@ -232,6 +235,9 @@ struct b43_phy {
 	/* PHY revision number. */
 	u8 rev;
 
+	/* Count writes since last read */
+	u8 writes_counter;
+
 	/* Radio versioning */
 	u16 radio_manuf;	/* Radio manufacturer */
 	u16 radio_ver;		/* Radio version */
-- 
1.6.3.3

