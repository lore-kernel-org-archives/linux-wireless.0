Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:43855 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbeDEMWh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 08:22:37 -0400
Received: by mail-wr0-f194.google.com with SMTP id p53so28061830wrc.10
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2018 05:22:36 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        wireless newbie <wnewbie72@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux wireless ml <linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless: rt2x00: rt2800: add antenna diversity for RT5370G
Date: Thu,  5 Apr 2018 14:22:32 +0200
Message-Id: <20180405122232.1694-1-xose.vazquez@gmail.com> (sfid-20180405_142240_977126_7B411586)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RT5370G has hardware RX antenna diversity like RT5390R.
Based on DPO_RT5572_LinuxSTA_2.6.1.3_20121022.tar.bz2 manufacturer driver:
https://d86o2zu8ugzlg.cloudfront.net/mediatek-craft/drivers/DPO_RT5572_LinuxSTA_2.6.1.3_20121022.tar.bz2

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: wireless newbie <wnewbie72@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux wireless ml <linux-wireless@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h    | 1 +
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index 6a8c93fb6a43..7a133e94b1bf 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -94,6 +94,7 @@
 #define REV_RT3390E			0x0211
 #define REV_RT3593E			0x0211
 #define REV_RT5390F			0x0502
+#define REV_RT5370G			0x0503
 #define REV_RT5390R			0x1502
 #define REV_RT5592C			0x0221
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 429d07b651dd..e827dc522580 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -6220,8 +6220,9 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
 	}
 
-	/* This chip has hardware antenna diversity*/
-	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
+	/* These chips have hardware RX antenna diversity */
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R) ||
+	    rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5370G)) {
 		rt2800_bbp_write(rt2x00dev, 150, 0); /* Disable Antenna Software OFDM */
 		rt2800_bbp_write(rt2x00dev, 151, 0); /* Disable Antenna Software CCK */
 		rt2800_bbp_write(rt2x00dev, 154, 0); /* Clear previously selected antenna */
@@ -8748,7 +8749,9 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00dev->default_ant.rx = ANTENNA_A;
 	}
 
-	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
+	/* These chips have hardware RX antenna diversity */
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R) ||
+	    rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5370G)) {
 		rt2x00dev->default_ant.tx = ANTENNA_HW_DIVERSITY; /* Unused */
 		rt2x00dev->default_ant.rx = ANTENNA_HW_DIVERSITY; /* Unused */
 	}
-- 
2.14.3
