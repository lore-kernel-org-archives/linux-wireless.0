Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:60936 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab3EGUEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 16:04:42 -0400
Received: by mail-we0-f181.google.com with SMTP id q55so967908wes.12
        for <linux-wireless@vger.kernel.org>; Tue, 07 May 2013 13:04:41 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3.10-rc] wireless: rt2x00: rt2800: fix hardware antenna diversity for RT5370G
Date: Tue,  7 May 2013 22:03:30 +0200
Message-Id: <1367957010-9496-1-git-send-email-xose.vazquez@gmail.com> (sfid-20130507_220446_647345_380731E3)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RT5370G has hardware RX antenna diversity like RT5390R.

based on 2012_03_22_RT5572_Linux_STA_v2.6.0.0_DPO

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Tested-by: wnewbie72@gmail.com
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    | 3 ++-
 drivers/net/wireless/rt2x00/rt2800lib.c | 8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index a7630d5..6e84eee 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -89,7 +89,8 @@
 #define REV_RT3090E			0x0211
 #define REV_RT3390E			0x0211
 #define REV_RT5390F			0x0502
-#define REV_RT5390R			0x1502
+#define REV_RT5370G			0x0503 /* hardware RX antenna diversity */
+#define REV_RT5390R			0x1502 /* hardware RX antenna diversity */
 #define REV_RT5592C			0x0221
 
 #define DEFAULT_RSSI_OFFSET		120
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index b52d70c..e202ec7 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4311,8 +4311,9 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 			rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
 		}
 
-		/* This chip has hardware antenna diversity*/
-		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
+		/* These chips have hardware RX antenna diversity */
+		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R) ||
+			rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5370G)) {
 			rt2800_bbp_write(rt2x00dev, 150, 0); /* Disable Antenna Software OFDM */
 			rt2800_bbp_write(rt2x00dev, 151, 0); /* Disable Antenna Software CCK */
 			rt2800_bbp_write(rt2x00dev, 154, 0); /* Clear previously selected antenna */
@@ -5554,7 +5555,8 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00dev->default_ant.rx = ANTENNA_A;
 	}
 
-	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R) ||
+		rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5370G)) {
 		rt2x00dev->default_ant.tx = ANTENNA_HW_DIVERSITY; /* Unused */
 		rt2x00dev->default_ant.rx = ANTENNA_HW_DIVERSITY; /* Unused */
 	}
-- 
1.7.11.7

