Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52311 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaJLK5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Oct 2014 06:57:13 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so4040408pdi.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Oct 2014 03:57:13 -0700 (PDT)
From: Michael Harris <harmic@gmail.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	Michael Harris <harmic@gmail.com>
Subject: [PATCH 1/1] wireless-regdb: Update rules for Australia (AU) to align with class licence
Date: Sun, 12 Oct 2014 21:56:51 +1100
Message-Id: <1413111411-29509-1-git-send-email-harmic@gmail.com> (sfid-20141012_125718_460714_98E89662)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am not sure where the existing regdb rules for Australia were derived from
(perhaps some default template?) but they are a lot more restrictive than the
actual class licence requirements.

I have updated to the best of my ability according to the "Radiocommunications
(Low Interference Potential Devices) Class Licence 2000" which can be found here:

http://www.acma.gov.au/Industry/Spectrum/Radiocomms-licensing/Class-licences/class-licences

There is also a useful FAQ for 2.4GHz WLANs here:
http://www.acma.gov.au/Citizen/Consumer-info/My-connected-home/Wireless-local-area-networks/wireless-lans-in-the-24-ghz-band-faqs

Signed-off-by: Michael Harris <harmic@gmail.com>
---
 db.txt | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/db.txt b/db.txt
index f0e4312..94c7010 100644
--- a/db.txt
+++ b/db.txt
@@ -78,12 +78,22 @@ country AT: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
+# Reference: Radiocommunications (Low Interference Potential Devices) Class Licence 2000
+# http://www.acma.gov.au/Industry/Spectrum/Radiocomms-licensing/Class-licences/class-licences
 country AU:
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (17)
-	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5710 @ 80), (24), DFS
-	(5735 - 5835 @ 80), (30)
+	# Item 45A
+	(2400 - 2483 @ 40), (36)
+	# Item 44
+	(5150 - 5250 @ 80), (23), NO-OUTDOOR
+	# Item 44A (assuminging no TPC implemented).
+	# If TPC implemented then 23dBm allowed.
+	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS
+	# Item 46 (assuming no TPC implemented)
+	# If TPC implemented then 30dBm allowed
+	(5470 - 5600 @ 80), (27), DFS
+	(5650 - 5725 @ 40), (27), DFS
+	# Item 45B
+	(5725 - 5850 @ 80), (36)
 
 country AW: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.8.3.1

