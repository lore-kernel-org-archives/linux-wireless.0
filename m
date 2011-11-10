Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4681 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285Ab1KJTa7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:59 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/19] brcm80211: util: remove pointer traversal from
 brcmu_pkt_buf_free_skb
Date: Thu, 10 Nov 2011 20:30:30 +0100
Message-ID: <1320953434-16859-17-git-send-email-arend@broadcom.com> (sfid-20111110_203116_291356_B5D718DC)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmu_pkt_buf_free_skb() was following the next pointer
to free all linked packets. However, it is only called with unlinked
packets so this can be removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmutil/utils.c |   33 +++++++---------------
 1 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index 3a92f72..b7537f7 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -41,28 +41,17 @@ EXPORT_SYMBOL(brcmu_pkt_buf_get_skb);
 /* Free the driver packet. Free the tag if present */
 void brcmu_pkt_buf_free_skb(struct sk_buff *skb)
 {
-	struct sk_buff *nskb;
-	int nest = 0;
-
-	/* perversion: we use skb->next to chain multi-skb packets */
-	while (skb) {
-		nskb = skb->next;
-		skb->next = NULL;
-
-		if (skb->destructor)
-			/* cannot kfree_skb() on hard IRQ (net/core/skbuff.c) if
-			 * destructor exists
-			 */
-			dev_kfree_skb_any(skb);
-		else
-			/* can free immediately (even in_irq()) if destructor
-			 * does not exist
-			 */
-			dev_kfree_skb(skb);
-
-		nest++;
-		skb = nskb;
-	}
+	WARN_ON(skb->next);
+	if (skb->destructor)
+		/* cannot kfree_skb() on hard IRQ (net/core/skbuff.c) if
+		 * destructor exists
+		 */
+		dev_kfree_skb_any(skb);
+	else
+		/* can free immediately (even in_irq()) if destructor
+		 * does not exist
+		 */
+		dev_kfree_skb(skb);
 }
 EXPORT_SYMBOL(brcmu_pkt_buf_free_skb);
 
-- 
1.7.5.4


