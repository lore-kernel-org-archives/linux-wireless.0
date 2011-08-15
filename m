Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42349 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1HOQLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 12:11:50 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so3673111fxh.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2011 09:11:49 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: LCN-PHY: init 0x2064 radio
Date: Mon, 15 Aug 2011 18:50:56 +0200
Message-Id: <1313427056-3755-2-git-send-email-zajec5@gmail.com> (sfid-20110815_181154_303032_20C644D4)
In-Reply-To: <1313427056-3755-1-git-send-email-zajec5@gmail.com>
References: <1313427056-3755-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
I'm slowly going to the end of translating my RE dumps into code.

Sets come from:
 phy_read(0x04eb) -> 0x0000
phy_write(0x04eb) <- 0x0002
 phy_read(0x04eb) -> 0x0000
phy_write(0x04eb) <- 0x0000
 phy_read(0x046a) -> 0x0000
phy_write(0x046a) <- 0x0019

 radio_read(0x005b) -> 0x0000
radio_write(0x005b) <- 0x0000
 radio_read(0x0004) -> 0x0000
radio_write(0x0004) <- 0x0040
 radio_read(0x0120) -> 0x0000
radio_write(0x0120) <- 0x0010
 radio_read(0x0078) -> 0x0000
radio_write(0x0078) <- 0x0080
 radio_read(0x0129) -> 0x0000
radio_write(0x0129) <- 0x0002
 radio_read(0x0057) -> 0x0000
radio_write(0x0057) <- 0x0001
 radio_read(0x005b) -> 0x0000
radio_write(0x005b) <- 0x0002

 radio_read(0x005b) -> 0x0000
radio_write(0x005b) <- 0x0000
 radio_read(0x0057) -> 0x0000
radio_write(0x0057) <- 0x0000

 radio_read(0x0057) -> 0x0000
radio_write(0x0057) <- 0x0000

Masks from:
 phy_read(0x04eb) -> 0xffff
phy_write(0x04eb) <- 0xfffa
 phy_read(0x04eb) -> 0xffff
phy_write(0x04eb) <- 0xfe3f
 phy_read(0x046a) -> 0xffff
phy_write(0x046a) <- 0x0019

 radio_read(0x005b) -> 0xffff
radio_write(0x005b) <- 0x00fd
 radio_read(0x0004) -> 0xffff
radio_write(0x0004) <- 0xffff
 radio_read(0x0120) -> 0xffff
radio_write(0x0120) <- 0xffff
 radio_read(0x0078) -> 0xffff
radio_write(0x0078) <- 0xffff
 radio_read(0x0129) -> 0xffff
radio_write(0x0129) <- 0xffff
 radio_read(0x0057) -> 0xffff
radio_write(0x0057) <- 0xffff
 radio_read(0x005b) -> 0xffff
radio_write(0x005b) <- 0xffff

 radio_read(0x005b) -> 0xffff
radio_write(0x005b) <- 0x00fd
 radio_read(0x0057) -> 0xffff
radio_write(0x0057) <- 0x00fe

 radio_read(0x0057) -> 0xffff
radio_write(0x0057) <- 0x00fd
---
 drivers/net/wireless/b43/phy_lcn.c |   54 ++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index 604a3a6..4b2cd6d 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -28,6 +28,55 @@
 #include "main.h"
 
 /**************************************************
+ * Radio 2064.
+ **************************************************/
+
+static void b43_radio_2064_init(struct b43_wldev *dev)
+{
+	b43_radio_write(dev, 0x09c, 0x0020);
+	b43_radio_write(dev, 0x105, 0x0008);
+	b43_radio_write(dev, 0x032, 0x0062);
+	b43_radio_write(dev, 0x033, 0x0019);
+	b43_radio_write(dev, 0x090, 0x0010);
+	b43_radio_write(dev, 0x010, 0x0000);
+	b43_radio_write(dev, 0x060, 0x007f);
+	b43_radio_write(dev, 0x061, 0x0072);
+	b43_radio_write(dev, 0x062, 0x007f);
+	b43_radio_write(dev, 0x01d, 0x0002);
+	b43_radio_write(dev, 0x01e, 0x0006);
+
+	b43_phy_write(dev, 0x4ea, 0x4688);
+	b43_phy_maskset(dev, 0x4eb, ~0x7, 0x2);
+	b43_phy_mask(dev, 0x4eb, ~0x01c0);
+	b43_phy_maskset(dev, 0x4eb, 0xff00, 0x19);
+
+	b43_lcntab_write(dev, B43_LCNTAB16(0x00, 0x55), 0);
+
+	b43_radio_mask(dev, 0x05b, (u16) ~0xff02);
+	b43_radio_set(dev, 0x004, 0x40);
+	b43_radio_set(dev, 0x120, 0x10);
+	b43_radio_set(dev, 0x078, 0x80);
+	b43_radio_set(dev, 0x129, 0x2);
+	b43_radio_set(dev, 0x057, 0x1);
+	b43_radio_set(dev, 0x05b, 0x2);
+
+	/* TODO: wait for some bit to be set */
+	b43_radio_read(dev, 0x05c);
+
+	b43_radio_mask(dev, 0x05b, (u16) ~0xff02);
+	b43_radio_mask(dev, 0x057, (u16) ~0xff01);
+
+	b43_phy_write(dev, 0x933, 0x2d6b);
+	b43_phy_write(dev, 0x934, 0x2d6b);
+	b43_phy_write(dev, 0x935, 0x2d6b);
+	b43_phy_write(dev, 0x936, 0x2d6b);
+	b43_phy_write(dev, 0x937, 0x016b);
+
+	b43_radio_mask(dev, 0x057, (u16) ~0xff02);
+	b43_radio_write(dev, 0x0c2, 0x006f);
+}
+
+/**************************************************
  * Various PHY ops
  **************************************************/
 
@@ -125,6 +174,11 @@ static int b43_phy_lcn_op_init(struct b43_wldev *dev)
 
 	b43_phy_lcn_clear_0x07_table(dev);
 
+	if (dev->phy.radio_ver == 0x2064)
+		b43_radio_2064_init(dev);
+	else
+		B43_WARN_ON(1);
+
 	return 0;
 }
 
-- 
1.7.3.4

