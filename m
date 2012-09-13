Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3323 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab2IMTMZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 15:12:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/10] brcmfmac: absorb brcmf_sendpkt into
 brcmf_netdev_start_xmit
Date: Thu, 13 Sep 2012 21:11:57 +0200
Message-ID: <1347563526-12513-2-git-send-email-arend@broadcom.com> (sfid-20120913_211233_208968_246D09FB)
In-Reply-To: <1347563526-12513-1-git-send-email-arend@broadcom.com>
References: <1347563526-12513-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

brcmf_sendpkt only called by brcmf_netdev_start_xmit now. Absorb it
to increase readability.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    4 --
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   41 ++++++++------------
 2 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 4766d9f..55e489d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -682,10 +682,6 @@ extern int brcmf_c_host_event(struct brcmf_pub *drvr, int *idx,
 
 extern void brcmf_del_if(struct brcmf_pub *drvr, int ifidx);
 
-/* Send packet to dongle via data channel */
-extern int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx,\
-			 struct sk_buff *pkt);
-
 extern void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg);
 extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg,
 					     int enable, int master_mode);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index b08f347..d7c76ce 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -272,30 +272,6 @@ static void brcmf_netdev_set_multicast_list(struct net_device *ndev)
 	schedule_work(&drvr->multicast_work);
 }
 
-int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx, struct sk_buff *pktbuf)
-{
-	/* Reject if down */
-	if (!drvr->bus_if->drvr_up || (drvr->bus_if->state == BRCMF_BUS_DOWN))
-		return -ENODEV;
-
-	/* Update multicast statistic */
-	if (pktbuf->len >= ETH_ALEN) {
-		u8 *pktdata = (u8 *) (pktbuf->data);
-		struct ethhdr *eh = (struct ethhdr *)pktdata;
-
-		if (is_multicast_ether_addr(eh->h_dest))
-			drvr->tx_multicast++;
-		if (ntohs(eh->h_proto) == ETH_P_PAE)
-			atomic_inc(&drvr->pend_8021x_cnt);
-	}
-
-	/* If the protocol uses a data header, apply it */
-	brcmf_proto_hdrpush(drvr, ifidx, pktbuf);
-
-	/* Use bus module to send data frame */
-	return drvr->bus_if->brcmf_bus_txdata(drvr->dev, pktbuf);
-}
-
 static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	int ret;
@@ -338,7 +314,22 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		}
 	}
 
-	ret = brcmf_sendpkt(drvr, ifp->idx, skb);
+	/* Update multicast statistic */
+	if (skb->len >= ETH_ALEN) {
+		u8 *pktdata = (u8 *)(skb->data);
+		struct ethhdr *eh = (struct ethhdr *)pktdata;
+
+		if (is_multicast_ether_addr(eh->h_dest))
+			drvr->tx_multicast++;
+		if (ntohs(eh->h_proto) == ETH_P_PAE)
+			atomic_inc(&drvr->pend_8021x_cnt);
+	}
+
+	/* If the protocol uses a data header, apply it */
+	brcmf_proto_hdrpush(drvr, ifp->idx, skb);
+
+	/* Use bus module to send data frame */
+	ret =  drvr->bus_if->brcmf_bus_txdata(drvr->dev, skb);
 
 done:
 	if (ret)
-- 
1.7.9.5


