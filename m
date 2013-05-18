Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:19644 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab3ERMDS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:03:18 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:03:16 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 30/32] rt2800: move 3352 specific bbp initialization
Date: Sat, 18 May 2013 14:03:53 +0200
Message-Id: <1368878635-4455-31-git-send-email-stf_xl@wp.pl> (sfid-20130518_142938_185300_034C278C)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   42 ++++++++++++++----------------
 1 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index bb0ed3d..ad191d5 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4182,6 +4182,26 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 120, 0x50);
 
 	rt2800_bbp_write(rt2x00dev, 137, 0x0f);
+
+	rt2800_bbp_write(rt2x00dev, 163, 0xbd);
+	/* Set ITxBF timeout to 0x9c40=1000msec */
+	rt2800_bbp_write(rt2x00dev, 179, 0x02);
+	rt2800_bbp_write(rt2x00dev, 180, 0x00);
+	rt2800_bbp_write(rt2x00dev, 182, 0x40);
+	rt2800_bbp_write(rt2x00dev, 180, 0x01);
+	rt2800_bbp_write(rt2x00dev, 182, 0x9c);
+	rt2800_bbp_write(rt2x00dev, 179, 0x00);
+	/* Reprogram the inband interface to put right values in RXWI */
+	rt2800_bbp_write(rt2x00dev, 142, 0x04);
+	rt2800_bbp_write(rt2x00dev, 143, 0x3b);
+	rt2800_bbp_write(rt2x00dev, 142, 0x06);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa0);
+	rt2800_bbp_write(rt2x00dev, 142, 0x07);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa1);
+	rt2800_bbp_write(rt2x00dev, 142, 0x08);
+	rt2800_bbp_write(rt2x00dev, 143, 0xa2);
+
+	rt2800_bbp_write(rt2x00dev, 148, 0xc8);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -4465,28 +4485,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 3, value);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3352)) {
-		rt2800_bbp_write(rt2x00dev, 163, 0xbd);
-		/* Set ITxBF timeout to 0x9c40=1000msec */
-		rt2800_bbp_write(rt2x00dev, 179, 0x02);
-		rt2800_bbp_write(rt2x00dev, 180, 0x00);
-		rt2800_bbp_write(rt2x00dev, 182, 0x40);
-		rt2800_bbp_write(rt2x00dev, 180, 0x01);
-		rt2800_bbp_write(rt2x00dev, 182, 0x9c);
-		rt2800_bbp_write(rt2x00dev, 179, 0x00);
-		/* Reprogram the inband interface to put right values in RXWI */
-		rt2800_bbp_write(rt2x00dev, 142, 0x04);
-		rt2800_bbp_write(rt2x00dev, 143, 0x3b);
-		rt2800_bbp_write(rt2x00dev, 142, 0x06);
-		rt2800_bbp_write(rt2x00dev, 143, 0xa0);
-		rt2800_bbp_write(rt2x00dev, 142, 0x07);
-		rt2800_bbp_write(rt2x00dev, 143, 0xa1);
-		rt2800_bbp_write(rt2x00dev, 142, 0x08);
-		rt2800_bbp_write(rt2x00dev, 143, 0xa2);
-
-		rt2800_bbp_write(rt2x00dev, 148, 0xc8);
-	}
-
 	if (rt2x00_rt(rt2x00dev, RT5390) ||
 	    rt2x00_rt(rt2x00dev, RT5392)) {
 		int ant, div_mode;
-- 
1.7.4.4

