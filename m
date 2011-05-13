Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3390 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab1EMKAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/32] staging: brcm80211: got rid of #ifdef __mips__ by
 new dma_spin_for_len()
Date: Fri, 13 May 2011 11:59:25 +0200
Message-ID: <1305280792-9475-5-git-send-email-arend@broadcom.com> (sfid-20110513_120011_950058_6691F044)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/hnddma.c |   11 +----------
 drivers/staging/brcm80211/include/hnddma.h  |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/hnddma.c b/drivers/staging/brcm80211/brcmsmac/hnddma.c
index 33432e6..5f11147 100644
--- a/drivers/staging/brcm80211/brcmsmac/hnddma.c
+++ b/drivers/staging/brcm80211/brcmsmac/hnddma.c
@@ -721,16 +721,7 @@ static void *_dma_rx(dma_info_t *di)
 
 	len = le16_to_cpu(*(u16 *) (head->data));
 	DMA_TRACE(("%s: dma_rx len %d\n", di->name, len));
-
-#if defined(__mips__)
-#define OSL_UNCACHED(va)        ((void *)KSEG1ADDR((va)))
-	if (!len) {
-		while (!(len = *(u16 *) OSL_UNCACHED(head->data)))
-			udelay(1);
-
-		*(u16 *) (head->data) = cpu_to_le16((u16) len);
-	}
-#endif				/* defined(__mips__) */
+	dma_spin_for_len(len, head);
 
 	/* set actual length */
 	pkt_len = min((di->rxoffset + len), di->rxbufsize);
diff --git a/drivers/staging/brcm80211/include/hnddma.h b/drivers/staging/brcm80211/include/hnddma.h
index 5d079e7..fbbcb9b 100644
--- a/drivers/staging/brcm80211/include/hnddma.h
+++ b/drivers/staging/brcm80211/include/hnddma.h
@@ -204,4 +204,23 @@ extern const di_fcn_t dma64proc;
 extern uint dma_addrwidth(si_t *sih, void *dmaregs);
 void dma_walk_packets(struct hnddma_pub *dmah, void (*callback_fnc)
 		      (void *pkt, void *arg_a), void *arg_a);
+
+/*
+ * DMA(Bug) on some chips seems to declare that the packet is ready, but the
+ * packet length is not updated yet (by DMA) on the expected time.
+ * Workaround is to hold processor till DMA updates the length, and stay off
+ * the bus to allow DMA update the length in buffer
+ */
+static inline void dma_spin_for_len(uint len, struct sk_buff *head)
+{
+#if defined(__mips__)
+	if (!len) {
+		while (!(len = *(u16 *) KSEG1ADDR(head->data)))
+			udelay(1);
+
+		*(u16 *) (head->data) = cpu_to_le16((u16) len);
+	}
+#endif				/* defined(__mips__) */
+}
+
 #endif				/* _hnddma_h_ */
-- 
1.7.4.1


