Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36688 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1H1RUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 13:20:06 -0400
Received: by fxh19 with SMTP id 19so3802629fxh.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 10:20:04 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [ONE MORE][PATCH 4/3] b43: LCN-PHY: implement saving and restoring PHY & radio configuration
Date: Sun, 28 Aug 2011 19:59:28 +0200
Message-Id: <1314554368-7002-4-git-send-email-zajec5@gmail.com> (sfid-20110828_192022_459733_5BC90D97)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_lcn.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index 4839536..b617e1f 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -213,6 +213,39 @@ static void b43_phy_lcn_pre_radio_init(struct b43_wldev *dev)
 	/* TODO: more ops */
 }
 
+static void b43_phy_lcn_save_configsth_restore(struct b43_wldev *dev)
+{
+	u8 i;
+
+	u16 save_radio_regs[6][2] = {
+		{ 0x007, 0 }, { 0x0ff, 0 }, { 0x11f, 0 }, { 0x005, 0 },
+		{ 0x025, 0 }, { 0x112, 0 },
+	};
+	u16 save_phy_regs[14][2] = {
+		{ 0x503, 0 }, { 0x4a4, 0 }, { 0x4d0, 0 }, { 0x4d9, 0 },
+		{ 0x4da, 0 }, { 0x4a6, 0 }, { 0x938, 0 }, { 0x939, 0 },
+		{ 0x4d8, 0 }, { 0x4d0, 0 }, { 0x4d7, 0 }, { 0x4a5, 0 },
+		{ 0x40d, 0 }, { 0x4a2, 0 },
+	};
+	u16 save_radio_4a4;
+
+	for (i = 0; i < 6; i++)
+		save_radio_regs[i][1] = b43_radio_read(dev,
+						       save_radio_regs[i][0]);
+	for (i = 0; i < 14; i++)
+		save_phy_regs[i][1] = b43_phy_read(dev, save_phy_regs[i][0]);
+	save_radio_4a4 = b43_radio_read(dev, 0x4a4);
+
+	/* TODO: config sth */
+
+	for (i = 0; i < 6; i++)
+		b43_radio_write(dev, save_radio_regs[i][0],
+				save_radio_regs[i][1]);
+	for (i = 0; i < 14; i++)
+		b43_phy_write(dev, save_phy_regs[i][0], save_phy_regs[i][1]);
+	b43_radio_write(dev, 0x4a4, save_radio_4a4);
+}
+
 /**************************************************
  * Channel switching ops.
  **************************************************/
@@ -297,6 +330,8 @@ static int b43_phy_lcn_op_init(struct b43_wldev *dev)
 	else
 		B43_WARN_ON(1);
 
+	b43_phy_lcn_save_configsth_restore(dev);
+
 	return 0;
 }
 
-- 
1.7.3.4

