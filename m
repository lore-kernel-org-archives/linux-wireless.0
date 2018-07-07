Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46900 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754067AbeGGPdL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Jul 2018 11:33:11 -0400
To: Simon Kelley <simon@thekelleys.org.uk>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] net/wireless/atmel: fix defined but not used warning
Message-ID: <d6ed90e1-c41e-d5b6-c892-ea5e1e6ad7e6@infradead.org> (sfid-20180707_173323_317159_C6538E1E)
Date: Sat, 7 Jul 2018 08:33:09 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix a build warning in drivers/net/wireless/atmel/ when CONFIG_PROC_FS
is not enabled by marking the unused function as __maybe_unused.

../drivers/net/wireless/atmel/atmel.c:1402:12: warning: 'atmel_proc_show' defined but not used [-Wunused-function]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Simon Kelley <simon@thekelleys.org.uk>
Cc: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/atmel/atmel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20180706.orig/drivers/net/wireless/atmel/atmel.c
+++ linux-next-20180706/drivers/net/wireless/atmel/atmel.c
@@ -39,6 +39,7 @@
 
 ******************************************************************************/
 
+#include <linux/compiler.h>
 #include <linux/interrupt.h>
 
 #include <linux/kernel.h>
@@ -1399,7 +1400,7 @@ static int atmel_validate_channel(struct
 	return 0;
 }
 
-static int atmel_proc_show(struct seq_file *m, void *v)
+static int __maybe_unused atmel_proc_show(struct seq_file *m, void *v)
 {
 	struct atmel_private *priv = m->private;
 	int i;
