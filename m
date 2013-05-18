Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:11799 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab3ERMDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:03:16 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:03:14 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 29/32] rt2800: initialize BBP_R108 on proper subroutines
Date: Sat, 18 May 2013 14:03:52 +0200
Message-Id: <1368878635-4455-30-git-send-email-stf_xl@wp.pl> (sfid-20130518_142937_211235_C143BBF7)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Create helper function and move initialization to subroutines.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   41 ++++++++++++++++++-------------
 1 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 408c0d4..bb0ed3d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3953,6 +3953,20 @@ static void rt2800_init_bbp_early(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 106, 0x35);
 }
 
+static void rt2800_disable_unused_dac_adc(struct rt2x00_dev *rt2x00dev)
+{
+	u16 eeprom;
+	u8 value;
+
+	rt2800_bbp_read(rt2x00dev, 138, &value);
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
+		value |= 0x20;
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
+		value &= ~0x02;
+	rt2800_bbp_write(rt2x00dev, 138, value);
+}
+
 static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_bbp_write(rt2x00dev, 31, 0x08);
@@ -4062,6 +4076,10 @@ static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 
 	rt2800_bbp_write(rt2x00dev, 106, 0x35);
+
+	if (rt2x00_rt(rt2x00dev, RT3071) ||
+	    rt2x00_rt(rt2x00dev, RT3090))
+		rt2800_disable_unused_dac_adc(rt2x00dev);
 }
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
@@ -4200,6 +4218,8 @@ static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 
 	rt2800_bbp_write(rt2x00dev, 106, 0x35);
+
+	rt2800_disable_unused_dac_adc(rt2x00dev);
 }
 
 static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
@@ -4235,6 +4255,8 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 
 	rt2800_bbp_write(rt2x00dev, 106, 0x35);
+
+	rt2800_disable_unused_dac_adc(rt2x00dev);
 }
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
@@ -4300,6 +4322,8 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 134, 0xd0);
 		rt2800_bbp_write(rt2x00dev, 135, 0xf6);
 	}
+
+	rt2800_disable_unused_dac_adc(rt2x00dev);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4418,23 +4442,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3071) ||
-	    rt2x00_rt(rt2x00dev, RT3090) ||
-	    rt2x00_rt(rt2x00dev, RT3390) ||
-	    rt2x00_rt(rt2x00dev, RT3572) ||
-	    rt2x00_rt(rt2x00dev, RT5390) ||
-	    rt2x00_rt(rt2x00dev, RT5392)) {
-		rt2800_bbp_read(rt2x00dev, 138, &value);
-
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
-		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
-			value |= 0x20;
-		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
-			value &= ~0x02;
-
-		rt2800_bbp_write(rt2x00dev, 138, value);
-	}
-
 	if (rt2x00_rt(rt2x00dev, RT3290)) {
 		rt2800_bbp_write(rt2x00dev, 67, 0x24);
 		rt2800_bbp_write(rt2x00dev, 143, 0x04);
-- 
1.7.4.4

