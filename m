Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:45586 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab3ERMDI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:03:08 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:03:06 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 24/32] rt2800: initialize BBP_R106 on all subroutines (except 5592)
Date: Sat, 18 May 2013 14:03:47 +0200
Message-Id: <1368878635-4455-25-git-send-email-stf_xl@wp.pl> (sfid-20130518_142937_352159_BB7627F4)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 422f6ed..70e2ff8 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3983,6 +3983,8 @@ static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 
 	rt2800_bbp_write(rt2x00dev, 105, 0x01);
+
+	rt2800_bbp_write(rt2x00dev, 106, 0x35);
 }
 
 static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
@@ -4020,6 +4022,8 @@ static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 103, 0x00);
 
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
+
+	rt2800_bbp_write(rt2x00dev, 106, 0x35);
 }
 
 static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
@@ -4056,6 +4060,8 @@ static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 103, 0x00);
 
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
+
+	rt2800_bbp_write(rt2x00dev, 106, 0x35);
 }
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
@@ -4100,6 +4106,8 @@ static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 104, 0x92);
 
 	rt2800_bbp_write(rt2x00dev, 105, 0x1c);
+
+	rt2800_bbp_write(rt2x00dev, 106, 0x03);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -4148,6 +4156,8 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 104, 0x92);
 
 	rt2800_bbp_write(rt2x00dev, 105, 0x34);
+
+	rt2800_bbp_write(rt2x00dev, 106, 0x05);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -4182,6 +4192,8 @@ static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 103, 0x00);
 
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
+
+	rt2800_bbp_write(rt2x00dev, 106, 0x35);
 }
 
 static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
@@ -4215,6 +4227,8 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
+
+	rt2800_bbp_write(rt2x00dev, 106, 0x35);
 }
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
@@ -4266,6 +4280,13 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 104, 0x92);
 
 	rt2800_bbp_write(rt2x00dev, 105, 0x3c);
+
+	if (rt2x00_rt(rt2x00dev, RT5390))
+		rt2800_bbp_write(rt2x00dev, 106, 0x03);
+	else if (rt2x00_rt(rt2x00dev, RT5392))
+		rt2800_bbp_write(rt2x00dev, 106, 0x12);
+	else
+		WARN_ON(1);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4384,16 +4405,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3290) ||
-	    rt2x00_rt(rt2x00dev, RT5390))
-		rt2800_bbp_write(rt2x00dev, 106, 0x03);
-	else if (rt2x00_rt(rt2x00dev, RT3352))
-		rt2800_bbp_write(rt2x00dev, 106, 0x05);
-	else if (rt2x00_rt(rt2x00dev, RT5392))
-		rt2800_bbp_write(rt2x00dev, 106, 0x12);
-	else
-		rt2800_bbp_write(rt2x00dev, 106, 0x35);
-
 	if (rt2x00_rt(rt2x00dev, RT3352))
 		rt2800_bbp_write(rt2x00dev, 120, 0x50);
 
-- 
1.7.4.4

