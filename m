Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:50808 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3ERMCq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:46 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:43 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 12/32] rt2800: initialize BBP_R74 - BBP_R80 on all subroutines (except 5592)
Date: Sat, 18 May 2013 14:03:35 +0200
Message-Id: <1368878635-4455-13-git-send-email-stf_xl@wp.pl> (sfid-20130518_142936_918909_0CA85B10)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   56 ++++++++++++++++--------------
 1 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index dd40c45..10050c3 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3964,6 +3964,9 @@ static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 73, 0x10);
 
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+
+	rt2800_bbp_write(rt2x00dev, 78, 0x0e);
+	rt2800_bbp_write(rt2x00dev, 80, 0x08);
 }
 
 static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
@@ -3980,6 +3983,8 @@ static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
 	}
 
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+
+	rt2800_bbp_write(rt2x00dev, 81, 0x37);
 }
 
 static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
@@ -3991,6 +3996,10 @@ static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 73, 0x10);
 
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+
+	rt2800_bbp_write(rt2x00dev, 79, 0x13);
+	rt2800_bbp_write(rt2x00dev, 80, 0x05);
+	rt2800_bbp_write(rt2x00dev, 81, 0x33);
 }
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
@@ -4012,6 +4021,11 @@ static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 77, 0x58);
 
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+
+	rt2800_bbp_write(rt2x00dev, 74, 0x0b);
+	rt2800_bbp_write(rt2x00dev, 79, 0x18);
+	rt2800_bbp_write(rt2x00dev, 80, 0x09);
+	rt2800_bbp_write(rt2x00dev, 81, 0x33);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -4036,6 +4050,10 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 77, 0x59);
 
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+
+	rt2800_bbp_write(rt2x00dev, 78, 0x0e);
+	rt2800_bbp_write(rt2x00dev, 80, 0x08);
+	rt2800_bbp_write(rt2x00dev, 81, 0x37);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -4047,6 +4065,10 @@ static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 73, 0x10);
 
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+
+	rt2800_bbp_write(rt2x00dev, 79, 0x13);
+	rt2800_bbp_write(rt2x00dev, 80, 0x05);
+	rt2800_bbp_write(rt2x00dev, 81, 0x33);
 }
 
 static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
@@ -4060,6 +4082,10 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 73, 0x10);
 
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+
+	rt2800_bbp_write(rt2x00dev, 79, 0x13);
+	rt2800_bbp_write(rt2x00dev, 80, 0x05);
+	rt2800_bbp_write(rt2x00dev, 81, 0x33);
 }
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
@@ -4081,6 +4107,10 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 77, 0x59);
 
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+
+	rt2800_bbp_write(rt2x00dev, 79, 0x13);
+	rt2800_bbp_write(rt2x00dev, 80, 0x05);
+	rt2800_bbp_write(rt2x00dev, 81, 0x33);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4199,32 +4229,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3070) ||
-	    rt2x00_rt(rt2x00dev, RT3071) ||
-	    rt2x00_rt(rt2x00dev, RT3090) ||
-	    rt2x00_rt(rt2x00dev, RT3390) ||
-	    rt2x00_rt(rt2x00dev, RT3572) ||
-	    rt2x00_rt(rt2x00dev, RT5390) ||
-	    rt2x00_rt(rt2x00dev, RT5392)) {
-		rt2800_bbp_write(rt2x00dev, 79, 0x13);
-		rt2800_bbp_write(rt2x00dev, 80, 0x05);
-		rt2800_bbp_write(rt2x00dev, 81, 0x33);
-	} else if (rt2800_is_305x_soc(rt2x00dev)) {
-		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
-		rt2800_bbp_write(rt2x00dev, 80, 0x08);
-	} else if (rt2x00_rt(rt2x00dev, RT3290)) {
-		rt2800_bbp_write(rt2x00dev, 74, 0x0b);
-		rt2800_bbp_write(rt2x00dev, 79, 0x18);
-		rt2800_bbp_write(rt2x00dev, 80, 0x09);
-		rt2800_bbp_write(rt2x00dev, 81, 0x33);
-	} else if (rt2x00_rt(rt2x00dev, RT3352)) {
-		rt2800_bbp_write(rt2x00dev, 78, 0x0e);
-		rt2800_bbp_write(rt2x00dev, 80, 0x08);
-		rt2800_bbp_write(rt2x00dev, 81, 0x37);
-	} else {
-		rt2800_bbp_write(rt2x00dev, 81, 0x37);
-	}
-
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 	if (rt2x00_rt(rt2x00dev, RT3290) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
-- 
1.7.4.4

