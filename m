Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2703 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab1HONei (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/15] staging: brcm80211: restrict MIPS dma bug
 workaround to BCM47XX
Date: Mon, 15 Aug 2011 15:34:26 +0200
Message-ID: <1313415267-5264-15-git-send-email-arend@broadcom.com> (sfid-20110815_153442_731879_67192452)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The inline function dma_spin_for_len() was defined for MIPS platforms
but the problem only occurs with dma of the PCI core in bcm47xx chips.
This patch restricts the function further to BCM47XX platforms only.

Tested on BCM63281.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Tested-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index 134402c..2ce5963 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -100,21 +100,21 @@ void dma_walk_packets(struct dma_pub *dmah, void (*callback_fnc)
 		      (void *pkt, void *arg_a), void *arg_a);
 
 /*
- * DMA(Bug) on some chips seems to declare that the packet is ready, but the
- * packet length is not updated yet (by DMA) on the expected time.
+ * DMA(Bug) on bcm47xx chips seems to declare that the packet is ready, but
+ * the packet length is not updated yet (by DMA) on the expected time.
  * Workaround is to hold processor till DMA updates the length, and stay off
  * the bus to allow DMA update the length in buffer
  */
 static inline void dma_spin_for_len(uint len, struct sk_buff *head)
 {
-#if defined(__mips__)
+#if defined(CONFIG_BCM47XX)
 	if (!len) {
 		while (!(len = *(u16 *) KSEG1ADDR(head->data)))
 			udelay(1);
 
 		*(u16 *) (head->data) = cpu_to_le16((u16) len);
 	}
-#endif				/* defined(__mips__) */
+#endif				/* defined(CONFIG_BCM47XX) */
 }
 
 #endif				/* _BRCM_DMA_H_ */
-- 
1.7.4.1


