Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:39009 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbbHZUPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 16:15:19 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 12/12] brcmfmac: introduce brcmf_net_detach() function
Date: Wed, 26 Aug 2015 22:15:04 +0200
Message-ID: <1440620104-2715-13-git-send-email-arend@broadcom.com> (sfid-20150826_221530_896390_1EA5E566)
In-Reply-To: <1440620104-2715-1-git-send-email-arend@broadcom.com>
References: <1440620104-2715-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of error during brcmf_bus_start() the network interfaces were
freed using free_netdev(). However, the interfaces may have additional
memory allocated which is not freed. The netdev has destructor set to
brcmf_cfg80211_free_netdev() which frees the additional memory if
allocated and call free_netdev(). The brcmf_net_detach() either calls
brcmf_cfg80211_free_netdev() directly or uses unregister_netdev() when
struct net_device::reg_state indicates the netdev was registered.

Reported-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c |  3 ++-
 drivers/net/wireless/brcm80211/brcmfmac/core.c     | 21 +++++++++++++--------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index cee9ff4..600098d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -4747,7 +4747,8 @@ void brcmf_cfg80211_free_netdev(struct net_device *ndev)
 	ifp = netdev_priv(ndev);
 	vif = ifp->vif;
 
-	brcmf_free_vif(vif);
+	if (vif)
+		brcmf_free_vif(vif);
 	free_netdev(ndev);
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 5d81b74..17658b5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -718,8 +718,6 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 	}
 
 	brcmf_dbg(INFO, "%s: Broadcom Dongle Host Driver\n", ndev->name);
-
-	ndev->destructor = brcmf_cfg80211_free_netdev;
 	return 0;
 
 fail:
@@ -729,6 +727,14 @@ fail:
 	return -EBADE;
 }
 
+static void brcmf_net_detach(struct net_device *ndev)
+{
+	if (ndev->reg_state == NETREG_REGISTERED)
+		unregister_netdev(ndev);
+	else
+		brcmf_cfg80211_free_netdev(ndev);
+}
+
 static int brcmf_net_p2p_open(struct net_device *ndev)
 {
 	brcmf_dbg(TRACE, "Enter\n");
@@ -805,8 +811,7 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 			  ifp->ndev->name);
 		if (ifidx) {
 			netif_stop_queue(ifp->ndev);
-			unregister_netdev(ifp->ndev);
-			free_netdev(ifp->ndev);
+			brcmf_net_detach(ifp->ndev);
 			drvr->iflist[bssidx] = NULL;
 		} else {
 			brcmf_err("ignore IF event\n");
@@ -828,6 +833,7 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 		if (!ndev)
 			return ERR_PTR(-ENOMEM);
 
+		ndev->destructor = brcmf_cfg80211_free_netdev;
 		ifp = netdev_priv(ndev);
 		ifp->ndev = ndev;
 		/* store mapping ifidx to bssidx */
@@ -879,8 +885,7 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bssidx)
 			cancel_work_sync(&ifp->setmacaddr_work);
 			cancel_work_sync(&ifp->multicast_work);
 		}
-		/* unregister will take care of freeing it */
-		unregister_netdev(ifp->ndev);
+		brcmf_net_detach(ifp->ndev);
 	}
 }
 
@@ -1056,11 +1061,11 @@ fail:
 			brcmf_fws_deinit(drvr);
 		}
 		if (drvr->iflist[0]) {
-			free_netdev(ifp->ndev);
+			brcmf_net_detach(ifp->ndev);
 			drvr->iflist[0] = NULL;
 		}
 		if (p2p_ifp) {
-			free_netdev(p2p_ifp->ndev);
+			brcmf_net_detach(p2p_ifp->ndev);
 			drvr->iflist[1] = NULL;
 		}
 		return ret;
-- 
1.9.1

