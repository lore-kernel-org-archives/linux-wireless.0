Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:58111 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab3ERMCi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:38 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:36 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 08/32] rt2800: initialize BBP_R65 & BBP_R66 on all subroutines (except 5592)
Date: Sat, 18 May 2013 14:03:31 +0200
Message-Id: <1368878635-4455-9-git-send-email-stf_xl@wp.pl> (sfid-20130518_140241_752184_96AE6F5E)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index d7e6dba..0265cf7 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3956,14 +3956,21 @@ static void rt2800_init_bbp_early(struct rt2x00_dev *rt2x00dev)
 static void rt2800_init_bbp_305x_soc(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_bbp_write(rt2x00dev, 31, 0x08);
+
+	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
+	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 }
 
 static void rt2800_init_bbp_28xx(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
+	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 }
 
 static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
+	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 }
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
@@ -3971,6 +3978,9 @@ static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
 
 	rt2800_bbp_write(rt2x00dev, 31, 0x08);
+
+	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
+	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -3981,15 +3991,23 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 31, 0x08);
 
 	rt2800_bbp_write(rt2x00dev, 47, 0x48);
+
+	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
+	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
+	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 }
 
 static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_bbp_write(rt2x00dev, 31, 0x08);
+
+	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
+	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 }
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
@@ -3997,6 +4015,9 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
 
 	rt2800_bbp_write(rt2x00dev, 31, 0x08);
+
+	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
+	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4115,9 +4136,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
-	rt2800_bbp_write(rt2x00dev, 66, 0x38);
-
 	if (rt2x00_rt(rt2x00dev, RT3290) ||
 	    rt2x00_rt(rt2x00dev, RT3352) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
-- 
1.7.4.4

