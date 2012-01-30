Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38983 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab2A3OXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 09:23:16 -0500
Received: by bkas6 with SMTP id s6so3210249bka.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 06:23:15 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 30 Jan 2012 15:23:15 +0100
Message-ID: <CAKkO-EgF=NKpj-duK5oOTCMdbOnc0HwmBT9oc9FhtqT5KqZgeg@mail.gmail.com> (sfid-20120130_152319_949409_A48907E2)
Subject: PROBLEM: rt2800lib return -128db when signal is stronger than -12db
From: Luigi Tarenga <luigi.tarenga@gmail.com>
To: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I found that my rt2870 sometimes report -128db signal when very near to AP or
using a hi-gain antenna such a waveguide (checked from iw and nm-applet).
I found that the rssi from the hardware is a signed from -13db
(strongest signal)
to positive number (bigger is weaker) while the 0 is treated as error condition
but there is an error in casting the value when retrieved from the hardware.
I changed the type of the variables so the cast is correct and when i
get -13 rssi
from hw i return 0 db from the function.

attached the patch against linux-3.2.2 (my very first Linux patch :P).

Luigi

--- a/drivers/net/wireless/rt2x00/rt2800lib.c	2012-01-30
12:48:15.779238642 +0100
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c	2012-01-30
15:09:30.694287624 +0100
@@ -514,9 +514,9 @@

 static int rt2800_agc_to_rssi(struct rt2x00_dev *rt2x00dev, u32 rxwi_w2)
 {
-	int rssi0 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI0);
-	int rssi1 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI1);
-	int rssi2 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI2);
+	s8 rssi0 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI0);
+	s8 rssi1 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI1);
+	s8 rssi2 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI2);
 	u16 eeprom;
 	u8 offset0;
 	u8 offset1;
@@ -539,11 +539,12 @@
 	/*
 	 * Convert the value from the descriptor into the RSSI value
 	 * If the value in the descriptor is 0, it is considered invalid
-	 * and the default (extremely low) rssi value is assumed
+	 * and the default (extremely low) rssi value is assumed.
+         * HW rssiX values go from -13 (strongest) to positive number
(weakest).
 	 */
-	rssi0 = (rssi0) ? (-12 - offset0 - rt2x00dev->lna_gain - rssi0) : -128;
-	rssi1 = (rssi1) ? (-12 - offset1 - rt2x00dev->lna_gain - rssi1) : -128;
-	rssi2 = (rssi2) ? (-12 - offset2 - rt2x00dev->lna_gain - rssi2) : -128;
+	rssi0 = (rssi0) ? (-13 - offset0 - rt2x00dev->lna_gain - rssi0) : -128;
+	rssi1 = (rssi1) ? (-13 - offset1 - rt2x00dev->lna_gain - rssi1) : -128;
+	rssi2 = (rssi2) ? (-13 - offset2 - rt2x00dev->lna_gain - rssi2) : -128;

 	/*
 	 * mac80211 only accepts a single RSSI value. Calculating the
@@ -552,7 +553,7 @@
 	 * which gives less energy...
 	 */
 	rssi0 = max(rssi0, rssi1);
-	return max(rssi0, rssi2);
+	return (int)max(rssi0, rssi2);
 }

 void rt2800_process_rxwi(struct queue_entry *entry,
