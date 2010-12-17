Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:35285 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab0LQWS0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 17:18:26 -0500
Received: from math.ut.ee (math.ut.ee [193.40.36.2])
	by smtp1.it.da.ut.ee (Postfix) with ESMTP id B76BA6E4E05
	for <linux-wireless@vger.kernel.org>; Sat, 18 Dec 2010 00:18:24 +0200 (EET)
Received: from localhost (localhost [127.0.0.1])
	by math.ut.ee (Postfix) with ESMTP id ADCC2DAF80
	for <linux-wireless@vger.kernel.org>; Sat, 18 Dec 2010 00:18:24 +0200 (EET)
Date: Sat, 18 Dec 2010 00:18:24 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] orinoco_cs: fix too early irq request
Message-ID: <alpine.SOC.1.00.1012180014390.26257@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

orinoco_cs requests its irq too early. This results in irq coming in 
right afrer request_irq and before initializing other data structures, 
resulting in NULL pointer dereference on module load.

Fix it by moving request_irq after other initialization tasks.

Tested to work with Orinoco Gold PCMCIA card.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index 71b3d68..47fc408 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -151,10 +151,6 @@ orinoco_cs_config(struct pcmcia_device *link)
 		goto failed;
 	}
 
-	ret = pcmcia_request_irq(link, orinoco_interrupt);
-	if (ret)
-		goto failed;
-
 	/* We initialize the hermes structure before completing PCMCIA
 	 * configuration just in case the interrupt handler gets
 	 * called. */
@@ -182,6 +178,10 @@ orinoco_cs_config(struct pcmcia_device *link)
 		goto failed;
 	}
 
+	ret = pcmcia_request_irq(link, orinoco_interrupt);
+	if (ret)
+		goto failed;
+
 	return 0;
 
  failed:

-- 
Meelis Roos (mroos@linux.ee)
