Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:58019 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab3ERMCv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:51 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:49 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 15/32] rt2800: initialize BBP_R84 on all subroutines (except 5592)
Date: Sat, 18 May 2013 14:03:38 +0200
Message-Id: <1368878635-4455-16-git-send-email-stf_xl@wp.pl> (sfid-20130518_142938_741096_633C6549)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 5e3dfd4..bb0d941 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3971,6 +3971,8 @@ static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 
 	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
+
+	rt2800_bbp_write(rt2x00dev, 84, 0x99);
 }
 
 static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
@@ -3993,6 +3995,11 @@ static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 
 	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
+
+	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860D))
+		rt2800_bbp_write(rt2x00dev, 84, 0x19);
+	else
+		rt2800_bbp_write(rt2x00dev, 84, 0x99);
 }
 
 static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
@@ -4012,6 +4019,8 @@ static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 
 	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
+
+	rt2800_bbp_write(rt2x00dev, 84, 0x99);
 }
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
@@ -4042,6 +4051,8 @@ static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 
 	rt2800_bbp_write(rt2x00dev, 83, 0x7a);
+
+	rt2800_bbp_write(rt2x00dev, 84, 0x9a);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -4074,6 +4085,8 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 
 	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
+
+	rt2800_bbp_write(rt2x00dev, 84, 0x99);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -4093,6 +4106,8 @@ static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 
 	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
+
+	rt2800_bbp_write(rt2x00dev, 84, 0x99);
 }
 
 static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
@@ -4114,6 +4129,8 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 
 	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
+
+	rt2800_bbp_write(rt2x00dev, 84, 0x99);
 }
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
@@ -4143,6 +4160,8 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 
 	rt2800_bbp_write(rt2x00dev, 83, 0x7a);
+
+	rt2800_bbp_write(rt2x00dev, 84, 0x9a);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4261,15 +4280,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860D))
-		rt2800_bbp_write(rt2x00dev, 84, 0x19);
-	else if (rt2x00_rt(rt2x00dev, RT3290) ||
-		 rt2x00_rt(rt2x00dev, RT5390) ||
-		 rt2x00_rt(rt2x00dev, RT5392))
-		rt2800_bbp_write(rt2x00dev, 84, 0x9a);
-	else
-		rt2800_bbp_write(rt2x00dev, 84, 0x99);
-
 	if (rt2x00_rt(rt2x00dev, RT3290) ||
 	    rt2x00_rt(rt2x00dev, RT3352) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
-- 
1.7.4.4

