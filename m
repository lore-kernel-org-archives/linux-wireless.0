Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57786 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYFXKX3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 06:23:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix PIO skb clobber
Date: Tue, 24 Jun 2008 12:22:05 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200806241222.05767.mb@bu3sch.de> (sfid-20080624_122333_814165_46B966C2)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a clobber of the skb that was introduced by the
tx_control->cb conversion patches.
This bug causes a crash when the skb destructor is invoked. That happens
on skb_orphan or skb_kfree.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please apply this bugfix to 2.6.27, as the bug is not present in 2.6.26.


Index: wireless-testing/drivers/net/wireless/b43/pio.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/pio.c	2008-05-23 23:41:06.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/pio.c	2008-06-24 12:10:12.000000000 +0200
@@ -583,13 +583,13 @@ void b43_pio_handle_txstatus(struct b43_
 	if (unlikely(!q))
 		return;
 	B43_WARN_ON(!pack);
 
 	spin_lock(&q->lock); /* IRQs are already disabled. */
 
-	info = (void *)pack->skb;
+	info = IEEE80211_SKB_CB(pack->skb);
 	memset(&info->status, 0, sizeof(info->status));
 
 	b43_fill_txstatus_report(info, status);
 
 	total_len = pack->skb->len + b43_txhdr_size(dev);
 	total_len = roundup(total_len, 4);
