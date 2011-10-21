Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3187 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769Ab1JUNzi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 09:55:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 16/17] brcm80211: fmac: remove state from brcmf_if in
 fullmac
Date: Fri, 21 Oct 2011 15:55:18 +0200
Message-ID: <1319205319-16891-17-git-send-email-arend@broadcom.com> (sfid-20111021_155546_973042_0002B0AE)
In-Reply-To: <1319205319-16891-1-git-send-email-arend@broadcom.com>
References: <1319205319-16891-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

The usage of state decrease readability. Optimize the code flow to
get rid of it

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 -
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   10 ++--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index a96a91f..6da519e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -122,7 +122,6 @@
 
 /* For supporting multiple interfaces */
 #define BRCMF_MAX_IFS	16
-#define BRCMF_DEL_IF	-0xe
 
 #define DOT11_BSSTYPE_ANY			2
 #define DOT11_MAX_DEFAULT_KEYS	4
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 394577a..719fd93 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -58,7 +58,6 @@ struct brcmf_if {
 	struct net_device *ndev;
 	struct net_device_stats stats;
 	int idx;		/* iface idx in dongle */
-	int state;		/* interface state */
 	u8 mac_addr[ETH_ALEN];	/* assigned MAC address */
 };
 
@@ -456,12 +455,10 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx, struct sk_buff *skb,
 					  skb_mac_header(skb),
 					  &event, &data);
 
-		if (drvr_priv->iflist[ifidx] &&
-		    !drvr_priv->iflist[ifidx]->state)
+		if (drvr_priv->iflist[ifidx]) {
 			ifp = drvr_priv->iflist[ifidx];
-
-		if (ifp->ndev)
 			ifp->ndev->last_rx = jiffies;
+		}
 
 		drvr->dstats.rx_bytes += skb->len;
 		drvr->rx_packets++;	/* Local count */
@@ -896,7 +893,6 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, char *name, u8 *mac_addr)
 	ifp->ndev = ndev;
 	ifp->info = drvr_priv;
 	drvr_priv->iflist[ifidx] = ifp;
-	ifp->state = BRCMF_E_IF_ADD;
 	ifp->idx = ifidx;
 	if (mac_addr != NULL)
 		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
@@ -910,7 +906,6 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, char *name, u8 *mac_addr)
 
 	brcmf_dbg(TRACE, " ==== pid:%x, net_device for if:%s created ===\n",
 		  current->pid, ifp->ndev->name);
-	ifp->state = 0;
 
 	return 0;
 }
@@ -926,7 +921,6 @@ void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx)
 		brcmf_dbg(ERROR, "Null interface\n");
 		return;
 	}
-	ifp->state = BRCMF_E_IF_DEL;
 	if (ifp->ndev) {
 		if (ifidx == 0) {
 			if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
-- 
1.7.4.1


