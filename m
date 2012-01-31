Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64820 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2AaRvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 12:51:25 -0500
Received: by bkcjm19 with SMTP id jm19so200637bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 09:51:23 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 31 Jan 2012 18:51:23 +0100
Message-ID: <CAKkO-EhQJfKZKTPVZH5-RvPDa8BSrbktEBYPuAHHPvQfhYZzog@mail.gmail.com> (sfid-20120131_185128_524069_82A85036)
Subject: [PATCH 3.2.2 1/1] rt2800lib: fix wrong -128dBm when signal is
 stronger than -12dBm
From: Luigi Tarenga <luigi.tarenga@gmail.com>
To: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch correct the type of variables containing the rssi
values read from the rxwi.

In function rt2800_agc_to_rssi() 3 variables (rssi0, rssi1, rss2)
defined as int was assigned a 16bit signed values as unsigned.
>From a test with a hi-gain antenna I verified that the rxwi
contains signed rssi values in the  range -13/+81 (inclusive)
with 0 as an error condition. In case of negative values a
condition is triggered and the function return -128dBm while
the signal is at its maximum. This patch correct the cast so
negative values are not treated as very high positive values
(ex. -13 does not become 243).

Signed-off-by: Luigi Tarenga <luigi.tarenga@gmail.com>
---

Thanks to Stanislaw for pointing me out the correct format.
> Not sure if change -12 to -13 is needed, seems not compatible with
> vendor driver. If you just change rssiX type to s8, will it
> fix the problem? That seems to be correct and enough to fix
> (example why this make difference: 0xc0 gives s8: -64 int: 192).

If you keep -12 in case the rssi is -13 you get a +1dBm. I thought it was
too optimistic to get positive dBm but should not be impossible.
Since rssi in rxwi is always an odd number, with -12 you get odd dBm
and with with -13 you get even dBm. I don't know if that is a problem.
-12 or -13 is not important in fixing my original problem: -128dBm
reported with very strong signal. I attach the patch keeping -12.

thank you
Luigi

diff -au a/drivers/net/wireless/rt2x00/rt2800lib.c
b/drivers/net/wireless/rt2x00/rt2800lib.c
--- a/drivers/net/wireless/rt2x00/rt2800lib.c	2012-01-31
18:45:16.557776563 +0100
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c	2012-01-31
18:44:28.366379036 +0100
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
@@ -552,7 +552,7 @@
 	 * which gives less energy...
 	 */
 	rssi0 = max(rssi0, rssi1);
-	return max(rssi0, rssi2);
+	return (int)max(rssi0, rssi2);
 }

 void rt2800_process_rxwi(struct queue_entry *entry,
