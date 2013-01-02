Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3939 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab3ABOXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:08 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/18] brcmfmac: cleanup netdev transmit callback
Date: Wed, 2 Jan 2013 15:22:46 +0100
Message-ID: <1357136572-18273-14-git-send-email-arend@broadcom.com> (sfid-20130102_155321_858915_FE4E3697)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The header of the ethernet packet is processed conditionally, but
the check is wrong as it checks skb length is at least ETH_ALEN. It
should check it is at least sizeof struct ethhdr instead.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   22 ++++++++++++--------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index a1ca691..9ca7411 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -165,6 +165,7 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	int ret;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
+	struct ethhdr *eh;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -202,17 +203,20 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		}
 	}
 
-	/* Update multicast statistic */
-	if (skb->len >= ETH_ALEN) {
-		u8 *pktdata = (u8 *)(skb->data);
-		struct ethhdr *eh = (struct ethhdr *)pktdata;
-
-		if (is_multicast_ether_addr(eh->h_dest))
-			drvr->tx_multicast++;
-		if (ntohs(eh->h_proto) == ETH_P_PAE)
-			atomic_inc(&drvr->pend_8021x_cnt);
+	/* validate length for ether packet */
+	if (skb->len < sizeof(*eh)) {
+		ret = -EINVAL;
+		dev_kfree_skb(skb);
+		goto done;
 	}
 
+	/* handle ethernet header */
+	eh = (struct ethhdr *)(skb->data);
+	if (is_multicast_ether_addr(eh->h_dest))
+		drvr->tx_multicast++;
+	if (ntohs(eh->h_proto) == ETH_P_PAE)
+		atomic_inc(&drvr->pend_8021x_cnt);
+
 	/* If the protocol uses a data header, apply it */
 	brcmf_proto_hdrpush(drvr, ifp->idx, skb);
 
-- 
1.7.10.4


