Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.150.24]:32382 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751602AbdGRU6B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 16:58:01 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 9990449CC4
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jul 2017 15:37:13 -0500 (CDT)
Date: Tue, 18 Jul 2017 15:37:11 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] wireless: airo: remove unnecessary static in writerids()
Message-ID: <20170718203711.GA30044@embeddedgus> (sfid-20170718_225804_602404_B7C73BE8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary static on local function pointer _writer_.
Such pointer is initialized before being used, on every
execution path throughout the function. The static has no
benefit and, removing it reduces the object file size.

This issue was detected using Coccinelle and the following semantic patch:

@bad exists@
position p;
identifier x;
type T;
@@

static T x@p;
...
x = <+...x...+>

@@
identifier x;
expression e;
type T;
position p != bad.p;
@@

-static
 T x@p;
 ... when != x
     when strict
?x = e;

In the following log you can see a significant difference in the object
file size. This log is the output of the size command, before and after
the code change:

before:
   text    data     bss     dec     hex filename
 113797   19152    1216  134165   20c15 drivers/net/wireless/cisco/airo.o

after:
   text	   data	    bss	    dec	    hex	filename
 113881	  19096	   1152	 134129	  20bf1	drivers/net/wireless/cisco/airo.o

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/cisco/airo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 84143a0..1066d84 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -7837,7 +7837,7 @@ static int writerids(struct net_device *dev, aironet_ioctl *comp) {
 	struct airo_info *ai = dev->ml_priv;
 	int  ridcode;
         int  enabled;
-	static int (* writer)(struct airo_info *, u16 rid, const void *, int, int);
+	int (*writer)(struct airo_info *, u16 rid, const void *, int, int);
 	unsigned char *iobuf;
 
 	/* Only super-user can write RIDs */
-- 
2.5.0
