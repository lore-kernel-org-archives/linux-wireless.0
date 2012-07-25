Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39488 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2GYVXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 17:23:43 -0400
Received: by wgbdr13 with SMTP id dr13so1159983wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2012 14:23:42 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] b43: add helper waiting for given value in radio reg
Date: Thu, 26 Jul 2012 00:07:37 +0200
Message-Id: <1343254059-4788-1-git-send-email-zajec5@gmail.com> (sfid-20120725_232347_319697_304D06EB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_common.c |   15 +++++++++++++++
 drivers/net/wireless/b43/phy_common.h |    6 ++++++
 drivers/net/wireless/b43/phy_n.c      |   12 +-----------
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index f627cef..f01676a 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -240,6 +240,21 @@ void b43_radio_maskset(struct b43_wldev *dev, u16 offset, u16 mask, u16 set)
 			  (b43_radio_read16(dev, offset) & mask) | set);
 }
 
+bool b43_radio_wait_value(struct b43_wldev *dev, u16 offset, u16 mask,
+			  u16 value, int delay, int timeout)
+{
+	u16 val;
+	int i;
+
+	for (i = 0; i < timeout; i += delay) {
+		val = b43_radio_read(dev, offset);
+		if ((val & mask) == value)
+			return true;
+		udelay(delay);
+	}
+	return false;
+}
+
 u16 b43_phy_read(struct b43_wldev *dev, u16 reg)
 {
 	assert_mac_suspended(dev);
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 9233b13..f1b9993 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -365,6 +365,12 @@ void b43_radio_set(struct b43_wldev *dev, u16 offset, u16 set);
 void b43_radio_maskset(struct b43_wldev *dev, u16 offset, u16 mask, u16 set);
 
 /**
+ * b43_radio_wait_value - Waits for a given value in masked register read
+ */
+bool b43_radio_wait_value(struct b43_wldev *dev, u16 offset, u16 mask,
+			  u16 value, int delay, int timeout);
+
+/**
  * b43_radio_lock - Lock firmware radio register access
  */
 void b43_radio_lock(struct b43_wldev *dev);
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index e49d847..0963d59 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -753,8 +753,6 @@ static void b43_radio_init2055_post(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy = dev->phy.n;
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
-	int i;
-	u16 val;
 	bool workaround = false;
 
 	if (sprom->revision < 4)
@@ -777,15 +775,7 @@ static void b43_radio_init2055_post(struct b43_wldev *dev)
 	b43_radio_set(dev, B2055_CAL_MISC, 0x1);
 	msleep(1);
 	b43_radio_set(dev, B2055_CAL_MISC, 0x40);
-	for (i = 0; i < 200; i++) {
-		val = b43_radio_read(dev, B2055_CAL_COUT2);
-		if (val & 0x80) {
-			i = 0;
-			break;
-		}
-		udelay(10);
-	}
-	if (i)
+	if (!b43_radio_wait_value(dev, B2055_CAL_COUT2, 0x80, 0x80, 10, 2000))
 		b43err(dev->wl, "radio post init timeout\n");
 	b43_radio_mask(dev, B2055_CAL_LPOCTL, 0xFF7F);
 	b43_switch_channel(dev, dev->phy.channel);
-- 
1.7.7

