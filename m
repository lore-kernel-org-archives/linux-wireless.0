Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45679 "EHLO
        mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934266AbcISLKZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 07:10:25 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 5/9] brcmfmac: remove worker from .ndo_set_mac_address() callback
Date: Mon, 19 Sep 2016 12:09:55 +0100
Message-Id: <1474283399-14385-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160919_131045_251351_DE365163)
In-Reply-To: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1474283399-14385-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As it turns out there is no need to use a worker for the callback
because it is not called from atomic context.

Reported-by: Dan Williams <dcbw@redhat.com>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 39 ++++++++--------------
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 --
 2 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 8d16f02..77c4180 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -136,27 +136,6 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 			  err);
 }
 
-static void
-_brcmf_set_mac_address(struct work_struct *work)
-{
-	struct brcmf_if *ifp;
-	s32 err;
-
-	ifp = container_of(work, struct brcmf_if, setmacaddr_work);
-
-	brcmf_dbg(TRACE, "Enter, bsscfgidx=%d\n", ifp->bsscfgidx);
-
-	err = brcmf_fil_iovar_data_set(ifp, "cur_etheraddr", ifp->mac_addr,
-				       ETH_ALEN);
-	if (err < 0) {
-		brcmf_err("Setting cur_etheraddr failed, %d\n", err);
-	} else {
-		brcmf_dbg(TRACE, "MAC address updated to %pM\n",
-			  ifp->mac_addr);
-		memcpy(ifp->ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
-	}
-}
-
 #if IS_ENABLED(CONFIG_IPV6)
 static void _brcmf_update_ndtable(struct work_struct *work)
 {
@@ -190,10 +169,20 @@ static int brcmf_netdev_set_mac_address(struct net_device *ndev, void *addr)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct sockaddr *sa = (struct sockaddr *)addr;
+	int err;
 
-	memcpy(&ifp->mac_addr, sa->sa_data, ETH_ALEN);
-	schedule_work(&ifp->setmacaddr_work);
-	return 0;
+	brcmf_dbg(TRACE, "Enter, bsscfgidx=%d\n", ifp->bsscfgidx);
+
+	err = brcmf_fil_iovar_data_set(ifp, "cur_etheraddr", sa->sa_data,
+				       ETH_ALEN);
+	if (err < 0) {
+		brcmf_err("Setting cur_etheraddr failed, %d\n", err);
+	} else {
+		brcmf_dbg(TRACE, "updated to %pM\n", sa->sa_data);
+		memcpy(ifp->mac_addr, sa->sa_data, ETH_ALEN);
+		memcpy(ifp->ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
+	}
+	return err;
 }
 
 static void brcmf_netdev_set_multicast_list(struct net_device *ndev)
@@ -525,7 +514,6 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 	/* set the mac address */
 	memcpy(ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
 
-	INIT_WORK(&ifp->setmacaddr_work, _brcmf_set_mac_address);
 	INIT_WORK(&ifp->multicast_work, _brcmf_set_multicast_list);
 	INIT_WORK(&ifp->ndoffload_work, _brcmf_update_ndtable);
 
@@ -730,7 +718,6 @@ static void brcmf_del_if(struct brcmf_pub *drvr, s32 bsscfgidx,
 		}
 
 		if (ifp->ndev->netdev_ops == &brcmf_netdev_ops_pri) {
-			cancel_work_sync(&ifp->setmacaddr_work);
 			cancel_work_sync(&ifp->multicast_work);
 			cancel_work_sync(&ifp->ndoffload_work);
 		}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 8fa34ca..8a810bb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -176,7 +176,6 @@ enum brcmf_netif_stop_reason {
  * @vif: points to cfg80211 specific interface information.
  * @ndev: associated network device.
  * @stats: interface specific network statistics.
- * @setmacaddr_work: worker object for setting mac address.
  * @multicast_work: worker object for multicast provisioning.
  * @ndoffload_work: worker object for neighbor discovery offload configuration.
  * @fws_desc: interface specific firmware-signalling descriptor.
@@ -193,7 +192,6 @@ struct brcmf_if {
 	struct brcmf_cfg80211_vif *vif;
 	struct net_device *ndev;
 	struct net_device_stats stats;
-	struct work_struct setmacaddr_work;
 	struct work_struct multicast_work;
 	struct work_struct ndoffload_work;
 	struct brcmf_fws_mac_descriptor *fws_desc;
-- 
1.9.1
