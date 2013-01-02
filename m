Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3953 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab3ABOXH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:07 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 16/18] brcmfmac: Return correct error on netdev xmit.
Date: Wed, 2 Jan 2013 15:22:49 +0100
Message-ID: <1357136572-18273-17-git-send-email-arend@broadcom.com> (sfid-20130102_155320_954993_28D67E72)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Netdev xmit routine brcfm_netdev_start_xmit was defined
incorrectly and used wrong return codes. Always eat the
packet and return ok. Remove drvr_up check since it is not
relevant.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   22 +++++++++++---------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 285a70e..d655501 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -160,7 +160,8 @@ static void brcmf_netdev_set_multicast_list(struct net_device *ndev)
 	schedule_work(&ifp->multicast_work);
 }
 
-static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
+					   struct net_device *ndev)
 {
 	int ret;
 	struct brcmf_if *ifp = netdev_priv(ndev);
@@ -169,20 +170,21 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	/* Reject if down */
-	if (!drvr->bus_if->drvr_up ||
-	    (drvr->bus_if->state != BRCMF_BUS_DATA)) {
-		brcmf_err("xmit rejected drvup=%d state=%d\n",
-			  drvr->bus_if->drvr_up,
-			  drvr->bus_if->state);
+	/* Can the device send data? */
+	if (drvr->bus_if->state != BRCMF_BUS_DATA) {
+		brcmf_err("xmit rejected state=%d\n", drvr->bus_if->state);
 		netif_stop_queue(ndev);
-		return -ENODEV;
+		dev_kfree_skb(skb);
+		ret = -ENODEV;
+		goto done;
 	}
 
 	if (!drvr->iflist[ifp->idx]) {
 		brcmf_err("bad ifidx %d\n", ifp->idx);
 		netif_stop_queue(ndev);
-		return -ENODEV;
+		dev_kfree_skb(skb);
+		ret = -ENODEV;
+		goto done;
 	}
 
 	/* Make sure there's enough room for any header */
@@ -230,7 +232,7 @@ done:
 		drvr->bus_if->dstats.tx_packets++;
 
 	/* Return ok: we always eat the packet */
-	return 0;
+	return NETDEV_TX_OK;
 }
 
 void brcmf_txflowblock(struct device *dev, bool state)
-- 
1.7.10.4


