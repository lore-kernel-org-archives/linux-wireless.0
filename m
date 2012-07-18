Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:53764 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab2GRMNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 08:13:53 -0400
Received: by lbom4 with SMTP id m4so4559042lbo.16
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jul 2012 05:13:50 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 05/14] wl18xx: fix bogus compile warning on cc config option
Date: Wed, 18 Jul 2012 15:13:24 +0300
Message-Id: <1342613613-917-6-git-send-email-coelho@ti.com> (sfid-20120718_141359_428790_8A510E68)
In-Reply-To: <1342613613-917-1-git-send-email-coelho@ti.com>
References: <1342613613-917-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Initialize val to 0, to remove the following warning with
CONFIG_CC_OPTIMIZE_FOR_SIZE. The compiler used was gcc 4.4.1
(Sourcery G++ Lite 2010q1-202).

drivers/net/wireless/ti/wl18xx/io.c: In function 'wl18xx_top_reg_read':
drivers/net/wireless/ti/wl18xx/io.c:57: warning: 'val' may be used uninitialized in this function

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/io.c b/drivers/net/wireless/ti/wl18xx/io.c
index 0c06ccf..f0abf3e 100644
--- a/drivers/net/wireless/ti/wl18xx/io.c
+++ b/drivers/net/wireless/ti/wl18xx/io.c
@@ -54,7 +54,7 @@ out:
 
 int wl18xx_top_reg_read(struct wl1271 *wl, int addr, u16 *out)
 {
-	u32 val;
+	u32 val = 0;
 	int ret;
 
 	if (WARN_ON(addr % 2))
-- 
1.7.10.4

