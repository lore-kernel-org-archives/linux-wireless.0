Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:22010 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab3ERMCc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:32 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:30 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 05/32] rt2800: move rt2800_bbp4_mac_if_ctrl to proper subroutines
Date: Sat, 18 May 2013 14:03:28 +0200
Message-Id: <1368878635-4455-6-git-send-email-stf_xl@wp.pl> (sfid-20130518_140236_300856_D12A23AC)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 16bdd3d..7c5b25d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3967,6 +3967,7 @@ static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -3985,6 +3986,7 @@ static void rt2800_init_bbp_3572(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 {
+	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4103,11 +4105,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3290) ||
-	    rt2x00_rt(rt2x00dev, RT5390) ||
-	    rt2x00_rt(rt2x00dev, RT5392))
-		rt2800_bbp4_mac_if_ctrl(rt2x00dev);
-
 	if (rt2800_is_305x_soc(rt2x00dev) ||
 	    rt2x00_rt(rt2x00dev, RT3290) ||
 	    rt2x00_rt(rt2x00dev, RT3352) ||
-- 
1.7.4.4

