Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:59150 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757120Ab2FUONh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:13:37 -0400
Received: by lbbgo11 with SMTP id go11so2449000lbb.31
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 07:13:34 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 12/12] wl18xx: use %zu for size_t arguments in printk calls
Date: Thu, 21 Jun 2012 17:13:11 +0300
Message-Id: <1340287991-15241-13-git-send-email-coelho@ti.com> (sfid-20120621_161416_080207_338784F6)
In-Reply-To: <1340287991-15241-1-git-send-email-coelho@ti.com>
References: <1340287991-15241-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After 934b9d1e (wl18xx: avoid some -Wformat warnings) there was still
a warning with (at least) ARM gcc version 4.4.1:

drivers/net/wireless/ti/wl18xx/main.c: In function 'wl18xx_conf_init':
drivers/net/wireless/ti/wl18xx/main.c:1026: warning: format '%ld' expects type 'long int', but argument 2 has type 'unsigned int'

Fix this by using %zu for the both formats, since the fw->size and the
macro (derived from sizeof()) are size_t.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 2c0f51b..271ff81 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1023,8 +1023,8 @@ static int wl18xx_conf_init(struct wl1271 *wl, struct device *dev)
 	}
 
 	if (fw->size != WL18XX_CONF_SIZE) {
-		wl1271_error("configuration binary file size is wrong, "
-			     "expected %d got %d", WL18XX_CONF_SIZE, fw->size);
+		wl1271_error("configuration binary file size is wrong, expected %zu got %zu",
+			     WL18XX_CONF_SIZE, fw->size);
 		ret = -EINVAL;
 		goto out;
 	}
-- 
1.7.10

