Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:27311 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3ERMCm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:42 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:40 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 10/32] rt2800: initialize BBP_R69 - BBP_R77 on proper subroutines
Date: Sat, 18 May 2013 14:03:33 +0200
Message-Id: <1368878635-4455-11-git-send-email-stf_xl@wp.pl> (sfid-20130518_142938_597955_6178FD6B)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   62 ++++++++++++++++++++----------
 1 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 3c404b2..d6b6f15 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3959,18 +3959,32 @@ static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
+
+	rt2800_bbp_write(rt2x00dev, 69, 0x12);
+	rt2800_bbp_write(rt2x00dev, 73, 0x10);
 }
 
 static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
+
+	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C)) {
+		rt2800_bbp_write(rt2x00dev, 69, 0x16);
+		rt2800_bbp_write(rt2x00dev, 73, 0x12);
+	} else {
+		rt2800_bbp_write(rt2x00dev, 69, 0x12);
+		rt2800_bbp_write(rt2x00dev, 73, 0x10);
+	}
 }
 
 static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
+
+	rt2800_bbp_write(rt2x00dev, 69, 0x12);
+	rt2800_bbp_write(rt2x00dev, 73, 0x10);
 }
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
@@ -3983,6 +3997,13 @@ static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 
 	rt2800_bbp_write(rt2x00dev, 68, 0x0b);
+
+	rt2800_bbp_write(rt2x00dev, 69, 0x12);
+	rt2800_bbp_write(rt2x00dev, 73, 0x13);
+	rt2800_bbp_write(rt2x00dev, 75, 0x46);
+	rt2800_bbp_write(rt2x00dev, 76, 0x28);
+
+	rt2800_bbp_write(rt2x00dev, 77, 0x58);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -3998,12 +4019,22 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 
 	rt2800_bbp_write(rt2x00dev, 68, 0x0b);
+
+	rt2800_bbp_write(rt2x00dev, 69, 0x12);
+	rt2800_bbp_write(rt2x00dev, 73, 0x13);
+	rt2800_bbp_write(rt2x00dev, 75, 0x46);
+	rt2800_bbp_write(rt2x00dev, 76, 0x28);
+
+	rt2800_bbp_write(rt2x00dev, 77, 0x59);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
+
+	rt2800_bbp_write(rt2x00dev, 69, 0x12);
+	rt2800_bbp_write(rt2x00dev, 73, 0x10);
 }
 
 static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
@@ -4012,6 +4043,9 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
+
+	rt2800_bbp_write(rt2x00dev, 69, 0x12);
+	rt2800_bbp_write(rt2x00dev, 73, 0x10);
 }
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
@@ -4024,6 +4058,13 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 
 	rt2800_bbp_write(rt2x00dev, 68, 0x0b);
+
+	rt2800_bbp_write(rt2x00dev, 69, 0x12);
+	rt2800_bbp_write(rt2x00dev, 73, 0x13);
+	rt2800_bbp_write(rt2x00dev, 75, 0x46);
+	rt2800_bbp_write(rt2x00dev, 76, 0x28);
+
+	rt2800_bbp_write(rt2x00dev, 77, 0x59);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4142,27 +4183,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C)) {
-		rt2800_bbp_write(rt2x00dev, 69, 0x16);
-		rt2800_bbp_write(rt2x00dev, 73, 0x12);
-	} else if (rt2x00_rt(rt2x00dev, RT3290) ||
-		   rt2x00_rt(rt2x00dev, RT3352) ||
-		   rt2x00_rt(rt2x00dev, RT5390) ||
-		   rt2x00_rt(rt2x00dev, RT5392)) {
-		rt2800_bbp_write(rt2x00dev, 69, 0x12);
-		rt2800_bbp_write(rt2x00dev, 73, 0x13);
-		rt2800_bbp_write(rt2x00dev, 75, 0x46);
-		rt2800_bbp_write(rt2x00dev, 76, 0x28);
-
-		if (rt2x00_rt(rt2x00dev, RT3290))
-			rt2800_bbp_write(rt2x00dev, 77, 0x58);
-		else
-			rt2800_bbp_write(rt2x00dev, 77, 0x59);
-	} else {
-		rt2800_bbp_write(rt2x00dev, 69, 0x12);
-		rt2800_bbp_write(rt2x00dev, 73, 0x10);
-	}
-
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 
 	if (rt2x00_rt(rt2x00dev, RT3070) ||
-- 
1.7.4.4

