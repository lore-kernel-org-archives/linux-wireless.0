Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:29210 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab3ERMCe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:34 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:32 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 06/32] rt2800: initialize BBP_R31 on proper subroutines
Date: Sat, 18 May 2013 14:03:29 +0200
Message-Id: <1368878635-4455-7-git-send-email-stf_xl@wp.pl> (sfid-20130518_140238_384653_30827B90)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 7c5b25d..84c7d4e 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3955,6 +3955,7 @@ static void rt2800_init_bbp_early(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_bbp_write(rt2x00dev, 31, 0x08);
 }
 
 static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
@@ -3968,12 +3969,16 @@ static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
+
+	rt2800_bbp_write(rt2x00dev, 31, 0x08);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_bbp_write(rt2x00dev, 3, 0x00);
 	rt2800_bbp_write(rt2x00dev, 4, 0x50);
+
+	rt2800_bbp_write(rt2x00dev, 31, 0x08);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -3982,11 +3987,14 @@ static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_bbp_write(rt2x00dev, 31, 0x08);
 }
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
+
+	rt2800_bbp_write(rt2x00dev, 31, 0x08);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4105,14 +4113,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2800_is_305x_soc(rt2x00dev) ||
-	    rt2x00_rt(rt2x00dev, RT3290) ||
-	    rt2x00_rt(rt2x00dev, RT3352) ||
-	    rt2x00_rt(rt2x00dev, RT3572) ||
-	    rt2x00_rt(rt2x00dev, RT5390) ||
-	    rt2x00_rt(rt2x00dev, RT5392))
-		rt2800_bbp_write(rt2x00dev, 31, 0x08);
-
 	if (rt2x00_rt(rt2x00dev, RT3352))
 		rt2800_bbp_write(rt2x00dev, 47, 0x48);
 
-- 
1.7.4.4

