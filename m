Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1763 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab3FZMUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 08:20:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 9/9] brcmfmac: remove code and comment for older kernel
 support
Date: Wed, 26 Jun 2013 14:20:22 +0200
Message-ID: <1372249222-4858-10-git-send-email-arend@broadcom.com> (sfid-20130626_142046_466898_401D9BBE)
In-Reply-To: <1372249222-4858-1-git-send-email-arend@broadcom.com>
References: <1372249222-4858-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the code of the receive path some code was dealing with how
things were done in older kernels. Not really needed for an
upstream driver.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   29 ++------------------
 1 file changed, 2 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 8c402e7..8e89755 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -281,8 +281,6 @@ void brcmf_txflowblock(struct device *dev, bool state)
 
 void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 {
-	unsigned char *eth;
-	uint len;
 	struct sk_buff *skb, *pnext;
 	struct brcmf_if *ifp;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
@@ -306,33 +304,12 @@ void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 			continue;
 		}
 
-		/* Get the protocol, maintain skb around eth_type_trans()
-		 * The main reason for this hack is for the limitation of
-		 * Linux 2.4 where 'eth_type_trans' uses the
-		 * 'net->hard_header_len'
-		 * to perform skb_pull inside vs ETH_HLEN. Since to avoid
-		 * coping of the packet coming from the network stack to add
-		 * BDC, Hardware header etc, during network interface
-		 * registration
-		 * we set the 'net->hard_header_len' to ETH_HLEN + extra space
-		 * required
-		 * for BDC, Hardware header etc. and not just the ETH_HLEN
-		 */
-		eth = skb->data;
-		len = skb->len;
-
 		skb->dev = ifp->ndev;
 		skb->protocol = eth_type_trans(skb, skb->dev);
 
 		if (skb->pkt_type == PACKET_MULTICAST)
 			ifp->stats.multicast++;
 
-		skb->data = eth;
-		skb->len = len;
-
-		/* Strip header, count, deliver upward */
-		skb_pull(skb, ETH_HLEN);
-
 		/* Process special event packets */
 		brcmf_fweh_process_skb(drvr, skb);
 
@@ -348,10 +325,8 @@ void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 			netif_rx(skb);
 		else
 			/* If the receive is not processed inside an ISR,
-			 * the softirqd must be woken explicitly to service
-			 * the NET_RX_SOFTIRQ.  In 2.6 kernels, this is handled
-			 * by netif_rx_ni(), but in earlier kernels, we need
-			 * to do it manually.
+			 * the softirqd must be woken explicitly to service the
+			 * NET_RX_SOFTIRQ. This is handled by netif_rx_ni().
 			 */
 			netif_rx_ni(skb);
 	}
-- 
1.7.10.4


