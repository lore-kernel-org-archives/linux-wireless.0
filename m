Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:1358 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718Ab0ESP0N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 11:26:13 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 1/7] rt2x00: Remove RT2870 chipset identification.
Date: Wed, 19 May 2010 17:26:03 +0200
Message-Id: <1274282769-19244-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>
References: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no evidence, either in adapters or in the Ralink code, that such
a device actually exists. All so-call RT2870 adapter identify themselves
as RT2860.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    1 -
 drivers/net/wireless/rt2x00/rt2800lib.c |    5 +----
 drivers/net/wireless/rt2x00/rt2x00.h    |    3 +--
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 2aa0375..35afe63 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -63,7 +63,6 @@
  */
 #define REV_RT2860C			0x0100
 #define REV_RT2860D			0x0101
-#define REV_RT2870D			0x0101
 #define REV_RT2872E			0x0200
 #define REV_RT3070E			0x0200
 #define REV_RT3070F			0x0201
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9ee4ffa..b1dfb57 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1765,8 +1765,7 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
 
-	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860D) ||
-	    rt2x00_rt_rev(rt2x00dev, RT2870, REV_RT2870D))
+	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860D))
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
 	else
 		rt2800_bbp_write(rt2x00dev, 84, 0x99);
@@ -2206,7 +2205,6 @@ int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_eeprom_write(rt2x00dev, EEPROM_ANTENNA, word);
 		EEPROM(rt2x00dev, "Antenna: 0x%04x\n", word);
 	} else if (rt2x00_rt(rt2x00dev, RT2860) ||
-		   rt2x00_rt(rt2x00dev, RT2870) ||
 		   rt2x00_rt(rt2x00dev, RT2872)) {
 		/*
 		 * There is a max of 2 RX streams for RT28x0 series
@@ -2310,7 +2308,6 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 			value, rt2x00_get_field32(reg, MAC_CSR0_REVISION));
 
 	if (!rt2x00_rt(rt2x00dev, RT2860) &&
-	    !rt2x00_rt(rt2x00dev, RT2870) &&
 	    !rt2x00_rt(rt2x00dev, RT2872) &&
 	    !rt2x00_rt(rt2x00dev, RT2883) &&
 	    !rt2x00_rt(rt2x00dev, RT3070) &&
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 889a372..9fc3612 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -176,8 +176,7 @@ struct rt2x00_chip {
 #define RT2570		0x2570
 #define RT2661		0x2661
 #define RT2573		0x2573
-#define RT2860		0x2860	/* 2.4GHz PCI/CB */
-#define RT2870		0x2870
+#define RT2860		0x2860	/* 2.4GHz */
 #define RT2872		0x2872	/* WSOC */
 #define RT2883		0x2883	/* WSOC */
 #define RT3070		0x3070
-- 
1.7.1

