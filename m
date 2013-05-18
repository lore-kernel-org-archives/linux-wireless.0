Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:32838 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab3ERMCg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:36 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:34 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 07/32] rt2800: initialize BBP_R47 on 3352 subroutine
Date: Sat, 18 May 2013 14:03:30 +0200
Message-Id: <1368878635-4455-8-git-send-email-stf_xl@wp.pl> (sfid-20130518_140239_486291_9D00326D)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 84c7d4e..d7e6dba 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3979,6 +3979,8 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 4, 0x50);
 
 	rt2800_bbp_write(rt2x00dev, 31, 0x08);
+
+	rt2800_bbp_write(rt2x00dev, 47, 0x48);
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -4113,9 +4115,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3352))
-		rt2800_bbp_write(rt2x00dev, 47, 0x48);
-
 	rt2800_bbp_write(rt2x00dev, 65, 0x2c);
 	rt2800_bbp_write(rt2x00dev, 66, 0x38);
 
-- 
1.7.4.4

