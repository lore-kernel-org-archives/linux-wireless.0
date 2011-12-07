Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46002 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1LGGCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 01:02:03 -0500
Received: by yenm1 with SMTP id m1so186885yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Dec 2011 22:02:01 -0800 (PST)
Date: Wed, 7 Dec 2011 01:01:57 -0500
From: nick black <dankamongmen@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [[PATCH] don't use unsigned ints for signed data, print_mcs_index()]
Message-ID: <20111207060157.GA14048@qemfd.net> (sfid-20111207_070207_060696_96784902)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(unsigned this time per
http://linuxwireless.org/en/developers/Documentation/SubmittingPatches,
sorry about that)

diff -ur iw-3.1-orig/util.c iw-3.1/util.c
--- iw-3.1-orig/util.c	2011-12-07 00:43:05.495669921 -0500
+++ iw-3.1/util.c	2011-12-07 00:51:45.558545571 -0500
@@ -384,7 +384,7 @@
 
 static void print_mcs_index(const __u8 *mcs)
 {
-	unsigned int mcs_bit, prev_bit = -2, prev_cont = 0;
+	int mcs_bit, prev_bit = -2, prev_cont = 0;
 
 	for (mcs_bit = 0; mcs_bit <= 76; mcs_bit++) {
 		unsigned int mcs_octet = mcs_bit/8;
@@ -458,7 +458,7 @@
 	if (max_ampdu_length) {
 		printf("\t\tMaximum RX AMPDU length %d bytes (exponent: 0x0%02x)\n",
 		       max_ampdu_length, exponent);
-        } else {
+	} else {
 		printf("\t\tMaximum RX AMPDU length: unrecognized bytes "
 		       "(exponent: %d)\n", exponent);
 	}
@@ -466,8 +466,8 @@
 
 void print_ampdu_spacing(__u8 spacing)
 {
-        printf("\t\tMinimum RX AMPDU time spacing: %s (0x%02x)\n",
-               print_ampdu_space(spacing), spacing);
+	printf("\t\tMinimum RX AMPDU time spacing: %s (0x%02x)\n",
+	       print_ampdu_space(spacing), spacing);
 }
 
 void print_ht_capability(__u16 cap)

-- 
                                       nick black <nickblack@linux.com>
"A main cause of the Roman Empire's fall was that–lacking zero–they had
       no way to indicate successful termination of their C programs."
