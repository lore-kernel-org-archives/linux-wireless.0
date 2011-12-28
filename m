Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1494 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837Ab1L1A7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 19:59:52 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: John W Linville <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3/7] rt2x00: Convert big if-statements to switch-statements.
Date: Wed, 28 Dec 2011 01:53:20 +0100
Message-Id: <1325033604-26469-4-git-send-email-gwingerde@gmail.com> (sfid-20111228_020005_067419_CD26D721)
In-Reply-To: <1325033604-26469-3-git-send-email-gwingerde@gmail.com>
References: <1325033604-26469-1-git-send-email-gwingerde@gmail.com>
 <1325033604-26469-2-git-send-email-gwingerde@gmail.com>
 <1325033604-26469-3-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   44 ++++++++++++++++++------------
 1 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e5df380..5b0137c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1944,19 +1944,24 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		info->default_power2 = TXPOWER_A_TO_DEV(info->default_power2);
 	}
 
-	if (rt2x00_rf(rt2x00dev, RF2020) ||
-	    rt2x00_rf(rt2x00dev, RF3020) ||
-	    rt2x00_rf(rt2x00dev, RF3021) ||
-	    rt2x00_rf(rt2x00dev, RF3022) ||
-	    rt2x00_rf(rt2x00dev, RF3320))
+	switch (rt2x00dev->chip.rf) {
+	case RF2020:
+	case RF3020:
+	case RF3021:
+	case RF3022:
+	case RF3320:
 		rt2800_config_channel_rf3xxx(rt2x00dev, conf, rf, info);
-	else if (rt2x00_rf(rt2x00dev, RF3052))
+		break;
+	case RF3052:
 		rt2800_config_channel_rf3052(rt2x00dev, conf, rf, info);
-	else if (rt2x00_rf(rt2x00dev, RF5370) ||
-		 rt2x00_rf(rt2x00dev, RF5390))
+		break;
+	case RF5370:
+	case RF5390:
 		rt2800_config_channel_rf53xx(rt2x00dev, conf, rf, info);
-	else
+		break;
+	default:
 		rt2800_config_channel_rf2xxx(rt2x00dev, conf, rf, info);
+	}
 
 	/*
 	 * Change BBP settings
@@ -3932,15 +3937,18 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_chip(rt2x00dev, rt2x00_get_field32(reg, MAC_CSR0_CHIPSET),
 			value, rt2x00_get_field32(reg, MAC_CSR0_REVISION));
 
-	if (!rt2x00_rt(rt2x00dev, RT2860) &&
-	    !rt2x00_rt(rt2x00dev, RT2872) &&
-	    !rt2x00_rt(rt2x00dev, RT2883) &&
-	    !rt2x00_rt(rt2x00dev, RT3070) &&
-	    !rt2x00_rt(rt2x00dev, RT3071) &&
-	    !rt2x00_rt(rt2x00dev, RT3090) &&
-	    !rt2x00_rt(rt2x00dev, RT3390) &&
-	    !rt2x00_rt(rt2x00dev, RT3572) &&
-	    !rt2x00_rt(rt2x00dev, RT5390)) {
+	switch (rt2x00dev->chip.rt) {
+	case RT2860:
+	case RT2872:
+	case RT2883:
+	case RT3070:
+	case RT3071:
+	case RT3090:
+	case RT3390:
+	case RT3572:
+	case RT5390:
+		break;
+	default:
 		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
 		return -ENODEV;
 	}
-- 
1.7.7.4

