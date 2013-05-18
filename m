Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:51093 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab3ERMDN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:03:13 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:03:11 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 27/32] rt2800: initialize BBP_R134 & BBP_R135 on 53xx subroutine
Date: Sat, 18 May 2013 14:03:50 +0200
Message-Id: <1368878635-4455-28-git-send-email-stf_xl@wp.pl> (sfid-20130518_142936_641898_F832F42B)
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
index 49a4759..96c1aea 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4293,6 +4293,11 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 		WARN_ON(1);
 
 	rt2800_bbp_write(rt2x00dev, 128, 0x12);
+
+	if (rt2x00_rt(rt2x00dev, RT5392)) {
+		rt2800_bbp_write(rt2x00dev, 134, 0xd0);
+		rt2800_bbp_write(rt2x00dev, 135, 0xf6);
+	}
 }
 
 static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
@@ -4411,11 +4416,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT5392)) {
-		rt2800_bbp_write(rt2x00dev, 134, 0xd0);
-		rt2800_bbp_write(rt2x00dev, 135, 0xf6);
-	}
-
 	if (rt2x00_rt(rt2x00dev, RT3352))
 		rt2800_bbp_write(rt2x00dev, 137, 0x0f);
 
-- 
1.7.4.4

