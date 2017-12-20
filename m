Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35201 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755636AbdLTRjk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Dec 2017 12:39:40 -0500
Received: by mail-wm0-f65.google.com with SMTP id f9so11331543wmh.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Dec 2017 09:39:39 -0800 (PST)
Date: Wed, 20 Dec 2017 18:39:34 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        nbd@nbd.name
Subject: MT7630 support
Message-ID: <alpine.LNX.2.21.99.1712201832120.21664@localhost.localdomain> (sfid-20171220_183945_854262_776AFF32)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello guys.
So, at some point I felt crazy enough to try to add support for the MT7630 chipset to the rt2xx ralink wireless drivers.
I expected this to be a little bit of a challenge.
I did begin adding some code paths around, reading from the mixed-up drivers here:
https://github.com/neurobin/MT7630E
(thanks a lot to the guys who are working on this, and who worked on this).
and working on the kernel's git rt2xx tree. I am sending a raw diff that will for sure not compile. I am asking for guidance and help in going on.
I tried to integrate the code as cleanly as possible, respecting the current style of the driver. Still, register initializzation functions are hard to read.
Any help would be greatly apreciated.

Note: on the diff you will find code marked like this:
**RTMPEnableRxTx(rt2x00dev);
This means something like - "I know this code shouldn't be there and anyway I plan to get rid of it in case".
this has been manual work; and it's incomplete.
Enrico

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index d2c289446c00..89875b6e03c8 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5185,14 +5185,16 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)

  	rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, 0x00000000);

-	reg = rt2800_register_read(rt2x00dev, BCN_TIME_CFG);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL, 1600);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TX_TIME_COMPENSATE, 0);
-	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+	if (!rt2x00_rt(rt2x00dev, MT7630)) {
+		reg = rt2800_register_read(rt2x00dev, BCN_TIME_CFG);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_INTERVAL, 1600);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_SYNC, 0);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
+		rt2x00_set_field32(&reg, BCN_TIME_CFG_TX_TIME_COMPENSATE, 0);
+		rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
+	}

  	rt2800_config_filter(rt2x00dev, FIF_ALLMULTI);

@@ -5237,6 +5239,10 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
  		rt2800_register_write(rt2x00dev, PLL_CTRL, reg);
  	}

+	if (rt2x00_rt(rt2x00dev, MT7630)) {
+		rt2800_register_write(rt2x00dev, TX_MAX_PCNT, 0x1fbf1f1f);
+	}
+
  	if (rt2x00_rt(rt2x00dev, RT3071) ||
  	    rt2x00_rt(rt2x00dev, RT3090) ||
  	    rt2x00_rt(rt2x00dev, RT3290) ||
@@ -5346,11 +5352,15 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
  	rt2x00_set_field32(&reg, TX_LINK_CFG_REMOTE_MFS, 0);
  	rt2800_register_write(rt2x00dev, TX_LINK_CFG, reg);

-	reg = rt2800_register_read(rt2x00dev, TX_TIMEOUT_CFG);
-	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_MPDU_LIFETIME, 9);
-	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_RX_ACK_TIMEOUT, 32);
-	rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_TX_OP_TIMEOUT, 10);
-	rt2800_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
+	if (rt2x00_rt(rt2x00dev, MT7630))
+		rt2800_register_write(rt2x00dev, TX_TIMEOUT_CFG, 0x000a2090);
+	else {
+		reg = rt2800_register_read(rt2x00dev, TX_TIMEOUT_CFG);
+		rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_MPDU_LIFETIME, 9);
+		rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_RX_ACK_TIMEOUT, 32);
+		rt2x00_set_field32(&reg, TX_TIMEOUT_CFG_TX_OP_TIMEOUT, 10);
+		rt2800_register_write(rt2x00dev, TX_TIMEOUT_CFG, reg);
+	}

  	reg = rt2800_register_read(rt2x00dev, MAX_LEN_CFG);
  	rt2x00_set_field32(&reg, MAX_LEN_CFG_MAX_MPDU, AGGREGATION_SIZE);
@@ -5378,7 +5388,61 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
  	rt2x00_set_field32(&reg, LED_CFG_LED_POLAR, 1);
  	rt2800_register_write(rt2x00dev, LED_CFG, reg);

