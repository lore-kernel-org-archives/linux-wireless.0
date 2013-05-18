Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:55308 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab3ERMDC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:03:02 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:03:00 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 21/32] rt2800: initialize BBP_R103 on all subroutines (except 5592)
Date: Sat, 18 May 2013 14:03:44 +0200
Message-Id: <1368878635-4455-22-git-send-email-stf_xl@wp.pl> (sfid-20130518_142939_179213_358D5BA5)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   38 +++++++++++++++++++-----------
 1 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e08a2d2..594b1e3 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3979,6 +3979,8 @@ static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 
 	rt2800_bbp_write(rt2x00dev, 92, 0x00);
+
+	rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 }
 
 static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
@@ -4012,6 +4014,8 @@ static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 
 	rt2800_bbp_write(rt2x00dev, 92, 0x00);
+
+	rt2800_bbp_write(rt2x00dev, 103, 0x00);
 }
 
 static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
@@ -4039,6 +4043,13 @@ static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 
 	rt2800_bbp_write(rt2x00dev, 92, 0x00);
+
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT3070, REV_RT3070F) ||
+	    rt2x00_rt_rev_gte(rt2x00dev, RT3071, REV_RT3071E) ||
+	    rt2x00_rt_rev_gte(rt2x00dev, RT3090, REV_RT3090E))
+		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
+	else
+		rt2800_bbp_write(rt2x00dev, 103, 0x00);
 }
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
@@ -4077,6 +4088,8 @@ static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 
 	rt2800_bbp_write(rt2x00dev, 92, 0x02);
+
+	rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -4119,6 +4132,8 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 
 	rt2800_bbp_write(rt2x00dev, 92, 0x02);
+
+	rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -4146,6 +4161,11 @@ static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 
 	rt2800_bbp_write(rt2x00dev, 92, 0x00);
+
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT3390, REV_RT3390E))
+		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
+	else
+		rt2800_bbp_write(rt2x00dev, 103, 0x00);
 }
 
 static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
@@ -4175,6 +4195,8 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 
 	rt2800_bbp_write(rt2x00dev, 92, 0x00);
+
+	rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 }
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
@@ -4220,6 +4242,8 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 95, 0x9a);
 		rt2800_bbp_write(rt2x00dev, 98, 0x12);
 	}
+
+	rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4338,20 +4362,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt_rev_gte(rt2x00dev, RT3070, REV_RT3070F) ||
-	    rt2x00_rt_rev_gte(rt2x00dev, RT3071, REV_RT3071E) ||
-	    rt2x00_rt_rev_gte(rt2x00dev, RT3090, REV_RT3090E) ||
-	    rt2x00_rt_rev_gte(rt2x00dev, RT3390, REV_RT3390E) ||
-	    rt2x00_rt(rt2x00dev, RT3290) ||
-	    rt2x00_rt(rt2x00dev, RT3352) ||
-	    rt2x00_rt(rt2x00dev, RT3572) ||
-	    rt2x00_rt(rt2x00dev, RT5390) ||
-	    rt2x00_rt(rt2x00dev, RT5392) ||
-	    rt2800_is_305x_soc(rt2x00dev))
-		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
-	else
-		rt2800_bbp_write(rt2x00dev, 103, 0x00);
-
 	if (rt2x00_rt(rt2x00dev, RT3290) ||
 	    rt2x00_rt(rt2x00dev, RT3352) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
-- 
1.7.4.4

