Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37612 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab2DWKhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 06:37:48 -0400
Received: by wgbds11 with SMTP id ds11so2417300wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 03:37:47 -0700 (PDT)
From: Anisse Astier <anisse@astier.eu>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Julian Calaby <julian.calaby@gmail.com>,
	linville@tuxdriver.com, Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	RA-ShiangTu <Shiang_Tu@ralinktech.com>,
	RA-Jay Hung <Jay_Hung@ralinktech.com>,
	John Li <chen-yang.li@mediatek.com>,
	Kevin Chou <kevin.chou@mediatek.com>,
	Anisse Astier <anisse@astier.eu>
Subject: [PATCH v2] rt2800: add chipset revision RT5390R support
Date: Mon, 23 Apr 2012 12:33:11 +0200
Message-Id: <1335177191-11101-1-git-send-email-anisse@astier.eu> (sfid-20120423_123752_692474_B194ACCC)
In-Reply-To: <CAL1gcdOT1E3jP=j8-sEEN87WRZ7qG=m0jv3aK6QaP-mBuYtXmw@mail.gmail.com>
References: <CAL1gcdOT1E3jP=j8-sEEN87WRZ7qG=m0jv3aK6QaP-mBuYtXmw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

About 70% of the chips with revision RT5390R initialize incorrectly, using
the auxiliary antenna instead of the main one. The net result is that
signal reception is very poor (no AP further than 1M).

This chipset differs from RT5390 and RT5390F by its support of hardware
antenna diversity. Therefore antenna selection should be done
differently, by disabling software features and previously selected
antenna.

This changeset does just that, and makes all RT5390R work properly.

This is based on Ralink's 2012_03_22_RT5572_Linux_STA_v2.6.0.0_DPO
driver.

Signed-off-by: Anisse Astier <anisse@astier.eu>
---
Changes since v1:
 - moved default_ant inits to proper function, thanks to Gertjan van Wingerde !

---
 drivers/net/wireless/rt2x00/rt2800.h    |    1 +
 drivers/net/wireless/rt2x00/rt2800lib.c |   12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 063bfa8..1ce2634 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -83,6 +83,7 @@
 #define REV_RT3090E			0x0211
 #define REV_RT3390E			0x0211
 #define REV_RT5390F			0x0502
+#define REV_RT5390R			0x1502
 
 /*
  * Signal information.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index bd19802..1cd16b4 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3356,6 +3356,13 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 			rt2800_register_write(rt2x00dev, GPIO_CTRL_CFG, reg);
 		}
 
+		/* This chip has hardware antenna diversity*/
+		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
+			rt2800_bbp_write(rt2x00dev, 150, 0); /* Disable Antenna Software OFDM */
+			rt2800_bbp_write(rt2x00dev, 151, 0); /* Disable Antenna Software CCK */
+			rt2800_bbp_write(rt2x00dev, 154, 0); /* Clear previously selected antenna */
+		}
+
 		rt2800_bbp_read(rt2x00dev, 152, &value);
 		if (ant == 0)
 			rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 1);
@@ -4291,6 +4298,11 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00dev->default_ant.rx = ANTENNA_A;
 	}
 
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390R)) {
+		rt2x00dev->default_ant.tx = ANTENNA_HW_DIVERSITY; /* Unused */
+		rt2x00dev->default_ant.rx = ANTENNA_HW_DIVERSITY; /* Unused */
+	}
+
 	/*
 	 * Determine external LNA informations.
 	 */
-- 
1.7.9.4

