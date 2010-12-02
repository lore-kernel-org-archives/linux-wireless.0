Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50078 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab0LBXkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 18:40:11 -0500
Received: by ywl5 with SMTP id 5so4468770ywl.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 15:40:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikq7h3hwVBQBWv+Avhzc6KZLxRC3OkxjpbgwQ8M@mail.gmail.com>
References: <AANLkTim0L7e+RZ1v6B3+s_Z7pOZ6KAgvZ_tZEQJnMHET@mail.gmail.com> <AANLkTikq7h3hwVBQBWv+Avhzc6KZLxRC3OkxjpbgwQ8M@mail.gmail.com>
From: Matteo Croce <technoboy85@gmail.com>
Date: Fri, 3 Dec 2010 00:39:49 +0100
Message-ID: <AANLkTinY5Ook3Jk=P8KW34djuAzK1sVJgPds9mZkU4sk@mail.gmail.com>
Subject: Re: [PATCH]: ath9k: fix bug in tx power
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath9k driver subtracts 3 dBm to the txpower as with two radios the
signal power is doubled.
The resulting value is assigned in an u16 which overflows and makes
the card work at full power.

Signed-off-by: Matteo Croce <matteo@openwrt.org>

--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c	2010-12-02
22:39:58.982020001 +0100
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c	2010-12-03
00:36:23.637799002 +0100
@@ -1065,15 +1065,19 @@
 	case 1:
 		break;
 	case 2:
-		scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		if (scaledPower > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
+			scaledPower -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		else
+			scaledPower = 0;
 		break;
 	case 3:
-		scaledPower -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		if (scaledPower > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
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