-	rt2800_register_write(rt2x00dev, PBF_MAX_PCNT, 0x1f3fbf9f);
+	if (!rt2x00_rt(rt2x00dev, MT7630))
+		rt2800_register_write(rt2x00dev, PBF_MAX_PCNT, 0x1f3fbf9f);
+	else {
+		reg = rt2800_register_read(rt2x00dev, MM20_PROT_CFG);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_RATE, 0x4004);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_CTRL, 0);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_NAV_SHORT, 1);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_CCK, 1);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM20, 1);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF20, 1);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF40, 0);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_RTS_TH_EN, 0);
+		rt2800_register_write(rt2x00dev, MM20_PROT_CFG, reg);
+
+		reg = rt2800_register_read(rt2x00dev, MM40_PROT_CFG);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_RATE, 0x4084);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 0);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_NAV_SHORT, 1);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_CCK, 1);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM20, 1);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF20, 1);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_RTS_TH_EN, 0);
+		rt2800_register_write(rt2x00dev, MM40_PROT_CFG, reg);
+
+		reg = rt2800_register_read(rt2x00dev, MM20_PROT_CFG);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_RATE, 0x4004);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_CTRL, 0);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_PROTECT_NAV_SHORT, 1);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_CCK, 1);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM20, 1);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_MM40, 0);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF20, 1);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_TX_OP_ALLOW_GF40, 0);
+		rt2x00_set_field32(&reg, MM20_PROT_CFG_RTS_TH_EN, 0);
+		rt2800_register_write(rt2x00dev, MM20_PROT_CFG, reg);
+
+		reg = rt2800_register_read(rt2x00dev, MM40_PROT_CFG);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_RATE, 0x4084);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 0);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_NAV_SHORT, 1);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_CCK, 1);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_OFDM, 1);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM20, 1);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_MM40, 1);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF20, 1);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_TX_OP_ALLOW_GF40, 1);
+		rt2x00_set_field32(&reg, MM40_PROT_CFG_RTS_TH_EN, 0);
+		rt2800_register_write(rt2x00dev, MM40_PROT_CFG, reg);
+	}

  	reg = rt2800_register_read(rt2x00dev, TX_RTY_CFG);
  	rt2x00_set_field32(&reg, TX_RTY_CFG_SHORT_RTY_LIMIT, 2);
@@ -5497,28 +5561,35 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
  	 * The legacy driver also sets TXOP_CTRL_CFG_RESERVED_TRUN_EN to 1
  	 * although it is reserved.
  	 */
-	reg = rt2800_register_read(rt2x00dev, TXOP_CTRL_CFG);
-	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_TIMEOUT_TRUN_EN, 1);
-	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_AC_TRUN_EN, 1);
-	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_TXRATEGRP_TRUN_EN, 1);
-	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_USER_MODE_TRUN_EN, 1);
+	if (rt2x00_rt(rt2x00dev, MT7630)) {
+		rt2800_register_write(rt2x00dev, TXOP_CTRL_CFG, 0x583f);
+	} else {
+		reg = rt2800_register_read(rt2x00dev, TXOP_CTRL_CFG);
+		rt2x00_set_field32(&reg, TXOP_CTRL_CFG_TIMEOUT_TRUN_EN, 1);
+		rt2x00_set_field32(&reg, TXOP_CTRL_CFG_AC_TRUN_EN, 1);
+		rt2x00_set_field32(&reg, TXOP_CTRL_CFG_TXRATEGRP_TRUN_EN, 1);
+		rt2x00_set_field32(&reg, TXOP_CTRL_CFG_USER_MODE_TRUN_EN, 1);
  	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_MIMO_PS_TRUN_EN, 1);
-	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_RESERVED_TRUN_EN, 1);
-	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_LSIG_TXOP_EN, 0);
-	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_EXT_CCA_EN, 0);
-	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_EXT_CCA_DLY, 88);
-	rt2x00_set_field32(&reg, TXOP_CTRL_CFG_EXT_CWMIN, 0);
-	rt2800_register_write(rt2x00dev, TXOP_CTRL_CFG, reg);
-
+		rt2x00_set_field32(&reg, TXOP_CTRL_CFG_RESERVED_TRUN_EN, 1);
+		rt2x00_set_field32(&reg, TXOP_CTRL_CFG_LSIG_TXOP_EN, 0);
+		rt2x00_set_field32(&reg, TXOP_CTRL_CFG_EXT_CCA_EN, 0);
+		rt2x00_set_field32(&reg, TXOP_CTRL_CFG_EXT_CCA_DLY, 88);
+		rt2x00_set_field32(&reg, TXOP_CTRL_CFG_EXT_CWMIN, 0);
+		rt2800_register_write(rt2x00dev, TXOP_CTRL_CFG, reg);
+	}
  	reg = rt2x00_rt(rt2x00dev, RT5592) ? 0x00000082 : 0x00000002;
  	rt2800_register_write(rt2x00dev, TXOP_HLDR_ET, reg);

