Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48718 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2GDALu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 20:11:50 -0400
Received: by wgbdr13 with SMTP id dr13so6793099wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 17:11:49 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: linux-wireless@vger.kernel.org, xose.vazquez@gmail.com,
	users@rt2x00.serialmonkey.com
Subject: [PATCH POC] wireless: rt2x00: rt2800: add support for RT5370G
Date: Wed,  4 Jul 2012 02:11:43 +0200
Message-Id: <1341360703-18029-1-git-send-email-xose.vazquez@gmail.com> (sfid-20120704_021230_404798_97D52C9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Proof of concept !! untested !! do not apply !!
I haven't the hardware to test it.

RT5370G has hardware RX antenna diversity like RT5390R.

based on 2012_03_22_RT5572_Linux_STA_v2.6.0.0_DPO

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    3 ++-
 drivers/net/wireless/rt2x00/rt2800lib.c |    8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index b483c23..fe62275 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -77,7 +77,8 @@
 #define REV_RT3090E			0x0211
 #define REV_RT3390E			0x0211
 #define REV_RT5390F			0x0502
-#define REV_RT5390R			0x1502
+#define REV_RT5370G			0x0503 /* hardware RX antenna diversity */
+#define REV_RT5390R			0x1502 /* hardware RX antenna diversity */
 
 /*
  * Signal information.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index dfc90d3..e27b203 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3363,8 +3363,9 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 			rt2800_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
 		}
 
-		/* This chip has hardware antenna diversity*/
-		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
+		/* These chips have hardware RX antenna diversity */
+		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R) ||
+			rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5370G)) {
 			rt2800_bbp_write(rt2x00dev, 150, 0); /* Disable Antenna Software OFDM */
 			rt2800_bbp_write(rt2x00dev, 151, 0); /* Disable Antenna Software CCK */
 			rt2800_bbp_write(rt2x00dev, 154, 0); /* Clear previously selected antenna */
@@ -4305,7 +4306,8 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00dev->default_ant.rx = ANTENNA_A;
 	}
 
-	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R) ||
+		rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5370G)) {
 		rt2x00dev->default_ant.tx = ANTENNA_HW_DIVERSITY; /* Unused */
 		rt2x00dev->default_ant.rx = ANTENNA_HW_DIVERSITY; /* Unused */
 	}
-- 
1.7.10.4

