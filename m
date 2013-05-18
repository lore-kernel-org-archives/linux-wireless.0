Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:24156 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515Ab3ERMDA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:03:00 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:58 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 20/32] rt2800: move initialization of BBP_95 & BBP_98 to 53xx subroutine
Date: Sat, 18 May 2013 14:03:43 +0200
Message-Id: <1368878635-4455-21-git-send-email-stf_xl@wp.pl> (sfid-20130518_142936_499962_B3501B06)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 3b3f66b..e08a2d2 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4215,6 +4215,11 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 
 	rt2800_bbp_write(rt2x00dev, 92, 0x02);
+
+	if (rt2x00_rt(rt2x00dev, RT5392)) {
+		rt2800_bbp_write(rt2x00dev, 95, 0x9a);
+		rt2800_bbp_write(rt2x00dev, 98, 0x12);
+	}
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4333,11 +4338,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT5392)) {
-		rt2800_bbp_write(rt2x00dev, 95, 0x9a);
-		rt2800_bbp_write(rt2x00dev, 98, 0x12);
-	}
-
 	if (rt2x00_rt_rev_gte(rt2x00dev, RT3070, REV_RT3070F) ||
 	    rt2x00_rt_rev_gte(rt2x00dev, RT3071, REV_RT3071E) ||
 	    rt2x00_rt_rev_gte(rt2x00dev, RT3090, REV_RT3090E) ||
-- 
1.7.4.4