-	reg = rt2800_register_read(rt2x00dev, TX_RTS_CFG);
-	rt2x00_set_field32(&reg, TX_RTS_CFG_AUTO_RTS_RETRY_LIMIT, 7);
-	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES,
-			   IEEE80211_MAX_RTS_THRESHOLD);
-	rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_FBK_EN, 1);
-	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
+	if (rt2x00_rt(rt2x00dev, MT7630))
+		rt2800_register_write(rt2x00dev, TX_RTS_CFG, 0x00092b20);
+	else {
+		reg = rt2800_register_read(rt2x00dev, TX_RTS_CFG);
+		rt2x00_set_field32(&reg, TX_RTS_CFG_AUTO_RTS_RETRY_LIMIT, 7);
+		rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_THRES,
+			IEEE80211_MAX_RTS_THRESHOLD);
+		rt2x00_set_field32(&reg, TX_RTS_CFG_RTS_FBK_EN, 1);
+		rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
+	}

  	rt2800_register_write(rt2x00dev, EXP_ACK_TIME, 0x002400ca);

@@ -5537,84 +5608,104 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
  	rt2x00_set_field32(&reg, XIFS_TIME_CFG_BB_RXEND_ENABLE, 1);
  	rt2800_register_write(rt2x00dev, XIFS_TIME_CFG, reg);

-	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
+	if (rt2x00_rt(rt2x00dev, MT7630)) {
+		rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000000);
+		rt2800_register_write(rt2x00dev, WMM_AIFSN_CFG, 0x00002273);
+		rt2800_register_write(rt2x00dev, WMM_CWMIN_CFG, 0x00002344);
+		rt2800_register_write(rt2x00dev, WMM_CWMAX_CFG, 0x000034aa);
+	} else
+		rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);

  	/*
  	 * ASIC will keep garbage value after boot, clear encryption keys.
  	 */
-	for (i = 0; i < 4; i++)
-		rt2800_register_write(rt2x00dev,
-					 SHARED_KEY_MODE_ENTRY(i), 0);
+	if (!rt2x00_rt(rt2x00dev, MT7630)) {
+		for (i = 0; i < 4; i++)
+			rt2800_register_write(rt2x00dev,
+						 SHARED_KEY_MODE_ENTRY(i), 0);

-	for (i = 0; i < 256; i++) {
-		rt2800_config_wcid(rt2x00dev, NULL, i);
-		rt2800_delete_wcid_attr(rt2x00dev, i);
-		rt2800_register_write(rt2x00dev, MAC_IVEIV_ENTRY(i), 0);
-	}
+		for (i = 0; i < 256; i++) {
+			rt2800_config_wcid(rt2x00dev, NULL, i);
+			rt2800_delete_wcid_attr(rt2x00dev, i);
+			rt2800_register_write(rt2x00dev, MAC_IVEIV_ENTRY(i), 0);
+		}
+	} else {
+		for (i = 0; i < 4; i++)
+			rt2800_register_write(rt2x00dev,
+						 SHARED_KEY_MODE_ENTRY_7630(i), 0);
+
+		for (i = 0; i < 256; i++) {
+			rt2800_config_wcid(rt2x00dev, NULL, i);
+			rt2800_delete_wcid_attr(rt2x00dev, i);
+			rt2800_register_write(rt2x00dev, MAC_IVEIV_ENTRY_7630(i), 0);
+		}

-	/*
-	 * Clear all beacons
-	 */
-	for (i = 0; i < 8; i++)
-		rt2800_clear_beacon_register(rt2x00dev, i);
+		/*
+		 * Clear all beacons
+		 */
+		for (i = 0; i < 8; i++)
+			rt2800_clear_beacon_register(rt2x00dev, i);
+	}

  	if (rt2x00_is_usb(rt2x00dev)) {
  		reg = rt2800_register_read(rt2x00dev, US_CYC_CNT);
  		rt2x00_set_field32(&reg, US_CYC_CNT_CLOCK_CYCLE, 30);
  		rt2800_register_write(rt2x00dev, US_CYC_CNT, reg);
-	} else if (rt2x00_is_pcie(rt2x00dev)) {
+	} else if (rt2x00_is_pcie(rt2x00dev) && (!rt2x00_rt(rt2x00dev, MT7630)) ) {
  		reg = rt2800_register_read(rt2x00dev, US_CYC_CNT);
  		rt2x00_set_field32(&reg, US_CYC_CNT_CLOCK_CYCLE, 125);
  		rt2800_register_write(rt2x00dev, US_CYC_CNT, reg);
  	}

