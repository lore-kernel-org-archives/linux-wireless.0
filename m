Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:36909 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbYKUOEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 09:04:00 -0500
Received: from [192.168.1.6] (KHP059129241136.ppp-bb.dion.ne.jp [59.129.241.136])
	by mail.holtmann.org (Postfix) with ESMTP id C79938B2E5
	for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 15:03:58 +0100 (CET)
Message-ID: <4926CDEF.4090908@linux.intel.com> (sfid-20081121_150406_993478_90A68C79)
Date: Fri, 21 Nov 2008 16:04:15 +0100
From: Marcel Holtmann <holtmann@linux.intel.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iwlwifi produces "Can not allocate SKB buffers"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

after the DMA issues got fixed, I am still seeing the SKB allocation
errors. So I put a WARN() into the code:

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c
b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 8d2b73e..acd9b12 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -252,10 +252,7 @@ void iwl_rx_allocate(struct iwl_priv *priv)
                 /* Alloc a new receive buffer */
                 rxb->skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
                                 __GFP_NOWARN | GFP_ATOMIC);
-               if (!rxb->skb) {
-                       if (net_ratelimit())
-                               printk(KERN_CRIT DRV_NAME
-                                      ": Can not allocate SKB buffers\n");
+               if (WARN(!rxb->skb, "Can not allocate SKB buffers\n")) {
                         /* We don't reschedule replenish work here -- we
will
                          * call the restock method and if it still needs
                          * more buffers it will schedule replenish */

This allows me to record these issue via kerneloops.org. And here is one 
from my current wireless-testing tree I am running:

http://www.kerneloops.org/raw.php?rawid=104543&msgid=

Regards

Marcel
