Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47987 "EHLO ds10.mine.nu"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757367AbYGTQbq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 12:31:46 -0400
Message-ID: <48836863.7090008@openwrt.org> (sfid-20080720_183150_594225_A47F4EB0)
Date: Sun, 20 Jul 2008 18:31:31 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH] ath9k: fix another endianness issue
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DMA descriptors must always be accessed in native endianness.
With this patch and my previous series, Atheros AR9160 now
works for me in STA mode (tested on an IXP4xx board, big-endian)

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -168,7 +168,7 @@
  			__func__, txq->axq_qnum,
  			ito64(bf->bf_daddr), bf->bf_desc);
  	} else {
-		*txq->axq_link = cpu_to_le32(bf->bf_daddr);
+		*txq->axq_link = bf->bf_daddr;
  		DPRINTF(sc, ATH_DEBUG_XMIT, "%s: link[%u] (%p)=%llx (%p)\n",
  			__func__,
  			txq->axq_qnum, txq->axq_link,