-	reg = rt2800_register_read(rt2x00dev, HT_FBK_CFG0);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS0FBK, 0);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS1FBK, 0);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS2FBK, 1);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS3FBK, 2);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS4FBK, 3);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS5FBK, 4);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS6FBK, 5);
-	rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS7FBK, 6);
-	rt2800_register_write(rt2x00dev, HT_FBK_CFG0, reg);
-
-	reg = rt2800_register_read(rt2x00dev, HT_FBK_CFG1);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS8FBK, 8);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS9FBK, 8);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS10FBK, 9);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS11FBK, 10);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS12FBK, 11);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS13FBK, 12);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS14FBK, 13);
-	rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS15FBK, 14);
-	rt2800_register_write(rt2x00dev, HT_FBK_CFG1, reg);
-
-	reg = rt2800_register_read(rt2x00dev, LG_FBK_CFG0);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS0FBK, 8);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS1FBK, 8);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS2FBK, 9);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS3FBK, 10);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS4FBK, 11);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS5FBK, 12);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS6FBK, 13);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS7FBK, 14);
-	rt2800_register_write(rt2x00dev, LG_FBK_CFG0, reg);
-
-	reg = rt2800_register_read(rt2x00dev, LG_FBK_CFG1);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS0FBK, 0);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS1FBK, 0);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS2FBK, 1);
-	rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS3FBK, 2);
-	rt2800_register_write(rt2x00dev, LG_FBK_CFG1, reg);
+	if (!rt2x00_rt(rt2x00dev, MT7630)) {
+		reg = rt2800_register_read(rt2x00dev, HT_FBK_CFG0);
+		rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS0FBK, 0);
+		rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS1FBK, 0);
+		rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS2FBK, 1);
+		rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS3FBK, 2);
+		rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS4FBK, 3);
+		rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS5FBK, 4);
+		rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS6FBK, 5);
+		rt2x00_set_field32(&reg, HT_FBK_CFG0_HTMCS7FBK, 6);
+		rt2800_register_write(rt2x00dev, HT_FBK_CFG0, reg);
+
+		reg = rt2800_register_read(rt2x00dev, HT_FBK_CFG1);
+		rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS8FBK, 8);
+		rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS9FBK, 8);
+		rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS10FBK, 9);
+		rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS11FBK, 10);
+		rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS12FBK, 11);
+		rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS13FBK, 12);
+		rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS14FBK, 13);
+		rt2x00_set_field32(&reg, HT_FBK_CFG1_HTMCS15FBK, 14);
+		rt2800_register_write(rt2x00dev, HT_FBK_CFG1, reg);
+
+		reg = rt2800_register_read(rt2x00dev, LG_FBK_CFG0);
+		rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS0FBK, 8);
+		rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS1FBK, 8);
+		rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS2FBK, 9);
+		rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS3FBK, 10);
+		rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS4FBK, 11);
+		rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS5FBK, 12);
+		rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS6FBK, 13);
+		rt2x00_set_field32(&reg, LG_FBK_CFG0_OFDMMCS7FBK, 14);
+		rt2800_register_write(rt2x00dev, LG_FBK_CFG0, reg);
+
+		reg = rt2800_register_read(rt2x00dev, LG_FBK_CFG1);
+		rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS0FBK, 0);
+		rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS1FBK, 0);
+		rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS2FBK, 1);
+		rt2x00_set_field32(&reg, LG_FBK_CFG0_CCKMCS3FBK, 2);
+		rt2800_register_write(rt2x00dev, LG_FBK_CFG1, reg);

-	/*
-	 * Do not force the BA window size, we use the TXWI to set it
-	 */
-	reg = rt2800_register_read(rt2x00dev, AMPDU_BA_WINSIZE);
-	rt2x00_set_field32(&reg, AMPDU_BA_WINSIZE_FORCE_WINSIZE_ENABLE, 0);
-	rt2x00_set_field32(&reg, AMPDU_BA_WINSIZE_FORCE_WINSIZE, 0);
-	rt2800_register_write(rt2x00dev, AMPDU_BA_WINSIZE, reg);
+		/*
+		 * Do not force the BA window size, we use the TXWI to set it
+		 */
+		reg = rt2800_register_read(rt2x00dev, AMPDU_BA_WINSIZE);
+		rt2x00_set_field32(&reg, AMPDU_BA_WINSIZE_FORCE_WINSIZE_ENABLE, 0);
+		rt2x00_set_field32(&reg, AMPDU_BA_WINSIZE_FORCE_WINSIZE, 0);
+		rt2800_register_write(rt2x00dev, AMPDU_BA_WINSIZE, reg);
+	}

  	/*
  	 * We must clear the error counters.
@@ -5631,20 +5722,61 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
  	/*
  	 * Setup leadtime for pre tbtt interrupt to 6ms
  	 */
