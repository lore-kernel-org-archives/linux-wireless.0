Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:44325 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab3ERMDG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:03:06 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:03:04 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 23/32] rt2800: initialize BBP_R105 on all subroutines (except 5592)
Date: Sat, 18 May 2013 14:03:46 +0200
Message-Id: <1368878635-4455-24-git-send-email-stf_xl@wp.pl> (sfid-20130518_142936_192026_D28D66D8)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 0b3c705..422f6ed 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3981,6 +3981,8 @@ static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 92, 0x00);
 
 	rt2800_bbp_write(rt2x00dev, 103, 0xc0);
+
+	rt2800_bbp_write(rt2x00dev, 105, 0x01);
 }
 
 static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
@@ -4016,6 +4018,8 @@ static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 92, 0x00);
 
 	rt2800_bbp_write(rt2x00dev, 103, 0x00);
+
+	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 }
 
 static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
@@ -4050,6 +4054,8 @@ static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 	else
 		rt2800_bbp_write(rt2x00dev, 103, 0x00);
+
+	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 }
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
@@ -4092,6 +4098,8 @@ static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 
 	rt2800_bbp_write(rt2x00dev, 104, 0x92);
+
+	rt2800_bbp_write(rt2x00dev, 105, 0x1c);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -4138,6 +4146,8 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 
 	rt2800_bbp_write(rt2x00dev, 104, 0x92);
+
+	rt2800_bbp_write(rt2x00dev, 105, 0x34);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -4170,6 +4180,8 @@ static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 	else
 		rt2800_bbp_write(rt2x00dev, 103, 0x00);
+
+	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 }
 
 static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
@@ -4201,6 +4213,8 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 92, 0x00);
 
 	rt2800_bbp_write(rt2x00dev, 103, 0xc0);
+
+	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 }
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
@@ -4250,6 +4264,8 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 
 	rt2800_bbp_write(rt2x00dev, 104, 0x92);
+
+	rt2800_bbp_write(rt2x00dev, 105, 0x3c);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4368,18 +4384,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2800_is_305x_soc(rt2x00dev))
-		rt2800_bbp_write(rt2x00dev, 105, 0x01);
-	else if (rt2x00_rt(rt2x00dev, RT3290))
-		rt2800_bbp_write(rt2x00dev, 105, 0x1c);
-	else if (rt2x00_rt(rt2x00dev, RT3352))
-		rt2800_bbp_write(rt2x00dev, 105, 0x34);
-	else if (rt2x00_rt(rt2x00dev, RT5390) ||
-		 rt2x00_rt(rt2x00dev, RT5392))
-		rt2800_bbp_write(rt2x00dev, 105, 0x3c);
-	else
-		rt2800_bbp_write(rt2x00dev, 105, 0x05);
-
 	if (rt2x00_rt(rt2x00dev, RT3290) ||
 	    rt2x00_rt(rt2x00dev, RT5390))
 		rt2800_bbp_write(rt2x00dev, 106, 0x03);
-- 
1.7.4.4

