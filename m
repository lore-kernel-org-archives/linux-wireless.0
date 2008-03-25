Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:58443 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbYCYHVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 03:21:22 -0400
Date: Tue, 25 Mar 2008 16:21:08 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] PS3: gelic: Add support for separate cipher selection
Cc: cbe-oss-dev@ozlabs.org, geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Message-Id: <20080325152404.0F15.40F06B3A@sm.sony.co.jp> (sfid-20080325_072126_222807_6239956D)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From version 2.20 of the PS3 system software, the hypervisor allows the guest OSes
to specify separate cipher for group and pairwise.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 drivers/net/ps3_gelic_wireless.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -87,7 +87,7 @@ static inline int wpa2_capable(void)
 
 static inline int precise_ie(void)
 {
-	return 0; /* FIXME */
+	return (0 <= ps3_compare_firmware_version(2, 2, 0));
 }
 /*
  * post_eurus_cmd helpers
-- 
Masakazu Mokuno

