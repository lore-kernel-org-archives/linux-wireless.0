Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f181.google.com ([209.85.210.181]:63438 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3CEQAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 11:00:10 -0500
Received: by mail-ia0-f181.google.com with SMTP id w33so6130559iag.40
        for <linux-wireless@vger.kernel.org>; Tue, 05 Mar 2013 08:00:10 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 5 Mar 2013 20:00:10 +0400
Message-ID: <CALK7Yahs2=2UkN9uXGbuoWXhvcC1u4-R4xak5cx0ZqKm7OfK+A@mail.gmail.com> (sfid-20130305_170016_826393_83F8BF0C)
Subject: RFC: RT3070 TX Power troubles
From: "Alex A. Mihaylov" <minimumlaw@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good day!

I use Jorjin WN8020 USB WiFi module with RT3070 chip.
On Windows and Os X module have 15dBm output power, but on Linux about
3dBm with 'ifconfig wlan0 txpower 20' and less if txpower set less,
than 20dBm.

I analyse Ralink driver and found RF_R49/RF_R50 registers present in
ralnik code, but abcent in Linux drivers. I try patch code:

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c
b/drivers/net/wireless/rt2x00/rt2800lib.c
index 197b446..10683e3 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1670,6 +1670,9 @@ static void rt2800_config_lna_gain(struct
rt2x00_dev *rt2x00dev,
 	rt2x00dev->lna_gain = lna_gain;
 }

+#define POWER_BOUND		0x27
+#define FREQ_OFFSET_BOUND	0x5f
+
 static void rt2800_config_channel_rf2xxx(struct rt2x00_dev *rt2x00dev,
 					 struct ieee80211_conf *conf,
 					 struct rf_channel *rf,
@@ -1761,6 +1764,24 @@ static void rt2800_config_channel_rf3xxx(struct
rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER, info->default_power2);
 	rt2800_rfcsr_write(rt2x00dev, 13, rfcsr);

+	/*
+	 * FixMe: Why POWER_BOUND and FREQ_OFFSET_BOUND not init here?
+	 */
+
+	rt2800_rfcsr_read(rt2x00dev, 49, &rfcsr);
+	if (info->default_power1 > POWER_BOUND)
+		rt2x00_set_field8(&rfcsr, RFCSR49_TX, POWER_BOUND);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
+	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
+	if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
+		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
+	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+
 	rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
 	rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD,
@@ -1988,9 +2009,6 @@ static void rt2800_config_channel_rf3052(struct
rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
 }

-#define POWER_BOUND		0x27
-#define FREQ_OFFSET_BOUND	0x5f
-
 static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
 					 struct ieee80211_conf *conf,
 					 struct rf_channel *rf,


and tx power stay 15dBm (ass writen in WN8020 specification) if
txpower set to 20dBm in driver, and about 0dBm if tx power set to 0dBm
in driver.
I also found function rt2800_config_channel_rf2xxx without
initialisation POWER_BOUND and FREQ_OFFSET_BOUND. May be this also
incorrect?

-- 
Alex A. Mihaylov
AKA MinimumLaw
