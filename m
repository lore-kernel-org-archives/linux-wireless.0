Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40562 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251Ab0LCBZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 20:25:29 -0500
Received: by gyb11 with SMTP id 11so4515823gyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 17:25:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101202235155.GN7399@tux>
References: <AANLkTim0L7e+RZ1v6B3+s_Z7pOZ6KAgvZ_tZEQJnMHET@mail.gmail.com>
 <AANLkTikq7h3hwVBQBWv+Avhzc6KZLxRC3OkxjpbgwQ8M@mail.gmail.com>
 <AANLkTinY5Ook3Jk=P8KW34djuAzK1sVJgPds9mZkU4sk@mail.gmail.com> <20101202235155.GN7399@tux>
From: Matteo Croce <technoboy85@gmail.com>
Date: Fri, 3 Dec 2010 02:25:08 +0100
Message-ID: <AANLkTi=vvytewRJt2it+tgdTSaT2tpVvCs77NjN71vX2@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH]: ath9k: fix bug in tx power
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath9k driver subtracts 3 dBm to the txpower as with two radios the
signal power is doubled.
The resulting value is assigned in an u16 which overflows and makes
the card work at full power.

Cc: stable@kernel.org
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
