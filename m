Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753564AbXLRAYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 19:24:06 -0500
Message-Id: <200712180022.lBI0Msm9010078@imap1.linux-foundation.org> (sfid-20071218_002412_142544_6081EDC4)
Subject: [patch (for 2.6.24?) 4/4] bcm43xx_debugfs sscanf fix
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	mb@bu3sch.de
From: akpm@linux-foundation.org
Date: Mon, 17 Dec 2007 16:22:53 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>

ia64:

drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c: In function `tsf_write_file':
drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c:237: warning: long long int format, u64 arg (arg 3)
drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c:237: warning: long long int format, u64 arg (arg 3)

We do not know what type was used to implement u64 and we can never use u64 in
printk(), sscanf(), etc.

Cc: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c~bcm43xx_debugfs-sscanf-fix drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
--- a/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c~bcm43xx_debugfs-sscanf-fix
+++ a/drivers/net/wireless/bcm43xx/bcm43xx_debugfs.c
@@ -219,7 +219,7 @@ static ssize_t tsf_write_file(struct fil
 	ssize_t buf_size;
 	ssize_t res;
 	unsigned long flags;
-	u64 tsf;
+	unsigned long long tsf;
 
 	buf_size = min(count, sizeof (really_big_buffer) - 1);
 	down(&big_buffer_sem);
_