-	reg = rt2800_register_read(rt2x00dev, INT_TIMER_CFG);
-	rt2x00_set_field32(&reg, INT_TIMER_CFG_PRE_TBTT_TIMER, 6 << 4);
-	rt2800_register_write(rt2x00dev, INT_TIMER_CFG, reg);
+	if (!rt2x00_rt(rt2x00dev, MT7630)) {
+		reg = rt2800_register_read(rt2x00dev, INT_TIMER_CFG);
+		rt2x00_set_field32(&reg, INT_TIMER_CFG_PRE_TBTT_TIMER, 6 << 4);
+		rt2800_register_write(rt2x00dev, INT_TIMER_CFG, reg);

-	/*
-	 * Set up channel statistics timer
-	 */
-	reg = rt2800_register_read(rt2x00dev, CH_TIME_CFG);
-	rt2x00_set_field32(&reg, CH_TIME_CFG_EIFS_BUSY, 1);
-	rt2x00_set_field32(&reg, CH_TIME_CFG_NAV_BUSY, 1);
-	rt2x00_set_field32(&reg, CH_TIME_CFG_RX_BUSY, 1);
-	rt2x00_set_field32(&reg, CH_TIME_CFG_TX_BUSY, 1);
-	rt2x00_set_field32(&reg, CH_TIME_CFG_TMR_EN, 1);
-	rt2800_register_write(rt2x00dev, CH_TIME_CFG, reg);
+		/*
+		 * Set up channel statistics timer
+		 */
+		reg = rt2800_register_read(rt2x00dev, CH_TIME_CFG);
+		rt2x00_set_field32(&reg, CH_TIME_CFG_EIFS_BUSY, 1);
+		rt2x00_set_field32(&reg, CH_TIME_CFG_NAV_BUSY, 1);
+		rt2x00_set_field32(&reg, CH_TIME_CFG_RX_BUSY, 1);
+		rt2x00_set_field32(&reg, CH_TIME_CFG_TX_BUSY, 1);
+		rt2x00_set_field32(&reg, CH_TIME_CFG_TMR_EN, 1);
+		rt2800_register_write(rt2x00dev, CH_TIME_CFG, reg);
+	} else {
+		rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00080c00);
+		rt2800_register_write(rt2x00dev, PBF_CFG_7630, 0x77723c1f);
+		rt2800_register_write(rt2x00dev, FCE_PSE_CTRL, 0x00000001);
+		rt2800_register_write(rt2x00dev, AMPDU_MAX_LEN_20M1S, 0xBAA99887);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000600);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
+		rt2800_register_write(rt2x00dev, 0xa44, 0x00000000);
+		rt2800_register_write(rt2x00dev, HEADER_TRANS_CTRL_REG, 0x00000000);
+		rt2800_register_write(rt2x00dev, TSO_CTRL, 0x00000000);
+		rt2800_register_write(rt2x00dev, BB_PA_MODE_CFG1, 0x00500055);
+		rt2800_register_write(rt2x00dev, RF_PA_MODE_CFG1, 0x00500055);
+		rt2800_register_write(rt2x00dev, TX_ALC_CFG_0, 0x2F2F000C);
+		rt2800_register_write(rt2x00dev, TX0_BB_GAIN_ATTEN, 0x00000000);
+		rt2800_register_write(rt2x00dev, TX0_RF_GAIN_CORR, 0x01010101);
+		rt2800_register_write(rt2x00dev, TX_PWR_CFG_0, 0x3A3A3A3A);
+		rt2800_register_write(rt2x00dev, TX_PWR_CFG_1, 0x3A3A3A3A);
+		rt2800_register_write(rt2x00dev, TX_PWR_CFG_2, 0x3A3A3A3A);
+		rt2800_register_write(rt2x00dev, TX_PWR_CFG_3, 0x3A3A3A3A);
+		rt2800_register_write(rt2x00dev, TX_PWR_CFG_4, 0x3A3A3A3A);
+		rt2800_register_write(rt2x00dev, TX_PWR_CFG_7, 0x3A3A3A3A);
+		rt2800_register_write(rt2x00dev, TX_PWR_CFG_8, 0x0000003A);
+		rt2800_register_write(rt2x00dev, TX_PWR_CFG_9, 0x0000003A);
+		rt2800_register_write(rt2x00dev, 0x150C, 0x00000002);
+
+		reg = rt2800_register_read(rt2x00dev, MAC_SYS_CTRL);
+		rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 0);
+		rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_BBP, 0);
+		rt2800_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+
+		reg = rt2800_register_read(rt2x00dev, EXT_CCA_CFG);
+		reg |= (0x0000F000);
+		rt2800_register_write(rt2x00dev, EXT_CCA_CFG, reg);
+
+		/* Init FCE */
+		reg = rt2800_register_read(rt2x00dev, FCE_L2_STUFF);
+		reg &= ~(0x00000010);
+		rt2800_register_write(rt2x00dev, FCE_L2_STUFF, reg);
+	}

  	return 0;
  }
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index 1123e2bed803..cd43f435bca8 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -530,22 +530,45 @@ void rt2800mmio_toggle_irq(struct rt2x00_dev *rt2x00dev,
  	 * should clear the register to assure a clean state.
  	 */
  	if (state == STATE_RADIO_IRQ_ON) {
-		reg = rt2x00mmio_register_read(rt2x00dev, INT_SOURCE_CSR);
-		rt2x00mmio_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
+		if (rt2x00_rt(rt2x00dev, MT7630))
+			rt2x00mmio_register_write(rt2x00dev, INT_SOURCE_CSR, 0xffffffff);
+		else {
+			reg = rt2x00mmio_register_read(rt2x00dev, INT_SOURCE_CSR);
+			rt2x00mmio_register_write(rt2x00dev, INT_SOURCE_CSR, reg);
+		}
  	}

  	spin_lock_irqsave(&rt2x00dev->irqmask_lock, flags);
  	reg = 0;
  	if (state == STATE_RADIO_IRQ_ON) {
-		rt2x00_set_field32(&reg, INT_MASK_CSR_RX_DONE, 1);
-		rt2x00_set_field32(&reg, INT_MASK_CSR_TBTT, 1);
-		rt2x00_set_field32(&reg, INT_MASK_CSR_PRE_TBTT, 1);
-		rt2x00_set_field32(&reg, INT_MASK_CSR_TX_FIFO_STATUS, 1);
-		rt2x00_set_field32(&reg, INT_MASK_CSR_AUTO_WAKEUP, 1);
+		if (rt2x00_rt(rt2x00dev, MT7630)) {
+			rt2x00_set_field32(&reg, INT_MASK_CSR_7630_RX_DONE, 1);
+			rt2x00_set_field32(&reg, INT_MASK_CSR_7630_TBTT, 1);
+			rt2x00_set_field32(&reg, INT_MASK_CSR_7630_PRE_TBTT, 1);
+			rt2x00_set_field32(&reg, INT_MASK_CSR_7630_TX_FIFO_STATUS, 1);
+			rt2x00_set_field32(&reg, INT_MASK_CSR_7630_AUTO_WAKEUP, 1);
+		} else {
+			rt2x00_set_field32(&reg, INT_MASK_CSR_RX_DONE, 1);
+			rt2x00_set_field32(&reg, INT_MASK_CSR_TBTT, 1);
+			rt2x00_set_field32(&reg, INT_MASK_CSR_PRE_TBTT, 1);
+			rt2x00_set_field32(&reg, INT_MASK_CSR_TX_FIFO_STATUS, 1);
+			rt2x00_set_field32(&reg, INT_MASK_CSR_AUTO_WAKEUP, 1);
+		}
  	}
+
  	rt2x00mmio_register_write(rt2x00dev, INT_MASK_CSR, reg);
  	spin_unlock_irqrestore(&rt2x00dev->irqmask_lock, flags);

+	// ??????????????
+	/* if (state == STATE_RADIO_IRQ_ON && rt2x00_rt(rt2x00dev, MT7630)) {
+		**RTMPEnableRxTx(rt2x00dev);
+
+		/* vendor driver says "clear garbage interrupts" */
+		**reg = rt2x00mmio_register_read(rt2x00dev, EDCA_AC0_CFG);
+		**AsicWaitPDMAIdle(rt2x00dev, 5, 10);
+		**AsicWaitPDMAIdle(rt2x00dev, 5, 10);
+	} */
+
  	if (state == STATE_RADIO_IRQ_OFF) {
  		/*
  		 * Wait for possibly running tasklets to finish.
@@ -601,13 +624,21 @@ void rt2800mmio_kick_queue(struct data_queue *queue)
  	case QID_AC_BE:
  	case QID_AC_BK:
  		entry = rt2x00queue_get_entry(queue, Q_INDEX);
-		rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX(queue->qid),
-					  entry->entry_idx);
+		if (rt2x00_rt(rt2x00dev, MT7630))
+			rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX_7630(queue->qid),
+				entry->entry_idx);
+		else
+			rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX(queue->qid),
+				entry->entry_idx);
  		break;
  	case QID_MGMT:
  		entry = rt2x00queue_get_entry(queue, Q_INDEX);
-		rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX(5),
-					  entry->entry_idx);
+		if (rt2x00_rt(rt2x00dev, MT7630))
+			rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX_7630(5),
+				entry->entry_idx);
+		else
+			rt2x00mmio_register_write(rt2x00dev, TX_CTX_IDX(5),
+			  entry->entry_idx);
  		break;
  	default:
  		break;
@@ -622,9 +653,11 @@ void rt2800mmio_stop_queue(struct data_queue *queue)

  	switch (queue->qid) {
  	case QID_RX:
-		reg = rt2x00mmio_register_read(rt2x00dev, MAC_SYS_CTRL);
-		rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 0);
-		rt2x00mmio_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+		if (!rt2x00_rt(rt2x00dev, MT7630)) {
+			reg = rt2x00mmio_register_read(rt2x00dev, MAC_SYS_CTRL);
+			rt2x00_set_field32(&reg, MAC_SYS_CTRL_ENABLE_RX, 0);
+			rt2x00mmio_register_write(rt2x00dev, MAC_SYS_CTRL, reg);
+		}
  		break;
  	case QID_BEACON:
  		reg = rt2x00mmio_register_read(rt2x00dev, BCN_TIME_CFG);
@@ -725,19 +758,33 @@ void rt2800mmio_clear_entry(struct queue_entry *entry)

  	if (entry->queue->qid == QID_RX) {
  		word = rt2x00_desc_read(entry_priv->desc, 0);
-		rt2x00_set_field32(&word, RXD_W0_SDP0, skbdesc->skb_dma);
+
+		if (rt2x00_rt(rt2x00dev, MT7630))
+			rt2x00_set_field32(&word, RXD_W0_7630_SDP0, skbdesc->skb_dma);
+		else
+			rt2x00_set_field32(&word, RXD_W0_SDP0, skbdesc->skb_dma);
+
  		rt2x00_desc_write(entry_priv->desc, 0, word);

  		word = rt2x00_desc_read(entry_priv->desc, 1);
-		rt2x00_set_field32(&word, RXD_W1_DMA_DONE, 0);
+
+		if (rt2x00_rt(rt2x00dev, MT7630)) {
+			rt2x00_set_field32(&word, RXD_W1_7630_DMA_DONE, 0);
+			rt2x00_set_field32(&word, RXD_W1_7630_SDL0, entry->skb->len);
+		}
+		else {
+			rt2x00_set_field32(&word, RXD_W1_DMA_DONE, 0);
+		}
+
  		rt2x00_desc_write(entry_priv->desc, 1, word);

  		/*
  		 * Set RX IDX in register to inform hardware that we have
  		 * handled this entry and it is available for reuse again.
  		 */
-		rt2x00mmio_register_write(rt2x00dev, RX_CRX_IDX,
-					  entry->entry_idx);
+		if (rt2x00_rt(rt2x00dev, MT7630))
+			rt2x00mmio_register_write(rt2x00dev, RX_CRX_IDX,
+				entry->entry_idx);
  	} else {
  		word = rt2x00_desc_read(entry_priv->desc, 1);
  		rt2x00_set_field32(&word, TXD_W1_DMA_DONE, 1);
@@ -749,10 +796,46 @@ EXPORT_SYMBOL_GPL(rt2800mmio_clear_entry);
  int rt2800mmio_init_queues(struct rt2x00_dev *rt2x00dev)
  {
  	struct queue_entry_priv_mmio *entry_priv;
+	u32 mt7630_index, mt7630_offset;

  	/*
  	 * Initialize registers.
  	 */
+	 if (rt2x00_rt(rt2x00dev, MT7630)) {
+	 	for (i = 0 ; i < 4; i++) {
+	 		mt7630_offset = mt7630_index * 0x10;
+
+	 		entry_priv = rt2x00dev->tx[i].entries[0].priv_data;
+	 		rt2x00mmio_register_write(rt2x00dev, TX_RING_BASE + mt7630_offset, entry_priv->desc_dma);
+	 		rt2x00mmio_register_write(rt2x00dev, TX_RING_CNT + mt7630_offset, rt2x00dev->tx[i].limit);
+	 		rt2x00mmio_register_write(rt2x00dev, TX_RING_CIDX + mt7630_offset, 0);
+	 	}
+
+	 	mt7630_offset = 4 * 0x10;
+	 	rt2x00mmio_register_write(rt2x00dev, TX_RING_BASE + mt7630_offset, 0);
+	 	rt2x00mmio_register_write(rt2x00dev, TX_RING_CNT + mt7630_offset, 0);
+	 	rt2x00mmio_register_write(rt2x00dev, TX_RING_CIDX + mt7630_offset, 0);
+
+	 	rt2x00mmio_register_write(rt2x00dev, TX_MGMT_BASE, 0);
+	 	rt2x00mmio_register_write(rt2x00dev, TX_MGMT_CNT, 0);
+	 	rt2x00mmio_register_write(rt2x00dev, TX_MGMT_CIDX, 0);
+
+	 	entry_priv = rt2x00dev->rx->entries[0].priv_data;
+	 	rt2x00mmio_register_write(rt2x00dev, RX_RING_BASE, entry_priv->desc_dma);
+	 	rt2x00mmio_register_write(rt2x00dev, RX_RING_CNT, rt2x00dev->rx[0].limit);
+	 	rt2x00mmio_register_write(rt2x00dev, RX_RING_CIDX, rt2x00dev->rx[0].limit - 1);
+	 	rt2x00mmio_register_write(rt2x00dev, RX_RING_CIDX + 0x10, rt2x00dev->rx[0].limit - 1);
+
+	 	/* Vendor driver says - "Reset DMA Index" */
+	 	rt2x00mmio_register_write(rt2x00dev, WPDMA_RST_IDX, 0xFFFFFFFF);
+
+		/* Does this make sense? */
+	 	rt2800_wait_wpdma_ready(rt2x00dev);
+ 		rt2800_disable_wpdma(rt2x00dev);
+ 		rt2x00mmio_register_write(rt2x00dev, DELAY_INT_CFG, 0);
+ 		return 0;
+	}
+
  	entry_priv = rt2x00dev->tx[0].entries[0].priv_data;
  	rt2x00mmio_register_write(rt2x00dev, TX_BASE_PTR0,
  				  entry_priv->desc_dma);
@@ -819,15 +902,17 @@ int rt2800mmio_init_registers(struct rt2x00_dev *rt2x00dev)
  	/*
  	 * Reset DMA indexes
  	 */
-	reg = rt2x00mmio_register_read(rt2x00dev, WPDMA_RST_IDX);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX3, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX4, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX5, 1);
-	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DRX_IDX0, 1);
-	rt2x00mmio_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
+	if (!rt2x00_rt(rt2x00dev, MT7630)) {
+		reg = rt2x00mmio_register_read(rt2x00dev, WPDMA_RST_IDX);
+		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX0, 1);
+		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX1, 1);
+		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX2, 1);
+		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX3, 1);
+		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX4, 1);
+		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DTX_IDX5, 1);
+		rt2x00_set_field32(&reg, WPDMA_RST_IDX_DRX_IDX0, 1);
+		rt2x00mmio_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
+	}

  	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
  	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
