Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54317 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab0LBXZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 18:25:16 -0500
Received: by gxk1 with SMTP id 1so1520532gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 15:25:16 -0800 (PST)
MIME-Version: 1.0
From: Matteo Croce <technoboy85@gmail.com>
Date: Fri, 3 Dec 2010 00:24:55 +0100
Message-ID: <AANLkTim0L7e+RZ1v6B3+s_Z7pOZ6KAgvZ_tZEQJnMHET@mail.gmail.com>
Subject: [PATCH]: ath9k: fix bug in tx power
To: Luis R Rodriguez <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath9k driver subtracts 3 dBm to the txpower as with two radios the
signal power is doubled.
The resulting value is assigned in an u16 which overflows and makes
the card to work at full power.

Signed-off-by: Matteo Croce <matteo@openwrt.org>

--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c	2010-12-02
22:39:58.982020001 +0100
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c	2010-12-02
23:05:43.662020001 +0100
@@ -1065,15 +1065,19 @@
 	case 1:
 		break;
 	case 2:
-		scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		if(scaledPower > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
+			scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		else
+			scaledPower = 0;
 		break;
 	case 3:
-		scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		if(scaledPower > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
+			scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		else
+			scaledPower = 0;
 		break;
 	}

-	scaledPower = max((u16)0, scaledPower);
-
 	if (IS_CHAN_2GHZ(chan)) {
 		numCtlModes = ARRAY_SIZE(ctlModesFor11g) -
 			SUB_NUM_CTL_MODES_AT_2G_40;


-- 
Matteo Croce
OpenWrt developer
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 KAMIKAZE (bleeding edge) ------------------
  * 10 oz Vodka       Shake well with ice and strain
  * 10 oz Triple sec  mixture into 10 shot glasses.
  * 10 oz lime juice  Salute!
 ---------------------------------------------------
