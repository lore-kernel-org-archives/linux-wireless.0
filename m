Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4302 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966751Ab3DQT0U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 15:26:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/10] brcmutil: simplify brcmu_pkt_free_skb()
Date: Wed, 17 Apr 2013 21:25:52 +0200
Message-ID: <1366226758-20641-5-git-send-email-arend@broadcom.com> (sfid-20130417_212628_686076_C6968C43)
In-Reply-To: <1366226758-20641-1-git-send-email-arend@broadcom.com>
References: <1366226758-20641-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmu_pkt_free_skb() use skb->destructor to decide
how the sk_buff should be freed. However, when running AP mode
with iptables configured this results in a kernel warning.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmutil/utils.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index bf5e50f..0f7e1c7 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -45,17 +45,9 @@ void brcmu_pkt_buf_free_skb(struct sk_buff *skb)
 {
 	if (!skb)
 		return;
+
 	WARN_ON(skb->next);
-	if (skb->destructor)
-		/* cannot kfree_skb() on hard IRQ (net/core/skbuff.c) if
-		 * destructor exists
-		 */
-		dev_kfree_skb_any(skb);
-	else
-		/* can free immediately (even in_irq()) if destructor
-		 * does not exist
-		 */
-		dev_kfree_skb(skb);
+	dev_kfree_skb_any(skb);
 }
 EXPORT_SYMBOL(brcmu_pkt_buf_free_skb);
 
-- 
1.7.10.4