@@ -846,7 +931,8 @@ int rt2800mmio_init_registers(struct rt2x00_dev *rt2x00dev)
  		rt2x00mmio_register_write(rt2x00dev, AUX_CTRL, reg);
  	}

-	rt2x00mmio_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);
+	if (!rt2x00_rt(rt2x00dev, MT7630))
+		rt2x00mmio_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000003);

  	reg = 0;
  	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
index 5cf655ff1430..19f23903ee5b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
@@ -170,6 +170,8 @@ static char *rt2800pci_get_firmware_name(struct rt2x00_dev *rt2x00dev)
  	 */
  	if (rt2x00_rt(rt2x00dev, RT3290))
  		return FIRMWARE_RT3290;
+	else if (rt2x00_rt(rt2x00dev, MT7630))
+		return FIRMWARE_MT7630;
  	else
  		return FIRMWARE_RT2860;
  }
@@ -179,6 +181,10 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
  {
  	u32 reg;

+	if (rt2x00_rt(rt2x00dev, MT7630)) {
+		printk("Missing firmware loading logic. I would stop here.\n");
+		return -1;
+	}
  	/*
  	 * enable Host program ram write selection
  	 */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 1f38c338ca7a..c2055512b975 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -175,6 +175,7 @@ struct rt2x00_chip {
  #define RT5392		0x5392  /* 2.4GHz */
  #define RT5592		0x5592
  #define RT6352		0x6352  /* WSOC 2.4GHz */
+#define MT7630    0x7630

  	u16 rf;
  	u16 rev;
