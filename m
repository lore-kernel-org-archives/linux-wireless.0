Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.217.174]:61010 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZBYMfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 07:35:37 -0500
Received: by gxk22 with SMTP id 22so165gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2009 04:35:35 -0800 (PST)
Message-ID: <49A53B16.8010605@gmail.com> (sfid-20090225_133544_707376_B70880EE)
Date: Wed, 25 Feb 2009 13:35:34 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: jt@hpl.hp.com
CC: linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] wireless, wavelan: spin off by 1
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

spin can reach -1 after the loop, so 0 is still success.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/wavelan_cs.c b/drivers/net/wireless/wavelan_cs.c
index de717f8..1565a0a 100644
--- a/drivers/net/wireless/wavelan_cs.c
+++ b/drivers/net/wireless/wavelan_cs.c
@@ -838,9 +838,8 @@ wv_82593_cmd(struct net_device *	dev,
     }
   while(((status & SR3_EXEC_STATE_MASK) != SR3_EXEC_IDLE) && (spin-- > 0));
 
-  /* If the interrupt hasn't be posted */
-  if(spin <= 0)
-    {
+  /* If the interrupt hasn't been posted */
+  if (spin < 0) {
 #ifdef DEBUG_INTERRUPT_ERROR
       printk(KERN_INFO "wv_82593_cmd: %s timeout (previous command), status 0x%02x\n",
 	     str, status);
