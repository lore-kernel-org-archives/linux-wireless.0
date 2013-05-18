Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:23434 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3ERMCk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:40 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:38 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 09/32] rt2800: initialize BBP_R68 on proper subroutines
Date: Sat, 18 May 2013 14:03:32 +0200
Message-Id: <1368878635-4455-10-git-send-email-stf_xl@wp.pl> (sfid-20130518_140243_630840_D23E7216)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 0265cf7..3c404b2 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3981,6 +3981,8 @@ static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
+
+	rt2800_bbp_write(rt2x00dev, 68, 0x0b);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -3994,6 +3996,8 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
+
+	rt2800_bbp_write(rt2x00dev, 68, 0x0b);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -4018,6 +4022,8 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
+
+	rt2800_bbp_write(rt2x00dev, 68, 0x0b);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4136,12 +4142,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3290) ||
-	    rt2x00_rt(rt2x00dev, RT3352) ||
-	    rt2x00_rt(rt2x00dev, RT5390) ||
-	    rt2x00_rt(rt2x00dev, RT5392))
-		rt2800_bbp_write(rt2x00dev, 68, 0x0b);
-
 	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C)) {
 		rt2800_bbp_write(rt2x00dev, 69, 0x16);
 		rt2800_bbp_write(rt2x00dev, 73, 0x12);
-- 
1.7.4.4

